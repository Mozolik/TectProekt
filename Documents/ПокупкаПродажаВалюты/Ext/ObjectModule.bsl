﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаПокупкуПродажуВалюты") Тогда
		
		ЗаполнитьДокументПоЗаявкеНаПокупкуПродажуВалюты(ДанныеЗаполнения, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ПокупкаПродажаВалюты.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации
	);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов
	);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов
	);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ПокупкаПродажаВалюты.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации
	);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации
	);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПокупкаПродажаВалюты.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоЗаявкеНаПокупкуПродажуВалюты(
	Знач ДокументОснование,
	ДанныеЗаполнения
	)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос;
	Запрос.Текст = "
	    |ВЫБРАТЬ
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДанныеДокумента.Банк КАК Банк,
		|	ДанныеДокумента.Валюта КАК Валюта,
		|	ДанныеДокумента.Ссылка КАК Заявка,
		|	ДанныеДокумента.СчетВалютный КАК СчетВалютный,
		|	ДанныеДокумента.СчетГривневый КАК СчетГривневый,
		|	ДанныеДокумента.СуммаГривневая КАК СуммаГривневая,
		|	ДанныеДокумента.СуммаВалютная КАК СуммаВалютная,
		|	ДанныеДокумента.СуммаКомиссионные КАК СуммаКомиссионные,
		|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ЗаявкаНаПокупкуПродажуВалюты КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не требуется вводить покупку-продажу валюты на основании документа %1';uk='Не потрібно вводити купівлю-продаж валюти на підставі документа %1'"),
			ДокументОснование
		);
		ВызватьИсключение Текст;
	Иначе
		ДанныеЗаполнения = Новый Структура;
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			ДанныеЗаполнения.Вставить(Колонка.Имя);
		КонецЦикла;
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();

		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);

		СтавкаНалогов = РегистрыСведений.ПараметрыНалоговогоУчета.ПолучитьСтавкуПФ(ТекущаяДата());
		
		Если ДанныеЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
			ДанныеЗаполнения.Вставить("СуммаПенсионный");
			ДанныеЗаполнения.СуммаПенсионный = ДанныеЗаполнения.СуммаГривневая*СтавкаНалогов;
			ДанныеЗаполнения.СуммаДокумента = ДанныеЗаполнения.СуммаГривневая + ДанныеЗаполнения.СуммаКомиссионные + ДанныеЗаполнения.СуммаПенсионный;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоУмолчанию()

	Ответственный = Пользователи.ТекущийПользователь();

	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	ЗаполнитьСтатьюРасходовПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьСтатьюРасходовПоУмолчанию()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов
	|ИЗ
	|	Документ.ПокупкаПродажаВалюты КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтатьяРасходов = Выборка.СтатьяРасходов;
		АналитикаРасходов = Выборка.АналитикаРасходов;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
