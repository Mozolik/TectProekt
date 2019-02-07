﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует дерево отклонений для формирования отчета
//
// Возвращаемое значение:
// 		ДеревоОтклонений - ДеревоЗначений - Инициализированное дерево значений
//
Функция ИнициализироватьДеревоОтклонений() Экспорт
	
	ДеревоОтклонений = Новый ДеревоЗначений();
	ДеревоОтклонений.Колонки.Добавить("НомерСтроки");
	ДеревоОтклонений.Колонки.Добавить("ЭтоНабор");
	ДеревоОтклонений.Колонки.Добавить("ЦенаНабора");
	ДеревоОтклонений.Колонки.Добавить("Параметр");
	ДеревоОтклонений.Колонки.Добавить("ОтклонениеПараметра");
	
	Возврат ДеревоОтклонений
	
КонецФункции

// Добавляет отклонения по шапке документа в массив отклонений от условий продаж
//
// Параметры:
// 		ИмяПараметраШапки   - Строка - Имя отклоняемого параметра
// 		ОтклонениеПараметраШапки - Строка - Текст с ошибкой
// 		МассивОтклонений     -Массив - Массив с отклонениями
//
Процедура ДобавитьОтклонениеШапкиВМассивОтклонений(ИмяПараметраШапки, ОтклонениеПараметраШапки, МассивОтклонений) Экспорт
	
	СтруктураОтклонений = Новый Структура();
	СтруктураОтклонений.Вставить("ИмяПараметраШапки", ИмяПараметраШапки);
	СтруктураОтклонений.Вставить("ОтклонениеПараметраШапки", ОтклонениеПараметраШапки);
	
	МассивОтклонений.Добавить(СтруктураОтклонений);
КонецПроцедуры

// Добавляет отклонения по скидкам/наценкам документа в массив отклонений от условий продаж
//
// Параметры:
// 		НомерСтроки   - Число - Номер строки с ошибкой
// 		СкидкаНаценка   - Строка - Скидка с отклонением
// 		ОтклонениеПараметра - Строка - Текст с ошибкой
// 		МассивОтклонений     -Массив - Массив с отклонениями
//
Процедура ДобавитьОтклонениеСкидкиНаценкиВМассивОтклонений(НомерСтроки, СкидкаНаценка, ОтклонениеПараметра, МассивОтклонений) Экспорт
	
	СтруктураОтклонений = Новый Структура();
	СтруктураОтклонений.Вставить("НомерСтроки",   НомерСтроки);
	СтруктураОтклонений.Вставить("СкидкаНаценка", СкидкаНаценка);
	СтруктураОтклонений.Вставить("ОтклонениеПараметра", ОтклонениеПараметра);
	
	МассивОтклонений.Добавить(СтруктураОтклонений);
	
КонецПроцедуры

// Добавляет отклонения по табличной части документа в дерево отклонений от условий продаж
//
// Параметры:
// 		НомерСтроки   - Число - Номер строки с ошибкой
// 		Параметр   - Строка - Имя отклоняемого параметра
// 		ОтклонениеПараметра - Строка - Текст с ошибкой
// 		ДеревоОтклонений     -ДеревоЗначений - Дерево с отклонениями
//
Процедура ДобавитьОтклонениеСтрокиВДеревоОтклонений(НомерСтроки, Параметр, ОтклонениеПараметра, ДеревоОтклонений, ЭтоНабор = Ложь, ЦенаНабора = 0) Экспорт
	НайденнаяСтрока  = ДеревоОтклонений.Строки.Найти(НомерСтроки,"НомерСтроки");
	Если НайденнаяСтрока = Неопределено Тогда
		СтрокаОтклонений             = ДеревоОтклонений.Строки.Добавить();
		СтрокаОтклонений.НомерСтроки = НомерСтроки;
		СтрокаОтклонений.ЭтоНабор    = ЭтоНабор;
		СтрокаОтклонений.ЦенаНабора  = ЦенаНабора;
		ВложеннаяСтрокаОтклонений    = СтрокаОтклонений.Строки.Добавить();
	Иначе
		ВложеннаяСтрокаОтклонений = НайденнаяСтрока.Строки.Добавить();
	КонецЕсли;
	ВложеннаяСтрокаОтклонений.НомерСтроки         = НомерСтроки;
	ВложеннаяСтрокаОтклонений.ЭтоНабор            = ЭтоНабор;
	ВложеннаяСтрокаОтклонений.ЦенаНабора          = ЦенаНабора;
	ВложеннаяСтрокаОтклонений.Параметр            = Параметр;
	ВложеннаяСтрокаОтклонений.ОтклонениеПараметра = ОтклонениеПараметра;
КонецПроцедуры

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Отключение контекстных вариантов
	ВариантыОтчетовУТПереопределяемый.ОтключитьОтчет(ОписаниеОтчета);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#Область ВыводДанных

Процедура ВывестиЗаголовокОтчета(ТаблицаОтчета, ЕстьОтклонения) Экспорт
	
	Макет = ПолучитьМакет("Макет");
	Если ЕстьОтклонения Тогда
		Область = Макет.ПолучитьОбласть("Заголовок");
	Иначе
		Область = Макет.ПолучитьОбласть("ЗаголовокБезОтклонений");
	КонецЕсли;
	ТаблицаОтчета.Вывести(Область);
	
КонецПроцедуры

Процедура ВывестиОтклоненияВОбластьШапки(МассивОтклонений, ТаблицаОтчета) Экспорт
	Макет = ПолучитьМакет("Макет");
	Область = Макет.ПолучитьОбласть("ЗаголовокОтклонений");
	Область.Параметры.Заголовок = НСтр("ru='Соответствие условиям продаж';uk='Відповідність умовам продажів'");
	ТаблицаОтчета.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ОтклонениеШапки");
	ТаблицаОтчета.НачатьГруппуСтрок();
	Для каждого Отклонение Из МассивОтклонений Цикл
		Область.Параметры.Заполнить(Отклонение);
		ТаблицаОтчета.Вывести(Область);
	КонецЦикла; 
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
КонецПроцедуры

Процедура ВывестиОтклоненияТоварыДокументаПродажи(Знач ДокументПродажи, ДеревоОтклоненийТовары, ТаблицаОтчета) Экспорт
	
	ИспользоватьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ЭтоСоглашение = ТипЗнч(ДокументПродажи) = Тип("СправочникСсылка.СоглашенияСКлиентами");
	
	ИмяТаблицы        = ОбщегоНазначения.ИмяТаблицыПоСсылке(ДокументПродажи.Ссылка);
	ИмяТЧ             = ПродажиСервер.ПолучитьИмяТабличнойЧасти(ИмяТаблицы);
	
	Макет = ПолучитьМакет("Макет");
	Область = Макет.ПолучитьОбласть("ЗаголовокОтклонений");
	Область.Параметры.Заголовок = НСтр("ru='Соответствие товаров условиям продаж';uk='Відповідність товарів умовам продажів'");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.НачатьГруппуСтрок();
	
	Если НЕ ЭтоСоглашение Тогда 
		Если ИспользоватьРучныеСкидки Тогда
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТаблицыСоСкидкой");
			ОбластьИмя = "СтрокаТаблицыСоСкидкой";
			ОбластьСтрокиИмя = "ТаблицаСтрокаСоСкидкой";
		Иначе
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТаблицыБезСкидки");
			ОбластьИмя = "СтрокаТаблицыБезСкидки";
			ОбластьСтрокиИмя = "ТаблицаСтрокаБезСкидки";
		КонецЕсли;
	Иначе 
		ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТоварыСоглашение");
		ОбластьИмя = "СтрокаТоварыСоглашение";
		ОбластьСтрокиИмя = "ТоварыСтрокаСоглашение";
	КонецЕсли;
	ОбластьШапки.Параметры.Валюта = ДокументПродажи.Валюта;
	ТаблицаОтчета.Вывести(ОбластьШапки);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&МассивНоменклатуры)
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.Ссылка,
	|	Номенклатура.ЕдиницаИзмерения";
	Запрос.УстановитьПараметр("МассивНоменклатуры", ДокументПродажи[ИмяТЧ].ВыгрузитьКолонку("Номенклатура"));
	ТаблицаЕдиницИзмерений = Запрос.Выполнить().Выгрузить();
	
	ОбластьОтклонение       = Макет.ПолучитьОбласть("СтрокаТаблицыОтклонение");
	ОбластьСтрокиОтклонение = ОбластьОтклонение.Области.ТаблицаСтрокаОтклонение;
	
	ЧетнаяСтрока = Ложь;
	
	Для каждого Отклонение Из ДеревоОтклоненийТовары.Строки Цикл
		Область = Макет.ПолучитьОбласть(ОбластьИмя);
		ОбластьСтроки = Область.Области[ОбластьСтрокиИмя];
		
		Если ЧетнаяСтрока Тогда
			ЦветФона = ЦветаСтиля.АльтернативныйЦветФонаПоля;
		Иначе
			ЦветФона = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
		
		СтрокаТовары = ДокументПродажи[ИмяТЧ].Получить(Отклонение.НомерСтроки-1);
		Область.Параметры.Заполнить(СтрокаТовары);
		
		Если Отклонение.ЭтоНабор Тогда
			Область.Параметры.Заполнить(Новый Структура("Цена", Отклонение.ЦенаНабора));
		КонецЕсли;
		
		Если Отклонение.ЭтоНабор Тогда
			ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТовары.НоменклатураНабора,
				СтрокаТовары.ХарактеристикаНабора);
		Иначе
			ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТовары.Номенклатура,
				СтрокаТовары.Характеристика);
		КонецЕсли;
		Область.Параметры.Товар = ПредставлениеНоменклатуры;
		
		Если ИмяТЧ = "Услуги" ИЛИ НЕ ЗначениеЗаполнено(СтрокаТовары.Упаковка) Тогда 
			НайденныеСтроки = ТаблицаЕдиницИзмерений.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовары.Номенклатура));
			Если НайденныеСтроки <> Неопределено Тогда
				Область.Параметры.Упаковка = НайденныеСтроки.Получить(0).ЕдиницаИзмерения;
			КонецЕсли;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТовары.ВидЦены) Тогда 
			Область.Параметры.ВидЦены = НСтр("ru='произвольный';uk='довільний'");
		КонецЕсли;
		
		ОбластьСтроки.ЦветФона = ЦветФона;
		
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			Попытка
				ИмяПараметра = ОбластьСтрокиИмя + СтрокаСОтклонением.Параметр;
				Область.Области[ИмяПараметра].ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
			Исключение
			КонецПопытки;
		КонецЦикла;
		ТаблицаОтчета.Вывести(Область);
		
		ТаблицаОтчета.НачатьГруппуСтрок();
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			ОбластьСтрокиОтклонение.ЦветФона = ЦветФона;
			ОбластьОтклонение.Параметры.Заполнить(СтрокаСОтклонением);
			ТаблицаОтчета.Вывести(ОбластьОтклонение);
		КонецЦикла;
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		
		ЧетнаяСтрока = НЕ ЧетнаяСтрока;
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("СтрокаТаблицыПоследняя");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
КонецПроцедуры

Процедура ВывестиОтклоненияСкидкиНаценки(МассивОтклонений, ТаблицаОтчета) Экспорт
	
	Макет = ПолучитьМакет("Макет");
	Область = Макет.ПолучитьОбласть("ЗаголовокОтклонений");
	Область.Параметры.Заголовок = НСтр("ru='Соответствие скидок/наценок условиям продаж';uk='Відповідність знижок/надбавок умовами продажу'");
	ТаблицаОтчета.Вывести(Область);
	ТаблицаОтчета.НачатьГруппуСтрок();

	Область = Макет.ПолучитьОбласть("ШапкаСоглашенияСкидки");
	ТаблицаОтчета.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("СтрокаСоглашенияСкидки");
	ОбластьОтклонение = Макет.ПолучитьОбласть("СтрокаТаблицыОтклонение");
	
	ЧетнаяСтрока = Ложь;
	
	Для каждого Отклонение Из МассивОтклонений Цикл
		Если ЧетнаяСтрока Тогда
			ЦветФона = ЦветаСтиля.АльтернативныйЦветФонаПоля;
		Иначе
			ЦветФона = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
		ОбластьОтклонение.Области.ТаблицаСтрокаОтклонение.ЦветФона = ЦветФона;
		Область.Области.СоглашенияСкидкиСтрока.ЦветФона = ЦветФона;
		
		Если Отклонение.НомерСтроки > 0 Тогда
			Область.Параметры.Заполнить(Отклонение);
			ТаблицаОтчета.Вывести(Область);
		КонецЕсли;
		ОбластьОтклонение.Параметры.Заполнить(Отклонение);
		ТаблицаОтчета.Вывести(ОбластьОтклонение);
		ЧетнаяСтрока = НЕ ЧетнаяСтрока;
	КонецЦикла; 
	
	Область = Макет.ПолучитьОбласть("СтрокаТаблицыПоследняя");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
КонецПроцедуры

Процедура ВывестиОтклоненияСоответствиеГруппЦенНоменклатурыУсловиямПродаж(Знач ДокументПродажи, ДеревоОтклонений, ТаблицаОтчета) Экспорт
	
	Макет = ПолучитьМакет("Макет");
	
	ИспользоватьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоСоглашениям");
	Если ИспользоватьРучныеСкидки Тогда
		ОбластьШапки = Макет.ПолучитьОбласть("ШапкаЦеновыеГруппы");
		ОбластьИмя = "СтрокаЦеновыеГруппы";
		ОбластьСтрокиИмя = "ЦеновыеГруппыСтрока";
	Иначе
		ОбластьШапки = Макет.ПолучитьОбласть("ШапкаЦеновыеГруппыБезСкидки");
		ОбластьИмя = "СтрокаЦеновыеГруппыБезСкидки";
		ОбластьСтрокиИмя = "ЦеновыеГруппыСтрокаБезСкидки";
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("ЗаголовокОтклонений");
	Область.Параметры.Заголовок = НСтр("ru='Соответствие ценовых групп условиям продаж';uk='Відповідність цінових груп умовами продажів'");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.НачатьГруппуСтрок();
	ТаблицаОтчета.Вывести(ОбластьШапки);
	
	ОбластьОтклонение       = Макет.ПолучитьОбласть("СтрокаТаблицыОтклонение");
	ОбластьСтрокиОтклонение = ОбластьОтклонение.Области.ТаблицаСтрокаОтклонение;
	
	ЧетнаяСтрока = Ложь;
	
	Для каждого Отклонение Из ДеревоОтклонений.Строки Цикл
		Область = Макет.ПолучитьОбласть(ОбластьИмя);
		ОбластьСтроки = Область.Области[ОбластьСтрокиИмя];
		
		Если ЧетнаяСтрока Тогда
			ЦветФона = ЦветаСтиля.АльтернативныйЦветФонаПоля;
		Иначе
			ЦветФона = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
		
		СтрокаТовары = ДокументПродажи.ЦеновыеГруппы.Получить(Отклонение.НомерСтроки-1);
		Область.Параметры.Заполнить(СтрокаТовары);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТовары.ВидЦен) Тогда 
			Область.Параметры.ВидЦен = НСтр("ru='произвольный';uk='довільний'");
		КонецЕсли;
		
		ОбластьСтроки.ЦветФона = ЦветФона;
		
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			Попытка
				ИмяПараметра = ОбластьСтрокиИмя + СтрокаСОтклонением.Параметр;
				Область.Области[ИмяПараметра].ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
			Исключение
			КонецПопытки;
		КонецЦикла;
		ТаблицаОтчета.Вывести(Область);
		
		ТаблицаОтчета.НачатьГруппуСтрок();
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			ОбластьСтрокиОтклонение.ЦветФона = ЦветФона;
			ОбластьОтклонение.Параметры.Заполнить(СтрокаСОтклонением);
			ТаблицаОтчета.Вывести(ОбластьОтклонение);
		КонецЦикла;
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		
		ЧетнаяСтрока = НЕ ЧетнаяСтрока;
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("СтрокаТаблицыПоследняя");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
КонецПроцедуры

