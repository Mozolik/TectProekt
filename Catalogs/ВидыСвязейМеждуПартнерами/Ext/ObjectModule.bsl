﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
	
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("РольПартнера1");
		МассивНепроверяемыхРеквизитов.Добавить("РольПартнера2");
		
		Если НЕ ЗначениеЗаполнено(РольПартнера1) Тогда
			ТекстОшибки = НСтр("ru='Не заполнена ""Роль контрагента 1""';uk='Не заповнена ""Роль контрагента 1""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"РольПартнера1",
				,
				Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(РольПартнера2) Тогда
			ТекстОшибки = НСтр("ru='Не заполнена ""Роль контрагента 2""';uk='Не заповнена ""Роль контрагента 2""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"РольПартнера2",
				,
				Отказ);
		КонецЕсли;
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли