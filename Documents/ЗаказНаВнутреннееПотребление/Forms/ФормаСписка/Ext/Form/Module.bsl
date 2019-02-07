﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	УстановитьВидимость();
	
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
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура УстановитьСтатусЗакрытПолностьюОтработанныхЗаказов(Команда)
	
	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У полностью отработанных из выделенных в списке заказов будет установлен статус ""Закрыт"". Продолжить?';uk='У повністю відпрацьованих поміж виділених у списку замовлень буде встановлено статус ""Закритий"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытПолностьюОтработанныхЗаказовЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытПолностьюОтработанныхЗаказовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "Закрыт", Новый Структура("КонтрольВыполненияЗаказа"));
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), "Закрыт");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрок(Команда)
	
	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Закрыт"". Все неотработанные строки будут отменены. Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""Закритий"". Всі невідпрацьовані рядки будуть скасовані. Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытСОтменойНеотработанныхСтрокЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "Закрыт", Новый Структура("ОтменаНеотработанныхСтрок"));
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), "Закрыт");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""До виконання"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), НСтр("ru='К выполнению';uk='До виконання'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?';uk='У виділених у списку замовлень буде встановлено статус ""До забезпечення"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОбеспечениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(), НСтр("ru='К обеспечению';uk='До забезпечення'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()

	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументЗаказНаВнутреннееПотребление.Ссылка,
		|	ДокументЗаказНаВнутреннееПотребление.ПометкаУдаления,
		|	ДокументЗаказНаВнутреннееПотребление.Номер,
		|	ДокументЗаказНаВнутреннееПотребление.Дата,
		|	ДокументЗаказНаВнутреннееПотребление.Проведен,
		|	ДокументЗаказНаВнутреннееПотребление.ЖелаемаяДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.Комментарий,
		|	ДокументЗаказНаВнутреннееПотребление.Организация,
		|	ДокументЗаказНаВнутреннееПотребление.Ответственный,
		|	ДокументЗаказНаВнутреннееПотребление.Подразделение,
		|	ДокументЗаказНаВнутреннееПотребление.Склад,
		|	ДокументЗаказНаВнутреннееПотребление.Статус,
		|	ДокументЗаказНаВнутреннееПотребление.МаксимальныйКодСтроки,
		|	ДокументЗаказНаВнутреннееПотребление.Сделка,
		|	ДокументЗаказНаВнутреннееПотребление.ХозяйственнаяОперация,
		|	ДокументЗаказНаВнутреннееПотребление.ДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.НеОтгружатьЧастями,
		|	ДокументЗаказНаВнутреннееПотребление.Назначение,
		|	ДокументЗаказНаВнутреннееПотребление.ДокументОснование,
		|	ДокументЗаказНаВнутреннееПотребление.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаВнутреннееПотребление.МоментВремени,
		|	ДокументЗаказНаВнутреннееПотребление.Товары,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаВнутреннееПотребление.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументЗаказНаВнутреннееПотребление
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаВнутреннееПотребление.Ссылка)";

	Иначе
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументЗаказНаВнутреннееПотребление.Ссылка,
		|	ДокументЗаказНаВнутреннееПотребление.ПометкаУдаления,
		|	ДокументЗаказНаВнутреннееПотребление.Номер,
		|	ДокументЗаказНаВнутреннееПотребление.Дата,
		|	ДокументЗаказНаВнутреннееПотребление.Проведен,
		|	ДокументЗаказНаВнутреннееПотребление.ЖелаемаяДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.Комментарий,
		|	ДокументЗаказНаВнутреннееПотребление.Организация,
		|	ДокументЗаказНаВнутреннееПотребление.Ответственный,
		|	ДокументЗаказНаВнутреннееПотребление.Подразделение,
		|	ДокументЗаказНаВнутреннееПотребление.Склад,
		|	ДокументЗаказНаВнутреннееПотребление.Статус,
		|	ДокументЗаказНаВнутреннееПотребление.МаксимальныйКодСтроки,
		|	ДокументЗаказНаВнутреннееПотребление.Сделка,
		|	ДокументЗаказНаВнутреннееПотребление.ХозяйственнаяОперация,
		|	ДокументЗаказНаВнутреннееПотребление.ДатаОтгрузки,
		|	ДокументЗаказНаВнутреннееПотребление.НеОтгружатьЧастями,
		|	ДокументЗаказНаВнутреннееПотребление.Назначение,
		|	ДокументЗаказНаВнутреннееПотребление.ДокументОснование,
		|	ДокументЗаказНаВнутреннееПотребление.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаВнутреннееПотребление.МоментВремени,
		|	ДокументЗаказНаВнутреннееПотребление.Товары
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументЗаказНаВнутреннееПотребление";
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ИспользоватьСтатусы = ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаВнутреннееПотребление);
	Элементы.ГруппаУстановитьСтатус.Видимость = ИспользоватьСтатусы;
	
	Если ИспользоватьСтатусы Тогда
		ИспользоватьСтатусЗакрыт = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузки");
		Элементы.УстановитьСтатусЗакрытПолностьюОтработанныхЗаказов.Видимость = ИспользоватьСтатусЗакрыт;
		Элементы.УстановитьСтатусЗакрытСОтменойНеотработанныхСтрок.Видимость = ИспользоватьСтатусЗакрыт;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		Элементы.ГруппаОтгрузка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Документ.ЗаказНаВнутреннееПотребление.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
