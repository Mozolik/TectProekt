﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
	Иначе
		
		ОтражатьВБухгалтерскомУчете = Истина;
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОтражатьВБухгалтерскомУчете И НЕ ОтражатьВНалоговомУчете Тогда
		
		ТекстСообщения = НСтр("ru='Документ должен отражаться в бухгалтерском или налоговом учете.';uk='Документ повинен відображатися в бухгалтерському або податковому обліку.'");
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", НСтр("ru='Отражать в бух. / налог. учете';uk='Відображати в бух. / податк. обліку'"), , , ТекстСообщения );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОтражатьВБухгалтерскомУчете", , Отказ);
		
	КонецЕсли;
	
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ИзменениеСостоянияОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
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

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		Если Основание.ЭтоГруппа Тогда
			ТекстСообщения = НСтр("ru='Ввод изменения состояния ОС на основании группы ОС невозможен!
                |Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз'
                |;uk='Введення зміни стану ОЗ на підставі групи ОЗ неможливе!
                |Виберіть ОЗ. Для розкриття групи використовуйте клавіші Ctrl і стрілку вниз'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание.Ссылка;
		
	КонецЕсли;
	
	ОтражатьВБухгалтерскомУчете = Истина;
	
	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОСВызовСервера.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВводВЭксплуатацию);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Реквизиты.Ссылка КАК Регистратор,
		|	Реквизиты.Дата КАК Период,
		|	Реквизиты.Номер,
		|	Реквизиты.Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка
		|ИЗ
		|	Документ.ИзменениеСостоянияОС КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
