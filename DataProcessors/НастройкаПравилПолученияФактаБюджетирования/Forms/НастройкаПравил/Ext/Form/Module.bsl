﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипПравилСтатьяБюджета = Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные;
	ТипПравилПоказательБюджета = Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные;
	
	ОбъектНастройки = Параметры.ОбъектНастройки;
	
	ПерваяЧастьКлюча = "";
	Если ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.НастройкиХозяйственныхОпераций") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Хоз.операция';uk='Госп.операція'");
		Элементы.РасчетныеПоказатели.Видимость = Ложь;
		Элементы.ЦелевыеПоказатели.Видимость = Ложь;
		ПерваяЧастьКлюча = "1";
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Статья активов/пассивов';uk='Стаття активів/пасивів'");
		Элементы.СтатьиБюджетов.Видимость = Ложь;
		ПерваяЧастьКлюча = "2";
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Счет БУ';uk='Рахунок БО'");
		ПерваяЧастьКлюча = "3";
	//++ НЕ УТКА	
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("ПланСчетовСсылка.Международный") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Счет МФУ';uk='Рахунок МФО'");
		ПерваяЧастьКлюча = "4";
	//-- НЕ УТКА	
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.СтатьиБюджетов") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Статья бюджетов';uk='Стаття бюджетів'");
		Элементы.РасчетныеПоказатели.Видимость = Ложь;
		Элементы.ЦелевыеПоказатели.Видимость = Ложь;
		ПерваяЧастьКлюча = "5";
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		Элементы.ОбъектНастройки.Заголовок = НСтр("ru='Показатель бюджетов';uk='Показник бюджетів'");
		Элементы.СтатьиБюджетов.Видимость = Ложь;
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектНастройки, "ТипПоказателя") = Перечисления.ТипПоказателяБюджетов.Расчетный Тогда
			Элементы.ЦелевыеПоказатели.Видимость = Ложь;
			ПерваяЧастьКлюча = "6";
		Иначе
			Элементы.РасчетныеПоказатели.Видимость = Ложь;
			ПерваяЧастьКлюча = "7";
		КонецЕсли;
	КонецЕсли;
	
	Количество = 0;
	Для Каждого Элемент из Элементы.СтраницыФормы.ПодчиненныеЭлементы Цикл
		Если Элемент.Видимость Тогда
			Количество = Количество + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Количество = 1 Тогда
		Элементы.СтраницыФормы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Элементы.СтатьиБюджетов.Видимость Тогда
		Если ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.СтатьиБюджетов") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоСтатьямБюджетов,
																					"СтатьяБюджетов", Параметры.ОбъектНастройки,
																					ВидСравненияКомпоновкиДанных.Равно, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоСтатьямБюджетов,
																					"ИсточникДанных", Параметры.ОбъектНастройки,
																					ВидСравненияКомпоновкиДанных.Равно, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.РасчетныеПоказатели.Видимость
			ИЛИ Элементы.ЦелевыеПоказатели.Видимость Тогда
		Если ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																					"ПоказательБюджетов", Параметры.ОбъектНастройки,
																					ВидСравненияКомпоновкиДанных.Равно, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																					"ИсточникДанных", Параметры.ОбъектНастройки,
																					ВидСравненияКомпоновкиДанных.Равно, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтатьиБюджетов.Видимость Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтатьиБюджетов;
	ИначеЕсли Элементы.РасчетныеПоказатели.Видимость Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.РасчетныеПоказатели;
	ИначеЕсли Элементы.ЦелевыеПоказатели.Видимость Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЦелевыеПоказатели;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.СтатьиБюджетов") Тогда
		Элементы.ПравилаПолученияФактаПоСтатьямБюджетовСтатьяБюджетов.Видимость = Ложь;
	ИначеЕсли ТипЗнч(Параметры.ОбъектНастройки) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		Элементы.ПравилаПолученияФактаПоРасчетнымПоказателямПоказательБюджетов.Видимость = Ложь;
		Элементы.ПравилаПолученияФактаПоЦелевымПоказателямПоказательБюджетов.Видимость = Ложь;
	Иначе
		Элементы.ПравилаПолученияФактаПоСтатьямБюджетовИсточникДанных.Видимость = Ложь;
		Элементы.ПравилаПолученияФактаПоЦелевымПоказателямИсточникДанных.Видимость = Ложь;
		Элементы.ПравилаПолученияФактаПоПоказателямБюджетовИсточникДанных.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой();
	
	Если Элементы.СтраницыФормы.ПодчиненныеЭлементы.Количество() > 1 Тогда
		УстановитьЗаголовкиЗакладок();
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = "НастройкаПравилПолученияФактаБюджетирования.НастройкаПравил_" + ПерваяЧастьКлюча + "_" + Количество;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	СписокТиповПравила = Новый СписокЗначений;
	СписокТиповПравила.Добавить(Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ИсполнениеБюджетаИФактическиеДанные);
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтатьиБюджетов Тогда
		СписокТиповПравила.Добавить(ТипПравилСтатьяБюджета);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоСтатьямБюджетов,
																				"ТипПравила", СписокТиповПравила,
																				ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЦелевыеПоказатели Тогда
		СписокТиповПравила.Добавить(ТипПравилПоказательБюджета);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																				"ТипПравила", СписокТиповПравила,
																				ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																				"ЭтоРасчетный", Ложь,
																				ВидСравненияКомпоновкиДанных.Равно, , Истина);
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.РасчетныеПоказатели Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																				"ТипПравила", ,
																				ВидСравненияКомпоновкиДанных.Равно, , Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаПолученияФактаПоПоказателямБюджетов,
																				"ЭтоРасчетный", Истина,
																				ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПравилСтатьяБюджетаФактическиеДанныеПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПравилСтатьяБюджетаИсполненияБюджетаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПравилПоказательБюджетаФактическиеДанныеПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПравилПоказательБюджетаИсполнениеБюджетаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыФормыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если Элементы.СтраницыФормы.ПодчиненныеЭлементы.Количество() > 1 Тогда
		УстановитьЗаголовкиЗакладок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиЗакладок()
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	NULL КАК СтатьяФактическиеДанные,
		|	NULL КАК СтатьяИсполнениеБюджета,
		|	ВЫБОР
		|		КОГДА ПравилаПолученияФактаПоПоказателямБюджетов.ТипПравила = &ФактическиеДанные
		|			ТОГДА ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка
		|		ИНАЧЕ NULL
		|	КОНЕЦ КАК РасчетныйФактическиеДанные,
		|	NULL КАК ЦелевойФактическиеДанные,
		|	NULL КАК ЦелевойИсполнениеБюджета,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ИсточникДанных,
		|	NULL КАК СтатьяБюджетов,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов
		|ПОМЕСТИТЬ ТаблицаПравил
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоПоказателямБюджетов КАК ПравилаПолученияФактаПоПоказателямБюджетов
		|ГДЕ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов.ТипПоказателя = &Расчетный
		|{ГДЕ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ИсточникДанных}
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	NULL,
		|	NULL,
		|	ВЫБОР
		|		КОГДА ПравилаПолученияФактаПоПоказателямБюджетов.ТипПравила = &ФактическиеДанные
		|			ТОГДА ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПравилаПолученияФактаПоПоказателямБюджетов.ТипПравила <> &ФактическиеДанные
		|			ТОГДА ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ИсточникДанных,
		|	NULL,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоПоказателямБюджетов КАК ПравилаПолученияФактаПоПоказателямБюджетов
		|ГДЕ
		|	НЕ ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов.ТипПоказателя = &Расчетный
		|{ГДЕ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов,
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ИсточникДанных}
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ПравилаПолученияФактаПоСтатьямБюджетов.ТипПравила = &ФактическиеДанные
		|			ТОГДА ПравилаПолученияФактаПоСтатьямБюджетов.Ссылка
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПравилаПолученияФактаПоСтатьямБюджетов.ТипПравила <> &ФактическиеДанные
		|			ТОГДА ПравилаПолученияФактаПоСтатьямБюджетов.Ссылка
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	NULL,
		|	NULL,
		|	NULL,
		|	ПравилаПолученияФактаПоСтатьямБюджетов.ИсточникДанных,
		|	ПравилаПолученияФактаПоСтатьямБюджетов.СтатьяБюджетов,
		|	NULL
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоСтатьямБюджетов КАК ПравилаПолученияФактаПоСтатьямБюджетов
		|{ГДЕ
		|	ПравилаПолученияФактаПоСтатьямБюджетов.СтатьяБюджетов,
		|	ПравилаПолученияФактаПоСтатьямБюджетов.ИсточникДанных}
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаПравил.СтатьяФактическиеДанные) КАК СтатьяФактическиеДанные,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаПравил.СтатьяИсполнениеБюджета) КАК СтатьяИсполнениеБюджета,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаПравил.РасчетныйФактическиеДанные) КАК РасчетныйФактическиеДанные,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаПравил.ЦелевойФактическиеДанные) КАК ЦелевойФактическиеДанные,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаПравил.ЦелевойИсполнениеБюджета) КАК ЦелевойИсполнениеБюджета
		|ИЗ
		|	ТаблицаПравил КАК ТаблицаПравил
		|{ГДЕ
		|	ТаблицаПравил.ИсточникДанных,
		|	ТаблицаПравил.СтатьяБюджетов,
		|	ТаблицаПравил.ПоказательБюджетов}";
	
	Запрос.Параметры.Вставить("ФактическиеДанные", Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные);
	Запрос.Параметры.Вставить("Расчетный", Перечисления.ТипПоказателяБюджетов.Расчетный);
	Если ТипЗнч(ОбъектНастройки) = Тип("СправочникСсылка.СтатьиБюджетов") Тогда
		Отбор = Запрос.Отбор.Добавить("СтатьяБюджетов");
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		Отбор = Запрос.Отбор.Добавить("ПоказательБюджетов");
	Иначе
		Отбор = Запрос.Отбор.Добавить("ИсточникДанных");
	КонецЕсли;
		
	Отбор.ВидСравнения = ВидСравнения.Равно;
	Отбор.Значение = ОбъектНастройки;
	Отбор.Использование = Истина;
	
	Запрос.Выполнить();
	
	Выборка = Запрос.Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаголовокЗакладки = НСтр("ru='Статьи бюджетов (%1 факт., %2 исп.)';uk='Статті бюджетів (%1 факт., %2 вик.)'");
	Элементы.СтатьиБюджетов.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ЗаголовокЗакладки, Выборка.СтатьяФактическиеДанные, Выборка.СтатьяИсполнениеБюджета);
	
	ЗаголовокЗакладки = НСтр("ru='Расчетные показатели (%1)';uk='Розрахункові показники (%1)'");
	КоличествоПравил = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Выборка.РасчетныйФактическиеДанные, "правило,правила,правил");
	Элементы.РасчетныеПоказатели.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокЗакладки, КоличествоПравил);
	
	ЗаголовокЗакладки = НСтр("ru='Целевые показатели (%1 факт., %2 исп.)';uk='Цільові показники (%1 факт., %2 вик.)'");
	Элементы.ЦелевыеПоказатели.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ЗаголовокЗакладки, Выборка.ЦелевойФактическиеДанные, Выборка.ЦелевойИсполнениеБюджета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНовогоПравила(ИмяНовойФормы, Отказ, Расчетный = Неопределено)
	
	Отказ = Истина;
	Если ТипЗнч(ОбъектНастройки) = Тип("СправочникСсылка.СтатьиБюджетов") Тогда
		
		ЗначенияЗаполнения = Новый Структура("СтатьяБюджетов", ОбъектНастройки);
		
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		
		ЗначенияЗаполнения = Новый Структура("ПоказательБюджетов", ОбъектНастройки);
		
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("СправочникСсылка.НастройкиХозяйственныхОпераций") Тогда
		
		ЗначенияЗаполнения = Новый Структура("РазделИсточникаДанных, ИсточникДанных", 
			ПредопределенноеЗначение("Перечисление.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет"), ОбъектНастройки);
		
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		
		ЗначенияЗаполнения = Новый Структура("РазделИсточникаДанных, ИсточникДанных", 
			ПредопределенноеЗначение("Перечисление.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет"), ОбъектНастройки);
		
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
		
		ЗначенияЗаполнения = Новый Структура("РазделИсточникаДанных, ИсточникДанных", 
			ПредопределенноеЗначение("Перечисление.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет"), ОбъектНастройки);
		
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(ОбъектНастройки) = Тип("ПланСчетовСсылка.Международный") Тогда
		
		ЗначенияЗаполнения = Новый Структура("РазделИсточникаДанных, ИсточникДанных", 
			ПредопределенноеЗначение("Перечисление.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет"), ОбъектНастройки);
	//-- НЕ УТКА
	КонецЕсли;
	
	Если ИмяНовойФормы = "ПравилаПолученияФактаПоСтатьямБюджетов" Тогда
		ЗначенияЗаполнения.Вставить("ТипПравила", ТипПравилСтатьяБюджета);
	Иначе
		ЗначенияЗаполнения.Вставить("ТипПравила", ТипПравилПоказательБюджета);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если Расчетный <> Неопределено Тогда
		Если Расчетный Тогда
			ПараметрыФормы.Вставить("ТипПоказателя", ПредопределенноеЗначение("Перечисление.ТипПоказателяБюджетов.Расчетный"));
		Иначе
			ПараметрыФормы.Вставить("ТипПоказателя", ПредопределенноеЗначение("Перечисление.ТипПоказателяБюджетов.Целевой"));
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Справочник." + ИмяНовойФормы + ".Форма.ФормаОбъекта", ПараметрыФормы,,,,,,
																	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПолученияФактаПоСтатьямБюджетовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОткрытьФормуНовогоПравила("ПравилаПолученияФактаПоСтатьямБюджетов", Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПолученияФактаПоРасчетнымПоказателямПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОткрытьФормуНовогоПравила("ПравилаПолученияФактаПоПоказателямБюджетов", Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПолученияФактаПоЦелевымПоказателямПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОткрытьФормуНовогоПравила("ПравилаПолученияФактаПоПоказателямБюджетов", Отказ, Ложь);
	
КонецПроцедуры
