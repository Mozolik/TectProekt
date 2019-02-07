﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ЗАПОЛНЕНИЯ МНОГООБОРОТНОЙ ТАРЫ В ДОКУМЕНТАХ

// Заполняет в документе подобранную обработкой многооборотную тару
//
// Параметры:
// Объект - ДокументОбъект - Документ, из которого необходимо подобрать многооборотную тару
// ИмяТаблицы - Строка - Имя таблицы документа, для которой необходимо подобрать многообротную тару
// ИменаКолонок - Строка - Имена колонок таблицы, по которым необходимо осуществлять подбор тары
// УникальныйИдентификатор - Строка - Уникальный идентификатор формы
// ИспользоватьСклад - Булево - Признак наличия склада в табличной части документа
// ИспользоватьДату - Булево - Признак наличия даты в табличной части документа
//
// Возвращаемое значение:
// Строка, Адрес во временном хранилище, в котором помещена тара
//
Функция ПоместитьТоварыДляПодбораТарыВоВременноеХранилище(Знач Объект,
	                                                      Знач ИмяТаблицы,
	                                                      Знач ИменаКолонок,
	                                                      Знач УникальныйИдентификатор,
	                                                      Знач ИспользоватьСклад,
	                                                      Знач ИспользоватьДату) Экспорт
	
	ТаблицаТоваров = Новый ТаблицаЗначений();
	ТаблицаТоваров.Колонки.Добавить("Номенклатура");
	ТаблицаТоваров.Колонки.Добавить("Характеристика");
	ТаблицаТоваров.Колонки.Добавить("Количество");
	ТаблицаТоваров.Колонки.Добавить("Склад");
	ТаблицаТоваров.Колонки.Добавить("Дата");
	
	МассивКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок, ",");
	
	ЕстьРеквизитНоменклатураНабора = Неопределено;
	Для Каждого ТекСтрока Из Объект[ИмяТаблицы] Цикл
		
		Если ЕстьРеквизитНоменклатураНабора = Неопределено Тогда
			Если ИмяТаблицы <> "Комплектующие" Тогда
				ЕстьРеквизитНоменклатураНабора = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ТекСтрока, "НоменклатураНабора");
			Иначе
				ЕстьРеквизитНоменклатураНабора = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьРеквизитНоменклатураНабора Тогда
			Если ЗначениеЗаполнено(ТекСтрока.НоменклатураНабора) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаТоваров.Добавить();
		НоваяСтрока.Номенклатура = ТекСтрока[МассивКолонок[0]];
		НоваяСтрока.Характеристика = ТекСтрока[МассивКолонок[1]];
		НоваяСтрока.Количество = ТекСтрока[МассивКолонок[2]];
		
		Если ИспользоватьСклад Тогда
			НоваяСтрока.Склад = ТекСтрока[МассивКолонок[3]];
		КонецЕсли;
		
		Если ИспользоватьДату Тогда
			НоваяСтрока.Дата = ТекСтрока[МассивКолонок[4]];
		КонецЕсли;
		
	КонецЦикла;
	
	АдресТоваровВоВременномХранилище = ПоместитьВоВременноеХранилище(
		ТаблицаТоваров,
		УникальныйИдентификатор);
		
	Возврат АдресТоваровВоВременномХранилище;
	
КонецФункции

// Проверяет наличие в документе товаров, для которых может потребоваться многооборотная тара
//
// Параметры:
// Объект - ДокументОбъект - Документ, из которого необходимо подобрать многооборотную тару
// ИмяТаблицы - Строка - Имя таблицы документа, для которой необходимо осуществлять проверку
// ИменаКолонок - Строка - Имена колонок таблицы, по которым необходимо осуществлять проверку
//
// Возвращаемое значение:
// Булево, Истина, если пользователю необходимо предложить добавить тару в документ
//
Функция ЗадаватьВопросОЗаполненииМногооборотнойТарой(Знач Объект,
	                                                 Знач ИмяТаблицы,
	                                                 Знач ИменаКолонок) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ПредлагатьДополнитьДокументыМногооборотнойТарой") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаТоваров = Новый ТаблицаЗначений();
	ТаблицаТоваров.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	
	МассивКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок, ",");
	
	Для Каждого ТекСтрока Из Объект[ИмяТаблицы] Цикл
		
		НоваяСтрока = ТаблицаТоваров.Добавить();
		НоваяСтрока.Номенклатура = ТекСтрока[МассивКолонок[0]];
		НоваяСтрока.Количество = ТекСтрока[МассивКолонок[2]];
		
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаДокументаИсходная.Номенклатура КАК Номенклатура,
	|	ТаблицаДокументаИсходная.Количество КАК Количество
	|ПОМЕСТИТЬ
	|	ТаблицаДокументаИсходная
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокументаИсходная
	|;
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	СУММА(ТаблицаДокумента.Количество) КАК Количество
	|ПОМЕСТИТЬ
	|	ТаблицаДокумента
	|ИЗ
	|	ТаблицаДокументаИсходная КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Номенклатура
	|;
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Количество КАК Количество,
	|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК Коэффициент,
	|	ЕСТЬNULL(УпаковкиНоменклатуры.МинимальноеКоличествоУпаковокМногооборотнойТары, 0) КАК МинимальноеКоличество
	|ПОМЕСТИТЬ
	|	УпаковкиВТаре
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|ПО
	|	(ТаблицаДокумента.Номенклатура.НаборУпаковок = УпаковкиНоменклатуры.Владелец
	|	ИЛИ (ТаблицаДокумента.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|		И ТаблицаДокумента.Номенклатура = УпаковкиНоменклатуры.Владелец))
	|ГДЕ
	|	УпаковкиНоменклатуры.ПоставляетсяВМногооборотнойТаре
	|	И НЕ УпаковкиНоменклатуры.ПометкаУдаления
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	УпаковкиВТаре.Номенклатура КАК Номенклатура
	|ИЗ
	|	УпаковкиВТаре КАК УпаковкиВТаре 
	|ГДЕ
	|	УпаковкиВТаре.Количество / УпаковкиВТаре.Коэффициент >= 1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Номенклатура.ПоставляетсяВМногооборотнойТаре
	|");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"УпаковкиНоменклатуры",
		"ТаблицаДокумента.Номенклатура"));
		
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаТоваров);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции
