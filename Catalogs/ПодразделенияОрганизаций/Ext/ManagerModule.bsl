﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ТолькоДействующиеПодразделения")
		Или Параметры.ТолькоДействующиеПодразделения Тогда
		
		Если Не Параметры.Отбор.Свойство("Сформировано") Тогда
			Параметры.Отбор.Вставить("Сформировано", Истина);
		КонецЕсли; 
		
		Если Не Параметры.Отбор.Свойство("Расформировано") Тогда
			Параметры.Отбор.Вставить("Расформировано", Ложь);
		КонецЕсли; 
		
	КонецЕсли;
		
	Если Параметры.Свойство("ПоказыватьНовыеПодразделения")
		И Параметры.ПоказыватьНовыеПодразделения Тогда
		
		Если Не Параметры.Отбор.Свойство("Расформировано") Тогда
			Параметры.Отбор.Вставить("Расформировано", Ложь);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти




#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы


#КонецОбласти

#КонецОбласти

#КонецЕсли