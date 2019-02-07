﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует список материалов по заказам
// - по не закрытым заказам на производство и заказам материалов
// - по заказам на производство, по которым остались не переданные в производство материалы
//
// Параметры:
//  ТаблицаМатериалов	- ТаблицаЗначений - содержит материалы для которых нужно ввести корректировку
//
Процедура ЗаполнитьВводКорректировкиЗаказаМатериаловПоМатериалам(ТаблицаМатериалов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаМатериалов.Организация    КАК Организация,
	|	ТаблицаМатериалов.Номенклатура   КАК Номенклатура,
	|	ТаблицаМатериалов.Характеристика КАК Характеристика,
	|	ТаблицаМатериалов.Назначение     КАК Назначение,
	|	ТаблицаМатериалов.Подразделение  КАК Подразделение
	|ПОМЕСТИТЬ ТаблицаМатериалов
	|ИЗ
	|	&ТаблицаМатериалов КАК ТаблицаМатериалов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ТаблицаЗаказов
	|ИЗ
	|	Документ.ЗаказНаПроизводство КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Проведен
	|	И ТаблицаДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.КПроизводству)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказыМатериаловОстатки.Распоряжение
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(, Распоряжение ССЫЛКА Документ.ЗаказНаПроизводство) КАК ЗаказыМатериаловОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка
	|ИЗ
	|	Документ.ЗаказМатериаловВПроизводство КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовМатериаловВПроизводство.Закрыт)
	|	И ТаблицаДокумента.Проведен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ЗаказыМатериаловОбороты.Распоряжение ССЫЛКА Документ.ЗаказНаПроизводство
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Приоритет,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.НомерСтроки, ЗаказМатериаловМатериалыИУслуги.НомерСтроки) КАК Порядок,
	|	ЗаказыМатериаловОбороты.Распоряжение КАК Ссылка,
	|	ЗаказыМатериаловОбороты.Организация,
	|	ЗаказыМатериаловОбороты.Подразделение,
	|	ЗаказыМатериаловОбороты.КодСтроки,
	|	ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения,
	|	ЗаказыМатериаловОбороты.Склад,
	|	ЗаказыМатериаловОбороты.ВариантОбеспечения,
	|	ЗаказыМатериаловОбороты.ДатаПотребности,
	|	ЗаказыМатериаловОбороты.Серия,
	|	ЗаказыМатериаловОбороты.Отменено,
	|	ЗаказыМатериаловОбороты.Упаковка,
	|	ЗаказыМатериаловОбороты.КоличествоОборот КАК Количество,
	|	ЗаказыМатериаловОбороты.КоличествоУпаковокОборот КАК КоличествоУпаковок,
	|	ЗаказыМатериаловОбороты.Номенклатура,
	|	ЗаказыМатериаловОбороты.Характеристика,
	|	ЗаказыМатериаловОбороты.Назначение,
	|	ЗаказыМатериаловОбороты.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказыМатериаловОбороты.Распоряжение.ПроизводствоПоЗаказу КАК ПроизводствоПоЗаказу,
	|	ЗаказыМатериаловОбороты.Распоряжение.Назначение КАК НазначениеЗаказа,
	|	ЕСТЬNULL(ЗаказНаПроизводствоПродукция.Назначение, НЕОПРЕДЕЛЕНО) КАК НазначениеПродукции,
	|	ЗаказыМатериаловОбороты.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ЗаказыМатериаловОбороты.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ЗаказыМатериаловОбороты.Серия.Представление КАК СерияПредставление,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе КАК ПроизводитсяВПроцессе,
	|	ЕСТЬNULL(ЗаказНаПроизводствоПродукция.КодСтроки, 0) КАК КодСтрокиПродукция,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.Этап, НЕОПРЕДЕЛЕНО) КАК Этап,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция, НЕОПРЕДЕЛЕНО) КАК КлючСвязиПродукция,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиЭтапыСтрока, """") КАК КлючСвязиЭтапыСтрока,
	|	ЕСТЬNULL(ЗаказыМатериаловВПроизводствоОстатки.КОформлениюОстаток, 0) КАК КоличествоОсталосьОтгрузить
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(
	|			,
	|			,
	|			,
	|			НЕ ПроизводствоНаСтороне
	|				И Распоряжение В
	|					(ВЫБРАТЬ
	|						ТаблицаЗаказов.Ссылка
	|					ИЗ
	|						ТаблицаЗаказов)
	|				И (Организация, Номенклатура, Характеристика, Подразделение, Назначение) В
	|					(ВЫБРАТЬ
	|						ТаблицаМатериалов.Организация,
	|						ТаблицаМатериалов.Номенклатура,
	|						ТаблицаМатериалов.Характеристика,
	|						ТаблицаМатериалов.Подразделение,
	|						ТаблицаМатериалов.Назначение
	|					ИЗ
	|						ТаблицаМатериалов)) КАК ЗаказыМатериаловОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|		ПО (ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки = ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ЗаказНаПроизводствоПродукция
	|		ПО (ЗаказНаПроизводствоПродукция.Ссылка = ЗаказНаПроизводствоМатериалыИУслуги.Ссылка)
	|			И (ЗаказНаПроизводствоПродукция.КлючСвязи = ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказМатериаловВПроизводство.Товары КАК ЗаказМатериаловМатериалыИУслуги
	|		ПО (ЗаказМатериаловМатериалыИУслуги.Ссылка = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказМатериаловМатериалыИУслуги.КодСтроки = ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(
	|				,
	|				Распоряжение В
	|					(ВЫБРАТЬ
	|						ТаблицаЗаказов.Ссылка
	|					ИЗ
	|						ТаблицаЗаказов)) КАК ЗаказыМатериаловВПроизводствоОстатки
	|		ПО (ЗаказыМатериаловВПроизводствоОстатки.Распоряжение = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Характеристика = ЗаказыМатериаловОбороты.Характеристика)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.КодСтроки = ЗаказыМатериаловОбороты.КодСтроки)
	|ГДЕ
	|	(НЕ ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе, ЛОЖЬ)
	|		ИЛИ ЗаказыМатериаловОбороты.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|	И ЗаказыМатериаловОбороты.Номенклатура.ТипНоменклатуры В (
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	Порядок";
	
	Запрос.УстановитьПараметр("ТаблицаМатериалов", ТаблицаМатериалов);
	
	МатериалыИУслуги.Очистить();
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЗаполнитьМатериалыИУслуги(Выборка);
	
КонецПроцедуры

// Заполняет данные для ввода корректировки заказа материалов
//
// Параметры:
//  СписокЗаказов		- Массив - содержит массив заказов
//  КлючСвязиПродукция	- УникальныйИдентификатор - ключ строки продукции
//
Процедура ЗаполнитьВводКорректировкиЗаказаМатериаловПоЗаказам(СписокЗаказов, КлючСвязиПродукция = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказНаПроизводствоМатериалыИУслуги.НомерСтроки КАК Порядок,
	|	ЗаказыМатериаловОбороты.Распоряжение КАК Ссылка,
	|	ЗаказыМатериаловОбороты.Организация,
	|	ЗаказыМатериаловОбороты.Подразделение,
	|	ЗаказыМатериаловОбороты.КодСтроки,
	|	ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения,
	|	ЗаказыМатериаловОбороты.Склад,
	|	ЗаказыМатериаловОбороты.ВариантОбеспечения,
	|	ЗаказыМатериаловОбороты.ДатаПотребности,
	|	ЗаказыМатериаловОбороты.Серия,
	|	ЗаказыМатериаловОбороты.Отменено,
	|	ЗаказыМатериаловОбороты.Упаковка,
	|	ЗаказыМатериаловОбороты.КоличествоОборот КАК Количество,
	|	ЗаказыМатериаловОбороты.КоличествоУпаковокОборот КАК КоличествоУпаковок,
	|	ЗаказыМатериаловОбороты.Номенклатура,
	|	ЗаказыМатериаловОбороты.Характеристика,
	|	ЗаказыМатериаловОбороты.Назначение,
	|	ЗаказыМатериаловОбороты.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказыМатериаловОбороты.Распоряжение.ПроизводствоПоЗаказу КАК ПроизводствоПоЗаказу,
	|	ЗаказыМатериаловОбороты.Распоряжение.Назначение КАК НазначениеЗаказа,
	|	ЕСТЬNULL(ЗаказНаПроизводствоПродукция.Назначение, НЕОПРЕДЕЛЕНО) КАК НазначениеПродукции,
	|	ЗаказыМатериаловОбороты.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ЗаказыМатериаловОбороты.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ЗаказыМатериаловОбороты.Серия.Представление КАК СерияПредставление,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе КАК ПроизводитсяВПроцессе,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ЗаказатьНаСклад КАК ЗаказатьНаСклад,
	|	ЕСТЬNULL(ЗаказНаПроизводствоПродукция.КодСтроки, 0) КАК КодСтрокиПродукция,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.Этап, НЕОПРЕДЕЛЕНО) КАК Этап,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция, НЕОПРЕДЕЛЕНО) КАК КлючСвязиПродукция,
	|	ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиЭтапыСтрока, """") КАК КлючСвязиЭтапыСтрока,
	|	ЕСТЬNULL(ЗаказыМатериаловВПроизводствоОстатки.КОформлениюОстаток, 0) КАК КоличествоОсталосьОтгрузить
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(
	|			,
	|			,
	|			,
	|			НЕ ПроизводствоНаСтороне
	|				И Распоряжение В (&СписокЗаказов)) КАК ЗаказыМатериаловОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|		ПО (ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки = ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ЗаказНаПроизводствоПродукция
	|		ПО (ЗаказНаПроизводствоПродукция.Ссылка = ЗаказНаПроизводствоМатериалыИУслуги.Ссылка)
	|			И (ЗаказНаПроизводствоПродукция.КлючСвязи = ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(, Распоряжение В (&СписокЗаказов)) КАК ЗаказыМатериаловВПроизводствоОстатки
	|		ПО (ЗаказыМатериаловВПроизводствоОстатки.Распоряжение = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Характеристика = ЗаказыМатериаловОбороты.Характеристика)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.КодСтроки = ЗаказыМатериаловОбороты.КодСтроки)
	|ГДЕ
	|	(НЕ ЕСТЬNULL(ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе, ЛОЖЬ)
	|		ИЛИ ЗаказыМатериаловОбороты.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|	И (&БезОтбораПродукции
	|			ИЛИ ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция В (&КлючСвязиПродукция))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	Запрос.УстановитьПараметр("КлючСвязиПродукция", ?(КлючСвязиПродукция <> Неопределено, КлючСвязиПродукция, Новый Массив));
	Запрос.УстановитьПараметр("БезОтбораПродукции", КлючСвязиПродукция = Неопределено);
	
	МатериалыИУслуги.Очистить();
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЗаполнитьМатериалыИУслуги(Выборка);
	
КонецПроцедуры

// Заполняет данные для отгрузки материалов маршрутным листам
// Вызывается из формы диспетчирования МЛ и из формы маршрутного листа
//
// Параметры:
//  СписокМаршрутныхЛистов	- Массив - содержит список маршрутных листов
//
Процедура ЗапланироватьПолучениеМатериаловПоМаршрутномуЛисту(СписокМаршрутныхЛистов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Номенклатура КАК Номенклатура,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Характеристика КАК Характеристика,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Назначение КАК Назначение,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Организация КАК Организация,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Подразделение КАК Подразделение,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Распоряжение КАК ЗаказНаПроизводство,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик,
	|	МАКСИМУМ(МаршрутныйЛистПроизводстваМатериалыИУслуги.Упаковка) КАК Упаковка,
	|	МАКСИМУМ(ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1)) КАК КоэффициентУпаковки,
	|	СУММА(МаршрутныйЛистПроизводстваМатериалыИУслуги.КоличествоФакт) КАК Количество
	|ПОМЕСТИТЬ ТаблицаМатериалов
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства.МатериалыИУслуги КАК МаршрутныйЛистПроизводстваМатериалыИУслуги
	|ГДЕ
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка В(&СписокМаршрутныхЛистов)
	|	И НЕ МаршрутныйЛистПроизводстваМатериалыИУслуги.ПроизводитсяВПроцессе
	|	И МаршрутныйЛистПроизводстваМатериалыИУслуги.КоличествоФакт <> 0
	|	И МаршрутныйЛистПроизводстваМатериалыИУслуги.Номенклатура.ТипНоменклатуры В (
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|СГРУППИРОВАТЬ ПО
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Номенклатура,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Характеристика,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Назначение,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Организация,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Подразделение,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.Распоряжение,
	|	МаршрутныйЛистПроизводстваМатериалыИУслуги.Ссылка.КодСтрокиЭтапыГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаМатериалов.Номенклатура,
	|	ТаблицаМатериалов.Характеристика,
	|	ТаблицаМатериалов.Назначение,
	|	ТаблицаМатериалов.Организация,
	|	ТаблицаМатериалов.Подразделение,
	|	ТаблицаМатериалов.ЗаказНаПроизводство,
	|	ТаблицаМатериалов.ЗаказНаПроизводство КАК Ссылка,
	|	ТаблицаМатериалов.Упаковка,
	|	ТаблицаМатериалов.КоэффициентУпаковки,
	|	ТаблицаМатериалов.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ТаблицаМатериалов.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ЗаказЭтапыГрафик.КлючСвязиЭтапы,
	|	ТаблицаМатериалов.Количество,
	|	ЕСТЬNULL(НастройкаПередачиМатериаловХарактеристика.Склад, ЕСТЬNULL(НастройкаПередачиМатериаловНоменклатура.Склад, ЕСТЬNULL(НастройкаПередачиМатериаловСклад.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)))) КАК СкладПоУмолчанию
	|ИЗ
	|	ТаблицаМатериалов КАК ТаблицаМатериалов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЗаказЭтапыГрафик
	|		ПО (ЗаказЭтапыГрафик.Ссылка = ТаблицаМатериалов.ЗаказНаПроизводство)
	|			И (ЗаказЭтапыГрафик.КодСтроки = ТаблицаМатериалов.КодСтрокиЭтапыГрафик)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловСклад
	|		ПО (НастройкаПередачиМатериаловСклад.Подразделение = ТаблицаМатериалов.Подразделение)
	|			И (НастройкаПередачиМатериаловСклад.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|			И (НастройкаПередачиМатериаловСклад.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловНоменклатура
	|		ПО (НастройкаПередачиМатериаловНоменклатура.Подразделение = ТаблицаМатериалов.Подразделение)
	|			И (НастройкаПередачиМатериаловНоменклатура.Номенклатура = ТаблицаМатериалов.Номенклатура)
	|			И (НастройкаПередачиМатериаловНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловХарактеристика
	|		ПО (НастройкаПередачиМатериаловХарактеристика.Подразделение = ТаблицаМатериалов.Подразделение)
	|			И (НастройкаПередачиМатериаловХарактеристика.Номенклатура = ТаблицаМатериалов.Номенклатура)
	|			И (НастройкаПередачиМатериаловХарактеристика.Характеристика = ТаблицаМатериалов.Характеристика)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыМатериаловОбороты.Распоряжение КАК Ссылка,
	|	ЗаказыМатериаловОбороты.Организация,
	|	ЗаказыМатериаловОбороты.Подразделение,
	|	ЗаказыМатериаловОбороты.Назначение,
	|	ЗаказыМатериаловОбороты.Распоряжение.ПроизводствоПоЗаказу КАК ПроизводствоПоЗаказу,
	|	ЗаказыМатериаловОбороты.Распоряжение.Назначение КАК НазначениеЗаказа,
	|	ЕСТЬNULL(ЗаказНаПроизводствоПродукция.Назначение, НЕОПРЕДЕЛЕНО) КАК НазначениеПродукции,
	|	ЗаказыМатериаловОбороты.КодСтроки,
	|	ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения,
	|	ЗаказыМатериаловОбороты.Склад,
	|	ЗаказыМатериаловОбороты.ВариантОбеспечения,
	|	ЗаказыМатериаловОбороты.ДатаПотребности,
	|	ЗаказыМатериаловОбороты.Серия,
	|	ЗаказыМатериаловОбороты.Отменено,
	|	ЗаказыМатериаловОбороты.Упаковка,
	|	ЗаказыМатериаловОбороты.КоличествоУпаковокОборот КАК КоличествоУпаковок,
	|	ЗаказыМатериаловОбороты.КоличествоУпаковокОборот * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Количество,
	|	ЗаказНаПроизводствоМатериалыИУслуги.НомерСтроки КАК Порядок,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Номенклатура,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Характеристика,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ЗаказыМатериаловОбороты.Серия.Представление КАК СерияПредставление,
	|	ЗаказыМатериаловОбороты.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Этап,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе КАК ПроизводитсяВПроцессе,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ЗаказатьНаСклад КАК ЗаказатьНаСклад,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ИсточникПолученияПолуфабриката КАК ИсточникПолученияПолуфабриката,
	|	ЗаказНаПроизводствоМатериалыИУслуги.СтатьяКалькуляции,
	|	ЗаказНаПроизводствоМатериалыИУслуги.СтатусУказанияСерий,
	|	ЗаказНаПроизводствоМатериалыИУслуги.УказыватьСерии,
	|	ЗаказНаПроизводствоМатериалыИУслуги.СтатусУказанияСерийОтправитель,
	|	ЗаказНаПроизводствоМатериалыИУслуги.СтатусУказанияСерийПолучатель,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиЭтапыСтрока,
	|	ЕСТЬNULL(ЗаказыМатериаловВПроизводствоОстатки.КОформлениюОстаток, 0) КАК КоличествоОсталосьОтгрузить
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(
	|			,
	|			,
	|			,
	|			(Организация, Распоряжение, Номенклатура, Характеристика, Подразделение, Назначение) В
	|					(ВЫБРАТЬ
	|						ТаблицаМатериалов.Организация,
	|						ТаблицаМатериалов.ЗаказНаПроизводство,
	|						ТаблицаМатериалов.Номенклатура,
	|						ТаблицаМатериалов.Характеристика,
	|						ТаблицаМатериалов.Подразделение,
	|						ТаблицаМатериалов.Назначение
	|					ИЗ
	|						ТаблицаМатериалов)
	|				И НЕ ПроизводствоНаСтороне) КАК ЗаказыМатериаловОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|		ПО (ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки = ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ЗаказНаПроизводствоПродукция
	|		ПО (ЗаказНаПроизводствоПродукция.Ссылка = ЗаказНаПроизводствоМатериалыИУслуги.Ссылка)
	|			И (ЗаказНаПроизводствоПродукция.КлючСвязи = ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(
	|				,
	|				(Номенклатура, Характеристика, Подразделение) В
	|					(ВЫБРАТЬ
	|						ТаблицаМатериалов.Номенклатура,
	|						ТаблицаМатериалов.Характеристика,
	|						ТаблицаМатериалов.Подразделение
	|					ИЗ
	|						ТаблицаМатериалов)) КАК ЗаказыМатериаловВПроизводствоОстатки
	|		ПО (ЗаказыМатериаловВПроизводствоОстатки.Распоряжение = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Характеристика = ЗаказыМатериаловОбороты.Характеристика)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.КодСтроки = ЗаказыМатериаловОбороты.КодСтроки)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"МаршрутныйЛистПроизводстваМатериалыИУслуги.Упаковка",
			"МаршрутныйЛистПроизводстваМатериалыИУслуги.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЗаказыМатериаловОбороты.Упаковка",
			"ЗаказыМатериаловОбороты.Номенклатура"));
			
	Запрос.УстановитьПараметр("СписокМаршрутныхЛистов", СписокМаршрутныхЛистов);
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	
	ЗаполнитьМатериалыИУслуги(Выборка);
	
	КэшированныеЗначения = Неопределено;
	
	ИспользоватьКорректировки = ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиЗаказаМатериаловВПроизводство");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	
	Выборка = Результат[Результат.ВГраница()-1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		КОформлениюОстаток = Выборка.Количество;
		
		ПорядокВыборкиВариантовОбеспечения = Новый Массив;
		Если ЗначениеЗаполнено(Выборка.Назначение) Тогда
			ПорядокВыборкиВариантовОбеспечения.Добавить(Перечисления.ВариантыОбеспечения.Обособленно);
		Иначе
			ПорядокВыборкиВариантовОбеспечения.Добавить(Перечисления.ВариантыОбеспечения.СоСклада);
			ПорядокВыборкиВариантовОбеспечения.Добавить(Перечисления.ВариантыОбеспечения.ИзЗаказов);
			ПорядокВыборкиВариантовОбеспечения.Добавить(Перечисления.ВариантыОбеспечения.Требуется);
			ПорядокВыборкиВариантовОбеспечения.Добавить(Перечисления.ВариантыОбеспечения.НеТребуется);
		КонецЕсли;
		
		Для каждого ВариантОбеспечения Из ПорядокВыборкиВариантовОбеспечения Цикл
			
			СтруктураПоиска = Новый Структура("Ссылка,Номенклатура,Характеристика,Назначение,Подразделение");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
			СтруктураПоиска.Вставить("ВариантОбеспечения", ВариантОбеспечения);
			СписокСтрок = МатериалыИУслуги.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаМатериал Из СписокСтрок Цикл
				
				Если СтрокаМатериал.Количество > КОформлениюОстаток Тогда
					СтрокаДляКорректировки = МатериалыИУслуги.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДляКорректировки, Выборка);
					ЗаполнитьЗначенияСвойств(СтрокаДляКорректировки, СтрокаМатериал);
					
					СтрокаДляКорректировки.КодСтроки = 0;
					СтрокаДляКорректировки.КлючСвязиЭтапыСтрока = Строка(Выборка.КлючСвязиЭтапы);
					
					СтрокаМатериал.Количество = СтрокаМатериал.Количество - КОформлениюОстаток;
					СтрокаДляКорректировки.Количество = КОформлениюОстаток;
					
					ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаМатериал, СтруктураДействий, КэшированныеЗначения);
					ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаДляКорректировки, СтруктураДействий, КэшированныеЗначения);
				Иначе
					СтрокаДляКорректировки = СтрокаМатериал;
				КонецЕсли;
				
				Если НЕ СтрокаДляКорректировки.ЗаказатьНаСклад Тогда
					СтрокаДляКорректировки.ЗаказатьНаСклад = Истина;
					СтрокаДляКорректировки.Склад = Выборка.СкладПоУмолчанию;
				КонецЕсли; 
				
				Если ЗначениеЗаполнено(СтрокаДляКорректировки.Назначение) Тогда
					СтрокаДляКорректировки.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно;
				Иначе
					СтрокаДляКорректировки.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Отгрузить;
				КонецЕсли; 
				
				КОформлениюОстаток = КОформлениюОстаток - СтрокаДляКорректировки.Количество;
				
				Если КОформлениюОстаток = 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если КОформлениюОстаток = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если КОформлениюОстаток <> 0 И ИспользоватьКорректировки Тогда
			СтрокаМатериал = МатериалыИУслуги.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаМатериал, Выборка);
			СтрокаМатериал.Количество = КОформлениюОстаток;
			СтрокаМатериал.КоличествоУпаковок = СтрокаМатериал.Количество / Выборка.КоэффициентУпаковки;
			
			СтрокаМатериал.КлючСвязиЭтапыСтрока = Строка(Выборка.КлючСвязиЭтапы);
			
			СтрокаМатериал.ЗаказатьНаСклад = Истина;
			СтрокаМатериал.Склад = Выборка.СкладПоУмолчанию;
			Если ЗначениеЗаполнено(СтрокаМатериал.Назначение) Тогда
				СтрокаМатериал.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно;
			Иначе
				СтрокаМатериал.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Отгрузить;
			КонецЕсли; 
			СтрокаМатериал.ДатаПотребности = ТекущаяДатаСеанса();
			СтрокаМатериал.КодСтрокиРаспоряжения = 0;
			СтрокаМатериал.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
														Выборка.НоменклатураПредставление,
														Выборка.ХарактеристикаПредставление);
			
		КонецЕсли; 
		
	КонецЦикла;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Обработки.ВводКорректировкиЗаказаМатериалов);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

// Заполняет данные для ввода корректировок по заказу на производство
// Используется при редактировании спецификации заказа
//
// Параметры:
//  Заказ - ДокументСсылка.ЗаказНаПроизводство - ссылка на заказ
//  КлючСвязиПродукция - УникальныйИдентификатор - ключ строки продукции
//  ПолучатьПроизводимыеВПроцессе - Булево - Истина, если в списке материалов должны присутствовать полуфабрикаты производимые в процессе
//  ПолучатьОтмененныеСтроки - Булево - Истина, если в списке материалов должны присутствовать данные по отмененным строкам
//
Процедура ЗаполнитьВводКорректировкиСпецификацииЗаказа(Заказ, КлючСвязиПродукция, ПолучатьПроизводимыеВПроцессе = Истина, ПолучатьОтмененныеСтроки = Ложь) Экспорт
	
	МатериалыИУслуги.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыМатериаловОбороты.Распоряжение КАК Ссылка,
	|	ЗаказыМатериаловОбороты.Организация КАК Организация,
	|	ЗаказыМатериаловОбороты.Подразделение КАК Подразделение,
	|	ЗаказыМатериаловОбороты.КодСтроки КАК КодСтроки,
	|	ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения КАК КодСтрокиРаспоряжения,
	|	ЗаказыМатериаловОбороты.Назначение КАК Назначение,
	|	ВЫБОР
	|		КОГДА ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе
	|			ТОГДА ЕСТЬNULL(НастройкаПередачиМатериаловХарактеристика.Склад, ЕСТЬNULL(НастройкаПередачиМатериаловНоменклатура.Склад, ЕСТЬNULL(НастройкаПередачиМатериаловСклад.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))))
	|		ИНАЧЕ ЗаказыМатериаловОбороты.Склад
	|	КОНЕЦ КАК Склад,
	|	ЗаказыМатериаловОбороты.ВариантОбеспечения КАК ВариантОбеспечения,
	|	ЗаказыМатериаловОбороты.ДатаПотребности КАК ДатаПотребности,
	|	ЗаказыМатериаловОбороты.Серия КАК Серия,
	|	ЗаказыМатериаловОбороты.Отменено КАК Отменено,
	|	ЗаказыМатериаловОбороты.Упаковка КАК Упаковка,
	|	ЗаказыМатериаловОбороты.КоличествоОборот КАК Количество,
	|	ЗаказыМатериаловОбороты.КоличествоУпаковокОборот КАК КоличествоУпаковок,
	|	ЗаказНаПроизводствоМатериалыИУслуги.НомерСтроки КАК Порядок,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Номенклатура КАК Номенклатура,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Характеристика КАК Характеристика,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ЗаказыМатериаловОбороты.Серия.Представление КАК СерияПредставление,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказНаПроизводствоМатериалыИУслуги.Этап КАК Этап,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ЗаказатьНаСклад КАК ЗаказатьНаСклад,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ИсточникПолученияПолуфабриката КАК ИсточникПолученияПолуфабриката,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе КАК ПроизводитсяВПроцессе,
	|	ЗаказНаПроизводствоМатериалыИУслуги.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ЗаказНаПроизводствоМатериалыИУслуги.ПрименениеМатериала КАК ПрименениеМатериала,
	|	ЗаказНаПроизводствоМатериалыИУслуги.УказыватьСерии КАК УказыватьСерии,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязи КАК КлючСвязи,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция КАК КлючСвязиПродукция,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиЭтапы КАК КлючСвязиЭтапы,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиСпецификация КАК КлючСвязиСпецификация,
	|	ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиЭтапВыпуска КАК КлючСвязиЭтапВыпуска,
	|	ЕСТЬNULL(ЗаказыМатериаловВПроизводствоОстатки.КОформлениюОстаток, 0) КАК КоличествоОсталосьОтгрузить
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(
	|			,
	|			,
	|			,
	|			НЕ ПроизводствоНаСтороне
	|				И Распоряжение = &Заказ
	|				И КодСтрокиРаспоряжения <> 0
	|				И (&ПолучатьОтмененныеСтроки
	|					ИЛИ НЕ Отменено)) КАК ЗаказыМатериаловОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|		ПО (ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки = ЗаказыМатериаловОбороты.КодСтрокиРаспоряжения)
	|			И (ЗаказНаПроизводствоМатериалыИУслуги.КлючСвязиПродукция = &КлючСвязиПродукция)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(, Распоряжение = &Заказ) КАК ЗаказыМатериаловВПроизводствоОстатки
	|		ПО (ЗаказыМатериаловВПроизводствоОстатки.Распоряжение = ЗаказыМатериаловОбороты.Распоряжение)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.Характеристика = ЗаказыМатериаловОбороты.Характеристика)
	|			И (ЗаказыМатериаловВПроизводствоОстатки.КодСтроки = ЗаказыМатериаловОбороты.КодСтроки)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловСклад
	|		ПО (НастройкаПередачиМатериаловСклад.Подразделение = ЗаказыМатериаловОбороты.Подразделение)
	|			И (НастройкаПередачиМатериаловСклад.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|			И (НастройкаПередачиМатериаловСклад.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловНоменклатура
	|		ПО (НастройкаПередачиМатериаловНоменклатура.Подразделение = ЗаказыМатериаловОбороты.Подразделение)
	|			И (НастройкаПередачиМатериаловНоменклатура.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (НастройкаПередачиМатериаловНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловХарактеристика
	|		ПО (НастройкаПередачиМатериаловХарактеристика.Подразделение = ЗаказыМатериаловОбороты.Подразделение)
	|			И (НастройкаПередачиМатериаловХарактеристика.Номенклатура = ЗаказыМатериаловОбороты.Номенклатура)
	|			И (НастройкаПередачиМатериаловХарактеристика.Характеристика = ЗаказыМатериаловОбороты.Характеристика)
	|ГДЕ
	|	(&ПолучатьПроизводимыеВПроцессе
	|			ИЛИ НЕ ЗаказНаПроизводствоМатериалыИУслуги.ПроизводитсяВПроцессе)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ВариантОбеспечения УБЫВ,
	|	ДатаПотребности";
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	Запрос.УстановитьПараметр("КлючСвязиПродукция", КлючСвязиПродукция);
	Запрос.УстановитьПараметр("ПолучатьПроизводимыеВПроцессе", ПолучатьПроизводимыеВПроцессе);
	Запрос.УстановитьПараметр("ПолучатьОтмененныеСтроки", ПолучатьОтмененныеСтроки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ЗаполнитьМатериалыИУслуги(РезультатЗапроса.Выбрать());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("МатериалыИУслуги.Назначение");
	
	ПараметрыПроверкиКоличества = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверкиКоличества.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыПроверкиКоличества.УсловиеОтбораСтрокДляОкругления = "МатериалыИУслуги.ЗаказатьНаСклад = ИСТИНА";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества);
	
	ПараметрыПроверкиХарактеристик = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверкиХарактеристик.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверкиХарактеристик);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Обработки.ВводКорректировкиЗаказаМатериалов),
		Отказ,
		МассивНепроверяемыхРеквизитов);
		
	ШаблонСообщенияНазначение = НСтр("ru='Не заполнена колонка ""Назначение"" в строке %1 списка ""Материалы и работы"".';uk='Не заповнена колонка ""Призначення"" в рядку %1 списку ""Матеріали і роботи"".'");
	Для каждого ДанныеСтроки Из МатериалыИУслуги Цикл
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Назначение)
			И (ДанныеСтроки.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Обособленно
				ИЛИ ДанныеСтроки.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно) Тогда
				
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщенияНазначение, Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("МатериалыИУслуги", ДанныеСтроки.НомерСтроки, "Назначение");
   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
		КонецЕсли; 
	КонецЦикла; 		
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьМатериалыИУслуги(Выборка)

	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = МатериалыИУслуги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НоваяСтрока.КодСтрокиИсходный = НоваяСтрока.КодСтроки;
		НоваяСтрока.ВариантОбеспеченияИсходный = НоваяСтрока.ВариантОбеспечения;
		НоваяСтрока.ДатаПотребностиИсходный = НоваяСтрока.ДатаПотребности;
		НоваяСтрока.СкладИсходный = НоваяСтрока.Склад;
		
		Если НоваяСтрока.ПроизводитсяВПроцессе Тогда
			НоваяСтрока.ЗаказатьНаСклад = ЗначениеЗаполнено(НоваяСтрока.Склад);
		Иначе
			НоваяСтрока.ЗаказатьНаСклад = (НоваяСтрока.ВариантОбеспечения <> Перечисления.ВариантыОбеспечения.НеТребуется
											И Выборка.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Работа);
		КонецЕсли;
		
		НоваяСтрока.НазначениеИсходный = НоваяСтрока.Назначение;
		НоваяСтрока.ЗаказатьНаСкладИсходный = НоваяСтрока.ЗаказатьНаСклад;
		НоваяСтрока.УпаковкаИсходный = НоваяСтрока.Упаковка;
		НоваяСтрока.СерияИсходный = НоваяСтрока.Серия;
		НоваяСтрока.ОтмененоИсходный = НоваяСтрока.Отменено;
		
		Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			НоваяСтрока.ЗаказНаПроизводство = Выборка.Ссылка;
		КонецЕсли; 
		
		НоваяСтрока.ТолькоПросмотр = НоваяСтрока.ПроизводитсяВПроцессе;
		
		Если НоваяСтрока.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Отгрузить
			ИЛИ НоваяСтрока.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно Тогда
			НоваяСтрока.КоличествоОтгружено = НоваяСтрока.Количество - Выборка.КоличествоОсталосьОтгрузить;
		КонецЕсли; 
		
		НоваяСтрока.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
													Выборка.НоменклатураПредставление,
													Выборка.ХарактеристикаПредставление,
													Выборка.СерияПредставление);
		
	КонецЦикла;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Обработки.ВводКорректировкиЗаказаМатериалов);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли