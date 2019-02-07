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
	
	// Установка значений по умолчанию
	НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	#Область АктуализацияВзаиморасчетов
	УстановитьПривилегированныйРежим(Истина);
	ПоляОтбора = РаспределениеВзаиморасчетов.ПоляОтбораПоУмолчанию();
	ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	РаспределениеВзаиморасчетов.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства,"РасчетыСПоставщиками");
	УстановитьПривилегированныйРежим(Ложь);
	#КонецОбласти
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РегистрыСведений.ЗаданияКРаспределениюРасчетовСПоставщиками.ВывестиАктуальностьРасчета(ДокументРезультат, ДопСвойства);
	#КонецОбласти

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы, ПользовательскиеНастройки = Ложь)
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
	
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
		ПользНастройкаПериода.Использование = Истина;
		ПользНастройкаПериода.Значение.ДатаНачала = ФиксНастройкаПериода.Значение.ДатаНачала;
		ПользНастройкаПериода.Значение.ДатаОкончания = ФиксНастройкаПериода.Значение.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
		
	КонецЕсли;
КонецПроцедуры

Функция ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроекФормы.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Возврат ПараметрДанных;

КонецФункции

Функция ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроекФормы.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецЕсли