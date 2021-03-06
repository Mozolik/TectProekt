﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Менеджер = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ЗаполнятьПоСоглашению") Тогда
	 
			Партнер = ДанныеЗаполнения.Партнер;
			Соглашение = ДанныеЗаполнения.Соглашение;
			Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") И ЗначениеЗаполнено(Соглашение) Тогда
				ЗаполнитьУсловияПродажПоCоглашению();
			Иначе
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			КонецЕсли;
			Организация = ДанныеЗаполнения.Организация;
			Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(
				ЭтотОбъект,
				Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию,
				Валюта);
			
			КомиссионнаяТорговляСервер.ЗаполнитьТоварыПоОстаткамПереданныхНаКомиссию(
				ЭтотОбъект, 
				ДанныеЗаполнения.КонецПериода,
				Ложь); // ЕстьСуммаПродажи
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
			
			Партнер = ДанныеЗаполнения.Партнер;
			Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
				ЗаполнитьУсловияПродажПоУмолчанию();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьУсловияПродаж();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если Товары.Итог("СуммаСНДС") = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежа");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);	
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
		
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	КомиссионнаяТорговляСервер.ПроверитьКорректностьПериода(ЭтотОбъект, Отказ);
	
																							
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	РасчетСуммаДокумента = Товары.Итог("СуммаСНДС");
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.ОтчетКомиссионера, Неопределено, Подразделение, Партнер);
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.СтатусУказанияСерий = "";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
		
		ЗаполнитьВидыЗапасов(Отказ);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ОтчетКомиссионераОСписании.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыПереданныеНаКомиссию(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ДоступныеДляШаблоновПечатныеФормы() Экспорт

	МассивДоступныхПечатныхФорм = Новый Массив;
	
	МассивДоступныхПечатныхФорм.Добавить(ШаблоныСообщенийСервер.СтруктураПараметровДоступнойПечатнойФормы(
	                                     "ОтчетКомиссионераСписание", НСтр("ru='Отчет комиссионера о списании';uk='Звіт комісіонера про списання'"),
	                                     "Обработка.ПечатьОбщихФорм", Неопределено));
	
	Возврат МассивДоступныхПечатныхФорм

КонецФункции

#КонецОбласти

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж <> Неопределено Тогда
	
		Валюта = УсловияПродаж.Валюта;
		НаправлениеДеятельности = УсловияПродаж.НаправлениеДеятельности;
		
		НалогообложениеНДС = УсловияПродаж.НалогообложениеНДС;
		ЦенаВключаетНДС = УсловияПродаж.ЦенаВключаетНДС;
			
		Если ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
			Организация = УсловияПродаж.Организация;
		КонецЕсли;
		
		Если Не УсловияПродаж.Типовое
		 И ЗначениеЗаполнено(УсловияПродаж.Контрагент) Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		
		Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
			
			Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(
				ЭтотОбъект,
				Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию,
				Валюта);
				
			Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
				НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
			КонецЕсли;
		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(УсловияПродаж.ГруппаФинансовогоУчета) Тогда
			ГруппаФинансовогоУчета = УсловияПродаж.ГруппаФинансовогоУчета;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");

	Если ЗначениеЗаполнено(Партнер) Или Не ИспользоватьСоглашенияСКлиентами Тогда
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура("ХозяйственнаяОперация, ВыбранноеСоглашение, ПустаяСсылкаДокумента", 
			Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию, 
			Соглашение,
			Документы.ОтчетКомиссионераОСписании.ПустаяСсылка()));
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если НЕ ИспользоватьСоглашенияСКлиентами ИЛИ
				(Соглашение <> УсловияПродажПоУмолчанию.Соглашение И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
				Если ИспользоватьСоглашенияСКлиентами Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					ПродажиСервер.ЗаполнитьЦены(
						Товары, // Табличная часть
						, // Массив строк или структура отбора
						Новый Структура( // Параметры заполнения
							"Дата, Валюта, Соглашение, ПоляЗаполнения",
							?(ЗначениеЗаполнено(КонецПериода), КонецПериода, Дата),
							Валюта,
							Соглашение,
							"Цена, СтавкаНДС, ВидЦены"
						),
						Новый Структура( // Структура действий с измененными строками
							"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
							"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
				КонецЕсли;
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
			КонецЕсли;
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ЗаполнитьУсловияПродажПоCоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение);
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
	ПродажиСервер.ЗаполнитьЦены(
		Товары, // Табличная часть
		, // Массив строк или структура отбора
		Новый Структура( // Параметры заполнения
			"Дата, Валюта, Соглашение, ПоляЗаполнения",
			?(ЗначениеЗаполнено(КонецПериода), КонецПериода, Дата),
			Валюта,
			Соглашение,
			"Цена, СтавкаНДС, ВидЦены"
		),
		Новый Структура( // Структура действий с измененными строками
			"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
			"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
			
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта			= ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);

КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Партнер КАК Партнер,
	|	&Контрагент КАК Контрагент,
	|	&Соглашение КАК Соглашение,
	|	&Договор КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетКомиссионераОСписании) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|   ВЫБОР 
	|   	КОГДА НЕ &ОрганизацияПлательщикНДС 
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность)
	|		КОГДА ТаблицаТоваров.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС) 
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность)
	|		КОГДА ТаблицаТоваров.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НеНДС) 
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность)
	|		ИНАЧЕ
	|   		ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая)
	|	КОНЕЦ КАК ЦелевоеНалоговоеНазначение,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов
	|	
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(Товары.Выгрузить()));
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(ВидыЗапасов.Выгрузить()));
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", НДСОбщегоНазначенияСервер.ПолучитьНалоговоеНазначениеНДС(Организация, Контрагент, Дата, Истина));
	Запрос.УстановитьПараметр("ОрганизацияПлательщикНДС", НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Организация, Дата));
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Функция РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) КАК НачалоМесяца,
	|	ДанныеДокумента.Партнер,
	|	ДанныеДокумента.Соглашение
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.ОтчетКомиссионераОСписании КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		Истина
	|	КОГДА НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) <> СохраненныеДанные.НачалоМесяца ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Партнер <> СохраненныеДанные.Партнер ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Соглашение <> СохраненныеДанные.Соглашение ТОГДА
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
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РеквизитыИзменены = Выборка.РеквизитыИзменены;
	Иначе
		РеквизитыИзменены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|///////////////////////////////////////////////////////////////////////////////
	|// Не обособленные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца
	|
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок)
	
	Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Номенклатура: %1 
            |Отчет комиссионера превышает остаток товара, переданного комиссионеру %2 по соглашению %3 на %4 %5'
            |;uk='Номенклатура: %1 
            |Звіт комісіонера перевищує залишок товару, переданого комісіонеру %2 за офертою %3 на %4 %5'"),
			НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
			Партнер,
			Соглашение,
			СтрокаТаблицы.Количество,
			СтрокаТаблицы.ЕдиницаИзмерения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	 ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
	 
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ЗапасыСервер.ТаблицаОстатковТоваровПереданныхНаКомиссию(
			Ссылка,
			Организация,
			Партнер,
			Соглашение,
			?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), КонецМесяца(Дата)),
			ДополнительныеСвойства,
			МенеджерВременныхТаблиц);
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок,
			Отказ);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, СтавкаНДС, ЦелевоеНалоговоеНазначение", "Количество, СуммаСНДС, СуммаНДС");
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
