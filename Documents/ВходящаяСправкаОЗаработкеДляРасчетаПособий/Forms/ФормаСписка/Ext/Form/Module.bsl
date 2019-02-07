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
	
	ПодобратьСотрудникаДляЗначенияЗаполнения(Параметры);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
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

#Область СлужебныеПроцедурыИФункции

Процедура ПодобратьСотрудникаДляЗначенияЗаполнения(Параметры)
	
	Отбор = Параметры.Отбор;
	
	Если Не Отбор.Свойство("ФизическоеЛицо") Или Не Отбор.Свойство("Организация") Тогда
		Возврат;
	КонецЕсли;
	
	Если Отбор.Свойство("Сотрудник") И ЗначениеЗаполнено(Отбор.Сотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	КадровыеДанные = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Отбор.ФизическоеЛицо, Истина, Отбор.Организация, ТекущаяДатаСеанса());
	Если КадровыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.ДополнительныеПараметры.Вставить("Сотрудник", КадровыеДанные[0].Сотрудник);
	
КонецПроцедуры

#КонецОбласти
