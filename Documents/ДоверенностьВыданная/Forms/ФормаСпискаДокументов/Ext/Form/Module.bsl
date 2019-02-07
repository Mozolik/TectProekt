﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДоступностьРаспоряженийТовары", ДоступностьРаспоряженийТовары) Тогда
		ДоступностьРаспоряженийТовары = ПолучитьФункциональнуюОпцию("ИспользоватьДоверенностиНаПолучениеТМЦ")
			И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыПоставщикам)
			И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаявкиНаВозвратТоваровОтКлиентов);
	КонецЕсли;
	Если НЕ Параметры.Свойство("ЗаголовокФормы", Заголовок) Тогда
		Заголовок = НСтр("ru='Доверенности';uk='Довіреності'");
	КонецЕсли;
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	СписокДоверенности.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДата()));
	ТекстНетПоступленияТоваров = НСтр("ru='Нет поступления товаров (МЦ)';uk='Немає надходження товарів (МЦ)'");
	ТекстЕстьПоступленияТоваров = НСтр("ru='Есть поступления товаров (МЦ)';uk='Є надходження товарів (МЦ)'");
	ТекстПолноеПоступлениеДС = НСтр("ru='ДС поступили полностью';uk='Грошові кошти надійшли повністю'");
	СписокДоверенности.Параметры.УстановитьЗначениеПараметра("ТекстНетПоступленияТоваров",
		ТекстНетПоступленияТоваров);
	СписокДоверенности.Параметры.УстановитьЗначениеПараметра("ТекстЕстьПоступленияТоваров",
		ТекстЕстьПоступленияТоваров);
	Элементы.ОтборИсполнение.СписокВыбора.Очистить();
	Элементы.ОтборИсполнение.СписокВыбора.Добавить("", НСтр("ru='Все';uk='Всі'"));
	Элементы.ОтборИсполнение.СписокВыбора.Добавить(ТекстНетПоступленияТоваров, ТекстНетПоступленияТоваров);
	Элементы.ОтборИсполнение.СписокВыбора.Добавить(ТекстЕстьПоступленияТоваров, ТекстЕстьПоступленияТоваров);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Параметры.Свойство("НаличиеДоверенности", НаличиеДоверенности);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
			"ПометкаУдаления", Ложь,,, Истина);
	КонецЕсли;
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокВыполнения.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокДоверенности,
		"Состояние", Состояние, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокДоверенности,
		"Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокДоверенности,
		"ФизЛицо", ФизЛицо, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(СписокДоверенности,
		Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокРаспоряженияНаОформление,
		"ЕстьДоверенность", Ложь, СтруктураБыстрогоОтбора, НаличиеДоверенности);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
		"ОплатыПриходыФильтр", ПолнотаИсполнения, ВидСравненияКомпоновкиДанных.Равно,,
		НЕ ПолнотаИсполнения ="");
	УстановитьТекущуюСтраницу();
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(Элементы.Ответственный.СписокВыбора,
		ПолучитьСписокВыбораОтбораПоОтветственномуСервер());
	СтатусДоступен = ПраваПользователяПовтИсп.ЗаписьВыданнойДоверенностиВОкончательномСтатусе();
	Элементы.ГруппаУстановитьСтатус.Видимость = СтатусДоступен;
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
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
	
	Если ИмяСобытия = "Запись_ЗаказПоставщику" Или ИмяСобытия = "Запись_ДоверенностьНаПолучениеТоваров" Тогда
		Элементы.СписокДоверенности.Обновить();
		Элементы.СписокРаспоряженияНаОформление.Обновить();
	КонецЕсли;
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Настройки.Удалить("СостояниеРаспоряжения");
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		НаличиеДоверенности = Настройки.Получить("НаличиеДоверенности");
	Иначе
		Настройки.Удалить("НаличиеДоверенности");
	КонецЕсли;
	Если СтруктураБыстрогоОтбора = Неопределено ИЛИ Не СтруктураБыстрогоОтбора.Свойство("Ответственный") Тогда
		ЗначениеИзНастройки = Настройки.Получить("Ответственный");
		Если ЗначениеЗаполнено(ЗначениеИзНастройки) Тогда
			Ответственный = ЗначениеИзНастройки;
		КонецЕсли;
	КонецЕсли;
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(СписокДоверенности,
		Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокДоверенности,
		"Ответственный", Ответственный, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокДоверенности,
		"ФизЛицо", ФизЛицо, СтруктураБыстрогоОтбора, Настройки);
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние,
		СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
			"Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Состояние) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
			"ПометкаУдаления",,,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
			"ПометкаУдаления", Ложь,,, Истина);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРаспоряженияНаОформление,
		"ЕстьДоверенность" ,Ложь, ВидСравненияКомпоновкиДанных.Равно,, НаличиеДоверенности);
	Если НЕ ЗначениеЗаполнено(ПолнотаИсполнения) Тогда
		ПолнотаИсполнения = Настройки.Получить("ПолнотаИсполнения");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
		"ОплатыПриходыФильтр", ПолнотаИсполнения, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПолнотаИсполнения));
	Иначе
		Настройки.Удалить("ПолнотаИсполнения");
	КонецЕсли;
	УстановитьВидимостьДоступностьКолонокРаспоряжений();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности, "ФизЛицо", ФизЛицо, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ФизЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Состояние) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности, "ПометкаУдаления",,,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности, "ПометкаУдаления", Ложь,,, Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияПриИзменении(Элемент)

	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(СписокДоверенности, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		СписокДоверенности, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(СписокДоверенности, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаличиеДоверенностиПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРаспоряженияНаОформление,
		"ЕстьДоверенность", Ложь, ВидСравненияКомпоновкиДанных.Равно,, НаличиеДоверенности);
КонецПроцедуры











#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписокДоверенности

&НаКлиенте
Процедура СписокДоверенностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокДоверенности.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФорму("Документ.ДоверенностьВыданная.ФормаОбъекта", Новый Структура("Ключ", ТекущиеДанные.Ссылка), ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.СписокДоверенности);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.СписокДоверенности);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура УстановитьСтатусВыдана(Команда)
	
	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.СписокДоверенности);
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекстВопроса = НСтр("ru='У выделенных в списке доверенностей будет установлен статус ""Выдана"". Продолжить?';uk='У виділених у списку довіреностей буде встановлено статус ""Видана"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусВыданаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусВыданаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "Выдана");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.СписокДоверенности, КоличествоОбработанных,
    ВыделенныеСсылки.Количество(), НСтр("ru='Выдана';uk='Видано'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусИспользована(Команда)
	
	ВыделенныеСсылки =РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.СписокДоверенности);
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекстВопроса = НСтр("ru='У выделенных в списке доверенностей будет установлен статус ""Использована"". Продолжить?';uk='У виділених у списку довіреностей буде встановлено статус ""Використана"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусИспользованаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусИспользованаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
    Элементы.СписокДоверенности.ВыделенныеСтроки, "Использована");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.СписокДоверенности, КоличествоОбработанных,
    ВыделенныеСсылки.Количество(), НСтр("ru='Использована';uk='Використана'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеИспользована(Команда)
	
	ВыделенныеСсылки =РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.СписокДоверенности);
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекстВопроса =
		НСтр("ru='У выделенных в списке доверенностей будет установлен статус ""Не использована"". Продолжить?';uk='У виділених у списку довіреностей буде встановлено статус ""Не використана"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеИспользованаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеИспользованаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
    Элементы.СписокДоверенности.ВыделенныеСтроки, "НеИспользована");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.СписокДоверенности, КоличествоОбработанных,
    ВыделенныеСсылки.Количество(), НСтр("ru='Не использована';uk='Не використана'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусАннулирована(Команда)
	
	ВыделенныеСсылки =РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.СписокДоверенности);
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекстВопроса = НСтр("ru='У выделенных в списке доверенностей будет установлен статус ""Аннулирована"". Продолжить?';uk='У виділених у списку довіреностей буде встановлено статус ""Анульована"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусАннулированаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусАннулированаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
    Элементы.СписокДоверенности.ВыделенныеСтроки, "Аннулирована");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.СписокДоверенности, КоличествоОбработанных,
    ВыделенныеСсылки.Количество(), НСтр("ru='Аннулирована';uk='Анульовано'"));

КонецПроцедуры

&НаКлиенте
Процедура СоздатьДоверенностьНаПолучениеТоваров(Команда)
	
	Если Элементы.СписокРаспоряженияНаОформление.ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Укажите распоряжение для формирования доверенности';uk='Вкажіть розпорядження для формування довіреності'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ОткрытьФорму("Документ.ДоверенностьВыданная.Форма.ФормаДокумента",
				Новый Структура("Основание", 
					Новый Структура("ДокументОснование",
								Элементы.СписокРаспоряженияНаОформление.ТекущиеДанные.Ссылка)));
КонецПроцедуры


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписокДоверенности);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда,
		ЭтаФорма, Элементы.СписокДоверенности);
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
	
	ТекстЗапроса = ТекстЗапросаРаспоряженийНаТовары();
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		СписокРаспоряженияНаОформление.ТекстЗапроса = ТекстЗапроса;
		СписокРаспоряженияНаОформление.Параметры.УстановитьЗначениеПараметра("ИспользоватьРасширенныеВозможностиЗаказаКлиента",
			ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	Иначе
		ДоступностьРаспоряженийДС = Ложь;
	КонецЕсли;
	
	Элементы.СтраницаРаспоряженияНаОформление.Видимость = ДоступностьРаспоряженийТовары;
	Если НЕ ДоступностьРаспоряженийТовары Тогда
		Возврат;
	КонецЕсли;
	
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
	
	// По документу оформлена доверенность
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru='Есть доверенность';uk='Є довіреність'");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьДоверенность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокРаспоряженияНаОформление", "СписокРаспоряженияНаОформлениеДата");
КонецПроцедуры


#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ДоверенностьВыданная.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			Элементы.СписокРаспоряженияНаОформление.ТекущаяСтрока = Ссылка;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаРаспоряженияНаОформление;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ДоверенностьВыданная") Тогда
			Элементы.СписокДоверенности.ТекущаяСтрока = Ссылка;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаДоверенностиНаПолучениеТоваров;
		КонецЕсли;
		ПоказатьЗначение(Неопределено, Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораОтбораПоОтветственномуСервер()
	
	Возврат ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ДоверенностьВыданная);
	
КонецФункции

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	Если Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы) Тогда
		Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
			ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
		КонецЕсли;
	КонецЕсли;
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДоверенности", "СписокДата");
КонецПроцедуры

&НаКлиенте
Процедура ОтборИсполнениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДоверенности,
		"ОплатыПриходыФильтр", ПолнотаИсполнения, ВидСравненияКомпоновкиДанных.Равно,,
		НЕ ПолнотаИсполнения ="");
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ТекстЗапросаРаспоряженийНаТовары()
	
	Возврат
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПлановоеПоступление.Распоряжение.Ссылка КАК Ссылка,
	|	ПлановоеПоступление.Распоряжение.ПометкаУдаления КАК ПометкаУдаления,
	|	ТИПЗНАЧЕНИЯ(ПлановоеПоступление.Распоряжение) КАК ТипРаспоряжения,
	|	ПлановоеПоступление.Распоряжение.Дата КАК Дата,
	|	ПлановоеПоступление.Распоряжение.Номер КАК Номер,
	|	ПлановоеПоступление.Распоряжение.Партнер КАК Партнер,
	|	ПлановоеПоступление.Распоряжение.Контрагент КАК Контрагент,
	|	ПлановоеПоступление.Распоряжение.Организация КАК Организация,
	|	ПлановоеПоступление.Распоряжение.Склад КАК Склад,
	|	ПлановоеПоступление.Распоряжение.Валюта КАК Валюта,
	|	ПлановоеПоступление.Распоряжение.Менеджер КАК Менеджер,
	|	ПлановоеПоступление.Распоряжение.СуммаДокумента КАК СуммаДокумента,
	|	ЗНАЧЕНИЕ(Справочник.Приоритеты.ПустаяСсылка) КАК Приоритет,
	|	ПлановоеПоступление.Распоряжение.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ПРЕДСТАВЛЕНИЕ(ПлановоеПоступление.Распоряжение.ХозяйственнаяОперация) КАК ХозяйственнаяОперацияПредставление,
	|	ПлановоеПоступление.Распоряжение.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА Доверенности.ЕстьДоверенность ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьДоверенность,
	|	1 КАК КартинкаПриоритета
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыПоставщикам.ЗаказПоставщику КАК Распоряжение
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки КАК ЗаказыПоставщикам
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗаказыПоставщикам.ЗаказПоставщику
	|	
	|	ИМЕЮЩИЕ
	|		СУММА(ЗаказыПоставщикам.КОформлениюОстаток) > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаявкиНаВозврат.ЗаявкаНаВозвратТоваровОтКлиента
	|	ИЗ
	|		РегистрНакопления.ЗаявкиНаВозвратТоваровОтКлиентов.Остатки КАК ЗаявкиНаВозврат
	|	ГДЕ
	|		&ИспользоватьРасширенныеВозможностиЗаказаКлиента
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗаявкиНаВозврат.ЗаявкаНаВозвратТоваровОтКлиента
	|	
	|	ИМЕЮЩИЕ
	|		СУММА(ЗаявкиНаВозврат.КОформлениюОстаток) > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаявкиНаВозврат.Ссылка
	|	ИЗ
	|		Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкиНаВозврат
	|	ГДЕ
	|		НЕ &ИспользоватьРасширенныеВозможностиЗаказаКлиента
	|		И ЗаявкиНаВозврат.Проведен) КАК ПлановоеПоступление
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МИНИМУМ(Доверенности.Ссылка) КАК ЕстьДоверенность,
	|			Доверенности.ДокументОснование КАК ДокументОснование
	|		ИЗ
	|			Документ.ДоверенностьВыданная КАК Доверенности
	|		ГДЕ
	|			НЕ Доверенности.ПометкаУдаления
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Доверенности.ДокументОснование) КАК Доверенности
	|		ПО ПлановоеПоступление.Распоряжение = Доверенности.ДокументОснование
	|ГДЕ
	|	НЕ ПлановоеПоступление.Распоряжение.Ссылка ЕСТЬ NULL 
	|	И (ТИПЗНАЧЕНИЯ(ПлановоеПоступление.Распоряжение) = ТИП(Документ.ЗаказПоставщику)
	//++ НЕ УТ
	|			ИЛИ ТИПЗНАЧЕНИЯ(ПлановоеПоступление.Распоряжение) = ТИП(Документ.ЗаказПереработчику)
	//-- НЕ УТ
	//++ НЕ УТКА
	|			ИЛИ ТИПЗНАЧЕНИЯ(ПлановоеПоступление.Распоряжение) = ТИП(Документ.ЗаказДавальца)
	//-- НЕ УТКА
	|			ИЛИ ТИПЗНАЧЕНИЯ(ПлановоеПоступление.Распоряжение) = ТИП(Документ.ЗаявкаНаВозвратТоваровОтКлиента))";
	
КонецФункции


&НаСервере
Процедура УстановитьВидимостьДоступностьКолонокРаспоряжений()
	
	НесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	НесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	ПартнерыКакКонтрагенты = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	Элементы.СписокРаспоряженияНаОформлениеКонтрагент.Видимость = 
		Элементы.СписокРаспоряженияНаОформлениеКонтрагент.Видимость И НЕ ПартнерыКакКонтрагенты;
		
	Элементы.СписокРаспоряженияНаОформлениеОрганизация.Видимость = 
		Элементы.СписокРаспоряженияНаОформлениеОрганизация.Видимость И НесколькоОрганизаций;
		
	Элементы.СписокРаспоряженияНаОформлениеСклад.Видимость = 
		Элементы.СписокРаспоряженияНаОформлениеСклад.Видимость И НесколькоСкладов;
		
КонецПроцедуры

#КонецОбласти
