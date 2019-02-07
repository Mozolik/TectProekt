﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если НЕ Параметры.Свойство("СсылкаНаИсточник") Тогда
		Отказ = ИСТИНА;
	ИначеЕсли ТипЗнч(Параметры.СсылкаНаИсточник) = Тип("СправочникСсылка.ПравилаРаспределенияРасходов") Тогда
		НастройкаДляПодразделения = ЛОЖЬ;
		Показатель = Параметры.СсылкаНаИсточник;
		ТипПоказателя = Параметры.ТипПоказателя;
		Если Параметры.Свойство("НаДату") Тогда
			Период = Параметры.НаДату;
		КонецЕсли;
		Если Параметры.Свойство("ПодразделенияДляКоторыхНеВведеноЗначениеПоказателя") Тогда
			СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя.ЗагрузитьЗначения(Параметры.ПодразделенияДляКоторыхНеВведеноЗначениеПоказателя);
		КонецЕсли;
		Заголовок = НСтр("ru='Значения показателя для распределения расходов';uk='Значення показника для розподілу витрат'");
	ИначеЕсли ТипЗнч(Параметры.СсылкаНаИсточник) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		НастройкаДляПодразделения = ИСТИНА;
		Подразделение = Параметры.СсылкаНаИсточник;
		Заголовок = НСтр("ru='Значения показателей для распределения расходов';uk='Значення показників для розподілу витрат'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьВидимостьРеквизитов();
	Если НЕ ЗначениеЗаполнено(Период) Тогда 
		Период = ТекущаяДата();
	КонецЕсли;
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	ЗаполнитьТаблицуНастройки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Подразделение", Элемент.ТекущиеДанные.Подразделение);
	СтруктураПараметры.Вставить("Показатель", Элемент.ТекущиеДанные.Показатель);
	СтруктураПараметры.Вставить("ЗначениеПоказателя", Элемент.ТекущиеДанные.ЗначениеПоказателя);
	СтруктураПараметры.Вставить("ДействуетС", Период);
	
	Оповещение = Новый ОписаниеОповещения("ТаблицаНастройкиВыборЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Обработка.НастройкаЗначенийПоказателейДляРаспределенияРасходов.Форма.ФормаУстановкиЗначений",
		СтруктураПараметры, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		Период = ВыбранныйПериод;
		МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);

		ЗаполнитьТаблицуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, Период, МесяцСтрока);

	ЗаполнитьТаблицуНастройки();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьРеквизитов()

	Если НастройкаДляПодразделения Тогда
		Элементы.Показатель.Видимость = ЛОЖЬ;
	Иначе
		Элементы.Подразделение.Видимость = ЛОЖЬ;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуНастройки()

	Если НастройкаДляПодразделения Тогда
		ЗаполнитьДляПодразделения();
	Иначе
		ЗаполнитьДляПоказателя();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляПодразделения()

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДляПодразделения();
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НаДату", НачалоМесяца(Период));
	Запрос.УстановитьПараметр("БезФильтраПоОдномуПоказателю", Истина);
	Запрос.УстановитьПараметр("Показатель", Справочники.ПравилаРаспределенияРасходов.ПустаяСсылка());
	ТаблицаНастройки.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляПоказателя()

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДляПоказателя();
	Запрос.УстановитьПараметр("Показатель", Показатель);
	Запрос.УстановитьПараметр("НаДату", НачалоМесяца(Период));
	Запрос.УстановитьПараметр("БезФильтраПоОдномуПодразделению", Истина);
	Запрос.УстановитьПараметр("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	БезФильтраПоНеВведеннымЗначениямПоказателя = СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя.НайтиПоЗначению(Справочники.СтруктураПредприятия.ПустаяСсылка()) <> Неопределено;
	Если СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя.Количество() > 0 Тогда
		Запрос.УстановитьПараметр("СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя", СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя);
		Запрос.УстановитьПараметр("БезФильтраПоНеВведеннымЗначениямПоказателя", БезФильтраПоНеВведеннымЗначениямПоказателя);
	Иначе
		Запрос.УстановитьПараметр("СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя", Неопределено);
		Запрос.УстановитьПараметр("БезФильтраПоНеВведеннымЗначениямПоказателя", Истина);
	КонецЕсли;
	ТЗРезультат = Запрос.Выполнить().Выгрузить();
	ТЗРезультат.Колонки.Добавить("ПодразделениеПолноеНаименование");
	Для Каждого Строка Из ТЗРезультат Цикл
		Строка.ПодразделениеПолноеНаименование = Строка.Подразделение.ПолноеНаименование();
	КонецЦикла;
	ТЗРезультат.Сортировать("ПодразделениеПолноеНаименование", Новый СравнениеЗначений);
	ТаблицаНастройки.Загрузить(ТЗРезультат);

КонецПроцедуры

&НаСервере
Функция ТекстЗапросаДляПодразделения()
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	Показатели.Ссылка КАК Показатель,
	|	Показатели.БазаРаспределения КАК Вводится
	|ПОМЕСТИТЬ ВТПриИзменении
	|ИЗ
	|	Справочник.ПравилаРаспределенияРасходов КАК Показатели
	|ГДЕ
	|	Показатели.БазаРаспределения = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ВводитсяПриИзменении)
	|	И Показатели.ПометкаУдаления = ЛОЖЬ
	|	И (&БезФильтраПоОдномуПоказателю 
	|		ИЛИ Показатели.Ссылка = &Показатель)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Показатели.Ссылка КАК Показатель,
	|	Показатели.БазаРаспределения КАК Вводится
	|ПОМЕСТИТЬ ВТЕжемесячно
	|ИЗ
	|	Справочник.ПравилаРаспределенияРасходов КАК Показатели
	|ГДЕ
	|	Показатели.БазаРаспределения = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ВводитсяЕжемесячно)
	|	И Показатели.ПометкаУдаления = ЛОЖЬ
	|	И (&БезФильтраПоОдномуПоказателю 
	|		ИЛИ Показатели.Ссылка = &Показатель)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Подразделение КАК Подразделение,
	|	ВТПриИзменении.Показатель,
	|	ВТПриИзменении.Вводится,
	|	ЕСТЬNULL(ЗначенияПоказателейСрезПоследних.ЗначениеПоказателя, 0) КАК ЗначениеПоказателя,
	|	ЕСТЬNULL(ЗначенияПоказателейСрезПоследних.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДействуетС
	|ИЗ
	|	ВТПриИзменении КАК ВТПриИзменении
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПоказателейДляРаспределенияРасходов.СрезПоследних(&НаДату, Подразделение = &Подразделение) КАК ЗначенияПоказателейСрезПоследних
	|		ПО ВТПриИзменении.Показатель = ЗначенияПоказателейСрезПоследних.Показатель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Подразделение,
	|	ВТЕжемесячно.Показатель,
	|	ВТЕжемесячно.Вводится,
	|	ЕСТЬNULL(ЗначенияПоказателей.ЗначениеПоказателя, 0),
	|	ЕСТЬNULL(ЗначенияПоказателей.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|ИЗ
	|	ВТЕжемесячно КАК ВТЕжемесячно
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПоказателейДляРаспределенияРасходов КАК ЗначенияПоказателей
	|		ПО (ВТЕжемесячно.Показатель = ЗначенияПоказателей.Показатель
	|			И ЗначенияПоказателей.Период = &НаДату
	|			И ЗначенияПоказателей.Подразделение = &Подразделение)";

	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаДляПоказателя()
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	СтруктураПредприятия.Ссылка КАК Подразделение
	|ПОМЕСТИТЬ ВТПодразделения
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.ПометкаУдаления = ЛОЖЬ
	|	И (&БезФильтраПоНеВведеннымЗначениямПоказателя
	|	   ИЛИ СтруктураПредприятия.Ссылка В(&СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя)
	|	   )
	|	И (&БезФильтраПоОдномуПодразделению
	|	   ИЛИ СтруктураПредприятия.Ссылка = &Подразделение
	|	   )
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";
	
	Если ТипПоказателя = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяЕжемесячно Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	&Показатель КАК Показатель,
		|	ВТПодразделения.Подразделение,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ПустаяСсылка) КАК Вводится,
		|	ЕСТЬNULL(ЗначенияПоказателей.ЗначениеПоказателя, 0) КАК ЗначениеПоказателя,
		|	ЕСТЬNULL(ЗначенияПоказателей.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДействуетС
		|ИЗ
		|	ВТПодразделения КАК ВТПодразделения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПоказателейДляРаспределенияРасходов КАК ЗначенияПоказателей
		|		ПО (ВТПодразделения.Подразделение = ЗначенияПоказателей.Подразделение
		|			И ЗначенияПоказателей.Период = &НаДату
		|			И ЗначенияПоказателей.Показатель = &Показатель)";
		
	ИначеЕсли ТипПоказателя = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяПриИзменении Тогда 
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	&Показатель КАК Показатель,
		|	ВТПодразделения.Подразделение,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ПустаяСсылка) КАК Вводится,
		|	ЕСТЬNULL(ЗначенияПоказателейСрезПоследних.ЗначениеПоказателя, 0) КАК ЗначениеПоказателя,
		|	ЕСТЬNULL(ЗначенияПоказателейСрезПоследних.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДействуетС
		|ИЗ
		|	ВТПодразделения КАК ВТПодразделения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПоказателейДляРаспределенияРасходов.СрезПоследних(&НаДату, Показатель = &Показатель) КАК ЗначенияПоказателейСрезПоследних
		|		ПО ВТПодразделения.Подразделение = ЗначенияПоказателейСрезПоследних.Подразделение";
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаНастройкиВыборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		ТекущиеДанные = Элементы.ТаблицаНастройки.ТекущиеДанные;
		СтруктураПараметры = Новый Структура;
		СтруктураПараметры.Вставить("НаДату", НачалоМесяца(Период));
		СтруктураПараметры.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураПараметры.Вставить("Показатель", ТекущиеДанные.Показатель);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПеречитатьТекущуюСтроку(СтруктураПараметры));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПеречитатьТекущуюСтроку(Параметры)
	
	Запрос = Новый Запрос;
	Если НастройкаДляПодразделения Тогда
		Запрос.Текст = ТекстЗапросаДляПодразделения();
		Запрос.УстановитьПараметр("НаДату", Параметры.НаДату);
		Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);
		Запрос.УстановитьПараметр("Показатель", Параметры.Показатель);
		Запрос.УстановитьПараметр("БезФильтраПоОдномуПоказателю", Ложь);
	Иначе
		Запрос.Текст = ТекстЗапросаДляПоказателя();
		Запрос.УстановитьПараметр("НаДату", Параметры.НаДату);
		Запрос.УстановитьПараметр("Показатель", Параметры.Показатель);
		Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);
		Запрос.УстановитьПараметр("БезФильтраПоОдномуПодразделению", Ложь);
		Запрос.УстановитьПараметр("БезФильтраПоНеВведеннымЗначениямПоказателя", Истина); 
		Запрос.УстановитьПараметр("СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя", Неопределено);
	КонецЕсли;
	
	СтруктураРезультат = Новый Структура;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураРезультат.Вставить("Подразделение", Выборка.Подразделение);
		СтруктураРезультат.Вставить("ПодразделениеПолноеНаименование", Выборка.Подразделение.ПолноеНаименование());
		СтруктураРезультат.Вставить("Показатель", Выборка.Показатель);
		СтруктураРезультат.Вставить("ЗначениеПоказателя", Выборка.ЗначениеПоказателя);
		СтруктураРезультат.Вставить("ДействуетС", Выборка.ДействуетС);
		СтруктураРезультат.Вставить("Вводится", Выборка.Вводится);
		Возврат СтруктураРезультат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиПоказатель.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкаДляПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиПодразделениеПолноеНаименование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкаДляПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиДатаУстановки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиЗначениеПоказателя.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНастройки.ДействуетС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый СтандартнаяДатаНачала(Дата('00010101000000'));

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Не введено>';uk='<Не введено>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиВводится.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНастройки.Вводится");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяПриИзменении;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='При изменении';uk='При зміні'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиВводится.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНастройки.Вводится");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяЕжемесячно;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Ежемесячно';uk='Щомісяця'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастройкиВводится.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкаДляПодразделения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

#КонецОбласти
