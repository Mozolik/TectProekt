﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПолучениеЗначенийНеобходимыхФО();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВерсияНастроек <> ТекущаяВерсияНастроек() Тогда
		ЗаполнитьДеревоНаборовДанных();
		ВерсияНастроек = ТекущаяВерсияНастроек();
	Иначе
		УстановитьВидимостьПоказателейВЗависимостиОтФО();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки = Новый Структура;
	Настройки.Вставить("НастройкиОтбора",Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Отчет.СравнительныйАнализПоказателейРаботыМенеджеров", "ФормаОтчета", Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	СхемаДляОтбораПользователей = Отчеты.СравнительныйАнализПоказателейРаботыМенеджеров.ПолучитьМакет("СхемаДляОтбораПользователей");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаДляОтбораПользователей,УникальныйИдентификатор);
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Отчет.СравнительныйАнализПоказателейРаботыМенеджеров", "ФормаОтчета");
	Если ЗначениеНастроек <> Неопределено И ЗначениеНастроек.НастройкиОтбора <> Неопределено Тогда
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ЗначениеНастроек.НастройкиОтбора);
		Отчет.КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	Отказ = ОтборыИНастройкиЗаполненыНеправильно();
	
	Если Не Отказ Тогда
		СформироватьОтчет();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	ПараметрыДляФормыНастроек = СтруктураФормыНастроек();
	Результат = Неопределено;

	ОткрытьФорму("Отчет.СравнительныйАнализПоказателейРаботыМенеджеров.Форма.ВыборНастроек",ПараметрыДляФормыНастроек,ЭтаФорма,,,, Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если Результат <> Неопределено Тогда
        
        ВыводитьДиаграммы         = Результат.ВыводитьДиаграммы;
        ВыводитьЛегенду           = Результат.ВыводитьЛегенду;
        ВыводитьТаблицы           = Результат.ВыводитьТаблицы;
        ПроцентнаяСтавка          = Результат.ПроцентнаяСтавка;
        Отчет.КомпоновщикНастроек = Результат.НастройкиКомпоновки;
        ОбработатьРезультатНаСервере(Результат.Показатели);
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтруктураПараметрыФормированияОтчета()
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("ДополнительныйПериодДляАнализа",ДополнительныйПериодДляАнализа);
	СтруктураПараметров.Вставить("ПериодФормированияОтчета",ПериодФормированияОтчета);
	СтруктураПараметров.Вставить("ПроцентнаяСтавка",ПроцентнаяСтавка);
	СтруктураПараметров.Вставить("ВыводитьДиаграммы",ВыводитьДиаграммы);
	СтруктураПараметров.Вставить("ВыводитьЛегенду",ВыводитьЛегенду);
	СтруктураПараметров.Вставить("ВыводитьТаблицы",ВыводитьТаблицы);
	СтруктураПараметров.Вставить("ДеревоНаборовДанных",ВременноеХранилищеНастроекНаСервере());
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ПолучениеЗначенийНеобходимыхФО()

	ФиксироватьПретензииКлиентов = ПолучитьФункциональнуюОпцию("ФиксироватьПретензииКлиентов");
	ИспользоватьВзаимодействия = ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент");
	ФиксироватьПервичныйИнтерес = ПолучитьФункциональнуюОпцию("ФиксироватьПервичныйИнтерес");
	ИспользоватьСделкиСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами");
	ИспользоватьРучныеСкидкиВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользуетсяКлассификацияПартнеров = ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли") 
	                                     ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВыручке")
	                                     ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж");
	
	ЕстьПраваНаВзаимодействия = ПравоДоступа("Чтение",Метаданные.Документы.Встреча) И 
	                            ПравоДоступа("Чтение",Метаданные.Документы.ТелефонныйЗвонок) И
	                            ПравоДоступа("Чтение",Метаданные.Документы.ЭлектронноеПисьмоВходящее) И
	                            ПравоДоступа("Чтение",Метаданные.Документы.ЭлектронноеПисьмоИсходящее)

КонецПроцедуры

&НаКлиенте
Функция ТекущаяВерсияНастроек()
	
	Возврат 1;
	
КонецФункции

&НаСервере
Процедура СформироватьОтчет()

	ТаблицаОтчета.Очистить();
	ОбъектОтчет =  РеквизитФормыВЗначение("Отчет");
	
	ОбъектОтчет.СформироватьОтчет(ТаблицаОтчета,СтруктураПараметрыФормированияОтчета());
	
КонецПроцедуры

&НаКлиенте
Функция ОтборыИНастройкиЗаполненыНеправильно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если (ПериодФормированияОтчета.ДатаНачала = Дата(1,1,1) ИЛИ  ПериодФормированияОтчета.ДатаОкончания = Дата(1,1,1)) И
		(ДополнительныйПериодДляАнализа = "ПредыдущийПериод" ИЛИ ДополнительныйПериодДляАнализа = "ПрошлыйГод") Тогда
		
		ТекстСообщения = НСтр("ru='В случае, когда используется дополнительный период для анализа, у основного периода должны быть указаны дата начала и дата конца.';uk='У випадку, коли використовується додатковий період для аналізу, у основного періоду повинні бути вказані дата початку та дата кінця.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ПериодФормированияОтчета",,Отказ);
		
	КонецЕсли;
	
	Если НЕ ВыводитьДиаграммы И НЕ ВыводитьТаблицы Тогда
		
		ТекстСообщения = НСтр("ru='В настройках формирования отчета, на закладке ""Прочее"", необходимо выбрать режим вывода.';uk='У настройках формування звіту, на закладці ""Інше"", необхідно вибрати режим виводу.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ВыводитьДиаграммы",,Отказ);
		
	КонецЕсли;
	
	Если ПроцентнаяСтавка = 0 Тогда
		
		ТекстСообщения = НСтр("ru='В настройках формирования отчета, на закладке ""Прочее"", необходимо указать процентную ставку для расчета финансовых потерь.';uk='У настройках формування звіту, на закладці ""Інше"", необхідно зазначити процентну ставку для розрахунку фінансових втрат.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ПроцентнаяСтавка",,Отказ);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Процедура ОбработатьРезультатНаСервере(АдресДереваПоказатели)
	
	ЗначениеВДанныеФормы(ПолучитьИзВременногоХранилища(АдресДереваПоказатели),ДеревоНастроек);
	
КонецПроцедуры

&НаСервере
Функция ВременноеХранилищеНастроекНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ДеревоНастроек"),УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьДеревоНаборовДанных()
	
	ДеревоНастроек.ПолучитьЭлементы().Очистить();

	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"ПродажиПрибыльВыручка",НСтр("ru='Продажи, прибыль, выручка';uk='Продажі, прибуток, виторг'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"Продажи",НСтр("ru='Продажи';uk='Продажі'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"Прибыль",НСтр("ru='Прибыль';uk='Прибуток'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПоступлениеДС",НСтр("ru='Поступление денежных средств';uk='Надходження грошових коштів'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПоступлениеДС_МинусСебестоимость",НСтр("ru='Выручка (по оплате) минус себестоимость (по отгрузке)';uk='Виторг (по оплаті) мінус собівартість (по відвантаженню)'"),Истина);
	
	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"СоблюдениеУсловийПродаж",НСтр("ru='Соблюдение условий продаж';uk='Дотримання умов продажів'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПотериПросроченнаяДебиторка",НСтр("ru='Потери в результате превышения сроков погашения дебиторской задолженности';uk='Втрати в результаті перевищення строків погашення дебіторської заборгованості'"),Истина);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПредоставленныеРучныеСкидки",НСтр("ru='Предоставленные ручные скидки';uk='Надані ручні знижки'"),ИспользоватьРучныеСкидкиВПродажах);
	
	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"ЭффективностьРаботы",НСтр("ru='Эффективность работы';uk='Ефективність роботи'"),ИспользоватьСделкиСКлиентами ИЛИ ИспользоватьВзаимодействия);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ЭффективностьВеденияСделок",НСтр("ru='Эффективность ведения сделок';uk='Ефективність ведення угод'"),ИспользоватьСделкиСКлиентами);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ЭффективностьВзаимодействий",НСтр("ru='Эффективность взаимодействий';uk='Ефективність взаємодій'"),ИспользоватьВзаимодействия И ИспользоватьСделкиСКлиентами);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПродажиНаОднуСделку",НСтр("ru='Продажи на одну сделку';uk='Продажі на одну угоду'"),ИспользоватьСделкиСКлиентами);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПродажиНаОдноВзаимодействие",НСтр("ru='Продажи на одно взаимодействие';uk='Продажі на одне взаємодія'"),ИспользоватьВзаимодействия);
	
	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"ПричиныПотерь",НСтр("ru='Причины потерь';uk='Причини втрат'"),ИспользоватьСделкиСКлиентами ИЛИ ФиксироватьПервичныйИнтерес);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ОсновныеЭтапыПотерь",НСтр("ru='Основные этапы потерь';uk='Основні етапи втрат'"),ИспользоватьСделкиСКлиентами);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПричиныПроигрышаСделок",НСтр("ru='Причины проигрыша сделок';uk='Причини програшу угод'"),ИспользоватьСделкиСКлиентами);
	НовыйЭлементДерева(ДобавленнаяСтрока,"НеудовлетворениеПервичногоСпроса",НСтр("ru='Причины неудовлетворения первичного спроса';uk='Причини незадоволення первинного попиту'"),ФиксироватьПервичныйИнтерес);
	
	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"ПривлечениеУдержаниеКлиентов",НСтр("ru='Привлечение и удержание клиентов';uk='Залучення і утримання клієнтів'"),ИспользуетсяКлассификацияПартнеров);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ДинамикаКлиентскойБазы",НСтр("ru='Динамика клиентской базы';uk='Динаміка клієнтської бази'"),ИспользуетсяКлассификацияПартнеров);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПродажиНовымКлиентам",НСтр("ru='Продажи новым клиентам';uk='Продажі новим клієнтам'"),ИспользуетсяКлассификацияПартнеров);
	
	ДобавленнаяСтрока = НовыйЭлементДерева(ДеревоНастроек,"ПоддержкаЛояльностиКлиентов",НСтр("ru='Поддержка лояльности клиентов';uk='Підтримка лояльності клієнтів'"),ФиксироватьПретензииКлиентов);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ВозникшиеПретензииКлиентов",НСтр("ru='Возникшие претензии клиентов';uk='Претензії клієнтів, що виникли'"),ФиксироватьПретензииКлиентов);
	НовыйЭлементДерева(ДобавленнаяСтрока,"ПричиныВозникновенияПретензий",НСтр("ru='Причины возникновения претензий клиентов';uk='Причини виникнення претензій клієнтів'"),ФиксироватьПретензииКлиентов);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьПоказателейВЗависимостиОтФО()
	
	СтрокаПредоставленныеРучныеСкидки      = ДеревоНастроек.ПолучитьЭлементы()[1].ПолучитьЭлементы()[1];
	СтрокаЭффективностьРаботы              = ДеревоНастроек.ПолучитьЭлементы()[2];
	СтрокаЭффективностьВеденияСделок       = ДеревоНастроек.ПолучитьЭлементы()[2].ПолучитьЭлементы()[0];
	СтрокаЭффективностьВзаимодействий      = ДеревоНастроек.ПолучитьЭлементы()[2].ПолучитьЭлементы()[1];
	СтрокаПродажиНаОднуСделку              = ДеревоНастроек.ПолучитьЭлементы()[2].ПолучитьЭлементы()[2];
	СтрокаПродажиНаОдноВзаимодействие      = ДеревоНастроек.ПолучитьЭлементы()[2].ПолучитьЭлементы()[3];
	СтрокаПричиныПотерь                    = ДеревоНастроек.ПолучитьЭлементы()[3];
	СтрокаОсновныеЭтапыПотерь              = ДеревоНастроек.ПолучитьЭлементы()[3].ПолучитьЭлементы()[0];
	СтрокаПричиныПроигрышаСделок           = ДеревоНастроек.ПолучитьЭлементы()[3].ПолучитьЭлементы()[1];
	СтрокаНеудовлетворениеПервичногоСпроса = ДеревоНастроек.ПолучитьЭлементы()[3].ПолучитьЭлементы()[2];
	СтрокаПривлечениеУдержаниеКлиентов     = ДеревоНастроек.ПолучитьЭлементы()[4];
	СтрокаДинамикаКлиентскойБазы           = ДеревоНастроек.ПолучитьЭлементы()[4].ПолучитьЭлементы()[0];
	СтрокаПродажиНовымКлиентам             = ДеревоНастроек.ПолучитьЭлементы()[4].ПолучитьЭлементы()[1];
	СтрокаПоддержкаЛояльностиКлиентов      = ДеревоНастроек.ПолучитьЭлементы()[5];
	СтрокаВозникшиеПретензииКлиентов       = ДеревоНастроек.ПолучитьЭлементы()[5].ПолучитьЭлементы()[0];
	СтрокаПричиныВозникновенияПретензий    = ДеревоНастроек.ПолучитьЭлементы()[5].ПолучитьЭлементы()[1];
	
	СтрокаПредоставленныеРучныеСкидки.ДоступностьСогласноФО = ИспользоватьРучныеСкидкиВПродажах;
	СтрокаЭффективностьРаботы.ДоступностьСогласноФО = (ИспользоватьСделкиСКлиентами ИЛИ ИспользоватьВзаимодействия);
	СтрокаЭффективностьВеденияСделок.ДоступностьСогласноФО = ИспользоватьСделкиСКлиентами;
	СтрокаЭффективностьВзаимодействий.ДоступностьСогласноФО = (ИспользоватьСделкиСКлиентами И ИспользоватьВзаимодействия И ЕстьПраваНаВзаимодействия);
	СтрокаПродажиНаОднуСделку.ДоступностьСогласноФО = ИспользоватьСделкиСКлиентами;
	СтрокаПродажиНаОдноВзаимодействие.ДоступностьСогласноФО = ИспользоватьВзаимодействия И ЕстьПраваНаВзаимодействия;
	СтрокаПричиныПотерь.ДоступностьСогласноФО = (ИспользоватьСделкиСКлиентами ИЛИ ФиксироватьПервичныйИнтерес);
	СтрокаОсновныеЭтапыПотерь.ДоступностьСогласноФО = ИспользоватьСделкиСКлиентами;
	СтрокаПричиныПроигрышаСделок.ДоступностьСогласноФО = ИспользоватьСделкиСКлиентами;
	СтрокаНеудовлетворениеПервичногоСпроса.ДоступностьСогласноФО = ФиксироватьПервичныйИнтерес;
	СтрокаПривлечениеУдержаниеКлиентов.ДоступностьСогласноФО = ИспользуетсяКлассификацияПартнеров;
	СтрокаДинамикаКлиентскойБазы.ДоступностьСогласноФО = ИспользуетсяКлассификацияПартнеров;
	СтрокаПродажиНовымКлиентам.ДоступностьСогласноФО = ИспользуетсяКлассификацияПартнеров;
	СтрокаПоддержкаЛояльностиКлиентов.ДоступностьСогласноФО = ФиксироватьПретензииКлиентов;
	СтрокаВозникшиеПретензииКлиентов.ДоступностьСогласноФО = ФиксироватьПретензииКлиентов;
	СтрокаПричиныВозникновенияПретензий.ДоступностьСогласноФО = ФиксироватьПретензииКлиентов;
	
	Если НЕ ИспользоватьРучныеСкидкиВПродажах Тогда
		СтрокаПредоставленныеРучныеСкидки.Включать = Ложь;
	КонецЕсли;
	
	Если НЕ (ИспользоватьСделкиСКлиентами ИЛИ ИспользоватьВзаимодействия) Тогда
		СтрокаЭффективностьРаботы.Включать = 0;
	КонецЕсли;
	
	Если НЕ (ИспользоватьСделкиСКлиентами И ИспользоватьВзаимодействия) ИЛИ (НЕ ЕстьПраваНаВзаимодействия) Тогда
		СтрокаЭффективностьВзаимодействий.Включать = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьСделкиСКлиентами Тогда
		СтрокаЭффективностьВеденияСделок.Включать = Ложь;
		СтрокаПродажиНаОднуСделку.Включать = Ложь;
		СтрокаОсновныеЭтапыПотерь.Включать = Ложь;
		СтрокаПричиныПроигрышаСделок.Включать = Ложь;
		СтрокаПричиныПроигрышаСделок.Включать = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьВзаимодействия ИЛИ (НЕ ЕстьПраваНаВзаимодействия) Тогда
		СтрокаПродажиНаОдноВзаимодействие.Включать = Ложь;
	КонецЕсли;
	
	Если НЕ (ИспользоватьСделкиСКлиентами ИЛИ ФиксироватьПервичныйИнтерес) Тогда
		СтрокаНеудовлетворениеПервичногоСпроса.Включать = 0;
	КонецЕсли;
	
	Если НЕ ФиксироватьПервичныйИнтерес Тогда
		СтрокаПричиныПотерь.Включать = 0;
	КонецЕсли;
	
	Если НЕ ФиксироватьПретензииКлиентов Тогда
		СтрокаПоддержкаЛояльностиКлиентов.Включать = Ложь;
		СтрокаВозникшиеПретензииКлиентов.Включать = Ложь;
		СтрокаПричиныВозникновенияПретензий.Включать = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НовыйЭлементДерева(Родитель,Имя,Наименование,ДоступностьПоФО)
	
	НоваяСтрока = Родитель.ПолучитьЭлементы().Добавить();
	НоваяСтрока.Имя = Имя;
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Включать = ДоступностьПоФО;
	НоваяСтрока.ДоступностьСогласноФО = ДоступностьПоФО;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция СтруктураФормыНастроек()

	ПараметрыДляФормыНастроек = Новый Структура();
	ПараметрыДляФормыНастроек.Вставить("ДеревоНастроек",ВременноеХранилищеНастроекНаСервере());
	ПараметрыДляФормыНастроек.Вставить("ВыводитьДиаграммы",ВыводитьДиаграммы);
	ПараметрыДляФормыНастроек.Вставить("ВыводитьТаблицы",ВыводитьТаблицы);
	ПараметрыДляФормыНастроек.Вставить("ВыводитьЛегенду",ВыводитьЛегенду);
	ПараметрыДляФормыНастроек.Вставить("ПроцентнаяСтавка",ПроцентнаяСтавка);
	ПараметрыДляФормыНастроек.Вставить("НастройкаКомпоновки",Отчет.КомпоновщикНастроек);
	ПараметрыДляФормыНастроек.Вставить("УИД_ВызывающейФормы",УникальныйИдентификатор);
	
	Возврат  ПараметрыДляФормыНастроек;

КонецФункции

#КонецОбласти
