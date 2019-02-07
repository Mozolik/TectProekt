﻿
#Область ПрограммныйИнтерфейс

#Область ОбработкаСкладскихЗаданийВФормах

//Меняет статус документов "Отбор (размещение) товаров" на "Выполнено без ошибок"
//
//	Параметры:
//		МассивДокументов - Массив - массив ссылок на документы, у которых нужно изменить статус
//		НазначитьИсполнителя - Булево - при установке статуса записывать исполнителя задания
//		Исполнитель - СправочникСсылка.Пользователи - если НазначитьИсполнителя = ИСТИНА, то в этом параметре передается
//					устанавливаемый исполнитель
//	Возвращаемое значение:
//		Массив - массив ссылок на документы, изменившие статус
//
Функция ОтметитьВыполненениеЗаданийБезОшибок(Знач МассивДокументов, НазначитьИсполнителя, Исполнитель = Неопределено) Экспорт	
	
	МассивИзмененныхДокументов = Новый Массив;
	Индекс = МассивДокументов.Количество();
	
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		СтрМас = МассивДокументов[Индекс];
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрМас, "Статус, Проведен");
		Если Не РеквизитыДокумента.Проведен Тогда 
			ТекстСообщения = НСтр("ru='Статус документа %Документ% не изменен: групповой обработкой можно изменять статусы только для проведенных документов.';uk='Статус документа %Документ% не змінено: груповою обробкою можна змінювати статуси тільки для проведених документів.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", СтрМас);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			МассивДокументов.Удалить(Индекс);
		ИначеЕсли РеквизитыДокумента.Статус <> Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено
			И РеквизитыДокумента.Статус <> Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе Тогда
			
			ТекстСообщения = НСтр("ru='Статус документа %Документ% не изменен: групповой обработкой статус %ВыполненоБезОшибок% можно установить только для документов в статусе %Подготовлено% или %ВРаботе%.';uk='Статус документа %Документ% не змінено: груповою обробкою статус %ВыполненоБезОшибок% можна встановити тільки для документів в статусі %Подготовлено% або %ВРаботе%.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", СтрМас);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВРаботе%", Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Подготовлено%", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВыполненоБезОшибок%", Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			МассивДокументов.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат МассивИзмененныхДокументов;
	КонецЕсли;
	
	Для Каждого СтрТабл из МассивДокументов Цикл
		ДокументОбъект = СтрТабл.ПолучитьОбъект();
		Попытка
			ДокументОбъект.Заблокировать();
			
			ДокументОбъект.Статус = Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок;
			Если НазначитьИсполнителя
				И ЗначениеЗаполнено(Исполнитель) Тогда
				ДокументОбъект.Исполнитель = Исполнитель;
			КонецЕсли;
			
			ОтказОтбор = Ложь;
			ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ДокументОбъект, Документы.ОтборРазмещениеТоваров);
			
			Если ДокументОбъект.ТоварыОтбор.Количество() > 0 Тогда
				НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ДокументОбъект,ПараметрыУказанияСерий.Отбор);
				НоменклатураСервер.ПроверитьЗаполнениеСерий(ДокументОбъект,ПараметрыУказанияСерий.Отбор,ОтказОтбор,Новый Массив);
			КонецЕсли;
			
			ОтказРазмещение = Ложь;
			Если ДокументОбъект.ТоварыРазмещение.Количество() > 0 Тогда
				НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ДокументОбъект,ПараметрыУказанияСерий.Размещение);
				НоменклатураСервер.ПроверитьЗаполнениеСерий(ДокументОбъект,ПараметрыУказанияСерий.Размещение,ОтказРазмещение,Новый Массив);
			КонецЕсли;
			
			Если Не ОтказОтбор
				И Не ОтказРазмещение Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				МассивИзмененныхДокументов.Добавить(СтрТабл);
			Иначе
				ТекстСообщения = НСтр("ru='Статус документа %Документ% не изменен.';uk='Статус документа %Документ% не змінений.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Документ%",ДокументОбъект.Ссылка);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке().Описание);
		КонецПопытки;
	КонецЦикла;
	
	Возврат МассивИзмененныхДокументов;
КонецФункции

//Меняет статус документов "Отбор (размещение) товаров" на "В работе"
//
//	Параметры:
//		МассивДокументов - Массив - массив ссылок на документы, у которых нужно изменить статус
//		НазначитьИсполнителя - Булево - при установке статуса записывать исполнителя задания
//		Исполнитель - СправочникСсылка.Пользователи - если НазначитьИсполнителя = ИСТИНА, то в этом параметре передается
//					устанавливаемый исполнитель
//	Возвращаемое значение:
//		Массив - массив ссылок на документы, изменившие статус
//
Функция ВзятьЗаданияВРаботу(Знач МассивДокументов, НазначитьИсполнителя, Исполнитель) Экспорт
		
	МассивИзмененныхДокументов = Новый Массив;
	
	Индекс = МассивДокументов.Количество();
	
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		СтрМас = МассивДокументов[Индекс];
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрМас, "Статус, Проведен");
		Если Не РеквизитыДокумента.Проведен Тогда 
			ТекстСообщения = НСтр("ru='Статус документа %Документ% не изменен: групповой обработкой можно изменять статусы только для проведенных документов.';uk='Статус документа %Документ% не змінено: груповою обробкою можна змінювати статуси тільки для проведених документів.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", СтрМас);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			МассивДокументов.Удалить(Индекс);
		ИначеЕсли РеквизитыДокумента.Статус <> Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено Тогда
			
			ТекстСообщения = НСтр("ru='Статус документа %Документ% не изменен: групповой обработкой статус %ВРаботе% можно установить только для документов в статусе %Подготовлено%.';uk='Статус документа %Документ% не змінено: груповою обробкою статус %ВРаботе% можна встановити тільки для документів в статусі %Подготовлено%.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", СтрМас);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВРаботе%", Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Подготовлено%", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			МассивДокументов.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат МассивИзмененныхДокументов;
	КонецЕсли;
	
	Для каждого СтрТабл из МассивДокументов Цикл
		Попытка
			ДокументОбъект = СтрТабл.ПолучитьОбъект();
			
			ДокументОбъект.Заблокировать();
			
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ДокументОбъект, "ДатаНачалаВыполнения") Тогда
				ДокументОбъект.ДатаНачалаВыполнения = ТекущаяДата();
			КонецЕсли;
			
			ДокументОбъект.Статус = Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе;
			Если НазначитьИсполнителя
				И ЗначениеЗаполнено(Исполнитель) Тогда
				ДокументОбъект.Исполнитель = Исполнитель;
			КонецЕсли;
			
			Если ДокументОбъект.ПроверитьЗаполнение() Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
				МассивИзмененныхДокументов.Добавить(ДокументОбъект.Ссылка);
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке().Описание);
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат МассивИзмененныхДокументов;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Серверный обработчик события ОбработкаПолученияДанныхВыбора справочника Склады.
//
Процедура СкладыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Перем ВыборГруппыСкладов, Дата, Склад,
		ИспользоватьОрдернуюСхемуПриОтгрузке,
		ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач,
		ИспользоватьОрдернуюСхемуПриПоступлении;
	
	//Проверяем и извлекаем параметры в переменные
	//	если передан хоть один обрабатываемый параметр - не используем стандартную обработку
	СтандартнаяОбработка = НЕ Параметры.Свойство("ВыборГруппыСкладов", ВыборГруппыСкладов);
	СтандартнаяОбработка = НЕ Параметры.Свойство("Склад", Склад) И СтандартнаяОбработка;
	Если Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриОтгрузке", Дата)
		ИЛИ Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач", Дата)
		ИЛИ Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриПоступлении", Дата) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	Если СтрокаПоиска = Неопределено Тогда
		СтрокаПоиска = "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка          КАК Склад,
	|	Склады.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Наименование ПОДОБНО &СтрокаПоиска
	|";
	
	//При наличии отбора по ордерной схеме необходимо учитывать дату начала использования ордерной схемы
	Если Параметры.Отбор.Свойство("ИспользоватьОрдернуюСхемуПриОтгрузке",
			ИспользоватьОрдернуюСхемуПриОтгрузке) Тогда
		ТекстУсловия = "
			|Склады.ИспользоватьОрдернуюСхемуПриОтгрузке";
		Если Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриОтгрузке")
			И ЗначениеЗаполнено(Дата) Тогда
			ТекстУсловия = ТекстУсловия + "
				|И &Дата >= Склады.ДатаНачалаОрдернойСхемыПриОтгрузке";
		КонецЕсли;
		Если НЕ ИспользоватьОрдернуюСхемуПриОтгрузке
			И ЗначениеЗаполнено(Дата) Тогда
			ТекстУсловия = "НЕ (" + ТекстУсловия +")";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + " И " + ТекстУсловия;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач",
			ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач) Тогда
		ТекстУсловия = "
			|Склады.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач";
		Если Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач")
			И ЗначениеЗаполнено(Дата) Тогда
			ТекстУсловия = ТекстУсловия + "
				|И &Дата >= Склады.ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач";
		КонецЕсли;
		Если НЕ ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда
			ТекстУсловия = "НЕ (" + ТекстУсловия +")";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + " И " + ТекстУсловия;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ИспользоватьОрдернуюСхемуПриПоступлении",
			ИспользоватьОрдернуюСхемуПриПоступлении) Тогда
		ТекстУсловия = "
				|Склады.ИспользоватьОрдернуюСхемуПриПоступлении";
		Если Параметры.Отбор.Свойство("ДатаНачалаОрдернойСхемыПриПоступлении") Тогда
			ТекстУсловия = ТекстУсловия + "
				|И &Дата >= Склады.ДатаНачалаОрдернойСхемыПриПоступлении";
		КонецЕсли;
		Если НЕ ИспользоватьОрдернуюСхемуПриПоступлении
			И ЗначениеЗаполнено(Дата) Тогда
			ТекстУсловия = "НЕ (" + ТекстУсловия +")";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + " И " + ТекстУсловия;
	КонецЕсли;
	
	Если Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
			|	И Склады.ЭтоГруппа";
	ИначеЕсли Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
			|	И НЕ Склады.ЭтоГруппа";
	КонецЕсли;
	
	// Если, например, в шапке Заказа выбрана группа складов, то при выборе склада в ТЧ нужно выбрать подчиненные
	Если ЗначениеЗаполнено(Склад) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
			|	И Склады.Ссылка В ИЕРАРХИИ(&Склад)
			|	И Склады.ВыборГруппы В (&ВыборГруппыСкладов)";
	
	ИначеЕсли ЗначениеЗаполнено(ВыборГруппыСкладов) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
			|	И (НЕ Склады.ЭтоГруппа
			|	ИЛИ Склады.ВыборГруппы В (&ВыборГруппыСкладов))";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|	УПОРЯДОЧИТЬ ПО Склады.Наименование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска + "%");
	Запрос.УстановитьПараметр("ВыборГруппыСкладов", ВыборГруппыСкладов);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Дата", Дата);

	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураВыбора = Новый Структура("Значение", Выборка.Склад);
			Если Выборка.ПометкаУдаления Тогда
				СтруктураВыбора.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
			КонецЕсли;
			ДанныеВыбора.Добавить(СтруктураВыбора);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Серверный обработчик события ОбработкаПолученияДанныхВыбора перечисления ВидыОперацийКорректировкиОрдераНаТовары.
//
Процедура ВидыОперацийКорректировкиОрдераНаТоварыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(
		Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОтразитьИзлишек, 
		Строка(Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОтразитьИзлишек));
	
	ДанныеВыбора.Добавить(
		Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОтразитьНедостачу, 
		Строка(Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОтразитьНедостачу));
		
	ДанныеВыбора.Добавить(
		Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ПеренестиВДругойОрдер,
		Строка(Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ПеренестиВДругойОрдер));	
	
КонецПроцедуры

// Серверный обработчик события ОбработкаПолученияДанныхВыбора перечисления СтатусыОрдеровНаПеремещение.
//
Процедура СтатусыОрдеровНаПеремещениеОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаПоиска = Параметры.СтрокаПоиска;
	Если СтрокаПоиска = Неопределено Тогда
		СтрокаПоиска = "";
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений();
	СтатусВПроцессеПроверки = Перечисления.СтатусыОрдеровНаПеремещение.ВПроцессеПроверки;
	Для Каждого Значение Из Перечисления.СтатусыОрдеровНаПеремещение Цикл
		Если Значение = СтатусВПроцессеПроверки Тогда
			Продолжить;
		КонецЕсли;
		Если СтрокаПоиска = Лев(Значение.Метаданные().Представление(),СтрДлина(СтрокаПоиска)) Тогда
			ДанныеВыбора.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьСкладПоУмолчанию(Знач Склад = Неопределено, УчитыватьГруппыСкладов = Ложь, ИсключитьГруппыДоступныеВЗаказах = Ложь) Экспорт
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, УчитыватьГруппыСкладов, ИсключитьГруппыДоступныеВЗаказах);
	
КонецФункции 

#КонецОбласти
