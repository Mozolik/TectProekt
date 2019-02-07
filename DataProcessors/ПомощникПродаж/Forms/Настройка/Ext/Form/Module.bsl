﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьСтатусыРеализацийТоваровУслуг = ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРеализацийТоваровУслуг");
	ИспользоватьРасширенныеВозможностиЗаказаКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	
	СтруктураПараметров = ПолучитьПараметры(Параметры);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПараметров);
	
	ЕстьПравоПечатиПКО = ПравоДоступа("Добавление",Метаданные.Документы.ПриходныйКассовыйОрдер);
	
	ИнициализироватьВариантыОформленияДокументовПродажи();
	УстановитьДоступностьСчетаНаОплатуПриходногоКассовогоОрдера(ЭтаФорма);
	УстановитьДоступностьКоммерческогоПредложения(ЭтаФорма);
	УстановитьДоступностьЗаказаКлиента(ЭтаФорма);
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	УстановитьДоступностьВидимостьТранспортнойНакладной(ЭтаФорма);
	УстановитьТекущуюСтраницуВариантовОформления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗакрытьФормуПринудительно Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
		
		Отказ = Истина;
		ДополнительныеПараметры = Новый Структура;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru='Параметры помощника продаж были изменены. Закрыть форму без сохранения параметров?';uk='Параметри помічника продажів були змінені. Закрити форму без збереження параметрів?'"),
			СписокКнопок);
		Возврат;
		
	КонецЕсли;
	
	ПередЗакрытиемЗавершение(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Отказ)
	
	Если СохранитьПараметры Тогда
		
		ОчиститьСообщения();
		
		Если СоздаватьКоммерческоеПредложение И Не ЗначениеЗаполнено(СтатусКоммерческогоПредложения) Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Поле ""Статус коммерческого предложения"" не заполнено';uk='Поле ""Статус комерційної пропозиції"" не заповнено'"),
				,
				"СтатусКоммерческогоПредложения",
				,
				Отказ);
			СохранитьПараметры = Ложь;
		
		КонецЕсли;
		
		Если ИспользоватьРасширенныеВозможностиЗаказаКлиента И СоздаватьЗаказКлиента И Не ЗначениеЗаполнено(СтатусЗаказаКлиента) Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Поле ""Статус заказа клиента"" не заполнено';uk='Поле ""Статус замовлення клієнта"" не заповнено'"),
				,
				"СтатусЗаказаКлиента",
				,
				Отказ);
			СохранитьПараметры = Ложь;
		
		КонецЕсли;
		
		Если ИспользоватьСтатусыРеализацийТоваровУслуг
			И СоздаватьДокументПродажи
			И Не ЗначениеЗаполнено(СтатусРеализацииТоваровУслуг) Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Поле ""Статус реализации"" не заполнено';uk='Поле ""Статус реалізації"" не заповнено'"),
				,
				"СтатусРеализацииТоваровУслуг",
				,
				Отказ);
			СохранитьПараметры = Ложь;
		
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВариантОформленияДокументов) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Поле ""Оформить"" не заполнено';uk='Поле ""Оформити"" не заповнено'"),
				,
				"ВариантОформленияДокументов",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеЗакрывать" Тогда
		СохранитьПараметры = Ложь;
	КонецЕсли;
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ЗакрытьФормуПринудительно = Истина;
	КонецЕсли;
	
	Отказ = Ложь;
	ПередЗакрытиемЗавершение(Отказ);
	Если Отказ = Истина Тогда
		ЗакрытьФормуПринудительно = Ложь;
	КонецЕсли;
	
	Если ЗакрытьФормуПринудительно Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если СохранитьПараметры Тогда
		
		СтруктураПараметров = ПолучитьПараметры(ЭтаФорма);
		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоздаватьСчетНаОплатуПриИзменении(Элемент)
	
	УстановитьДоступностьСчетаНаОплату(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьПриходныйКассовыйОрдерПриИзменении(Элемент)
	
	Если НЕ ЕстьПравоПечатиПКО Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недостаточно прав на создание ПКО.';uk='Недостатньо прав на створення ПКО.'"));
	КонецЕсли;
	
	УстановитьДоступностьПриходногоКассовогоОрдера(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьПараметры = Истина;
	ЗакрытьФормуПринудительно = Ложь;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусКоммерческогоПредложения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоздаватьКоммерческоеПредложение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусКоммерческогоПредложения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЗаказаКлиента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоздаватьЗаказКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗаказаКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусРеализацииТоваровУслуг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоздаватьДокументПродажи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусРеализацииТоваровУслуг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусКоммерческогоПредложения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусКоммерческогоПредложения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЗаказаКлиента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗаказаКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусРеализацииТоваровУслуг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусРеализацииТоваровУслуг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПараметры(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ПечататьАктВыполненныхРабот",              Источник.ПечататьАктВыполненныхРабот);
	СтруктураПараметров.Вставить("ПечататьЗаказКлиента",                     Источник.ПечататьЗаказКлиента);
	СтруктураПараметров.Вставить("ПечататьКоммерческоеПредложение",          Источник.ПечататьКоммерческоеПредложение);
	СтруктураПараметров.Вставить("ПечататьПриходныйКассовыйОрдер",           Источник.ПечататьПриходныйКассовыйОрдер);
	СтруктураПараметров.Вставить("ПечататьРеализациюТоваровУслуг",           Источник.ПечататьРеализациюТоваровУслуг);
	СтруктураПараметров.Вставить("ПечататьСчетНаОплату",                     Источник.ПечататьСчетНаОплату);
	СтруктураПараметров.Вставить("СоздаватьДокументПродажи",                 Источник.СоздаватьДокументПродажи);
	СтруктураПараметров.Вставить("СоздаватьЗаказКлиента",                    Источник.СоздаватьЗаказКлиента);
	СтруктураПараметров.Вставить("СоздаватьКоммерческоеПредложение",         Источник.СоздаватьКоммерческоеПредложение);
	СтруктураПараметров.Вставить("СоздаватьПриходныйКассовыйОрдер",          Источник.СоздаватьПриходныйКассовыйОрдер);
	СтруктураПараметров.Вставить("СоздаватьСчетНаОплату",                    Источник.СоздаватьСчетНаОплату);
	СтруктураПараметров.Вставить("СтатусЗаказаКлиента",                      Источник.СтатусЗаказаКлиента);
	СтруктураПараметров.Вставить("СтатусКоммерческогоПредложения",           Источник.СтатусКоммерческогоПредложения);
	СтруктураПараметров.Вставить("СтатусРеализацииТоваровУслуг",             Источник.СтатусРеализацииТоваровУслуг);	
	СтруктураПараметров.Вставить("СоздаватьТранспортнуюНакладнуюПоУмолчанию",Источник.СоздаватьТранспортнуюНакладнуюПоУмолчанию);
	СтруктураПараметров.Вставить("ВариантОформленияДокументов",                   Источник.ВариантОформленияДокументов);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзменениеФлага(Реквизит, ЗависимыеЭлементы = Неопределено, ЗависимыйРеквизит = Неопределено)
	
	Если ТипЗнч(ЗависимыеЭлементы) = Тип("Массив") Тогда
		Для каждого ЗависимыйЭлемент Из ЗависимыеЭлементы Цикл
			ЗависимыйЭлемент.Доступность = Реквизит;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЗависимыеЭлементы) = Тип("ПолеФормы") Тогда
		ЗависимыеЭлементы.Доступность = Реквизит;
	КонецЕсли;
	
	Если Не Реквизит Тогда
		ЗависимыйРеквизит = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСчетаНаОплатуПриходногоКассовогоОрдера(Форма)
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи,
		,
		Форма.СоздаватьСчетНаОплату);
		
	МассивЭлементовПечататьСчетНаОплату = Новый Массив;
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплату);
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплатуЗаказРеализация);
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплатуРеализация);
	
	ОбработатьИзменениеФлага(
		(Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи) И Форма.СоздаватьСчетНаОплату,
		МассивЭлементовПечататьСчетНаОплату,
		Форма.ПечататьСчетНаОплату);
		
	ОбработатьИзменениеФлага(
		Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи,
		,
		Форма.СоздаватьПриходныйКассовыйОрдер);
		
	МассивЭлементовПечататьПКО = Новый Массив;
	МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдер);
	МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдерЗаказРеализация);
	МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдерРеализация);
	
	ОбработатьИзменениеФлага(
		(Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи) И Форма.СоздаватьПриходныйКассовыйОрдер,
		МассивЭлементовПечататьПКО,
		Форма.ПечататьПриходныйКассовыйОрдер);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКоммерческогоПредложения(Форма)
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьКоммерческоеПредложение,
		Форма.Элементы.ПечататьКоммерческоеПредложение,
		Форма.ПечататьКоммерческоеПредложение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЗаказаКлиента(Форма)
	
	МассивЭлементовПечататьЗаказ = Новый Массив;
	МассивЭлементовПечататьЗаказ.Добавить(Форма.Элементы.ПечататьЗаказКлиента);
	МассивЭлементовПечататьЗаказ.Добавить(Форма.Элементы.ПечататьЗаказКлиентаЗаказРеализация);
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьЗаказКлиента,
		МассивЭлементовПечататьЗаказ,
		Форма.ПечататьЗаказКлиента);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСчетаНаОплату(Форма)
	
	МассивЭлементовПечататьСчетНаОплату = Новый Массив;
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплату);
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплатуЗаказРеализация);
	МассивЭлементовПечататьСчетНаОплату.Добавить(Форма.Элементы.ПечататьСчетНаОплатуРеализация);
	
	ОбработатьИзменениеФлага(
		(Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи) И Форма.СоздаватьСчетНаОплату,
		МассивЭлементовПечататьСчетНаОплату,
		Форма.ПечататьСчетНаОплату);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьДокументаПродажи(Форма)
	
	МассивЭлементовПечататьРеализацию = Новый Массив;
	МассивЭлементовПечататьРеализацию.Добавить(Форма.Элементы.ПечататьРеализацию);
	МассивЭлементовПечататьРеализацию.Добавить(Форма.Элементы.ПечататьРеализациюЗаказРеализация);
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		МассивЭлементовПечататьРеализацию,
		Форма.ПечататьРеализациюТоваровУслуг);
		
	МассивЭлементовПечататьАкт = Новый Массив;
	МассивЭлементовПечататьАкт.Добавить(Форма.Элементы.ПечататьАкт);
	МассивЭлементовПечататьАкт.Добавить(Форма.Элементы.ПечататьАктЗаказРеализация);
		
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		МассивЭлементовПечататьАкт,
		Форма.ПечататьАктВыполненныхРабот);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПриходногоКассовогоОрдера(Форма)
	
	Если Форма.ЕстьПравоПечатиПКО Тогда
		МассивЭлементовПечататьПКО = Новый Массив;
		МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдер);
		МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдерЗаказРеализация);
		МассивЭлементовПечататьПКО.Добавить(Форма.Элементы.ПечататьПриходныйКассовыйОрдерРеализация);
		
		ОбработатьИзменениеФлага(
			(Форма.СоздаватьЗаказКлиента Или Форма.СоздаватьДокументПродажи) И Форма.СоздаватьПриходныйКассовыйОрдер,
			МассивЭлементовПечататьПКО,
			Форма.ПечататьПриходныйКассовыйОрдер);
	Иначе
		Форма.СоздаватьПриходныйКассовыйОрдер = Ложь;
		Форма.ПечататьПриходныйКассовыйОрдер = Ложь;
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьВидимостьТранспортнойНакладной(Форма)
	
	Форма.Элементы.ГруппаТранспортнаяНакладная.Доступность = Форма.СоздаватьДокументПродажи;
	Форма.Элементы.ГруппаТранспортнаяНакладнаяЗаказРеализация.Доступность = Форма.СоздаватьДокументПродажи;
	Если Не Форма.СоздаватьДокументПродажи Тогда 
		Форма.СоздаватьТранспортнуюНакладнуюПоУмолчанию = Ложь;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ВариантОформленияДокументовПриИзменении(Элемент)
	УстановитьТекущуюСтраницуВариантовОформления(ЭтаФорма);
	УстановитьДоступностьСчетаНаОплатуПриходногоКассовогоОрдера(ЭтаФорма);
	УстановитьДоступностьКоммерческогоПредложения(ЭтаФорма);
	УстановитьДоступностьЗаказаКлиента(ЭтаФорма);
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	УстановитьДоступностьВидимостьТранспортнойНакладной(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуВариантовОформления(Форма)
	
	Элементы = Форма.Элементы;
	ВариантОформленияДокументов = Форма.ВариантОформленияДокументов;
	Если ВариантОформленияДокументов = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение") Тогда
		Элементы.ГруппаСтраницыВарианты.ТекущаяСтраница = Элементы.ГруппаСтраницаКомерческоеПредложение;
		Форма.СоздаватьКоммерческоеПредложение = Истина;
		Форма.СоздаватьЗаказКлиента = Ложь;
		Форма.СоздаватьДокументПродажи = Ложь;
	ИначеЕсли ВариантОформленияДокументов = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиента") Тогда
		Элементы.ГруппаСтраницыВарианты.ТекущаяСтраница = Элементы.ГруппаСтраницаЗаказКлиента;
		Форма.СоздаватьКоммерческоеПредложение = Ложь;
		Форма.СоздаватьЗаказКлиента = Истина;
		Форма.СоздаватьДокументПродажи = Ложь;
	ИначеЕсли ВариантОформленияДокументов = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг") Тогда
		Элементы.ГруппаСтраницыВарианты.ТекущаяСтраница = Элементы.ГруппаСтраницаРеализация;
		Форма.СоздаватьКоммерческоеПредложение = Ложь;
		Форма.СоздаватьЗаказКлиента = Ложь;
		Форма.СоздаватьДокументПродажи = Истина;
	иначеЕсли ВариантОформленияДокументов = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг") Тогда
		Элементы.ГруппаСтраницыВарианты.ТекущаяСтраница = Элементы.ГруппаСтраницаЗаказКлиентаРеализация;
		Форма.СоздаватьКоммерческоеПредложение = Ложь;
		Форма.СоздаватьЗаказКлиента = Истина;
		Форма.СоздаватьДокументПродажи = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьВариантыОформленияДокументовПродажи()
	
	ИспользоватьКоммерческиеПредложенияКлиентам = ПолучитьФункциональнуюОпцию("ИспользоватьКоммерческиеПредложенияКлиентам");
	ИспользоватьЗаказыКлиентов = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов");
	
	Элементы.ВариантОформленияДокументов.СписокВыбора.Очистить();
	
	Если ИспользоватьКоммерческиеПредложенияКлиентам Тогда
		Элементы.ВариантОформленияДокументов.СписокВыбора.Добавить(Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение);
	КонецЕсли;
	
	Если ИспользоватьЗаказыКлиентов Тогда
		Элементы.ВариантОформленияДокументов.СписокВыбора.Добавить(Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиента);
	КонецЕсли;
	
	Элементы.ВариантОформленияДокументов.СписокВыбора.Добавить(Перечисления.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг);
	
	Если ИспользоватьЗаказыКлиентов Тогда
		Элементы.ВариантОформленияДокументов.СписокВыбора.Добавить(Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг);
	КонецЕсли;
	
	Если Элементы.ВариантОформленияДокументов.СписокВыбора.Количество() > 1 Тогда
		Элементы.ВариантОформленияДокументов.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ВариантОформленияДокументов.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
