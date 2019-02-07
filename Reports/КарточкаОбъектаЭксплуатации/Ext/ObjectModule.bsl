﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует отчет в табличном документе по указанному объекту ремонта
//
// Параметры:
// 		ТаблицаОтчета - ТабличныйДокумент - Табличный документ, в котором необходимо сформировать отчет
// 		ОбъектЭксплуатации - СправочникСсылка.ОбъектыЭксплуатации - Объект эксплуатации, по которому необходимо сформировать отчет
//
Процедура СформироватьОтчет(ТаблицаОтчета, ОбъектЭксплуатации) Экспорт
	
	ОтчетПоУзлам = (Тип("СправочникСсылка.УзлыОбъектовЭксплуатации") = ТипЗнч(ОбъектЭксплуатации));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектЭксплуатации", ОбъектЭксплуатации);
	Запрос.УстановитьПараметр("Класс", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектЭксплуатации, "Класс"));
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	
	СтруктураЗапроса = Новый Структура;
	СтруктураЗапроса.Вставить("СчетЗапросов", 0);
	СтруктураЗапроса.Вставить("ПараметрыЗапроса", Новый Структура);
	СформироватьТекстЗапроса(Запрос.Текст, СтруктураЗапроса);
	
	Если СтруктураЗапроса.ПараметрыЗапроса.Количество() <> 0 Тогда
		Для Каждого Параметр Из СтруктураЗапроса.ПараметрыЗапроса Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ВывестиВТабличныйДокумент(Пакет, СтруктураЗапроса, ТаблицаОтчета);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапроса(ТекстЗапроса, СтруктураЗапроса)
	
	СформироватьТекстЗапросаПоОбъектуЭксплуатации(ТекстЗапроса, СтруктураЗапроса);
	СформироватьТекстЗапросаПоПаспортнымХарактеристикам(ТекстЗапроса, СтруктураЗапроса);
	СформироватьТекстЗапросаПоПодчиненнымУзлам(ТекстЗапроса, СтруктураЗапроса);
	СформироватьТекстЗапросаПоНаработкам(ТекстЗапроса, СтруктураЗапроса);
	СформироватьТекстЗапросаПоРемонтам(ТекстЗапроса, СтруктураЗапроса);
	СформироватьТекстЗапросаПоДефектам(ТекстЗапроса, СтруктураЗапроса);
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоОбъектуЭксплуатации(ТекстЗапроса, СтруктураЗапроса)
	
	СтруктураЗапроса.Вставить("ОбъектЭксплуатации", СтруктураЗапроса.СчетЗапросов);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 1;
	
	ТекстЗапроса = ТекстЗапроса + "
	|////////////////////////////////////////////////////////////////////////////////
	|// ДАННЫЕ ОБЪЕКТА РЕМОНТА
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ОбъектыЭксплуатации.Ссылка КАК Ссылка,
	|	ОбъектыЭксплуатации.Наименование КАК Наименование,
	|	ОбъектыЭксплуатации.НаименованиеПолное КАК НаименованиеПолное,
	|	НЕОПРЕДЕЛЕНО КАК Принадлежность,
	|	ОбъектыЭксплуатации.Класс КАК Класс,
	|	ОбъектыЭксплуатации.Подкласс КАК Подкласс,
	|	ОбъектыЭксплуатации.Статус КАК Статус,
	|	ОбъектыЭксплуатации.ЭксплуатирующееПодразделение КАК ЭксплуатирующееПодразделение,
	|	ОбъектыЭксплуатации.РемонтирующееПодразделение КАК РемонтирующееПодразделение,
	|	ОбъектыЭксплуатации.Расположение КАК Расположение,
	|	ОбъектыЭксплуатации.Модель КАК Модель,
	|	ОбъектыЭксплуатации.СерийныйНомер КАК СерийныйНомер
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка = &ОбъектЭксплуатации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УзлыОбъектовЭксплуатации.Ссылка,
	|	УзлыОбъектовЭксплуатации.Наименование,
	|	УзлыОбъектовЭксплуатации.НаименованиеПолное,
	|	НЕОПРЕДЕЛЕНО,
	|	УзлыОбъектовЭксплуатации.Класс,
	|	УзлыОбъектовЭксплуатации.Подкласс,
	|	УзлыОбъектовЭксплуатации.Статус,
	|	НЕОПРЕДЕЛЕНО,
	|	УзлыОбъектовЭксплуатации.РемонтирующееПодразделение,
	|	УзлыОбъектовЭксплуатации.Расположение,
	|	УзлыОбъектовЭксплуатации.Модель,
	|	УзлыОбъектовЭксплуатации.СерийныйНомер
	|ИЗ
	|	Справочник.УзлыОбъектовЭксплуатации КАК УзлыОбъектовЭксплуатации
	|ГДЕ
	|	УзлыОбъектовЭксплуатации.Ссылка = &ОбъектЭксплуатации";
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоПаспортнымХарактеристикам(ТекстЗапроса, СтруктураЗапроса)
	
	Если Не ЭтотОбъект.ПаспортныеХарактеристики Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗапроса.Вставить("ПаспортныеХарактеристики", СтруктураЗапроса.СчетЗапросов);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 1;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// ПАСПОРТНЫЕ ХАРАКТЕРИСТИКИ
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Свойство КАК Характеристика,
	|	ДополнительныеРеквизиты.Значение КАК Значение
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	ДополнительныеРеквизиты.Ссылка = &ОбъектЭксплуатации
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДополнительныеРеквизиты.НомерСтроки";
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоПодчиненнымУзлам(ТекстЗапроса, СтруктураЗапроса)
	
	Если Не ЭтотОбъект.ПодчиненныеУзлы Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗапроса.Вставить("ПодчиненныеУзлы", СтруктураЗапроса.СчетЗапросов);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 1;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// ПОДЧИНЕННЫЕ УЗЛЫ
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	Узлы.Ссылка КАК Узел,
	|	ВЫБОР
	|		КОГДА Узлы.Родитель = &ОбъектЭксплуатации
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.УзлыОбъектовЭксплуатации.ПустаяСсылка)
	|		ИНАЧЕ Узлы.Родитель
	|	КОНЕЦ КАК Родитель,
	|	Узлы.Наименование КАК Наименование,
	|	НЕОПРЕДЕЛЕНО КАК ДатаВводаВЭксплуатацию,
	|	НЕОПРЕДЕЛЕНО КАК ЭксплуатирующееПодразделение,
	|	Узлы.РемонтирующееПодразделение КАК РемонтирующееПодразделение
	|ИЗ
	|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|ГДЕ
	|	(Узлы.Владелец В (&ОбъектЭксплуатации)
	|			ИЛИ Узлы.Ссылка В ИЕРАРХИИ (&ОбъектЭксплуатации)
	|				И Узлы.Ссылка <> &ОбъектЭксплуатации)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Узлы.НаименованиеПолное";
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоНаработкам(ТекстЗапроса, СтруктураЗапроса)
	
	Если Не ЭтотОбъект.Наработки Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗапроса.Вставить("Наработки", СтруктураЗапроса.СчетЗапросов+2);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 3;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// НАРАБОТКИ
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ПоказателиНаработки.ПоказательНаработки,
	|	ПоказателиНаработки.РасчитыватьОстаточныйРесурс
	|ПОМЕСТИТЬ втНастройкиКласса
	|ИЗ
	|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработки
	|ГДЕ
	|	ПоказателиНаработки.Ссылка = &Класс
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНастройкиКласса.ПоказательНаработки КАК ПоказательНаработки,
	|	втНастройкиКласса.РасчитыватьОстаточныйРесурс КАК РасчитыватьОстаточныйРесурс,
	|	ВЫБОР
	|		КОГДА втНастройкиКласса.РасчитыватьОстаточныйРесурс
	|			ТОГДА ЕСТЬNULL(НастройкиОбъекта.НазначенныйРесурс, ЕСТЬNULL(НастройкиУзла.НазначенныйРесурс, 0))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НазначенныйРесурс
	|ПОМЕСТИТЬ втПоказателиНаработок
	|ИЗ
	|	втНастройкиКласса КАК втНастройкиКласса
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации.ПараметрыУчетаНаработок КАК НастройкиОбъекта
	|		ПО втНастройкиКласса.ПоказательНаработки = НастройкиОбъекта.ПоказательНаработки
	|			И (НастройкиОбъекта.Ссылка = &ОбъектЭксплуатации)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации.ПараметрыУчетаНаработок КАК НастройкиУзла
	|		ПО втНастройкиКласса.ПоказательНаработки = НастройкиУзла.ПоказательНаработки
	|			И (НастройкиУзла.Ссылка = &ОбъектЭксплуатации)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втПоказателиНаработок.ПоказательНаработки,
	|	НаработкиСрезПоследних.Период КАК ДатаРегистрации,
	|	НаработкиСрезПоследних.Значение КАК ТекущееЗначение,
	|	НаработкиСрезПоследних.СреднесуточноеЗначение КАК СреднесуточноеЗначение,
	|	втПоказателиНаработок.НазначенныйРесурс КАК НазначенныйРесурс,
	|	ВЫБОР
	|		КОГДА втПоказателиНаработок.РасчитыватьОстаточныйРесурс
	|			ТОГДА втПоказателиНаработок.НазначенныйРесурс - НаработкиСрезПоследних.Значение
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ОстаточныйРесурс,
	|	ВЫБОР
	|		КОГДА НЕ втПоказателиНаработок.РасчитыватьОстаточныйРесурс
	|				ИЛИ НаработкиСрезПоследних.СреднесуточноеЗначение ЕСТЬ NULL 
	|				ИЛИ НаработкиСрезПоследних.СреднесуточноеЗначение = 0
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ЕСТЬNULL(НаработкиСрезПоследних.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)), ДЕНЬ, (втПоказателиНаработок.НазначенныйРесурс - ЕСТЬNULL(НаработкиСрезПоследних.Значение, 0)) / ЕСТЬNULL(НаработкиСрезПоследних.СреднесуточноеЗначение, 0))
	|	КОНЕЦ КАК ДатаВыработки,
	|	ВЫБОР
	|		КОГДА НЕ втПоказателиНаработок.РасчитыватьОстаточныйРесурс
	|				ИЛИ НаработкиСрезПоследних.СреднесуточноеЗначение ЕСТЬ NULL 
	|				ИЛИ НаработкиСрезПоследних.СреднесуточноеЗначение = 0
	|			ТОГДА 0
	|		ИНАЧЕ (втПоказателиНаработок.НазначенныйРесурс - ЕСТЬNULL(НаработкиСрезПоследних.Значение, 0)) / ЕСТЬNULL(НаработкиСрезПоследних.СреднесуточноеЗначение, 0)
	|	КОНЕЦ КАК ОстаточныйРесурсДней
	|ИЗ
	|	втПоказателиНаработок КАК втПоказателиНаработок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(
	|				,
	|				(ОбъектЭксплуатации, ПоказательНаработки) В
	|					(ВЫБРАТЬ
	|						&ОбъектЭксплуатации,
	|						втПоказателиНаработок.ПоказательНаработки КАК ПоказательНаработки
	|					ИЗ
	|						втПоказателиНаработок КАК втПоказателиНаработок)) КАК НаработкиСрезПоследних
	|		ПО втПоказателиНаработок.ПоказательНаработки = НаработкиСрезПоследних.ПоказательНаработки";
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоРемонтам(ТекстЗапроса, СтруктураЗапроса)
	
	МассивСтатусов = Новый Массив;
	
	Если ЭтотОбъект.ТекущиеРемонты Тогда
		МассивСтатусов.Добавить(Перечисления.СтатусыЗаказовНаРемонт.КВыполнению);
		МассивСтатусов.Добавить(Перечисления.СтатусыЗаказовНаРемонт.Выполняется);
	КонецЕсли;
	
	Если ЭтотОбъект.ЗакрытыеРемонты Тогда
		МассивСтатусов.Добавить(Перечисления.СтатусыЗаказовНаРемонт.Закрыт);
	КонецЕсли;
	
	Если МассивСтатусов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗапроса.Вставить("Ремонты", СтруктураЗапроса.СчетЗапросов);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 1;
	СтруктураЗапроса.ПараметрыЗапроса.Вставить("СтатусыЗаказов", МассивСтатусов);
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// РЕМОНТЫ
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ЗаказНаРемонт.Номер,
	|	ЗаказНаРемонт.Дата,
	|	ЗаказНаРемонт.ОбъектЭксплуатации,
	|	ЗаказНаРемонт.Статус,
	|	ЗаказНаРемонт.ДатаНачала,
	|	ЗаказНаРемонт.ДатаЗавершения,
	|	ЗаказНаРемонт.Подразделение,
	|	ЗаказНаРемонт.Ответственный,
	|	ЗаказНаРемонт.РемонтноеМероприятие,
	|	ЗаказНаРемонт.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказНаРемонт КАК ЗаказНаРемонт
	|ГДЕ
	|	(ЗаказНаРемонт.ОбъектЭксплуатации = &ОбъектЭксплуатации
	|			ИЛИ ЗаказНаРемонт.Ремонты.Узел = &ОбъектЭксплуатации)
	|	И ЗаказНаРемонт.Статус В(&СтатусыЗаказов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказНаРемонт.Статус.Порядок УБЫВ";
	
КонецПроцедуры

// Формирует текст пакета запросов и структуру выборок в пакете
//
// Параметры:
// 		ТекстЗапроса - Строка - Строка для формирования текста пакета зпросов
// 		СтруктураЗапроса - Структура - Структура с наименованиями выборок в ключах и индексами результатов запросов в значениях
//
Процедура СформироватьТекстЗапросаПоДефектам(ТекстЗапроса, СтруктураЗапроса)
	
	МассивСтатусов = Новый Массив;
	
	Если ЭтотОбъект.ТекущиеДефекты Тогда
		МассивСтатусов.Добавить(Перечисления.СтатусыДефектов.Зарегистрирован);
		МассивСтатусов.Добавить(Перечисления.СтатусыДефектов.ОтложеноУстранение);
		МассивСтатусов.Добавить(Перечисления.СтатусыДефектов.Признан);
	КонецЕсли;
	
	Если ЭтотОбъект.ЗакрытыеДефекты Тогда
		МассивСтатусов.Добавить(Перечисления.СтатусыДефектов.Устранен);
	КонецЕсли;
	
	Если МассивСтатусов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗапроса.Вставить("Дефекты", СтруктураЗапроса.СчетЗапросов);
	СтруктураЗапроса.СчетЗапросов = СтруктураЗапроса.СчетЗапросов + 1;
	СтруктураЗапроса.ПараметрыЗапроса.Вставить("СтатусыДефектов", МассивСтатусов);
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// ДЕФЕКТЫ
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ДефектныеУзлы.Ссылка.Номер,
	|	ДефектныеУзлы.Ссылка.Дата,
	|	ДефектныеУзлы.Ссылка.Статус,
	|	ДефектныеУзлы.Узел КАК Узел,
	|	ДефектныеУзлы.ОписаниеДефекта,
	|	ДефектныеУзлы.Ссылка.Ответственный,
	|	ДефектныеУзлы.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистрацияДефекта.ДефектныеУзлы КАК ДефектныеУзлы
	|ГДЕ
	|	ДефектныеУзлы.Ссылка.Статус В(&СтатусыДефектов)
	|	И (ДефектныеУзлы.Узел = &ОбъектЭксплуатации
	|			ИЛИ ДефектныеУзлы.Ссылка.ОбъектЭксплуатации = &ОбъектЭксплуатации)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДефектныеУзлы.Ссылка.Статус.Порядок УБЫВ";
	
КонецПроцедуры

// Выводит данные выборки в табличный документ
//
// Параметры:
// 		Пакет - Массив - Массив результатов запросов
// 		СтруктураПакета - Структура - Структура результатов запросов в пакете
// 		ТабличныйДокумент - ТабличныйДокумент- Табличный документ для вывода отчета
//
Процедура ВывестиВТабличныйДокумент(Пакет, СтруктураПакета, ТабличныйДокумент)
	
	Макет = ЭтотОбъект.ПолучитьМакет("МакетКарточкаОбъектаЭксплуатации");
	
	Если СтруктураПакета.Свойство("ОбъектЭксплуатации") И Не Пакет[СтруктураПакета.ОбъектЭксплуатации].Пустой() Тогда
		
		ВывестиВТабличныйДокументОбъектЭксплуатации(Пакет[СтруктураПакета.ОбъектЭксплуатации].Выбрать(), ТабличныйДокумент, Макет);
		
		Если СтруктураПакета.Свойство("ПаспортныеХарактеристики") И Не Пакет[СтруктураПакета.ПаспортныеХарактеристики].Пустой() Тогда
			ВывестиВТабличныйДокументПаспортныеХарактеристики(Пакет[СтруктураПакета.ПаспортныеХарактеристики].Выбрать(), ТабличныйДокумент, Макет);
		КонецЕсли;
		
		Если СтруктураПакета.Свойство("ПодчиненныеУзлы") И Не Пакет[СтруктураПакета.ПодчиненныеУзлы].Пустой() Тогда
			ВывестиВТабличныйДокументПодчиненныеУзлы(Пакет[СтруктураПакета.ПодчиненныеУзлы].Выбрать(), ТабличныйДокумент, Макет);
		КонецЕсли;
		
		Если СтруктураПакета.Свойство("Наработки") И Не Пакет[СтруктураПакета.Наработки].Пустой() Тогда
			ВывестиВТабличныйДокументНаработки(Пакет[СтруктураПакета.Наработки].Выбрать(), ТабличныйДокумент, Макет);
		КонецЕсли;
		
		Если СтруктураПакета.Свойство("Ремонты") И Не Пакет[СтруктураПакета.Ремонты].Пустой() Тогда
			ВывестиВТабличныйДокументРемонты(Пакет[СтруктураПакета.Ремонты].Выбрать(), ТабличныйДокумент, Макет);
		КонецЕсли;
		
		Если СтруктураПакета.Свойство("Дефекты") И Не Пакет[СтруктураПакета.Дефекты].Пустой() Тогда
			ВывестиВТабличныйДокументДефекты(Пакет[СтруктураПакета.Дефекты].Выбрать(), ТабличныйДокумент, Макет);
		КонецЕсли;
		
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЕсли;
	
КонецПроцедуры

// Выводить выборку по объекту эксплуатации в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументОбъектЭксплуатации(Выборка, ТабличныйДокумент, Макет)
	
	Выборка.Следующий();
	
	// Вывод заголовка отчета
	Если ЭтотОбъект.ОтчетПоУзлам Тогда
		ШаблонЗаголовкаОтчета = НСтр("ru='Узел объекта эксплуатации ""%Наименование%""';uk='Вузол об''єкту експлуатації  ""%Наименование%""'");
		ЗаголовокРазделаДанных = НСтр("ru='Данные узла объекта эксплуатации';uk='Дані вузла об''єкта експлуатації'");
	Иначе
		ШаблонЗаголовкаОтчета = НСтр("ru='Объект эксплуатации ""%Наименование%""';uk='Об''єкт експлуатації ""%Наименование%""'");
		ЗаголовокРазделаДанных = НСтр("ru='Данные объекта эксплуатации';uk='Дані об''єкта експлуатації'");
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	ОбластьМакета.Параметры.Заголовок = СтрЗаменить(ШаблонЗаголовкаОтчета, "%Наименование%", Выборка.НаименованиеПолное);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("ОбъектЭксплуатации");
	
	// Вывод заголовка раздела данных объекта
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = ЗаголовокРазделаДанных;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("ДанныеОбъектаРемонта");
	
	// Вывод раздела данных объекта
	ШаблонДанныхОбъекта = Новый Структура;
	ШаблонДанныхОбъекта.Вставить("Наименование", НСтр("ru='<не заполнено>';uk='<не заповнено>'"));
	ШаблонДанныхОбъекта.Вставить("НаименованиеПолное", НСтр("ru='<не заполнено>';uk='<не заповнено>'"));
	ШаблонДанныхОбъекта.Вставить("Принадлежность", НСтр("ru='<в корне дерева>';uk='<в корені дерева>'"));
	ШаблонДанныхОбъекта.Вставить("Класс", НСтр("ru='<не заполнен>';uk='<не заповнений>'"));
	ШаблонДанныхОбъекта.Вставить("Подкласс", НСтр("ru='<не заполнен>';uk='<не заповнений>'"));
	ШаблонДанныхОбъекта.Вставить("Статус", НСтр("ru='<не заполнен>';uk='<не заповнений>'"));
	ШаблонДанныхОбъекта.Вставить("РемонтирующееПодразделение", НСтр("ru='<не заполнено>';uk='<не заповнено>'"));
	ШаблонДанныхОбъекта.Вставить("ЭксплуатирующееПодразделение", НСтр("ru='<не заполнено>';uk='<не заповнено>'"));
	ШаблонДанныхОбъекта.Вставить("Расположение", НСтр("ru='<не заполнено>';uk='<не заповнено>'"));
	ШаблонДанныхОбъекта.Вставить("Модель", НСтр("ru='<не заполнена>';uk='<не заповнена>'"));
	ШаблонДанныхОбъекта.Вставить("СерийныйНомер", НСтр("ru='<не заполнен>';uk='<не заповнений>'"));
	
	Для Каждого КлючИЗначение Из ШаблонДанныхОбъекта Цикл
		Если ЗначениеЗаполнено(Выборка[КлючИЗначение.Ключ]) Тогда
			ШаблонДанныхОбъекта[КлючИЗначение.Ключ] = Выборка[КлючИЗначение.Ключ];
		КонецЕсли;
	КонецЦикла;
	
	Принадлежность = Выборка.Ссылка.ПолноеНаименование();
	Если ЗначениеЗаполнено(Принадлежность) Тогда
		ШаблонДанныхОбъекта.Принадлежность = Принадлежность;
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ДанныеОбъектаЭксплуатации");
	ОбластьМакета.Параметры.Заполнить(ШаблонДанныхОбъекта);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Выводить выборку по паспортным характеристикам в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументПаспортныеХарактеристики(Выборка, ТабличныйДокумент, Макет)
	
	// Вывод заголовка раздела паспортных характеристик
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Паспортные характеристики - %1';uk='Паспортні характеристики - %1'"), Выборка.Количество());
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("ПаспортныеХарактеристики");
	
	// Вывод паспортных характеристик
	Пока Выборка.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПаспортныеХарактеристикиСтрока");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Выводить выборку по подчиненным узлам в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументПодчиненныеУзлы(Выборка, ТабличныйДокумент, Макет)
	
	// Вывод заголовка раздела подчиненных узлов
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Подчиненные узлы - %1';uk='Підпорядковані вузли - %1'"), Выборка.Количество());
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("ПодчиненныеУзлы");
	
	// Вывод заголовка таблицы
	ОбластьМакета = Макет.ПолучитьОбласть("ПодчиненныеУзлыЗаголовок");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	// Вывод подчиненных узлов
	МассивПодчиненныхУзлов = ПолучитьПодчиненныеУзлыПоВыборке(Выборка);
	ВывестиПодчиненныеУзлыВТабличныйДокумент(МассивПодчиненныхУзлов, ТабличныйДокумент, Макет.ПолучитьОбласть("ПодчиненныеУзлыСтрока"));
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Возвращает массив подчиненных узлов по родителю из указанной выборки
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка из запроса по подчиненным узлам объекта
// 		Родитель - СправочникСсылка.ОбъектыРемонта - Текущий родитель для обхода выборки
// 		ПрефиксПолногоНаимнования - Строка - Префикс вывода при печати
//
// Возвращаемое значение:
// 		Массив - Массив структур описания подчиненного узла
//
Функция ПолучитьПодчиненныеУзлыПоВыборке(Выборка, Родитель = Неопределено, Знач ПрефиксНаименования = "")
	
	Если Родитель = Неопределено Тогда
		Родитель = Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка();
	КонецЕсли;
	
	МассивПодчиненныхУзлов = Новый Массив;
	СтруктураПоискаПоРодителю = Новый Структура("Родитель", Родитель);
	
	Выборка.Сбросить();
	Пока Выборка.НайтиСледующий(СтруктураПоискаПоРодителю) Цикл
		
		СтруктураПодчиненногоУзла = Новый Структура("Узел, Наименование, ДатаВводаВЭксплуатацию, ЭксплуатирующееПодразделение, РемонтирующееПодразделение, ПодчиненныеУзлы");
		ЗаполнитьЗначенияСвойств(СтруктураПодчиненногоУзла, Выборка);
		СтруктураПодчиненногоУзла.Наименование = ПрефиксНаименования + СтруктураПодчиненногоУзла.Наименование;
		МассивПодчиненныхУзлов.Добавить(СтруктураПодчиненногоУзла);
		
	КонецЦикла;
	
	Для Каждого Узел Из МассивПодчиненныхУзлов Цикл
		Узел.ПодчиненныеУзлы = ПолучитьПодчиненныеУзлыПоВыборке(Выборка, Узел.Узел, ПрефиксНаименования + Символы.Таб);
	КонецЦикла;
	
	Если МассивПодчиненныхУзлов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МассивПодчиненныхУзлов;
	
КонецФункции

// Выводит в табличный документ массив подчиненных узлов
//
// Параметры:
// 		МассивПодчиенныхУзлов - Массив - Массив структур описания подчиненного узла
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ отчета
// 		ОбластьМакета - ТабличныйДокумент - Область макета строки вывода узла
//
Процедура ВывестиПодчиненныеУзлыВТабличныйДокумент(МассивПодчиненныхУзлов, ТабличныйДокумент, ОбластьМакета)
	
	Для Каждого Узел Из МассивПодчиненныхУзлов Цикл
		
		ОбластьМакета.Параметры.Заполнить(Узел);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ЗначениеЗаполнено(Узел.ПодчиненныеУзлы) Тогда
			ВывестиПодчиненныеУзлыВТабличныйДокумент(Узел.ПодчиненныеУзлы, ТабличныйДокумент, ОбластьМакета);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выводить выборку по наработкам в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументНаработки(Выборка, ТабличныйДокумент, Макет)
	
	// Вывод заголовка раздела наработок
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Наработки - %1';uk='Напрацювання - %1'"), Выборка.Количество());
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("Наработки");
	
	ОбластьМакета = Макет.ПолучитьОбласть("НаработкиЗаголовок");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("НаработкиСтрока");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.ОстаточныйРесурсПоВремени = ОбъектыЭксплуатации.ОстаточныйРесурсПоВремениСтрокой(Выборка.ОстаточныйРесурсДней);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Выводить выборку по ремонтам в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументРемонты(Выборка, ТабличныйДокумент, Макет)
	
	// Вывод заголовка раздела ремонтов
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ремонты - %1';uk='Ремонти - %1'"), Выборка.Количество());
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("Ремонты");
	
	ОбластьМакета = Макет.ПолучитьОбласть("РемонтыЗаголовок");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("РемонтыСтрока");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.НомерИДата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='№ %1 от %2';uk='№ %1 від %2'"),Выборка.Номер, Формат(Выборка.Дата, "ДЛФ=DD"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Выводить выборку по дефектам в табличный документ
//
// Параметры:
// 		Выборка - ВыборкаИзРезультатаЗапроса - Выборка для заполнения табличного документа
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода отчета
// 		Макет - ТабличныйДокумент - Табличный документ макета
//
Процедура ВывестиВТабличныйДокументДефекты(Выборка, ТабличныйДокумент, Макет)
	
	// Вывод заголовка раздела дефектов
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОбластьМакета.Параметры.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Дефекты - %1';uk='Дефекти - %1'"), Выборка.Количество());
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ТабличныйДокумент.НачатьГруппуСтрок("Дефекты");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ДефектыЗаголовок");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДефектыСтрока");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.НомерИДата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='№ %1 от %2';uk='№ %1 від %2'"),Выборка.Номер, Формат(Выборка.Дата, "ДЛФ=DD"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли