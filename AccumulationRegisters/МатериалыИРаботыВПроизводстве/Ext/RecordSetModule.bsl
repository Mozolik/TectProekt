﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Затраты.Период,
	|	Затраты.Регистратор,
	|	Затраты.Организация,
	|	Затраты.АналитикаУчетаНоменклатуры,
	|
	|	Затраты.Количество,
	|
	|	Затраты.СтатьяКалькуляции,
	|	Затраты.ЗаказНаПроизводство,
	|	Затраты.КодСтрокиПродукция,
	|	Затраты.Этап,
	|	Затраты.Назначение,
	|	Затраты.НалоговоеНазначение,
	|	Затраты.АналитикаУчетаПродукции,
	|	Затраты.Спецификация,
	|	Затраты.СтатьяРасходов,
	|	Затраты.АналитикаРасходов,
	|	Затраты.ПодразделениеПолучатель
	|ПОМЕСТИТЬ МатериалыИРаботыВПроизводствеПередЗаписью
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве КАК Затраты
	|ГДЕ
	|	Затраты.Регистратор = &Регистратор
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Затраты.Период,
	|		Затраты.Регистратор,
	|		Затраты.Организация,
	|		Затраты.АналитикаУчетаНоменклатуры,
	|
	|		Затраты.Количество,
	|
	|		Затраты.СтатьяКалькуляции,
	|		Затраты.ЗаказНаПроизводство,
	|		Затраты.КодСтрокиПродукция,
	|		Затраты.Этап,
	|		Затраты.Назначение,
	|		Затраты.НалоговоеНазначение,
	|		Затраты.АналитикаУчетаПродукции,
	|		Затраты.Спецификация,
	|		Затраты.СтатьяРасходов,
	|		Затраты.АналитикаРасходов,
	|		Затраты.ПодразделениеПолучатель
	|	ИЗ
	|		МатериалыИРаботыВПроизводствеПередЗаписью КАК Затраты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Затраты.Период,
	|		Затраты.Регистратор,
	|		Затраты.Организация,
	|		Затраты.АналитикаУчетаНоменклатуры,
	|
	|		-Затраты.Количество,
	|
	|		Затраты.СтатьяКалькуляции,
	|		Затраты.ЗаказНаПроизводство,
	|		Затраты.КодСтрокиПродукция,
	|		Затраты.Этап,
	|		Затраты.Назначение,
	|		Затраты.НалоговоеНазначение,
	|		Затраты.АналитикаУчетаПродукции,
	|		Затраты.Спецификация,
	|		Затраты.СтатьяРасходов,
	|		Затраты.АналитикаРасходов,
	|		Затраты.ПодразделениеПолучатель
	|	ИЗ
	|		РегистрНакопления.МатериалыИРаботыВПроизводстве КАК Затраты
	|	ГДЕ
	|		Затраты.Регистратор = &Регистратор
	|	) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.СтатьяКалькуляции,
	|	Таблица.ЗаказНаПроизводство,
	|	Таблица.КодСтрокиПродукция,
	|	Таблица.Этап,
	|	Таблица.Назначение,
	|	Таблица.НалоговоеНазначение,
	|	Таблица.АналитикаУчетаПродукции,
	|	Таблица.Спецификация,
	|	Таблица.СтатьяРасходов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.ПодразделениеПолучатель
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ МатериалыИРаботыВПроизводствеПередЗаписью
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписиРегистраПоДаннымВыборки(Запрос.Выполнить().Выбрать());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
