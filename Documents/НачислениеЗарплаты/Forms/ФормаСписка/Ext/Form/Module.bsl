﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "РежимДоначисления", Параметры.РежимДоначисления);
		
	Если Параметры.Отбор.Свойство("Организация") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Параметры.Отбор.Организация);
			
		Параметры.Отбор.Удалить("Организация");
			
	КонецЕсли; 
		
	Если Параметры.Отбор.Свойство("МесяцНачисления") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "МесяцНачисления", Параметры.Отбор.МесяцНачисления);
			
		Параметры.Отбор.Удалить("МесяцНачисления");
			
	КонецЕсли; 
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПериодыПерерасчета",
		"Видимость",
		Параметры.РежимДоначисления);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"МесяцНачисления",
		"Видимость",
		Не Параметры.РежимДоначисления);
		
	Если Параметры.РежимДоначисления Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок  = НСтр("ru='Доначисления, перерасчеты зарплаты';uk='Донарахування, перерахунки зарплати'");
		
		Если Параметры.Отбор.Свойство("Ссылка") Тогда
			РежимВыбораДоначисления = Истина;
		КонецЕсли; 
		
	КонецЕсли;
	
	Если Параметры.РежимВыбора = Истина Тогда
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Список.МножественныйВыбор = Ложь;
	КонецЕсли;
	
	Если Не Параметры.РежимДоначисления Тогда
		ЗарплатаКадрыРасширенный.СформироватьПодменюСоздатьФормыСпискаДокументов(ЭтаФорма, "Документ.НачислениеЗарплаты");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаСоздать",
		"Видимость",
		Параметры.РежимДоначисления);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
	    Модуль.ДоработатьЗапросСпискаНачислений(ЭтотОбъект);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, 
		"ПредставлениеТипаДоначислениеПерерасчет", Документы.НачислениеЗарплаты.ПредставлениеТипаДоначислениеПерерасчет());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, 
		"ПредставлениеТипаРасчетЗарплаты", Метаданные.Документы.НачислениеЗарплаты.Синоним);

	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "РежимДоначисления");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ОткрытиеФормыДокументаНачислениеЗарплаты");

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ОткрытиеФормыНовогоДокументаНачислениеЗарплаты");

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


&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.СоздатьДокументПоОписанию(ЭтаФорма, Команда.Имя);
	
КонецПроцедуры

#КонецОбласти

