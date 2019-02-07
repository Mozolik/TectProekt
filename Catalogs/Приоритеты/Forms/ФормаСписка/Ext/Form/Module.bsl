﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
//++ НЕ УТКА
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
//-- НЕ УТКА
		ТекстСообщения = НСтр("ru='Непосредственное открытие формы списка справочника ""Приоритеты"" не предусмотрено.';uk='Безпосереднє відкриття форми списку довідника ""Пріоритети"" не передбачено.'");
		ВызватьИсключение ТекстСообщения;
//++ НЕ УТКА
	КонецЕсли;
//-- НЕ УТКА
	
	ДоступноИзменение = ПравоДоступа("Изменение", Метаданные.Справочники.Приоритеты);
	
	Элементы.ПереместитьЭлементВверх.Доступность = ДоступноИзменение;
	Элементы.ПереместитьЭлементВниз.Доступность = ДоступноИзменение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