Процедура ВывестиОтклоненияЭтапыОплатыДокументаПродажи(Знач ДокументПродажи, ДеревоОтклонений, ТаблицаОтчета) Экспорт
	
	Макет = ПолучитьМакет("Макет");
	
	ТребуетсяЗалогЗаТару = ДокументПродажи.ТребуетсяЗалогЗаТару;
	ЭтоСоглашение    = ТипЗнч(ДокументПродажи) = Тип("СправочникСсылка.СоглашенияСКлиентами");
	
	Если ЭтоСоглашение Тогда
		Если ТребуетсяЗалогЗаТару Тогда
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаГрафикСТарой");
			ОбластьИмя = "СтрокаГрафикСТарой";
			ОбластьСтрокиИмя = "ГрафикСтрокаСТарой";
		Иначе
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаГрафик");
			ОбластьИмя = "СтрокаГрафик";
			ОбластьСтрокиИмя = "ГрафикСтрока";
		КонецЕсли;
	Иначе
		Если ТребуетсяЗалогЗаТару Тогда
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаЭтаповОплатыСТарой");
			ОбластьИмя = "СтрокаЭтаповОплатыСТарой";
			ОбластьСтрокиИмя = "ЭтапыОплатыСтрокаСТарой";
		Иначе
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаЭтаповОплаты");
			ОбластьИмя = "СтрокаЭтаповОплаты";
			ОбластьСтрокиИмя = "ЭтапыОплатыСтрока";
		КонецЕсли;
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("ЗаголовокОтклонений");
	Область.Параметры.Заголовок = НСтр("ru='Соответствие этапов оплаты условиям продаж';uk='Відповідність етапів оплати умовами продажів'");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.НачатьГруппуСтрок();
	ТаблицаОтчета.Вывести(ОбластьШапки);
	
	ОбластьОтклонение       = Макет.ПолучитьОбласть("СтрокаТаблицыОтклонение");
	ОбластьСтрокиОтклонение = ОбластьОтклонение.Области.ТаблицаСтрокаОтклонение;
	
	ЧетнаяСтрока = Ложь;
	
	Для каждого Отклонение Из ДеревоОтклонений.Строки Цикл
		Область = Макет.ПолучитьОбласть(ОбластьИмя);
		ОбластьСтроки = Область.Области[ОбластьСтрокиИмя];
		
		Если ЧетнаяСтрока Тогда
			ЦветФона = ЦветаСтиля.АльтернативныйЦветФонаПоля;
		Иначе
			ЦветФона = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
		
		СтрокаТовары = ДокументПродажи.ЭтапыГрафикаОплаты.Получить(Отклонение.НомерСтроки-1);
		Область.Параметры.Заполнить(СтрокаТовары);
		
		ОбластьСтроки.ЦветФона = ЦветФона;
		
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			Попытка
				ИмяПараметра = ОбластьСтрокиИмя + СтрокаСОтклонением.Параметр;
				Область.Области[ИмяПараметра].ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
			Исключение
			КонецПопытки;
		КонецЦикла;
		ТаблицаОтчета.Вывести(Область);
		
		ТаблицаОтчета.НачатьГруппуСтрок();
		Для каждого СтрокаСОтклонением Из Отклонение.Строки Цикл
			ОбластьСтрокиОтклонение.ЦветФона = ЦветФона;
			ОбластьОтклонение.Параметры.Заполнить(СтрокаСОтклонением);
			ТаблицаОтчета.Вывести(ОбластьОтклонение);
		КонецЦикла;
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		
		ЧетнаяСтрока = НЕ ЧетнаяСтрока;
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("СтрокаТаблицыПоследняя");
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли