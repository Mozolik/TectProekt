﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет узлы по указанному отбору
//
Процедура ЗаполнитьПоОтбору(Отбор, СтруктураДополнительныхСвойств, Отказ=Ложь) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	УзлыОбъектовЭксплуатации.Родитель КАК Родитель,
		|	УзлыОбъектовЭксплуатации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УзлыОбъектовЭксплуатации КАК УзлыОбъектовЭксплуатации
		|ГДЕ
		|	(&ОтборПоляРодитель
		|		И УзлыОбъектовЭксплуатации.Ссылка <> &Родитель
		|		И УзлыОбъектовЭксплуатации.Ссылка В ИЕРАРХИИ (&Родитель))
		|	ИЛИ
		|	(&ОтборПоляВладелец
		|		И УзлыОбъектовЭксплуатации.Владелец = &Владелец)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Родитель");
	
	СтруктураПараметровЗапроса = Новый Структура("Родитель, Владелец");
	ЗаполнитьЗначенияСвойств(СтруктураПараметровЗапроса, Отбор);
	Для Каждого КлючИЗначение Из СтруктураПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		Запрос.УстановитьПараметр("ОтборПоля"+КлючИЗначение.Ключ, ЗначениеЗаполнено(КлючИЗначение.Значение));
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбходаВыборки = Новый Массив;
	МассивОбходаВыборки.Добавить(СтруктураПараметровЗапроса.Родитель);
	СтруктураОбходаВыборки = Новый Структура("Родитель");
	СчетОбходаВыборки = 0;
	
	Выборка = Результат.Выбрать();
	
	Пока СчетОбходаВыборки < МассивОбходаВыборки.Количество() Цикл
		Выборка.Сбросить();
		СтруктураОбходаВыборки.Родитель = МассивОбходаВыборки[СчетОбходаВыборки];
		Пока Выборка.НайтиСледующий(СтруктураОбходаВыборки) Цикл
			
			МассивОбходаВыборки.Добавить(Выборка.Ссылка);
			
			ОбъектСправочника = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектСправочника.ИнициализироватьДополнительныеСвойстваДляЗаписи(СтруктураДополнительныхСвойств);
			
			Попытка
				ОбъектСправочника.Записать();
			Исключение
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			
		КонецЦикла;
		
		СчетОбходаВыборки = СчетОбходаВыборки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описание реквизитов объекта эксплуатации
