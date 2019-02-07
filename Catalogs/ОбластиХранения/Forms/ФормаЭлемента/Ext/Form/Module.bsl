﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
		
	ИспользоватьХарактеристики = Константы.ИспользоватьХарактеристикиНоменклатуры.Получить();
	ИспользоватьСерии = Константы.ИспользоватьСерииНоменклатуры.Получить();
		   
	Если Не ИспользоватьСерии Тогда
		
		Элементы.ОписаниеМонотоварности.СписокВыбора.Удалить(2);
		Элементы.ДекорацияМонотоварностьБезСерий.Видимость = Истина;

		Если Не ИспользоватьХарактеристики Тогда
			Элементы.СтраницыМонотоварностьИПриоритетОтбора.ТекущаяСтраница = Элементы.СтраницаБезМонотоварности;
		КонецЕсли;
		
	Иначе
		
		Если Не ИспользоватьХарактеристики Тогда
			Элементы.ОписаниеМонотоварности.СписокВыбора[2].Представление = НСтр("ru='по номенклатуре и серии';uk='по номенклатурі і серії'");
			Элементы.ОписаниеМонотоварности.СписокВыбора.Удалить(1);
			Элементы.ДекорацияМонотоварностьБезСерий.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.СтрогаяМонотоварность Тогда
		Размещать = "СтрогаяМонотоварность";
	Иначе
		Размещать = "ПоПриоритетам";
	КонецЕсли;	
	
	НастроитьДоступностьПриоритетовРазмещения();
	
	Если НЕ ЗначениеЗаполнено(Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек) Тогда
		Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек = Перечисления.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.НеИспользовать;		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
		
	Если Не ПравоДоступа("Изменение",Метаданные.Справочники.ОбластиХранения) Тогда
		Элементы.ГруппаХранениеТоваров.Доступность = Ложь;	
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Размещать = "ПоПриоритетам" Тогда
		ТекущийОбъект.СтрогаяМонотоварность = Ложь;
	Иначе
		ТекущийОбъект.СтрогаяМонотоварность = Истина;
	КонецЕсли;	

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Описание",
		НСтр("ru='Описание';uk='Опис'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Владелец))
КонецПроцедуры

&НаКлиенте
Процедура ТипХраненияПриИзменении(Элемент)
	
	Если ТипХранения = "Общий" Тогда
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииДоступны;
		Объект.ОбластьОбособленногоХранения = Ложь;
	Иначе
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииНедоступны;
		Объект.ОбластьОбособленногоХранения = Истина;
	КонецЕсли;	
	          	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзменении(Элемент)
	ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере();
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

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.ОбластиХранения.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Владелец));
	
	
	ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленноеОбеспечениеЗаказов");
	
	Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленноеОбеспечениеЗаказов") 
		И Объект.ОбластьОбособленногоХранения Тогда
		ТипХранения = "Обособленный";
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииНедоступны;
	Иначе
		ТипХранения = "Общий";
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииДоступны;
	КонецЕсли;
	
	Элементы.ПояснениеОбособленногоХранения.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;
	Элементы.ПояснениеОбособленногоХранения1.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;
	
	ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьПриоритетовРазмещения()
	
	Если Размещать = "СтрогаяМонотоварность" Тогда
		Элементы.ПриоритетыРазмещения.Доступность = Ложь;
	Иначе
		Элементы.ПриоритетыРазмещения.Доступность = Истина;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере()
	
	Если Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек 
			= Перечисления.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.ИспользоватьНастройкиОбластиХранения Тогда 
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.ГруппаКоличествоДнейМеждуИнвентаризациямиДоступно;
	Иначе
		Объект.КоличествоДнейМеждуИнвентаризациями = 0;
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.ГруппаКоличествоДнейМеждуИнвентаризациямиНедоступно;
	КонецЕсли;
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура РазмещатьПриИзменении(Элемент)
	
	НастроитьДоступностьПриоритетовРазмещения();	
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#КонецОбласти
