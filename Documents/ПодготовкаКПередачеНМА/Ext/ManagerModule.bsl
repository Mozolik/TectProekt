﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.РеализацияУслугПрочихАктивов.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПодготовкаКПередачеНМА) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ПодготовкаКПередачеНМА.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ПодготовкаКПередачеНМА);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
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


Процедура ИнициализироватьДанныеДокументаУКР(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru='Переоценка НМА';uk='Переоцінка нематеріального активу'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры, ПрочиеРасходы(ТекстыЗапроса));
	УчетОСВызовСервера.ПартииПрочихРасходов(ТекстыЗапроса, Регистры, ПартииПрочихРасходов(ТекстыЗапроса));
	УчетОСВызовСервера.ПорядокОтраженияПрочихОпераций(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	
	ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры);
	ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры);
	СостоянияНМАОрганизаций(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.НематериальныйАктив КАК НематериальныйАктив,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходовПринятиеКНалоговомуУчету,
	|	ДанныеДокумента.СтатьяРасходов.ВариантРаспределенияРасходов КАК СтатьяРасходовВариантРаспределенияРасходов
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА КАК ДанныеДокумента
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
	Запрос.УстановитьПараметр("КонецМесяца", Новый Граница(КонецМесяца(Реквизиты.Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("СписаниеОстаточнойСтоимости", Истина);
	Запрос.УстановитьПараметр("ДатаСписанияОстаточнойСтоиости", Реквизиты.Период);
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Реквизиты.Организация, Реквизиты.Период));
	
КонецПроцедуры

Процедура ВременнаяТаблицаОстаточнойСтоимости(ТекстыЗапроса)
	
	ИмяТаблицы = "ОстаточнаяСтоимостьНМА";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица ОстаточнаяСтоимостьНМА
	|"+
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстатокДт,0)
	|	- ЕСТЬNULL(ДанныеСчетАмортизации.СуммаОстатокКт,0)
	|	- ЕСТЬNULL(Амортизация.СуммаБУ,0) КАК ОстаточнаяСтоимостьБУ,
	|	0 КАК ОстаточнаяСтоимостьПР,
	|	0 КАК ОстаточнаяСтоимостьВР
	|ПОМЕСТИТЬ ОстаточнаяСтоимостьНМА
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА КАК ДанныеДокумента
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|		ВЫБРАТЬ
	|			Т.ОбъектУчета КАК НематериальныйАктив,
	|			СУММА(Т.СуммаБУ) КАК СуммаБУ,
	|			СУММА(Т.СуммаНУ) КАК СуммаНУ,
	|			СУММА(Т.СуммаПР) КАК СуммаПР,
	|			СУММА(Т.СуммаВР) КАК СуммаВР
	|		ИЗ Документ.ПодготовкаКПередачеНМА.НачисленнаяАмортизация КАК Т
	|		ГДЕ Т.Ссылка = &Ссылка
	|		СГРУППИРОВАТЬ ПО Т.ОбъектУчета
	|		) КАК Амортизация
	|		ПО ДанныеДокумента.НематериальныйАктив = Амортизация.НематериальныйАктив
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&КонецМесяца,
	|			Счет В 
	|				(ВЫБРАТЬ СчетаОтражения.СчетУчета
	|				ИЗ РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(
	|					&Период,
	|					(Организация, НематериальныйАктив) В
	|						(ВЫБРАТЬ
	|							Т.Организация,
	|							Т.НематериальныйАктив
	|						ИЗ
	|							Документ.ПодготовкаКПередачеНМА КАК Т
	|						ГДЕ Т.Ссылка = &Ссылка)) КАК СчетаОтражения),,
	|			(Организация, Подразделение, Субконто1) В
	|				(ВЫБРАТЬ
	|					Т.Организация,
	|					Т.Подразделение,
	|					Т.НематериальныйАктив
	|				ИЗ
	|					Документ.ПодготовкаКПередачеНМА КАК Т
	|				ГДЕ Т.Ссылка = &Ссылка)
	|			) КАК ДанныеСчетУчета
	|		ПО ДанныеДокумента.НематериальныйАктив = ДанныеСчетУчета.Субконто1
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&КонецМесяца,
	|			Счет В 
	|				(ВЫБРАТЬ СчетаОтражения.СчетНачисленияАмортизации
	|				ИЗ РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(
	|					&Период,
	|					(Организация, НематериальныйАктив) В
	|						(ВЫБРАТЬ
	|							Т.Организация,
	|							Т.НематериальныйАктив
	|						ИЗ
	|							Документ.ПодготовкаКПередачеНМА КАК Т
	|						ГДЕ Т.Ссылка = &Ссылка)) КАК СчетаОтражения),,
	|			(Организация, Подразделение, Субконто1) В
	|				(ВЫБРАТЬ
	|					Т.Организация,
	|					Т.Подразделение,
	|					Т.НематериальныйАктив
	|				ИЗ
	|					Документ.ПодготовкаКПередачеНМА КАК Т
	|				ГДЕ Т.Ссылка = &Ссылка)
	|			) КАК ДанныеСчетАмортизации
	|		ПО ДанныеДокумента.НематериальныйАктив = ДанныеСчетАмортизации.Субконто1
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

 
Процедура ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ПервоначальнаяСтоимость,
	|	НЕОПРЕДЕЛЕНО КАК ЛиквидационнаяСтоимость,
	|	ЛОЖЬ КАК НачислятьАмортизацию,
	|	НЕОПРЕДЕЛЕНО КАК СпособНачисленияАмортизации,
	|	НЕОПРЕДЕЛЕНО КАК СрокПолезногоИспользования,
	|	НЕОПРЕДЕЛЕНО КАК ОбъемПродукцииРаботДляВычисленияАмортизации
	|" + ";";
	
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

 
Процедура ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАНалоговыйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАНалоговыйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ЛОЖЬ КАК НачислятьАмортизацию,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ПервоначальнаяСтоимостьНУ,
	|	НЕОПРЕДЕЛЕНО КАК СрокПолезногоИспользования
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура СостоянияНМАОрганизаций(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СостоянияНМАОрганизаций";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СостоянияНМАОрганизаций
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан) КАК Состояние" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Функция ПрочиеРасходы(ТекстыЗапроса)
	
	ВременнаяТаблицаОстаточнойСтоимости(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	
	|	0 КАК Сумма,
	|	
	|	0 КАК СуммаБезНДС,
	|	
	|	ОстаточнаяСтоимостьНМА.ОстаточнаяСтоимостьБУ КАК СуммаРегл,
	|	0 КАК СуммаРеглБезНДС,
	|	0 КАК НДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Неопределено КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	ОстаточнаяСтоимостьНМА КАК ОстаточнаяСтоимостьНМА
	|ГДЕ
	|	НЕ &СтатьяРасходовВариантРаспределенияРасходов В (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|	)
	|
	   |";
		
	
КонецФункции

Функция ПартииПрочихРасходов(ТекстыЗапроса)
	
	ВременнаяТаблицаОстаточнойСтоимости(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	&Ссылка КАК ДокументПоступленияРасходов,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаПартий,
	|	
	|	0 КАК Стоимость,
	|	0 КАК СтоимостьБезНДС,
	|	ОстаточнаяСтоимостьНМА.ОстаточнаяСтоимостьБУ КАК СтоимостьРегл,
	|	0 КАК НДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница
	|ИЗ
	|	ОстаточнаяСтоимостьНМА КАК ОстаточнаяСтоимостьНМА
	|ГДЕ
	|	&СтатьяРасходовВариантРаспределенияРасходов В (ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров))
	|";

КонецФункции

#КонецОбласти

#Область ПроведениеПоРегламентированномуУчету

Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат УчетНМА.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизацииУКР("ПодготовкаКПередачеНМА")
		+ УчетНМА.ТекстЗапросаВТОтраженияВРеглУчетеОстаткиПоСчетамУКР();
	
КонецФункции

Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	Разделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Возврат УчетНМА.ТекстОтраженияВРеглУчетеНачисленнойАмортизацииУКР()
		+ Разделитель + ПереносНачисленнойАмортизацииНМАУКР()
		+ Разделитель + СписаниеОстаточнойСтоимостиНМАУКР()
		//+ Разделитель + СписаниеОстаточнойСтоимостиНМАЦФ()
		//+ Разделитель + СписаниеДоходыОтЦелевогоФинансирования();
		;
		
КонецФункции

Функция ПереносНачисленнойАмортизацииНМАУКР()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Перенос начисленной амортизации НМА (Дт СчетНакопленияАмортизации :: Кт СчетУчета)
	|ВЫБРАТЬ
	|	
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияБУ, 0) КАК Сумма,
	|	
	|	// Дт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеДт,//НужноДобавитьНалоговоеНазначениеДт
	|	
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетДт,
	|	Операция.НематериальныйАктив КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияПР, 0) КАК СуммаПРДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияВР, 0) КАК СуммаВРДт,
	|	
	|	// Кт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеКт,//НужноДобавитьНалоговоеНазначениеКт
	|	
	|	СчетаОтражения.СчетУчета КАК СчетКт,
	|	Операция.НематериальныйАктив КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияПР, 0) КАК СуммаПРКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияВР, 0) КАК СуммаВРКт,
	|	
	|	""Перенос начисленной амортизации НМА"" КАК Содержание
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА КАК Операция
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Операция.НематериальныйАктив = СчетаОтражения.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Операция.НематериальныйАктив = втОстаткиПоСчетам.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НематериальныеАктивы КАК НематериальныеАктивы
	|		ПО Операция.НематериальныйАктив = НематериальныеАктивы.Ссылка
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
КонецФункции

Функция СписаниеОстаточнойСтоимостиНМАУКР()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Списание остаточной стоимости НМА (Дт Расходы :: Кт СчетУчета)
	|ВЫБРАТЬ
	|	
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьБУ, 0) КАК Сумма,
	|	
	|	// Дт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	ВЫБОР КОГДА СтатьиСтроительства.ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.ПрочиеРаботыИУслуги)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеОперации)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы)
	|	КОНЕЦ КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеДт,//НужноДобавитьНалоговоеНазначениеДт
	|	
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Операция.СтатьяРасходов КАК СубконтоДт1,
	|	Операция.НематериальныйАктив КАК СубконтоДт2,
	|	Операция.АналитикаРасходов КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьНУ, 0) КАК СуммаНУДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьПР, 0) КАК СуммаПРДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьВР, 0) КАК СуммаВРДт,
	|	
	|	// Кт ///////////////////////////////////////////////////////////////////////////////////////////
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеКт,//НужноДобавитьНалоговоеНазначениеКт
	|	
	|	СчетаОтражения.СчетУчета КАК СчетКт,
	|	Операция.НематериальныйАктив КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьНУ, 0) КАК СуммаНУКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьПР, 0) КАК СуммаПРКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ОстаточнаяСтоимостьВР, 0) КАК СуммаВРКт,
	|	
	|	""Списание остаточной стоимости НМА"" КАК Содержание
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА КАК Операция
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Операция.НематериальныйАктив = СчетаОтражения.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Операция.НематериальныйАктив = втОстаткиПоСчетам.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиСтроительства
	|	ПО Операция.СтатьяРасходов = СтатьиСтроительства.Ссылка
	|		И СтатьиСтроительства.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НематериальныеАктивы КАК НематериальныеАктивы
	|		ПО Операция.НематериальныйАктив = НематериальныеАктивы.Ссылка
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
КонецФункции

#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НА3";
	КомандаПечати.Представление = НСтр("ru='Форма НА-3';uk='Форма НА-3'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НА3") Тогда
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "НА3", НСтр("ru='Форма НА-3';uk='Форма НА-3'"),
			ПечатьНА3(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),
			,
			,
			,
			Ложь // ЭтоМногоязычнаяПечатнаяФорма
		);
	КонецЕсли;
	
КонецПроцедуры


// Функция формирует табличный документ с типовой печатной формой НА-3
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНА3(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеНМА_НА3";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_НА3");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"				,Ссылка);
		Запрос.УстановитьПараметр("Период"				,Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("ГраницаДо"			,Новый Граница(Ссылка.МоментВремени(),ВидГраницы.Исключая));
		Запрос.УстановитьПараметр("Организация"			,Ссылка.Организация);
		Запрос.УстановитьПараметр("НематериальныйАктив" ,Ссылка.НематериальныйАктив);
		Запрос.Текст = 
		 "ВЫБРАТЬ
		 |	ПодготовкаКПередачеНМА.Номер КАК НомерДок,
		 |	ПодготовкаКПередачеНМА.Дата КАК ДатаДок,
		 |	ВЫРАЗИТЬ(ПодготовкаКПередачеНМА.Организация.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолноеОрганизации,
		 |	ПодготовкаКПередачеНМА.Организация.КодПоЕДРПОУ КАК КодПоЕДРПОУ,
		 |	ВЫРАЗИТЬ(ПодготовкаКПередачеНМА.НематериальныйАктив.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное,
		 |	ПодготовкаКПередачеНМА.НематериальныйАктив.ПрочиеСведения КАК ПрочиеСведения,
		 |	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.МОЛ,
		 |	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.Местонахождение,
		 |	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
		 |	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.СрокПолезногоИспользования КАК СрокИспользования,
		 |	СчетаБухгалтерскогоУчетаНМАСрезПоследних.СчетУчета КАК СчетУчетаБУ,
		 |	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстатокДт, 0) - ЕСТЬNULL(ДанныеСчетаАмортизации.СуммаОборотКт, 0) КАК ОстаточнаяСтоимость,
		 |	ДанныеСчетаРасходов.Счет КАК СчетСписанияБУ,
		 |	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость
		 |ИЗ
		 |	Документ.ПодготовкаКПередачеНМА КАК ПодготовкаКПередачеНМА
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеНМАБухгалтерскийУчет.СрезПоследних(
		 |				&Период,
		 |				НематериальныйАктив = &НематериальныйАктив
		 |					И Организация = &Организация) КАК МестонахождениеНМАБухгалтерскийУчетСрезПоследних
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(
		 |				&ГраницаДо,
		 |				НематериальныйАктив = &НематериальныйАктив
		 |					И Организация = &Организация) КАК ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(
		 |				&Период,
		 |				НематериальныйАктив = &НематериальныйАктив
		 |					И Организация = &Организация) КАК СчетаБухгалтерскогоУчетаНМАСрезПоследних
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = СчетаБухгалтерскогоУчетаНМАСрезПоследних.НематериальныйАктив
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
		 |				,
		 |				&Период,
		 |				,
		 |				,
		 |				Счет В
		 |					(ВЫБРАТЬ
		 |						Т.СчетНачисленияАмортизации
		 |					ИЗ
		 |						РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&Период, НематериальныйАктив = &НематериальныйАктив
		 |							И Организация = &Организация) КАК Т),
		 |				,
		 |				(Организация, Подразделение, Субконто1) В
		 |					(ВЫБРАТЬ
		 |						ПодготовкаКПередачеНМА.Организация,
		 |						ПодготовкаКПередачеНМА.Подразделение,
		 |						ПодготовкаКПередачеНМА.НематериальныйАктив
		 |					ИЗ
		 |						Документ.ПодготовкаКПередачеНМА КАК ПодготовкаКПередачеНМА
		 |					ГДЕ
		 |						ПодготовкаКПередачеНМА.Ссылка = &Ссылка)) КАК ДанныеСчетаАмортизации
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = ДанныеСчетаАмортизации.Субконто1
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		 |				&Период,
		 |				Счет В
		 |					(ВЫБРАТЬ
		 |						Т.СчетУчета
		 |					ИЗ
		 |						РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&Период, НематериальныйАктив = &НематериальныйАктив
		 |							И Организация = &Организация) КАК Т),
		 |				,
		 |				) КАК ДанныеСчетУчета
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = ДанныеСчетУчета.Субконто1
		 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Обороты(
		 |				,
		 |				&Период,
		 |				,
		 |				,
		 |				,
		 |				(Организация, Подразделение, Субконто1) В
		 |					(ВЫБРАТЬ
		 |						ПодготовкаКПередачеНМА.Организация,
		 |						ПодготовкаКПередачеНМА.Подразделение,
		 |						ПодготовкаКПередачеНМА.СтатьяРасходов
		 |					ИЗ
		 |						Документ.ПодготовкаКПередачеНМА КАК ПодготовкаКПередачеНМА
		 |					ГДЕ
		 |						ПодготовкаКПередачеНМА.Ссылка = &Ссылка),
		 |				КорСчет В
		 |					(ВЫБРАТЬ
		 |						Т.СчетУчета
		 |					ИЗ
		 |						РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&Период, НематериальныйАктив = &НематериальныйАктив
		 |							И Организация = &Организация) КАК Т),
		 |				) КАК ДанныеСчетаРасходов
		 |		ПО ПодготовкаКПередачеНМА.НематериальныйАктив = ДанныеСчетаРасходов.КорСубконто1
		 |ГДЕ
		 |	ПодготовкаКПередачеНМА.Ссылка = &Ссылка";
		Результат = Запрос.Выполнить();
		ВыборкаПоНМА = Результат.Выбрать();
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		ОтветственныеЛицаОрганизации = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Ссылка.Организация,Ссылка.Дата);
			
		Пока ВыборкаПоНМА.Следующий() Цикл
			
			ОбластьМакета = Макет.ПолучитьОбласть("НА3");
			Параметры     = ОбластьМакета.Параметры;
			Параметры.Заполнить(ВыборкаПоКомиссии);
			Параметры.Заполнить(ВыборкаПоНМА);
			
			ОсновныеСотрудникиФизическихЛицМОЛ = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(ВыборкаПоНМА.МОЛ, Истина, Ссылка.Организация, Ссылка.Дата);
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицМОЛ) Тогда
				Для каждого Строка Из ОсновныеСотрудникиФизическихЛицМОЛ Цикл
				    ДанныеФизЛицаПолучил = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);			
				КонецЦикла;
				Для каждого СтрокаДанныеПолучил Из ДанныеФизЛицаПолучил Цикл			
					ОбластьМакета.Параметры.МОЛДолжность = СтрокаДанныеПолучил.Должность;
					ОбластьМакета.Параметры.МОЛФИО 		 = СтрокаДанныеПолучил.ФизическоеЛицо;			
				КонецЦикла;
			КонецЕсли;
 	
			Параметры.ФИОРук      = ОтветственныеЛицаОрганизации[Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления.Руководитель.Имя + "Наименование"];
			Параметры.ФИОБух      = ОтветственныеЛицаОрганизации[Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления.ГлавныйБухгалтер.Имя + "Наименование"];
			
			ТабДокумент.Вывести(ОбластьМакета);
			НеНачало = Истина;
			
		КонецЦикла;
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции // ПечатьНА3()

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	УчетНМА.ЗаполнитьВходящиеДанныеАмортизации(ВходящиеДанные);
	
	ЗакрытиеМесяцаУТВызовСервера.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли