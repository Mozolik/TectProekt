﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПодготовитьФормуНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьИнвентарныеНомераОС();
			Если Объект.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность") Тогда 
				ЗаполнитьТаблицуНачальнойНалоговойСтоимости();
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНачальнойНалоговойСтоимости()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Новый Граница(НачалоМесяца(Объект.Дата), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СписокОС", Объект.ОС.Выгрузить(,"ОсновноеСредство").ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ втСчетаУчета
		|ИЗ
		|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство В (&СписокОС)) КАК СчетаБухгалтерскогоУчетаОССрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СчетУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НалоговыеНазначенияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	НалоговыеНазначенияОССрезПоследних.НалоговоеНазначение
		|ПОМЕСТИТЬ втНалоговыеНазначения
		|ИЗ
		|	РегистрСведений.НалоговыеНазначенияОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство В (&СписокОС)) КАК НалоговыеНазначенияОССрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
		|	ВЫБОР
		|		КОГДА втНалоговыеНазначения.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
		|			ТОГДА ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстатокДт, 0)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтоимостьОСБУ,
		|	втНалоговыеНазначения.НалоговоеНазначение
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В
		|				(ВЫБРАТЬ
		|					втСчетаУчета.СчетУчета
		|				ИЗ
		|					втСчетаУчета КАК втСчетаУчета),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|			Организация = &Организация
		|				И Субконто1 В (&СписокОС)) КАК ХозрасчетныйОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ втНалоговыеНазначения КАК втНалоговыеНазначения
		|		ПО ХозрасчетныйОстатки.Субконто1 = втНалоговыеНазначения.ОсновноеСредство";
	
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		ТаблицаОсновныхСредств = Объект.ОС.Выгрузить();
		
		ТаблицаРезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
		Для каждого ТекСтрока Из ТаблицаРезультатЗапроса Цикл
			
			Если ТекСтрока.НалоговоеНазначение <> Объект.НалоговоеНазначение Тогда
				Сообщение = Новый СообщениеПользователю();
			    Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Для ОС <%1> нал. назначение указанное в документе <%2> не совпадает с нал. назначением по данным учета <%3>';uk='Для ОЗ <%1> под. призначення зазначене в документі <%2> не збігається з под. призначенням за даними обліку <%3>'"), 
								ТекСтрока.ОсновноеСредство, Объект.НалоговоеНазначение, ТекСтрока.НалоговоеНазначение);
			    Сообщение.Сообщить();
			КонецЕсли; 
			
			Отбор = Новый Структура();
			Отбор.Вставить("ОсновноеСредство",ТекСтрока.ОсновноеСредство);
			Строки = ТаблицаОсновныхСредств.НайтиСтроки(Отбор);
			Если Строки.Количество() > 0 Тогда
			    Строки[0].НачальнаяСтоимостьНУ = ТекСтрока.СтоимостьОСБУ;
			КонецЕсли;
			
		КонецЦикла; 
		
		Объект.ОС.Загрузить(ТаблицаОсновныхСредств);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомераОС();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомераОС();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаКлиенте
Процедура НачислениеАмортизацииПриИзменении(Элемент)
	
	Элементы.ГруппаОтражение.Доступность = (Объект.НачислениеАмортизации = 1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицы

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
	Иначе
		СтрокаТЧ.ИнвентарныйНомер = УчетОСВызовСервера.ПолучитьИнвентарныйНомерОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
	КонецЕсли;
	
	Если Объект.НалоговоеНазначение = ПредопределенноеЗначение("Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность") 
			И ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтруктураСтрокаТЧ = ПолучитьДанныеСтрокиТаблицы(СтрокаТЧ);
		СтрокаТЧ.НачальнаяСтоимостьНУ = ЗаполнистьСтоимостиИСуммыСтрокиТаблицыОС("НачальнаяСтоимостьНУ",СтруктураСтрокаТЧ);
	КонецЕсли;
	СтрокаТЧ.СтавкаНДС = "";
	СтрокаТЧ.СуммаНДС  = 0;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	
	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	 
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление,
		"СтатьяРасходов, АналитикаРасходов");
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ОперацияПередачи = Перечисления.ХозяйственныеОперацииРеглУчет.ПеремещениеОСвПодразделениеВыделенноеНаБаланс;
	
	Элементы.ГруппаОтражение.Доступность = (Объект.НачислениеАмортизации = 1);
	ОбновитьДоступностьЭлементовФормы();		
	ЗаполнитьИнвентарныеНомераОС();
	
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Тогда
		Элементы.Организация.Видимость = (Объект.ХозяйственнаяОперация <> ОперацияПередачи);
	КонецЕсли;

	Если Реквизиты.Свойство("НалоговоеНазначение") Тогда
		Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка();
	КонецЕсли;
	
	Если ОбновитьВсе ИЛИ Реквизиты.Свойство("НалоговоеНазначение") Тогда
		
		Элементы.НовоеНалоговоеНазначение.Доступность = ЗначениеЗаполнено(Объект.НалоговоеНазначение);
		
		Если ЗначениеЗаполнено(Объект.НалоговоеНазначение) Тогда
			
			НовоеНалоговоеНазначениеСписок = Элементы.НовоеНалоговоеНазначение.СписокВыбора;
			НовоеНалоговоеНазначениеСписок.Очистить();
			
			Если Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая Тогда
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность);
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально Тогда
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность Тогда
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая);
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая);
				НовоеНалоговоеНазначениеСписок.Добавить(Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность);
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЕсли;

	
	
	Если ОбновитьВсе ИЛИ Реквизиты.Свойство("НовоеНалоговоеНазначение") Тогда
		
			КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
			
			Если Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность   
					 Тогда
					 
					 УстановитьВидимостьСтавкаСуммаНДС(Истина);
					 
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность   
					 Тогда
					  
					  УстановитьВидимостьСтавкаСуммаНДС(Истина);
					 
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность   
					 Тогда
					  
					  УстановитьВидимостьСтавкаСуммаНДС(Истина);
					 
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая   
					 Тогда
					   
					   УстановитьВидимостьСтавкаСуммаНДС(Истина);
					  
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность   
					 Тогда
					
					 УстановитьВидимостьСтавкаСуммаНДС(Ложь);
					
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая   
					 Тогда
					 
					 УстановитьВидимостьСтавкаСуммаНДС(Истина);
					 
			ИначеЕсли Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность 
					И Объект.НовоеНалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность   
					 Тогда
					 
					 УстановитьВидимостьСтавкаСуммаНДС(Ложь);
					 
			Иначе
					 УстановитьВидимостьСтавкаСуммаНДС(Истина);
			
			КонецЕсли;
			
			Элементы.ОСНачальнаяСтоимостьНУ.Видимость = Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность;
		КонецЕсли;

КонецПроцедуры
	
&НаСервере
Процедура УстановитьВидимостьСтавкаСуммаНДС(ЗначениеВидимости)
	Элементы.ОССтавкаНДС.Видимость = ЗначениеВидимости;
	Элементы.ОССуммаНДС.Видимость  = ЗначениеВидимости;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнвентарныеНомераОС()
	
	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	
	ТаблицаНомеров = УчетОСВызовСервера.ПолучитьТаблицуИнвентарныхНомеровОС(
		ТаблицаОС, Объект.Организация, Объект.Дата);
		
	Для Каждого Строка Из ТаблицаНомеров Цикл
		Объект.ОС[Строка.НомерСтроки-1].ИнвентарныйНомер = Строка.ИнвентарныйНомер;
	КонецЦикла;			

КонецПроцедуры
 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УчетОСВызовСервера.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговоеНазначениеПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("НалоговоеНазначение");
	ОбновитьДоступностьЭлементовФормы("НовоеНалоговоеНазначение");
КонецПроцедуры

&НаКлиенте
Процедура НовоеНалоговоеНазначениеПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("НовоеНалоговоеНазначение");
КонецПроцедуры

&НаКлиенте
Процедура ОССтавкаНДСПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.ОсновноеСредство) Тогда
		 СтруктураСтрокаТЧ = ПолучитьДанныеСтрокиТаблицы(СтрокаТЧ);
		 СтрокаТЧ.СуммаНДС = ЗаполнистьСтоимостиИСуммыСтрокиТаблицыОС("СуммаНДС",СтруктураСтрокаТЧ);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДанныеСтрокиТаблицы(СтрокаТаблицы)
	
	ДанныеСтрокиТаблицы	= Новый Структура(
	"ОсновноеСредство,
	|СуммаНДС,СтавкаНДС,
	|НачальнаяСтоимостьНУ");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТаблицы);
	
	Возврат ДанныеСтрокиТаблицы;
	
КонецФункции // ПолучитьДанныеСтрокиТаблицы()


&НаСервере
Функция ЗаполнистьСтоимостиИСуммыСтрокиТаблицыОС(ВозвращаемыйРезультат,СтрокаТЧ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Новый Граница(НачалоМесяца(Объект.Дата), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ОсновноеСредство", СтрокаТЧ.ОсновноеСредство);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
		|ПОМЕСТИТЬ втСчетаУчета
		|ИЗ
		|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОССрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СчетУчета,
		|	СчетНачисленияАмортизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НалоговыеНазначенияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	НалоговыеНазначенияОССрезПоследних.НалоговоеНазначение
		|ПОМЕСТИТЬ втНалоговыеНазначения
		|ИЗ
		|	РегистрСведений.НалоговыеНазначенияОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство = &ОсновноеСредство) КАК НалоговыеНазначенияОССрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстатокДт, 0) КАК СтоимостьОСБУ,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаНУОстатокДт, 0) КАК СтоимостьОСНУ
		|ПОМЕСТИТЬ втСтоимость
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В
		|				(ВЫБРАТЬ
		|					втСчетаУчета.СчетУчета
		|				ИЗ
		|					втСчетаУчета КАК втСчетаУчета),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстатокКт, 0) КАК АмортизацияБУ,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаНУОстатокКт, 0) КАК АмортизацияНУ
		|ПОМЕСТИТЬ втАмортизация
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В
		|				(ВЫБРАТЬ
		|					втСчетаУчета.СчетНачисленияАмортизации
		|				ИЗ
		|					втСчетаУчета КАК втСчетаУчета),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втСтоимость.ОсновноеСредство,
		|	ЕСТЬNULL(втСтоимость.СтоимостьОСБУ,0) - ЕСТЬNULL(втАмортизация.АмортизацияБУ,0) КАК ОстаточнаяСтоимостьБУ,
		|	ЕСТЬNULL(втСтоимость.СтоимостьОСНУ,0) - ЕСТЬNULL(втАмортизация.АмортизацияНУ,0) КАК ОстаточнаяСтоимостьНУ,
		|	втНалоговыеНазначения.НалоговоеНазначение КАК  НалоговоеНазначение,
		|	ВЫБОР
		|		КОГДА втНалоговыеНазначения.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
		|			ТОГДА втСтоимость.СтоимостьОСБУ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НачальнаяСтоимостьНУ
		|ИЗ
		|	втСтоимость КАК втСтоимость
		|		ЛЕВОЕ СОЕДИНЕНИЕ втАмортизация КАК втАмортизация
		|		ПО втСтоимость.ОсновноеСредство = втАмортизация.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ втНалоговыеНазначения КАК втНалоговыеНазначения
		|		ПО втСтоимость.ОсновноеСредство = втНалоговыеНазначения.ОсновноеСредство";
	
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		СтоимостиТаблицыОС = Запрос.Выполнить().Выгрузить();
		
		СтоимостиОС = СтоимостиТаблицыОС[0];
		
		Если СтоимостиОС.НалоговоеНазначение <> Объект.НалоговоеНазначение Тогда
				Сообщение = Новый СообщениеПользователю();
			    Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Для ОС <%1> нал. назначение указанное в документе <%2> не совпадает с нал. назначением по данным учета <%3>';uk='Для ОЗ <%1> под. призначення зазначене в документі <%2> не збігається з под. призначенням за даними обліку <%3>'"), 
								СтоимостиОС.ОсновноеСредство, Объект.НалоговоеНазначение, СтоимостиОС.НалоговоеНазначение);
			    Сообщение.Сообщить();
			КонецЕсли;
		
		Если ВозвращаемыйРезультат = "СуммаНДС" Тогда
			
			СуммаНДС 		 = 0;
			СуммаВключаетНДС = Объект.НалоговоеНазначение.ВидДеятельностиНДС = Перечисления.ВидыДеятельностиНДС.Необлагаемая;
			СтавкаНДСЧислом  = НДСОбщегоНазначенияКлиентСервер.ПолучитьСтавкуНДСЧислом(СтрокаТЧ.СтавкаНДС);
			ЕстьНалогНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация,Объект.Дата);
			
			Если ЕстьНалогНаПрибыль И НЕ Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
				// от остаточной стоимости НУ
				ОстаточнаяСтоимость = СтоимостиОС.ОстаточнаяСтоимостьНУ;
			Иначе	
				// для ЕН и страрого налогового назначения Необл. Нехоз.
					ОстаточнаяСтоимость = СтоимостиОС.ОстаточнаяСтоимостьБУ;
			КонецЕсли;

		Если СуммаВключаетНДС Тогда
			СуммаНДС = ОстаточнаяСтоимость*СтавкаНДСЧислом/(СтавкаНДСЧислом+1);
		Иначе
			СуммаНДС = ОстаточнаяСтоимость*СтавкаНДСЧислом; 
		КонецЕсли;  
	      	Возврат СуммаНДС;
			
		ИначеЕсли ВозвращаемыйРезультат = "НачальнаяСтоимостьНУ" Тогда
			
			Возврат СтоимостиОС.НачальнаяСтоимостьНУ ;
			
		КонецЕсли; 
		
	КонецЕсли; 
		
КонецФункции


#КонецОбласти