//
Функция СоставРеквизитов() Экспорт
	
	// Описание формата возвращаемой таблицы реквизитов
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ОбязателенДляЗаполнения", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("ТолькоПросмотрОбязательности", Новый ОписаниеТипов("Булево"));
	
	// Значения заполняемые по-умолчанию в строку каждого из реквизитов
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("Имя", "");
	ЗначенияПоУмолчанию.Вставить("Синоним", "");
	ЗначенияПоУмолчанию.Вставить("ОбязателенДляЗаполнения", "Ложь");
	ЗначенияПоУмолчанию.Вставить("ТолькоПросмотрОбязательности", "Ложь");
	
	// Описания реквизитов, со значениями параметров отличающихся от "по-умолчанию"
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Статус", Новый Структура("ОбязателенДляЗаполнения, ТолькоПросмотрОбязательности", Истина, Истина));
	СтруктураРеквизитов.Вставить("Класс", Новый Структура("ТолькоПросмотрОбязательности", Истина));
	СтруктураРеквизитов.Вставить("Подкласс", Новый Структура("ОбязателенДляЗаполнения, ТолькоПросмотрОбязательности", Ложь, Истина));
	СтруктураРеквизитов.Вставить("ТипОбъекта", Новый Структура("ТолькоПросмотрОбязательности", Истина));
	
	// Список реквизитов, которые должны быть исключены: служебные, не используемые, предназначенные для удаления, булевы признаки
	// 		или любые другие не предназначенные для интрерактивной настройки пользователем
	СтопЛист = Новый Структура(
		"Описание,
		|ВлияетНаДоступностьРЦ,
		|Принадлежность");
	
	// Получение таблицы реквизитов из описания метаданных
	СтруктураСправочника = Метаданные.Справочники.УзлыОбъектовЭксплуатации;
	Для Каждого Реквизит Из СтруктураСправочника.Реквизиты Цикл
		
		Если СтопЛист.Свойство(Реквизит.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаРеквизита = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРеквизита, ЗначенияПоУмолчанию);
		ЗаполнитьЗначенияСвойств(СтрокаРеквизита, Реквизит);
		
		СтрокаРеквизита.ОбязателенДляЗаполнения = (Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку);
		
		Если СтруктураРеквизитов.Свойство(Реквизит.Имя) Тогда
			ЗаполнитьЗначенияСвойств(СтрокаРеквизита, СтруктураРеквизитов[Реквизит.Имя]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Возвращает структуру параметров проверки заполнения
//
Функция ПараметрыПроверкиЗаполнения() Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ПотокОшибок", Новый Структура);
	ОбъектыЭксплуатации.ИнициализироватьПотокОшибок(Параметры.ПотокОшибок);
	
	Параметры.Вставить("СообщатьОшибки", Истина);
	Параметры.Вставить("Форма", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Процедура проверки заполнения узла объекта эксплуатации
//
Процедура ПроверитьЗаполнение(ОбъектПроверки, ПараметрыПроверки, Отказ, КэшированныеЗначения=Неопределено) Экспорт
	
	ОбъектыЭксплуатации.ИнициализироватьКэшированныеЗначенияПроверкиЗаполнения(КэшированныеЗначения);
	
	ТипОбъекта = ТипЗнч(ОбъектПроверки);
	
	Если ТипОбъекта = Тип("СправочникСсылка.УзлыОбъектовЭксплуатации")
		Или ТипОбъекта = Тип("Массив") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Узлы", ОбъектПроверки);
		СформироватьЗапросПроверкиЗаполнения(Запрос.Текст);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ПроверитьУзелОбъектаЭксплуатации(
				Выборка,
				ПараметрыПроверки,
				КэшированныеЗначения);
			
		КонецЦикла;
		
	Иначе
		
		ПроверитьУзелОбъектаЭксплуатации(
			ОбъектПроверки,
			ПараметрыПроверки,
			КэшированныеЗначения);
		
	КонецЕсли;
	
	Если ПараметрыПроверки.ПотокОшибок.СписокОшибок.Количество() <> 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ПараметрыПроверки.СообщатьОшибки Тогда
		ОбъектыЭксплуатации.СообщитьОшибкиПроверкиЗаполнения(ПараметрыПроверки.ПотокОшибок, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьЗапросПроверкиЗаполнения(ТекстЗапроса)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Узлы.*
		|ИЗ
		|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|ГДЕ
		|	Узлы.Ссылка В(&Узлы)");
	
КонецПроцедуры

Функция ПолучитьОбязательныеРеквизиты(Класс, КэшированныеЗначения)
	
	ОбязательныеРеквизиты = КэшированныеЗначения.ОбязательныеРеквизиты.Получить(Класс);
	
	Если ОбязательныеРеквизиты = Неопределено Тогда
		
		Запрос = Новый Запрос;
		
		Если ЗначениеЗаполнено(Класс) Тогда
			Запрос.Текст =
				"ВЫБРАТЬ
				|	РеквизитыДляКонтроляУзлов.Имя,
				|	РеквизитыДляКонтроляУзлов.Синоним
				|ИЗ
				|	Справочник.КлассыОбъектовЭксплуатации.РеквизитыДляКонтроля КАК Реквизиты
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РеквизитыУзлов КАК РеквизитыДляКонтроляУзлов
				|		ПО Реквизиты.ИмяРеквизита = РеквизитыДляКонтроляУзлов.Имя
				|ГДЕ
				|	Реквизиты.Ссылка = &Класс
				|	И Реквизиты.ОбязателенДляЗаполнения"
			;
		Иначе
			Запрос.Текст =
				"ВЫБРАТЬ
				|	Реквизиты.Имя,
				|	Реквизиты.Синоним
				|ИЗ
				|	РеквизитыУзлов КАК Реквизиты
				|ГДЕ
				|	Реквизиты.ОбязателенДляЗаполнения"
			;
			
		КонецЕсли;
		Запрос.МенеджерВременныхТаблиц = КэшированныеЗначения.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Класс", Класс);
		
		ОбязательныеРеквизиты = Запрос.Выполнить().Выгрузить();
		
		КэшированныеЗначения.ОбязательныеРеквизиты.Вставить(Класс, ОбязательныеРеквизиты);
		
	КонецЕсли;
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции

Функция ПолучитьОбязательныеДопРеквизиты(Класс, КэшированныеЗначения)
	
	ОбязательныеДопРеквизиты = КэшированныеЗначения.ОбязательныеДопРеквизиты.Получить(Класс);
	
	Если ОбязательныеДопРеквизиты = Неопределено Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДопРеквизиты.Свойство
			|ИЗ
			|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДопРеквизиты
			|ГДЕ
			|	ДопРеквизиты.Ссылка = ВЫРАЗИТЬ(&Класс КАК Справочник.КлассыОбъектовЭксплуатации).НаборСвойств
			|	И НЕ ДопРеквизиты.Свойство В
			|				(ВЫБРАТЬ
			|					ОбщиеДопРеквизитыУзлов.Свойство
			|				ИЗ
			|					ОбщиеДопРеквизитыУзлов КАК ОбщиеДопРеквизитыУзлов)
			|	И (ДопРеквизиты.Свойство.ЗаполнятьОбязательно)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДопРеквизиты.Свойство
			|ИЗ
			|	ОбщиеДопРеквизитыУзлов КАК ДопРеквизиты
			|ГДЕ
			|	ДопРеквизиты.ЗаполнятьОбязательно");
		Запрос.МенеджерВременныхТаблиц = КэшированныеЗначения.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Класс", Класс);
		
		ОбязательныеДопРеквизиты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Свойство");
		
		КэшированныеЗначения.ОбязательныеДопРеквизиты.Вставить(Класс, ОбязательныеДопРеквизиты);
		
	КонецЕсли;
	
	Возврат ОбязательныеДопРеквизиты;
	
КонецФункции

Функция ПолучитьПараметрыУчетаНаработок(Класс, КэшированныеЗначения)
	
	ПараметрыУчетаНаработок = КэшированныеЗначения.ПараметрыУчетаНаработок.Получить(Класс);
	
	Если ПараметрыУчетаНаработок = Неопределено Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Параметры.ПоказательНаработки КАК ПоказательНаработки,
			|	Параметры.РасчитыватьОстаточныйРесурс КАК ЗаполнятьНазначенныйРесурс,
			|	Параметры.РегистрироватьОтИсточника КАК ЗаполнятьИсточник
			|ИЗ
			|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК Параметры
			|ГДЕ
			|	Параметры.Ссылка = &Класс
			|	И (Параметры.РегистрироватьОтИсточника
			|			ИЛИ Параметры.РасчитыватьОстаточныйРесурс)");
		Запрос.МенеджерВременныхТаблиц = КэшированныеЗначения.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Класс", Класс);
		
		ПараметрыУчетаНаработок = Запрос.Выполнить().Выгрузить();
		
		КэшированныеЗначения.ПараметрыУчетаНаработок.Вставить(Класс, ПараметрыУчетаНаработок);
		
	КонецЕсли;
	
	Возврат ПараметрыУчетаНаработок;
	
КонецФункции

Процедура ПроверитьУзелОбъектаЭксплуатации(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения)
	
	ПроверитьРеквизиты(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения);
	ПроверитьДопРеквизиты(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения);
	
	ПроверитьПараметрыУчетаНаработок(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПроверитьРеквизиты(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения)
	
	ОбязательныеРеквизиты = ПолучитьОбязательныеРеквизиты(ОбъектПроверки.Класс, КэшированныеЗначения);
	
	Для Каждого Реквизит Из ОбязательныеРеквизиты Цикл
		
		Если Не ЗначениеЗаполнено(ОбъектПроверки[СокрЛП(Реквизит.Имя)]) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Поле ""%1"" не заполнено.';uk='Поле ""%1"" не заповнене.'"),
				СокрЛП(Реквизит.Синоним));
			
			ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
				ПараметрыПроверки.ПотокОшибок,
				ОбъектПроверки.Ссылка,
				"Объект."+Реквизит.Имя,
				ТекстОшибки,
				"Реквизиты",
				0,
				ТекстОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДопРеквизиты(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения)
	
	Если ПараметрыПроверки.Форма = Неопределено Тогда
		
		ОбязательныеДопРеквизиты = ПолучитьОбязательныеДопРеквизиты(ОбъектПроверки.Класс, КэшированныеЗначения);
		
		ТаблицаДопРеквизитов = ОбъектПроверки.ДополнительныеРеквизиты.Выгрузить();
		
		Для Каждого Свойство Из ОбязательныеДопРеквизиты Цикл
			
			Если ТаблицаДопРеквизитов.Найти(Свойство, "Свойство") = Неопределено Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Поле ""%1"" не заполнено.';uk='Поле ""%1"" не заповнене.'"),
					Свойство);
				
				ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
					ПараметрыПроверки.ПотокОшибок,
					ОбъектПроверки.Ссылка,
					"ГруппаДополнительныеРеквизиты",
					ТекстОшибки,
					"ДопРеквизиты",
					0,
					ТекстОшибки);
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Если Не (ПараметрыПроверки.Форма.Свойства_ИспользоватьСвойства И ПараметрыПроверки.Форма.Свойства_ИспользоватьДопРеквизиты) Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого Строка Из ПараметрыПроверки.Форма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
			Если Строка.ЗаполнятьОбязательно Тогда
				
				Если НЕ ЗначениеЗаполнено(ПараметрыПроверки.Форма[Строка.ИмяРеквизитаЗначение]) Тогда
					
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Поле ""%1"" не заполнено.';uk='Поле ""%1"" не заповнене.'"),
						Строка.Наименование);
					
					ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
						ПараметрыПроверки.ПотокОшибок,
						ОбъектПроверки.Ссылка,
						Строка.ИмяРеквизитаЗначение,
						ТекстОшибки,
						"ДопРеквизиты",
						0,
						ТекстОшибки);
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПараметрыУчетаНаработок(ОбъектПроверки, ПараметрыПроверки, КэшированныеЗначения)
	
	Если ПараметрыПроверки.Форма = Неопределено Тогда
		
		ПараметрыУчетаНаработки = ПолучитьПараметрыУчетаНаработок(ОбъектПроверки.Класс, КэшированныеЗначения);
		
		ТаблицаПараметров = ОбъектПроверки.ПараметрыУчетаНаработок.Выгрузить();
		
		Для Каждого НастройкаПоказателя Из ПараметрыУчетаНаработки Цикл
			
			Строка = ТаблицаПараметров.Найти(НастройкаПоказателя.ПоказательНаработки, "ПоказательНаработки");
			
			Если Строка = Неопределено Или (НастройкаПоказателя.ЗаполнятьНазначенныйРесурс И Не ЗначениеЗаполнено(Строка.НазначенныйРесурс)) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Назначенный ресурс показателя наработки ""%1"" не заполнен';uk='Призначений ресурс показника напрацювання ""%1"" не заповнений'"),
					НастройкаПоказателя.ПоказательНаработки);
				
				ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
					ПараметрыПроверки.ПотокОшибок,
					ОбъектПроверки.Ссылка,
					"ПараметрыУчетаНаработок",
					ТекстОшибки,
					"ПараметрыУчетаНаработок",
					0,
					ТекстОшибки);
				
			КонецЕсли;
			
			Если Строка = Неопределено Или (НастройкаПоказателя.ЗаполнятьИсточник И Не ЗначениеЗаполнено(Строка.Источник)) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Источник текущих значений показателя наработки ""%1"" не заполнен';uk='Джерело поточних значень показника напрацювання ""%1"" не заповнений'"),
					НастройкаПоказателя.ПоказательНаработки);
				
				ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
					ПараметрыПроверки.ПотокОшибок,
					ОбъектПроверки.Ссылка,
					"ПараметрыУчетаНаработок",
					ТекстОшибки,
					"ПараметрыУчетаНаработок",
					0,
					ТекстОшибки);
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Если ПараметрыПроверки.Форма.ПараметрыУчетаНаработок.Количество()=0 Тогда
			Возврат;
		КонецЕсли;
		
		Для ТекИндекс=0 По ПараметрыПроверки.Форма.ПараметрыУчетаНаработок.Количество()-1 Цикл
			
			Строка = ПараметрыПроверки.Форма.ПараметрыУчетаНаработок[ТекИндекс];
			
			Если Строка.ЗаполнятьНазначенныйРесурс И Не ЗначениеЗаполнено(Строка.НазначенныйРесурс) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Назначенный ресурс показателя наработки ""%1"" не заполнен';uk='Призначений ресурс показника напрацювання ""%1"" не заповнений'"),
					Строка.ПоказательНаработки);
				
				ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
					ПараметрыПроверки.ПотокОшибок,
					ОбъектПроверки.Ссылка,
					"ПараметрыУчетаНаработок[%1].НазначенныйРесурс",
					ТекстОшибки,
					"ПараметрыУчетаНаработок",
					ТекИндекс,
					ТекстОшибки);
				
			КонецЕсли;
			Если Строка.ЗаполнятьИсточник И Не ЗначениеЗаполнено(Строка.Источник) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Источник текущих значений показателя наработки ""%1"" не заполнен';uk='Джерело поточних значень показника напрацювання ""%1"" не заповнений'"),
					Строка.ПоказательНаработки);
				
				ОбъектыЭксплуатации.ДобавитьОшибкуПользователю(
					ПараметрыПроверки.ПотокОшибок,
					ОбъектПроверки.Ссылка,
					"ПараметрыУчетаНаработок[%1].ОбъектФормы",
					ТекстОшибки,
					"ПараметрыУчетаНаработок",
					ТекИндекс,
					ТекстОшибки);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

