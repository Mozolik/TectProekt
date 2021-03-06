﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыЗаполнения

Функция ДанныеОВремениСотрудников(ДанныеТабеля, СписокСотрудников = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", ДанныеТабеля.Организация);
	Запрос.УстановитьПараметр("ДатаНачала", ДанныеТабеля.ДатаНачалаПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", ДанныеТабеля.ДатаОкончанияПериода);

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	НеучитываемыеДокументы = Новый Массив;
	Если Не ДанныеТабеля.Ссылка.Пустая() Тогда
		НеучитываемыеДокументы.Добавить(ДанныеТабеля.Ссылка);
	КонецЕсли;
	
	Если Не ДанныеТабеля.ИсправленныйДокумент.Пустая() Тогда
		НеучитываемыеДокументы.Добавить(ДанныеТабеля.ИсправленныйДокумент);
	КонецЕсли;	
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Месяц", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));	
	ТаблицаСотрудников.Колонки.Добавить("ДатаАктуальности", Новый ОписаниеТипов("Дата"));	
	
	Если СписокСотрудников = Неопределено Тогда
		ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудников.Организация  = ДанныеТабеля.Организация;
		ПараметрыПолученияСотрудников.НачалоПериода = ДанныеТабеля.ДатаНачалаПериода;
		ПараметрыПолученияСотрудников.ОкончаниеПериода = ДанныеТабеля.ДатаОкончанияПериода;
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
			Модуль.ДобавитьОтборыПоВидуДоговора(ПараметрыПолученияСотрудников.Отборы);
		КонецЕсли; 
	
		КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников, "ВТСотрудникиОрганизации");
		
		Запрос.УстановитьПараметр("Месяц", НачалоМесяца(ДанныеТабеля.ДатаНачалаПериода));
		Запрос.УстановитьПараметр("ДатаАктуальности", НачалоМесяца(ДанныеТабеля.Дата));
	
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиОрганизации.Сотрудник,
		|	&Месяц,
		|	&ДатаАктуальности,
		|	&ДатаНачала,
		|	&ДатаОкончания
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации";
		
		Запрос.Выполнить();
		
	Иначе	
		Для Каждого Сотрудник Из СписокСотрудников Цикл
			СтрокаТаблицыСотрудников = ТаблицаСотрудников.Добавить();
			СтрокаТаблицыСотрудников.Сотрудник = Сотрудник;
			СтрокаТаблицыСотрудников.Месяц = НачалоМесяца(ДанныеТабеля.ДатаНачалаПериода); 
			СтрокаТаблицыСотрудников.ДатаНачала = ДанныеТабеля.ДатаНачалаПериода;
			СтрокаТаблицыСотрудников.ДатаОкончания = ДанныеТабеля.ДатаОкончанияПериода;
			СтрокаТаблицыСотрудников.ДатаАктуальности = ДанныеТабеля.Дата;
		КонецЦикла;	
		
		Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаСотрудников.Сотрудник,
		|	ТаблицаСотрудников.Месяц,
		|	ТаблицаСотрудников.ДатаНачала,
		|	ТаблицаСотрудников.ДатаОкончания,
		|	ТаблицаСотрудников.ДатаАктуальности КАК ДатаАктуальности
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&ТаблицаСотрудников КАК ТаблицаСотрудников";
		
		Запрос.Выполнить();
	КонецЕсли;	
	
	ПараметрыДляЗапросВТРабочиеМестаСотрудников = КадровыйУчет.ПараметрыДляЗапросВТРабочиеМестаСотрудниковПоВременнойТаблице(
														"ВТСотрудники",
														"Сотрудник", 
														"ДатаНачала",
														"ДатаОкончания");
	
	ЗапросВТРабочиеМестаСотрудников = КадровыйУчет.ЗапросВТРабочиеМестаСотрудниковПоВременнойТаблице(
											Истина, 
											"ВТРабочиеМестаСотрудников",
											ПараметрыДляЗапросВТРабочиеМестаСотрудников);
										
	ЗапросВТРабочиеМестаСотрудников.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;		
	ЗапросВТРабочиеМестаСотрудников.Выполнить();

	ПараметрыПолученияДанных = УчетРабочегоВремени.ПараметрыДляСоздатьВТПлановоеВремяСотрудников();
	ПараметрыПолученияДанных.НеучитываемыеРегистраторы = НеучитываемыеДокументы;
	
	УчетРабочегоВремени.СоздатьВТПлановоеВремя(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПериодыРаботы.Сотрудник,
	|	ПериодыРаботы.Период КАК ДатаНачала,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ПериодыРаботыСлед.Период ЕСТЬ NULL 
	|				ТОГДА &ДатаОкончания
	|			КОГДА ПериодыРаботыСлед.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
	|				ТОГДА ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ПериодыРаботыСлед.Период, ДЕНЬ), ДЕНЬ, -1)
	|			ИНАЧЕ ДОБАВИТЬКДАТЕ(ПериодыРаботыСлед.Период, СЕКУНДА, -1)
	|		КОНЕЦ) КАК ДатаОкончания,
	|	ПериодыРаботы.Организация,
	|	ПериодыРаботы.Подразделение,
	|	ПериодыРаботы.Должность
	|ПОМЕСТИТЬ ВТПериодыРаботыСотрудников
	|ИЗ
	|	ВТРабочиеМестаСотрудников КАК ПериодыРаботы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМестаСотрудников КАК ПериодыРаботыСлед
	|		ПО ПериодыРаботы.Сотрудник = ПериодыРаботыСлед.Сотрудник
	|			И ПериодыРаботы.Период < ПериодыРаботыСлед.Период
	|ГДЕ
	|	ПериодыРаботы.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
	|	И ПериодыРаботы.Организация = &Организация
	|	И &УсловиеПодразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ПериодыРаботы.Сотрудник,
	|	ПериодыРаботы.Период,
	|	ПериодыРаботы.Организация,
	|	ПериодыРаботы.Подразделение,
	|	ПериодыРаботы.Должность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПлановоеВремя.Сотрудник,
	|	ПлановоеВремя.Дата,
	|	СУММА(ПлановоеВремя.ЧасыПлан) КАК НормаЧасов
	|ПОМЕСТИТЬ ВТНормаВремени
	|ИЗ
	|	ВТПлановоеВремя КАК ПлановоеВремя
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановоеВремя.Сотрудник,
	|	ПлановоеВремя.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПлановоеВремя.Сотрудник КАК Сотрудник,
	|	ПлановоеВремя.Дата КАК Дата,
	|	ПлановоеВремя.ДниПлан КАК Дней,
	|	ПлановоеВремя.ЧасыПлан КАК Часы,
	|	ПлановоеВремя.ВидУчетаВремени КАК ВидУчетаВремени,
	|	ЕСТЬNULL(НормаВремени.НормаЧасов, 0) КАК НормаЧасов,
	|	НАЧАЛОПЕРИОДА(ПлановоеВремя.Дата, МЕСЯЦ) КАК Месяц
	|ИЗ
	|	ВТПлановоеВремя КАК ПлановоеВремя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыРаботыСотрудников КАК ПериодыРаботыСотрудников
	|		ПО ПлановоеВремя.Сотрудник = ПериодыРаботыСотрудников.Сотрудник
	|			И ПлановоеВремя.Дата >= ПериодыРаботыСотрудников.ДатаНачала
	|			И ПлановоеВремя.Дата <= ПериодыРаботыСотрудников.ДатаОкончания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНормаВремени КАК НормаВремени
	|		ПО ПлановоеВремя.Сотрудник = НормаВремени.Сотрудник
	|			И ПлановоеВремя.Дата = НормаВремени.Дата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ПлановоеВремя.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	(ПлановоеВремя.ДниПлан <> 0
	|			ИЛИ ПлановоеВремя.ЧасыПлан <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Дата,
	|	ВидУчетаВремени,
	|	Часы УБЫВ";	
	
	Если ЗначениеЗаполнено(ДанныеТабеля.Подразделение) И ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		Запрос.УстановитьПараметр("Подразделение", ДанныеТабеля.Подразделение);
		ТекстУсловияПодразделение = "ПериодыРаботы.Подразделение = &Подразделение";
	Иначе
		ТекстУсловияПодразделение = "ИСТИНА";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПодразделение", ТекстУсловияПодразделение);
	
	ПсевдонимыТаблиц = Новый Соответствие;
	ПсевдонимыТаблиц.Вставить("Справочник.ПодразделенияОрганизаций", "ПериодыРаботыСотрудников");
	ПсевдонимыТаблиц.Вставить("Справочник.Должности", "ПериодыРаботыСотрудников");
	ПсевдонимыТаблиц.Вставить("Справочник.Сотрудники", "ВЫРАЗИТЬ(ПериодыРаботыСотрудников.Сотрудник КАК Справочник.Сотрудники)");
	
	ЗарплатаКадры.ДополнитьТекстЗапросаУпорядочиваниемСотрудников(Запрос, ПсевдонимыТаблиц);
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

Функция ДоступныеДляВводаВидыВремени() Экспорт
	ДоступныеДляВводаВидыВремени = Новый Соответствие;
	
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "ВыходныеДни");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаВРежимеНеполногоВремени");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаВечерниеЧасы");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаНочныеЧасы");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "СокращенноеРабочееВремя");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "Явка");
	
	Возврат ДоступныеДляВводаВидыВремени;
КонецФункции

Процедура ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеВидыВремени, ИдентификаторВидаВремени)
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени." + ИдентификаторВидаВремени);
	
	Если ЗначениеЗаполнено(ВидВремени) Тогда
		ДоступныеВидыВремени.Вставить(ВидВремени, Истина);
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли