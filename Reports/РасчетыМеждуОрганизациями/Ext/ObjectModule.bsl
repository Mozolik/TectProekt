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
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.ФормаПараметры;
	
	Если Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("Документ") Тогда
	   
		Если ТипЗнч(Параметры.Отбор.Документ) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
			Реквизиты = Документы.ПередачаТоваровМеждуОрганизациями.РеквизитыДокумента(Параметры.Отбор.Документ);
			
		ИначеЕсли ТипЗнч(Параметры.Отбор.Документ) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
			Реквизиты = Документы.ОтчетПоКомиссииМеждуОрганизациями.РеквизитыДокумента(Параметры.Отбор.Документ);
			
		Иначе
			Реквизиты = Неопределено;
			
		КонецЕсли;
		
		Если Реквизиты <> Неопределено Тогда
			Массив = Новый Массив;
			Массив.Добавить(Реквизиты.ОрганизацияОтправитель);
			Массив.Добавить(Реквизиты.ОрганизацияПолучатель);
			Параметры.Отбор.Вставить("Организация", Массив);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДанныеПоРасчетам");
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
		ПараметрДанных.ИдентификаторПользовательскойНастройки);
		
	Если ПользовательскаяНастройка <> Неопределено Тогда
		
		Если ПользовательскаяНастройка.Значение = 2 Тогда // В валюте упр. учета
			
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Валюта",
				Константы.ВалютаУправленческогоУчета.Получить());
			
		ИначеЕсли ПользовательскаяНастройка.Значение = 3 Тогда // В валюте регл. учета
			
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Валюта",
				Константы.ВалютаРегламентированногоУчета.Получить());
			
		Иначе
			
			ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Валюта");
			Если ПараметрДанных <> Неопределено Тогда
				ПараметрДанных.Использование = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПользовательскаяНастройка.Значение = 2 // В валюте упр. учета
			ИЛИ ПользовательскаяНастройка.Значение = 3 Тогда // В валюте регл. учета
				#Область АктуализацияВзаиморасчетов
				УстановитьПривилегированныйРежим(Истина);
				ПоляОтбора = РаспределениеВзаиморасчетов.ПоляОтбораПоУмолчанию();
				ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
				РаспределениеВзаиморасчетов.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства);
				УстановитьПривилегированныйРежим(Ложь);
				#КонецОбласти
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РаспределениеВзаиморасчетов.ВывестиАктуальностьРасчетов(ДокументРезультат, ДопСвойства);
	#КонецОбласти

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли