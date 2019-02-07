﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем Макет;
	Перем НазваниеДекларации;
	
	НужноОбнулитьФорму = Истина;
	
	Параметры.Свойство("СохраненныйОтчет", Отчет);
	Параметры.Свойство("ПредставлениеОшибок", Макет);
	Параметры.Свойство("НазваниеДекларации", НазваниеДекларации);
	
	Ошибки.Вывести(Макет);
	
	Если ЗначениеЗаполнено(НазваниеДекларации) Тогда
		Заголовок = "Результаты проверки выгрузки" + " (" + НазваниеДекларации + ")";
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Отчет, "ДатаНачала, ДатаОкончания, Организация, ВыбраннаяФорма");
	
	мДатаНачалаПериодаОтчета = Реквизиты.ДатаНачала;
	мДатаКонцаПериодаОтчета = Реквизиты.ДатаОкончания;
	Организация = Реквизиты.Организация;
	мВыбраннаяФорма = Реквизиты.ВыбраннаяФорма;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.ТипОбласти <> ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
		Возврат;
	КонецЕсли;
	
	Если Область.Гиперссылка = Истина Тогда 
		Текст = Область.Текст;
		Если СтрНайти(Нрег(Текст), "http") > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ПерейтиПоНавигационнойСсылке(Текст);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		ОбработкаРасшифровкиСтруктуры(Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРасшифровкиСтруктуры(Расшифровка, СтандартнаяОбработка)
	
	Перем ИмяЯчейки;
	Перем Раздел;
	Перем Страница;
	
	СтандартнаяОбработка = Ложь;
	
	Расшифровка.Свойство("Показатель", ИмяЯчейки);
	Расшифровка.Свойство("Раздел", Раздел);
	Расшифровка.Свойство("Страница", Страница);
	
	Ячейка = Новый Структура("Раздел,Страница,ИмяЯчейки", Раздел, Страница, ИмяЯчейки);
	
	Попытка
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("мСохраненныйДок", Отчет);
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета", мДатаКонцаПериодаОтчета);
		ПараметрыФормы.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("мВыбраннаяФорма", мВыбраннаяФорма);
		ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417", Истина);
		
		ФормаРеглОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьСсылкуНаФормуРеглОтчета(Отчет, ПараметрыФормы);
		Если СтрЧислоВхождений(ФормаРеглОтчета, "ОтчетМенеджер") > 0 Тогда
			ФормаРеглОтчета = СтрЗаменить(ФормаРеглОтчета, "ОтчетМенеджер.", "");
			ФормаРеглОтчета = ПолучитьФорму("Отчет." + ФормаРеглОтчета, ПараметрыФормы, , ПараметрыФормы.мСохраненныйДок);
		ИначеЕсли СтрЧислоВхождений(ФормаРеглОтчета, "ВнешнийОтчетОбъект") > 0 Тогда
			ФормаРеглОтчета = СтрЗаменить(ФормаРеглОтчета, "ВнешнийОтчетОбъект.", "");
			ФормаРеглОтчета = ПолучитьФорму("ВнешнийОтчет." + ФормаРеглОтчета, ПараметрыФормы, , ПараметрыФормы.мСохраненныйДок);
		КонецЕсли;
			
		ФормаРеглОтчета.Открыть();
		ФормаРеглОтчета.Активизировать();
		ФормаРеглОтчета.ТекущийЭлемент = ФормаРеглОтчета.Элементы.ТабличныйДокумент;
		ФормаРеглОтчета.АктивизироватьЯчейку(Ячейка);
		
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры
