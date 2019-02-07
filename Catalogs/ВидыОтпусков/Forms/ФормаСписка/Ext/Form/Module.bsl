﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	        	
	ПереопределитьНеобходимостьСоздаватьНачисления(Параметры);

	
	СкрытьНедействительныеВидыОтпуска();
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "Недействителен,Ссылка");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНедействительныеВидыОтпускаПриИзменении(Элемент)
	ПереключитьОтображениеНедействительныхВидовОтпуска(ЭтотОбъект, ПоказыватьНедействительныеВидыОтпуска);
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ДополнительныеПараметры = Новый Структура;
	
	Если ПереопределятьНеобходимостьСоздаватьНачисления Тогда
	     ДополнительныеПараметры.Вставить("СоздаватьНачисления", СоздаватьНачисления);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ, ДополнительныеПараметры", Элемент.ТекущаяСтрока, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.ВидыОтпусков.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкрытьНедействительныеВидыОтпуска()
		
	ПереключитьОтображениеНедействительныхВидовОтпуска(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьОтображениеНедействительныхВидовОтпуска(Форма, ПоказыватьНедействительные)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список, "Недействителен", Ложь, , , НЕ ПоказыватьНедействительные);
	
КонецПроцедуры

&НаСервере
Процедура ПереопределитьНеобходимостьСоздаватьНачисления(Параметры)
	
	ПереопределятьНеобходимостьСоздаватьНачисления = Ложь;
	НеобходимоСоздаватьНачисления = Ложь;
	
	Если Параметры.ДополнительныеПараметры.Свойство("СоздаватьНачисления") Тогда 
		ПереопределятьНеобходимостьСоздаватьНачисления = Истина;
		СоздаватьНачисления = Параметры.ДополнительныеПараметры.СоздаватьНачисления;	
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти
