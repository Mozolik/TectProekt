﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РаспоряженияНаПоступлениеКонтрагент", "Видимость", Ложь);
	КонецЕсли;
	ИспользоватьДоверенности = ПолучитьФункциональнуюОпцию("ИспользоватьДоверенностиНаПолучениеТМЦ");
	ИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
	ИспользоватьСчетаНаОплату = ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам");
	
	ИнициализироватьСписокРаспоряженийНаПоступление();
	
	ОписаниеОтборов = Новый Соответствие;
	ОписаниеОтборов.Вставить("Организация", Тип("СправочникСсылка.Организации"));
	ОписаниеОтборов.Вставить("Касса", Тип("СправочникСсылка.Кассы"));
	УправлениеДоступом.НастроитьОтборыДинамическогоСписка(ПриходныеКассовыеОрдера, ОписаниеОтборов);
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		РазрешенныеОрганизации = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка("Документ.ПриходныйКассовыйОрдер", Тип("СправочникСсылка.Организации"));
		РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("РазрешенныеЗначенияПоляОрганизация", РазрешенныеОрганизации);
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	УправлениеЭлементамиФормы();
	
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
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ПриходныеКассовыеОрдера", "Дата");
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "РаспоряженияНаПоступление", "РаспоряженияНаПоступлениеДата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// МеханизмВнешнегоОборудования
	Если ИспользоватьПодключаемоеОборудование // Проверка на включенную ФО "Использовать ВО"
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО
		ОписаниеОшибки = "";

		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");

		Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
			ТекстСообщения = НСтр("ru='При подключении оборудования произошла ошибка:
                                  |""%ОписаниеОшибки%"".'
                                  |;uk='При підключенні обладнання сталася помилка:
                                  |""%ОписаниеОшибки%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// МеханизмВнешнегоОборудования
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");

	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			//Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияПослеОбработки", ЭтотОбъект, Новый Структура("ИмяСобытия, Параметр", ИмяСобытия, Параметр)), Новый Структура("Штрихкод, Количество", Параметр[0], 1));
                Возврат;
			Иначе
				ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияЗавершение", ЭтотОбъект, Новый Структура("ИмяСобытия", ИмяСобытия)), Новый Структура("Штрихкод, Количество", Параметр[1][1], 1));
                Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	ОбработкаОповещенияФрагмент(ИмяСобытия);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияПослеОбработки(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    Параметр = ДополнительныеПараметры.Параметр;
    
    
    // Достаем штрихкод из основных данных;
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    
    
    // Достаем штрихкод из дополнительных данных;
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияФрагмент(Знач ИмяСобытия)
	
	Если ИмяСобытия = "Запись_ПриходныйКассовыйОрдер" Тогда
		ОбновитьДиначескиеСписки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация                 = Настройки.Получить("Организация");
	Касса                       = Настройки.Получить("Касса");
	
	СписокОпераций              = Настройки.Получить("СписокОперацийПоступления");
	ИнициализироватьСписокОперацийПоступления();
	Если СписокОпераций <> Неопределено Тогда
		Для каждого Операция Из СписокОпераций Цикл
			Если Операция.Пометка Тогда
				ОперацияСписка = СписокОперацийПоступления.НайтиПоЗначению(Операция.Значение);
				Если ОперацияСписка <> Неопределено Тогда
					ОперацияСписка.Пометка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ХозяйственнаяОперацияПредставление = СписокОперацийПоступленияПредставление(СписокОперацийПоступления);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	КассаОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияНаПоступлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Ссылка = Элементы.РаспоряженияНаПоступление.ТекущиеДанные.Ссылка;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПоказатьЗначение(Неопределено, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаКПоступлениюПриИзменении(Элемент)
	
	ДатаКПоступлениюПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДатаКПоступлениюПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		СписокОперацийПоступления = ВыбранноеЗначение;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		
		Для Каждого ЭлементСписка Из СписокОперацийПоступления Цикл
			ЭлементСписка.Пометка = (ЭлементСписка.Значение = ВыбранноеЗначение);
		КонецЦикла;
	КонецЕсли;
	
	ХозяйственнаяОперацияПредставление = СписокОперацийПоступленияПредставление(СписокОперацийПоступления);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
		Новый Структура("СписокОпераций, Заголовок, ВыводитьПредупреждение", СписокОперацийПоступления, НСтр("ru='Основания платежа';uk='Підстави платежу'"), Истина), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОчистка(Элемент, СтандартнаяОбработка)
	
	СписокОперацийПоступления.ЗаполнитьПометки(Ложь);
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПредставлениеОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПриходныеКассовыеОрдера,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПоставщика(Команда)

	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзКассыККМ(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзБанка(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюДенежныхСредствИзБанка(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзДругойКассы(Команда)

	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы"));

КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПодотчетника(Команда)

	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзДругойОрганизации(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтДругойОрганизации(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееПоступлениеДенежныхСредств(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВнутреннююПередачуДенежныхСредств(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПоКредитам(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПогашениеЗаймаКонтрагентом(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПогашениеЗаймаСотрудником(Команда)
	
	СоздатьПриходныйКассовыйОрдер(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПогашениеЗаймаСотрудником"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПриходныйКассовыйОрдерПоРаспоряжению(Команда)
	
	ТекущиеДанные = Элементы.РаспоряженияНаПоступление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Укажите распоряжение для формирования приходного ордера';uk='Вкажіть розпорядження для формування прибуткового ордера'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	СтруктураПараметры = Новый Структура;
	
	Если ТипЗнч(ТекущиеДанные.Ссылка) = 
		Тип("ДокументСсылка.ДоверенностьВыданная") Тогда
		СтруктураПараметры.Вставить("ДоверенностьВыданная", ТекущиеДанные.Ссылка);
		СтруктураПараметры.Вставить("Основание", ОснованиеДоверенности(ТекущиеДанные.Ссылка));
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		СтруктураПараметры.Вставить("Основание", ТекущиеДанные.Ссылка);
		
	Иначе
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Организация", ТекущиеДанные.Организация);
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ТекущиеДанные.ХозяйственнаяОперация);
		ДанныеЗаполнения.Вставить("Касса", ТекущиеДанные.Касса);
		ДанныеЗаполнения.Вставить("КассаОтправитель", ТекущиеДанные.Плательщик);
		ДанныеЗаполнения.Вставить("Контрагент", ТекущиеДанные.Контрагент);
		ДанныеЗаполнения.Вставить("БанковскийСчет", ТекущиеДанные.Плательщик);
		ДанныеЗаполнения.Вставить("КассаККМ", ТекущиеДанные.Плательщик);
		ДанныеЗаполнения.Вставить("ПодотчетноеЛицо", ТекущиеДанные.Плательщик);
		ДанныеЗаполнения.Вставить("ПринятоОт", Строка(ТекущиеДанные.Плательщик));
		
		Если ТекущиеДанные.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты") Тогда
			ДанныеЗаполнения.Вставить("СуммаКонвертации", ТекущиеДанные.СуммаКОплате);
			ДанныеЗаполнения.Вставить("ВалютаКонвертации", ТекущиеДанные.Валюта);
		Иначе
			ДанныеЗаполнения.Вставить("СуммаДокумента", ТекущиеДанные.СуммаКОплате);
		КонецЕсли;
		
		СтруктураПараметры.Вставить("Основание", ДанныеЗаполнения);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.РаспоряженияНаПоступление);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ПриходныеКассовыеОрдера);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура КассаОтборПриИзмененииНаСервере()
	
	Организация = Справочники.Кассы.ПолучитьРеквизитыКассы(Касса).Организация;
	УстановитьОтборДинамическихСписков();
	УправлениеЭлементамиФормы();

КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриходныйКассовыйОрдер.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетНаОплатуКлиенту.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Знач Оповещение, Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
			Элементы.ПриходныеКассовыеОрдера.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаПриходныеКассовыеОрдера;
		КонецЕсли;
		
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

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.КассаОтбор.Видимость = ИспользоватьНесколькоКасс;
	Элементы.ПриходныеКассовыеОрдераСоздатьПоступлениеДенежныхСредствИзДругойКассы.Видимость = 
		ИспользоватьНесколькоКасс;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Элементы.ПриходныеКассовыеОрдераСоздатьПогашениеЗаймаСотрудником.Видимость = Ложь;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") И Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаймыСотрудникам") Тогда
		Элементы.ПриходныеКассовыеОрдераСоздатьПогашениеЗаймаСотрудником.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ УТ

	Если ЗначениеЗаполнено(Организация) И (Организация <> Справочники.Организации.УправленческаяОрганизация) Тогда
		Элементы.ПриходныеКассовыеОрдераСоздатьКонвертацияВалюты.Видимость = Ложь;
	Иначе
		Элементы.ПриходныеКассовыеОрдераСоздатьКонвертацияВалюты.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьПриходныйКассовыйОрдер(ХозяйственнаяОперация)

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, Элементы.ПриходныеКассовыеОрдера);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ИнициализироватьСписокРаспоряженийНаПоступление()
	
	РаспоряженияНаПоступление.ТекстЗапроса = ДенежныеСредстваСервер.ТекстЗапросаЗаказыКПоступлению();
	
	Если РольДоступна("ЧтениеОстатковДенежныхСредствВКассеККМ")
		Или РольДоступна("ПолныеПрава") Тогда
		
		РаспоряженияНаПоступление.ТекстЗапроса = 
		
			РаспоряженияНаПоступление.ТекстЗапроса
			
			+ " ОБЪЕДИНИТЬ ВСЕ " + "
			
			|ВЫБРАТЬ
			|	НЕОПРЕДЕЛЕНО КАК Ссылка,
			|	НЕОПРЕДЕЛЕНО КАК Дата,
			|	НЕОПРЕДЕЛЕНО КАК Номер,
			|	ТИП(Документ.ВыемкаДенежныхСредствИзКассыККМ),
			|	ДенежныеСредства.КассаККМ.ВалютаДенежныхСредств,
			|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ),
			|	""Поступление из кассы ККМ"",
			|	ДенежныеСредства.КассаККМ,
			|	ДенежныеСредства.КассаККМ.Наименование,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО,
			|	ДенежныеСредства.Организация,
			|	НЕОПРЕДЕЛЕНО,
			|	0 КАК СуммаДокумента,
			|	НЕОПРЕДЕЛЕНО КАК ВалютаДокумента,
			|	НЕОПРЕДЕЛЕНО КАК БанковскийСчет,
			|	НЕОПРЕДЕЛЕНО КАК Касса,
			|	ДенежныеСредства.КПоступлениюВКассуОрганизацииОстаток КАК СуммаКОплате
			|	
			|ИЗ
			|	РегистрНакопления.ДенежныеСредстваВКассахККМ.Остатки КАК ДенежныеСредства
			|ГДЕ
			|	ДенежныеСредства.КПоступлениюВКассуОрганизацииОстаток > 0
			|	И &ВыводитьДенежныеСредстваВПути
			|{ГДЕ
			|	ДенежныеСредства.Организация В (&РазрешенныеЗначенияПоляОрганизация)
			|}
			|";
	КонецЕсли;
	
	Если Не ИспользоватьСчетаНаОплату Тогда
		РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("ВыводитьСчетаНаОплату", Ложь);
	КонецЕсли;
	Если Не ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("ВыводитьРаспоряженияНаПеремещение", Ложь);
	КонецЕсли;
	РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("ТипыПолучателейДенежныхСредствВПути", Тип("СправочникСсылка.Кассы"));
	
	ИнициализироватьСписокОперацийПоступления();
	
КонецПроцедуры

&НаСервере
Функция ОснованиеДоверенности(ДоверенностьСсылка)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоверенностьСсылка, "ДокументОснование");
КонецФункции

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", "", ?(СохранитьНеопределено, Неопределено, Организация));
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяКасса", "", ?(СохранитьНеопределено, Неопределено, Касса));
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(ПриходныеКассовыеОрдера);
	МассивСписков.Добавить(РаспоряженияНаПоступление);
	
	Возврат МассивСписков;

КонецФункции

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	СписокКасс = Новый СписокЗначений;
	СписокКасс.Добавить(Справочники.Кассы.ПустаяСсылка());
	Если ЗначениеЗаполнено(Касса) Тогда
		СписокКасс.Добавить(Касса);
	КонецЕсли;
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Касса",
			СписокКасс,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Касса));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Организация));
	КонецЦикла;
	
	Граница = Новый Граница(?(ЗначениеЗаполнено(ДатаКПоступлению), КонецДня(ДатаКПоступлению), ДатаКПоступлению), ВидГраницы.Включая);
	РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	
	Для каждого ЭлементСписка Из СписокОперацийПоступления Цикл
		РаспоряженияНаПоступление.Параметры.УстановитьЗначениеПараметра(ЭлементСписка.Значение, ЭлементСписка.Пометка);
	КонецЦикла;
	
	СохранитьРабочиеЗначенияПолейФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРаспоряженияНаПоступление Тогда
		Элементы.РаспоряженияНаПоступление.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписокОперацийПоступления()
	
	СписокОпераций = Новый СписокЗначений;
	СписокОпераций.Добавить("ВыводитьДокументыРасчетов", НСтр("ru='Документы расчетов';uk='Документи розрахунків'"));
	Если ИспользоватьСчетаНаОплату Тогда
		СписокОпераций.Добавить("ВыводитьСчетаНаОплату", НСтр("ru='Счета на оплату';uk='Рахунки на оплату'"));
	КонецЕсли;
	СписокОпераций.Добавить("ВыводитьВозвратыОтПоставщиков", НСтр("ru='Возвраты от поставщиков';uk='Повернення від постачальників'"));
	СписокОпераций.Добавить("ВыводитьВозвратыОтПодотчетников", НСтр("ru='Возвраты от подотчетников';uk='Повернення від підзвітних особ'"));
	Если ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		СписокОпераций.Добавить("ВыводитьРаспоряженияНаПеремещение", НСтр("ru='Распоряжения на перемещение';uk='Розпорядження на переміщення'"));
	КонецЕсли;
	СписокОпераций.Добавить("ВыводитьДенежныеСредстваВПути", НСтр("ru='Денежные средства в пути';uk='Грошові кошти в дорозі'"));
	
	СписокОперацийПоступления = СписокОпераций;
	
	Элементы.ХозяйственнаяОперацияПредставлениеОтбор.СписокВыбора.Очистить();
	Для каждого Операция Из СписокОперацийПоступления Цикл
		Элементы.ХозяйственнаяОперацияПредставлениеОтбор.СписокВыбора.Добавить(Операция.Значение, Операция.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокОперацийПоступленияПредставление(СписокОпераций)
	
	СписокОперацийПоступленияПредставление = "";
	Для Каждого ЭлементСписка Из СписокОпераций Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокОперацийПоступленияПредставление = СписокОперацийПоступленияПредставление +
				?(ЗначениеЗаполнено(СписокОперацийПоступленияПредставление), ", ", "") + ЭлементСписка.Представление;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокОперацийПоступленияПредставление;
	
КонецФункции

#КонецОбласти

#КонецОбласти
