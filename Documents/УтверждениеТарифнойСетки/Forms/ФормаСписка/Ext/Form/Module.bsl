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
	
	Если Параметры.Отбор.Свойство("ТарифнаяСетка", ТарифнаяСетка) Тогда
		ВидТарифнойСетки = ТарифнаяСетка.ВидТарифнойСетки;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидТарифнойСетки) Тогда
		Параметры.Отбор.Свойство("ВидТарифнойСетки", ВидТарифнойСетки);
	КонецЕсли;
	
	ЭтаФорма.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("УтверждениеТарифнойСеткиСписок", ВидТарифнойСетки);
	Элементы.ТарифнаяСетка.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитТарифнаяСетка",
		?(ЗначениеЗаполнено(ВидТарифнойСетки),ВидТарифнойСетки, Перечисления.ВидыТарифныхСеток.Тариф));	
	Элементы.ВидТарифнойСетки.Видимость = НЕ ЗначениеЗаполнено(ВидТарифнойСетки);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "ВидТарифнойСетки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

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

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти