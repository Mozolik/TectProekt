﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе клиента
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияПродаж.Валюта;
	ВалютаВзаиморасчетов = УсловияПродаж.Валюта;
	НаправлениеДеятельности = УсловияПродаж.НаправлениеДеятельности;
	
	ЦенаВключаетНДС       = УсловияПродаж.ЦенаВключаетНДС;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация <> Организация Тогда
		Организация = УсловияПродаж.Организация;
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    			= Организация;
		СтруктураПараметров.НаправлениеДеятельности = НаправлениеДеятельности;
		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И УсловияПродаж.Контрагент <> Контрагент Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(
			ПараметрыОбъектаССоглашением(),
			Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья,
			ВалютаВзаиморасчетов);
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, , Договор);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьУсловияРасчетов(УсловияПродаж);
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияПродаж.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ДатаНачала = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в заказе клиента
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура (
				"ТолькоТиповые,
				|УчитыватьГруппыСкладов,
				|ИсключитьГруппыСкладовДоступныеВЗаказах,
				|ХозяйственнаяОперация,
				|ВыбранноеСоглашение",
				Истина,
				Истина,
				Истина,
				Перечисления.ХозяйственныеОперации.РеализацияКлиенту,
				Справочники.СоглашенияСКлиентами.ПустаяСсылка()));
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение) Тогда
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	АдресДоставки = ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(Партнер);
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "Продукция";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	СформироватьСписокЗависимыхЗаказов();
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение И АвторасчетНДС И НДСИсходящийКлиентСервер.НуженАвторасчетНДС(Продукция,,,,,,СтавкаНДС) Тогда
		// соответствие для хранения погрешностей округлений
		ПогрешностиОкругления = Новый Соответствие();
		// пересчет сумм НДС с учетом ошибок округления
		НДСИсходящийКлиентСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(Продукция, ЭтотОбъект, ЦенаВключаетНДС, ПогрешностиОкругления, "Продукция", Строка(Валюта),,,,,,,СтавкаНДС);
		
		ОбщегоНазначенияУТКлиентСервер.ЗаполнитьЗначенияСвойствКоллекции(Продукция, 0, "СуммаВзаиморасчетов");
	КонецЕсли;
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(
		Продукция,
		ЦенаВключаетНДС);
	
	ЗаполнитьСуммуВзаиморасчетов();
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Продукция");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Продукция);
		
	КонецЕсли;
	
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи);
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ПараметрыОбъектаССоглашением());
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		// Заполнение из формы списка распоряжений.
		Если ДанныеЗаполнения.Свойство("ДокументОснование") И ДанныеЗаполнения.Свойство("ДатаОтгрузки")
			 И (ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.ЗаказДавальца")
				Или ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("Массив")) Тогда
			
			// Если передана дата отгрузки-заполняем по ней.
			Если ЗначениеЗаполнено(ДанныеЗаполнения.ДатаОтгрузки) Тогда
				Дата = ДанныеЗаполнения.ДатаОтгрузки;
			Иначе
				// Дата отгрузки берется максимально возможная для заказа.
				Дата = ЗаказыСервер.ПолучитьМаксимальнуюДатуОтгрузкиЗаказа(ДанныеЗаполнения.ДокументОснование);
			КонецЕсли;
			
			ДанныеЗаполнения.Свойство("РеквизитыШапки", РеквизитыШапки);
			
			ЗаполнитьДокументНаОснованииЗаказаКлиента(ДанныеЗаполнения.ДокументОснование, Истина, РеквизитыШапки);
			
		Иначе
			
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
			
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказДавальца") Тогда
		
		ЗаполнитьДокументНаОснованииЗаказаКлиента(ДанныеЗаполнения, Ложь);
		
	Иначе
		
		ИнициализироватьУсловияПродаж();
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
    ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияКассыПриФОИспользоватьНесколькоКассЛожь", Ложь);
    ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

#Область ДокХарактеристики
	
	ПроверятьХарактеристику = Ложь;
	
	Если Не Номенклатура.Пустая() Тогда
		
		МассивВариантов = Новый Массив;
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры);
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры);
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры);
		
		ПроверятьХарактеристику = Не (МассивВариантов.Найти(Номенклатура.ИспользованиеХарактеристик) = Неопределено);
		
	КонецЕсли;
	
	Если Не ПроверятьХарактеристику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	КонецЕсли;

#КонецОбласти

#Область ТчХарактеристикиКоличество
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "Продукция";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "Продукция";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);

#КонецОбласти

#Область ДокДатаплатежа
	
	МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежа");
	Если Не ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Продукция.КодСтроки");
		
	КонецЕсли;

#КонецОбласти

#Область НаправлениеДеятельности

	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
#КонецОбласти

#Область ИсключимПроверенныеРеквизитыИзДальнейшейПроверки
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

#КонецОбласти

#Область ПроверкаОстальныхРеквизитов
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;

#КонецОбласти

#Область ПроверкаКорректностиЗаполненияДокумента
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект,Отказ);
	
#КонецОбласти

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетДавальцу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаказыСервер.ОтразитьУслугиДавальцуКОформлению(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьВыручкуИСебестоимостьПродаж(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	ЗатратыСервер.ОтразитьВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	НДСИсходящийСервер.ОтразитьНДСНоменклатурныйСоставДляНалоговыхНакладных(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ДатаПлатежа  = Дата(1,1,1);
	Согласован   = Ложь;
	ЗаказДавальца = Неопределено;
	
	Для Каждого ТекСтрока Из Продукция Цикл
		
		ТекСтрока.ЗаказДавальца = Неопределено;
		ТекСтрока.КодСтроки    = 0;
		
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьСуммуВзаиморасчетов()
	
	Если Продукция.НайтиСтроки(Новый Структура("СуммаВзаиморасчетов", 0)).Количество() = 0 Тогда
		
		СуммаВзаиморасчетов = Продукция.Итог("СуммаВзаиморасчетов");
		
	Иначе
		
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииЗаказаКлиента(Знач ДокументОснование,Знач ЗаполнятьНаДатуОказанияУслуг = Истина, РеквизитыЗаказа = Неопределено)
	
	ТипОснования = ТипЗнч(ДокументОснование);
	ОтобратьПоЗаказу = Истина;
	
	Если ТипОснования = Тип("ДокументСсылка.ЗаказДавальца") Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		// *** Основные реквизиты
		|	ЗаказДавальца.Ссылка                    КАК ЗаказДавальца,
		|	ЗаказДавальца.Сделка                    КАК Сделка,
		|	ЗаказДавальца.Статус                    КАК СтатусДокумента,
		|	ЗаказДавальца.Организация               КАК Организация,
		|	ЗаказДавальца.БанковскийСчет            КАК БанковскийСчетОрганизации,
		|	ЗаказДавальца.Подразделение             КАК Подразделение,
		// *** Реквизиты оплаты
		|	ЗаказДавальца.ПорядокРасчетов           КАК ПорядокРасчетов,
		|	ЗаказДавальца.ФормаОплаты               КАК ФормаОплаты,
		|	ЗаказДавальца.ГруппаФинансовогоУчета    КАК ГруппаФинансовогоУчета,
		|	ЗаказДавальца.Касса                     КАК Касса,
		|	ЗаказДавальца.Валюта                    КАК Валюта,
		|	ЗаказДавальца.Валюта                    КАК ВалютаВзаиморасчетов,
		|	ЗаказДавальца.ГрафикОплаты              КАК ГрафикОплаты,
		|	ЗаказДавальца.НаправлениеДеятельности   КАК НаправлениеДеятельности,
		// *** Информация о партнере
		|	ЗаказДавальца.Партнер                   КАК Партнер,
		|	ЗаказДавальца.Контрагент                КАК Контрагент,
		|	ЗаказДавальца.Договор                   КАК Договор,
		|	ЗаказДавальца.КонтактноеЛицо            КАК КонтактноеЛицо,
		|	ЗаказДавальца.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
		// *** НДС
		|	ЗаказДавальца.ЦенаВключаетНДС           КАК ЦенаВключаетНДС,
		|	ЗаказДавальца.НалоговоеНазначение       КАК НалоговоеНазначение,
		|	ЗаказДавальца.СтавкаНДС                 КАК СтавкаНДС,
		// *** Реквизиты услуги
		|	ЗаказДавальца.Номенклатура              КАК Номенклатура,
		|	ЗаказДавальца.Характеристика            КАК Характеристика,
		|	ЗаказДавальца.Содержание                КАК Содержание,
		// *** Ошибки запонления
		|	(НЕ ЗаказДавальца.Проведен)             КАК ЕстьОшибкиПроведен,
		|	ВЫБОР КОГДА ЗаказДавальца.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовДавальцев.КОтгрузке)
		|			ИЛИ ЗаказДавальца.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовДавальцев.Закрыт) ТОГДА
		|		ЛОЖЬ
		|	ИНАЧЕ
		|		ИСТИНА
		|	КОНЕЦ                                   КАК ЕстьОшибкиСтатус
		|
		|ИЗ
		|	Документ.ЗаказДавальца КАК ЗаказДавальца
		|
		|ГДЕ
		|	ЗаказДавальца.Ссылка = &ЗаказДавальца");
		
		Запрос.УстановитьПараметр("ЗаказДавальца", ДокументОснование);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		РеквизитыЗаказа = РезультатЗапроса.Выбрать();
		РеквизитыЗаказа.Следующий();
		
		МассивДопустимыхСтатусов = Новый Массив;
		МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовДавальцев.КОтгрузке);
		МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовДавальцев.Закрыт);
		
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
			РеквизитыЗаказа.ЗаказДавальца,
			РеквизитыЗаказа.СтатусДокумента,
			РеквизитыЗаказа.ЕстьОшибкиПроведен,
			РеквизитыЗаказа.ЕстьОшибкиСтатус,
			МассивДопустимыхСтатусов);
		
		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаказа);
		
	ИначеЕсли ТипОснования = Тип("Массив") Тогда
		
		// Заполнение шапки.
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаказа);
		
		Валюта                    = ВалютаВзаиморасчетов;
		БанковскийСчетОрганизации = РеквизитыЗаказа.БанковскийСчетОрганизации;
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
		Если Не ЗначениеЗаполнено(БанковскийСчетОрганизации) Тогда
			
			СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
			СтруктураПараметров.Организация    			= Организация;
			СтруктураПараметров.НаправлениеДеятельности = НаправлениеДеятельности;
			СтруктураПараметров.БанковскийСчет 			= БанковскийСчетОрганизации;
			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(БанковскийСчетКонтрагента) Тогда
			
			БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(
				Контрагент,
				,
				БанковскийСчетКонтрагента);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипОснования = Тип("Массив") Тогда
		МассивЗаказов = ДокументОснование;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ЗаказДавальца);
	КонецЕсли;
	
	// Заполнение т.ч. услуги.
	Документы.ОтчетДавальцу.ЗаполнитьПоОстаткамУслугДавальцаКОформлению(
		ЭтотОбъект,
		Продукция,
		МассивЗаказов,
		ЗаполнятьНаДатуОказанияУслуг,
		Истина);
	
	ЗаказыСервер.ЗаполнитьЗаказВШапкеПоЗаказамВТабличнойЧасти(
		ЗаказДавальца,
		Продукция,
		"ЗаказДавальца");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)

	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияПродажПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер                  = Пользователи.ТекущийПользователь();
    Валюта                    = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
    ВалютаВзаиморасчетов      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);	
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    = Организация;
	СтруктураПараметров.БанковскийСчет = БанковскийСчетОрганизации;
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация  = Организация;
	СтруктураПараметров.Касса		 = Касса;
	Касса                     = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
	
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
	ПорядокРасчетов           = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ПараметрыОбъектаССоглашением());
	
	АвторасчетНДС                     = ЗначениеНастроекПовтИсп.ПолучитьФлагАвторасчетНДС(Организация, Дата);

	МестоСоставленияДокумента         = ПродажиСервер.ПолучитьМестоСоставленияДокумента(Метаданные().Имя, Менеджер);
	ПредставительОрганизации          = Менеджер.ФизическоеЛицо;
	ПредставительОрганизацииДолжность = ДолжностиДляПечатиКлиентСервер.ДолжностьФизическогоЛица(ПредставительОрганизации, Организация, Дата);
	
КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация, ПорядокРасчетов";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСКлиентами.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

Процедура ЗаполнитьУсловияРасчетов(Знач УсловияПродаж)
	
	ФормаОплаты = УсловияПродаж.ФормаОплаты;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация = Организация Тогда
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация  			= Организация;
		СтруктураПараметров.ФормаОплаты		 		= ФормаОплаты;
		СтруктураПараметров.НаправлениеДеятельности	= НаправлениеДеятельности;

		Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГрафикОплаты)
	 И (Не ЗначениеЗаполнено(ЗаказДавальца) Или ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным) Тогда
		ДатаПлатежа = ПродажиСервер.ПолучитьПоследнююДатуПоГрафику(Дата, УсловияПродаж.ГрафикОплаты, Справочники.СоглашенияСКлиентами.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	// Контроль выполняется при проведении / отмене проведения не нового документа.
	Массив.Добавить(Движения.УслугиДавальцуКОформлению);
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.РасчетыСКлиентами);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура СформироватьСписокЗависимыхЗаказов()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказДавальца КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказДавальца КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В (ВЫБРАТЬ
	|			ТоварыДокумента.ЗаказДавальца
	|		ИЗ
	|			Документ.ОтчетДавальцу.Продукция КАК ТоварыДокумента
	|		ГДЕ
	|			ТоварыДокумента.Ссылка = &Ссылка)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|";
	
	Запрос.УстановитьПараметр("МассивЗаказов", ЭтотОбъект.Продукция.ВыгрузитьКолонку("ЗаказДавальца"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	МассивЗависимыхЗаказов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовКлиентов", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
