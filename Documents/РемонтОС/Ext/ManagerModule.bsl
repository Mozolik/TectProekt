﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

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
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru='Ремонт ОС';uk='Ремонт ОЗ'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры, ПрочиеРасходы(ТекстыЗапроса));
	УчетОСВызовСервера.ПереоценкаОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	ДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	СобытияОСОрганизаций(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.СобытиеОС КАК СобытиеОС,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов
	|ИЗ
	|	Документ.РемонтОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	УчетОСВызовСервера.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос, ДополнительныеСвойства);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("Граница", Новый Граница(НачалоМесяца(Реквизиты.Период), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("НазваниеДокумента", НСтр("ru='Ремонт ОС';uk='Ремонт ОЗ'"));
	Запрос.УстановитьПараметр("ГраницаКонецМесяца", Новый Граница(КонецМесяца(Реквизиты.Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Реквизиты.Организация, Реквизиты.Период));
	
КонецПроцедуры

Процедура ВременнаяТаблицаСгруппированнаяАмортизация(ТекстыЗапроса)
	
	ИмяТаблицы = "НачисленнаяАмортизация";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	УчетОСВызовСервера.ВременнаяТаблицаНачисленнаяАмортизация(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица сгруппированная амортизация
	|"+
	"ВЫБРАТЬ
	|	НачисленнаяАмортизация.ОбъектУчета КАК ОсновноеСредство,
	|	СУММА(НачисленнаяАмортизация.СуммаБУ) КАК СуммаБУ,
	|	СУММА(НачисленнаяАмортизация.СуммаНУ) КАК СуммаНУ
	|ПОМЕСТИТЬ НачисленнаяАмортизация
	|ИЗ
	|	втНачисленнаяАмортизация КАК НачисленнаяАмортизация
	|
	|СГРУППИРОВАТЬ ПО
	|	НачисленнаяАмортизация.ОбъектУчета
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ВременнаяТаблицаПоТабличнойЧасти(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаДокумента";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаСгруппированнаяАмортизация(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица по табличной части
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка,
	|	ТаблицаОС.НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство,
	|	ЕСТЬNULL(Амортизация.СуммаБУ,0) КАК СуммаАмортизацииБУ,
	|	ЕСТЬNULL(Амортизация.СуммаНУ,0) КАК СуммаАмортизацииНУ,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.РемонтОС.ОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|				,
	|				(Организация, ОсновноеСредство) В
	|					(ВЫБРАТЬ
	|						&Организация,
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						Документ.РемонтОС.ОС КАК ТаблицаОС
	|					ГДЕ
	|						ТаблицаОС.Ссылка = &Ссылка)) КАК СчетаБухгалтерскогоУчетаОССрезПоследних
	|		ПО ТаблицаОС.ОсновноеСредство = СчетаБухгалтерскогоУчетаОССрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачисленнаяАмортизация КАК Амортизация
	|		ПО ТаблицаОС.ОсновноеСредство = Амортизация.ОсновноеСредство
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|" + ";";

	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаОС";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаПоТабличнойЧасти(ТекстыЗапроса);
	ВременнаяТаблицаОстаткиСчета(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица ТаблицаОС
	|"+
	"ВЫБРАТЬ
	|	ТаблицаДокумента.ОсновноеСредство,
	|	ТаблицаДокумента.НомерСтроки,
	|	ПервоначальныеСведения.ПоказательНаработки КАК ПоказательНаработки,
	|	
	|
	|	втДанныеСчетаКапитализации.СуммаБУ КАК СуммаРегл,
	|	втДанныеСчетаКапитализации.СуммаБУ -
	|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеСчетУчета.СуммаОстатокДт,0)=0
	|	ТОГДА 0
	|	ИНАЧЕ ВЫРАЗИТЬ((ЕСТЬNULL(ДанныеСчетАмортизации.СуммаОстатокКт,0) + ЕСТЬNULL(ТаблицаДокумента.СуммаАмортизацииБУ,0)) * ЕСТЬNULL(втДанныеСчетаКапитализации.СуммаБУ/ДанныеСчетУчета.СуммаОстатокДт,0) КАК ЧИСЛО(15,2))
	|	КОНЕЦ КАК РасходБУ,
	|
	|	
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстатокДт,0)
	|	- ЕСТЬNULL(ДанныеСчетАмортизации.СуммаОстатокКт,0)
	|	- ЕСТЬNULL(ТаблицаДокумента.СуммаАмортизацииБУ,0) КАК ОстаточнаяСтоимостьБУ
	|	
	|	
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&Дата, ОсновноеСредство В(ВЫБРАТЬ Т.ОсновноеСредство ИЗ ТаблицаДокумента КАК Т)) КАК ПервоначальныеСведения
	|		ПО ПервоначальныеСведения.ОсновноеСредство = ТаблицаДокумента.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&ГраницаКонецМесяца,
	|				Счет В (ВЫБРАТЬ Т.СчетУчета ИЗ ТаблицаДокумента КАК Т),,
	|				(Организация, Подразделение, Субконто1) В
	|					(ВЫБРАТЬ
	|						&Организация, &Подразделение, ТаблицаДокумента.ОсновноеСредство
	|					ИЗ
	|						ТаблицаДокумента)
	|				) КАК ДанныеСчетУчета
	|		ПО ТаблицаДокумента.ОсновноеСредство = ДанныеСчетУчета.Субконто1
	|			И ТаблицаДокумента.СчетУчета = ДанныеСчетУчета.Счет
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеСчетаКапитализации КАК втДанныеСчетаКапитализации
	|		ПО ТаблицаДокумента.ОсновноеСредство = втДанныеСчетаКапитализации.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&ГраницаКонецМесяца,
	|				Счет В (ВЫБРАТЬ Т.СчетНачисленияАмортизации ИЗ ТаблицаДокумента КАК Т),,
	|				(Организация, Подразделение, Субконто1) В
	|					(ВЫБРАТЬ
	|						&Организация, &Подразделение, ТаблицаДокумента.ОсновноеСредство
	|					ИЗ
	|						ТаблицаДокумента)
	|				) КАК ДанныеСчетАмортизации
	|		ПО ТаблицаДокумента.ОсновноеСредство = ДанныеСчетАмортизации.Субконто1
	|"+";";

	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура СобытияОСОрганизаций(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СобытияОСОрганизаций";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СобытияОСОрганизаций
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	&Организация КАК Организация,
	|	&СобытиеОС КАК Событие,
	|	&НазваниеДокумента КАК НазваниеДокумента,
	|	&Номер КАК НомерДокумента,
	|	втДанныеСчетаКапитализации.СуммаБУ КАК СуммаЗатратБУ,
	|	0 КАК СуммаЗатратНУ
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеСчетаКапитализации КАК втДанныеСчетаКапитализации
	|		ПО ТаблицаОС.ОсновноеСредство = втДанныеСчетаКапитализации.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура ВременнаяТаблицаДанныеДокументаРегл(ТекстыЗапроса)
	
	ИмяТаблицы = "втДанныеДокумента";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
		
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица по табличной части
	|"+
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Подразделение КАК Подразделение,
	|	ТаблицаДокумента.Подразделение КАК Местонахождение,
	|	ТабличнаяЧасть.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов
	|ПОМЕСТИТЬ втДанныеДокумента
	|ИЗ
	|	Документ.РемонтОС КАК ТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РемонтОС.ОС КАК ТабличнаяЧасть
	|		ПО ТаблицаДокумента.Ссылка = ТабличнаяЧасть.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ВременнаяТаблицаОстатки(ТекстыЗапроса)
	
	ИмяТаблицы = "втОстатки";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаДанныеДокументаРегл(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица по остаткам счета капитализации
	|"+
	"ВЫБРАТЬ
	|	ДанныеУчета.Счет КАК Счет,
	|	ДанныеУчета.Субконто1 КАК ОсновноеСредство,
	//|	ДанныеУчета.Субконто2 КАК СтатьяРасходов,
	|	СУММА(ДанныеУчета.СуммаОборот) КАК СуммаБУ,
	|	0 КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&ГраницаКонецМесяца,
	|			Регистратор,
	|           Счет  = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОбслуживаниеИРемонт),
	|			,
	|			(Организация, Подразделение) В
	|				(ВЫБРАТЬ
	|					Т.Организация,
	|					Т.Подразделение
	//|					Т.ОсновноеСредство
	|				ИЗ
	|					втДанныеДокумента КАК Т),
	|			,
	|			) КАК ДанныеУчета
	|ГДЕ
	|	ДанныеУчета.Регистратор <> &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеУчета.Субконто1,
	|	ДанныеУчета.Счет
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ВременнаяТаблицаОстаткиСчета(ТекстыЗапроса)
	
	ИмяТаблицы = "втДанныеСчетаКапитализации";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаДанныеДокументаРегл(ТекстыЗапроса);
	ВременнаяТаблицаОстатки(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица по остаткам счета капитализации
	|"+
	"ВЫБРАТЬ
	|	втОстатки.Счет КАК Счет,
	|	втОстатки.ОсновноеСредство,
	|	втОстатки.СуммаБУ КАК СуммаБУ,
	|	0 КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втДанныеСчетаКапитализации
	|ИЗ
	|	втОстатки КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеДокумента КАК втДанныеДокумента
	|		ПО втОстатки.ОсновноеСредство = втДанныеДокумента.ОсновноеСредство
	|
	|
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Функция ПрочиеРасходы(ТекстыЗапроса)
			
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	ВременнаяТаблицаОстаткиСчета(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	
	|	&Организация КАК Организация,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначение,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	
	|	0 КАК Сумма,
	|	0 КАК СуммаБезНДС,
	|	ТаблицаОС.СуммаРегл КАК СуммаРегл,
    |	ТаблицаОС.СуммаРегл КАК СуммаРеглБезНДС,
	|	0 КАК НДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Неопределено КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК ПВХСтатьиРасходов
	|		ПО &СтатьяРасходов = ПВХСтатьиРасходов.Ссылка
	|		
	|ГДЕ
	|	 НЕ ПВХСтатьиРасходов.ВариантРаспределенияРасходов В (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|	)
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	
	|	&Организация КАК Организация,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначение,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	
	|	СУММА(ПрочиеРасходыНаРемонтОстатки.СуммаОстаток) КАК Сумма,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаРеглБезНДС,
	|	0 КАК НДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Неопределено КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы.Остатки(
	|			&Период,
	|			СтатьяРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И Организация = &Организация
	|				И СтатьяРасходов.РасходыНаРемонтОС = Истина
	|				И АналитикаРасходов В
	|					(ВЫБРАТЬ
	|						Т.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК Т)) КАК ПрочиеРасходыНаРемонтОстатки
	|    ПО ТаблицаОС.ОсновноеСредство = ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК ПВХСтатьиРасходов
	|		ПО ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов = ПВХСтатьиРасходов.Ссылка
	|		
	|ГДЕ
	|	ПВХСтатьиРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|	И ПВХСтатьиРасходов.РасходыНаРемонтОС = Истина
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	
	|	&Организация КАК Организация,
    |	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|	&Подразделение КАК Подразделение,
	|	ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|	ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов,
	|	
	|	СУММА(ПрочиеРасходыНаРемонтОстатки.СуммаОстаток) КАК Сумма,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаРеглБезНДС,
	|	0 КАК НДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Неопределено КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы.Остатки(
	|			&Период,
	|			СтатьяРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И Организация = &Организация
	|				И СтатьяРасходов.РасходыНаРемонтОС = Истина
	|				И АналитикаРасходов В
	|					(ВЫБРАТЬ
	|						Т.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК Т)) КАК ПрочиеРасходыНаРемонтОстатки
	|    ПО ТаблицаОС.ОсновноеСредство = ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК ПВХСтатьиРасходов
	|		ПО ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов = ПВХСтатьиРасходов.Ссылка
	|		
	|ГДЕ
	|	 ПВХСтатьиРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|	И ПВХСтатьиРасходов.РасходыНаРемонтОС = Истина
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов,
	|	ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов
	|";
	
	
КонецФункции

Процедура ДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДоходыРасходыПрочиеАктивыПассивы";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	ВременнаяТаблицаОстаткиСчета(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// ДвиженияДоходыРасходыПрочиеАктивыПассивы
	|"+
	"ВЫБРАТЬ
	|
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗавершениеТекущегоРемонта)КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяРасходов КАК Статья,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	&Подразделение КАК КорПодразделение,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НезавершенноеПроизводство) КАК КорСтатья,
	|	&Подразделение КАК КорАналитикаРасходов,
	|	
	|	0 КАК Сумма,
	|	ТаблицаОС.СуммаРегл КАК СуммаРегл
	|
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК ПВХСтатьиРасходов
	|		ПО &СтатьяРасходов = ПВХСтатьиРасходов.Ссылка
	|		
	|ГДЕ
	|	 НЕ ПВХСтатьиРасходов.ВариантРаспределенияРасходов В (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|	)
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗавершениеТекущегоРемонта)КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяРасходов КАК Статья,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	&Подразделение КАК КорПодразделение,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НезавершенноеПроизводство) КАК КорСтатья,
	|	&Подразделение КАК КорАналитикаРасходов,
	|	
	|	СУММА(ПрочиеРасходыНаРемонтОстатки.СуммаОстаток) КАК Сумма,
	|	0 КАК СуммаРегл
	|
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы.Остатки(
	|			&Период,
	|			СтатьяРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И Организация = &Организация
	|				И СтатьяРасходов.РасходыНаРемонтОС = Истина
	|				И АналитикаРасходов В
	|					(ВЫБРАТЬ
	|						Т.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК Т)) КАК ПрочиеРасходыНаРемонтОстатки
	|    ПО ТаблицаОС.ОсновноеСредство = ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК ПВХСтатьиРасходов
	|		ПО ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов = ПВХСтатьиРасходов.Ссылка
	|		
	|ГДЕ
	|	 ПВХСтатьиРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|	И ПВХСтатьиРасходов.РасходыНаРемонтОС = Истина
	|СГРУППИРОВАТЬ ПО
	|
	|	ПрочиеРасходыНаРемонтОстатки.АналитикаРасходов,
	|
	|	ПрочиеРасходыНаРемонтОстатки.СтатьяРасходов
	//////////////////////////////////////////////////////
	|"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры
#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизацииУКР("РемонтОС")
		+ УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеОстаткиПоСчетам()
		+ВременнаяТаблицаДанныеДокумента()
		+ ВременнаяТаблицаОстаткиСчетаКапитализации();
		
	КонецФункции
	
Функция ВременнаяТаблицаДанныеДокумента()
	
	Возврат
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Подразделение КАК Подразделение,
	|	ТаблицаДокумента.Подразделение КАК Местонахождение,
	|	ТабличнаяЧасть.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов
	|ПОМЕСТИТЬ втДанныеДокумента
	|ИЗ
	|	Документ.РемонтОС КАК ТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РемонтОС.ОС КАК ТабличнаяЧасть
	|		ПО ТаблицаДокумента.Ссылка = ТабличнаяЧасть.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(
	|				&Дата,
	|				Организация В
	|					(ВЫБРАТЬ
	|						Т.Организация
	|					ИЗ
	|						Документ.РемонтОС КАК Т
	|					ГДЕ
	|						Т.Ссылка = &Ссылка)) КАК УчетнаяПолитикаОрганизаций
	|		ПО ТаблицаДокумента.Организация = УчетнаяПолитикаОрганизаций.Организация
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка" + ";";
	
КонецФункции

Функция ВременнаяТаблицаОстаткиСчетаКапитализации()
	
	Возврат
	"ВЫБРАТЬ
	|	ДанныеУчета.Счет КАК Счет,
	|	ДанныеУчета.Субконто1 КАК ОсновноеСредство,
	|	СУММА(ДанныеУчета.СуммаОборот) КАК СуммаБУ,
	|	0 КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&ГраницаМесяцОкончание,
	|			Регистратор,
	|           Счет  = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОбслуживаниеИРемонт),
	|			,
	|			(Организация, Подразделение) В
	|				(ВЫБРАТЬ
	|					Т.Организация,
	|					Т.Подразделение
	|				ИЗ
	|					втДанныеДокумента КАК Т),
	|			,
	|			) КАК ДанныеУчета
	|ГДЕ
	|	ДанныеУчета.Регистратор <> &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеУчета.Субконто1,
	|	ДанныеУчета.Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОстатки.ОсновноеСредство,
	|	СУММА(втОстатки.СуммаБУ) КАК СуммаБУ,
	|	0 КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втОстаткиСгруппированные
	|ИЗ
	|	втОстатки КАК втОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	втОстатки.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОстатки.Счет КАК Счет,
	|	втОстатки.ОсновноеСредство,
	|	втОстатки.СуммаБУ КАК СуммаБУ,
	|   0 КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втДанныеСчетаКапитализации
	|ИЗ
	|	втОстатки КАК втОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеДокумента КАК втДанныеДокумента
	|		ПО втОстатки.ОсновноеСредство = втДанныеДокумента.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеСчетаКапитализации.ОсновноеСредство,
	|	СУММА(втДанныеСчетаКапитализации.СуммаБУ) КАК СуммаБУ,
	|	СУММА(втДанныеСчетаКапитализации.СуммаНУ) КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ втДанныеСчетаКапитализацииСгруппированные
	|ИЗ
	|	втДанныеСчетаКапитализации КАК втДанныеСчетаКапитализации
	|
	|СГРУППИРОВАТЬ ПО
	|	втДанныеСчетаКапитализации.ОсновноеСредство"
	+"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
КонецФункции

Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	Разделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Возврат УчетОСВызовСервера.ТекстОтраженияВРеглУчетеНачисленнойАмортизации()
		+ Разделитель + РемонтОС();
КонецФункции

Функция РемонтОС()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Ремонт ОС (Дт Счет расходов :: Кт 239)
	|ВЫБРАТЬ
	|	
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(втДанныеСчетаКапитализации.СуммаБУ, 0) КАК Сумма,
	|	
	|	// Дт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК АналитижкаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеДт,
	|	
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	
	|	Строки.ОсновноеСредство КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	// Кт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|   ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеКт,
	|	
	|	втДанныеСчетаКапитализации.Счет КАК СчетКт,
	|	
	|	Строки.ОсновноеСредство КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	
	|	""Ремонт ОС"" КАК Содержание
	|ИЗ
	|	Документ.РемонтОС КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РемонтОС.ОС КАК Строки
	|		ПО Строки.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеСчетаКапитализации
	|	ПО Строки.ОсновноеСредство = втДанныеСчетаКапитализации.ОсновноеСредство
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	
	// Акт о приеме-сдаче ОС (ОС-2)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОЗ2";
	КомандаПечати.Представление = НСтр("ru='Форма ОЗ-2';uk='Форма ОЗ-2'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюУТКлиент.ВыполнитьКомандуПечати";	

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОЗ2") Тогда

		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОЗ2", НСтр("ru='Форма ОЗ-2';uk='Форма ОЗ-2'"), 
			ПечатьОЗ2(МассивОбъектов, ОбъектыПечати, ПараметрыПечати), , );

	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОЗ2(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	УстановитьПривилегированныйРежим(Истина);

	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_ОЗ2");
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Ремонт_ОЗ2";
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		
		Запрос       = Новый Запрос;
		Запрос.УстановитьПараметр("Период"            , Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("ТекОрганизация"    , Ссылка.Организация);
		Запрос.УстановитьПараметр("ГлавныйБухгалтер"  , Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		Запрос.УстановитьПараметр("РуководительОтдела", Ссылка.РуководительОтдела);
		Запрос.УстановитьПараметр("Сдал"              , Ссылка.Сдал);
		Запрос.УстановитьПараметр("Принял"            , Ссылка.Принял);
		Запрос.УстановитьПараметр("Ссылка"            , Ссылка.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РемонтОС.Организация.НаименованиеПолное КАК Организация,
		|	РемонтОС.Организация.КодПоЕДРПОУ КАК ЕДРПОУ,
		|	РемонтОС.Номер КАК НомерАкта,
		|	РемонтОС.Дата КАК ДатаАкта,
		|	РемонтОС.СобытиеОС КАК ВидОперации,
		|	Хозрасчетный.СчетКт КАК СчетКт,
		|	РемонтОС.ДатаНачалаРемонта КАК ДатаНачала,
		|	РемонтОС.ДатаОкончанияРемонта КАК ДатаОкончания,
		|	РемонтОС.ЧтоНеВыполнено КАК ЧтоНеВыполнено,
		|	РемонтОС.ЧтоИзменилось КАК ЧтоИзменилось,
		|	РАЗНОСТЬДАТ(РемонтОС.ДатаНачалаРемонта, РемонтОС.ДатаОкончанияРемонта, ДЕНЬ) КАК КоличествоДней
		|ИЗ
		|	Документ.РемонтОС КАК РемонтОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
		|		ПО (Хозрасчетный.Регистратор = РемонтОС.Ссылка)
		|ГДЕ
		|	РемонтОС.Ссылка = &Ссылка
		|	И НЕ Хозрасчетный.СчетДт.Забалансовый
		|	И Хозрасчетный.СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОбслуживаниеИРемонт)";
		ВыборкаПоШапке = Запрос.Выполнить().Выбрать();
		ВыборкаПоШапке.Следующий();

		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка",         Ссылка.Ссылка);
		Запрос.УстановитьПараметр("Период",         Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("ТекОрганизация", Ссылка.Организация);
		
		СписокОС = Ссылка.ОС.ВыгрузитьКолонку("ОсновноеСредство");
		Запрос.УстановитьПараметр("СписокОС",       СписокОС);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РемонтОСОС.ОсновноеСредство.ЗаводскойНомер       КАК ЗаводскойНомер,
		|	РемонтОСОС.ОсновноеСредство.НаименованиеПолное   КАК ОсновноеСредствоНаименование,
		|	Хозрасчетный.Сумма 									   КАК СуммаРемонта,
		|	Хозрасчетный.Сумма                   	   			   КАК СуммаМодернизацииИРемонта,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета                   КАК СчетДт,
		|	ПервоначальныеСведенияОС.ИнвентарныйНомер              КАК ИнвентарныйНомер,
		|	МестонахождениеОС.МОЛ.Код                              КАК КодМОЛа,
		|	МестонахождениеОС.Местонахождение.Наименование         КАК Подразделение
		|ИЗ
		|	Документ.РемонтОС.ОС КАК РемонтОСОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|		                    &Период,
		|		                    Организация = &ТекОрганизация
		|		                    И ОсновноеСредство В (&СписокОС)) КАК СчетаБухгалтерскогоУчетаОС
		|		ПО РемонтОСОС.ОсновноеСредство = СчетаБухгалтерскогоУчетаОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|		                    &Период,
		|		                    Организация = &ТекОрганизация
		|		                    И ОсновноеСредство В (&СписокОС)) КАК ПервоначальныеСведенияОС
		|		ПО РемонтОСОС.ОсновноеСредство = ПервоначальныеСведенияОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|		                    &Период,
		|		                    Организация = &ТекОрганизация
		|		                    И ОсновноеСредство В (&СписокОС)) КАК МестонахождениеОС
		|		ПО РемонтОСОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто КАК Хозрасчетный
		|		ПО (Хозрасчетный.Регистратор = РемонтОСОС.Ссылка
		|		    И Хозрасчетный.СубконтоКт1 = РемонтОСОС.ОсновноеСредство)
		|ГДЕ
		|	РемонтОСОС.Ссылка = &Ссылка
		|	И СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОбслуживаниеИРемонт)";
		
			
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		НеПервая = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если НеПервая Тогда
				
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЕсли;
			
			ОбластьМакета = Макет.ПолучитьОбласть("ОЗ2");
			ОбластьМакета.Параметры.Заполнить(ВыборкаПоШапке);
					
			ОбластьМакета.Параметры.Заполнить(Выборка);
			
			ОсновныеСотрудникиФизическихЛицПринял = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Ссылка.Принял, Истина, Ссылка.Организация, Ссылка.Дата);
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицПринял) Тогда
				Для каждого Строка Из ОсновныеСотрудникиФизическихЛицПринял Цикл
				    ДанныеФизЛицаПолучил = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);			
				КонецЦикла;
				Для каждого СтрокаДанныеПолучил Из ДанныеФизЛицаПолучил Цикл			
					ОбластьМакета.Параметры.ПринялДолжность = СтрокаДанныеПолучил.Должность;
					ОбластьМакета.Параметры.Принял 			= СтрокаДанныеПолучил.ФизическоеЛицо;			
				КонецЦикла;
			КонецЕсли;
			ОсновныеСотрудникиФизическихЛицСдал = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Ссылка.Сдал, Истина, Ссылка.Организация, Ссылка.Дата);
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицСдал) Тогда		
				Для каждого Строка Из ОсновныеСотрудникиФизическихЛицСдал Цикл
					ДанныеФизЛицаСдал = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);
				КонецЦикла;
				Для каждого СтрокаДанныеСдал Из ДанныеФизЛицаСдал Цикл
					ОбластьМакета.Параметры.СдалДолжность 	= СтрокаДанныеСдал.Должность;
					ОбластьМакета.Параметры.Сдал	 		= СтрокаДанныеСдал.ФизическоеЛицо;
				КонецЦикла;			
			КонецЕсли;
			ОсновныеСотрудникиФизическихЛицРуководительОтдела = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Ссылка.РуководительОтдела, Истина, Ссылка.Организация, Ссылка.Дата); 
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицРуководительОтдела) Тогда
				Для каждого СтрокаДанныеРуководительОтдела Из ОсновныеСотрудникиФизическихЛицРуководительОтдела Цикл
					ДанныеФизЛицаРуководительОтдела = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СтрокаДанныеРуководительОтдела.Сотрудник, "Должность", Ссылка.Дата);
				КонецЦикла;
				Для каждого СтрокаДанныеРуководительОтдела Из ДанныеФизЛицаРуководительОтдела Цикл
					ОбластьМакета.Параметры.РуководительОтдела = СтрокаДанныеРуководительОтдела.ФизическоеЛицо;
				КонецЦикла;
			КонецЕсли;
			ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Ссылка.Организация, Ссылка.Дата);

			ОбластьМакета.Параметры.ГлавныйБухгалтер 	= ОтветственныеЛица.ГлавныйБухгалтерПредставление;
			
			ТабДокумент.Вывести(ОбластьМакета);
			НеПервая = Истина;
		
		КонецЦикла;
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьОЗ2()

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	УчетОСВызовСервера.ЗаполнитьВходящиеДанныеАмортизации(ВходящиеДанные);
	
	ЗакрытиеМесяцаУТВызовСервера.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
