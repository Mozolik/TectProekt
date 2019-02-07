﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.Вставить("РазрешеноМенятьВарианты", Ложь);
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		Дата = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "ЖелательнаяДатаПлатежа");
	
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Дата", Дата);
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрДокумент = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Документ").Значение;
	ПараметрДата = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Дата").Значение;
	
	Если ТипЗнч(ПараметрДата) = Тип("СтандартнаяДатаНачала") Тогда
		ПараметрДата = ПараметрДата.Дата;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрДата) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Дата", ТекущаяДата(), Истина);
	КонецЕсли;
	
	ПланФактЛимитов = ЛимитыРасходованияДенежныхСредствСервер.ПланФактЛимитов(ПараметрДата, ПараметрДокумент);
	ПланФактЛимитов = ПреобразоватьПланФактЛимитовДляВыводаВОтчет(ПланФактЛимитов);
	
	ЛимитыДействующиеНаДату = ЛимитыРасходованияДенежныхСредствСервер.ЛимитыРасходовПоДаннымБюджетирования(ПараметрДата);
	
	ВнешниеНаборы = Новый Структура("ПланФактЛимитов, ДействующиеЛимиты", ПланФактЛимитов, ЛимитыДействующиеНаДату);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьПланФактЛимитовДляВыводаВОтчет(ПланФактЛимитов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаЛимитовПоДаннымБюджетирования.СтатьяБюджета,
		|	ПравилаЛимитовПоДаннымБюджетирования.Ссылка,
		|	ПравилаЛимитовПоДаннымБюджетированияИспользуемыеАналитики.ВидАналитики,
		|	ПравилаЛимитовПоДаннымБюджетированияИспользуемыеАналитики.ИмяИзмерения
		|ПОМЕСТИТЬ ПравилаЛимитов
		|ИЗ
		|	Справочник.ПравилаЛимитовПоДаннымБюджетирования.ИспользуемыеАналитики КАК ПравилаЛимитовПоДаннымБюджетированияИспользуемыеАналитики
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаЛимитовПоДаннымБюджетирования КАК ПравилаЛимитовПоДаннымБюджетирования
		|		ПО ПравилаЛимитовПоДаннымБюджетированияИспользуемыеАналитики.Ссылка = ПравилаЛимитовПоДаннымБюджетирования.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПравилаЛимитов.СтатьяБюджета,
		|	ПравилаЛимитов.Ссылка,
		|	ПравилаЛимитов.ВидАналитики,
		|	ПравилаЛимитов.ИмяИзмерения
		|ИЗ
		|	ПравилаЛимитов КАК ПравилаЛимитов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтатьиБюджетов.Ссылка,
		|	СтатьиБюджетов.ВидАналитики1,
		|	СтатьиБюджетов.ВидАналитики2,
		|	СтатьиБюджетов.ВидАналитики3,
		|	СтатьиБюджетов.ВидАналитики4,
		|	СтатьиБюджетов.ВидАналитики5,
		|	СтатьиБюджетов.ВидАналитики6
		|ИЗ
		|	Справочник.СтатьиБюджетов КАК СтатьиБюджетов
		|ГДЕ
		|	СтатьиБюджетов.Ссылка В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ПравилаЛимитов.СтатьяБюджета
		|			ИЗ
		|				ПравилаЛимитов)
		|";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	КэшАналитикЛимитов = РезультатЗапроса[1].Выгрузить();
	КэшАналитикЛимитов.Индексы.Добавить("Ссылка, ИмяИзмерения");
	
	КэшВидовАналитик = РезультатЗапроса[2].Выгрузить();
	КэшВидовАналитик.Индексы.Добавить("Ссылка");
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	Для Каждого Колонка из ПланФактЛимитов.Колонки Цикл
		ТаблицаРезультат.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	ТаблицаРезультат.Колонки.Добавить("Аналитика7");
	ТаблицаРезультат.Колонки.Добавить("Аналитика8");
	
	Для Каждого СтрокаПланФакт из ПланФактЛимитов Цикл
		
		НоваяСтрока = ТаблицаРезультат.Добавить();
		НоваяСтрока.Правило = СтрокаПланФакт.Правило;
		НоваяСтрока.СуммаПлан = СтрокаПланФакт.СуммаПлан;
		НоваяСтрока.СуммаФакт = СтрокаПланФакт.СуммаФакт;
		
		Для Сч = 1 по 8 Цикл
			НоваяСтрока["Аналитика" + Сч] = NULL;
		КонецЦикла;
		
		Счетчик = 1;
		
		СтруктураПоиска = Новый Структура("Ссылка, ИмяИзмерения", СтрокаПланФакт.Правило, "Организация");
		Если КэшАналитикЛимитов.НайтиСтроки(СтруктураПоиска).Количество() Тогда
			НоваяСтрока["Аналитика" + Счетчик] = СтрокаПланФакт.Организация;
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		СтруктураПоиска.ИмяИзмерения = "Подразделение";
		Если КэшАналитикЛимитов.НайтиСтроки(СтруктураПоиска).Количество() Тогда
			НоваяСтрока["Аналитика" + Счетчик] = СтрокаПланФакт.Подразделение;
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		СтруктураПоиска.ИмяИзмерения = "";
		НайденныеСтроки = КэшАналитикЛимитов.НайтиСтроки(СтруктураПоиска);
		КэшВидовАналитикСтроки = Неопределено;
		
		Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
			Если КэшВидовАналитикСтроки = Неопределено Тогда
				КэшВидовАналитикСтроки = КэшВидовАналитик.Найти(НайденнаяСтрока.СтатьяБюджета);
			КонецЕсли;
			ИмяИсточника = "";
			Для Сч = 1 по 6 Цикл
				Если КэшВидовАналитикСтроки["ВидАналитики" + Сч] = НайденнаяСтрока.ВидАналитики Тогда
					ИмяИсточника = "Аналитика" + Сч;
				КонецЕсли;
			КонецЦикла;
			Если ЗначениеЗаполнено(ИмяИсточника) Тогда
				НоваяСтрока["Аналитика" + Счетчик] = СтрокаПланФакт[ИмяИсточника];
			КонецЕсли;
			Счетчик = Счетчик + 1;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТаблицаРезультат;
	
КонецФункции

#КонецОбласти

#КонецЕсли