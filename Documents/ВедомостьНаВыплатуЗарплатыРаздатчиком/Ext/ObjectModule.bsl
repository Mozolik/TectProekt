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

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает в ведомости переданную зарплату физических лиц
//
// Параметры:
//  ЗарплатаРаботников - ТаблицаЗначений - таблица значений с колонками:
//		* ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//		* Сумма - Число
//
Процедура УстановитьЗарплатуРаботников(ЗарплатаРаботников) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьУстановитьЗарплатуРаботников(ЭтотОбъект, ЗарплатаРаботников)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаЗаполнения(ЭтотОбъект,ДанныеЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Индекс = ПроверяемыеРеквизиты.Найти("Зарплата.ГруппаУчетаНачислений");
	Если Индекс <> Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(Индекс);
	КонецЕсли;	
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыССотрудниками.ВедомостьПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	
	МожноЗаполнитьЗарплату = 
		ВзаиморасчетыССотрудниками.ВедомостьМожноЗаполнитьЗарплату(ЭтотОбъект);
		
	ПравилаПроверки = Новый Структура;
	ПравилаПроверки.Вставить("Раздатчик", НСтр("ru='Не указан раздатчик';uk='Не вказано роздавальник'"));
	
	МожноЗаполнитьЗарплату = 
		ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(ЭтотОбъект, ПравилаПроверки, Истина)
		И МожноЗаполнитьЗарплату;
	
	Возврат МожноЗаполнитьЗарплату
	
КонецФункции

Процедура ЗаполнитьЗарплату() Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьЗаполнитьЗарплату(ЭтотОбъект);
КонецПроцедуры	

Процедура ДополнитьЗарплату(ФизическиеЛица) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьДополнитьЗарплату(ЭтотОбъект, ФизическиеЛица);
КонецПроцедуры	

#КонецОбласти

Функция МестоВыплаты() Экспорт
	
	МестоВыплаты = ВзаиморасчетыССотрудниками.ВедомостьМестоВыплаты();
	МестоВыплаты.Вид = Перечисления.ВидыМестВыплатыЗарплаты.Раздатчик;
	МестоВыплаты.Значение = Раздатчик; 
	
	Возврат МестоВыплаты
	
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	Раздатчик = Значение;
КонецПроцедуры

Процедура ЗаполнитьПоТаблицеЗарплат(ТаблицаЗарплат) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьЗаполнитьПоТаблицеЗарплат(ЭтотОбъект, ТаблицаЗарплат);
КонецПроцедуры

Процедура ДополнитьПоТаблицеЗарплат(ТаблицаЗарплат) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьДополнитьПоТаблицеЗарплат(ЭтотОбъект, ТаблицаЗарплат)
КонецПроцедуры


#КонецОбласти

#КонецЕсли