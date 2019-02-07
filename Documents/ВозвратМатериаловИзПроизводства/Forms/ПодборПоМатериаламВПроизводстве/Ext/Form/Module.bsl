﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресВХранилище  = Параметры.АдресВХранилище;
	Организация      = Параметры.Организация;
	Подразделение    = Параметры.Подразделение;
	ДокументВозврата = Параметры.ДокументВозврата;
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	
	ОповеститьОВыборе(АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()
	
	ОтметитьСтроки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()
	
	ОтметитьСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	ОтметитьСтроки(Истина, МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	ОтметитьСтроки(Ложь, МассивСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<без назначения>';uk='<без призначення>'"));

КонецПроцедуры

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, Назначение, НазначениеОтправителя, Количество, КоличествоУпаковок");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		Если Не СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Товары.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(Товары);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	СтруктураПараметров = Новый Структура("Организация, Подразделение, ДокументВозврата");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтаФорма, "Организация, Подразделение, ДокументВозврата");
	
	УстановитьПривилегированныйРежим(Истина);
	ЗапасыСервер.ТаблицаОстатковМатериаловВПодразделении(МенеджерВременныхТаблиц, СтруктураПараметров);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Назначение КАК Назначение,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Номенклатура КАК Номенклатура,
	|	ТаблицаОстатков.Характеристика КАК Характеристика,
	|	ТаблицаОстатков.Количество КАК Количество,
	|	ТаблицаОстатков.Назначение КАК Назначение,
	|	ТаблицаОстатков.Назначение КАК НазначениеОтправителя,
	|	ВЫБОР
	|		КОГДА Товары.Количество ЕСТЬ NULL 
	|				ИЛИ Товары.Количество = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ТаблицаОстатков.Количество КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|		ЛЕВОЕ СОЕДИНЕНИЕ Товары КАК Товары
	|		ПО ТаблицаОстатков.Номенклатура = Товары.Номенклатура
	|			И ТаблицаОстатков.Характеристика = Товары.Характеристика
	|			И ТаблицаОстатков.Назначение = Товары.Назначение
	|ГДЕ
	|	ТаблицаОстатков.Количество > 0
	|	И ТаблицаОстатков.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))";
	
	Товары = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Товары.Свернуть("Номенклатура, Характеристика, Назначение", "Количество");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Товары", Товары);
	
	ТаблицаТоваров.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ТаблицаТоваров.Сортировать("Номенклатура");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСтроки(Значение, МассивСтрок = Неопределено)
	
	Если МассивСтрок = Неопределено Тогда
		
		Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
			СтрокаТаблицы.Выбран = Значение;
		КонецЦикла;
		
	Иначе
		
		Для Каждого НомерСтроки Из МассивСтрок Цикл
			СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
			Если СтрокаТаблицы <> Неопределено Тогда
				СтрокаТаблицы.Выбран = Значение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
