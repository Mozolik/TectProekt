﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
		РежимВыбораИнформацииОВидеВремени = Параметры.РежимВыбораИнформацииОВидеВремени;
		Если РежимВыбораИнформацииОВидеВремени Тогда
			РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		КонецЕсли;
	КонецЕсли;
	
	ВидВремениРабочееВремя = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.РабочееВремя");
	
	Если ВидВремениРабочееВремя <> Неопределено Тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ЭлементОтбора.ПравоеЗначение = ВидВремениРабочееВремя;
	КонецЕсли;
	
	// Исключение регистрируемых отдельными документами.
	Если Параметры.Свойство("ИсключатьРегистриуемыеОтдельнымиДокументами")
		И Параметры.ИсключатьРегистриуемыеОтдельнымиДокументами = Истина Тогда
		ВидыДокументов = Справочники.ВидыИспользованияРабочегоВремени.ВидыВремениРегистрируемыеОтдельнымиДокументами();
		ВидыВремени = Новый Массив;
		Для Каждого СтрокаТаблицы Из ВидыДокументов Цикл
			Если СтрокаТаблицы.ВидДокумента = Перечисления.ВидыДокументовНачисления.ОплатаПоСреднемуЗаработку Тогда
				Продолжить;
			КонецЕсли;
			ВидыВремени.Добавить(СтрокаТаблицы.ВидВремени);
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.Отбор, "Ссылка", ВидСравненияКомпоновкиДанных.НеВСписке, ВидыВремени, , Истина);
	КонецЕсли;
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "Ссылка, Предопределенный");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не РежимВыбораИнформацииОВидеВремени Тогда
		Возврат;
	КонецЕсли;

	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	
	ДанныеВыбора = Новый Структура("ВидВремени, БуквенноеОбозначение, Наименование, Целосменное"); 
	ДанныеВыбора.ВидВремени = ВыбраннаяСтрока;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		ДанныеВыбора.БуквенноеОбозначение = ДанныеТекущейСтроки.БуквенныйКод;
		ДанныеВыбора.Наименование = ДанныеТекущейСтроки.Наименование;
		ДанныеВыбора.Целосменное = ДанныеТекущейСтроки.Целосменное;
	КонецЕсли;
	
 	ОповеститьОВыборе(ДанныеВыбора);	
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
