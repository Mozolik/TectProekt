﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СтруктураПараметров = ПолучитьПараметры(Параметры);
	СтруктураПараметров.Вставить("Контрагент",            Параметры.Контрагент);
	СтруктураПараметров.Вставить("ТолькоПросмотр",        Параметры.ТолькоПросмотр);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПараметров);
	
	Если ТолькоПросмотр Тогда
		
		МассивЭлементов = Новый Массив();
		МассивЭлементов.Добавить("ДополнительнаяИнформацияШапки");
		МассивЭлементов.Добавить("ДополнительнаяИнформация");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
		
		Отказ = Истина;
		ДополнительныеПараметры = Новый Структура;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru='Реквизиты печати акта выполненных работ были изменены. Закрыть форму без сохранения реквизитов?';uk='Реквізити друку акта виконаних робіт були змінені. Закрити форму без збереження реквізитів?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеЗакрывать" Тогда
		СохранитьПараметры = Ложь;
		
	Иначе
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если СохранитьПараметры Тогда
		
		СтруктураПараметров = ПолучитьПараметры(ЭтаФорма);
		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТолькоПросмотр Тогда
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПараметры(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ДополнительнаяИнформация",      Источник.ДополнительнаяИнформация);
	СтруктураПараметров.Вставить("ДополнительнаяИнформацияШапки", Источник.ДополнительнаяИнформацияШапки);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#КонецОбласти
