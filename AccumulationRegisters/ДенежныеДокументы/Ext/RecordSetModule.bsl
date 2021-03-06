﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Период				КАК Период,
	|	Таблица.Организация			КАК Организация,
	|	Таблица.Подразделение		КАК Подразделение,
	|	Таблица.МОЛ					КАК МОЛ,
	|	Таблица.ДенежныйДокумент	КАК ДенежныйДокумент,
	|	(ВЫБОР Таблица.ВидДвижения КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА -Таблица.Количество
	|		ИНАЧЕ Таблица.Количество КОНЕЦ) КАК КоличествоПередЗаписью,
	|	(ВЫБОР Таблица.ВидДвижения КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА -Таблица.Сумма
	|		ИНАЧЕ Таблица.Сумма КОНЕЦ) КАК СуммаПередЗаписью
	|ПОМЕСТИТЬ
	|	ДвиженияДенежныеДокументыПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДенежныеДокументы КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|	И НЕ &ЭтоОбменДанными
	|	И &РассчитыватьИзменения
	|;
	|///////////////////////////////////////////
	|ВЫБРАТЬ
	|	Записи.Период                     КАК Период,
	|	Записи.Регистратор                КАК Регистратор,
	|	Записи.Организация                КАК Организация,
	|	Записи.Подразделение              КАК Подразделение,
	|	Записи.МОЛ                        КАК МОЛ,
	|	Записи.ДенежныйДокумент           КАК ДенежныйДокумент,
	|
	|	Записи.Количество   КАК Количество,
	|	Записи.Сумма        КАК Сумма,
	|	Записи.СуммаУпр     КАК СуммаУпр,
	|	Записи.СуммаРегл    КАК СуммаРегл,
	|
	|	Записи.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ПОМЕСТИТЬ ПереоценкаДенежныеДокументыПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДенежныеДокументы КАК Записи
	|ГДЕ
	|	Записи.Регистратор = &Регистратор
	|	И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|		ИЛИ Записи.ДенежныйДокумент.Валюта <> &ВалютаУпр
	|		ИЛИ Записи.ДенежныйДокумент.Валюта <> &ВалютаРегл
	|	)
	|");
	Запрос.УстановитьПараметр("Регистратор",	Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",		ДополнительныеСвойства.ЭтоНовый);
	Запрос.УстановитьПараметр("ЭтоОбменДанными", ОбменДанными.Загрузка);
	Запрос.УстановитьПараметр("РассчитыватьИзменения", ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства));
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаИзменений.ПериодПередЗаписью) КАК ПериодПередЗаписью,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.МОЛ,
	|	ТаблицаИзменений.ДенежныйДокумент,
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ТаблицаИзменений.СуммаИзменение) КАК СуммаИзменение
	|ПОМЕСТИТЬ
	|	ДвиженияДенежныеДокументыИзменение
	|ИЗ (
	|	ВЫБРАТЬ
	|		Таблица.Период КАК ПериодПередЗаписью,
	|		NULL КАК ПериодПриЗаписи,
	|		Таблица.Организация,
	|		Таблица.Подразделение,
	|		Таблица.МОЛ,
	|		Таблица.ДенежныйДокумент,
	|		Таблица.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		Таблица.СуммаПередЗаписью КАК СуммаИзменение
	|	ИЗ
	|		ДвиженияДенежныеДокументыПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	ВЫБРАТЬ
	|		NULL КАК ПериодПередЗаписью,
	|		Таблица.Период КАК ПериодПриЗаписи,
	|		Таблица.Организация,
	|		Таблица.Подразделение,
	|		Таблица.МОЛ,
	|		Таблица.ДенежныйДокумент,
	|		(ВЫБОР Таблица.ВидДвижения КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА Таблица.Количество
	|			ИНАЧЕ -Таблица.Количество КОНЕЦ) КАК КоличествоИзменение,
	|		(ВЫБОР Таблица.ВидДвижения КОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА Таблица.Сумма
	|			ИНАЧЕ -Таблица.Сумма КОНЕЦ) КАК СуммаИзменение
	|	ИЗ
	|		РегистрНакопления.ДенежныеДокументы КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И НЕ &ЭтоОбменДанными
	|		И &РассчитыватьИзменения
	|) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.МОЛ,
	|	ТаблицаИзменений.ДенежныйДокумент
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.СуммаИзменение) <> 0
	|	ИЛИ МИНИМУМ(ТаблицаИзменений.ПериодПередЗаписью) < МАКСИМУМ(ТаблицаИзменений.ПериодПриЗаписи)
	|;
	|//////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияДенежныеДокументыПередЗаписью
	|;
	|//////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	&Операция                            КАК Операция,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.Подразделение              КАК Подразделение,
	|		Записи.МОЛ                        КАК МОЛ,
	|		Записи.ДенежныйДокумент           КАК ДенежныйДокумент,
	|
	|		Записи.Количество   КАК Количество,
	|		Записи.Сумма        КАК Сумма,
	|		Записи.СуммаУпр     КАК СуммаУпр,
	|		Записи.СуммаРегл    КАК СуммаРегл,
	|
	|		Записи.ХозяйственнаяОперация      КАК ХозяйственнаяОперация
	|	ИЗ
	|		ПереоценкаДенежныеДокументыПередЗаписью КАК Записи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.Подразделение              КАК Подразделение,
	|		Записи.МОЛ                        КАК МОЛ,
	|		Записи.ДенежныйДокумент           КАК ДенежныйДокумент,
	|
	|		-Записи.Количество   КАК Количество,
	|		-Записи.Сумма        КАК Сумма,
	|		-Записи.СуммаУпр     КАК СуммаУпр,
	|		-Записи.СуммаРегл    КАК СуммаРегл,
	|
	|		Записи.ХозяйственнаяОперация      КАК ХозяйственнаяОперация
	|	ИЗ
	|		РегистрНакопления.ДенежныеДокументы КАК Записи
	|	ГДЕ
	|		Записи.Регистратор = &Регистратор
	|	И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|		ИЛИ Записи.ДенежныйДокумент.Валюта <> &ВалютаУпр
	|		ИЛИ Записи.ДенежныйДокумент.Валюта <> &ВалютаРегл)
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|	Таблица.МОЛ,
	|	Таблица.ДенежныйДокумент,
	|	Таблица.ХозяйственнаяОперация
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	ИЛИ СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоОбменДанными", ОбменДанными.Загрузка);
	Запрос.УстановитьПараметр("РассчитыватьИзменения", ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства));
	Запрос.УстановитьПараметр("Операция", Перечисления.ОперацииЗакрытияМесяца.ПереоценкаВалютныхСредств);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[0].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу.
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияДенежныеДокументыИзменение", Выборка.Количество > 0);
	
	Выборка = Результат[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКЗакрытиюМесяца");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();

		НаборЗаписей = РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
		НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКЗакрытиюМесяца.Получить();
		НаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли