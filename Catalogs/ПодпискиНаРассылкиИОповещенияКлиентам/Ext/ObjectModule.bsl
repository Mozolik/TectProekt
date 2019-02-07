﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ОтправлятьПартнеру Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИПартнераДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИПартнераДляSMS");

	КонецЕсли;
	
	Если Не ОтправлятьКонтактномуЛицуОбъектаОповещения Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS");
		
	КонецЕсли;
	
	РеквизитыГруппы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ГруппаРассылокИОповещений,
	                                                              "ПредназначенаДляЭлектронныхПисем, ПредназначенаДляSMS");
	
	Если НЕ РеквизитыГруппы.ПредназначенаДляЭлектронныхПисем Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИПартнераДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("КонтактныеЛица.ВидКИДляПисем");
		
	КонецЕсли;
	
	Если НЕ РеквизитыГруппы.ПредназначенаДляSMS Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКИПартнераДляSMS");
		МассивНепроверяемыхРеквизитов.Добавить("КонтактныеЛица.ВидКИДляSMS");
		
	КонецЕсли;
	
	Если ПодпискаДействует И (Не ОтправлятьПартнеру И НЕ ОтправлятьКонтактномуЛицуОбъектаОповещения И КонтактныеЛица.Количество() = 0) Тогда
		
		ТекстОшибки = НСтр("ru='Подписка действует, но не указан ни один адресат.';uk='Підписка діє, але не вказаний жодний адресат.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОтправлятьПартнеру",
			,
			Отказ);
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	КоличествоКонтактныхЛицАдресатов = КонтактныеЛица.Количество();
	ШаблонНаименования = НСтр("ru='Для ""%1"" по ""%2""';uk='Для ""%1"" ""%2""'");
	ШаблонНаименования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования,
	                                                                       Строка(Владелец),
	                                                                       Строка(ГруппаРассылокИОповещений));
	
	Если СтрДлина(ШаблонНаименования) > 150 Тогда
		Наименование = Лев(ШаблонНаименования, 147) + "...";
	Иначе
		Наименование = ШаблонНаименования;
	КонецЕсли;
	
	КонтактныеЛица.Свернуть("КонтактноеЛицо, ВидКИДляПисем, ВидКИДляSMS");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
