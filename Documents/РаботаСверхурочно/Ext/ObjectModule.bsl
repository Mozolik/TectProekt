﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ВремяУчтено И ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда 
		РегистрируемыеДанныеОВремени = ДанныеОВремени();
		УчетРабочегоВремени.ПроверитьРегистрируемыеДанныхОВремени(Ссылка, РегистрируемыеДанныеОВремени, Отказ, Истина, ПериодРегистрации);
		УчетРабочегоВремени.ЗарегистрироватьРабочееВремяСотрудников(Движения, РегистрируемыеДанныеОВремени, ПериодРегистрации);
		// Отгулы
		УчетРабочегоВремени.ЗарегистрироватьДниЧасыОтгуловСотрудников(Движения, ДанныеОбОтгулах());
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоМесяца(ПериодРегистрации);
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= КонецМесяца(ПериодРегистрации);
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	Если Не СогласиеПолучено Тогда
		ТекстСообщения = НСтр("ru='Не получено согласие работников.';uk='Не отримано згоду працівників.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, , , Отказ);
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
	Если ВремяУчтено Тогда 
		ТаблицаСотрудники = Сотрудники.Выгрузить();
		ТаблицаСотрудники.Свернуть("Сотрудник", "ОтработаноЧасов");
		Для Каждого СтрокаСотрудника Из ТаблицаСотрудники Цикл 
			Если СтрокаСотрудника.ОтработаноЧасов = 0 Тогда 
				ИндексСтроки = ТаблицаСотрудники.Индекс(СтрокаСотрудника);
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='%1 - не указано количество часов.';uk='%1 - не зазначено кількість годин.'"), СтрокаСотрудника.Сотрудник);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения, Ссылка, "Сотрудники[" + ИндексСтроки + "].Сотрудник", , Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеОВремени() Экспорт
	
	ДанныеОВремени = УчетРабочегоВремени.ТаблицаДляРегистрацииВремени();
	
	ВидВремениСверхурочные = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Сверхурочные");
	ВидВремениСверхурочныеБезОплаты = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.СверхурочныеБезПовышеннойОплаты");
	
	Для Каждого ТекСтрока Из Сотрудники Цикл
		
		Если ТекСтрока.ОтработаноЧасов = 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ТекСтрока.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			ПрисваиваемыйВидВремени = ВидВремениСверхурочныеБезОплаты;
		Иначе
			ПрисваиваемыйВидВремени = ВидВремениСверхурочные;
		КонецЕсли;
		Если ПрисваиваемыйВидВремени = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДанныхОВремени = ДанныеОВремени.Добавить();
		СтрокаДанныхОВремени.Дата = ТекСтрока.Дата;
		СтрокаДанныхОВремени.Сотрудник = ТекСтрока.Сотрудник;
		СтрокаДанныхОВремени.ВидВремени = ПрисваиваемыйВидВремени;
		СтрокаДанныхОВремени.Дней = 1;
		СтрокаДанныхОВремени.Часов = ТекСтрока.ОтработаноЧасов;
		
	КонецЦикла;

	Возврат ДанныеОВремени;
	
КонецФункции	

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.РаботаСверхурочно.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеОбОтгулах()

	ТаблицаОтгулов = Новый ТаблицаЗначений;
	ТаблицаОтгулов.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОтгулов.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаОтгулов.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаОтгулов.Колонки.Добавить("ВидДвижения", Новый ОписаниеТипов("ВидДвиженияНакопления"));
	ТаблицаОтгулов.Колонки.Добавить("Дни", Новый ОписаниеТипов("Число"));
	ТаблицаОтгулов.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		Если НЕ СтрокаТаблицы.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаОтгулов.Добавить();
		НоваяСтрока.Период = СтрокаТаблицы.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Сотрудник = СтрокаТаблицы.Сотрудник;
		НоваяСтрока.Дни = 0; 
		НоваяСтрока.Часы = СтрокаТаблицы.ОтработаноЧасов;
	КонецЦикла;

	Возврат ТаблицаОтгулов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
