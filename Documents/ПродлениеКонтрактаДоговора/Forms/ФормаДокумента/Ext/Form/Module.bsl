﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		ЗаполнитьДанныеФормыПоОрганизации();
		
		ЗаполнитьСведенияОКонтрактеДоговореСотрудника();
		
		ПриПолученииДанныхНаСервере(Объект);
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ДанныеВРеквизиты();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИсправленДокумент" И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизиты();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПродленияПриИзменении(Элемент)
	
	ДатаПродленияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СрочныйДоговорПриИзменении(Элемент)
	
	СрочныйДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗавершенияТрудовогоДоговораПриИзменении(Элемент)
	Если НЕ Объект.СрочныйДоговор Тогда
		Объект.СрочныйДоговор = ЗначениеЗаполнено(Объект.ДатаЗавершенияТрудовогоДоговора);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИныеУсловияДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИныеУсловияДоговораЗавершениеВвода", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		НСтр("ru='Иные условия';uk='Інші умови'"));

КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеРабочегоМестаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ОборудованиеРабочегоМестаЗавершениеВвода", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		НСтр("ru='Оборудование рабочего места';uk='Обладнання робочого місця'"));
		
КонецПроцедуры

&НаКлиенте
Процедура СрокЗаключенияДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("СрокЗаключенияДоговораЗавершениеВвода", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		НСтр("ru='Срок заключения договора';uk='Термін укладання договору'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПредставителяНанимателяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ОснованиеПредставителяНанимателяЗавершениеВвода", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		НСтр("ru='Основание представителя нанимателя';uk='Підстава представника наймача'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ВидАктаГосорганаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВидАктаГосорганаЗавершениеВвода", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		НСтр("ru='Вид акта государственного органа';uk='Вид акта державного органу'"));
		
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ПродлениеКонтрактаДоговора");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ПриемНаРаботу");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ПриемНаРаботу");
КонецПроцедуры
// Конец ИсправлениеДокументов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()

	ОбновитьДанныеТекущегоКонтрактаСотрудника();

КонецПроцедуры

&НаСервере
Процедура ДатаПродленияПриИзмененииНаСервере()
	
	ОбновитьДанныеТекущегоКонтрактаСотрудника();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеТекущегоКонтрактаСотрудника()
	
	ЗаполнитьСведенияОКонтрактеДоговореСотрудника();
	ОписаниеФормы = ОписаниеФормыРедактирующейДанныеКонтрактаДоговора();
	КонтрактыДоговорыСотрудниковФормы.НастроитьФормуПоВидуДоговора(ЭтотОбъект, ОписаниеФормы, ВидДоговора);
	КонтрактыДоговорыСотрудниковФормы.УстановитьДоступностьПолейСрочногоТрудовогоДоговора(ЭтотОбъект, ОписаниеФормы, Истина, Объект.СрочныйДоговор);
	
КонецПроцедуры

&НаСервере
Процедура СрочныйДоговорПриИзмененииНаСервере()
	КонтрактыДоговорыСотрудниковФормы.УстановитьДоступностьПолейСрочногоТрудовогоДоговора(ЭтотОбъект, ОписаниеФормыРедактирующейДанныеКонтрактаДоговора(), Истина, Объект.СрочныйДоговор);
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.ПредставительНанимателя");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьПредставителяНанимателя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнитьФорму();
	УстановитьФункциональныеОпцииФормы();
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьФорму()
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ОписаниеФормы = ОписаниеФормыРедактирующейДанныеКонтрактаДоговора();
	КонтрактыДоговорыСотрудниковФормы.НастроитьФормуПоВидуДоговора(ЭтотОбъект, ОписаниеФормы, ВидДоговора);
	КонтрактыДоговорыСотрудниковФормы.УстановитьДоступностьПолейСрочногоТрудовогоДоговора(ЭтотОбъект, ОписаниеФормы, Истина, Объект.СрочныйДоговор);
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
КонецПроцедуры

&НаСервере
Функция ОписаниеФормыРедактирующейДанныеКонтрактаДоговора()
	
	ОписаниеФормы = КонтрактыДоговорыСотрудниковФормы.ОписаниеФормыРедактирующейДанныеКонтрактаДоговора();
	
	Возврат ОписаниеФормы;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСведенияОКонтрактеДоговореСотрудника()
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаПродления)
		Или НЕ ЗначениеЗаполнено(Объект.Сотрудник) Тогда
	    Возврат;
	КонецЕсли;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник), "ВидДоговора", Объект.ДатаПродления); 
	Если КадровыеДанные.Количество() > 0 Тогда
		ВидДоговора = КадровыеДанные[0].ВидДоговора;
	КонецЕсли;
	
	СведенияОКонтрактеДоговоре = КонтрактыДоговорыСотрудников.СведенияОКонтрактеДоговореСотрудника(Объект.ДатаПродления, Объект.Сотрудник);
	
	Объект.СрочныйДоговор 					= СведенияОКонтрактеДоговоре.СрочныйДоговор;
	Объект.ДатаЗавершенияТрудовогоДоговора 	= СведенияОКонтрактеДоговоре.ДатаОкончания;
	Объект.СрокЗаключенияДоговора 			= СведенияОКонтрактеДоговоре.СрокЗаключенияДоговора;
	Объект.ОснованиеСрочногоДоговора 		= СведенияОКонтрактеДоговоре.ОснованиеСрочногоДоговора;
	Объект.ОборудованиеРабочегоМеста 		= СведенияОКонтрактеДоговоре.ОборудованиеРабочегоМеста;
	Объект.ИныеУсловияДоговора 				= СведенияОКонтрактеДоговоре.ИныеУсловияДоговора;
	Объект.ВидАктаГосоргана 				= СведенияОКонтрактеДоговоре.ВидАктаГосоргана;
	Объект.ОснованиеПредставителяНанимателя = СведенияОКонтрактеДоговоре.ОснованиеПредставителяНанимателя;

КонецПроцедуры

&НаКлиенте
Процедура ИныеУсловияДоговораЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Объект.ИныеУсловияДоговора = ВведенныйТекст;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеРабочегоМестаЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Объект.ОборудованиеРабочегоМеста = ВведенныйТекст;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокЗаключенияДоговораЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Объект.СрокЗаключенияДоговора = ВведенныйТекст;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПредставителяНанимателяЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Объект.ОснованиеПредставителяНанимателя = ВведенныйТекст;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидАктаГосорганаЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Объект.ВидАктаГосоргана = ВведенныйТекст;
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
