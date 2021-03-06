﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ДополнительныеСвойства.Вставить("КлючеваяОперация", "ПроведениеПереоценкаВалютныхСредств");
	ДополнительныеСвойства.Вставить("ВремяНачала", ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремениТехнологический("ПроведениеПереоценкаВалютныхСредств"));
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
		ПроверитьДублиДокументовТекущегоПериода(Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Если НЕ ДополнительныеСвойства.Свойство("ВыполненРасчет") Тогда
		ОчиститьНаборыЗаписейДвижений(ЭтотОбъект);
	КонецЕсли;
	
	Документы.ПереоценкаВалютныхСредств.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЭтотОбъект.Движения.РасчетыСПоставщикамиПоДокументам.Записывать     = Ложь;
	ЭтотОбъект.Движения.РасчетыСКлиентамиПоДокументам.Записывать        = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваБезналичные.Записывать          = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваНаличные.Записывать             = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваВКассахККМ.Записывать           = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваВПути.Записывать                = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваУПодотчетныхЛиц.Записывать      = Ложь;
	ЭтотОбъект.Движения.РасчетыПоДоговорамКредитовИДепозитов.Записывать = Ложь;
	//++ НЕ УТ
	ЭтотОбъект.Движения.ДенежныеДокументы.Записывать                    = Ложь;
	//-- НЕ УТ
	
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	КлючеваяОперация = Неопределено;
	ВремяНачала = Неопределено;
	Если ДополнительныеСвойства.Свойство("КлючеваяОперация", КлючеваяОперация)
		И ДополнительныеСвойства.Свойство("ВремяНачала", ВремяНачала) Тогда
		ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремениТехнологический(КлючеваяОперация, ВремяНачала);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПроверитьДублиДокументовТекущегоПериода(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ОтключитьПроверкуДублей") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка
	|ИЗ
	|	Документ.ПереоценкаВалютныхСредств КАК Т
	|ГДЕ
	|	Т.Проведен
	|	И Т.Организация = &Организация
	|	И Т.Дата МЕЖДУ &ПериодНачало И &ПериодОкончание
	|	И НЕ Т.Ссылка = &ТекущийДокумент
	|	И Т.ХозяйственнаяОперация = &Операция");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("ПериодНачало", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ПериодОкончание", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Операция", ХозяйственнаяОперация);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='В указанном периоде уже существует аналогичный документ. Операция не выполнена.';uk='У зазначеному періоді вже існує аналогічний документ. Операція не виконана.'"),,,,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьНаборыЗаписейДвижений(ЭтотОбъект)

	НаборыДвижений = Новый Массив;
	НаборыДвижений.Добавить("РасчетыСПоставщикамиПоДокументам");
	НаборыДвижений.Добавить("РасчетыСКлиентамиПоДокументам");
	НаборыДвижений.Добавить("ДенежныеСредстваБезналичные");
	НаборыДвижений.Добавить("ДенежныеСредстваНаличные");
	НаборыДвижений.Добавить("ДенежныеСредстваВКассахККМ");
	НаборыДвижений.Добавить("ДенежныеСредстваВПути");
	НаборыДвижений.Добавить("ДенежныеСредстваУПодотчетныхЛиц");
	НаборыДвижений.Добавить("РасчетыПоДоговорамКредитовИДепозитов");
	//++ НЕ УТ
	НаборыДвижений.Добавить("ДенежныеДокументы");
	//-- НЕ УТ
	
	Для Каждого ИмяНабора Из НаборыДвижений Цикл
		Набор = ЭтотОбъект.Движения[ИмяНабора];
		Набор.Очистить();
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
