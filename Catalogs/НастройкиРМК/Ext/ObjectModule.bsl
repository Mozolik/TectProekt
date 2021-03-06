﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиРМК.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиРМК КАК НастройкиРМК
		|ГДЕ
		|	НастройкиРМК.Ссылка <> &Ссылка
		|	И НастройкиРМК.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для рабочего места %1 уже существует настройка РМК %2';uk='Для робочого місця %1 вже існує настройка РМК %2'"), РабочееМесто, Выборка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				,
				,
				Отказ);
		
		КонецЕсли;
	
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из КассыККМ Цикл
		Если Не СтрокаТЧ.ИспользоватьБезПодключенияОборудования
			И Не ЗначениеЗаполнено(СтрокаТЧ.ПодключаемоеОборудование) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Оборудование""';uk='Не заповнене поле ""Обладнання""'");
			АдресОшибки = НСтр("ru=' в строке %НомерСтроки% списка ""КассыККМ""';uk=' у рядку %НомерСтроки% списку ""КассиККМ""'");
			АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрокаТЧ.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("КассыККМ", СтрокаТЧ.НомерСтроки, "ПодключаемоеОборудование"),
				,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ЭквайринговыеТерминалы Цикл
		Если Не СтрокаТЧ.ИспользоватьБезПодключенияОборудования
			И Не ЗначениеЗаполнено(СтрокаТЧ.ПодключаемоеОборудование) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Оборудование""';uk='Не заповнене поле ""Обладнання""'");
			АдресОшибки = НСтр("ru=' в строке %НомерСтроки% списка ""Эквайринговые терминалы""';uk=' у рядку %НомерСтроки% списку ""Еквайрингові термінали""'");
			АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрокаТЧ.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭквайринговыеТерминалы", СтрокаТЧ.НомерСтроки, "ПодключаемоеОборудование"),
				,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("КассыККМ.ПодключаемоеОборудование");
	МассивНепроверяемыхРеквизитов.Добавить("ЭквайринговыеТерминалы.ПодключаемоеОборудование");
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КассыККМ");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Наименование = Строка(ЭтотОбъект.РабочееМесто);
КонецПроцедуры

#КонецОбласти

#КонецЕсли