﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УстановитьУсловноеОформление();

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Элементы.Склад.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ЗаполнитьСписокХозяйственныхОпераций();
	
	// Установка отборов.
	УстановитьОтборПоСкладуСервер();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ВозвратТоваровОтКлиента));
	
	Элементы.ГруппаСоздать.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ВозвратТоваровОтКлиента);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

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
    
    Если ИмяСобытия = "Запись_ВозвратТоваровОтКлиента" Тогда
        
        Элементы.СписокРаспоряженияНаОформление.Обновить();
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер = Настройки.Получить("Менеджер");
	Склад    = Настройки.Получить("Склад");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	СписокРаспоряженияНаОформление.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	УстановитьОтборПоСкладуСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.СписокВозвратыТоваровОтКлиентов);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.СписокВозвратыТоваровОтКлиентов);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура СоздатьВозвратОтКомиссионера(Команда)
	
	СоздатьВозвратТоваровОтКлиента(0);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОтРозничногоПокупателя(Команда)
	
	СоздатьВозвратТоваровОтКлиента(1);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписокВозвратыТоваровОтКлиентов);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписокВозвратыТоваровОтКлиентов);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Условное оформление динамического списка "СписокРаспоряженияНаОформление"
	СписокУсловноеОформление = СписокРаспоряженияНаОформление.КомпоновщикНастроек.Настройки.УсловноеОформление;
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
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокВозвратыТоваровОтКлиентов", "СписокДата");
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокРаспоряженияНаОформление", "СписокРаспоряженияНаОформлениеДата");
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ВозвратТоваровОтКлиента.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Знач Оповещение, Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
			Элементы.СписокВозвратыТоваровОтКлиентов.ТекущаяСтрока = Ссылка;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ВозвратыТоваровОтКлиентов;
		Иначе
			Элементы.СписокРаспоряженияНаОформление.ТекущаяСтрока = Ссылка;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.РаспоряженияНаОформление;
		КонецЕсли;
		
		ПоказатьЗначение(Новый ОписаниеОповещения("ОбработатьШтрихкодыЗавершение", ЭтотОбъект, Новый Структура("Данные, Оповещение", Данные, Оповещение)), Ссылка);
        Возврат;
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыЗавершение(ДополнительныеПараметры) Экспорт
    
    Данные = ДополнительныеПараметры.Данные;
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьОтборПоСкладуСервер()
	
	СписокРаспоряженияНаОформление.Параметры.УстановитьЗначениеПараметра("Склад", Склад);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокХозяйственныхОпераций()
	
	СписокХозяйственныхОпераций.Очистить();
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратТоваровОтКлиента(ХозяйственнаяОперацияИндекс)

	ХозяйственнаяОперация = СписокХозяйственныхОпераций[ХозяйственнаяОперацияИндекс].Значение;

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ВозвратТоваровОтКлиента.ФормаОбъекта", СтруктураПараметры, Элементы.СписокВозвратыТоваровОтКлиентов);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
