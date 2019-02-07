﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.СписаниеНМАМеждународныйУчет) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.СписаниеНМАМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.СписаниеНМАМеждународныйУчет);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет";
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

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru='Списание НМА (международный учет)';uk='Списання НМА (міжнародний облік)'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	МеждународныйУчетВнеоборотныеАктивы.ОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.Международный(ТекстыЗапроса, Регистры, Международный(ТекстыЗапроса));
	НематериальныеАктивыМеждународныйУчет(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы) КАК ВидСубконтоОбъектаАмортизации,
	|	ДанныеДокумента.НематериальныйАктив,
	|	ДанныеДокумента.СчетРасходов,
	|	ДанныеДокумента.СчетРасходовСубконто1,
	|	ДанныеДокумента.СчетРасходовСубконто2,
	|	ДанныеДокумента.СчетРасходовСубконто3
	|ИЗ
	|	Документ.СписаниеНМАМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Если НачалоДня(Реквизиты.Период) = НачалоМесяца(Реквизиты.Период) Тогда
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.ТаблицаАмортизационныхРасходов();
	Иначе
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.АмортизационныеРасходыПоНМА(
			Реквизиты.Период,
			Реквизиты.Организация,
			Реквизиты.НематериальныйАктив);
	КонецЕсли;
	ОшибкиШаблоновПроводок = МеждународныйУчетВнеоборотныеАктивы.ОшибкиЗаполненияШаблоновПроводокАмортизации(
		Реквизиты.Период,
		Реквизиты.Организация,
		ТаблицаАмортизационныеРасходы.ВыгрузитьКолонку("СтатьяРасходов"));
	
	Если ОшибкиШаблоновПроводок <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиШаблоновПроводок);
		ВызватьИсключение НСтр("ru='Требуется настроить счета расходов амортизации в шаблоне проводок для операции ""Амортизация внеоборотных активов""';uk='Потрібно настроїти рахунки витрат амортизації в шаблоні проводок для операції ""Амортизація необоротних активів""'");
	КонецЕсли;
	
	МеждународныйУчетВнеоборотныеАктивы.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Реквизиты.Период));
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Период, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ТаблицаАмортизации", ТаблицаАмортизационныеРасходы);
	Запрос.УстановитьПараметр("СписаниеОстаточнойСтоимости", Истина);
	
	Если ТипЗнч(Реквизиты.СчетРасходовСубконто1) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто1);
	ИначеЕсли ТипЗнч(Реквизиты.СчетРасходовСубконто2) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто2);
	ИначеЕсли ТипЗнч(Реквизиты.СчетРасходовСубконто3) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто3);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса)
	
	ИмяТаблицы = "втОбъектыДокумента";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица втОбъектыДокумента
	|"+
	"ВЫБРАТЬ
	|	Состояния.НематериальныйАктив,
	|	Состояния.СчетУчета,
	|	Состояния.СчетАмортизации
	|ПОМЕСТИТЬ втОбъектыДокумента
	|ИЗ
	|	РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(
	|			&Граница,
	|			НематериальныйАктив = &НематериальныйАктив
	|				И Регистратор <> &Ссылка) КАК Состояния" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ВременнаяТаблицаВидыСубконтоСчетаРасходов(ТекстыЗапроса)
	
	ИмяТаблицы = "втВидыСубконтоСчетаРасходов";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица втВидыСубконтоСчетаРасходов
	|"+
	"ВЫБРАТЬ
	|	ЕСТЬNULL(Субконто1.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто1,
	|	ВЫБОР
	|		КОГДА Субконто1.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто1
	|	КОНЕЦ КАК Субконто1,
	|	ЕСТЬNULL(Субконто2.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто2,
	|	ВЫБОР
	|		КОГДА Субконто2.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто2
	|	КОНЕЦ КАК Субконто2,
	|	ЕСТЬNULL(Субконто3.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто3,
	|	ВЫБОР
	|		КОГДА Субконто3.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто3
	|	КОНЕЦ КАК Субконто3
	|ПОМЕСТИТЬ втВидыСубконтоСчетаРасходов
	|ИЗ
	|	ПланСчетов.Международный КАК СчетРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто1
	|		ПО СчетРасходов.Ссылка = Субконто1.Ссылка
	|			И (Субконто1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто2
	|		ПО СчетРасходов.Ссылка = Субконто2.Ссылка
	|			И (Субконто2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто3
	|		ПО СчетРасходов.Ссылка = Субконто3.Ссылка
	|			И (Субконто3.НомерСтроки = 3)
	|ГДЕ
	|	СчетРасходов.Ссылка = &СчетРасходов" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура НематериальныеАктивыМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НематериальныеАктивыМеждународныйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица НематериальныеАктивыМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	ТаблицаДокумента.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан) КАК Состояние
	|ИЗ
	|	втОбъектыДокумента КАК ТаблицаДокумента"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Функция Международный(ТекстыЗапроса)
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	ВременнаяТаблицаВидыСубконтоСчетаРасходов(ТекстыЗапроса);
	МеждународныйУчетВнеоборотныеАктивы.ВременнаяТаблицаНачисленнаяАмортизация(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ // Списание стоимости объекта со счета учета
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	&Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	&СчетРасходов КАК СчетДт,
	|	ВидыСубконто.ВидСубконто1 КАК ВидСубконтоДт1,
	|	ВидыСубконто.Субконто1 КАК СубконтоДт1,
	|	ВидыСубконто.ВидСубконто2 КАК ВидСубконтоДт2,
	|	ВидыСубконто.Субконто2 КАК СубконтоДт2,
	|	ВидыСубконто.ВидСубконто3 КАК ВидСубконтоДт3,
	|	ВидыСубконто.Субконто3 КАК СубконтоДт3,
	|	
	|	&Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.СчетУчета КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.НематериальныйАктив КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстаток,0) КАК Сумма,
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаПредставленияОстаток,0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	втОбъектыДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						втОбъектыДокумента.СчетУчета
	|					ИЗ
	|						втОбъектыДокумента),
	|				,
	|				Организация = &Организация
	|					И Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							втОбъектыДокумента.НематериальныйАктив
	|						ИЗ
	|							втОбъектыДокумента)) КАК ДанныеСчетУчета
	|		ПО СтрокиДокумента.НематериальныйАктив = ДанныеСчетУчета.Субконто1
	|			И СтрокиДокумента.СчетУчета = ДанныеСчетУчета.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВидыСубконтоСчетаРасходов КАК ВидыСубконто
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ ДанныеСчетУчета.Счет ЕСТЬ NULL
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Вычитание начисленной амортизации со счета списания
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	&Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.СчетАмортизации КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.НематериальныйАктив КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	&Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	&СчетРасходов КАК СчетКт,
	|	ВидыСубконто.ВидСубконто1 КАК ВидСубконтоКт1,
	|	ВидыСубконто.Субконто1 КАК СубконтоКт1,
	|	ВидыСубконто.ВидСубконто2 КАК ВидСубконтоКт2,
	|	ВидыСубконто.Субконто2 КАК СубконтоКт2,
	|	ВидыСубконто.ВидСубконто3 КАК ВидСубконтоКт3,
	|	ВидыСубконто.Субконто3 КАК СубконтоКт3,
	|	
	|	(-ЕСТЬNULL(ДанныеСчетАмортизации.СуммаОстаток,0))
	|		+ ЕСТЬNULL(СтрокиАмортизации.Сумма,0) КАК Сумма,
	|	(-ЕСТЬNULL(ДанныеСчетАмортизации.СуммаПредставленияОстаток,0))
	|		+ ЕСТЬNULL(СтрокиАмортизации.СуммаПредставления,0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	втОбъектыДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачисленнаяАмортизация КАК СтрокиАмортизации
	|		ПО СтрокиДокумента.НематериальныйАктив = СтрокиАмортизации.ОбъектАмортизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						втОбъектыДокумента.СчетАмортизации
	|					ИЗ
	|						втОбъектыДокумента),
	|				,
	|				Организация = &Организация
	|					И Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							втОбъектыДокумента.НематериальныйАктив
	|						ИЗ
	|							втОбъектыДокумента)) КАК ДанныеСчетАмортизации
	|		ПО СтрокиДокумента.НематериальныйАктив = ДанныеСчетАмортизации.Субконто1
	|			И СтрокиДокумента.СчетАмортизации = ДанныеСчетАмортизации.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВидыСубконтоСчетаРасходов КАК ВидыСубконто
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ (ДанныеСчетАмортизации.Счет ЕСТЬ NULL И СтрокиАмортизации.ОбъектАмортизации ЕСТЬ NULL)";
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	ВходящиеДанные.Вставить(Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыБухгалтерии.Международный);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ВыработкаНМА);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НаработкиОбъектовЭксплуатации);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НематериальныеАктивыМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ОсновныеСредстваМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаОтраженияВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаУточненияСчетовВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета);
	
	ЗакрытиеМесяцаУТВызовСервера.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли