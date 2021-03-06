﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор);
		
	Если Параметры.Свойство("Партнер") Тогда
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Параметры.Партнер, СписокПартнеров);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			СписокПартнеров,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			Истина);
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Параметры.Партнер);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ПартнерПоУмолчанию",
			Параметры.Партнер,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
		
	Иначе
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Справочники.Партнеры.ПустаяСсылка());
		
	КонецЕсли;
		
	Если Параметры.Свойство("Контрагент") Тогда
		
		СписокПартнеров = Новый СписокЗначений;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Контрагент",
			Параметры.Контрагент,
			ВидСравненияКомпоновкиДанных.Равно
			, 
			Истина);
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(ЭтотОбъект, "Партнер", НСтр("ru='Контрагент';uk='Контрагент'"));
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора)
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		Если ЭлементОтбора.Ключ = "Контрагент" И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"Партнер",
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементОтбора.Значение, "Партнер"),
				ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ЭлементОтбора.Ключ,
			ЭлементОтбора.Значение,
			ВидСравненияКомпоновкиДанных.Равно);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
