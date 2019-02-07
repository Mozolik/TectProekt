﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "НаборыВызовСервера", содержит процедуры и функции для
// работы с наборами
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет, является ли поле блокируемым элементом подсистемы наборов
// 
// Параметры:
//  Поле - Поле формы
//
// Возвращаемое значение:
//  Булево - результат проверки
Функция БлокируемыйЭлемент(Поле) Экспорт
	
	БлокируемыеЭлементы = НаборыКлиентСервер.БлокируемыеЭлементы();
	
	Если БлокируемыеЭлементы.Найти(Поле.Имя) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура обработчик события ПередУдалением
// 
// Параметры:
//  ДанныеФормы - Данные формы
//  ИмяТЧ       - Строка, Имя табличной части
//  Отказ       - Булево
//  Копирование - Булево
//
// Возвращаемое значение:
//  Нет
Процедура ПередУдалениемСтрокиТабличнойЧасти(ДанныеФормы, ИмяТЧ, Отказ, Копирование = Ложь) Экспорт
	
	Форма = ПолучитьУправляемуюФорму(ДанныеФормы);
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		ТЧ = Форма.Объект[ИмяТЧ];
	Иначе
		ТЧ = Форма[ИмяТЧ];
	КонецЕсли;
	
	Если Форма.Элементы[ИмяТЧ].ВыделенныеСтроки.Количество() = ТЧ.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Наборы", Новый Массив);
	Параметры.Вставить("Прочее", Новый Массив);
	Параметры.Вставить("ИмяТЧ", ИмяТЧ);
	Параметры.Вставить("Копирование", Копирование);
	
	ПроверятьКодСтроки = Ложь;
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Ссылка") Тогда
		ПроверятьКодСтроки = ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		                 ИЛИ ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктВыполненныхРабот");
	КонецЕсли;
	
	НайденНабор = Ложь;
	Для каждого ИдентификаторВыделеннойСтроки Из Форма.Элементы[ИмяТЧ].ВыделенныеСтроки Цикл
		СтрокаТЧ = ТЧ.НайтиПоИдентификатору(ИдентификаторВыделеннойСтроки);
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "НоменклатураНабора")
			И ЗначениеЗаполнено(СтрокаТЧ.НоменклатураНабора)
			И ( Не ПроверятьКодСтроки
			   ИЛИ (ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "КодСтроки") И СтрокаТЧ.КодСтроки = 0)
			   ИЛИ НЕ ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "КодСтроки")) Тогда
			НайденНабор = Истина;
			
			ПараметрыНабора = Новый Структура;
			ПараметрыНабора.Вставить("НоменклатураНабора", СтрокаТЧ.НоменклатураНабора);
			ПараметрыНабора.Вставить("ХарактеристикаНабора", СтрокаТЧ.ХарактеристикаНабора);
			
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "ЗаказКлиента") Тогда
				ПараметрыНабора.Вставить("ЗаказКлиента", СтрокаТЧ.ЗаказКлиента);
			КонецЕсли;
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "ДокументРеализации") Тогда
				ПараметрыНабора.Вставить("ДокументРеализации", СтрокаТЧ.ДокументРеализации);
			КонецЕсли;
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "КодСтроки") И СтрокаТЧ.КодСтроки = 0 Тогда
				ПараметрыНабора.Вставить("КодСтроки", 0);
			КонецЕсли;
			
			НаборДобавлен = Ложь;
			Для Каждого СтрокаНабора Из Параметры.Наборы Цикл
				ЕстьОтличия = Ложь;
				Для Каждого КлючИЗначение Из ПараметрыНабора Цикл
					Если СтрокаНабора[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
						ЕстьОтличия = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ ЕстьОтличия Тогда
					НаборДобавлен = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не НаборДобавлен Тогда
				Параметры.Наборы.Добавить(ПараметрыНабора);
			КонецЕсли;
			
		Иначе
			Параметры.Прочее.Добавить(СтрокаТЧ.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
	Если НайденНабор Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриУдаленииКомплектующих", Форма, Параметры);
		
		ОткрытьФорму("Обработка.РедактированиеНабора.Форма.УдалениеСтрокиНабора",
			Параметры,
			Форма,
			Форма.УникальныйИдентификатор,,,
			ОписаниеОповещения);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик события ПриУдалении
// 
// Параметры:
//  Форма     - Форма
//  ИмяТЧ     - Строка, Имя табличной части
//  Действие  - Строка ("РедактироватьНабор", "УдалитьВесьНабор")
//  Параметры - Структура (Наборы, Прочее)
//
// Возвращаемое значение:
//  Нет
Процедура ПриУдаленииКомплектующих(Форма, ИмяТЧ, Параметры) Экспорт
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("НоменклатураНабора",   Параметры.Наборы[0].НоменклатураНабора);
	ПараметрОповещения.Вставить("ХарактеристикаНабора", Параметры.Наборы[0].ХарактеристикаНабора);
	ПараметрОповещения.Вставить("ФормаВладелец",        Форма.УникальныйИдентификатор);
	ПараметрОповещения.Вставить("ИмяТЧ",                ИмяТЧ);
	
	Оповестить("РедактироватьНабор", ПараметрОповещения, Форма);
	
КонецПроцедуры

// Процедура проверки заполнения в части наборов
// 
// Параметры:
//  Форма     - Форма
//  Отказ     - Булево
//
// Возвращаемое значение:
//  Нет
Процедура ПроверитьЗаполнение(Форма, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(Форма.ВариантРаспределенияЦены) Тогда
		ТекстОшибки = НСтр("ru='Не заполнено поле ""Вариант распределения цены"".';uk='Не заповнене поле ""Варіант розподілу ціни"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"ВариантРаспределенияЦены",
			,
			Отказ);
	КонецЕсли;
	
	Если Форма.Товары.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru='Не введено ни одной строки в список ""Комплектующие"".';uk='Не введено жодного рядка в список ""Комплектуючі"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Товары",
			,
			Отказ);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Форма.Товары Цикл
		
		НомерСтроки = Форма.Товары.Индекс(СтрокаТЧ) + 1;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Номенклатура"" в строке ""%НомерСтроки%"" списка ""Комплектующие""';uk='Не заповнена колонка ""Номенклатура"" в рядку ""%НомерСтроки%"" списку ""Комплектуючі""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Номенклатура"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Характеристика) И СтрокаТЧ.ХарактеристикиИспользуются Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Характеристика"" в строке ""%НомерСтроки%"" списка ""Комплектующие""';uk='Не заповнена колонка ""Характеристика"" в рядку ""%НомерСтроки%"" списку ""Комплектуючі""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Характеристика"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.КоличествоУпаковок) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Количество"" в строке ""%НомерСтроки%"" списка ""Комплектующие""';uk='Не заповнена колонка ""Кількість"" в рядку ""%НомерСтроки%"" списку ""Комплектуючі""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "КоличествоУпаковок"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура дополняет массив строк табличной части оставшимися строками наборов,
// если указанные наборы в массиве строк представлены не полностью.
// 
// Параметры:
//  ТабличнаяЧасть - ТабличнаяЧасть
//  МассивСтрок - Массив строк табличной часи
//
// Возвращаемое значение:
//  Нет
Процедура ДополнитьДоПолногоНабора(ТабличнаяЧасть, МассивСтрок) Экспорт
	
	ДобавляемыеСтроки = Новый Массив;
	
	Для Каждого СтрокаТЧ Из МассивСтрок Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НоменклатураНабора) Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("НоменклатураНабора", СтрокаТЧ.НоменклатураНабора);
			Отбор.Вставить("ХарактеристикаНабора", СтрокаТЧ.ХарактеристикаНабора);
			
			НайденныеСтроки = ТабличнаяЧасть.НайтиСтроки(Отбор);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если МассивСтрок.Найти(НайденнаяСтрока) = Неопределено Тогда
					 ДобавляемыеСтроки.Добавить(НайденнаяСтрока);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ДобавляемыеСтроки Цикл
		МассивСтрок.Добавить(СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры

// Процедура управляет видимостью элементов в формах настройки состава набора
// если указанные наборы в массиве строк представлены не полностью.
// 
// Параметры:
//  ТабличнаяЧасть - ТабличнаяЧасть
//  МассивСтрок - Массив строк табличной часи
//
// Возвращаемое значение:
//  Нет
Процедура ИзменитьВидимостьПредупрежденияОбОграниченииНастроек(Форма) Экспорт
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ВариантПредставленияНабораВПечатныхФормах") Тогда
		ВариантПредставленияНабораВПечатныхФормах = Форма.ВариантПредставленияНабораВПечатныхФормах;
	Иначе
		ВариантПредставленияНабораВПечатныхФормах = Форма.Объект.ВариантПредставленияНабораВПечатныхФормах;
	КонецЕсли;
	
	ВариантЗаданияЦены = Форма.ВариантЗаданияЦены;
	
	Форма.Элементы.ГруппаПредупреждениеНаборы.Видимость = 
		(ВариантПредставленияНабораВПечатныхФормах = ПредопределенноеЗначение("Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор")
		ИЛИ ВариантЗаданияЦены = 1);
		
КонецПроцедуры

// Функция проверяет выполнение действия "РедактироватьНабор"
Функция ДействиеРедактироватьНабор(Действие) Экспорт
	Возврат Действие = "РедактироватьНабор"
КонецФункции

// Функция проверяет выполнение действия "УдалитьВесьНабор"
Функция ДействиеУдалитьВесьНабор(Действие) Экспорт
	Возврат Действие = "УдалитьВесьНабор"
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьУправляемуюФорму(ДанныеФормы)
	
	Если ТипЗнч(ДанныеФормы) = Тип("УправляемаяФорма") Тогда
		Возврат ДанныеФормы;
	Иначе
		Возврат ПолучитьУправляемуюФорму(ДанныеФормы.Родитель);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
