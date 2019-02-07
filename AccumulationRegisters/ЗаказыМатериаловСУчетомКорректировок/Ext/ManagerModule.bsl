﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//++ НЕ УТКА

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора) Экспорт

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗаказыМатериалов.Распоряжение          КАК Распоряжение,
		|	ТЗаказыМатериалов.КодСтроки             КАК КодСтроки,
		|	ТЗаказыМатериалов.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
		|	ТЗаказыМатериалов.Номенклатура          КАК Номенклатура,
		|	ТЗаказыМатериалов.Характеристика        КАК Характеристика,
		|	ТЗаказыМатериалов.Склад                 КАК Склад,
		|	ТЗаказыМатериалов.Серия                 КАК Серия
		|ПОМЕСТИТЬ ВТЗаказыМатериаловСУчетомКорректировок
		|ИЗ
		|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(,,,
		|			(Распоряжение, КодСтроки) В
		|					(ВЫБРАТЬ
		|						ВтОтбор.Ссылка,
		|						ВтОтбор.КодСтроки
		|					ИЗ
		|						ВтОтбор КАК ВтОтбор)
		|				И ВариантОбеспечения В (ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить),
		|											ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))) КАК ТЗаказыМатериалов
		|ГДЕ
		|	ТЗаказыМатериалов.КоличествоОборот > 0
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	КодСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТМатериалыИУслуги.Распоряжение                    КАК Ссылка,
		|	ТМатериалыИУслуги.КодСтроки                       КАК КодСтроки,
		|	МАКСИМУМ(ТМатериалыИУслуги.Номенклатура)          КАК Номенклатура,
		|	МАКСИМУМ(ТМатериалыИУслуги.Характеристика)        КАК Характеристика,
		|	МАКСИМУМ(ТМатериалыИУслуги.Склад)                 КАК Склад,
		|	МАКСИМУМ(ТМатериалыИУслуги.Серия)                 КАК Серия,
		|	СУММА(ТЗаказыМатериаловВПроизводство.КОформлению) КАК Количество
		|ИЗ
		|	ВТЗаказыМатериаловСУчетомКорректировок КАК ТМатериалыИУслуги
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство КАК ТЗаказыМатериаловВПроизводство
		|		ПО (ТЗаказыМатериаловВПроизводство.Распоряжение = ТМатериалыИУслуги.Распоряжение)
		|			И (ТЗаказыМатериаловВПроизводство.КодСтроки = ТМатериалыИУслуги.КодСтроки)
		|			И (ТЗаказыМатериаловВПроизводство.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход))
		|			И (ТЗаказыМатериаловВПроизводство.КОформлению <> 0)
		|			И (ТЗаказыМатериаловВПроизводство.Активность)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТМатериалыИУслуги.Распоряжение,
		|	ТМатериалыИУслуги.КодСтроки");
		
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

//Возвращает текст запроса заказанного количества из заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Не обеспечивать,Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказанного по заказам количества.
//
//Параметры:
//	ЕстьФильтр - Булево - Признак, определяющий необходимость предварительной фильтрации выборки по заказам,
//	                      передаваемым параметром "Заказы".
//
//Возвращаемое значение:
//	Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовКОбеспечению(ЕстьФильтр) Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТЗаказыМатериалов.Распоряжение          КАК Распоряжение,
		|	ТЗаказыМатериалов.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
		|	ТЗаказыМатериалов.КодСтроки             КАК КодСтроки,
		|
		|	ТЗаказыМатериалов.Номенклатура   КАК Номенклатура,
		|	ТЗаказыМатериалов.Характеристика КАК Характеристика,
		|	ТЗаказыМатериалов.Склад          КАК Склад,
		|	ТЗаказыМатериалов.Назначение     КАК Назначение,
		|	ТЗаказыМатериалов.Подразделение  КАК Подразделение,
		|	
		|	ТЗаказыМатериалов.ВариантОбеспечения КАК ВариантОбеспечения,
		|	ТЗаказыМатериалов.ДатаПотребности    КАК ДатаПотребности,
		|
		|	ТЗаказыМатериалов.Упаковка         КАК Упаковка,
		|	ТЗаказыМатериалов.КоличествоОборот КАК Количество
		|
		|ПОМЕСТИТЬ ВТЗаказыМатериаловСУчетомКорректировок
		|ИЗ
		|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(,,,
		|		{(Распоряжение).* КАК Заказ, (Склад).* КАК Склад}
		|		&Распоряжение
		|
		|	И(
		|		Распоряжение В(
		|			ВЫБРАТЬ
		|				Таблица.Ссылка КАК Распоряжение
		|			ИЗ
		|				Документ.ЗаказНаПроизводство КАК Таблица
		|			ГДЕ
		|				Таблица.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Создан))
		|		ИЛИ НЕ ПроизводствоНаСтороне)
		|		
		|	И Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|	И ВариантОбеспечения В(
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется),
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно),
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ИзЗаказов))) КАК ТЗаказыМатериалов
		|
		|ГДЕ
		|	ТЗаказыМатериалов.КоличествоОборот > 0
		|	
		|	И (ТЗаказыМатериалов.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
		|		ИЛИ ТЗаказыМатериалов.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно))";

	Если ЕстьФильтр Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Распоряжение", "Распоряжение В (&Заказы) И КодСтрокиРаспоряжения <> 0");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Распоряжение", "КодСтрокиРаспоряжения <> 0");
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	КодСтроки
		|;
		|
		|////////////////////////////////////////////
		|";
	
	Возврат ТекстЗапроса;

КонецФункции

//Возвращает текст запроса заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказов,
//содержащих указанную номенклатуру на указанном складе.
//
//Возвращаемое значение:
// Строка - текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры() Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТЗаказыМатериалов.Распоряжение КАК Заказ
		|
		|ИЗ
		|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(,,,
		|		{Склад.* КАК Склад, Номенклатура.* КАК Номенклатура}
		|		КодСтрокиРаспоряжения <> 0
		|		И Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|		И ВариантОбеспечения В(
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется),
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно),
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
		|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ИзЗаказов))) КАК ТЗаказыМатериалов
		|
		|ГДЕ
		|	ТЗаказыМатериалов.КоличествоОборот > 0
		|";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

//-- НЕ УТКА

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

//++ НЕ УТКА

//-- НЕ УТКА

#КонецОбласти

#КонецОбласти

#КонецЕсли
