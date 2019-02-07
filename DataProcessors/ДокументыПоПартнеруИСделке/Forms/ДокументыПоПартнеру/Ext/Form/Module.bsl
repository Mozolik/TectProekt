﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ИмяФормыНастройкаСоставаВидовДокументов = ОбработкаОбъект.Метаданные().ПолноеИмя()
			+ ".Форма.НастройкаСоставаВидовДокументов";

	УстановитьКлючНастроек();

	ЗаполнитьТаблицуЗапросов(ОбработкаОбъект);

	ОбновитьСписокВидовДокументов();

	ВосстановитьНастройки();

	ОбновитьТекстЗапроса();

	УстановитьЗначенияПоУмолчанию();

	ПрименитьПараметрыКоманды();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	СохранитьНастройки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Документ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСоставДокументов(Команда)

	РедактироватьСоставДокументов();

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();

	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ОбщегоНазначенияУТКлиент.РедактироватьПериод(ПериодВыборкиДокументов);

КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)

	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		ПоказатьЗначение(Неопределено, ТекущиеДанные.Документ);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

&НаСервере
Процедура ВосстановитьНастройки()

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ДокументыПоПартнеру", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда

		ЗначениеИзНастройки = ЗначениеНастроек.Получить("СписокВидовДокументов");
		Если ТипЗнч(ЗначениеИзНастройки) = Тип("СписокЗначений") Тогда
			ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеИзНастройки);
		КонецЕсли;

		ПериодВыборкиДокументов.ДатаНачала    = ЗначениеНастроек.Получить("ДатаНачала");
		ПериодВыборкиДокументов.ДатаОкончания = ЗначениеНастроек.Получить("ДатаОкончания");

		Партнер = ЗначениеНастроек.Получить("Параметр");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Настройки = Новый Соответствие;
	Настройки.Вставить("Партнер",               Параметр);
	Настройки.Вставить("СписокВидовДокументов", СписокВидовДокументов);
	Настройки.Вставить("ДатаНачала",            ПериодВыборкиДокументов.ДатаНачала);
	Настройки.Вставить("ДатаОкончания",         ПериодВыборкиДокументов.ДатаОкончания);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ДокументыПоПартнеру", КлючНастроек, Настройки);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()

	Если Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаНачала)
	 Или Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаОкончания) Тогда

		ПериодВыборкиДокументов.ДатаНачала    = ДобавитьМесяц(ТекущаяДата(), - 12);
		ПериодВыборкиДокументов.ДатаОкончания = ТекущаяДата();

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрименитьПараметрыКоманды()

	Если Параметры.Свойство("Отбор") Тогда

		Параметры.Отбор.Свойство("Партнер", Параметр);
	
	КонецЕсли;

	Если Параметры.Свойство("СформироватьПриОткрытии") И Параметры.СформироватьПриОткрытии Тогда

		ОбновитьТаблицуДокументовНаСервере();

	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Элементы.Параметр.Видимость = Истина;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			Элементы.Параметр.Заголовок = НСтр("ru='Контрагент';uk='Контрагент'");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьКлючНастроек()

	Если Параметры.Свойство("КлючНастроек") И Не ПустаяСтрока(Параметры.КлючНастроек) Тогда

		КлючНастроек = Параметры.КлючНастроек;

	Иначе

		КлючНастроек = "БезПартнера";

	КонецЕсли;

	КлючНастроек = КлючНастроек + "_" + Пользователи.ТекущийПользователь().УникальныйИдентификатор();

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Партнер") Тогда

		КлючНастроек = КлючНастроек + "_" + Параметры.Отбор.Партнер.УникальныйИдентификатор();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьТаблицуЗапросов(ОбработкаОбъект)

	ДополнительныеДокументы = Новый Массив;
	ДополнительныеДокументы.Добавить(Метаданные.Документы.РасходныйОрдерНаТовары);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПриходныйОрдерНаТовары);

	ПоляШапки = Новый Массив;
	ПоляШапки.Добавить("СуммаДокумента");
	ПоляШапки.Добавить("Валюта");
	ПоляШапки.Добавить("Склад");
	ПоляШапки.Добавить("Организация");

	ОбработкаОбъект.ЗаполнитьТаблицуЗапросов(ТаблицаЗапросов, "ДокументыПоПартнеру",
			ДополнительныеДокументы,
			ПоляШапки);

КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстЗапроса()

	ВремТекстЗапросаВт     = "";
	ВремТекстЗапросаДанные = "";
	Для Каждого СтрокаТаб Из ТаблицаЗапросов.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл

		ВремТекстЗапросаВт = ВремТекстЗапросаВт + ?(ПустаяСтрока(ВремТекстЗапросаВт), "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ СтрокаТаб.ТекстЗапроса;

		ВремТекстЗапросаДанные = ВремТекстЗапросаДанные + ?(ПустаяСтрока(ВремТекстЗапросаДанные), "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ СтрокаТаб.ТекстЗапросаВыборка;

	КонецЦикла;

	Позиция = СтрНайти(ВРЕГ(ВремТекстЗапросаВт), ВРег("//%ПОМЕСТИТЬ%"));
	Если Позиция > 0 Тогда

		ВремТекстЗапросаВт = ЛЕВ(ВремТекстЗапросаВт, Позиция-1) + Сред(ВремТекстЗапросаВт, Позиция + СтрДлина("//%ПОМЕСТИТЬ%"));

	КонецЕсли;

	Позиция = СтрНайти(ВРЕГ(ВремТекстЗапросаДанные), ВРег("Выбрать"));
	Если Позиция > 0 Тогда

		ВремТекстЗапросаДанные = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + Сред(ВремТекстЗапросаДанные, Позиция + СтрДлина("Выбрать")) + 
		"УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Документ
		|";

	КонецЕсли;

	ТекстЗапросаФильтр       = ВремТекстЗапросаВт;
	ТекстЗапросаПоДокументам = ВремТекстЗапросаДанные;

КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакИспользованияВидаДокумента()

	Для Каждого СтрокаТаб Из ТаблицаЗапросов Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(СтрокаТаб.ИмяДокумента);
		Если ЭлементСписка <> Неопределено Тогда
			СтрокаТаб.Использовать = ЭлементСписка.Пометка;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВидовДокументов()

	СписокВидовДокументов.Очистить();
	Для Каждого Строка Из ТаблицаЗапросов Цикл
		СписокВидовДокументов.Добавить(Строка.ИмяДокумента, Строка.СинонимДокумента, Строка.Использовать);
	КонецЦикла;

	СписокВидовДокументов.СортироватьПоЗначению(НаправлениеСортировки.Возр);

КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеНастройки)

	ПереформироватьЗапрос = Ложь;
	Для Каждого Элемент Из ЗначениеНастройки Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ЭлементСписка.Пометка <> Элемент.Пометка Тогда

			ЭлементСписка.Пометка = Элемент.Пометка;
			ПереформироватьЗапрос = Истина;

		КонецЕсли;

	КонецЦикла;

	Если ПереформироватьЗапрос Тогда

		УстановитьПризнакИспользованияВидаДокумента();

		ОбновитьТекстЗапроса();

		СохранитьНастройки();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументов()

	Результат = Неопределено;


	ОткрытьФорму(ИмяФормыНастройкаСоставаВидовДокументов,
			Новый Структура("СписокВидовДокументов", СписокВидовДокументов),,,,, Новый ОписаниеОповещения("РедактироватьСоставДокументовЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
        
        ПрименитьНастройкиКСпискуВидовДокументов(Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуДокументовНаСервере()

	Если ПустаяСтрока(ТекстЗапросаПоДокументам) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо настроить состав документов';uk='Необхідно настроїти склад документів'"),,"ЭтаФорма");
		Возврат;

	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапросаФильтр);
	Запрос.УстановитьПараметр("Параметр",         Параметр);
	Запрос.УстановитьПараметр("НачалоПериода",    ПериодВыборкиДокументов.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПериодВыборкиДокументов.ДатаОкончания);
	Запрос.МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;

	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	Запрос.Текст = ТекстЗапросаПоДокументам;

	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ТаблицаДокументов");

КонецПроцедуры

#КонецОбласти

#КонецОбласти
