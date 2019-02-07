﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.УстановкаКвотАссортимента) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.УстановкаКвотАссортимента.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.УстановкаКвотАссортимента);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьТоварныеКатегории";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Загрузка из файла.

// Устанавливает параметры загрузки.
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   ПолноеИмяТабличнойЧасти   - Строка - полное имя табличной части, в которую загружаются данные.
//   АдресЗагружаемыхДанных    - Строка - адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - порядковый номер строки;
//     * остальные колонки сооответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - список неоднозначных значений, для которых в ИБ имеется несколько подходящих вариантов.
//     * Колонка       - Строка - имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - идентификатор строки, в которой была обнаружена неоднозначность.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	ТоварныеКатегории =  ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДляСопоставления.ТоварнаяКатегория,
	|	ДанныеДляСопоставления.Марка,
	|	ДанныеДляСопоставления.Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставления
	|ИЗ
	|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТоварныеКатегории.Ссылка) КАК ТоварнаяКатегорияСсылка,
	|	ДанныеДляСопоставления.Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|		ПО (ТоварныеКатегории.Наименование ПОДОБНО ДанныеДляСопоставления.ТоварнаяКатегория)
	|			И НЕ ТоварныеКатегории.ЭтоГруппа
	|ГДЕ
	|	НЕ ТоварныеКатегории.Ссылка ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Марки.Ссылка) КАК МаркаСсылка,
	|	ДанныеДляСопоставления.Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Марки КАК Марки
	|		ПО (Марки.Наименование ПОДОБНО ДанныеДляСопоставления.Марка)
	|			И НЕ Марки.ЭтоГруппа
	|ГДЕ
	|	НЕ Марки.Ссылка ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Идентификатор";
	
	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	ТаблицаТоварныеКатегории = РезультатыЗапросов[1].Выгрузить();
	ТаблицаМарки = РезультатыЗапросов[2].Выгрузить();
	
	Для каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл 
		
		НоваяСтрока = ТоварныеКатегории.Добавить();
		НоваяСтрока.Идентификатор = СтрокаТаблицы.Идентификатор;
		НоваяСтрока.Квота = СтрокаТаблицы.Квота;
		НоваяСтрока.ПроцентОтклонения = СтрокаТаблицы.ПроцентОтклонения;
		
		СтрокаТоварнаяКатегория = ТаблицаТоварныеКатегории.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаТоварнаяКатегория <> Неопределено Тогда 
			Если СтрокаТоварнаяКатегория.Количество = 1 Тогда 
				НоваяСтрока.ТоварнаяКатегория  = СтрокаТоварнаяКатегория.ТоварнаяКатегорияСсылка;
			ИначеЕсли СтрокаТоварнаяКатегория.Количество > 1 Тогда 
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "ТоварнаяКатегория";
			КонецЕсли;
		КонецЕсли;
		
		СтрокаМарка = ТаблицаМарки.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаМарка <> Неопределено Тогда 
			Если СтрокаМарка.Количество = 1 Тогда 
				НоваяСтрока.Марка  = СтрокаМарка.МаркаСсылка;
			ИначеЕсли СтрокаМарка.Количество > 1 Тогда 
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "Марка";
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТоварныеКатегории, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Возврашает список подходящих объектов ИБ для неоднозначного значения ячейки.
// 
// Параметры:
//   ПолноеИмяТабличнойЧасти  - Строка - полное имя табличной части, в которую загружаются данные.
//  ИмяКолонки                - Строка - имя колонки, в который возника неоднозначность 
//  СписокНеоднозначностей    - ТаблицаЗначений - Список для заполения с неоднозначными данными
//     * Идентификатор        - Число  - Уникальный идентификатор строки
//     * Колонка              - Строка -  Имя колонки с возникшей неоднозначностью 
//  ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт 
	
	Если ИмяКолонки = "ТоварнаяКатегория" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварныеКатегории.Ссылка
		|ИЗ
		|	Справочник.ТоварныеКатегории КАК ТоварныеКатегории
		|ГДЕ
		|	ТоварныеКатегории.Наименование = &Наименование
		|	И НЕ ТоварныеКатегории.ЭтоГруппа";
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.ТоварнаяКатегория);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);  
		КонецЦикла;
	КонецЕсли;
	
	Если ИмяКолонки = "Марка" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Марки.Ссылка
		|ИЗ
		|	Справочник.Марки КАК Марки
		|ГДЕ
		|	Марки.Наименование = &Наименование
		|	И НЕ Марки.ЭтоГруппа";
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.Марка);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);  
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаКвотыАссортимента(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаКвотыАссортимента(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "КвотыАссортимента";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТоварныеКатегории.НомерСтроки КАК НСтр,
	|	ТоварныеКатегории.Ссылка.ДатаНачалаДействия КАК Период,
	|	ТоварныеКатегории.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ТоварныеКатегории.Ссылка.ОбъектПланирования КАК ОбъектПланирования,
	|	ТоварныеКатегории.Марка КАК Марка,
	|	ТоварныеКатегории.Ссылка.КоллекцияНоменклатуры КАК КоллекцияНоменклатуры,
	|	ТоварныеКатегории.Квота КАК Квота,
	|	ТоварныеКатегории.ПроцентОтклонения КАК ПроцентОтклонения
	|ИЗ
	|	Документ.УстановкаКвотАссортимента.ТоварныеКатегории КАК ТоварныеКатегории
	|ГДЕ
	|	ТоварныеКатегории.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НСтр";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

// 
Функция СуществуетПлан(ПроверяемыйОбъектПланирования, НаДату, ВызывающийДокумент) Экспорт
	ЕстьПлан = Ложь;
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.КвотыАссортимента КАК КвотыАссортимента
	|ГДЕ
	|	КвотыАссортимента.Период = &Период
	|	И КвотыАссортимента.ОбъектПланирования = &ОбъектПланирования");
	Запрос.УстановитьПараметр("Период", НачалоМесяца(НаДату));
	Запрос.УстановитьПараметр("ОбъектПланирования", ПроверяемыйОбъектПланирования);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Регистратор <> ВызывающийДокумент Тогда
			ЕстьПлан = Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат ЕстьПлан;
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли