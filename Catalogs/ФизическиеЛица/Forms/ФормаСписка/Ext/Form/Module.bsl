﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	Если Параметры.РежимВыбора = Истина Тогда
		
		Элементы.Список.РежимВыбора = Истина;
		Если НЕ ЭтаФорма.ЗакрыватьПриВыборе Тогда
		
			Если НЕ ПустаяСтрока(Параметры.АдресСпискаПодобранныхСотрудников) Тогда
				МассивПодобранных = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаПодобранныхСотрудников);
				СписокПодобранных.ЗагрузитьЗначения(МассивПодобранных);
			КонецЕсли; 
		
		КонецЕсли; 
		
	КонецЕсли;
	
	УстановитьСписокПодобранныхСотрудников();
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ВыбранныеФизическиеЛица.Количество() > 0 Тогда
		ОповеститьОВыборе(ВыбранныеФизическиеЛица.ВыгрузитьЗначения());
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Элементы.Список.РежимВыбора И ИмяСобытия = "СозданоФизическоеЛицо" И Источник = Элементы.Список Тогда
		
		Если Элементы.Список.МножественныйВыбор И ТипЗнч(Параметр) <> Тип("Массив") Тогда
			ПараметрОповещения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметр);
		Иначе
			ПараметрОповещения = Параметр;
		КонецЕсли; 
		
		ОповеститьОВыборе(ПараметрОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ОткрытиеФормыЭлементаСправочникаФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			СписокЗначений = Значение;
		Иначе
			СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
		КонецЕсли;
		
		Если СписокЗначений.Количество() > 0 Тогда
			
			Если Элементы.Список.МножественныйВыбор Тогда
				
				ОбновитьСписокПодобранных(СписокЗначений);
				Если СписокЗначений.Количество() > 1 Тогда
					Закрыть();
				КонецЕсли; 
				
			Иначе
				
				Если СписокПодобранных.НайтиПоЗначению(СписокЗначений[0]) = Неопределено Тогда
					ОповеститьОВыборе(СписокЗначений[0]);
				Иначе
					Закрыть();
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЕсли; 
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ОткрытиеФормыНовогоЭлементаСправочникаФизическиеЛица");
	
	Если Не Группа И Элементы.Список.РежимВыбора Тогда
		
		Отказ = Истина;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытия, Элемент);

	КонецЕсли; 
	
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


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПодобранных(Значение)
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Для каждого ВыбранноеЗначение Из СписокЗначений Цикл
		Если СписокПодобранных.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			СписокПодобранных.Добавить(ВыбранноеЗначение);
			ВыбранныеФизическиеЛица.Добавить(ВыбранноеЗначение);
		КонецЕсли; 
	КонецЦикла;
	
	УстановитьСписокПодобранныхСотрудников();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокПодобранныхСотрудников()
	
	ЭлементУсловногоОформления = Неопределено;
	Для каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru='Выделение подобранных';uk='Виділення підібраних'") Тогда
			ЭлементУсловногоОформления = ЭлементОформления;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ЭлементУсловногоОформления <> Неопределено Тогда
		ЭлементУсловногоОформления.Отбор.Элементы[0].ПравоеЗначение = СписокПодобранных;
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти
