﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Элементы.КартинкаРасхождениеЗаказ.Картинка = Новый Картинка();
	КонецЕсли;
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОповеститьОПроведенииДокумента(ПараметрыЗаписи);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаказНаПроизводство));
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	ОбновитьЗависимыеРеквизитыФормыПоЗаказу(
		Объект.МатериалыИУслуги,
		НадписьРасхождениеЗаказ,
		Элементы.КартинкаРасхождениеЗаказ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗависимыеРеквизитыФормыПоЗаказу(Товары, НадписьРасхождениеЗаказ, КартинкаРасхождениеЗаказ)
	
	КоличествоРасхождений = Товары.Итог("РасхождениеЗаказ");
	
	Если КоличествоРасхождений > 0 Тогда
		КартинкаРасхождениеЗаказ.Картинка = БиблиотекаКартинок.ПревышениеЗаказа;
		НадписьРасхождениеЗаказ = СтрЗаменить(НСтр("ru='Строк сверх заказа: %КоличествоРасхождений%';uk='Рядків понад замовлення: %КоличествоРасхождений%'"), "%КоличествоРасхождений%", КоличествоРасхождений);
	Иначе
		КартинкаРасхождениеЗаказ.Картинка = Новый Картинка();
		НадписьРасхождениеЗаказ = "";
		КоличествоРасхождений = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	Для каждого СтрокаМатериал Из Объект.МатериалыИУслуги Цикл
		СтрокаМатериал.НадписьДоИзменения = НСтр("ru='До изменения';uk='До зміни'");
		СтрокаМатериал.НадписьПослеИзменения = НСтр("ru='После изменения';uk='Після зміни'");
		ОбновитьОтклоненияОтЗаказаВСтроке(СтрокаМатериал, Истина);
	КонецЦикла; 
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.МатериалыИУслуги,
		Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются, ЗаполнитьПризнакТипНоменклатуры, ЗаполнитьПризнакАртикул",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются"),
			Новый Структура("Номенклатура", "ТипНоменклатуры"),
			Новый Структура("Номенклатура", "Артикул")));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтклоненияОтЗаказаВСтроке(ТекущаяСтрока, ПотреблениеПоЗаказам)
	
	Если ТекущаяСтрока.КодСтрокиРаспоряжения = 0 Тогда
		ТекущаяСтрока.РасхождениеЗаказ = 1;
	Иначе
		ТекущаяСтрока.РасхождениеЗаказ = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Стандартное оформление номенклатуры
	#Область ОформлениеНоменклатуры
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, "МатериалыИУслугиХарактеристика", "Объект.МатериалыИУслуги.ХарактеристикиИспользуются");
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "МатериалыИУслугиНоменклатураЕдиницаИзмерения1", "Объект.МатериалыИУслуги.УпаковкаИсходный");
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "МатериалыИУслугиНоменклатураЕдиницаИзмерения2", "Объект.МатериалыИУслуги.Упаковка");
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары", "МатериалыИУслугиСерия", "Объект.МатериалыИУслуги.СтатусУказанияСерий", "Объект.МатериалыИУслуги.ТипНоменклатуры");
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары", "МатериалыИУслугиСерияИсходный", "Объект.МатериалыИУслуги.СтатусУказанияСерийИсходный", "Объект.МатериалыИУслуги.ТипНоменклатуры");
	#КонецОбласти
	
	// Выделение серым отмененных строк
	#Область ВыделениеСерымОтмененныхСтрок
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслуги.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.Отменено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	#КонецОбласти
	
	// Выделение цветом реквизитов, которые изменились
	#Область ВыделитьИзмененныеРеквизиты
	ЦветТекста = WebЦвета.ТемноЗеленый;
	
	// Серия
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиСерияИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиСерия.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.СерияИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.Серия");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	// ВариантОбеспечения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиВариантОбеспеченияИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиВариантОбеспечения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.ВариантОбеспеченияИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.ВариантОбеспечения");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	// ДатаПотребности
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиДатаПотребностиИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиДатаПотребности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.ДатаПотребностиИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.ДатаПотребности");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	// Склад
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиСкладИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиСклад.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.СкладИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.Склад");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	// Отменено
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиОтмененоИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиОтменено.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.ОтмененоИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.Отменено");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	// Упаковка
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиУпаковкаИсходный.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиУпаковка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.УпаковкаИсходный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МатериалыИУслуги.Упаковка");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОПроведенииДокумента(ПараметрыЗаписи)

	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("РежимЗаписи",      ПараметрыЗаписи.РежимЗаписи);
	ПараметрыОповещения.Вставить("ЕстьРаспоряжение", Истина);

	Оповестить("Запись_КорректировкаЗаказаМатериаловВПроизводство", ПараметрыОповещения, Объект.Ссылка);

КонецПроцедуры

#КонецОбласти
