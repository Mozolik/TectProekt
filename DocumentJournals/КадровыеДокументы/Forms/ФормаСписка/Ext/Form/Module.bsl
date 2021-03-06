﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Параметры.Свойство("СотрудникСсылка", СотрудникСсылка);
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СотрудникСсылка, "ГоловнаяОрганизация,ФизическоеЛицо,ТекущаяОрганизация");
		Если КадровыеДанныеСотрудников.Количество() > 0 Тогда
			
			ДанныеСотрудника = КадровыеДанныеСотрудников[0];
			
			Организация = ДанныеСотрудника.ТекущаяОрганизация;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ГоловнаяОрганизация", ДанныеСотрудника.ГоловнаяОрганизация);
			
			МассивДокументов = ЗарплатаКадры.ДокументыПоФизическомуЛицу(ДанныеСотрудника.ФизическоеЛицо);
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "МассивДокументов", МассивДокументов, Истина);
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"Сотрудник",
				"Видимость",
				Ложь);
			
			Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСотрудника.ГоловнаяОрганизация, "ЕстьОбособленныеПодразделения") Тогда
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"Организация",
					"Видимость",
					Ложь);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ОписаниеТипаФизическоеЛицо = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		СтруктураПараметраФизическоеЛицо = Новый Структура("ТипПараметра, ИмяПараметра", ОписаниеТипаФизическоеЛицо, "МассивДокументов");
		СтруктураПараметровОтбора = Новый Структура(НСтр("ru='Сотрудник';uk='Співробітник'"), СтруктураПараметраФизическоеЛицо);
		ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", "СписокНастройкиОтбора",
			СтруктураПараметровОтбора, "СписокКритерииОтбора");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУтвердить", "Видимость", Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ДобавлениеИзменениеНачисленнойЗарплатыРасширенная"));
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтаФорма);
	
	ЗарплатаКадрыРасширенный.СформироватьПодменюСоздатьФормыСпискаДокументов(ЭтаФорма, "ЖурналДокументов.КадровыеДокументы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрКритерияОтбораПриИзменении(Элемент)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("УстановкаОтбораПоСотрудникуЖурналаДокументовКадровыеДокументы");
	
	ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(ИмяЭлемента)
	ЗарплатаКадры.ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, ИмяЭлемента);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		Если Параметр = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура;
		
		ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
		
		Отказ = Истина;
		ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		ДополнительныеЗначенияЗаполнения = Новый Структура("Сотрудник", СотрудникСсылка);
		Если ЗначениеЗаполнено(Организация) Тогда
			ДополнительныеЗначенияЗаполнения.Вставить("Организация", Организация);
		КонецЕсли;
		
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, КомандыСозданияДокументов.Получить(Команда.Имя).ПолноеИмя);
		ДополнительныеЗначенияЗаполнения = ПараметрыОткрытия.ЗначенияЗаполнения;
	КонецЕсли; 
	
	ЗарплатаКадрыРасширенныйКлиент.СоздатьДокументПоОписанию(ЭтаФорма, Команда.Имя, ДополнительныеЗначенияЗаполнения);
	
КонецПроцедуры

#КонецОбласти
