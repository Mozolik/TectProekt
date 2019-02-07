﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.РасчетныйДокумент
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Регистратор = &Регистратор
	|	И ДанныеРегистра.РасчетныйДокумент <> &Регистратор
	|	И ДанныеРегистра.Предоплата <> 0
	|	И &ЭтоРежимЗаписи
	|	И &ЭтоОтменаПроведения
	|;
	|/////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расчеты.Регистратор               КАК Регистратор,
	|	Расчеты.Период                    КАК Период,
	|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента              КАК ЗаказКлиента,
	|	Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|	Расчеты.Валюта                    КАК Валюта,
	|
	|	Расчеты.Долг             КАК Долг,
	|	Расчеты.ДолгУпр          КАК ДолгУпр,
	|	Расчеты.ДолгРегл         КАК ДолгРегл,
	|	Расчеты.Предоплата       КАК Предоплата,
	|	Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|	Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|	Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|	Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|	Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ РасчетыСКлиентамиПоДокументамИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|	И ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|");
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоРежимЗаписи", ДополнительныеСвойства.Свойство("РежимЗаписи"));
	Запрос.УстановитьПараметр("ЭтоОтменаПроведения", ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Массив = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Массив.Добавить(Выборка.РасчетныйДокумент);
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ДокументыАванса", Массив);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказКлиента                 КАК ОбъектРасчетов,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Регистратор               КАК Регистратор,
	|		Расчеты.Период                    КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказКлиента              КАК ЗаказКлиента,
	|		Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|		Расчеты.Валюта                    КАК Валюта,
	|
	|		Расчеты.Долг             КАК Долг,
	|		Расчеты.ДолгУпр          КАК ДолгУпр,
	|		Расчеты.ДолгРегл         КАК ДолгРегл,
	|		Расчеты.Предоплата       КАК Предоплата,
	|		Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|		Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|		Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|		Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РасчетыСКлиентамиПоДокументамИсходныеДвижения КАК Расчеты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Регистратор               КАК Регистратор,
	|		Расчеты.Период                    КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказКлиента              КАК ЗаказКлиента,
	|		Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|		Расчеты.Валюта                    КАК Валюта,
	|
	|		-Расчеты.Долг             КАК Долг,
	|		-Расчеты.ДолгУпр          КАК ДолгУпр,
	|		-Расчеты.ДолгРегл         КАК ДолгРегл,
	|		-Расчеты.Предоплата       КАК Предоплата,
	|		-Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|		-Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|		-Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|		-Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказКлиента,
	|	Таблица.РасчетныйДокумент,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Долг) <> 0 ИЛИ СУММА(Таблица.ДолгУпр) <> 0 ИЛИ СУММА(Таблица.ДолгРегл) <> 0
	|	ИЛИ СУММА(Таблица.Предоплата) <> 0 ИЛИ СУММА(Таблица.ПредоплатаУпр) <> 0 ИЛИ СУММА(Таблица.ПредоплатаРегл) <> 0
	|	ИЛИ СУММА(Таблица.ЗалогЗаТару) <> 0 ИЛИ СУММА(Таблица.ЗалогЗаТаруРегл) <> 0
	|;
	|////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РасчетыСКлиентамиПоДокументамИсходныеДвижения
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКРаспределениюРасчетовСКлиентами");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();

			НаборЗаписей = РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
			НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКРаспределениюРасчетовСКлиентами.Получить();
			НаборЗаписей.Записать();
		КонецЦикла;
		Если Константы.АктуализироватьВзаморасчетыПриПроведенииДокументов.Получить() Тогда
			РаспределениеВзаиморасчетов.РаспределитьРасчетыФоновымЗаданием(,,"РасчетыСКлиентами");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецЕсли