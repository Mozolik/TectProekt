﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	ОписаниеТипаФизическоеЛицо = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	СтруктураПараметраФизическоеЛицо = Новый Структура("ТипПараметра, ИмяПараметра", ОписаниеТипаФизическоеЛицо, "МассивДокументов");
	СтруктураПараметровОтбора = Новый Структура(НСтр("ru='Сотрудник';uk='Співробітник'"), СтруктураПараметраФизическоеЛицо);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", "СписокНастройкиОтбора",
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрКритерияОтбораПриИзменении(Элемент)
	ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(ИмяЭлемента)
	ЗарплатаКадры.ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, ИмяЭлемента);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
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

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
