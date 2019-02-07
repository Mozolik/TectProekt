﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.УстановкаЗначенийНаработки) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.УстановкаЗначенийНаработки.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.УстановкаЗначенийНаработки);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьУправлениеРемонтами";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	НаработкиОбъектовЭксплуатации(ТекстыЗапроса, Регистры);
	ПериодыАктуальностиОбъектовЭксплуатации(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Истина, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УстановкаЗначенийНаработки.Дата КАК ДатаРегистрации
	|ИЗ
	|	Документ.УстановкаЗначенийНаработки КАК УстановкаЗначенийНаработки
	|ГДЕ
	|	УстановкаЗначенийНаработки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("ДатаРегистрации", Реквизиты.ДатаРегистрации);
	Запрос.УстановитьПараметр("ИспользоватьУзлы", ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации"));
	
КонецПроцедуры

Процедура НаработкиОбъектовЭксплуатации(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НаработкиОбъектовЭксплуатации";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// НаработкиОбъектовЭксплуатации
	|"+
	"ВЫБРАТЬ
	|	&ДатаРегистрации КАК Период,
	|	ЕСТЬNULL(Узлы.Ссылка, Объекты.Ссылка) КАК ОбъектЭксплуатации,
	|	Наработки.ПоказательНаработки КАК ПоказательНаработки,
	|	Наработки.Значение КАК Значение,
	|	Наработки.СреднесуточноеЗначение КАК СреднесуточноеЗначение,
	|	ИСТИНА КАК КорректировочнаяЗапись
	|ИЗ
	|	Документ.УстановкаЗначенийНаработки.Наработки КАК Наработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
	|		ПО Наработки.ОбъектЭксплуатации = Объекты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|		ПО Наработки.ОбъектЭксплуатации = Узлы.Ссылка
	|			И (&ИспользоватьУзлы)
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура ПериодыАктуальностиОбъектовЭксплуатации(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПериодыАктуальностиОбъектовЭксплуатации";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// ПериодыАктуальностиОбъектовЭксплуатации
	|"+
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаРегистрации КАК Период,
	|	ВЫБОР
	|		КОГДА Наработки.ОбъектЭксплуатации ССЫЛКА Справочник.ОбъектыЭксплуатации
	|			ТОГДА Наработки.ОбъектЭксплуатации
	|		ИНАЧЕ Наработки.ОбъектЭксплуатации.Владелец
	|	КОНЕЦ КАК ОбъектЭксплуатации
	|ИЗ
	|	Документ.УстановкаЗначенийНаработки.Наработки КАК Наработки
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли