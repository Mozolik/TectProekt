﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И Организация.Пустая() Тогда
		Организация = УсловияЗакупок.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Склад) Тогда
		
		Склад = УсловияЗакупок.Склад;
		
		СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
		Если СтруктураОтветственного <> Неопределено Тогда
			Принял = СтруктураОтветственного.Ответственный;
			ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья;
		Параметрыобъекта = ПараметрыОбъектаССоглашением();
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Параметрыобъекта, ХозяйственнаяОперацияДоговора);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("УчитыватьГруппыСкладов", Истина);
		ПараметрыОтбора.Вставить("ИсключитьГруппыСкладовДоступныеВЗаказах", Истина);
		
		УсловияЗакупокПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(Партнер, ПараметрыОтбора);
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует временные данных документа
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата					КАК Дата,
	|	&Организация			КАК Организация,
	|	&Склад					КАК Склад,
	|	&Партнер				КАК Партнер,
	|	&Контрагент				КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО			КАК Соглашение,
	|	&Договор				КАК Договор,
	|	&Валюта					КАК Валюта,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
	|	&ХозяйственнаяОперация	КАК ХозяйственнаяОперация,
	|	Ложь					КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ					КАК Подразделение,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ					КАК Менеджер
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика						КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество							КАК Количество,
	|	&Склад												КАК Склад,
	|	ТаблицаТоваров.ДокументПоступления					КАК ДокументПоступления,
	|	ТаблицаТоваров.ДокументРеализации					КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	ТаблицаТоваров.Назначение							КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)		КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК ЦелевоеНалоговоеНазначение,
	|	ТаблицаТоваров.Сумма								КАК СуммаСНДС,
	|	0													КАК СуммаНДС,
	|	0													КАК СуммаВознаграждения,
	|	0													КАК СуммаНДСВознаграждения,
	|	ИСТИНА												КАК ПодбиратьВидыЗапасов
	|	
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки					КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументРеализации			КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов					КАК ВидЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)		КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество					КАК Количество,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)	КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Сумма						КАК СуммаСНДС,
	|	0												КАК СуммаНДС
	|	
	|ПОМЕСТИТЬ ИсходныеВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки						КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура								КАК Номенклатура,
	|	Аналитика.Характеристика							КАК Характеристика,
	|	Аналитика.Серия										КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументРеализации				КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов						КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД							КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество						КАК Количество,
	|	ТаблицаВидыЗапасов.СтавкаНДС						КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС						КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС							КАК СуммаНДС,
	|	0													КАК СуммаВознаграждения,
	|	0													КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК СкладОтгрузки,
	|	&Склад												КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	&ВидыЗапасовУказаныВручную							КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ИсходныеВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	99999												КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика						КАК Характеристика,
	|	ТаблицаТоваров.Серия								КАК Серия,
	|	НЕОПРЕДЕЛЕНО										КАК ДокументРеализации,
	|	ТаблицаТоваров.ВидЗапасов							КАК ВидЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)			КАК НомерГТД,
	|	0													КАК Количество,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)		КАК СтавкаНДС,
	|	0													КАК СуммаСНДС,
	|	0													КАК СуммаНДС,
	|	0													КАК СуммаВознаграждения,
	|	0													КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК СкладОтгрузки,
	|	&Склад												КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	&ВидыЗапасовУказаныВручную							КАК ВидыЗапасовУказаныВручную
	|ИЗ
	|	Документ.ПоступлениеСырьяОтДавальца.Товары КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ИсходныеВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ПО
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры = ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры
	|
	|ГДЕ
	|	ТаблицаТоваров.Ссылка В (ВЫБРАТЬ
	|								ТаблицаТоваров.ДокументПоступления
	|							ИЗ
	|								ТаблицаТоваров КАК ТаблицаТоваров)
	|	И ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка",						Ссылка);
	Запрос.УстановитьПараметр("Дата",						Дата);
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("Склад",						Склад);
	Запрос.УстановитьПараметр("Партнер",					Партнер);
	Запрос.УстановитьПараметр("Контрагент",					Контрагент);
	Запрос.УстановитьПараметр("Договор",					Договор);
	Запрос.УстановитьПараметр("Валюта",						Валюта);
	Запрос.УстановитьПараметр("Менеджер",					Менеджер);
	Запрос.УстановитьПараметр("Подразделение",				Подразделение);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",		ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",	ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров",				ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(Товары.Выгрузить()));
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",			ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(ВидыЗапасов.Выгрузить()));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам",	ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам",					ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Организация, Дата));
	
	Запрос.Выполнить();
	
	Если ВидыЗапасовУказаныВручную Тогда
		ДополнительныеСвойства.Вставить("ИгнорироватьОперативныеОстатки", Истина);
	КонецЕсли;
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

#Область ТчХарактеристикиИКоличество
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(
		ЭтотОбъект,
		МассивНепроверяемыхРеквизитов,
		Отказ);
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);

#КонецОбласти

#Область Серии
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВозвратСырьяДавальцу),
		Отказ,
		МассивНепроверяемыхРеквизитов);

#КонецОбласти

#Область ТчЗаказыДавальцев
	
	Если Не ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
			
			Если Не ЗначениеЗаполнено(Товары[ТекИндекс].ЗаказДавальца) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Заказ давальца"" в строке %НомерСтроки% списка ""Товары""';uk='Не заповнено поле ""Замовлення давальця"" в рядку %НомерСтроки% списку ""Товари""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Товары[ТекИндекс].НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Товары[ТекИндекс].НомерСтроки, "ЗаказДавальца"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

#КонецОбласти

	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;

#Область ИсключимПроверенныеРеквизитыИзДальнейшейПроверки
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

#КонецОбласти
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗакупкиСервер.ПроверитьКорректностьВозвращаемыхТоваров(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Перем СкладПоступления, РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПринятойТаре") Тогда
			ЗаполнитьДокументНаОснованииПринятойТары(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеСырьяОтДавальца") Тогда
		ЗаполнитьДокументНаОснованииПоступления(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказДавальца") Тогда
		ЗаполнитьДокументНаОснованииЗаказа(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		Для Каждого ТекСтрока Из Товары Цикл
			
			Если Не ЗначениеЗаполнено(ТекСтрока.ЗаказДавальца) Тогда
				ТекСтрока.ЗаказДавальца = ЗаказДавальца;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(
		ЭтотОбъект,
		Документы.ВозвратСырьяДавальцу);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
			ХозяйственнаяОперация,
			Склад,
			Подразделение,
			Партнер);
		
		// Если Склад - группа, то для аналитики учета номенклатуры склад берем из ТЧ
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(
			Товары,
			МестаУчета,
			ИменаПолей);
		
		ЗаполнитьВидыЗапасов(Отказ);
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВозвратСырьяДавальцу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запасы
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	// Заказы
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	// Склад
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	// Взаиморасчеты
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	// Тара
	МногооборотнаяТараСервер.ОтразитьПринятуюВозвратнуюТару(ДополнительныеСвойства, Движения, Отказ);
	// Себестоимость
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Согласован		= Ложь;
	ЗаказДавальца	= Документы.ЗаказДавальца.ПустаяСсылка();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	Товары.Очистить();
	ВидыЗапасов.Очистить();
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ТранспортнаяНакладная.АктуализироватьТранспортныеНакладные(Ссылка, Проведен, ПометкаУдаления);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииЗаказа(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Ссылка										КАК Ссылка,
	|	Заказ.Партнер								КАК Партнер,
	|	Заказ.Сделка								КАК Сделка,
	|	Заказ.Контрагент							КАК Контрагент,
	|	Заказ.Договор								КАК Договор,
	|	Заказ.Организация							КАК Организация,
	|	Заказ.БанковскийСчет						КАК БанковскийСчетОрганизации,
	|	Заказ.Подразделение							КАК Подразделение,
	|	ВЫБОР КОГДА Заказ.СкладПоступления.ЭтоГруппа ТОГДА
	|		ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	ИНАЧЕ
	|		 Заказ.СкладПоступления
	|	КОНЕЦ										КАК Склад,
	|	Заказ.Валюта								КАК Валюта,
	|	Заказ.СуммаДокумента						КАК СуммаДокумента,
	|	Заказ.Менеджер								КАК Менеджер,
	|	Заказ.Ссылка								КАК ЗаказДавальца,
	|	Заказ.ВернутьМногооборотнуюТару				КАК ВозвратПринятойМногооборотнойТары,
	|	НЕ Заказ.Проведен							КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ЗаказДавальца КАК Заказ
	|ГДЕ
	|	Заказ.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыборкаШапка = Запрос.Выполнить().Выбрать();
	
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ДокументОснование,
		,
		ВыборкаШапка.ЕстьОшибкиПроведен);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка, , "Ссылка");
	
	МассивЗаказов = Новый Массив;
	МассивЗаказов.Добавить(ДокументОснование);
	Документы.ВозвратСырьяДавальцу.ЗаполнитьПоОстаткамЗаказов(
		ВыборкаШапка,
		Товары,
		МассивЗаказов);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(
		ЭтотОбъект,
		Документы.ВозвратСырьяДавальцу);
	НоменклатураСервер.ЗаполнитьСерииПоFEFO(ЭтотОбъект, ПараметрыУказанияСерий, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПоступления(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Ссылка											КАК Ссылка,
	|	Поступление.Партнер								КАК Партнер,
	|	Поступление.Контрагент							КАК Контрагент,
	|	Поступление.Договор								КАК Договор,
	|	Поступление.Организация							КАК Организация,
	|	Поступление.БанковскийСчетОрганизации			КАК БанковскийСчетОрганизации,
	|	Поступление.Подразделение						КАК Подразделение,
	|	ВЫБОР КОГДА Поступление.Склад.ЭтоГруппа ТОГДА
	|		ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	ИНАЧЕ
	|		 Поступление.Склад
	|	КОНЕЦ											КАК Склад,
	|	Поступление.Валюта								КАК Валюта,
	|	Поступление.СуммаДокумента						КАК СуммаДокумента,
	|	Поступление.Менеджер							КАК Менеджер,
	|	Поступление.ЗаказДавальца						КАК ЗаказДавальца,
	|	Поступление.ВернутьМногооборотнуюТару			КАК ВозвратПринятойМногооборотнойТары,
	|	НЕ Поступление.Проведен							КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ПоступлениеСырьяОтДавальца КАК Поступление
	|ГДЕ
	|	Поступление.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = ПакетЗапросов[0].Выбрать();
	
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ДокументОснование,
		,
		ВыборкаШапка.ЕстьОшибкиПроведен);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	МассивЗаказов = Новый Массив;
	МассивЗаказов.Добавить(ВыборкаШапка.ЗаказДавальца);
	Документы.ВозвратСырьяДавальцу.ЗаполнитьПоОстаткамЗаказов(
		ВыборкаШапка,
		Товары,
		МассивЗаказов,
		ДокументОснование);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(
		ЭтотОбъект,
		Документы.ВозвратСырьяДавальцу);
	НоменклатураСервер.ЗаполнитьСерииПоFEFO(ЭтотОбъект, ПараметрыУказанияСерий, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПринятойТары(Знач РеквизитыЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения.РеквизитыШапки);
	ВозвратПринятойМногооборотнойТары = Истина;
	
	ЗаполнитьУсловияЗакупокПоУмолчанию();
	
	Если ЭтоАдресВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаТары.Партнер					КАК Партнер,
		|	ТаблицаТары.Номенклатура			КАК Номенклатура,
		|	ТаблицаТары.Характеристика			КАК Характеристика,
		|	ТаблицаТары.Сумма					КАК Сумма,
		|	ВЫБОР КОГДА ТаблицаТары.Количество = 0 ТОГДА
		|		ТаблицаТары.Сумма
		|	ИНАЧЕ
		|		ТаблицаТары.Сумма / ТаблицаТары.Количество
		|	КОНЕЦ								КАК Цена,
		|	ТаблицаТары.Количество				КАК Количество,
		|	ТаблицаТары.Количество				КАК КоличествоУпаковок,
		|	ТаблицаТары.ДокументПоступления		КАК ДокументПоступления,
		|	ТаблицаТары.ПредусмотренЗалогЗаТару	КАК ПредусмотренЗалогЗаТару
		|ПОМЕСТИТЬ ВтТаблицаТары
		|ИЗ
		|	&ТаблицаТары КАК ТаблицаТары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТары.Партнер				КАК Партнер,
		|	ТаблицаТары.Номенклатура		КАК Номенклатура,
		|	ТаблицаТары.Характеристика		КАК Характеристика,
		|	ТаблицаТары.Сумма				КАК Сумма,
		|	ТаблицаТары.Цена				КАК Цена,
		|	ТаблицаТары.Количество			КАК Количество,
		|	ТаблицаТары.КоличествоУпаковок	КАК КоличествоУпаковок,
		|	ТаблицаТары.ДокументПоступления	КАК ДокументПоступления,
		|	Заказ.Ссылка					КАК ЗаказДавальца,
		|	Заказ.Назначение				КАК Назначение
		|ИЗ
		|	ВтТаблицаТары КАК ТаблицаТары
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		Документ.ПоступлениеСырьяОтДавальца КАК ПоступлениеСырья
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Документ.ЗаказДавальца КАК Заказ
		|		ПО
		|			ПоступлениеСырья.ЗаказДавальца = Заказ.Ссылка
		|	ПО
		|		ТаблицаТары.ДокументПоступления = ПоступлениеСырья.Ссылка
		|");
		
		ПринятаяТара = ПолучитьИзВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище);
		Запрос.УстановитьПараметр("ТаблицаТары", ПринятаяТара);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(
		ЭтотОбъект,
		Документы.ВозвратСырьяДавальцу);
	
	НоменклатураСервер.ЗаполнитьСерииПоFEFO(ЭтотОбъект,ПараметрыУказанияСерий, Ложь);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер		= Пользователи.ТекущийПользователь();
    Валюта          = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад			= ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки"), Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	
	Если Не Проведен
	 Или ПерезаполнитьВидыЗапасов
	 Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 Или ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
	 
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ЗапасыСервер.УстановитьБлокировкуОстатковТоваровОрганизаций(МенеджерВременныхТаблиц);
		
		ЗапасыСервер.ТаблицаОстатковТоваровОрганизаций(
			Ссылка,
			Организация,
			Дата,
			ДополнительныеСвойства,
			МенеджерВременныхТаблиц);
		
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок,
			Отказ);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов", "Количество"); 
		
		ЗаполнитьДопКолонкиВидовЗапасов();
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура формирует временную таблицу доступных видов запасов.
//
// Параметры:
//	МенеджерВременныхТаблиц - Менеджер временных таблиц
//
Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка	КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка	КАК ВидЗапасовПродавца
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.Назначения КАК Назначения
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Документ.ЗаказДавальца КАК ЗаказДавальца
	|		ПО
	|			Назначения.Заказ = ЗаказДавальца.Ссылка
	|			И ЗаказДавальца.Ссылка В (&МассивЗаказов)
	|	ПО
	|		ВидыЗапасов.Назначение = Назначения.Ссылка
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И Не ВидыЗапасов.ПометкаУдаления
	|	И	ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТовары.ВидЗапасов,
	|	ПоступлениеТовары.ВидЗапасов
	|
	|ИЗ
	|	Документ.ПоступлениеСырьяОтДавальца.Товары КАК ПоступлениеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Документ.ЗаказДавальца КАК ДанныеЗаказа
	|	ПО
	|		ПоступлениеТовары.ЗаказДавальца = ДанныеЗаказа.Ссылка
	|
	|ГДЕ
	|	Не ПоступлениеТовары.ВидЗапасов.РеализацияЗапасовДругойОрганизации
	|	И Не ПоступлениеТовары.ВидЗапасов.ПометкаУдаления
	|	И ДанныеЗаказа.Ссылка В (&МассивЗаказов)
	|	И ПоступлениеТовары.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|");
	
	МассивЗаказов = Товары.ВыгрузитьКолонку("ЗаказДавальца");
	ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(МассивЗаказов);
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация		КАК Организация,
	|	ДанныеДокумента.Склад			КАК Склад,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		ДанныеДокумента.Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ							КАК Подразделение,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		ДанныеДокумента.Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ							КАК Менеджер
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Склад <> СохраненныеДанные.Склад ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Подразделение <> СохраненныеДанные.Подразделение ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Менеджер <> СохраненныеДанные.Менеджер ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК РеквизитыИзменены
	|ИЗ
	|	ТаблицаДанныхДокумента КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СохраненныеДанныеДокумента КАК СохраненныеДанные
	|	ПО
	|		Истина
	|");
	
	Запрос.УстановитьПараметр("Ссылка",												Ссылка);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам",	ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам",					ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	РеквизитыИзменены = Выборка.Следующий() И Выборка.РеквизитыИзменены;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц)
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
		СтруктураАналитики = ЗапасыСервер.АналитикаОбособленноУчетаДокумента(МенеджерВременныхТаблиц);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Возврат превышает остаток товара давальца %1 в организации %2 на складе %3 %4 %5';uk='Повернення перевищує залишок товару давальця %1 в організації %2 на складі %3 %4 %5'"),
			Партнер,
			Организация,
			Склад,
			СтруктураАналитики.СтрокаАналитики,
			СтруктураАналитики.Аналитика);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект);
	
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Номенклатура: %1, недостаточно %2 %3';uk='Номенклатура: %1, недостатньо %2 %3'"),
				НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
				СтрокаТаблицы.Количество,
				СтрокаТаблицы.ЕдиницаИзмерения);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДопКолонкиВидовЗапасов() Экспорт
	
	ТаблицаТовары = Товары.Выгрузить(, "АналитикаУчетаНоменклатуры, Упаковка, ДокументПоступления, Количество, КоличествоУпаковок, Сумма");
	ТаблицаТовары.Свернуть("АналитикаУчетаНоменклатуры, Упаковка, ДокументПоступления", "Количество, КоличествоУпаковок, Сумма");
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		
		КоличествоТоваров	= СтрокаТоваров.Количество;
		СуммаТоваров		= СтрокаТоваров.Сумма;
		КоличествоУпаковок	= СтрокаТоваров.КоличествоУпаковок;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.Упаковка			= СтрокаТоваров.Упаковка;
			НоваяСтрока.ДокументПоступления	= СтрокаТоваров.ДокументПоступления;
			НоваяСтрока.КоличествоУпаковок	= ?(КоличествоТоваров <> 0, КоличествоУпаковок * Количество / КоличествоТоваров, 0);
			НоваяСтрока.Количество			= Количество;
			НоваяСтрока.Сумма				= ?(КоличествоТоваров <> 0, Количество * СуммаТоваров / КоличествоТоваров, 0);
			
			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров	= КоличествоТоваров		- НоваяСтрока.Количество;
			КоличествоУпаковок	= КоличествоУпаковок	- НоваяСтрока.КоличествоУпаковок;
			СуммаТоваров		= СуммаТоваров			- НоваяСтрока.Сумма;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
		Массив.Добавить(Движения.ТоварыКОтгрузке);
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.ПринятаяВозвратнаяТара);
		
		Если НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВозвратСырьяДавальцу).ИспользоватьСерииНоменклатуры Тогда
			Массив.Добавить(Движения.ТоварыНаСкладах);
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
