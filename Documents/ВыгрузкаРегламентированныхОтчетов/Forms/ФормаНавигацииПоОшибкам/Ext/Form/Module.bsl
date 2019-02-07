﻿
// ПриОткрытии()
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Для Каждого Стр Из ВладелецТС.ТаблицаСообщений Цикл
		
		ДокументВладелец = РегламентированнаяОтчетностьКлиентСервер.НайтиЭлементВДанныхФормыДерево(ТаблицаСообщений.ПолучитьЭлементы(), "ОтчетДок", Стр.ОтчетДок);
		Если ДокументВладелец = Неопределено Тогда
			ДокументВладелец = ТаблицаСообщений.ПолучитьЭлементы().Добавить();
			ДокументВладелец.Отчет    = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(ПолучитьДанныеОтчетаДляПредставления(Стр.ОтчетДок));
			ДокументВладелец.ОтчетДок = Стр.ОтчетДок;
			Элементы.ТаблицаСообщений.Развернуть(ДокументВладелец.ПолучитьИдентификатор(), Истина);
		КонецЕсли;
		
		СхемаВладелец = РегламентированнаяОтчетностьКлиентСервер.НайтиЭлементВДанныхФормыДерево(ДокументВладелец.ПолучитьЭлементы(), "Отчет", Стр.Отчет);
		Если СхемаВладелец = Неопределено Тогда
			СхемаВладелец = ДокументВладелец.ПолучитьЭлементы().Добавить();
			СхемаВладелец.Отчет    = Стр.Отчет;
			СхемаВладелец.ОтчетДок = Стр.ОтчетДок;
			Элементы.ТаблицаСообщений.Развернуть(СхемаВладелец.ПолучитьИдентификатор(), Истина);
		КонецЕсли;
		
		НовСтр = СхемаВладелец.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		НовСтр.Отчет = Стр.ИмяЯчейки;
		
	КонецЦикла;
	
	Для Каждого Элемент Из ТаблицаСообщений.ПолучитьЭлементы() Цикл
		Для каждого Элемент2 Из Элемент.ПолучитьЭлементы() Цикл
			Элемент2.Описание = "Ошибок в форме: " + Элемент2.ПолучитьЭлементы().Количество();
		КонецЦикла;
	КонецЦикла;
							
	Для Каждого Стр Из ТаблицаСообщений.ПолучитьЭлементы() Цикл
		Если Стр.ПолучитьЭлементы().Количество() <> 0 Тогда
			Элементы.ТаблицаСообщений.ТекущаяСтрока = Стр.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	НадписьВсегоОшибок = "Всего ошибок: " + Формат(ВладелецТС.ТаблицаСообщений.Количество(), "ЧГ=")
						+ " в " + Формат(ТаблицаСообщений.ПолучитьЭлементы()[0].ПолучитьЭлементы().Количество(), "ЧГ=")
						+ ?(ТаблицаСообщений.ПолучитьЭлементы()[0].ПолучитьЭлементы().Количество() = 1, " форме", " формах");
		
КонецПроцедуры // ПриОткрытии()

// ПриЗакрытии()
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	ТаблицаСообщений.ПолучитьЭлементы().Очистить();
	
КонецПроцедуры // ПриЗакрытии()

// ТаблицаСообщенийВыбор()
//
&НаКлиенте
Процедура ТаблицаСообщенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// пропускаем строки первых двух уровней
	Если  НЕ Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено
		И НЕ Элемент.ТекущиеДанные.ПолучитьРодителя().ПолучитьРодителя() = Неопределено Тогда
		АктивизироватьЯчейку(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры // ТаблицаСообщенийВыбор()

// Процедура формирует необходимый набор параметров и вызывает экспортную
// процедуру формы регламентированного отчета, соответствующего переданной в качестве
// параметра строке ВыбраннаяСтрока. Вызываемая экспортная процедура активизирует
// описываемую ячейку одного из табличных документов, расположенных на форме.
//
// Параметры:
//	ВыбраннаяСтрока - строка табличного поля ТаблицаСообщений формы, ячейку, 
//						соответствующую которой, следует активизировать.
//
&НаКлиенте
Процедура АктивизироватьЯчейку(ВыбраннаяСтрока)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ТекДок = ВыбраннаяСтрока.ОтчетДок;
	Если ТекДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ячейка = Новый Структура("Раздел, Страница, Строка, Графа, СтрокаПП, ИмяЯчейки, Описание",
				ВыбраннаяСтрока.Раздел, ВыбраннаяСтрока.Страница, ВыбраннаяСтрока.Строка, ВыбраннаяСтрока.Графа, ВыбраннаяСтрока.СтрокаПП, ВыбраннаяСтрока.ИмяЯчейки, ВыбраннаяСтрока.Описание);
	
	Попытка
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета");
		ПараметрыФормы.Вставить("мСохраненныйДок");
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета");
		ПараметрыФормы.Вставить("Организация");
		ПараметрыФормы.Вставить("мВыбраннаяФорма");
		
		ФормаРеглОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьСсылкуНаФормуРеглОтчета(ТекДок, ПараметрыФормы);
		
		Если СтрЧислоВхождений(ФормаРеглОтчета, "ОтчетМенеджер") > 0 Тогда
			ФормаРеглОтчета = СтрЗаменить(ФормаРеглОтчета, "ОтчетМенеджер.", "");
			ФормаРеглОтчета = ПолучитьФорму("Отчет." + ФормаРеглОтчета, ПараметрыФормы, , ПараметрыФормы.мСохраненныйДок);
		КонецЕсли;
		
		ФормаРеглОтчета.Открыть();
		
		ФормаРеглОтчета.АктивизироватьЯчейку(Ячейка);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры // АктивизироватьЯчейку()

&НаСервере
Функция ПолучитьДанныеОтчетаДляПредставления(Ссылка)
	
	Данные = Новый Структура();
	Данные.Вставить("Отчет",    	 "");
	Данные.Вставить("ДатаНачала", 	 '0001-01-01');
	Данные.Вставить("ДатаОкончания", '0001-01-01');
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		
		Данные = Новый Структура();
		Данные.Вставить("Отчет", 		 Ссылка.НаименованиеОтчета);
		Данные.Вставить("НаименованиеОтчета", Ссылка.НаименованиеОтчета);
		Данные.Вставить("ДатаНачала", 	 Ссылка.ДатаНачала);
		Данные.Вставить("ДатаОкончания", Ссылка.ДатаОкончания);
	
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции