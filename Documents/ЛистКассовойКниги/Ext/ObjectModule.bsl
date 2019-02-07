﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Если КассовыеОрдера.Количество() > 0 Тогда
		КассовыеОрдера.Очистить();
	КонецЕсли;
	ИнициализироватьДокумент(Неопределено);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеТабличнойЧасти(Отказ);
	ПроверитьДублиДокумента(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Дата <> КонецДня(Дата) Тогда
		Дата = КонецДня(Дата);
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КассовыеОрдера.Документ КАК Документ,
	|	КассовыеОрдера.Приход КАК Приход,
	|	КассовыеОрдера.Расход КАК Расход
	|	
	|ПОМЕСТИТЬ КассовыеОрдера
	|ИЗ
	|	&КассовыеОрдера КАК КассовыеОрдера
	|;
	|////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммаПриход), 0) КАК СуммаПоступления,
	|	ЕСТЬNULL(СУММА(СуммаРасход), 0) КАК СуммаВыдачи
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Обороты(,, Регистратор) КАК ДенежныеСредства
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		КассовыеОрдера КАК КассовыеОрдера
	|	ПО
	|		КассовыеОрдера.Документ = ДенежныеСредства.Регистратор
	|");
	
	Запрос.УстановитьПараметр("КассовыеОрдера", ЭтотОбъект.КассовыеОрдера.Выгрузить(, "Документ, Приход, Расход"));
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаОрдеров = Результат[1].Выбрать();
	ВыборкаОрдеров.Следующий();
	СуммаПоступления = ВыборкаОрдеров.СуммаПоступления;
	СуммаВыдачи = ВыборкаОрдеров.СуммаВыдачи;
	
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Кассы.Ссылка КАК Касса
	|ПОМЕСТИТЬ Кассы
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|	И Кассы.ВалютаДенежныхСредств = &ВалютаДенежныхСредств	
	|	И Кассы.ОбособленноеПодразделениеОрганизации = &ОбособленноеПодразделениеОрганизации
	|;
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеСредстваНаличныеОстатки.СуммаОстаток КАК СуммаОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(
	|		&КонецПредыдущегоДня,
	|		Организация = &Организация
	|		И Касса В (ВЫБРАТЬ Кассы.Касса ИЗ Кассы)) КАК ДенежныеСредстваНаличныеОстатки
	|");
	
	Запрос.УстановитьПараметр("КонецПредыдущегоДня", НачалоДня(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", ВалютаДенежныхСредств);
	
	СуммаКонечныйОстаток = Запрос.Выполнить().Выгрузить()[0].СуммаОстаток
		+ СуммаПоступления - СуммаВыдачи;
	
	ЗаполнитьНомераЛистов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализаицияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	ВыводитьКаждыйДокументВОтдельнойСтроке = ПолучитьПоследнееЗначениеРеквизитаВыводитьКаждыйДокументВОтдельнойСтроке();
	
КонецПроцедуры

Функция ПолучитьПоследнееЗначениеРеквизитаВыводитьКаждыйДокументВОтдельнойСтроке()

	ЗначениеРеквизита = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЛистКассовойКниги.ВыводитьКаждыйДокументВОтдельнойСтроке
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ЛистКассовойКниги
	|ГДЕ
	|	НЕ ЛистКассовойКниги.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЛистКассовойКниги.МоментВремени УБЫВ";
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
	    ЗначениеРеквизита = Выборка.ВыводитьКаждыйДокументВОтдельнойСтроке;
	КонецЕсли;
	
	Возврат ЗначениеРеквизита;

КонецФункции
 

#КонецОбласти

#Область Прочее

Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Документ КАК Документ
	|
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК Таблица
	|ГДЕ
	|	Таблица.Документ <> НЕОПРЕДЕЛЕНО
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента.Документ КАК Документ
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Документ
	|ИМЕЮЩИЕ 
	|	КОЛИЧЕСТВО (*) > 1
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Документ КАК Документ,
	|	ВЫБОР КОГДА НАЧАЛОПЕРИОДА(ТаблицаДокумента.Документ.Дата, ДЕНЬ) <> НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяДата,
	|	ВЫБОР КОГДА ТаблицаДокумента.Документ.Организация <> &Организация ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяОрганизация,
	|	ВЫБОР КОГДА ТаблицаДокумента.Документ.Валюта <> &ВалютаДенежныхСредств ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяВалюта,
	|	ВЫБОР КОГДА ТаблицаДокумента.Документ.Касса.ОбособленноеПодразделениеОрганизации <> &ОбособленноеПодразделениеОрганизации ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяОбособленноеПодразделение,
	|	Не ТаблицаДокумента.Документ.Проведен КАК ДокументНеПроведен
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|");
	ТаблицаДокумента = КассовыеОрдера.Выгрузить(, "НомерСтроки, Документ");
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", ВалютаДенежныхСредств);
	Если ИспользованиеОбособленногоПодразделения() Тогда
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
	Иначе
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Массив = Запрос.ВыполнитьПакет();
	
	// Массив[0] - временная таблица "ТаблицаДокумента"
	РезультатЗапросаДубли = Массив[1];
	РезультатЗапросаДокументы = Массив[2];
	
	// Проверяем дубли строк в документе.
	Выборка = РезультатЗапросаДубли.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Документ %1 повторяется в табличной части';uk='Документ %1 повторюється в табличній частині'"),
			Выборка.Документ);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
			,
			Отказ);
		
	КонецЦикла;
	
	// Проверяем документы, указанные в табличной части.
	Выборка = РезультатЗапросаДокументы.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ДокументНеПроведен Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Указан не проведенный документ %1';uk='Зазначений не проведений документ %1'"),
				Выборка.Документ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
	
		// Проверяем соответствие даты документа и даты листа кассовой книги.
		Если Выборка.ОтличаетсяДата Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Дата документа %1 отличается от даты листа кассовой книги %2';uk='Дата документа %1 відрізняється від дати листа касової книги %2'"),
				Выборка.Документ,
				Формат(Дата, "ДЛФ=Д") );
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
	
		// Проверяем соответствие организации документа и листа кассовой книги.
		Если Выборка.ОтличаетсяОрганизация Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Организация документа %1 отличается от организации кассовой книги %2';uk='Організація документа %1 відрізняється від організації касової книги %2'"),
				Выборка.Документ,
				Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ);
		КонецЕсли;
		
		Если Выборка.ОтличаетсяВалюта Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Валюта документа %1 отличается от валюты кассовой книги %2';uk='Валюта документа %1 відрізняється від валюти касової книги %2'"),
				Выборка.Документ,
				ВалютаДенежныхСредств 
			);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ
			);
		КонецЕсли;
		
		// Проверяем соответствие обособленного подразделения организации документа и листа кассовой книги.
		Если Выборка.ОтличаетсяОбособленноеПодразделение Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Обособленное подразделение организации документа %1 отличается от обособленного подразделения организации листа кассовой книги %2';uk='Відокремлений підрозділ організації документа %1 відрізняється від відокремленого підрозділу організації аркуша касової книги %2'"),
				Выборка.Документ,
				ОбособленноеПодразделениеОрганизации 
			);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Документы", Выборка.НомерСтроки, "Документ"),
				,
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДублиДокумента(Отказ)
	
	// Проверка дублей документов за день
	ТекстЗапроса = 
	"
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ДокументКассоваяКнига.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ДокументКассоваяКнига
	|ГДЕ
	|	ДокументКассоваяКнига.Ссылка <> &ТекущийДокумент
	|	И ДокументКассоваяКнига.Организация = &Организация
	|	И ДокументКассоваяКнига.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|   И ДокументКассоваяКнига.ОбособленноеПодразделениеОрганизации = &ОбособленноеПодразделениеОрганизации
	|	И ДокументКассоваяКнига.Проведен
	|	И НачалоПериода(ДокументКассоваяКнига.Дата, ДЕНЬ) = &ДатаНач
	|";
		
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", ВалютаДенежныхСредств);
	ИспользоватьОбособленноеПодразделение = ИспользованиеОбособленногоПодразделения(); 
	Если ИспользоватьОбособленноеПодразделение Тогда
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
	Иначе
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Дата));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='На дату %1  уже существует проведенный документ: %2';uk='На дату %1 вже існує проведений документ: %2'"),
			Дата, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Дата",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНомераЛистов()
	
	Если КассовыеОрдера.Количество() > 0 Тогда
	
		ТекстЗапроса = " 
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	КассоваяКнигаДокументы.НомерЛиста КАК НомерЛиста,
		|	ДанныеДокумента.Дата КАК Период
		|ИЗ
		|	Документ.ЛистКассовойКниги КАК ДанныеДокумента
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК КассоваяКнигаДокументы
		|	ПО
		|		ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
		|ГДЕ
		|	ДанныеДокумента.Организация = &Организация
		|	И ДанныеДокумента.ОбособленноеПодразделениеОрганизации = &ОбособленноеПодразделениеОрганизации
		|	И ДанныеДокумента.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
		|	И ДанныеДокумента.Проведен
		|	И КассоваяКнигаДокументы.НомерЛиста <> 0
		|	И НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, ДЕНЬ) < НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		|	И НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, ГОД) = НАЧАЛОПЕРИОДА(&Дата, ГОД)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ,
		|	НомерЛиста УБЫВ
		|";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
		Запрос.УстановитьПараметр("ВалютаДенежныхСредств", ВалютаДенежныхСредств);
		Запрос.УстановитьПараметр("Дата", Дата);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ПоследнийНомер = Выборка.НомерЛиста;
		Иначе
			ПоследнийНомер = 0;
		КонецЕсли;
		
		НачальныйНомерЛиста = ПоследнийНомер + 1;
		ТекущийНомерЛиста = ПоследнийНомер + 1;
		
		Сч = 0;
		Для Каждого СтрокаТаблицы Из КассовыеОрдера Цикл
			
			Если СтрокаТаблицы.НомерЛиста <> ТекущийНомерЛиста Тогда
				СтрокаТаблицы.НомерЛиста = ТекущийНомерЛиста;
			КонецЕсли;
			
			КонечныйНомерЛиста = ТекущийНомерЛиста;
			
			Сч = Сч + 1;
			Если Сч >= КоличествоДокументовНаЛисте Тогда
				Сч = 0;
				ТекущийНомерЛиста = ТекущийНомерЛиста + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НачальныйНомерЛиста = КонечныйНомерЛиста Тогда
			ТекущиеНомераЛистов = НачальныйНомерЛиста;
		Иначе
			ТекущиеНомераЛистов = Строка(НачальныйНомерЛиста) + "-" + Строка(КонечныйНомерЛиста); 
		КонецЕсли;
		
	Иначе
		ТекущиеНомераЛистов = "";
	КонецЕсли;
		
	Если НомераЛистов <> ТекущиеНомераЛистов Тогда
		НомераЛистов = ТекущиеНомераЛистов;
	КонецЕсли;
	
КонецПроцедуры

Функция ИспользованиеОбособленногоПодразделения()
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениямОрганизация", Новый Структура("Организация", Организация));
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
