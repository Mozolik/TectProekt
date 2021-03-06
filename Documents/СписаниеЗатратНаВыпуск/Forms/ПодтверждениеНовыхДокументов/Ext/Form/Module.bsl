﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокДокументов = Параметры.СписокДокументов;
	
	СклонениеСлова = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
		СписокДокументов.Количество(),
		НСтр("ru='документ';uk='документ'"),
		НСтр("ru='документа';uk='документа'"),
		НСтр("ru='документов';uk='документів'"),
		"м");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Заголовок, СписокДокументов.Количество(),
		СклонениеСлова);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДинамическмйСписок,
		"Ссылка",
		СписокДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Сохранить новые документы?';uk='Зберегти нові документи?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		УдалитьДокументы();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаспоряжения

&НаКлиенте
Процедура ДинамическмйСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДинамическмйСписок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru='Команда не может быть выполнена для указанного объекта.';uk='Команда не може бути виконана для зазначеного об''єкта.'"));
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	ТекущиеДанные = Элементы.ДинамическмйСписок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru='Команда не может быть выполнена для указанного объекта.';uk='Команда не може бути виконана для зазначеного об''єкта.'"));
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ВыполняетсяЗакрытие = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ВыполняетсяЗакрытие = Истина;
	УдалитьДокументы();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьДокументы()
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Строка Из СписокДокументов Цикл
		ДокументОбъект = Строка.Значение.ПолучитьОбъект();
		ДокументОбъект.Удалить();
	КонецЦикла;
	
КонецПроцедуры

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
