﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентСервер: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует текст сообщения, подставляя значения
// параметров в шаблоны сообщений.
//
// Параметры
//  ВидПоля       - Строка - может принимать значения:
//                  Поле, Колонка, Список
//  ВидСообщения  - Строка - может принимать значения:
//                  Заполнение, Корректность
//  Параметр1     - Строка - имя поля
//  Параметр2     - Строка - номер строки
//  Параметр3     - Строка - имя списка
//  Параметр4     - Строка - текст сообщения о некорректности заполнения
//
// Возвращаемое значение:
//   Строка - текст сообщения
//
Функция ТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение",
	Параметр1 = "", Параметр2 = "",	Параметр3 = "", Параметр4 = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Поле ""%1"" не заполнено.';uk='Поле ""%1"" не заповнене.'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Поле ""%1"" заполнено некорректно.
                           |
                           |%4'
                           |;uk='Поле ""%1"" заповнене некоректно.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Не заполнена колонка ""%1"" в строке %2 списка ""%3"".';uk='Не заповнена колонка ""%1"" в рядку %2 списку ""%3"".'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
                           |
                           |%4'
                           |;uk='Некоректно заповнена колонка ""%1"" у рядку %2 списку ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Не введено ни одной строки в список ""%3"".';uk='Не введено жодного рядка в список ""%3"".'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Некорректно заполнен список ""%3"".
                           |
                           |%4'
                           |;uk='Некоректно заповнений список ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметр1, Параметр2, Параметр3, Параметр4);

КонецФункции

// Определяет необходимость конкретного действия из перечня действий.
//
// Параметры:
//  ПереченьДействий - Строка, перечень действий, которые должны быть совершены с объектом
//  Действие - Строка, конкретное действие, которое нужно найти в перечне действий
// 
// Возвращаемое значение:
//  Булево - Если действие найдено - возвращается Истина, иначе Ложь
//
Функция ЕстьДействие(ПереченьДействий, Действие) Экспорт
	
	Возврат (СтрНайти(ПереченьДействий, Действие) > 0);
	
КонецФункции

#КонецОбласти