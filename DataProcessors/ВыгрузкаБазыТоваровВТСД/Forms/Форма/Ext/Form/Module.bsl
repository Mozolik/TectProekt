﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();

	Элементы.Вариант.СписокВыбора.Добавить("ПоДвижениям",                       НСтр("ru='По движениям на складах за период';uk='За рухами на складах за період'"));
	Элементы.Вариант.СписокВыбора.Добавить("ПоТоварамПересчета",                НСтр("ru='По товарам пересчета';uk='По товарах перерахунку'"));
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение", Новый Структура) Тогда
		Элементы.Вариант.СписокВыбора.Добавить("ПоРаспоряжениямНаПриемкуИОтгрузку", НСтр("ru='По распоряжениям на приемку и отгрузку';uk='За розпорядженням на приймання і відвантаження'"));
		Элементы.Вариант.СписокВыбора.Добавить("ПоРаспоряжениямНаОтгрузку",         НСтр("ru='По распоряжениям на отгрузку';uk='За розпорядженням на відвантаження'"));
		Элементы.Вариант.СписокВыбора.Добавить("ПоРаспоряжениямНаПриемку",          НСтр("ru='По распоряжениям на приемку';uk='За розпорядженням на приймання'"));
	КонецЕсли;
	Элементы.Вариант.СписокВыбора.Добавить("ПоОтбору", НСтр("ru='По отбору';uk='За відбором'"));
	
	Если ЗначениеЗаполнено(Параметры.ВариантЗаполнения) Тогда
		ВариантЗаполнения = Параметры.ВариантЗаполнения;
		
		ДатаОтгрузки = Параметры.ДатаОтгрузки;
		ДатаПриемки = Параметры.ДатаПриемки;
		
		СкладОтгрузки = Параметры.СкладОтгрузки;
		СкладПриемки = Параметры.СкладПриемки;
		
		Пересчет = Параметры.Пересчет;
		
		ЗаполнитьНаСервере();
		
	Иначе
		ВариантЗаполнения = "ПоОтбору";
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы[ВариантЗаполнения];
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ВариантЗаполнения = Настройки["ВариантЗаполнения"];
	
	Элементы.Страницы.ТекущаяСтраница = Элементы[ВариантЗаполнения];
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьВыполнить(Команда)
	
	ОчиститьСообщения();
	
	РезультатПроверки = ВыполнитьПроверку();
	Если Не РезультатПроверки.ТоварыВыбраны Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не выбрано ни одного товара';uk='Не обрано жодного товару'"));
		Возврат;
	КонецЕсли;
	
	ТаблицаТСД = МассивБазыТоваров();
	
	МенеджерОборудованияКлиент.НачатьВыгрузкуДанныеВТСД(
		Новый ОписаниеОповещения("ВыгрузитьВТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор,
		ТаблицаТСД);

КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВТСДЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='Данные успешно выгружены в ТСД.';uk='Дані успішно вивантажені в ТЗД.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		МенеджерОборудованияКлиентПереопределяемый.СообщитьОбОшибке(РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если ВариантЗаполнения = "ПоТоварамПересчета"
		И Не ЗначениеЗаполнено(Пересчет) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Пересчет товаров""';uk='Не заповнене поле ""Перерахунок товарів""'"),
			,
			"Пересчет",
			,
			Отказ);
			
		Возврат;
		
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаПриемкуИОтгрузку"
		И Не ЗначениеЗаполнено(СкладОтгрузки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Склад""';uk='Не заповнене поле ""Склад""'"),
			,
			"СкладОтгрузки",
			,
			Отказ);
		
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаОтгрузку"
		И Не ЗначениеЗаполнено(СкладОтгрузки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Склад""';uk='Не заповнене поле ""Склад""'"),
			,
			"СкладОтгрузки",
			,
			Отказ);
		
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаПриемку"
		И Не ЗначениеЗаполнено(СкладПриемки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Склад""';uk='Не заповнене поле ""Склад""'"),
			,
			"СкладПриемки",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		СтрокаТЧ.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)

	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		СтрокаТЧ.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
	
	Если МассивСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='В списке отсутствуют выделенные строки';uk='У списку відсутні виділені рядки'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(НомерСтроки);
		СтрокаТЧ.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
	
	Если МассивСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='В списке отсутствуют выделенные строки';uk='У списку відсутні виділені рядки'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(НомерСтроки);
		СтрокаТЧ.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНовыйШтрихкодEAN13(Команда)
	
	МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
	
	Если МассивСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='В списке отсутствуют выделенные строки';uk='У списку відсутні виділені рядки'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Результат = УстановитьНовыеШтрихкодыEAN13НаСервере(ОписаниеОшибки);
	
	Если Результат = 0 И ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(Неопределено, ОписаниеОшибки);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ВариантЗаполненияПриИзменении(Элемент)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы[ВариантЗаполнения];
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыШтрихкод.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Штрихкод");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

#Область Прочее

&НаСервере
Функция МассивБазыТоваров()

	МассивВыгрузки = Новый Массив();

	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Штрихкод", СтрокаТЧ.Штрихкод);
		СтруктураСтроки.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		СтруктураСтроки.Вставить("ЕдиницаИзмерения", СтрокаТЧ.Упаковка);
		СтруктураСтроки.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.Характеристика);
		СтруктураСтроки.Вставить("Цена", СтрокаТЧ.Цена);
		СтруктураСтроки.Вставить("Количество", 0);

		МассивВыгрузки.Добавить(СтруктураСтроки);
	КонецЦикла;

	Возврат МассивВыгрузки;

КонецФункции

&НаСервере
Процедура ЗаполнитьПоОтборуНаСервере()
	
	Объект.Товары.Очистить();
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	СтруктураНастроек = Обработки.ВыгрузкаБазыТоваровВТСД.СтруктураНастроек();
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("Цена");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Штрихкод");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Количество");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Характеристика");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Упаковка");
	КонецЕсли;
	СтруктураНастроек.ОбязательныеПоля.Добавить("Весовой");
	СтруктураНастроек.ОбязательныеПоля.Добавить("ОстатокНаСкладе");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Цена");
	
	ПараметрыДанных = НОвый Структура;
	ПараметрыДанных.Вставить("ТекущаяДата", ТекущаяДатаСеанса());
	ПараметрыДанных.Вставить("ВидЦены", ВидЦены);
	СтруктураНастроек.Вставить("ПараметрыДанных", ПараметрыДанных);
	
	// Шаблоны этикеток и ценников.
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроек;
	
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "ПоляШаблонаБДТовары";
	
	Объект.Товары.Очистить();
	
	// Загрузка сформированного списка товаров.
	Таблица = Обработки.ВыгрузкаБазыТоваровВТСД.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из Таблица Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = СтрокаТЧ.Номенклатура;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
			НоваяСтрока.Характеристика       = СтрокаТЧ.Характеристика;
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
			НоваяСтрока.Упаковка             = СтрокаТЧ.Упаковка;
		КонецЕсли;
		
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(СтрокаТЧ.Штрихкод);
		НоваяСтрока.Цена                 = СтрокаТЧ.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоТоварамПересчетаНаСервере()
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПересчетТоваровТовары.Номенклатура,
	|	ПересчетТоваровТовары.Упаковка,
	|	ПересчетТоваровТовары.Характеристика,
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	РегистрЦеныНоменклатуры.Цена / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Цена
	|ИЗ
	|	Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ПересчетТоваровТовары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|			И ПересчетТоваровТовары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|			И ПересчетТоваровТовары.Упаковка = ШтрихкодыНоменклатуры.Упаковка
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ВидЦены = &ВидЦены) КАК РегистрЦеныНоменклатуры
	|		ПО ПересчетТоваровТовары.Номенклатура = РегистрЦеныНоменклатуры.Номенклатура
	|			И ПересчетТоваровТовары.Характеристика = РегистрЦеныНоменклатуры.Характеристика
	|
	|ГДЕ
	|	ПересчетТоваровТовары.Ссылка = &ПересчетТоваров");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РегистрЦеныНоменклатуры.Упаковка",
			"РегистрЦеныНоменклатуры.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ПересчетТоваровТовары.Упаковка",
			"ПересчетТоваровТовары.Номенклатура"));
	
	Запрос.УстановитьПараметр("ПересчетТоваров", Пересчет);
	Запрос.УстановитьПараметр("ТекущаяДата",     ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦены",         ВидЦены);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = Выборка.Номенклатура;
		НоваяСтрока.Характеристика       = Выборка.Характеристика;
		НоваяСтрока.Упаковка             = Выборка.Упаковка;
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(Выборка.Штрихкод);
		НоваяСтрока.Цена                 = Выборка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДвижениямНаСервере()
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка,
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	РегистрЦеныНоменклатуры.Цена / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Цена
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ВидЦены = &ВидЦены) КАК РегистрЦеныНоменклатуры
	|		ПО ШтрихкодыНоменклатуры.Номенклатура = РегистрЦеныНоменклатуры.Номенклатура
	|			И ШтрихкодыНоменклатуры.Характеристика = РегистрЦеныНоменклатуры.Характеристика
	|
	|ГДЕ
	|	(ШтрихкодыНоменклатуры.Номенклатура, ШтрихкодыНоменклатуры.Характеристика) В
	|			(ВЫБРАТЬ
	|				ДвижениеТоваровОбороты.Номенклатура,
	|				ДвижениеТоваровОбороты.Характеристика
	|			ИЗ
	|				РегистрНакопления.ТоварыНаСкладах.Обороты(&НачалоПериода, &КонецПериода, Авто, ) КАК ДвижениеТоваровОбороты)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РегистрЦеныНоменклатуры.Упаковка",
			"РегистрЦеныНоменклатуры.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ШтрихкодыНоменклатуры.Упаковка",
			"ШтрихкодыНоменклатуры.Номенклатура"));
	
	Запрос.УстановитьПараметр("НачалоПериода", СтандартныйПериод.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",  СтандартныйПериод.ДатаОкончания);
	Запрос.УстановитьПараметр("ТекущаяДата",   ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦены",       ВидЦены);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = Выборка.Номенклатура;
		НоваяСтрока.Характеристика       = Выборка.Характеристика;
		НоваяСтрока.Упаковка             = Выборка.Упаковка;
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(Выборка.Штрихкод);
		НоваяСтрока.Цена                 = Выборка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоРаспоряжениямНаПриемкуИОтгрузкуНаСервере()
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка,
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	РегистрЦеныНоменклатуры.Цена / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Цена
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ВидЦены = &ВидЦены) КАК РегистрЦеныНоменклатуры
	|		ПО ШтрихкодыНоменклатуры.Номенклатура = РегистрЦеныНоменклатуры.Номенклатура
	|			И ШтрихкодыНоменклатуры.Характеристика = РегистрЦеныНоменклатуры.Характеристика
	|
	|ГДЕ
	|	(ШтрихкодыНоменклатуры.Номенклатура, ШтрихкодыНоменклатуры.Характеристика) В
	|			(
	|			ВЫБРАТЬ
	|				РегистрНакопленияТоварыКОтгрузкеОстатки.Номенклатура,
	|				РегистрНакопленияТоварыКОтгрузкеОстатки.Характеристика
	|			ИЗ
	|				РегистрНакопления.ТоварыКОтгрузке.Остатки(&Дата, Склад = &Склад) КАК РегистрНакопленияТоварыКОтгрузкеОстатки)
	|	ИЛИ (ШтрихкодыНоменклатуры.Номенклатура, ШтрихкодыНоменклатуры.Характеристика) В
	|			(
	|			ВЫБРАТЬ
	|				ТоварыКПоступлениюОстаткиНаДату.Номенклатура,
	|				ТоварыКПоступлениюОстаткиНаДату.Характеристика
	|			ИЗ
	|				РегистрНакопления.ТоварыКПоступлению.Остатки(&Дата, Склад = &Склад) КАК ТоварыКПоступлениюОстаткиНаДату
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКПоступлению.Остатки(, Склад = &Склад) КАК ТоварыКПоступлениюОстаткиТекущие
	|					ПО ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления = ТоварыКПоступлениюОстаткиТекущие.ДокументПоступления
	|						И ТоварыКПоступлениюОстаткиНаДату.Номенклатура = ТоварыКПоступлениюОстаткиТекущие.Номенклатура
	|						И ТоварыКПоступлениюОстаткиНаДату.Характеристика = ТоварыКПоступлениюОстаткиТекущие.Характеристика
	|						И ТоварыКПоступлениюОстаткиНаДату.Склад = ТоварыКПоступлениюОстаткиТекущие.Склад
	|)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РегистрЦеныНоменклатуры.Упаковка",
			"РегистрЦеныНоменклатуры.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ШтрихкодыНоменклатуры.Упаковка",
			"ШтрихкодыНоменклатуры.Номенклатура"));
	
	Запрос.УстановитьПараметр("Склад",       СкладОтгрузки);
	Запрос.УстановитьПараметр("Дата",        ?(ЗначениеЗаполнено(ДатаОтгрузки), КонецДня(ДатаОтгрузки), ТекущаяДата()));
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦены",     ВидЦены);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = Выборка.Номенклатура;
		НоваяСтрока.Характеристика       = Выборка.Характеристика;
		НоваяСтрока.Упаковка             = Выборка.Упаковка;
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(Выборка.Штрихкод);
		НоваяСтрока.Цена                 = Выборка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоРаспоряжениямНаОтгрузкуНаСервере()
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка,
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	РегистрЦеныНоменклатуры.Цена / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Цена
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ВидЦены = &ВидЦены) КАК РегистрЦеныНоменклатуры
	|		ПО ШтрихкодыНоменклатуры.Номенклатура = РегистрЦеныНоменклатуры.Номенклатура
	|			И ШтрихкодыНоменклатуры.Характеристика = РегистрЦеныНоменклатуры.Характеристика
	|
	|ГДЕ
	|	(ШтрихкодыНоменклатуры.Номенклатура, ШтрихкодыНоменклатуры.Характеристика) В
	|			(
	|			ВЫБРАТЬ
	|				РегистрНакопленияТоварыКОтгрузкеОстатки.Номенклатура,
	|				РегистрНакопленияТоварыКОтгрузкеОстатки.Характеристика
	|			ИЗ
	|				РегистрНакопления.ТоварыКОтгрузке.Остатки(&ДатаОтгрузки, Склад = &Склад) КАК РегистрНакопленияТоварыКОтгрузкеОстатки
	|)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РегистрЦеныНоменклатуры.Упаковка",
			"РегистрЦеныНоменклатуры.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ШтрихкодыНоменклатуры.Упаковка",
			"ШтрихкодыНоменклатуры.Номенклатура"));
	
	Запрос.УстановитьПараметр("Склад",        СкладОтгрузки);
	Запрос.УстановитьПараметр("ДатаОтгрузки", ?(ЗначениеЗаполнено(ДатаОтгрузки), КонецДня(ДатаОтгрузки), ТекущаяДата()));
	Запрос.УстановитьПараметр("ТекущаяДата",  ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦены",      ВидЦены);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = Выборка.Номенклатура;
		НоваяСтрока.Характеристика       = Выборка.Характеристика;
		НоваяСтрока.Упаковка             = Выборка.Упаковка;
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(Выборка.Штрихкод);
		НоваяСтрока.Цена                 = Выборка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоРаспоряжениямНаПриемкуНаСервере()
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка,
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	РегистрЦеныНоменклатуры.Цена / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК Цена
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ВидЦены = &ВидЦены) КАК РегистрЦеныНоменклатуры
	|		ПО ШтрихкодыНоменклатуры.Номенклатура = РегистрЦеныНоменклатуры.Номенклатура
	|			И ШтрихкодыНоменклатуры.Характеристика = РегистрЦеныНоменклатуры.Характеристика
	|
	|ГДЕ
	|	(ШтрихкодыНоменклатуры.Номенклатура, ШтрихкодыНоменклатуры.Характеристика) В
	|			(
	|			ВЫБРАТЬ
	|				ТоварыКПоступлениюОстаткиНаДату.Номенклатура,
	|				ТоварыКПоступлениюОстаткиНаДату.Характеристика
	|			ИЗ
	|				РегистрНакопления.ТоварыКПоступлению.Остатки(&ДатаПоступления, Склад = &Склад) КАК ТоварыКПоступлениюОстаткиНаДату
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКПоступлению.Остатки(, Склад = &Склад) КАК ТоварыКПоступлениюОстаткиТекущие
	|					ПО ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления = ТоварыКПоступлениюОстаткиТекущие.ДокументПоступления
	|						И ТоварыКПоступлениюОстаткиНаДату.Номенклатура = ТоварыКПоступлениюОстаткиТекущие.Номенклатура
	|						И ТоварыКПоступлениюОстаткиНаДату.Характеристика = ТоварыКПоступлениюОстаткиТекущие.Характеристика
	|						И ТоварыКПоступлениюОстаткиНаДату.Склад = ТоварыКПоступлениюОстаткиТекущие.Склад
	|)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"РегистрЦеныНоменклатуры.Упаковка",
			"РегистрЦеныНоменклатуры.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ШтрихкодыНоменклатуры.Упаковка",
			"ШтрихкодыНоменклатуры.Номенклатура"));
	
	Запрос.УстановитьПараметр("Склад",           СкладПриемки);
	Запрос.УстановитьПараметр("ДатаПоступления", ?(ЗначениеЗаполнено(ДатаПриемки), КонецДня(ДатаПриемки), ТекущаяДата()));
	Запрос.УстановитьПараметр("ТекущаяДата",     ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦены",         ВидЦены);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = Выборка.Номенклатура;
		НоваяСтрока.Характеристика       = Выборка.Характеристика;
		НоваяСтрока.Упаковка             = Выборка.Упаковка;
		НоваяСтрока.Штрихкод             = РегистрыСведений.ШтрихкодыНоменклатуры.ПодготовитьШтрихкод(Выборка.Штрихкод);
		НоваяСтрока.Цена                 = Выборка.Цена;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВариантЗаполнения = "ПоОтбору" Тогда
		ЗаполнитьПоОтборуНаСервере();
	ИначеЕсли ВариантЗаполнения = "ПоТоварамПересчета" Тогда
		ЗаполнитьПоТоварамПересчетаНаСервере();
	ИначеЕсли ВариантЗаполнения = "ПоДвижениям" Тогда
		ЗаполнитьПоДвижениямНаСервере();
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаПриемкуИОтгрузку" Тогда
		ЗаполнитьПоРаспоряжениямНаПриемкуИОтгрузкуНаСервере();
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаОтгрузку" Тогда
		ЗаполнитьПоРаспоряжениямНаОтгрузкуНаСервере();
	ИначеЕсли ВариантЗаполнения = "ПоРаспоряжениямНаПриемку" Тогда
		ЗаполнитьПоРаспоряжениямНаПриемкуНаСервере();
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		СтрокаТЧ.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ВыгрузкаБазыТоваровВТСД.ПолучитьМакет("ПоляШаблонаБДТовары");
	
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаСервере
Функция УстановитьНовыеШтрихкодыEAN13НаСервере(ОписаниеОшибки = "")
	
	Количество = 0;
	
	МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
	
	Штрихкоды = Новый Соответствие;
	
	МаксимальныеЗначенияКодовШтучныхШтрихкодов = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьМаксимальныеЗначенияКодовШтучныхШтрихкодов();
	МаксимальныйКодШтучногоТовара              = РегистрыСведений.ШтрихкодыНоменклатуры.МаксимальныйКодШтучногоТовара();
	ПрефиксУзлаШтрихкода                       = РегистрыСведений.ШтрихкодыНоменклатуры.ПрефиксУзлаШтрихкода();
	
	НачатьТранзакцию();
	
	Попытка
	
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(НомерСтроки);
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Штрихкод) Тогда
			Количество = Количество + 1;
		Иначе
			Продолжить;
		КонецЕсли;
		
		Код = Неопределено;
		Диапазон = Неопределено;
		
		Для Каждого СтрокаТЧМаксимальныеЗначения Из МаксимальныеЗначенияКодовШтучныхШтрихкодов Цикл
			
			Если Не СтрокаТЧМаксимальныеЗначения.Код < МаксимальныйКодШтучногоТовара Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаТЧМаксимальныеЗначения.Код = СтрокаТЧМаксимальныеЗначения.Код + 1;
			
			Код      = СтрокаТЧМаксимальныеЗначения.Код; 
			Диапазон = СтрокаТЧМаксимальныеЗначения.Диапазон;
			
			Прервать;
		КонецЦикла;
		
		Если Код = Неопределено Тогда
			ВызватьИсключение РегистрыСведений.ШтрихкодыНоменклатуры.ТекстСообщенияНетСвободныхКодовШтучныхШтрихкодов();
		КонецЕсли;
		
		Штрихкод = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьШтрихкодПоКоду(Код, Диапазон, ПрефиксУзлаШтрихкода);
		
		НовыйШтрихкод = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
		НовыйШтрихкод.Номенклатура = СтрокаТЧ.Номенклатура; 
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
			НовыйШтрихкод.Характеристика = СтрокаТЧ.Характеристика;
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
			НовыйШтрихкод.Упаковка       = СтрокаТЧ.Упаковка;
		КонецЕсли;
		
		НовыйШтрихкод.Штрихкод = Штрихкод;
		НовыйШтрихкод.Записать();
		
		Штрихкоды.Вставить(СтрокаТЧ, НовыйШтрихкод.Штрихкод);
		
	КонецЦикла;
	
	Исключение
		ОтменитьТранзакцию();
		
		ОписаниеОшибки = НСтр("ru='При записи штрихкодов произошла ошибка.
                              |Запись штрихкодов не выполнена.
                              |Дополнительное описание:
                              |%ДополнительноеОписание%'
                              |;uk='При запису штрихкодів сталася помилка.
                              |Запис штрихкодів не виконаний.
                              |Додатковий опис:
                              |%ДополнительноеОписание%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%ДополнительноеОписание%", ИнформацияОбОшибке().Описание);
		
		Возврат 0;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Для Каждого КлючИЗначение Из Штрихкоды Цикл
		КлючИЗначение.Ключ.Штрихкод = КлючИЗначение.Значение;
	КонецЦикла;
	
	Возврат Количество;
	
КонецФункции

&НаСервере
Функция ВыполнитьПроверку()
	
	ЕстьОшибки = Ложь;
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		Если НЕ СтрокаТЧ.Выбран Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСтроки = СтрокаТЧ.НомерСтроки - 1;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Штрихкод) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнено поле ""Штрихкод"" в строке %1';uk='Не заповнене поле ""Штрихкод"" в рядку %1'"),
					НомерСтроки+1
				),
				,
				"Объект.Товары["+НомерСтроки+"].Штрихкод",
				,
				ЕстьОшибки);
			
		КонецЕсли;
	
	КонецЦикла;

	Возврат Новый Структура("ТоварыВыбраны, ПроверкаВыполнена", Объект.Товары.НайтиСтроки(Новый Структура("Выбран", Истина)).Количество() > 0, Не ЕстьОшибки);
	
КонецФункции

&НаКлиенте
Процедура ВариантОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
