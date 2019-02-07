﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВес", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения", "АналитикаНоменклатуры.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъем", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения", "АналитикаНоменклатуры.Номенклатура"));
		
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек);
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	ВспомогательныеПараметры = Новый Массив;
	
	КлючТекущегоВарианта = "";
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта", КлючТекущегоВарианта) Тогда
		Если Не КлючТекущегоВарианта = "ДинамикаЗакупок" Тогда
			ВспомогательныеПараметры.Добавить("Периодичность");
		КонецЕсли;
	КонецЕсли;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	ВспомогательныеПараметры.Добавить("МаксимумСерийКоличество");
	ВспомогательныеПараметры.Добавить("ВыделениеСерийДиаграмм");
	ВспомогательныеПараметры.Добавить("ОтслеживаемыеАналитики");
	ВспомогательныеПараметры.Добавить("ГрадиентСерийДиаграмм");
	ВспомогательныеПараметры.Добавить("ОтображениеМаркеровТочекДиаграмм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;
КонецФункции

Процедура УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВыводитьСуммы");
	Если ПараметрДанныеОтчета <> Неопределено Тогда
		ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
		Если Не ЗначениеЗаполнено(ПараметрДанныеОтчета.Значение) Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВыводитьСуммы", 1);			
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		
		ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
		Если ПараметрВалюта <> Неопределено Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Валюта", ВалютаУправленческогоУчета);	
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалют(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	СтруктуруЗаголовковПолейЕдиницИзмерений = КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктуруЗаголовковПолейЕдиницИзмерений, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли