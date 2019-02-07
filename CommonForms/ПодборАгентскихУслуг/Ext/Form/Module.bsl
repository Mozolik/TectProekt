﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Принципал = Параметры.Принципал;
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	Если Параметры.Свойство("ЭтоПодбор") Тогда
		ЭтоПодбор = Параметры.ЭтоПодбор;
	Иначе 
		ЭтоПодбор = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	УстановитьВидимостьПоПодбору();
	ЗаполнитьТаблицуУслуг();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВСправочникВыполнить()
	
	Закрыть(КодВозвратаДиалога.OK);
	
	Если ЭтоПодбор Тогда
		АдресУслугиВХранилище = ПоместитьУслугиВХранилище();
		ОповеститьОВыборе(АдресУслугиВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаУслуг Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаУслуг Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаУслуг.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаУслуг.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаУслуг.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаУслуг.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Если Не ЭтоПодбор Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформление.Элементы.Очистить();
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслуг.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУслуг.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоПодбору()
	
	Если Не ЭтоПодбор Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ТаблицаУслугВыбран","Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ВыбратьВыделенные","Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ИсключитьВыделенные","Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ПеренестиВСправочник","Заголовок", "Закрыть");
		Заголовок = НСтр("ru='Список агентских услуг';uk='Список агентських послуг'");
	КонецЕсли;
	
КонецПроцедуры

#Область Прочее

&НаСервере
Функция ПоместитьУслугиВХранилище() 
	
	Услуги = ТаблицаУслуг.Выгрузить(, "Выбран, Номенклатура, Характеристика");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Услуги Цикл
		Если НЕ СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Услуги.Удалить(СтрокаТаблицы);
	КонецЦикла;

	Возврат ПоместитьВоВременноеХранилище(Услуги, ИдентификаторВызывающейФормы);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьУслугиПоПодбору()
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Услуги.Номенклатура КАК Номенклатура,
	|	Услуги.Характеристика КАК Характеристика,
	|	ИСТИНА КАК Выбран
	|ПОМЕСТИТЬ ВыбранныеУслуги
	|ИЗ
	|	&Услуги КАК Услуги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Услуги.Номенклатура КАК Номенклатура,
	|	Услуги.Характеристика КАК Характеристика,
	|	ИСТИНА КАК Выбран
	|ИЗ
	|	ВыбранныеУслуги КАК Услуги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеУслуги КАК Услуги
	|		ПО (Услуги.Номенклатура = СпрНоменклатура.Ссылка)
	|			И (Услуги.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|	И СпрНоменклатура.Принципал = &Принципал
	|	И СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|	И Услуги.Номенклатура ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка,
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО (ВЫБОР
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|					ТОГДА СпрНоменклатура.Ссылка
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					ТОГДА СпрНоменклатура.ВидНоменклатуры
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					ТОГДА СпрНоменклатура.ВладелецХарактеристик
	|				ИНАЧЕ НЕОПРЕДЕЛЕНО
	|			КОНЕЦ = ХарактеристикиНоменклатуры.Владелец)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеУслуги КАК Услуги
	|		ПО (Услуги.Номенклатура = СпрНоменклатура.Ссылка)
	|			И (Услуги.Характеристика = ХарактеристикиНоменклатуры.Ссылка)
	|ГДЕ
	|	СпрНоменклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры))
	|	И ХарактеристикиНоменклатуры.Принципал = &Принципал
	|	И СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|	И Услуги.Номенклатура ЕСТЬ NULL ";
		
	Услуги = ПолучитьИзВременногоХранилища(ИдентификаторВызывающейФормы);
	Услуги.Свернуть("Номенклатура, Характеристика");
	Запрос.УстановитьПараметр("Услуги", Услуги);
	Запрос.УстановитьПараметр("Принципал", Принципал);
	
	ТаблицаУслуг.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсеАгентскиеУслугиПоПринципалу()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
	|	ЛОЖЬ КАК Выбран
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|	И СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|	И СпрНоменклатура.Принципал = &Принципал
	|	И СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка,
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО (ВЫБОР
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|					ТОГДА СпрНоменклатура.Ссылка
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					ТОГДА СпрНоменклатура.ВидНоменклатуры
	|				КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					ТОГДА СпрНоменклатура.ВладелецХарактеристик
	|				ИНАЧЕ НЕОПРЕДЕЛЕНО
	|			КОНЕЦ = ХарактеристикиНоменклатуры.Владелец)
	|ГДЕ
	|	СпрНоменклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры))
	|	И ХарактеристикиНоменклатуры.Принципал = &Принципал
	|	И СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)";
	Запрос.УстановитьПараметр("Принципал", Принципал);
	ТаблицаУслуг.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуУслуг()
	
	Если ЭтоПодбор Тогда
		ЗагрузитьУслугиПоПодбору();
	Иначе
		ЗаполнитьВсеАгентскиеУслугиПоПринципалу();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
