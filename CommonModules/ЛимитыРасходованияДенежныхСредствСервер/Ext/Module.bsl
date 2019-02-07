﻿
#Область ПрограмныйИнтерфейс

Процедура ВыполнитьКонтрольРезультатовПроведения(ЗаявкаОбъект, Отказ) Экспорт
	Перем Ошибки;
	
	СсылкаНаЗаявку = ЗаявкаОбъект.Ссылка;
	ДополнительныеСвойства = ЗаявкаОбъект.ДополнительныеСвойства;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщенияПользователю = Новый Массив;
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаЗаявку, "СверхЛимита, Статус");
	
	Если РеквизитыДокумента.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена Тогда
		Возврат;
	КонецЕсли;
	
	СверхЛимита = РеквизитыДокумента.СверхЛимита;
	КонтролироватьПревышение = ПолучитьФункциональнуюОпцию("КонтролироватьПревышениеЛимитовРасходаДенежныхСредств");
	
	НарушеныТолькоИнформационныеЛимиты = Ложь;
	ИспользоватьБюджетирование = Ложь;
	//++ НЕ УТ
	ИспользоватьБюджетирование = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование");
	
	Если ИспользоватьБюджетирование Тогда
		ЗаявкаПроходитПоЛимитамБюджетирования(СсылкаНаЗаявку, Ошибки, СверхЛимита, 
						КонтролироватьПревышение, НарушеныТолькоИнформационныеЛимиты);
	Иначе
	//-- НЕ УТ
	
		ЗаявкаПроходитПоОперативнымЛимитам(СсылкаНаЗаявку, Ошибки, ДополнительныеСвойства);
		
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ
	
	Если КонтролироватьПревышение И Не СверхЛимита Тогда
		Если ИспользоватьБюджетирование И НарушеныТолькоИнформационныеЛимиты Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

//++ НЕ УТ
Функция ПланФактЛимитов(Дата, Документ = Неопределено) Экспорт
	Перем ЗаписыватьНаборы;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыПроверки = ПараметрыПланФактЛимитов(Дата);
	Если ЗначениеЗаполнено(Документ) Тогда
		ПараметрыПроверки.Вставить("СсылкаНаЗаявку", Документ);
	КонецЕсли;
	
	СтруктураНаборов = СтруктураНаборовЗаявки(Документ, Ложь, ЗаписыватьНаборы);
	ПараметрыПроверки.Вставить("СтруктураНаборов", СтруктураНаборов);
	
	ЛимитыДействующиеНаДатуЗаявки = ПараметрыПроверки.ЛимитыДействующиеНаДатуЗаявки;
	
	Если ЗначениеЗаполнено(Документ) Тогда
		
		ИзмененныеСтатьи = ИзмененныеСтатьи(ПараметрыПроверки);
		
		Если ЗаписыватьНаборы = Истина Тогда
			Для Каждого КлючИЗначение из СтруктураНаборов Цикл
				КлючИЗначение.Значение.Очистить();
				КлючИЗначение.Значение.Записать(Истина);
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		ИзмененныеСтатьи = ЛимитыДействующиеНаДатуЗаявки;
		
	КонецЕсли;
	
	СоответствиеФакта = ФактПоСтатьям(ИзмененныеСтатьи, ПараметрыПроверки);
	РезультатВыполнения = ПланФактПоПравилам(СоответствиеФакта, ПараметрыПроверки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатВыполнения;
	
КонецФункции
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КонтрольОперативныхЛимитов

Процедура СообщитьОбОшибкахПроведенияПоРегиструЛимитыРасходаДенежныхСредств(Ошибки, РезультатЗапроса)
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Превышен лимит расхода по статье %1 на сумму %2 %3';uk='Перевищено ліміт витрачання за статтею %1 на суму %2 %3'"),
				Строка(Выборка.СтатьяДвиженияДенежныхСредств),
				Строка(Выборка.ПервышениеЛимита),
				Строка(ВалютаУправленческогоУчета));
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения, "");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаявкаПроходитПоОперативнымЛимитам(СсылкаНаЗаявку, Ошибки, ДополнительныеСвойства)
	Перем ЕстьИзменения;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	ЕстьИзменения = СтруктураВременныеТаблицы.Свойство("ДвиженияЛимитыРасходаДенежныхСредствИзменение", ЕстьИзменения) И ЕстьИзменения;
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЛимитыРасхода.Ссылка.МоментВремени КАК МоментВремени,
	|	ЛимитыРасхода.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ЛимитыРасхода.ЕстьЛимит КАК ЕстьЛимит
	|ПОМЕСТИТЬ ВременнаяТаблицаСтатьиДДС
	|ИЗ
	|	Документ.ЛимитыРасходаДенежныхСредств.Лимиты КАК ЛимитыРасхода
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ДвиженияЛимитыРасходаДенежныхСредствИзменение КАК Таблица
	|	ПО
	|		(ЛимитыРасхода.Ссылка.Организация = Таблица.Организация ИЛИ НЕ &ЛимитыПоОрганизациям)
	|		И (ЛимитыРасхода.Ссылка.Подразделение = Таблица.Подразделение ИЛИ НЕ &ЛимитыПоПодразделениям)
	|		И ЛимитыРасхода.СтатьяДвиженияДенежныхСредств = Таблица.СтатьяДвиженияДенежныхСредств
	|
	|ГДЕ
	|	&КонтролироватьПревышениеЛимитовРасходаДенежныхСредств
	|	И ЛимитыРасхода.Ссылка.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	|	И ЛимитыРасхода.Ссылка.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаСтатьиДДС.СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ ВременнаяТаблицаСтатьиДДСЛимитНеОграничен
	|ИЗ
	|	ВременнаяТаблицаСтатьиДДС КАК ВременнаяТаблицаСтатьиДДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСтатьиДДС КАК Отбор
	|		ПО ВременнаяТаблицаСтатьиДДС.СтатьяДвиженияДенежныхСредств = Отбор.СтатьяДвиженияДенежныхСредств
	|			И ВременнаяТаблицаСтатьиДДС.МоментВремени < Отбор.МоментВремени
	|ГДЕ
	|	Отбор.МоментВремени ЕСТЬ NULL 
	|	И НЕ ВременнаяТаблицаСтатьиДДС.ЕстьЛимит
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОборотов.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ТаблицаОборотов.Организация КАК Организация,
	|	ТаблицаОборотов.Подразделение КАК Подразделение,
	|	ТаблицаОборотов.РасходВПределахЛимитаОборот - ТаблицаОборотов.ЛимитОборот КАК ПервышениеЛимита
	|ИЗ
	|	РегистрНакопления.ЛимитыРасходаДенежныхСредств.Обороты(
	|			НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ),
	|			КОНЕЦПЕРИОДА(&Период, МЕСЯЦ),
	|			,
	|			(СтатьяДвиженияДенежныхСредств, Организация, Подразделение) В
	|				(ВЫБРАТЬ
	|					Таблица.СтатьяДвиженияДенежныхСредств,
	|					Таблица.Организация,
	|					Таблица.Подразделение
	|				ИЗ
	|					ДвиженияЛимитыРасходаДенежныхСредствИзменение КАК Таблица
	|						ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСтатьиДДСЛимитНеОграничен КАК СтатьиДДСЛимитНеОграничен
	|						ПО
	|							Таблица.СтатьяДвиженияДенежныхСредств = СтатьиДДСЛимитНеОграничен.СтатьяДвиженияДенежныхСредств
	|				ГДЕ
	|					СтатьиДДСЛимитНеОграничен.СтатьяДвиженияДенежныхСредств ЕСТЬ NULL )) КАК ТаблицаОборотов
	|ГДЕ
	|	&КонтролироватьПревышениеЛимитовРасходаДенежныхСредств
	|	И ТаблицаОборотов.РасходВПределахЛимитаОборот - ТаблицаОборотов.ЛимитОборот > 0";
	
	
	РеквизитыЗаявки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаЗаявку, "ДатаПлатежа, ЖелательнаяДатаПлатежа, Дата");
	Если ЗначениеЗаполнено(РеквизитыЗаявки.ДатаПлатежа) Тогда
		Период = РеквизитыЗаявки.ДатаПлатежа;
	ИначеЕсли ЗначениеЗаполнено(РеквизитыЗаявки.ЖелательнаяДатаПлатежа) Тогда
		Период = РеквизитыЗаявки.ЖелательнаяДатаПлатежа;
	Иначе
		Период = РеквизитыЗаявки.Дата;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ЛимитыПоОрганизациям",
		ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям"));
	Запрос.УстановитьПараметр("ЛимитыПоПодразделениям",
		ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям"));
	Запрос.УстановитьПараметр("КонтролироватьПревышениеЛимитовРасходаДенежныхСредств",
		ПолучитьФункциональнуюОпцию("КонтролироватьПревышениеЛимитовРасходаДенежныхСредств"));
	
	СообщитьОбОшибкахПроведенияПоРегиструЛимитыРасходаДенежныхСредств(Ошибки, Запрос.Выполнить());
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ

#Область КонтрольЛимитовБюджетирования

Процедура ЗаявкаПроходитПоЛимитамБюджетирования(СсылкаНаЗаявку, Ошибки, СверхЛимита, КонтролироватьПревышение, НарушеныТолькоИнформационныеЛимиты)
	
	ДатаПроверки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаЗаявку, "ЖелательнаяДатаПлатежа");
	ПараметрыПроверки = ПараметрыПланФактЛимитов(ДатаПроверки);
	ПараметрыПроверки.Вставить("СсылкаНаЗаявку", СсылкаНаЗаявку);
	
	СтруктураНаборов = СтруктураНаборовЗаявки(СсылкаНаЗаявку, Истина, Ложь);
	ПараметрыПроверки.Вставить("СтруктураНаборов", СтруктураНаборов);
	
	//1. Статьи, факт которых будет изменен после проведения заявки
	ИзмененныеСтатьи = ИзмененныеСтатьи(ПараметрыПроверки);
	
	//2. Факт по статьям и показателям
	РазрешающийЛимитНайден = Ложь;
	СоответствиеФакта = ФактПоСтатьям(ИзмененныеСтатьи, ПараметрыПроверки, РазрешающийЛимитНайден);
	
	//3. Сбор запроса для план-факт анализа
	РезультатВыполнения = ПланФактПоПравилам(СоответствиеФакта, ПараметрыПроверки);
	
	НарушеныТолькоИнформационныеЛимиты = Истина;
	
	//4. План-факт анализ
	Для Каждого ИзмененнаяСтатья Из ИзмененныеСтатьи Цикл
		
		НайденныеСтроки = РезультатВыполнения.Скопировать(Новый Структура("Правило", ИзмененнаяСтатья.Ссылка));
		СтрокаСвертки = "";
		Для Каждого СтрокаАналитики из ИзмененнаяСтатья.ИспользуемыеАналитики Цикл
			Если ЗначениеЗаполнено(СтрокаАналитики.ИмяИзмерения) Тогда
				ИмяПоля = СтрокаАналитики.ИмяИзмерения;
			Иначе
				ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(СтрокаАналитики.ВидАналитики);
			КонецЕсли;
			СтрокаСвертки = СтрокаСвертки + ?(ПустаяСтрока(СтрокаСвертки), "", ",") + ИмяПоля;
		КонецЦикла;
		
		НайденныеСтроки.Свернуть(СтрокаСвертки, "СуммаФакт, СуммаПлан");
		
		Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
			
			СуммаПревышения = 0;
			Если НайденнаяСтрока.СуммаПлан < НайденнаяСтрока.СуммаФакт Тогда
				СуммаПревышения = НайденнаяСтрока.СуммаФакт - НайденнаяСтрока.СуммаПлан;
			КонецЕсли;
			
			Если СуммаПревышения Тогда
				Если ИзмененнаяСтатья.ТипЛимита <> Перечисления.ТипыЛимитовРасходованияДС.Информационный Тогда
					НарушеныТолькоИнформационныеЛимиты = Ложь;
				КонецЕсли;
				ТекстСообщения = НСтр("ru='Превышение на %1 лимита %4%2. Всего лимит %3';uk='Перевищення на %1 ліміту %4%2. Всього ліміт %3'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
										СуммаПревышения, ПредставлениеЛимита(ИзмененнаяСтатья, НайденнаяСтрока), НайденнаяСтрока.СуммаПлан,
										ИзмененнаяСтатья.Наименование);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,,ТекстСообщения, "");
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	//5. Анализ, что заявка подпала под "разрешающие лимиты"
	Если КонтролироватьПревышение Тогда
		Если Не СверхЛимита Тогда
			Если Не РазрешающийЛимитНайден Тогда
				НарушеныТолькоИнформационныеЛимиты = Ложь;
				ТекстСообщения = НСтр("ru='Заявка не попадает ни в одно ""Разрешающее"" правило лимитирования. 
                                            |Заявка может быть только сверх-лимитной'
                                            |;uk='Заявка не потрапляє у жодне ""Дозволяюче"" правило лімітування. 
                                            |Заявка може бути тільки понад-лімітною'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,,ТекстСообщения, "");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ЛимитыРасходовПоДаннымБюджетирования(ДатаЛимитов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МоделиБюджетирования.Ссылка
		|ПОМЕСТИТЬ МоделиБюджетирования
		|ИЗ
		|	Справочник.МоделиБюджетирования КАК МоделиБюджетирования
		|ГДЕ
		|	МоделиБюджетирования.НачалоДействия <= &ДатаЛимитов
		|	И (&ДатаЛимитов <= МоделиБюджетирования.КонецДействия
		|			ИЛИ МоделиБюджетирования.КонецДействия = ДАТАВРЕМЯ(1, 1, 1))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПравилаЛимитовПоДаннымБюджетирования.Ссылка,
		|	ПравилаЛимитовПоДаннымБюджетирования.Наименование,
		|	ПравилаЛимитовПоДаннымБюджетирования.СтатьяБюджета,
		|	ПравилаЛимитовПоДаннымБюджетирования.Сценарий,
		|	ПравилаЛимитовПоДаннымБюджетирования.Периодичность,
		|	ПравилаЛимитовПоДаннымБюджетирования.ТипЛимита,
		|	ПравилаЛимитовПоДаннымБюджетирования.ИспользуемыеАналитики.(
		|		Ссылка,
		|		НомерСтроки,
		|		ВидАналитики,
		|		ИмяИзмерения
		|	),
		|	НЕОПРЕДЕЛЕНО КАК ДополнительныйОтбор
		|ИЗ
		|	МоделиБюджетирования КАК МоделиБюджетирования
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаЛимитовПоДаннымБюджетирования КАК ПравилаЛимитовПоДаннымБюджетирования
		|		ПО МоделиБюджетирования.Ссылка = ПравилаЛимитовПоДаннымБюджетирования.Владелец
		|ГДЕ
		|	НЕ ПравилаЛимитовПоДаннымБюджетирования.ЭтоГруппа
		|	И НЕ ПравилаЛимитовПоДаннымБюджетирования.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ДатаЛимитов", ДатаЛимитов);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция КэшАналитикСтатейПоказателей(ЛимитыДействующиеНаДатуЗаявки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиБюджетов.ВидАналитики1,
		|	СтатьиБюджетов.ВидАналитики2,
		|	СтатьиБюджетов.ВидАналитики3,
		|	СтатьиБюджетов.ВидАналитики4,
		|	СтатьиБюджетов.ВидАналитики5,
		|	СтатьиБюджетов.ВидАналитики6,
		|	СтатьиБюджетов.Ссылка
		|ИЗ
		|	Справочник.СтатьиБюджетов КАК СтатьиБюджетов
		|ГДЕ
		|	СтатьиБюджетов.Ссылка В(&СтатьиПоказатели)";
	
	Запрос.УстановитьПараметр("СтатьиПоказатели", ЛимитыДействующиеНаДатуЗаявки.ВыгрузитьКолонку("СтатьяБюджета"));
	
	РезультатЗапроса = Запрос.Выполнить();
	КэшАналитикСтатейПоказателей = РезультатЗапроса.Выгрузить();
	КэшАналитикСтатейПоказателей.Индексы.Добавить("Ссылка");
	
	Возврат КэшАналитикСтатейПоказателей;
	
КонецФункции

Функция СтруктураНаборовЗаявки(СсылкаНаЗаявку, БлокироватьОтИзменения, ЗаписатьНаборы)
	
	БлокировкаДанных = Новый БлокировкаДанных;
	СтруктураНаборов = Новый Структура;
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств;
	
	Если ЗначениеЗаполнено(СсылкаНаЗаявку) И ЗаписатьНаборы = Неопределено Тогда
		Проведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаЗаявку, "Проведен");
		Если Проведен = Ложь Тогда
			ЗаписатьНаборы = Истина;
		КонецЕсли;
	КонецЕсли;
		
	Для Каждого МетаданныеНабора из МетаданныеДокумента.Движения Цикл
		
		//++ НЕ УТКА
		Если МетаданныеНабора = Метаданные.РегистрыНакопления.ФактическиеДанныеБюджетирования Тогда
			Продолжить;
		КонецЕсли;
		//-- НЕ УТКА
		
		ИмяНабора = МетаданныеНабора.Имя;
		НаборЗаписей = Неопределено;
		Если БлокироватьОтИзменения Или ЗаписатьНаборы = Истина Тогда
			НаборЗаписей = РегистрыНакопления[ИмяНабора].СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(СсылкаНаЗаявку);
			Если БлокироватьОтИзменения Тогда
				НаборЗаписей.Прочитать();
				ТаблицаНабора = НаборЗаписей.Выгрузить();
				ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрНакопления." + ИмяНабора);
				ЭлементБлокировки.ИсточникДанных = ТаблицаНабора;
				Для Каждого Измерение из МетаданныеНабора.Измерения Цикл
					ЭлементБлокировки.ИспользоватьИзИсточникаДанных(Измерение.Имя, Измерение.Имя);
				КонецЦикла;
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			КонецЕсли;
		КонецЕсли;
		СтруктураНаборов.Вставить(ИмяНабора, НаборЗаписей);
		
	КонецЦикла;
	
	Если БлокироватьОтИзменения Тогда
		БлокировкаДанных.Заблокировать();
	КонецЕсли;
	
	//Отразим движения заявки для расчета измененных регистров
	Если ЗаписатьНаборы = Истина Тогда
		
		ДополнительныеСвойства = Новый Структура;
		Отказ = Ложь;
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
		
		// Инициализация дополнительных свойств для проведения документа
		ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(СсылкаНаЗаявку, ДополнительныеСвойства, РежимПроведения);
		
		// Инициализация данных документа
		Документы.ЗаявкаНаРасходованиеДенежныхСредств.ИнициализироватьДанныеДокумента(СсылкаНаЗаявку, ДополнительныеСвойства);
		
		// Движения по регистрам
		ДенежныеСредстваСервер.ОтразитьДенежныеСредстваКВыплате(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		ДенежныеСредстваСервер.ОтразитьЛимитыРасходаДенежныхСредств(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		
		ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		
		// Движения по оборотным регистрам управленческого учета
		УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныхСредств(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, СтруктураНаборов, Отказ);
		
		Для Каждого КлючИЗначение из СтруктураНаборов Цикл
			КлючИЗначение.Значение.Записать();
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураНаборов;
	
КонецФункции

Функция ПараметрыПолученияФакта(Правило, СсылкаНаЗаявку, ДатаПроверки)
	
	ПараметрыПолученияФакта = БюджетированиеСервер.ПараметрыПолученияФакта();
	ТаблицаАналитик = Правило.ИспользуемыеАналитики;
	ПараметрыПолученияФакта.ПоОрганизациям = ТаблицаАналитик.Найти("Организация") <> Неопределено;
	ПараметрыПолученияФакта.ПоПодразделениям = ТаблицаАналитик.Найти("Подразделение") <> Неопределено;
	Для Каждого ИспользуемаяАналитика из ТаблицаАналитик Цикл
		Если ЗначениеЗаполнено(ИспользуемаяАналитика.ВидАналитики) Тогда
			ПараметрыПолученияФакта.ВидыАналитик.Добавить(ИспользуемаяАналитика.ВидАналитики);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПолученияФакта.Период = Новый СтандартныйПериод(
			БюджетированиеКлиентСервер.ДатаНачалаПериода(ДатаПроверки	, Правило.Периодичность),
			БюджетированиеКлиентСервер.ДатаКонцаПериода(ДатаПроверки, Правило.Периодичность));
	
	ТаблицаПериодов = Планирование.ПолучитьТаблицуПериодов();
	
	Период = ТаблицаПериодов.Добавить();
	Период.ДатаНачала = ПараметрыПолученияФакта.Период.ДатаНачала;
	Период.ДатаОкончания = ПараметрыПолученияФакта.Период.ДатаОкончания;
	
	ПараметрыПолученияФакта.Вставить("ТаблицаПериодов", ТаблицаПериодов);
	
	ПараметрыПолученияФакта.ВозвращатьПравилоПолученияДанных = Ложь;
	
	Если СсылкаНаЗаявку <> Неопределено Тогда
		ДополнительныйОтбор = Новый НастройкиКомпоновкиДанных;
		ФинансоваяОтчетностьСервер.УстановитьОтбор(ДополнительныйОтбор.Отбор, "Регистратор", СсылкаНаЗаявку);
		ПараметрыПолученияФакта.ДополнительныйОтбор = ДополнительныйОтбор;
	КонецЕсли;
	
	Возврат ПараметрыПолученияФакта;
	
КонецФункции

Функция ПроверитьВозможностьПрименениеНабора(НаборыДанных, СтруктураНаборов)
	
	Для Каждого Набор из НаборыДанных Цикл
		Если ТипЗнч(Набор) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") Тогда
			Для Каждого КлючРегистра из СтруктураНаборов Цикл
				Запрос = НРег(Набор.Запрос);
				СтрокаПоиска = НРег("РегистрНакопления." + КлючРегистра.Ключ);
				Если Найти(Запрос, СтрокаПоиска) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ТипЗнч(Набор) = Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных") Тогда
			Если ПроверитьВозможностьПрименениеНабора(Набор.Элементы, СтруктураНаборов) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПрименятьПравилоСтатьи(ПравилоФакта, СтруктураНаборов)
	
	СКД = Неопределено;
	Если ПравилоФакта.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные Тогда
		СКД = ПравилоФакта.СхемаИсточникаДанных.Получить();
	Иначе
		СКД = Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.СхемаПолученияДанных(ПравилоФакта);
	КонецЕсли;
	
	Возврат ПроверитьВозможностьПрименениеНабора(СКД.НаборыДанных, СтруктураНаборов);
	
КонецФункции

Функция ПрименятьПравило(ПравилоФакта, СтруктураНаборов, ТаблицаПримененияПравил)
	
	НайденнаяСтрока = ТаблицаПримененияПравил.Найти(ПравилоФакта.Правило, "Правило");
	Если НайденнаяСтрока = Неопределено Тогда
		Запись = РегистрыСведений.КэшПримененияПравилПолученияФакта.СоздатьМенеджерЗаписи();
		Запись.Правило = ПравилоФакта.Правило;
		ПрименятьПравило = ПрименятьПравилоСтатьи(ПравилоФакта, СтруктураНаборов);
		Запись.СтатьяБюджета = ПравилоФакта.СтатьяБюджетов;
		Запись.ЗаявкаНаРасходованиеСредств = ПрименятьПравило;
		Запись.Записать();
	Иначе
		ПрименятьПравило = НайденнаяСтрока.ЗаявкаНаРасходованиеСредств;
	КонецЕсли;
	
	Возврат ПрименятьПравило;
	
КонецФункции

Функция РассчитатьДополнительныйОтбор(ПараметрыПолученияФакта, ФактПоПоказателюБюджетов)
	
	НастройкиДополнительногоОтбора = Новый НастройкиКомпоновкиДанных;
	Для Каждого ВидАналитики Из ПараметрыПолученияФакта.ВидыАналитик Цикл
		ИмяКолонки = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(ВидАналитики);
		МассивЗначенийОтбора = ФактПоПоказателюБюджетов.ВыгрузитьКолонку(ИмяКолонки);
		МассивЗначенийОтбора = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивЗначенийОтбора);
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(МассивЗначенийОтбора);
		КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(НастройкиДополнительногоОтбора, ИмяКолонки, СписокЗначений, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЦикла;
	
	Возврат НастройкиДополнительногоОтбора;
	
КонецФункции

Функция ИзмененныеСтатьи(ПараметрыПроверки)
	
	СсылкаНаЗаявку					= ПараметрыПроверки.СсылкаНаЗаявку;
	ДатаПроверки 					= ПараметрыПроверки.ДатаПроверки;
	ЛимитыДействующиеНаДатуЗаявки 	= ПараметрыПроверки.ЛимитыДействующиеНаДатуЗаявки;
	ТаблицаПравилСтатей 			= ПараметрыПроверки.ТаблицаПравилСтатей;
	ТаблицаПримененияПравил 		= ПараметрыПроверки.ТаблицаПримененияПравил;
	СтруктураНаборов 				= ПараметрыПроверки.СтруктураНаборов;
	
	МассивПрименяемыхПравил = Новый Массив;
	Для Каждого ПравилоЛимитов из ЛимитыДействующиеНаДатуЗаявки Цикл
		
		ПараметрыПолученияФакта = ПараметрыПолученияФакта(ПравилоЛимитов, СсылкаНаЗаявку, ДатаПроверки);
		ПараметрыПолученияФакта.РазворачиватьПоРегистратору = Истина;
		
		ФактПоСтатьямБюджетов = БюджетированиеСервер.ТаблицаФактаПоСтатьямБюджетов(ПараметрыПолученияФакта);
		ПравилаСтатей = ТаблицаПравилСтатей.НайтиСтроки(Новый Структура("СтатьяБюджетов", ПравилоЛимитов.СтатьяБюджета));
		
		Для Каждого ПравилоФакта из ПравилаСтатей Цикл
			
			Если Не ПрименятьПравило(ПравилоФакта, СтруктураНаборов, ТаблицаПримененияПравил) Тогда
				Продолжить;
			КонецЕсли;
			
			БюджетированиеСервер.ФактСтатьиБюджетовПоПравилу(ПравилоФакта, ПараметрыПолученияФакта, ФактПоСтатьямБюджетов, Ложь);
			
		КонецЦикла;
		
		Если ФактПоСтатьямБюджетов.Количество() Тогда
			МассивПрименяемыхПравил.Добавить(ПравилоЛимитов);
			ПравилоЛимитов.ДополнительныйОтбор = РассчитатьДополнительныйОтбор(ПараметрыПолученияФакта, ФактПоСтатьямБюджетов);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивПрименяемыхПравил;
	
КонецФункции

Функция ПараметрыПланФактЛимитов(Дата)
	
	ЛимитыДействующиеНаДатуЗаявки = ЛимитыРасходовПоДаннымБюджетирования(Дата);
	КэшАналитикСтатейПоказателей = КэшАналитикСтатейПоказателей(ЛимитыДействующиеНаДатуЗаявки);
	
	СКДПравил = Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.ПолучитьМакет("ПравилаПолученияФакта");
	Настройки = СКДПравил.НастройкиПоУмолчанию;
	
	СписокТиповПравил = Новый СписокЗначений;
	СписокТиповПравил.Добавить(Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ИсполнениеБюджета);
	СписокТиповПравил.Добавить(Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ИсполнениеБюджетаИФактическиеДанные);
	
	ФинансоваяОтчетностьСервер.УстановитьОтбор(Настройки.Отбор, "ТипПравила", СписокТиповПравил, ВидСравненияКомпоновкиДанных.ВСписке);
	ТаблицаПравилСтатей = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКДПравил, Настройки);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КэшПримененияПравилПолученияФакта.Правило,
		|	КэшПримененияПравилПолученияФакта.СтатьяБюджета,
		|	КэшПримененияПравилПолученияФакта.ЗаявкаНаРасходованиеСредств
		|ИЗ
		|	РегистрСведений.КэшПримененияПравилПолученияФакта КАК КэшПримененияПравилПолученияФакта";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаПримененияПравил = РезультатЗапроса.Выгрузить();
	ТаблицаПримененияПравил.Индексы.Добавить("Правило");
	
	Результат = Новый Структура;
	Результат.Вставить("ДатаПроверки", 					Дата);
	Результат.Вставить("ЛимитыДействующиеНаДатуЗаявки", ЛимитыДействующиеНаДатуЗаявки);
	Результат.Вставить("КэшАналитикСтатейПоказателей", 	КэшАналитикСтатейПоказателей);
	Результат.Вставить("ТаблицаПравилСтатей", 			ТаблицаПравилСтатей);
	Результат.Вставить("ТаблицаПримененияПравил", 		ТаблицаПримененияПравил);
	
	Возврат Результат;
	
КонецФункции

Функция ПланФактПоПравилам(СоответствиеФакта, ПараметрыПроверки)
	
	Если Не СоответствиеФакта.Количество() Тогда
		РезультатВыполнения = Новый ТаблицаЗначений;
		РезультатВыполнения.Колонки.Добавить("Правило");
		Для Сч = 1 По 6 Цикл
			РезультатВыполнения.Колонки.Добавить("Аналитика" + Сч);
		КонецЦикла;
		РезультатВыполнения.Колонки.Добавить("СуммаПлан");
		РезультатВыполнения.Колонки.Добавить("СуммаФакт");
		Возврат РезультатВыполнения;
	КонецЕсли;
	
	ФинОтчеты = ФинансоваяОтчетностьСервер;
	
	СКДПланФакт = ФинОтчеты.НоваяСхема();
	НаборОбъединение = ФинОтчеты.НовыйНабор(СКДПланФакт, Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных"));
	
	Счетчик = 0;
	
	СоответствиеПолейГруппировки = Новый Соответствие;
	СоответствиеПолейГруппировки.Вставить("Правило");
	
	СоответствиеОтборов = Новый Соответствие;
	
	ВнешниеНаборы = Новый Структура;
	
	ПараметрыКУстановке = Новый Структура;
	
	Для Каждого КлючИЗначение из СоответствиеФакта Цикл
		
		Счетчик = Счетчик + 1;
		СчетчикТекст = Формат(Счетчик, "ЧН=; ЧГ=");
		
		ВнешниеНаборы.Вставить("Факт_" + СчетчикТекст, КлючИЗначение.Значение.ТаблицаФакта);
		
		ПравилоЛимитов = КлючИЗначение.Значение.ПравилоЛимитов;
		
		НаборФакт = ФинОтчеты.НовыйНабор(НаборОбъединение, Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"), "Факт_" + СчетчикТекст);
		НаборПлан = ФинОтчеты.НовыйНабор(НаборОбъединение, Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"), "План_" + СчетчикТекст);
		
		НаборФакт.ИмяОбъекта = "Факт_" + СчетчикТекст;
		
		ФинОтчеты.НовоеПолеНабора(НаборФакт, "Правило", "Правило");
		Для Каждого СтрокаАналитики из ПравилоЛимитов.ИспользуемыеАналитики Цикл
			Если ЗначениеЗаполнено(СтрокаАналитики.ИмяИзмерения) Тогда
				ФинОтчеты.НовоеПолеНабора(НаборФакт, СтрокаАналитики.ИмяИзмерения);
				СоответствиеПолейГруппировки.Вставить(СтрокаАналитики.ИмяИзмерения);
			Иначе
				ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(СтрокаАналитики.ВидАналитики);
				ФинОтчеты.НовоеПолеНабора(НаборФакт, ИмяПоля);
				СоответствиеПолейГруппировки.Вставить(ИмяПоля);
			КонецЕсли;
		КонецЦикла;
		
		ФинОтчеты.НовоеПолеНабора(НаборФакт, "СтатьяБюджетов", "СтатьяБюджетов", , Новый ОписаниеТипов("СправочникСсылка.СтатьиБюджетов"));
		ФинОтчеты.НовоеПолеНабора(НаборФакт, "ВалютаХранения", "Валюта");
		ФинОтчеты.НовоеПолеНабора(НаборФакт, "СуммаВВалюте", "СуммаФакт");
		
		СоответствиеПолейГруппировки.Вставить("Валюта");
		СоответствиеПолейГруппировки.Вставить("СтатьяБюджетов");
		
		ТекстЗапроса = 
		"ВЫБРАТЬ &Правило_" + СчетчикТекст + " КАК Правило,
		|СтатьяБюджетов,
		|Сценарий";
		
		ВидыАналитик = ПараметрыПроверки.КэшАналитикСтатейПоказателей.Найти(ПравилоЛимитов.СтатьяБюджета);
		
		Для Сч = 1 по 6 Цикл
			ФинОтчеты.НовоеПолеНабора(НаборФакт, "Аналитика" + Сч, "Аналитика" + Сч);
			ТекстЗапроса = ТекстЗапроса + ",
			| Аналитика" + Сч + " КАК Аналитика" + Сч;
			СоответствиеПолейГруппировки.Вставить("Аналитика" + Сч);
		КонецЦикла;
		
		ТекстУсловий = "";
		Для Каждого СтрокаАналитики из ПравилоЛимитов.ИспользуемыеАналитики Цикл
			
			Если ЗначениеЗаполнено(СтрокаАналитики.ИмяИзмерения) Тогда
				ТекстЗапроса = ТекстЗапроса + ",
				| ТаблицаПлана." + СтрокаАналитики.ИмяИзмерения;
			Иначе
				ИндексАналитики = Неопределено;
				Для Сч = 1 По 6 Цикл
					ВидАналитики = ВидыАналитик["ВидАналитики" + Сч];
					Если Не ЗначениеЗаполнено(ВидАналитики) Тогда
						Прервать;
					КонецЕсли;
					Если ВидАналитики = СтрокаАналитики.ВидАналитики Тогда
						ИндексАналитики = Сч;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(СтрокаАналитики.ВидАналитики);
				Если ИндексАналитики = Неопределено Тогда
					ТекстЗапроса = ТекстЗапроса + ",
					| НЕОПРЕДЕЛЕНО КАК " + ИмяПоля;
					ТекстУсловий = ", НЕОПРЕДЕЛЕНО КАК " + ИмяПоля;
				Иначе
					ТекстЗапроса = ТекстЗапроса + ",
					| ТаблицаПлана.Аналитика" + ИндексАналитики + " КАК " + ИмяПоля;
					ТекстУсловий = ТекстУсловий + ", 
					| Аналитика" + ИндексАналитики + " КАК " + ИмяПоля + "_" + СчетчикТекст;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстЗапроса = ТекстЗапроса + ",
		| ТаблицаПлана.Валюта КАК Валюта,
		| ТаблицаПлана.СуммаВВалютеОборот КАК СуммаПлан
		|
		|ИЗ РегистрНакопления.ОборотыБюджетов.Обороты({&ПустаяДата},
		|											{&ПустаяДата},
		|											,
		|											ПериодПланирования МЕЖДУ &НачалоПериода_" + СчетчикТекст + " И &КонецПериода_" + СчетчикТекст + "
		|											//%ОтборСценарий%
		|											И Статус = &Статус
		|											И СтатьяБюджетов = &СтатьяБюджетов_" + СчетчикТекст + "
		|											{Подразделение КАК Подразделение_" + СчетчикТекст + "
		|											,Организация КАК Организация_" + СчетчикТекст + ТекстУсловий + "}) КАК ТаблицаПлана";
		
		
		Если ЗначениеЗаполнено(ПравилоЛимитов.Сценарий) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%ОтборСценарий%", "И Сценарий = &Сценарий_" + СчетчикТекст);
		КонецЕсли;
		
		НаборПлан.Запрос = ТекстЗапроса;
		
		БюджетнаяОтчетностьРасчетКэшаСервер.ДобавитьПараметрСхемы(СКДПланФакт, "НачалоПериода_" + СчетчикТекст);
		БюджетнаяОтчетностьРасчетКэшаСервер.ДобавитьПараметрСхемы(СКДПланФакт, "КонецПериода_" + СчетчикТекст);
		БюджетнаяОтчетностьРасчетКэшаСервер.ДобавитьПараметрСхемы(СКДПланФакт, "Правило_" + СчетчикТекст);
		БюджетнаяОтчетностьРасчетКэшаСервер.ДобавитьПараметрСхемы(СКДПланФакт, "СтатьяБюджетов_" + СчетчикТекст);
		БюджетнаяОтчетностьРасчетКэшаСервер.ДобавитьПараметрСхемы(СКДПланФакт, "Сценарий_" + СчетчикТекст);
		
		НачалоПериода = БюджетированиеКлиентСервер.ДатаНачалаПериода(ПараметрыПроверки.ДатаПроверки, ПравилоЛимитов.Периодичность);
		КонецПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(ПараметрыПроверки.ДатаПроверки, ПравилоЛимитов.Периодичность);
		
		ПараметрыКУстановке.Вставить("НачалоПериода_" + СчетчикТекст, НачалоПериода);
		ПараметрыКУстановке.Вставить("КонецПериода_" + СчетчикТекст, КонецПериода);
		ПараметрыКУстановке.Вставить("Правило_" + СчетчикТекст, ПравилоЛимитов.Ссылка);
		ПараметрыКУстановке.Вставить("СтатьяБюджетов_" + СчетчикТекст, ПравилоЛимитов.СтатьяБюджета);
		ПараметрыКУстановке.Вставить("Сценарий_" + СчетчикТекст, ПравилоЛимитов.Сценарий);
		
		Если ПравилоЛимитов.ДополнительныйОтбор <> Неопределено Тогда
			СоответствиеОтборов.Вставить("_" + СчетчикТекст, ПравилоЛимитов.ДополнительныйОтбор.Отбор);
		КонецЕсли;
		
	КонецЦикла;
	
	ФинОтчеты.НовоеВычисляемоеПоле(СКДПланФакт, "ВалютаПриведенияФакта", "ВЫБОР КОГДА 
																		|СтатьяБюджетов.УчитыватьПоВалюте = ЛОЖЬ ТОГДА
																		|Сценарий.Валюта ИНАЧЕ Валюта КОНЕЦ");
	
	ФинОтчеты.НовоеВычисляемоеПоле(СКДПланФакт, "УчитыватьПоВалюте", "СтатьяБюджетов.УчитыватьПоВалюте");
	
	СоответствиеПолейГруппировки.Вставить("ВалютаПриведенияФакта");
	СоответствиеПолейГруппировки.Вставить("УчитыватьПоВалюте");
	
	
	Для Сч = 1 по 6 Цикл
		
		ФинОтчеты.НовоеВычисляемоеПоле(СКДПланФакт, "Аналитика" + Сч, 
									"ВЫБОР КОГДА ЗначениеЗаполнено(Аналитика" + Сч + ")
									|ТОГДА Аналитика" + Сч + " ИНАЧЕ Неопределено КОНЕЦ");
		
	КонецЦикла;
	
	Компоновщик = ФинОтчеты.КомпоновщикСхемы(СКДПланФакт);
	Для Каждого КлючИЗначение ИЗ ПараметрыКУстановке Цикл
		ФинОтчеты.УстановитьПараметрКомпоновки(Компоновщик.Настройки, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	ФинОтчеты.УстановитьПараметрКомпоновки(Компоновщик.Настройки, "ПустаяДата", Дата(1, 1, 1));
	ФинОтчеты.УстановитьПараметрКомпоновки(Компоновщик.Настройки, "Статус", Перечисления.СтатусыПланов.Утвержден);
	
	Для Каждого КлючИЗначение Из СоответствиеОтборов Цикл
		ФинОтчеты.СкопироватьОтбор(КлючИЗначение.Значение, Компоновщик.Настройки.Отбор, , , КлючИЗначение.Ключ);
	КонецЦикла;
	
	Группировка = Неопределено;
	Для Каждого КлючИЗначение из СоответствиеПолейГруппировки Цикл
		
		Если Группировка = Неопределено Тогда
			Группировка = ФинОтчеты.НоваяГруппировка(Компоновщик.Настройки.Структура, КлючИЗначение.Ключ);
		Иначе
			ФинОтчеты.НовоеПолеГруппировки(Группировка, КлючИЗначение.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
	ФинОтчеты.НовыйРесурс(СКДПланФакт, "СуммаПлан", , "ЕстьNULL(Сумма(СуммаПлан), 0)");
	ФинОтчеты.НовыйРесурс(СКДПланФакт, "СуммаФакт", , "ЕстьNULL(Сумма(СуммаФакт), 0)");
	
	ФинОтчеты.НовоеПолеВыбора(Компоновщик.Настройки, "СуммаПлан");
	ФинОтчеты.НовоеПолеВыбора(Компоновщик.Настройки, "СуммаФакт");
	
	БюджетированиеСервер.ОтключитьВыводОбщихИтогов(Компоновщик.Настройки);
	
	РезультатКомпоновки = ФинОтчеты.ВыгрузитьРезультатСКД(СКДПланФакт, Компоновщик.Настройки, ВнешниеНаборы);
	
	Возврат РезультатКомпоновки;
	
КонецФункции

Функция ПредставлениеЛимита(ПравилоЛимитов, НайденнаяСтрока)
	
	ПредставлениеЛимита = "";
	Для Каждого СтрокаАналитики из ПравилоЛимитов.ИспользуемыеАналитики Цикл
		Если ЗначениеЗаполнено(СтрокаАналитики.ИмяИзмерения) Тогда
			ИмяПоля = СтрокаАналитики.ИмяИзмерения;
		Иначе
			ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(СтрокаАналитики.ВидАналитики);
		КонецЕсли;
		ПредставлениеПоля = Строка(НайденнаяСтрока[ИмяПоля]);
		Если Не ЗначениеЗаполнено(ПредставлениеПоля) Тогда
			ПредставлениеПоля = НСтр("ru='<прочие>';uk='<інші>'");
		КонецЕсли;
		ПредставлениеЛимита = ПредставлениеЛимита + ?(ПустаяСтрока(ПредставлениеЛимита), "", ", ") + ПредставлениеПоля;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ПредставлениеЛимита) Тогда
		ПредставлениеЛимита = " по " + ПредставлениеЛимита;
	КонецЕсли;
	
	Возврат ПредставлениеЛимита;
	
КонецФункции

Функция ФактПоСтатьям(ИзмененныеСтатьи, ПараметрыПроверки, РазрешающийЛимитНайден = Неопределено)
	
	СоответствиеФакта = Новый Соответствие;
	
	Для Каждого ИзмененнаяСтатья из ИзмененныеСтатьи Цикл
		
		ПараметрыФакта = ПараметрыПолученияФакта(ИзмененнаяСтатья, Неопределено, ПараметрыПроверки.ДатаПроверки);
		ТаблицаФакта = БюджетированиеСервер.ТаблицаФактаПоСтатьямБюджетов(ПараметрыФакта);
		ОтборПравил = Новый Структура("СтатьяБюджетов", ИзмененнаяСтатья.СтатьяБюджета);
		СписокПравил = ПараметрыПроверки.ТаблицаПравилСтатей.НайтиСтроки(ОтборПравил);
		ПараметрыФакта.ДополнительныйОтбор = ИзмененнаяСтатья.ДополнительныйОтбор;
		Для Каждого ПравилоФакта из СписокПравил Цикл
			БюджетированиеСервер.ФактСтатьиБюджетовПоПравилу(ПравилоФакта, ПараметрыФакта, ТаблицаФакта, Ложь);
		КонецЦикла;
		ТаблицаФакта.Колонки.Добавить("Правило");
		ТаблицаФакта.ЗаполнитьЗначения(ИзмененнаяСтатья.Ссылка, "Правило");
		СоответствиеФакта.Вставить(ИзмененнаяСтатья.Ссылка, 
				Новый Структура("ПравилоЛимитов, ТаблицаФакта", ИзмененнаяСтатья, ТаблицаФакта));
		
		Если ИзмененнаяСтатья.ТипЛимита = Перечисления.ТипыЛимитовРасходованияДС.РазрешающийВПределахЛимита Тогда
			РазрешающийЛимитНайден = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СоответствиеФакта;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#КонецОбласти 


