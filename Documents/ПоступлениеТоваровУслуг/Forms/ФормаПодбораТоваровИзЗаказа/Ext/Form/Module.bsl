﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента    = Параметры.ВалютаДокумента;
	ЦенаВключаетНДС    = Параметры.ЦенаВключаетНДС;

	ЗаполнитьТаблицуТоваров();
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.ПоступлениеТоваровУслуг);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если НЕ ВыполняетсяЗакрытие и Модифицированность Тогда
        Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Данные были изменены. Перенести изменения в документ?';uk='Дані були змінені. Перенести зміни в документ?'"), РежимДиалогаВопрос.ДаНетОтмена);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		ПеренестиТоварыВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТоваров.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаТоваровЗаказПоставщику" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТоваров.ТекущиеДанные.ЗаказПоставщику);
		ИначеЕсли Поле.Имя = "ТаблицаТоваровСделка" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТоваров.ТекущиеДанные.Сделка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПеренестиТоварыВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровЗаказПоставщику.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ЗаказПоставщику");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСделка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Сделка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСуммаСНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЦенаВключаетНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// Оформление склада и подразделения
	// отключение видимости склада, если работа или услуга

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Работа);
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Услуга);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// отключение видимости подразделения, если товар или тара

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Товар);
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.МногооборотнаяТара);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "ТаблицаТоваровНоменклатураЕдиницаИзмерения", "ТаблицаТоваров.Упаковка");

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТоваров.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()

	Возврат ПоместитьВоВременноеХранилище(ТаблицаТоваров.Выгрузить(Новый Структура("СтрокаВыбрана", Истина)));

КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()

	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Партнер",                   Параметры.Партнер);
	ДанныеОтбора.Вставить("Контрагент",                Параметры.Контрагент);
	ДанныеОтбора.Вставить("Договор",                   Параметры.Договор);
	ДанныеОтбора.Вставить("Организация",               Параметры.Организация);
	ДанныеОтбора.Вставить("ХозяйственнаяОперация",     Параметры.ХозяйственнаяОперация);
	ДанныеОтбора.Вставить("Соглашение",                Параметры.Соглашение);
	ДанныеОтбора.Вставить("Валюта",                    Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("ВалютаВзаиморасчетов",      Параметры.ВалютаВзаиморасчетов);
	ДанныеОтбора.Вставить("ЦенаВключаетНДС",           Параметры.ЦенаВключаетНДС);
	ДанныеОтбора.Вставить("ПорядокРасчетов",           Параметры.ПорядокРасчетов);
	ДанныеОтбора.Вставить("ВернутьМногооборотнуюТару", Параметры.ВернутьМногооборотнуюТару);
	ДанныеОтбора.Вставить("Склад",                     Параметры.Склад);
	ДанныеОтбора.Вставить("Ссылка",                    Параметры.ПоступлениеТоваровУслуг);
	ДанныеОтбора.Вставить("НаправлениеДеятельности",   Параметры.НаправлениеДеятельности);
	
	Если Не ЗначениеЗаполнено(Параметры.ЗаказПоставщику) Или ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(Параметры.ЗаказПоставщику);
	КонецЕсли;
	
	Документы.ПоступлениеТоваровУслуг.ЗаполнитьПоОстаткамЗаказов(
		ДанныеОтбора,
		ТаблицаТоваров,
		Параметры.Склад,
		МассивЗаказов);
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТоваров, "ЗаказПоставщику", Параметры.МассивКодовСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()

	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;

	Закрыть();

	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", ПоместитьТоварыВХранилище()));

КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;