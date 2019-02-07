﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НачисленнаяАмортизация.Количество() <> 0 Тогда
		НачисленнаяАмортизация.Очистить();
	КонецЕсли;
	
	ТекстОшибки = НСтр("ru='Требуются настройки отражения %1 по амортизации в регламентированном учете';uk='Потрібні настройки відображення %1 по амортизації в регламентованому обліку'");
	УчетЦФ = ПолучитьФункциональнуюОпцию("ИспользоватьУчетВнеоборотныхАктивовПоНаправлениямДеятельности");
	ТекстОшибки = СтрШаблон(ТекстОшибки, ?(УчетЦФ, НСтр("ru='доходов и расходов';uk='доходів і витрат'"), НСтр("ru='расходов';uk='витрат'")));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И Не ДополнительныеСвойства.Свойство("ВыполненаПроверкаНастроекОтражения")
		И РегистрыСведений.ПорядокОтраженияРасходов.ЕстьОшибкиЗаполненияРасходовПоАмортизацииОС(Организация, КонецМесяца(Дата))
		Или (УчетЦФ И РегистрыСведений.ПорядокОтраженияДоходов.ЕстьОшибкиЗаполненияДоходовЦелевогоФинансированияОС(Организация, КонецМесяца(Дата))) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,, "ДекорацияОшибка", Отказ);
		
	КонецЕсли;
	
	УчетОСВызовСервера.ПроверитьСпособыОтраженияРасходовНаПрочиеАктивы(ЭтотОбъект, Отказ);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РассчитатьАмортизацию(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ОчиститьЗаписатьДвижения(Движения, "Хозрасчетный");
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Документы.АмортизацияОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ПорядокОтраженияПрочихОпераций");
	
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСервер.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Если Не Отказ Тогда
		
		Результат = РеглУчетПроведениеСервер.ОтразитьДокумент(
			Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата, Организация),,
			МенеджерВременныхТаблицНачисленнойАмортизации());
		
		Если Результат <> Перечисления.СтатусыОтраженияДокументовВРеглУчете.ОтраженоВРеглУчете Тогда
			
			ВызватьИсключение ПолучитьТекстОшибкиОтражения();
			
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МенеджерВременныхТаблицНачисленнойАмортизации()
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("ТаблицаАмортизации", ДополнительныеСвойства.НачисленнаяАмортизация);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(&Организация КАК Справочник.Организации) КАК Организация,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.ОбъектУчета КАК Справочник.ОбъектыЭксплуатации) КАК ОбъектУчета,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.Подразделение КАК Справочник.СтруктураПредприятия) КАК Подразделение,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СуммаБУ КАК ЧИСЛО) КАК СуммаБУ,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СуммаНУ КАК ЧИСЛО) КАК СуммаНУ,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СуммаПР КАК ЧИСЛО) КАК СуммаПР,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СуммаВР КАК ЧИСЛО) КАК СуммаВР,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.Коэффициент КАК ЧИСЛО) КАК Коэффициент,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СтатьяРасходов КАК ПланВидовХарактеристик.СтатьиРасходов) КАК СтатьяРасходов,
	|	ТаблицаАмортизации.АналитикаРасходов КАК АналитикаРасходов,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.НалоговоеНазначениеКт КАК Справочник.НалоговыеНазначенияАктивовИЗатрат) КАК НалоговоеНазначениеКт,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СуммаУменьшенияДооценки КАК ЧИСЛО) КАК СуммаУменьшенияДооценки,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.ПередаватьРасходыВДругуюОрганизацию КАК Булево) КАК ПередаватьРасходыВДругуюОрганизацию,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.ОрганизацияПолучательРасходов КАК Справочник.Организации) КАК ОрганизацияПолучательРасходов,
	|	ВЫРАЗИТЬ(ТаблицаАмортизации.СчетПередачиРасходов КАК ПланСчетов.Хозрасчетный) КАК СчетПередачиРасходов
	|ПОМЕСТИТЬ втТаблицаАмортизации
	|ИЗ
	|	&ТаблицаАмортизации КАК ТаблицаАмортизации";
	
	Запрос.Выполнить();
	Возврат ВременныеТаблицы;
	
КонецФункции

Процедура РассчитатьАмортизацию(Отказ)
	
	ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.НачисленнаяАмортизация(
		Неопределено, ТаблицаРеквизитовДокумента(), Отказ);
	
	ДополнительныеСвойства.Вставить("НачисленнаяАмортизация", ТаблицаНачисленнаяАмортизация);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер КАК Номер,
		|	&Организация КАК Организация,
		|	"""" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьТекстОшибкиОтражения()
	
	ТекстОшибки = НСтр("ru='Не удалось отразить документ в регл. учете. %Комментарий';uk='Не вдалося відобразити документ в регл. обліку. %Комментарий'");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеРегистра.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВРеглУчете КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Регистратор = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат СтрЗаменить(ТекстОшибки, "%Комментарий", Выборка.Комментарий);
	КонецЕсли;
	
	Возврат СтрЗаменить(ТекстОшибки, "%Комментарий", "");
	
КонецФункции

#КонецОбласти

#КонецЕсли
