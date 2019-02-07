﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
    
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда 
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
    КонецЕсли;
    
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(НалоговыеНазначенияОС.Период, МЕСЯЦ) КАК Период,
	|	НалоговыеНазначенияОС.Регистратор                  КАК Регистратор,
    |	НалоговыеНазначенияОС.ОсновноеСредство             КАК ОсновноеСредство,
	|	НалоговыеНазначенияОС.Организация                  КАК Организация,
	|	НалоговыеНазначенияОС.НалоговоеНазначение          КАК НалоговоеНазначение
	|ПОМЕСТИТЬ НалоговыеНазначенияОСПередЗаписью
	|ИЗ
	|	РегистрСведений.НалоговыеНазначенияОС КАК НалоговыеНазначенияОС
	|ГДЕ
	|	НалоговыеНазначенияОС.Регистратор = &Регистратор
	|";
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
    
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
    
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(НалоговыеНазначенияОС.Период, МЕСЯЦ) КАК Период,
	|	НалоговыеНазначенияОС.Регистратор                  КАК Регистратор,
    |	НалоговыеНазначенияОС.ОсновноеСредство             КАК ОсновноеСредство,
	|	НалоговыеНазначенияОС.Организация                  КАК Организация,
	|	НалоговыеНазначенияОС.НалоговоеНазначение          КАК НалоговоеНазначение
	|ПОМЕСТИТЬ НалоговыеНазначенияОСПриЗаписи
	|ИЗ
	|	РегистрСведений.НалоговыеНазначенияОС КАК НалоговыеНазначенияОС
	|ГДЕ
	|	НалоговыеНазначенияОС.Регистратор = &Регистратор
    |;
	|ВЫБРАТЬ
	|	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.Период, НалоговыеНазначенияОСПриЗаписи.Период)                           КАК Период,
    |	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.Регистратор, НалоговыеНазначенияОСПриЗаписи.Регистратор)                 КАК Регистратор,
    |	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.ОсновноеСредство, НалоговыеНазначенияОСПриЗаписи.ОсновноеСредство)       КАК ОсновноеСредство,
    |	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.Организация, НалоговыеНазначенияОСПриЗаписи.Организация)                 КАК Организация,
    |	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.НалоговоеНазначение, НалоговыеНазначенияОСПриЗаписи.НалоговоеНазначение) КАК НалоговоеНазначение
	|ПОМЕСТИТЬ НалоговыеНазначенияИзмененныеДвижения
	|ИЗ
	|	НалоговыеНазначенияОСПередЗаписью КАК НалоговыеНазначенияОСПередЗаписью
	|		ПОЛНОЕ СОЕДИНЕНИЕ НалоговыеНазначенияОСПриЗаписи КАК НалоговыеНазначенияОСПриЗаписи
	|		ПО  НалоговыеНазначенияОСПередЗаписью.Период                = НалоговыеНазначенияОСПриЗаписи.Период
	|			И НалоговыеНазначенияОСПередЗаписью.ОсновноеСредство    = НалоговыеНазначенияОСПриЗаписи.ОсновноеСредство
	|			И НалоговыеНазначенияОСПередЗаписью.Организация         = НалоговыеНазначенияОСПриЗаписи.Организация
	|			И НалоговыеНазначенияОСПередЗаписью.НалоговоеНазначение = НалоговыеНазначенияОСПриЗаписи.НалоговоеНазначение
	|ГДЕ
	|	ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.Период, ДАТАВРЕМЯ(1, 1, 1)) <> ЕСТЬNULL(НалоговыеНазначенияОСПриЗаписи.Период, ДАТАВРЕМЯ(1, 1, 1))
	|	ИЛИ ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.ОсновноеСредство, ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка)) <> ЕСТЬNULL(НалоговыеНазначенияОСПриЗаписи.ОсновноеСредство, ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка))
	|	ИЛИ ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) <> ЕСТЬNULL(НалоговыеНазначенияОСПриЗаписи.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|	ИЛИ ЕСТЬNULL(НалоговыеНазначенияОСПередЗаписью.НалоговоеНазначение, ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка)) <> ЕСТЬNULL(НалоговыеНазначенияОСПриЗаписи.НалоговоеНазначение, ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка))
    |
	|;
    |
	|ВЫБРАТЬ
	|	НалоговыеНазначенияИзмененныеДвижения.Период          КАК Месяц,
	|	НалоговыеНазначенияИзмененныеДвижения.Регистратор     КАК Документ,
	|	НалоговыеНазначенияИзмененныеДвижения.Организация     КАК Организация
	|ИЗ
    |   НалоговыеНазначенияИзмененныеДвижения КАК НалоговыеНазначенияИзмененныеДвижения
	|
	|СГРУППИРОВАТЬ ПО
	|	НалоговыеНазначенияИзмененныеДвижения.Период,
	|	НалоговыеНазначенияИзмененныеДвижения.Регистратор,
	|	НалоговыеНазначенияИзмененныеДвижения.Организация
    |
	|";
    
    Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКЗакрытиюМесяца");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
		НаборЗаписей.Операция = Перечисления.ОперацииЗакрытияМесяца.КорректировкаНалоговогоНазначенияКапитальныхИнвестиций;
		НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКЗакрытиюМесяца.Получить();
		НаборЗаписей.Записать();
		
	КонецЦикла;
    
КонецПроцедуры

#КонецЕсли