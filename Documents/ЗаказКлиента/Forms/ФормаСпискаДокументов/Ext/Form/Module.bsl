﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИспользоватьПричиныОтменыЗаказовКлиентов = ПолучитьФункциональнуюОпцию("ИспользоватьПричиныОтменыЗаказовКлиентов");
	ИспользоватьУпрощеннуюСхемуОплаты        = ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах");
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности",               НачалоДня(ТекущаяДатаСеанса()));
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокВыполнения.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Приоритет", Приоритет, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоСостояниюСервер();
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОтбораПоСостояниюСервер(Элементы.ОтборСостояние.СписокВыбора, ИспользоватьУпрощеннуюСхемуОплаты);
	ИспользоватьРеализациюПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам");
	ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам");
	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	ИспользоватьОрдернуюСхемуПриОтгрузке = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтгрузке");
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаказКлиента));
	
	УстановитьВидимостьЭлементов();
	Если НЕ ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента Тогда
		Элементы.УстановитьСтатусКВыполнению.Заголовок = НСтр("ru='В резерве';uk='В резерві'");
	КонецЕсли;
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	// КомандыЭДО
	ОбменСКонтрагентами.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюЭДО);
	// Конец КомандыЭДО
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияЗавершение", ЭтотОбъект, Новый Структура("ИмяСобытия", ИмяСобытия)), МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
            Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	ОбработкаОповещенияФрагмент(ИмяСобытия);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияФрагмент(Знач ИмяСобытия)
    
    Если ИмяСобытия = "ЗачтенаОплата" Или ПродажиКлиент.ИзменилисьДокументыОплатыКлиентам(ИмяСобытия) Тогда
        Элементы.Список.Обновить();
    КонецЕсли;
    
    // Подсистема "ЭлектронныеДокументы"
    Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
        Элементы.Список.Обновить();
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Приоритет", Приоритет, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоСостояниюСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостояниюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияПриИзменении(Элемент)

	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));

КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));

КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерОчистка(Элемент, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетОчистка(Элемент, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Приоритет) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОчистка(Элемент, СтандартнаяОбработка)
	Если Состояние = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНаСогласовании(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""На согласовании"".
        |По принятым к выполнению заказам могут быть оформлены документы. Продолжить?'
        |;uk='У виділених у списку замовлень буде встановлено статус ""На погодження"".
        |За прийнятими до виконання замовленнями можуть бути оформлені документи. Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНаСогласованииЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаСогласованииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласован");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='На согласовании';uk='На погодженні'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента Тогда
		ИмяСтатуса = НСтр("ru='К выполнению';uk='До виконання'");
	Иначе
		ИмяСтатуса = НСтр("ru='В резерве';uk='В резерві'");
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""%ИмяСтатуса%"". Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""%ИмяСтатуса%"". Продовжити?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяСтатуса%", ИмяСтатуса);
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки, ИмяСтатуса", ВыделенныеСтроки, ИмяСтатуса)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    ИмяСтатуса = ДополнительныеПараметры.ИмяСтатуса;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), ИмяСтатуса);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОтгрузке(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К отгрузке"". Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""До відвантаження"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОтгрузкеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОтгрузкеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОтгрузке");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='К отгрузке';uk='До відвантаження'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытПолностьюОтработанныхЗаказов(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У полностью отработанных из выделенных в списке заказов будет установлен статус ""Закрыт"". Продолжить?';uk='У повністю відпрацьованих поміж виділених у списку замовлень буде встановлено статус ""Закритий"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытПолностьюОтработанныхЗаказовЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытПолностьюОтработанныхЗаказовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Закрыт", Новый Структура("КонтрольВыполненияЗаказа"));
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Закрыт';uk='Закритий'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрок(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Закрыт"". Все неотработанные строки будут отменены. Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""Закритий"". Всі невідпрацьовані рядки будуть скасовані. Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокПослеВопроса", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокПослеВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ПричинаОтменыЗаказовКлиентов = ПредопределенноеЗначение("Справочник.ПричиныОтменыЗаказовКлиентов.ПустаяСсылка");
    Если ИспользоватьПричиныОтменыЗаказовКлиентов Тогда
        ОткрытьФорму("Справочник.ПричиныОтменыЗаказовКлиентов.ФормаВыбора",
        Новый Структура("ТекущаяСтрока",ПричинаОтменыЗаказовКлиентов),,,,, Новый ОписаниеОповещения("УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
    КонецЕсли;
    
    УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокФрагмент(ВыделенныеСтроки);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    ПричинаОтменыЗаказовКлиентов = Результат;
    Если Не ЗначениеЗаполнено(ПричинаОтменыЗаказовКлиентов) Тогда
        Возврат;
    КонецЕсли;
    
    УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокФрагмент(ВыделенныеСтроки);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокФрагмент(Знач ВыделенныеСтроки)
    
    Перем КоличествоОбработанных;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Закрыт", Новый Структура("ОтменаНеотработанныхСтрок", ПричинаОтменыЗаказовКлиентов));
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Закрыт';uk='Закритий'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Документ.ЗаказКлиента.ФормаСпискаДокументов.Элемент.Список.Выбор");
	
	Если Поле.Имя = "СписокПроцентОтгрузки" Или Поле.Имя = "СписокСостояние" Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если Не ТекущиеДанные = Неопределено Тогда
			
			СтандартнаяОбработка = Ложь;
			СписокДокументов = Новый СписокЗначений;
			СписокДокументов.Добавить(ТекущиеДанные.Ссылка);
			
			ОткрытьФорму("Отчет.СостояниеВыполненияДокументов.Форма.ФормаОтчета", 
			             Новый Структура("ВходящиеДокументы", СписокДокументов), 
			             ЭтаФорма,
			             Ложь);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Условное оформление динамического списка "Список"
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// Документ имеет высокий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Документ имеет высокий приоритет';uk='Документ має високий пріоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьВысшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ВысокийПриоритетДокумента);
	
	// Документ имеет низкий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Документ имеет низкий приоритет';uk='Документ має низький пріоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьНизшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.НизкийПриоритетДокумента);
	
	// Выделение цветом состояния "Закрыт"
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Выделение цветом состояния ""Закрыт""';uk='Виділення кольором стану ""Закрито""'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияЗаказовКлиентов.Закрыт;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	// Выделение цветом просроченного заказа
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Выделение цветом просроченного заказа';uk='Виділення кольором простроченого замовлення'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("Состояние");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаСобытия");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Просрочен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныйДокумент);
	
	// Скрытие итогов по заказу при учете расчетов по договорам или накладным
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Скрытие итогов по заказу при учете расчетов по договорам или накладным';uk='Приховування підсумків по замовленню при обліку розрахунків по договорах або накладних'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДолгКлиента");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НашДолг");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентДолга");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаПросроченнойОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОтгрузки");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОтгрузки");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПорядокРасчетов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='—';uk='—'"));
	

	УсловноеОформление.Элементы.Очистить();
	
	// Изменение представления статуса, в зависимости от включенных опций.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Изменение представления статуса, в зависимости от включенных опций.';uk='Зміна представлення статусу, залежно від включених опцій.'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказовКлиентов.КОбеспечению;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='К выполнению';uk='До виконання'"));

	// Изменение представления статуса, в зависимости от включенных опций.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Изменение представления статуса, в зависимости от включенных опций.';uk='Зміна представлення статусу, залежно від включених опцій.'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказовКлиентов.КОбеспечению;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='В резерве';uk='В резерві'"));
	
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДата");


КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Знач Оповещение, Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Новый ОписаниеОповещения("ОбработатьШтрихкодыЗавершение", ЭтотОбъект, Новый Структура("Данные, Оповещение", Данные, Оповещение)), Ссылка);
        Возврат;
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
	ОбработатьШтрихкодыФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыЗавершение(ДополнительныеПараметры) Экспорт
    
    Данные = ДополнительныеПараметры.Данные;
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ОбработатьШтрихкодыФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыФрагмент(Знач Оповещение)
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораОтбораПоСостояниюСервер(СписокВыбора, ИспользоватьУпрощеннуюСхемуОплаты)
	
	СтандартнаяОбработка = Истина;
	Параметры = Новый Структура;
	
	СписокВыбора.Добавить("ВсеОткрытые", НСтр("ru='Все открытые';uk='Всі відкриті'"));
	СписокВыбора.Добавить("ВсеОжидающиеОплаты", НСтр("ru='Все ожидающие оплаты';uk='Всі, що очікують оплати'"));
	СписокВыбора.Добавить("ВсеОжидающиеИсполнения", НСтр("ru='Все ожидающие исполнения';uk='Всі, що очікують виконання'"));
	
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяСогласование);
	Если НЕ ИспользоватьУпрощеннуюСхемуОплаты Тогда
		СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяАвансДоОбеспечения);
	КонецЕсли;
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКОбеспечению);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяПредоплатаДоОтгрузки);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяОбеспечение);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКОтгрузке);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ВПроцессеОтгрузки);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяОплатаПослеОтгрузки);
	Если ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОплаты") 
		ИЛИ ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки") Тогда
		СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКЗакрытию);
	КонецЕсли;
	СписокВыбора.Добавить(Перечисления.СостоянияЗаказовКлиентов.Закрыт);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСостояниюСервер()
	
	Если Состояние = "ВсеОткрытые" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Перечисления.СостоянияЗаказовКлиентов.Закрыт, ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	ИначеЕсли Состояние = "ВсеОжидающиеОплаты" Тогда
		
		МассивСостояний = Новый Массив();
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяАвансДоОбеспечения);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяПредоплатаДоОтгрузки);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяОплатаПослеОтгрузки);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	ИначеЕсли Состояние = "ВсеОжидающиеИсполнения" Тогда
		
		МассивСостояний = Новый Массив();
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяСогласование);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКОбеспечению);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяОбеспечение);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКОтгрузке);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ВПроцессеОтгрузки);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаказовКлиентов.ГотовКЗакрытию);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления",,,, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ИспользоватьРасширенныеВозможностиЗаказаКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	
	Элементы.УстановитьСтатусКОтгрузке.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента")
													И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	
	Элементы.СписокСуммаОплаты.Видимость     = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентОплаты.Видимость   = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокСуммаОтгрузки.Видимость   = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентОтгрузки.Видимость = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокНашДолг.Видимость         = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокДолгКлиента.Видимость     = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентДолга.Видимость    = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокДатаСобытия.Видимость     = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокСостояние.Видимость       = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	
КонецПроцедуры
 
// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ЭДО

&НаКлиенте
Процедура ВыгрузкаПервичныхДокументовВЗвит1С(Команда)
	
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыгрузкиПервичныхДокументов("Рахунок");	
	
КонецПроцедуры

#КонецОбласти
