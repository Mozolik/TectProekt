﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу используемых аналитик
//  
// Возвращаемое значение
//  ИспользуемыеАналитики - ТаблицаЗначений - таблица с колонками Ссылка, Представление, УчитыватьПоКоличеству
//
Функция ВидыАналитики()Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналитикиСтатейБюджетов.Ссылка                КАК Ссылка,
	|	АналитикиСтатейБюджетов.Представление         КАК Представление,
	|	АналитикиСтатейБюджетов.УчитыватьПоКоличеству КАК УчитыватьПоКоличеству
	|ИЗ
	|	ПланВидовХарактеристик.АналитикиСтатейБюджетов КАК АналитикиСтатейБюджетов";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает признак использования аналитики в статьях бюджетов
//
// Параметры
//  АналитикаСтатейБюджетов - ПланВидовХарактеристикСсылка.АналитикиСтатейБюджетов - аналитика для проверки
//  
// Возвращаемое значение
//  Булево - признак использования
//
Функция ИспользуетсяВСтатьяхБюджетов(АналитикаСтатейБюджетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтатьиБюджетов.Ссылка
	|ИЗ
	|	Справочник.СтатьиБюджетов КАК СтатьиБюджетов
	|ГДЕ
	|	СтатьиБюджетов.ВидАналитики1 = &АналитикаСтатейБюджетов
	|	ИЛИ СтатьиБюджетов.ВидАналитики2 = &АналитикаСтатейБюджетов
	|	ИЛИ СтатьиБюджетов.ВидАналитики3 = &АналитикаСтатейБюджетов
	|	ИЛИ СтатьиБюджетов.ВидАналитики4 = &АналитикаСтатейБюджетов
	|	ИЛИ СтатьиБюджетов.ВидАналитики5 = &АналитикаСтатейБюджетов
	|	ИЛИ СтатьиБюджетов.ВидАналитики6 = &АналитикаСтатейБюджетов";
	Запрос.УстановитьПараметр("АналитикаСтатейБюджетов", АналитикаСтатейБюджетов);
	
	Результат = НЕ Запрос.Выполнить().Пустой();
	
	Возврат Результат;
	
КонецФункции

// Возвращает типы значений аналитики
//
// Параметры
//  АналитикаСтатейБюджетов - ПланВидовХарактеристикСсылка.АналитикиСтатейБюджетов 
//  
// Возвращаемое значение
//  ДоступныеТипы - Соответствие
//         Ключ - Тип -  Тип значения аналитики
//         Значение - Полное имя объекта метаданных
//        
Функция ДоступныеТипыАналитикиСтатейБюджетов(АналитикаСтатейБюджетов) Экспорт
	
	ДоступныеТипы = Новый Соответствие;
	
	Для каждого Тип Из АналитикаСтатейБюджетов.ТипЗначения.Типы() Цикл
		ДоступныеТипы.Вставить(Тип, Метаданные.НайтиПоТипу(Тип).ПолноеИмя());
	КонецЦикла;
	
	Возврат ДоступныеТипы;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
// 
// Возвращаемое значание:
// 	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ТипЗначения");
	Результат.Добавить("ПредставлениеВалюты");
	Результат.Добавить("ПредставлениеЕдиницыИзмерения");
	Результат.Добавить("УчитыватьПоВалюте");
	Результат.Добавить("УчитыватьПоКоличеству");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет предопределенные элементы
//
Процедура ЗаполнитьПредопределенныеАналитикиСтатейБюджетов() Экспорт
	
	ПВХОбъект = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.Номенклатура.ПолучитьОбъект();
	ПВХОбъект.УчитыватьПоКоличеству = Истина;
	ПВХОбъект.ЗаполнениеЕдиницыИзмерения = "ЕдиницаИзмерения";
	ПВХОбъект.ПредставлениеЕдиницыИзмерения = НСтр("ru='[Единица хранения]';uk='[Одиниця зберігання]'");
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	
	ПВХОбъект = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ВидыНоменклатуры.ПолучитьОбъект();
	ПВХОбъект.УчитыватьПоКоличеству = Истина;
	ПВХОбъект.ЗаполнениеЕдиницыИзмерения = "ЕдиницаИзмерения";
	ПВХОбъект.ПредставлениеЕдиницыИзмерения = НСтр("ru='[Единица хранения]';uk='[Одиниця зберігання]'");
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	
	ПВХОбъект = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ДенежныеСредства.ПолучитьОбъект();
	ПВХОбъект.УчитыватьПоВалюте = Истина;
	ПВХОбъект.ЗаполнениеВалюты = "ВалютаДенежныхСредств";
	ПВХОбъект.ПредставлениеВалюты = НСтр("ru='[Валюта денежных средств]';uk='[Валюта грошових коштів]'");
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	
	ПВХОбъект = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.Договоры.ПолучитьОбъект();
	ПВХОбъект.УчитыватьПоВалюте = Истина;
	ПВХОбъект.ЗаполнениеВалюты = "ВалютаВзаиморасчетов";
	ПВХОбъект.ПредставлениеВалюты = НСтр("ru='[Валюта взаиморасчетов]';uk='[Валюта взаєморозрахунків]'");
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	
	Выборка = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.Выбрать();
	Пока Выборка.Следующий() Цикл
		ПВХОбъект = Выборка.ПолучитьОбъект();
		ПВХОбъект.ПредставлениеТипаЗначения = Строка(ПВХОбъект.ТипЗначения);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли