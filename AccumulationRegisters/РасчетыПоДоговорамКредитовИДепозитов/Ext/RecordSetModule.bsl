﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаУТВызовСервера.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистраНакопления(ЭтотОбъект.Метаданные());
	
	Запрос = Новый Запрос;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Выполнить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ПереоценкаВалютныхСредств) КАК Операция,
	|	ТаблицаИзменений.Регистратор КАК Документ,
	|	Аналитика.Организация
	|ИЗ
	|	ТаблицаИзмененийРасчетыПоДоговорамКредитовИДепозитов КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|		ПО ТаблицаИзменений.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
	|ГДЕ
	|	(ТИПЗНАЧЕНИЯ(ТаблицаИзменений.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|			ИЛИ ТаблицаИзменений.Договор.ВалютаВзаиморасчетов <> &ВалютаУпр
	|			ИЛИ ТаблицаИзменений.Договор.ВалютаВзаиморасчетов <> &ВалютаРегл)";
	
	Запрос.УстановитьПараметр("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда // В РИБ данный регистр обрабатывается только в главном узле.
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
			НаборЗаписей.НомерЗадания = ЗакрытиеМесяцаУТВызовСервера.ТекущийНомерЗадания();
			НаборЗаписей.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли