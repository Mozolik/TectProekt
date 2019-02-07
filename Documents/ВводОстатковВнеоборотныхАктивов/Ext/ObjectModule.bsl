﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ИнициализироватьДокумент();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
		
	Если ТипОперации <> Перечисления.ТипыОперацийВводаОстатков.ОстаткиОС Тогда
		ОС.Очистить();
		Иначе
			Для Каждого Строка Из ОС Цикл
				ОчиститьНеИспользуемыеРеквизитыОС(Строка);
			КонецЦикла;
	КонецЕсли;
	
	Если ТипОперации <> Перечисления.ТипыОперацийВводаОстатков.ОстаткиНМА Тогда
		НМА.Очистить();
	Иначе
		Для каждого Строка Из НМА Цикл
			ОчиститьНеИспользуемыеРеквизитыНМА(Строка);
		КонецЦикла; 
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОчиститьНеИспользуемыеРеквизитыОС(Описание)
	
	Если Описание.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
		Описание.НачислятьАмортизациюНУ = Ложь;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ОчиститьНеИспользуемыеРеквизитыНМА(Описание)
	
	Если Описание.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
		
		Описание.НачислятьАмортизациюНУ = Ложь;
		Описание.СпособНачисленияАмортизацииНУ = Неопределено;
		
		Описание.ПервоначальнаяСтоимостьНУ = 0;
		Описание.НакопленнаяАмортизацияНУ  = 0;
		
		Описание.СрокПолезногоИспользованияНУ = 0;
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	
	Если ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиОС Тогда
		УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
		
		ПроверкаОСНеПринятыКУчетуВДругихОрганизациях(Отказ);
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
	КонецЕсли;
	
	Если ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиНМА Тогда
		
		УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
	КонецЕсли;
	
	
	ТабличныеЧасти = Новый Структура;
	ТабличныеЧасти.Вставить(
		"ОС",
		"СтатьяРасходовАмортизации, АналитикаРасходовАмортизации");
	ТабличныеЧасти.Вставить("НМА", "СтатьяРасходовАмортизации, АналитикаРасходовАмортизации");
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект, ТабличныеЧасти, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВводОстатковВнеоборотныхАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ОтражениеДокументовВРеглУчете");
	
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСервер.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	Массив = Новый Массив;
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
КонецПроцедуры


Процедура ПроверкаОСНеПринятыКУчетуВДругихОрганизациях(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТаблицаОС", ОС.Выгрузить());
	
	Запрос.Текст = "
	|// Таблица ОС
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	ВЫРАЗИТЬ(ТаблицаОС.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации) КАК ОсновноеСредство,
	|	ТаблицаОС.ДатаПринятияКУчету КАК ДатаПринятияКУчетуРегл
	|ПОМЕСТИТЬ
	|	ВТ_ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	ДатаПринятияКУчетуРегл
	|;
	|
	|// Все принятия к учету ОС по другим организациям
	|ВЫБРАТЬ
	|	Рег.ОсновноеСредство КАК ОсновноеСредство,
	|	Рег.Организация КАК Организация,
	|	Рег.ДатаСостояния КАК ДатаСостояния,
	|	Рег.Состояние
	|ПОМЕСТИТЬ ВТ_ПринятияКУчету
	|ИЗ
	|	РегистрСведений.СостоянияОСОрганизаций КАК Рег
	|ГДЕ
	|	Рег.ОсновноеСредство В (ВЫБРАТЬ ВТ_ТаблицаОС.ОсновноеСредство ИЗ ВТ_ТаблицаОС)
	|	И Рег.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)
	|	И Рег.Организация <> &Организация
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	ДатаСостояния
	|;
	|
	|// Все списания ОС по другим организациям
	|ВЫБРАТЬ
	|	Рег.ОсновноеСредство КАК ОсновноеСредство,
	|	Рег.Организация КАК Организация,
	|	Рег.ДатаСостояния КАК ДатаСостояния,
	|	Рег.Состояние
	|ПОМЕСТИТЬ ВТ_СнятияСУчета
	|ИЗ
	|	РегистрСведений.СостоянияОСОрганизаций КАК Рег
	|ГДЕ
	|	Рег.ОсновноеСредство В (ВЫБРАТЬ ВТ_ТаблицаОС.ОсновноеСредство ИЗ ВТ_ТаблицаОС)
	|	И Рег.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета)
	|	И Рег.Организация <> &Организация
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	ДатаСостояния
	|;
	|
	|// Поиск ОС, которые в других организациях были приняты к  учету, но не списаны, т.е. еще находятся в учете
	|ВЫБРАТЬ
	|	ВТ_ТаблицаОС.Организация                   КАК Организация,
	|	ВТ_ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство,
	|	ВТ_ТаблицаОС.ОсновноеСредство.Наименование КАК ОсновноеСредствоНаименование,
	|	ВТ_ТаблицаОС.ОсновноеСредство.Код          КАК КодОсновногоСредства,
	|	ВТ_ТаблицаОС.ДатаПринятияКУчетуРегл        КАК ДатаПринятияКУчетуРегл,
	|	ЕСТЬNULL(Рег_ПринятиеКУчету.ДатаСостояния, ДАТАВРЕМЯ(1,1,1))                           КАК ДатаПринятияКУчетуВДругойОрганизации,
	|	ЕСТЬNULL(Рег_ПринятиеКУчету.Организация,ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ОрганизацияПринятияКУчету,
	|	ЕСТЬNULL(Рег_СнятияСУчета.ДатаСостояния, ДАТАВРЕМЯ(3999,12,31))                        КАК ДатаСнятияСУчетаВДругойОрганизации,
	|	ЕСТЬNULL(Рег_СнятияСУчета.Организация,ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))   КАК ОрганизацияСнятияСУчета
	|
	|ИЗ
	|	ВТ_ТаблицаОС
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	|		ВЫБРАТЬ
	|			МАКСИМУМ(Рег.ДатаСостояния),
	|			Рег.ОсновноеСредство КАК ОсновноеСредство,
	|			Рег.Организация КАК Организация
	|		ИЗ
	|		ВТ_ПринятияКУчету КАК Рег
	|		СГРУППИРОВАТЬ ПО
	|			Рег.ОсновноеСредство,
	|			Рег.Организация
	|	) КАК Рег_ПринятиеКУчету
	|	ПО
	|		ВТ_ТаблицаОС.Организация <> Рег_ПринятиеКУчету.Организация
	|		И ВТ_ТаблицаОС.ОсновноеСредство = Рег_ПринятиеКУчету.ОсновноеСредство
	|		И ВТ_ТаблицаОС.ДатаПринятияКУчетуРегл >= Рег_ПринятиеКУчету.ДатаСостояния
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	|		ВЫБРАТЬ
	|			МАКСИМУМ(Рег.ДатаСостояния),
	|			Рег.ОсновноеСредство КАК ОсновноеСредство,
	|			Рег.Организация КАК Организация
	|		ИЗ
	|		ВТ_СнятияСУчета КАК Рег
	|		СГРУППИРОВАТЬ ПО
	|			Рег.ОсновноеСредство,
	|			Рег.Организация
	|	) КАК Рег_СнятияСУчета
	|	ПО
	|		Рег_ПринятиеКУчету.Организация = Рег_СнятияСУчета.Организация
	|		И ВТ_ТаблицаОС.ОсновноеСредство = Рег_СнятияСУчета.ОсновноеСредство
	|		И ВТ_ТаблицаОС.ДатаПринятияКУчетуРегл >= Рег_СнятияСУчета.ДатаСостояния
	|
	|// Надо выбрать только те ОС, по которым в других организациях есть принятие к учету и нет списания, или списание раньше
	|ГДЕ
	|	ЕСТЬNULL(Рег_СнятияСУчета.ДатаСостояния, ДАТАВРЕМЯ(3999,12,31)) > ДатаПринятияКУчетуРегл
	|	И НЕ Рег_ПринятиеКУчету.Организация ЕСТЬ NULL
	|";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока Выборка.Следующий() Цикл
			НайденнаяСтрока = ОС.Найти(Выборка.ОсновноеСредство, "ОсновноеСредство");
			Если НайденнаяСтрока <> Неопределено Тогда
				Префикс = "ОС[" + Формат(НайденнаяСтрока.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В строках %1 Основное средство %2 (%3) %4 уже было принято к учету в организации %5';uk='У рядках %1 Основний засіб %2 (%3) %4 вже було прийнято до обліку в організації %5'"),
					НайденнаяСтрока.НомерСтроки,
					Выборка.ОсновноеСредствоНаименование,
					Выборка.КодОсновногоСредства,
					Формат(Выборка.ДатаПринятияКУчетуВДругойОрганизации, "ДЛФ=DD"),
					Выборка.ОрганизацияПринятияКУчету);
				Поле = Префикс + "ОсновноеСредство";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли