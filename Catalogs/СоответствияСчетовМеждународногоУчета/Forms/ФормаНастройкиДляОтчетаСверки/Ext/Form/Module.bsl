﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СоответствующиеСчетаМеждународногоУчета, "СчетРеглУчета", Неопределено);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СоответствующиеСчетаРегламентированногоУчета, "СчетМеждународногоУчета", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьСоответствияСчетов" Тогда
		Элементы.ПланСчетовРеглУчета.Обновить();
		Элементы.ПланСчетовМеждународногоУчета.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПланСчетовМеждународногоУчетаПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовМеждународногоУчетаПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовМеждународногоУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
	ПараметрыФормы.Вставить("ОтображатьПризнакРекласс", Истина);
	
	ОткрытьФорму("ПланСчетов.Международный.Форма.ФормаСчета", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовРеглУчетаПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовРеглУчетаПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетовРеглУчетаПриИзменении(Элемент)
	
	ПриИзмененииОтбораСчетовСервер("ПланСчетовРеглУчета", ОтборСчетовРеглУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетовМеждународногоУчетаПриИзменении(Элемент)
	
	ПриИзмененииОтбораСчетовСервер("ПланСчетовМеждународногоУчета", ОтборСчетовМеждународногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствующиеСчетаМеждународногоУчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СчетРеглУчета = Элементы.ПланСчетовРеглУчета.ТекущаяСтрока;
	
	Если Не ЗначениеЗаполнено(СчетРеглУчета) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет.';uk='Для додавання відповідності виберіть рахунок.'"));
	КонецЕсли;
	
	Если Элементы.ПланСчетовРеглУчета.ДанныеСтроки(СчетРеглУчета).ЗапретитьИспользоватьВПроводках Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет, который используется в проводках';uk='Для додавання відповідності виберіть рахунок, який використовується в проводках'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствующиеСчетаРегламентированногоУчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СчетМеждународногоУчета = Элементы.ПланСчетовМеждународногоУчета.ТекущаяСтрока;
	
	Если Не ЗначениеЗаполнено(СчетМеждународногоУчета) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет.';uk='Для додавання відповідності виберіть рахунок.'"));
	КонецЕсли;
	
	Если Элементы.ПланСчетовМеждународногоУчета.ДанныеСтроки(СчетМеждународногоУчета).ЗапретитьИспользоватьВПроводках Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет, который используется в проводках';uk='Для додавання відповідності виберіть рахунок, який використовується в проводках'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикПланСчетовМеждународногоУчетаПриАктивизацииСтроки()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СоответствующиеСчетаРегламентированногоУчета, 
		"СчетМеждународногоУчета", 
		Элементы.ПланСчетовМеждународногоУчета.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПланСчетовРеглУчетаПриАктивизацииСтроки()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СоответствующиеСчетаМеждународногоУчета, 
		"СчетРеглУчета", 
		Элементы.ПланСчетовРеглУчета.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтбораСчетовСервер(СписокСчетов, ЗначениеОтбора)
	
	ПравоеЗначение = ?(ЗначениеОтбора = "СНастроеннымСоответствием", Истина, Ложь);
	УстановитьОтбор =  ЗначениеОтбора <> "";
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		ЭтаФорма[СписокСчетов], "НастроеныСоотвествующиеСчета", ПравоеЗначение, УстановитьОтбор);
		
	Если УстановитьОтбор Тогда
		Элементы[СписокСчетов].Отображение = ОтображениеТаблицы.Список;
	Иначе
		Элементы[СписокСчетов].Отображение = ОтображениеТаблицы.Дерево;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

