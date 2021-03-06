﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция ТекстЗапросаОстатков предназначена для получения остатков регистра
// в разрезе номенклатуры, характеристики и склада.
//
// Параметры:
//  ИспользоватьКорректировку - Булево - признак необходимости скорректировать движения регистра перед получением остатков.
//  Разделы - Массив - массив в который будет добавлена информация о временных таблицах создаваемых при выполнении запроса
//
// Возвращаемое значение:
//  Строка - Текст запроса свободного остатка регистра в разрезе номенклатуры, характеристики и склада
//
Функция ТекстЗапросаОстатков(ИспользоватьКорректировку, Разделы = Неопределено) Экспорт

	Если Не ИспользоватьКорректировку Тогда
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Т.Номенклатура           КАК Номенклатура,
			|	Т.Характеристика         КАК Характеристика,
			|	Т.Склад                  КАК Склад,
			|
			|	Т.ВНаличииОстаток
			|		- Т.ВРезервеСоСкладаОстаток
			|		- Т.ВРезервеПодЗаказОстаток КАК Количество
			|
			|ПОМЕСТИТЬ ВтОстаткиСклада
			|ИЗ
			|	РегистрНакопления.СвободныеОстатки.Остатки(,
			|		(Номенклатура, Характеристика, Склад) В(
			|			ВЫБРАТЬ
			|				Ключи.Номенклатура   КАК Номенклатура,
			|				Ключи.Характеристика КАК Характеристика,
			|				Ключи.Склад          КАК Склад
			|			ИЗ
			|				ВтТовары КАК Ключи
			|		)) КАК Т
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Склад
			|;
			|
			|/////////////////////////////////////////////////////////////
			|";
	Иначе
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	НаборДанных.Номенклатура           КАК Номенклатура,
			|	НаборДанных.Характеристика         КАК Характеристика,
			|	НаборДанных.Склад                  КАК Склад,
			|
			|	СУММА(НаборДанных.Количество)      КАК Количество
			|
			|ПОМЕСТИТЬ ВтОстаткиСклада
			|ИЗ (
			|	ВЫБРАТЬ
			|		Т.Номенклатура           КАК Номенклатура,
			|		Т.Характеристика         КАК Характеристика,
			|		Т.Склад                  КАК Склад,
			|
			|		Т.ВНаличииОстаток
			|			- Т.ВРезервеСоСкладаОстаток
			|			- Т.ВРезервеПодЗаказОстаток КАК Количество
			|
			|	ИЗ
			|		РегистрНакопления.СвободныеОстатки.Остатки(,
			|			(Номенклатура, Характеристика, Склад) В(
			|				ВЫБРАТЬ
			|					Ключи.Номенклатура   КАК Номенклатура,
			|					Ключи.Характеристика КАК Характеристика,
			|					Ключи.Склад          КАК Склад
			|				ИЗ
			|					ВтТовары КАК Ключи
			|			)) КАК Т
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		Т.Номенклатура            КАК Номенклатура,
			|		Т.Характеристика          КАК Характеристика,
			|		Т.Склад                   КАК Склад,
			|
			|		- Т.ВРезерве - Т.КОтгрузке КАК Количество
			|
			|	ИЗ
			|		ВтТоварыКОтгрузкеКорректировка КАК Т
			|	ГДЕ
			|		Т.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|
			|	) КАК НаборДанных
			|
			|СГРУППИРОВАТЬ ПО
			|	НаборДанных.Номенклатура, НаборДанных.Характеристика, НаборДанных.Склад
			|ИМЕЮЩИЕ
			|	СУММА(НаборДанных.Количество) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Склад
			|;
			|
			|/////////////////////////////////////////////////////////////
			|";
	КонецЕсли;

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаОстаткиСклада");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
	
	ИмяРегистра = "СвободныеОстатки";
	ПолноеИмяРегистра = "РегистрНакопления." + ИмяРегистра;

#Область ЗаказКлиента
	ТекстЗапросаМеханизмаПроведения = Документы.ЗаказКлиента.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ЗаказКлиента"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	Документы.ЗаказКлиента.ИсправлениеДвиженийСвободныеОстаткиЗарегистрироватьДанныеДляКОбработке(Параметры);

#КонецОбласти

#Область РеализацияТоваровУслуг
	ТекстЗапросаМеханизмаПроведения = Документы.РеализацияТоваровУслуг.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.РеализацияТоваровУслуг"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область ЗаказНаВнутреннееПотребление
	ТекстЗапросаМеханизмаПроведения = Документы.ЗаказНаВнутреннееПотребление.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ЗаказНаВнутреннееПотребление"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область ВнутреннееПотреблениеТоваров
	ТекстЗапросаМеханизмаПроведения = Документы.ВнутреннееПотреблениеТоваров.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ВнутреннееПотреблениеТоваров"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
	// ЗаполнитьЗаказНаВнутреннееПотреблениеВСтрокахСверхЗаказаОтложенно
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК ТЧДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВнутреннееПотреблениеТоваров КАК ШапкаДокумента
	|		ПО ТЧДокумента.Ссылка = ШапкаДокумента.Ссылка
	|ГДЕ
	|	ШапкаДокумента.Проведен
	|	И ТЧДокумента.КодСтроки = 0
	|	И ТЧДокумента.ЗаказНаВнутреннееПотребление В(&ПустыеЗначенияЗаказов)
	|	И ШапкаДокумента.ПотреблениеПоЗаказам";
	
	Запрос.УстановитьПараметр("ПустыеЗначенияЗаказов", Документы.ВнутреннееПотреблениеТоваров.ПустыеЗначенияЗаказов());
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
#КонецОбласти

#Область ЗаказНаПеремещение
	ТекстЗапросаМеханизмаПроведения = Документы.ЗаказНаПеремещение.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ЗаказНаПеремещение"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область ПеремещениеТоваров
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА Товары.КодСтроки = 0
	|				ТОГДА Товары.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоВНаличии,
	|	СУММА(ВЫБОР
	|			КОГДА Товары.КодСтроки = 0
	|					И Товары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|				ТОГДА Товары.Количество
	|		КОНЕЦ) КАК КоличествоВРезервеПодЗаказ
	|ПОМЕСТИТЬ КоличествоВНакладной
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка.Проведен
	|	И Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВНаличии, 0)) КАК ВНаличии,
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВРезервеСоСклада, 0)) КАК ВРезервеСоСклада,
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВРезервеПодЗаказ, 0)) КАК ВРезервеПодЗаказ,
	|	КоличествоВНакладной.Ссылка,
	|	КоличествоВНакладной.КоличествоВНаличии,
	|	КоличествоВНакладной.КоличествоВРезервеПодЗаказ
	|ПОМЕСТИТЬ ОбщееКоличество
	|ИЗ
	|	КоличествоВНакладной КАК КоличествоВНакладной
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки КАК СвободныеОстатки
	|		ПО (СвободныеОстатки.Регистратор = КоличествоВНакладной.Ссылка)
	|ГДЕ
	|	СвободныеОстатки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоВНакладной.Ссылка,
	|	КоличествоВНакладной.КоличествоВНаличии,
	|	КоличествоВНакладной.КоличествоВРезервеПодЗаказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбщееКоличество.Ссылка
	|ПОМЕСТИТЬ ДокументыДляОбновления
	|ИЗ
	|	ОбщееКоличество КАК ОбщееКоличество
	|ГДЕ
	|	(ОбщееКоличество.ВНаличии <> ОбщееКоличество.КоличествоВНаличии
	|			ИЛИ ОбщееКоличество.ВРезервеПодЗаказ <> ОбщееКоличество.КоличествоВРезервеПодЗаказ
	|			ИЛИ ОбщееКоличество.ВРезервеСоСклада <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыРасхождения.Ссылка КАК ДокументОснование
	|ПОМЕСТИТЬ ВтПеренестиРасхожденияВАктыМонопольно
	|ИЗ
	|	Документ.ПеремещениеТоваров.УдалитьРасхожденияТовары КАК ТоварыРасхождения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров КАК Накладная
	|		ПО (Накладная.Ссылка = ТоварыРасхождения.Ссылка)
	|			И (Накладная.Проведен)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ТоварыНакладной
	|		ПО (ТоварыНакладной.Ссылка = ТоварыРасхождения.Ссылка)
	|			И (ТоварыНакладной.ИдентификаторСтроки = ТоварыРасхождения.ИдентификаторСтроки)
	|ГДЕ
	|	Накладная.СкладОтправитель.ИспользоватьОрдернуюСхемуПриОтгрузке
	|	И Накладная.Дата >= Накладная.СкладОтправитель.ДатаНачалаОрдернойСхемыПриОтгрузке
	|	И (ТоварыРасхождения.КоличествоРасхождение <> 0
	|			ИЛИ ТоварыРасхождения.ЕстьРасхождениеПоСериям = 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыДляОбновления.Ссылка КАК Регистратор
	|ИЗ
	|	ДокументыДляОбновления КАК ДокументыДляОбновления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВтПеренестиРасхожденияВАктыМонопольно.ДокументОснование
	|ИЗ
	|	ВтПеренестиРасхожденияВАктыМонопольно КАК ВтПеренестиРасхожденияВАктыМонопольно";
    
    Регистраторы  = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область ЗаказНаСборку
	ТекстЗапросаМеханизмаПроведения = Документы.ЗаказНаСборку.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ЗаказНаСборку"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
	Регистраторы = Документы.ЗаказНаСборку.ЗаказыНаРазборкуКоторыеНужноРазбитьПередЗаполнениемСерий();
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
	Регистраторы = Документы.ЗаказНаСборку.РазборкиКоторыеНужноРазбитьПоВариантуОбеспечения();
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область СборкаТоваров

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КоличествоВНаличииПоДокументу.Ссылка,
	|	СУММА(КоличествоВНаличииПоДокументу.КоличествоВНаличии) КАК КоличествоВНаличии,
	|	СУММА(КоличествоВНаличииПоДокументу.КоличествоВРезервеПодЗаказ) КАК КоличествоВРезервеПодЗаказ
	|ПОМЕСТИТЬ КоличествоВНакладной
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Ссылка КАК Ссылка,
	|		ВЫБОР
	|			КОГДА Товары.Ссылка.ЗаказНаСборку = ЗНАЧЕНИЕ(Документ.ЗаказНаСборку.ПустаяСсылка)
	|				ТОГДА Товары.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК КоличествоВНаличии,
	|		ВЫБОР
	|			КОГДА Товары.Ссылка.ЗаказНаСборку = ЗНАЧЕНИЕ(Документ.ЗаказНаСборку.ПустаяСсылка)
	|					И Товары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|				ТОГДА Товары.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК КоличествоВРезервеПодЗаказ
	|	ИЗ
	|		Документ.СборкаТоваров.Товары КАК Товары
	|	ГДЕ
	|		Товары.Ссылка.Проведен
	|		И Товары.Ссылка.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыОперацийЗаказаНаСборку.СборкаИзКомплектующих)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СборкаТоваров.Ссылка,
	|		ВЫБОР
	|			КОГДА СборкаТоваров.ЗаказНаСборку = ЗНАЧЕНИЕ(Документ.ЗаказНаСборку.ПустаяСсылка)
	|				ТОГДА СборкаТоваров.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА СборкаТоваров.ЗаказНаСборку = ЗНАЧЕНИЕ(Документ.ЗаказНаСборку.ПустаяСсылка)
	|					И СборкаТоваров.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|				ТОГДА СборкаТоваров.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		Документ.СборкаТоваров КАК СборкаТоваров
	|	ГДЕ
	|		СборкаТоваров.Проведен
	|		И СборкаТоваров.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыОперацийЗаказаНаСборку.РазборкаНаКомплектующие)) КАК КоличествоВНаличииПоДокументу
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоВНаличииПоДокументу.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВНаличии, 0)) КАК ВНаличии,
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВРезервеСоСклада, 0)) КАК ВРезервеСоСклада,
	|	СУММА(ЕСТЬNULL(СвободныеОстатки.ВРезервеПодЗаказ, 0)) КАК ВРезервеПодЗаказ,
	|	КоличествоВНакладной.Ссылка,
	|	КоличествоВНакладной.КоличествоВНаличии,
	|	КоличествоВНакладной.КоличествоВРезервеПодЗаказ
	|ПОМЕСТИТЬ ОбщееКоличество
	|ИЗ
	|	КоличествоВНакладной КАК КоличествоВНакладной
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки КАК СвободныеОстатки
	|		ПО (СвободныеОстатки.Регистратор = КоличествоВНакладной.Ссылка)
	|ГДЕ
	|	СвободныеОстатки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоВНакладной.Ссылка,
	|	КоличествоВНакладной.КоличествоВНаличии,
	|	КоличествоВНакладной.КоличествоВРезервеПодЗаказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбщееКоличество.Ссылка КАК Регистратор
	|ИЗ
	|	ОбщееКоличество КАК ОбщееКоличество
	|ГДЕ
	|	(ОбщееКоличество.ВНаличии <> ОбщееКоличество.КоличествоВНаличии
	|			ИЛИ ОбщееКоличество.ВРезервеПодЗаказ <> ОбщееКоличество.КоличествоВРезервеПодЗаказ
	|			ИЛИ ОбщееКоличество.ВРезервеСоСклада <> 0)";
    
    Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область ЗаявкаНаВозвратТоваровОтКлиента
	ТекстЗапросаМеханизмаПроведения = Документы.ЗаявкаНаВозвратТоваровОтКлиента.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ЗаявкаНаВозвратТоваровОтКлиента"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ИсправлениеДвиженийСвободныеОстаткиЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти

#Область ПриходныйОрдерНаТовары
	ТекстЗапросаМеханизмаПроведения = Документы.ПриходныйОрдерНаТовары.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
        ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ПриходныйОрдерНаТовары"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти


#Область АктОРасхожденияхПослеОтгрузки
	ТекстЗапросаМеханизмаПроведения = Документы.АктОРасхожденияхПослеОтгрузки.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.АктОРасхожденияхПослеОтгрузки"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

#Область АктОРасхожденияхПослеПеремещения
	ТекстЗапросаМеханизмаПроведения = Документы.АктОРасхожденияхПослеПеремещения.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.АктОРасхожденияхПослеПеремещения"
    );
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти

КонецПроцедуры

Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ЗаказКлиента");
	Регистраторы.Добавить("Документ.РеализацияТоваровУслуг");
	Регистраторы.Добавить("Документ.ЗаказНаВнутреннееПотребление");
	Регистраторы.Добавить("Документ.ВнутреннееПотреблениеТоваров");
	Регистраторы.Добавить("Документ.ЗаказНаПеремещение");
	Регистраторы.Добавить("Документ.ПеремещениеТоваров");
	Регистраторы.Добавить("Документ.ЗаказНаСборку");
	Регистраторы.Добавить("Документ.СборкаТоваров");
	Регистраторы.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	Регистраторы.Добавить("Документ.ПриходныйОрдерНаТовары");
	Регистраторы.Добавить("Документ.АктОРасхожденияхПослеПеремещения");
	Регистраторы.Добавить("Документ.АктОРасхожденияхПослеОтгрузки");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		"РегистрНакопления.СвободныеОстатки",
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти

#КонецЕсли