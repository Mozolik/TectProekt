﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Соглашение = Параметры.Соглашение;
	Валюта = Параметры.Валюта;
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода = Параметры.КонецПериода;
	НалогообложениеНДС = Параметры.НалогообложениеНДС;
	ЭтоОтчетОПродажах = Параметры.ЭтоОтчетОПродажах;
	АдресТоварыВХранилище = Параметры.АдресТоварыВХранилище;
	
	Если ЭтоОтчетОПродажах Тогда
		ЗаполнитьТаблицуТоваровДляОтчетаОПродажах();
	Иначе
		ЗаполнитьТаблицуТоваровДляОтчетаОСписании();
	КонецЕсли;
	
	Элементы.ТаблицаТоваровЦенаПродажи.Видимость = ЭтоОтчетОПродажах;
	Элементы.ТаблицаТоваровСуммаПродажи.Видимость = ЭтоОтчетОПродажах;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = (СтрокаТаблицы.КоличествоУпаковок <> 0);
	СтрокаТаблицы.СуммаПродажи = СтрокаТаблицы.ЦенаПродажи * СтрокаТаблицы.КоличествоУпаковок;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресТоварыВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
 	Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, СтавкаНДС, Количество, КоличествоУпаковок, КоличествоУпаковокВыбран, ЦенаПродажи, СуммаПродажи");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		Если Не СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		Иначе
			СтрокаТаблицы.Количество         = СтрокаТаблицы.КоличествоУпаковокВыбран;
			СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.КоличествоУпаковокВыбран;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Товары.Удалить(СтрокаТаблицы);
	КонецЦикла;

	ПоместитьВоВременноеХранилище(Товары, АдресТоварыВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваровДляОтчетаОПродажах()
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Валюта", Валюта);
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("Партнер", Партнер);
	СтруктураПараметров.Вставить("Соглашение", Соглашение);
	СтруктураПараметров.Вставить("НачалоПериода", НачалоПериода);
	СтруктураПараметров.Вставить("КонецПериода", КонецДня(?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДата())));
	СтруктураПараметров.Вставить("ЕстьСуммаПродажиНДС", Ложь);
	
	КомиссионнаяТорговляСервер.ЗапросПоТоварамКОформлениюОтчетовКомитентуЗаПериод(СтруктураПараметров, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество
	|
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТаблицаТовары.Количество, 0) > 0 ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК Выбран,
	|
	|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика КАК Характеристика,
	|	ТоварыКОформлению.Количество КАК Количество,
	|	ЕСТЬNULL(ТаблицаТовары.Количество, ТоварыКОформлению.Количество) КАК КоличествоУпаковокВыбран,
	|	ТоварыКОформлению.СуммаВыручки КАК СуммаПродажи,
	|	ТоварыКОформлению.КоличествоОстаток КАК КоличествоОстаток,
	|	ТоварыКОформлению.ЕстьСуммаПродажиНДС КАК ЕстьСуммаПродажиНДС
	|
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаТовары КАК ТаблицаТовары
	|	ПО
	|		ТоварыКОформлению.Номенклатура = ТаблицаТовары.Номенклатура
	|		И ТоварыКОформлению.Характеристика = ТаблицаТовары.Характеристика
	|
	|
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(КоличествоОстаток)
	|ПО
	|	Номенклатура,
	|	Характеристика
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Товары = ПолучитьИзВременногоХранилища(АдресТоварыВХранилище);
 	Товары.Свернуть("Номенклатура, Характеристика", "Количество");
	Запрос.УстановитьПараметр("ТаблицаТовары", Товары);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	КомиссионнаяТорговляСервер.ЗаполнитьТЧПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТаблицаТоваров, РезультатЗапроса, НалогообложениеНДС);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваровДляОтчетаОСписании()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	Товары.Количество КАК Количество
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|
	|ПОМЕСТИТЬ ВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.Комитент = &Комитент
	|	И (ВидыЗапасов.Соглашение = &Соглашение
	|		ИЛИ &Соглашение = Неопределено)
	|	И ВидыЗапасов.Валюта = &Валюта
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|
	|	ВЫБОР КОГДА &ЭтоОтчетОПродажах ТОГДА
	|		Остатки.КоличествоОстаток
	|	ИНАЧЕ
	|		Остатки.КоличествоСписаноОстаток
	|	КОНЕЦ КАК КоличествоОстаток,
	|	Остатки.СуммаВыручкиОстаток
	|
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(&Граница,
	|		ВидЗапасов В (
	|			ВЫБРАТЬ
	|				ВидЗапасов
	|			ИЗ
	|				ВидыЗапасов КАК ВидыЗапасов
	|			)
	|	) КАК Остатки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Остатки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|ГДЕ
	|	(Остатки.КоличествоОстаток <> 0 И &ЭтоОтчетОПродажах)
	|	ИЛИ 
	|	(Остатки.КоличествоСписаноОстаток <> 0 И Не &ЭтоОтчетОПродажах)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|
	|	ВЫБОР КОГДА &ЭтоОтчетОПродажах ТОГДА
	|		Остатки.КоличествоОстаток
	|	ИНАЧЕ
	|		Остатки.КоличествоСписаноОстаток
	|	КОНЕЦ КАК КоличествоОстаток,
	|	ВЫБОР КОГДА &ЭтоОтчетОПродажах И Остатки.КоличествоОстаток < 0 ТОГДА
	|		-1
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ КАК Знак,
	|	Остатки.СуммаВыручкиОстаток
	|
	|ПОМЕСТИТЬ ТоварыКОформлениюОстатки
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(,
	|		ВидЗапасов В (
	|			ВЫБРАТЬ
	|				ВидЗапасов
	|			ИЗ
	|				ВидыЗапасов КАК ВидыЗапасов
	|			)
	|	) КАК Остатки
	|ГДЕ
	|	(Остатки.КоличествоОстаток <> 0 И &ЭтоОтчетОПродажах)
	|	ИЛИ 
	|	(Остатки.КоличествоСписаноОстаток <> 0 И Не &ЭтоОтчетОПродажах)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика КАК Характеристика,
	|	ТоварыКОформлению.Серия КАК Серия,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток * ТоварыКОформлениюОстатки.Знак, 0)
	|		< (ТоварыКОформлению.КоличествоОстаток * ЕСТЬNULL(ТоварыКОформлениюОстатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыКОформлению.КоличествоОстаток
	|	КОНЕЦ КАК КоличествоУпаковок,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток * ТоварыКОформлениюОстатки.Знак, 0)
	|		< (ТоварыКОформлению.КоличествоОстаток * ЕСТЬNULL(ТоварыКОформлениюОстатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыКОформлению.КоличествоОстаток
	|	КОНЕЦ КАК КоличествоУпаковокУчет,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток * ТоварыКОформлениюОстатки.Знак, 0)
	|		< (ТоварыКОформлению.КоличествоОстаток * ЕСТЬNULL(ТоварыКОформлениюОстатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(ТоварыКОформлениюОстатки.СуммаВыручкиОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыКОформлению.СуммаВыручкиОстаток
	|	КОНЕЦ КАК СуммаПродажи,
	|
	|	ВЫБОР КОГДА (
	|		ВЫБОР КОГДА ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток * ТоварыКОформлениюОстатки.Знак, 0)
	|			< (ТоварыКОформлению.КоличествоОстаток * ЕСТЬNULL(ТоварыКОформлениюОстатки.Знак, 1))
	|		ТОГДА
	|			ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток, 0)
	|		ИНАЧЕ
	|			ТоварыКОформлению.КоличествоОстаток
	|		КОНЕЦ
	|		) = 0
	|	ТОГДА
	|		0
	|	ИНАЧЕ
	|		ТоварыКОформлению.СуммаВыручкиОстаток / 
	|		(
	|		ВЫБОР КОГДА ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток * ТоварыКОформлениюОстатки.Знак, 0)
	|			< (ТоварыКОформлению.КоличествоОстаток * ЕСТЬNULL(ТоварыКОформлениюОстатки.Знак, 1))
	|		ТОГДА
	|			ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток, 0)
	|		ИНАЧЕ
	|			ТоварыКОформлению.КоличествоОстаток
	|		КОНЕЦ
	|		)
	|	КОНЕЦ КАК ЦенаПродажи
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТоварыКОформлениюОстатки КАК ТоварыКОформлениюОстатки
	|	ПО
	|		ТоварыКОформлению.АналитикаУчетаНоменклатуры = ТоварыКОформлениюОстатки.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	ТоварыКОформлению.КоличествоОстаток <> 0
	|	И ЕСТЬNULL(ТоварыКОформлениюОстатки.КоличествоОстаток, 0) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыКОформлению.Номенклатура,
	|	ТоварыКОформлению.Характеристика
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Комитент", Партнер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("ЭтоОтчетОПродажах", ЭтоОтчетОПродажах);
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), ТекущаяДата());
	Граница = Новый Граница(ДатаЗаполнения, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Товары = ПолучитьИзВременногоХранилища(АдресТоварыВХранилище);
	Товары.Свернуть("Номенклатура, Характеристика", "Количество");
	Запрос.УстановитьПараметр("Товары", Товары);
	
	ТаблицаТоваров.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
