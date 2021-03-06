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
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
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
	
	// Дополнительные команды
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПланПроизводства", Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Если Параметры.Свойство("Расшифровка")
		И Параметры.Расшифровка <> Неопределено Тогда
		
		ЗаменятьВариант = Ложь;
		
		Если Параметры.Расшифровка.ПрименяемыеНастройки.Структура.Количество() > 0 Тогда
			
			ПолеНоменклатураПродукции = Новый ПолеКомпоновкиДанных("НоменклатураПродукции");
			ПолеХарактеристикаПродукции = Новый ПолеКомпоновкиДанных("ХарактеристикаПродукции");
			ПолеСпецификация = Новый ПолеКомпоновкиДанных("Спецификация");
			
			Для каждого Группировка Из Параметры.Расшифровка.ПрименяемыеНастройки.Структура[0].ПоляГруппировки.Элементы Цикл
			
				Если Группировка.Поле = ПолеНоменклатураПродукции 
					ИЛИ Группировка.Поле = ПолеХарактеристикаПродукции
					ИЛИ Группировка.Поле = ПолеСпецификация Тогда
				
					ЗаменятьВариант = Истина;
					Прервать;
				
				КонецЕсли; 
			
			КонецЦикла; 
		
		КонецЕсли; 
		
		// заполняем параметры расшифровки
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
		
			ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
			
			Если НЕ ДанныеРасшифровки.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта")
				ИЛИ ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючТекущегоВарианта <> "ПлановаяПотребностьВПолуфабрикатахКонтекст" Тогда
			
				Возврат;
			
			КонецЕсли; 
		КонецЕсли; 
		
		Если НЕ ЗаменятьВариант Тогда
			Возврат;
		КонецЕсли; 
		
		Если Параметры.Свойство("КлючВарианта") Тогда
			Параметры.КлючВарианта = "РасшифровкаКонтекст";
		КонецЕсли; 
		Если Параметры.Свойство("КлючНазначенияИспользования") Тогда
			Параметры.КлючНазначенияИспользования = "РасшифровкаКонтекст";
		КонецЕсли;
		
		ЭтаФорма.КлючТекущегоВарианта = "РасшифровкаКонтекст";
		
		ЭтаФорма.РежимВариантаОтчета = Истина;
		ЭтаФорма.РежимРасшифровки = Ложь;
		ЭтаФорма.НастройкиОтчета.РазрешеноМенятьВарианты = Ложь;
		ЭтаФорма.НастройкиОтчета.ВариантСсылка = ВариантыОтчетов.ПолучитьСсылку(ЭтаФорма.НастройкиОтчета.ОтчетСсылка, ЭтаФорма.КлючТекущегоВарианта);
		
	КонецЕсли;
	

КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта") 
		И КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.КлючТекущегоВарианта = "ПлановаяПотребностьВПолуфабрикатахКонтекст"
		И ЭтаФорма.КлючТекущегоВарианта = "РасшифровкаКонтекст" Тогда
		
		Сценарий = Неопределено;
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("Сценарий", Сценарий);
		ПланПроизводства = Неопределено;
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("ПланПроизводства", ПланПроизводства);
		
		ОтчетОбъект = Отчеты.ПлановаяПотребностьВПолуфабрикатах.Создать();
		Вариант = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ЭтаФорма.КлючТекущегоВарианта);
		
		КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(Вариант.Настройки.ПараметрыДанных,	КомпоновщикНастроекФормы.Настройки.ПараметрыДанных);
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(Вариант.Настройки.Отбор,			КомпоновщикНастроекФормы.Настройки.Отбор, Ложь);
		
		КомпоновщикНастроекФормы.ЗагрузитьНастройки(Вариант.Настройки);
		
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить(
			"ПланПроизводства", 
			ПланПроизводства);
		
		Если Сценарий <> Неопределено Тогда
		
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
				КомпоновщикНастроекФормы, 
				"Сценарий", 
				Сценарий);
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	
	Если ЭтаФорма.ФормаПараметры.Отбор.Свойство("ПланПроизводства") Тогда
		
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить(
			"ПланПроизводства", 
			ЭтаФорма.ФормаПараметры.Отбор.ПланПроизводства);
		
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить(
			"Сценарий", 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтаФорма.ФормаПараметры.Отбор.ПланПроизводства, "Сценарий"));
		
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроекФормы, 
			"Сценарий", 
			КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Сценарий);
		
		
	КонецЕсли; 
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрСценарий = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Сценарий");
	
	Если НЕ ЗначениеЗаполнено(ПараметрСценарий.Значение) Тогда
		ВызватьИсключение НСтр("ru='Не заполнено значение параметра ""Сценарий"".';uk='Не заповнено значення параметра ""Сценарій"".'");
	КонецЕсли; 
	
	Периодичность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрСценарий.Значение, "Периодичность");
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодВыпуска");
	
	ДатаОкончания = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(Период.Значение.ДатаНачала, Периодичность);
	
	Если ДатаОкончания < Период.Значение.ДатаОкончания Тогда
		ИспользоватьИтоги = Истина;
	Иначе
		ИспользоватьИтоги = Ложь;
	КонецЕсли; 
	
	Параметр = Новый ПараметрКомпоновкиДанных("ГоризонтальноеРасположениеОбщихИтогов");
	ПараметрГоризонтальноеРасположениеОбщихИтогов = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти(Параметр);
	
	Если ИспользоватьИтоги Тогда
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Начало;
	Иначе
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Полуфабрикаты.ДатаВыпуска ДинамическийПериод,
	|	Полуфабрикаты.Номенклатура,
	|	Полуфабрикаты.Характеристика,
	|	Полуфабрикаты.Количество КАК КоличествоПолуфабрикатов,
	|	0 КАК КоличествоПродукции,
	|	0 КАК КоличествоПотребления,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаВыпуска,
	|	ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаясСылка) КАК Спецификация,
	|	Полуфабрикаты.Ссылка.Подразделение КАК ПодразделениеДиспетчер,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаясСылка) КАК ПодразделениеИсполнитель,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаясСылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаясСылка) КАК НоменклатураПродукции,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаПродукции,
	|	Полуфабрикаты.Ссылка КАК ПланПроизводства,
	|	Полуфабрикаты.Ссылка.НачалоПериода КАК НачалоПериода
	|ИЗ
	|	Документ.ПланПроизводства.Продукция КАК Полуфабрикаты
	|ГДЕ
	|	Полуфабрикаты.Полуфабрикат
	|	И Полуфабрикаты.Ссылка = &ПланПроизводства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Продукция.ДатаВыпуска КАК ДинамическийПериод,
	|	Продукция.Номенклатура,
	|	Продукция.Характеристика,
	|	0 КАК КоличествоПолуфабрикатов,
	|	Продукция.Количество КАК КоличествоПродукции,
	|	0 КАК КоличествоПотребления,
	|	Продукция.ДатаВыпуска,
	|	Продукция.Спецификация,
	|	Продукция.Ссылка.Подразделение КАК ПодразделениеДиспетчер,
	|	Продукция.Номенклатура КАК НоменклатураПродукции,
	|	Продукция.Характеристика КАК ХарактеристикаПродукции,
	|	Продукция.Ссылка КАК ПланПроизводства,
	|	Продукция.Ссылка.НачалоПериода КАК НачалоПериода
	|ИЗ
	|	Документ.ПланПроизводства.Продукция КАК Продукция
	|ГДЕ
	|	НЕ Продукция.Полуфабрикат
	|	И Продукция.Ссылка = &ПланПроизводства";
	
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ПланПроизводства") Тогда
	
		Запрос.УстановитьПараметр("ПланПроизводства", КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПланПроизводства);
	
	Иначе
	
		Запрос.УстановитьПараметр("ПланПроизводства", Документы.ПланПроизводства.ПустаяСсылка());
	
	КонецЕсли; 
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаРезультат = РезультатыЗапроса[0].Выгрузить();
	
	ТаблицаПродукция = РезультатыЗапроса[1].Выгрузить();
	
	
	ПереченьДанных = Новый Массив;
	ПереченьДанных.Добавить("МатериалыИУслуги");
	
	КэшированныеСпецификации = Неопределено;
	ПараметрыГрафика = Неопределено;
	
	Для каждого СтрокаТЧ Из ТаблицаПродукция Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Спецификация) ИЛИ СтрокаТЧ.КоличествоПродукции = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЗнакКоличества = 1;
		ДанныеПоНоменклатуре = Новый Структура("Номенклатура, Характеристика, Спецификация, Количество, Подразделение, НачалоПроизводства, ДнейДоОкончания");
		ЗаполнитьЗначенияСвойств(ДанныеПоНоменклатуре, СтрокаТЧ);
		Если СтрокаТЧ.КоличествоПродукции < 0 Тогда
			ДанныеПоНоменклатуре.Количество = -СтрокаТЧ.КоличествоПродукции;
			ЗнакКоличества = -1;
		Иначе
			ДанныеПоНоменклатуре.Количество = СтрокаТЧ.КоличествоПродукции;
		КонецЕсли;
		
		ДанныеПоНоменклатуре.Подразделение = СтрокаТЧ.ПодразделениеДиспетчер;
		ДанныеПоНоменклатуре.Вставить("ПодразделениеДиспетчер", СтрокаТЧ.ПодразделениеДиспетчер);
		ДанныеПоНоменклатуре.НачалоПроизводства = Дата("00010101");
		ДанныеПоНоменклатуре.ДнейДоОкончания = 0;
		
		ДанныеСпецификации = Справочники.РесурсныеСпецификации.ДанныеСпецификацииСПолуфабрикатами(ДанныеПоНоменклатуре, Истина,,ПереченьДанных, КэшированныеСпецификации);
		
		// Данные по материалам
		Для каждого ЭлементМатериал Из ДанныеСпецификации.МатериалыИУслуги Цикл
			
			Если НЕ ЭлементМатериал.Запланировать Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаРезультат.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМатериал,	"Номенклатура,Характеристика, Склад");
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ,	"ПодразделениеДиспетчер,НоменклатураПродукции, 
				|ХарактеристикаПродукции, Спецификация, ПланПроизводства, НачалоПериода, ДатаВыпуска, 
				|КоличествоПродукции, КоличествоПолуфабрикатов");
			НоваяСтрока.КоличествоПотребления = ЗнакКоличества * ЭлементМатериал.Количество;
			НоваяСтрока.ПодразделениеИсполнитель = ЭлементМатериал.ПодразделениеЭтапа;
			
			НоваяСтрока.ДинамическийПериод = Документы.ПланПроизводства.ПолучитьДатуПоГрафику(
				СтрокаТЧ.ДатаВыпуска,
				-ЭлементМатериал.ДнейДоОкончания, 
				ПараметрыГрафика);
			
			
			СтрокаПродукции = ТаблицаПродукция.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПродукции, НоваяСтрока);
			
			ПараметрыСпецификации = Новый Структура();
			ПараметрыСпецификации.Вставить("Номенклатура",	НоваяСтрока.Номенклатура);
			ПараметрыСпецификации.Вставить("Характеристика",НоваяСтрока.Характеристика);
			ПараметрыСпецификации.Вставить("Спецификация",	НоваяСтрока.Спецификация);
			ПараметрыСпецификации.Вставить("Подразделение",	СтрокаТЧ.ПодразделениеДиспетчер);
			ПараметрыСпецификации.Вставить("НачалоПериода",	Мин(СтрокаТЧ.НачалоПериода, НоваяСтрока.ДинамическийПериод));
			
			Документы.ПланПроизводства.ЗаполнитьСпецификациюДляСтрокиПродукции(ПараметрыСпецификации);
			СтрокаПродукции.Спецификация = ПараметрыСпецификации.Спецификация;
			
		КонецЦикла;
	КонецЦикла;
	
	Для каждого СтрокаТЧ Из ТаблицаРезультат Цикл
	
		СтрокаТЧ.ДинамическийПериод = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуНачалаПериода(СтрокаТЧ.ДинамическийПериод, Периодичность);
	
	КонецЦикла; 
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("НаборДанных1", ТаблицаРезультат);
	
	// Компоновка макета
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(
		СхемаКомпоновкиДанных, 
		КомпоновщикНастроек.ПолучитьНастройки(), 
		ДанныеРасшифровки,
		, 
		Тип("ГенераторМакетаКомпоновкиДанных"));
	
	// Инициализация процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, НаборыДанных, ДанныеРасшифровки);
		
	// Получение результата
	ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли