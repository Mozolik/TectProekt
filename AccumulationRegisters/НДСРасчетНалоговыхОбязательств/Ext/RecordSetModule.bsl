﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Ниже приведеный код, должен выполняться до проверки:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// т.к. существет проверка на доп. свойство ДляПроведения, и 
	// данный объект в РИБ при записи должен создавать запись р/с Задания.
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Расчеты.Регистратор                  КАК Регистратор,
	|	Расчеты.Период                       КАК Период,
	|	Расчеты.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ОбъектРасчетов               КАК ОбъектРасчетов,
	|	Расчеты.ВидПоставки                  КАК ВидПоставки,
	|	Расчеты.Валюта                       КАК Валюта,
	|	Расчеты.ДокументПоставки             КАК ДокументПоставки,
	|	Расчеты.МоментОпределенияБазыНДС     КАК МоментОпределенияБазыНДС,
	|
	|	Расчеты.СуммаПоставкиТребующаяРегистрацииНН        КАК СуммаПоставкиТребующаяРегистрацииНН,
	|	Расчеты.СуммаПоставкиНеТребующаяРегистрацииНН      КАК СуммаПоставкиНеТребующаяРегистрацииНН
	|ПОМЕСТИТЬ РасчетыИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.НДСРасчетНалоговыхОбязательств КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|	И Расчеты.СуммаПоставкиТребующаяРегистрацииНН <> 0
	|");
	
	Запрос.УстановитьПараметр("Регистратор",              Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// Не требуется, т.к. существет проверка на доп. свойство ДляПроведения,
	// а данный объект в РИБ при записи должен создавать запись р/с Задания.
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ)  КАК День,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов               КАК ОбъектРасчетов,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Регистратор                  КАК Регистратор,
	|		Расчеты.Период                       КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ОбъектРасчетов               КАК ОбъектРасчетов,
	|		Расчеты.ВидПоставки                  КАК ВидПоставки,
	|		Расчеты.Валюта                       КАК Валюта,
	|		Расчеты.ДокументПоставки             КАК ДокументПоставки,
	|		Расчеты.МоментОпределенияБазыНДС     КАК МоментОпределенияБазыНДС,
	|
	|		Расчеты.СуммаПоставкиТребующаяРегистрацииНН        КАК СуммаПоставкиТребующаяРегистрацииНН,
	|		Расчеты.СуммаПоставкиНеТребующаяРегистрацииНН      КАК СуммаПоставкиНеТребующаяРегистрацииНН
	|	ИЗ РасчетыИсходныеДвижения КАК Расчеты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Регистратор                  КАК Регистратор,
	|		Расчеты.Период                       КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ОбъектРасчетов               КАК ОбъектРасчетов,
	|		Расчеты.ВидПоставки                  КАК ВидПоставки,
	|		Расчеты.Валюта                       КАК Валюта,
	|		Расчеты.ДокументПоставки             КАК ДокументПоставки,
	|		Расчеты.МоментОпределенияБазыНДС     КАК МоментОпределенияБазыНДС,
	|
	|		-Расчеты.СуммаПоставкиТребующаяРегистрацииНН        КАК СуммаПоставкиТребующаяРегистрацииНН,
	|		-Расчеты.СуммаПоставкиНеТребующаяРегистрацииНН      КАК СуммаПоставкиНеТребующаяРегистрацииНН
	|	ИЗ РегистрНакопления.НДСРасчетНалоговыхОбязательств КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|		И Расчеты.СуммаПоставкиТребующаяРегистрацииНН <> 0
	|) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов,
	|	Таблица.ВидПоставки,
	|	Таблица.Валюта,
	|	Таблица.ДокументПоставки,
	|	Таблица.МоментОпределенияБазыНДС
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СуммаПоставкиТребующаяРегистрацииНН) <> 0
	|;
	|////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РасчетыИсходныеДвижения;
	|");
	
	Запрос.УстановитьПараметр("Регистратор",              Отбор.Регистратор.Значение);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;

	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		Выборка = МассивРезультатов[0].Выбрать();
		Пока Выборка.Следующий() Цикл
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКФормированиюИсходящихНалоговыхДокументов");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ЗаданияКФормированиюИсходящихНалоговыхДокументов.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
			НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКФормированиюИсходящихНалоговыхДокументов.Получить();
			НаборЗаписей.КодОтслеживаемогоРегистра = 2;
			НаборЗаписей.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
