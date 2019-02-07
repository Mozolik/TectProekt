﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.Совмещение);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ на совмещение
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.Совмещение";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказНаСовмещение";
	КомандаПечати.Представление = НСтр("ru='Приказ на совмещение';uk='Наказ на суміщення'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
	// Дополнительное соглашение
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.Совмещение";
		КомандаПечати.Идентификатор = "ПФ_MXL_ДополнительноеСоглашение";
		КомандаПечати.Представление = НСтр("ru='Дополнительное соглашение';uk='Додаткова угода'");
		КомандаПечати.Порядок = 20;
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
	КонецЕсли;

КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьПриказ = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказНаСовмещение");
	
	Если НужноПечататьПриказ Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ПриказНаСовмещение",
			НСтр("ru='Приказ на совмещение';uk='Наказ на суміщення'"), ПечатьПриказа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
			"Документ.Совмещение.ПФ_MXL_ПриказНаСовмещение",, Истина);
	КонецЕсли;
	
	НужноПечататьСоглашение = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ДополнительноеСоглашение");
	
	Если НужноПечататьСоглашение Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ДополнительноеСоглашение",
			НСтр("ru='Дополнительное соглашение';uk='Додаткова угода'"), ПечатьСоглашения(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
			"Документ.Совмещение.ПФ_MXL_ДополнительноеСоглашение",, Истина);
	КонецЕсли;
						
КонецПроцедуры								

Функция ПечатьСоглашения(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Совмещение_ДополнительноеСоглашение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Совмещение.ПФ_MXL_ДополнительноеСоглашение", КодЯзыкаПечать);
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов, КодЯзыкаПечать);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;	
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(Макет);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции
	
Функция ПечатьПриказа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Совмещение_ПриказНаСовмещение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Совмещение.ПФ_MXL_ПриказНаСовмещение", КодЯзыкаПечать);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСовмещениеПрофессийДолжностей = Макет.ПолучитьОбласть("ОснованиеСовмещениеПрофессийДолжностей");
	ОбластьИсполнениеОбязанностей = Макет.ПолучитьОбласть("ОснованиеИсполнениеОбязанностей");
	ОбластьУвеличениеОбъемаРабот = Макет.ПолучитьОбласть("ОснованиеУвеличениеОбъемаРабот");
	ОбластьПриказНачало = Макет.ПолучитьОбласть("ПриказНачало");
	ОбластьСрокДействия = Макет.ПолучитьОбласть("СрокДействия");
	ОбластьПриказОкончание = Макет.ПолучитьОбласть("ПриказОкончание");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов, КодЯзыкаПечать);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;		
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьСовмещениеПрофессийДолжностей.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьИсполнениеОбязанностей.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьУвеличениеОбъемаРабот.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьПриказНачало.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьСрокДействия.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьПриказОкончание.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Если ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.СовмещениеПрофессийДолжностей Тогда
			ТабличныйДокумент.Вывести(ОбластьСовмещениеПрофессийДолжностей);
		ИначеЕсли ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.ИсполнениеОбязанностей Тогда
			ТабличныйДокумент.Вывести(ОбластьИсполнениеОбязанностей);
		ИначеЕсли ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.УвеличениеОбъемаРабот Тогда
			ТабличныйДокумент.Вывести(ОбластьУвеличениеОбъемаРабот);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПриказНачало);
		
		Если ЗначениеЗаполнено(ДанныеПечати.Значение.ДатаОкончания) Тогда
			ТабличныйДокумент.Вывести(ОбластьСрокДействия);
		КонецЕсли;
				
		ТабличныйДокумент.Вывести(ОбластьПриказОкончание);	
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов, КодЯзыкаПечать)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Совмещение.Ссылка,
	|	Совмещение.Номер,
	|	Совмещение.Дата,
	|	Совмещение.ПричинаСовмещения,
	|	Совмещение.Организация,
	|	Совмещение.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	|	Совмещение.СовмещающийСотрудник КАК СовмещающийСотрудник,
	|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо КАК СовмещающееФизическоеЛицо,
	|	Совмещение.ОтсутствующийСотрудник КАК ОтсутствующийСотрудник,
	|	Совмещение.ОтсутствующийСотрудник.ФизическоеЛицо КАК ОтсутствующееФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА Совмещение.СовмещаемаяДолжность ЕСТЬ NULL 
	|				ИЛИ Совмещение.ПричинаСовмещения <> ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.СовмещениеПрофессийДолжностей)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)
	|		ИНАЧЕ Совмещение.СовмещаемаяДолжность.Должность
	|	КОНЕЦ КАК СовмещаемаяДолжность,
	|	Совмещение.ДатаОкончания,
	|	Совмещение.РазмерДоплаты,
	|	Совмещение.Руководитель,
	|	Совмещение.ДолжностьРуководителя
	|ИЗ
	|	Документ.Совмещение КАК Совмещение
	|ГДЕ
	|	Совмещение.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ДокументДляПечати Из РезультатыЗапроса Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДокументДляПечати);
		ДанныеПечати.Вставить("ФИОРуководителяСокращенное", ДанныеПечати.Руководитель);
		ДанныеПечати.Вставить("ФИОРуководителяСклоняемое", ДанныеПечати.Руководитель);
		ДанныеПечати.Вставить("ДатаОкончания", Формат(ДанныеПечати.ДатаОкончания, "Л="+КодЯзыкаПечать+";ДЛФ=DD"));
		ДанныеПечати.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=D");
		
		// Подготовка номера документа.
		ДанныеПечати.Номер = КадровыйУчетРасширенный.НомерКадровогоПриказа(ДанныеПечати.Номер);

		Если ЗначениеЗаполнено(ДанныеПечати.Руководитель) Тогда
				
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПечати.Руководитель), 
				"Пол", ДокументДляПечати.Дата);
				
			Если ДанныеФизическогоЛица[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ДанныеПечати.Вставить("Действующего", НСтр("ru='действующего';uk='діючого'"));
			Иначе
				ДанныеПечати.Вставить("Действующего", НСтр("ru='действующей';uk='діючої'"));
			КонецЕсли;
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				
				ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОРуководителяСокращенное),
					2, ДанныеПечати.ФИОРуководителяСклоняемое, ДанныеФизическогоЛица[0].Пол);
					
				ДанныеПечати.ФИОРуководителяСокращенное = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(Строка(ДанныеПечати.ФИОРуководителяСокращенное));
				
			КонецЕсли;
				
		КонецЕсли;
		
		// Юридический адрес организации.
		ДанныеПечати.Вставить("АдресОрганизации", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ДанныеПечати.Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации));
		
		// Данные совмещающего сотрудника.
		ДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.СовмещающийСотрудник), 
			"ТрудовойДоговорНомер, ТрудовойДоговорДата, Должность,ФИОПолные, Пол, АдресПоПрописке, ДокументВид, ДокументСерия, ДокументНомер", ДокументДляПечати.Дата);
			
		Если ДанныеСотрудника.Количество() > 0 Тогда
				
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(
					ДанныеСотрудника[0].АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			АдресПоПрописке = "";
			УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, АдресПоПрописке);
			
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудника", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаСокращенное", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаРодительный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаДательный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаТворительный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("АдресСотрудника", АдресПоПрописке);
			ДанныеПечати.Вставить("ДокументВид", ДанныеСотрудника[0].ДокументВид);
			ДанныеПечати.Вставить("ДокументСерия", ДанныеСотрудника[0].ДокументСерия);
			ДанныеПечати.Вставить("ДокументНомер", ДанныеСотрудника[0].ДокументНомер);
			
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаРодительный),
				2, ДанныеПечати.ФИОСовмещающегоСотрудникаРодительный, ДанныеСотрудника[0].Пол);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаДательный),
				3, ДанныеПечати.ФИОСовмещающегоСотрудникаДательный, ДанныеСотрудника[0].Пол);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаТворительный),
				5, ДанныеПечати.ФИОСовмещающегоСотрудникаТворительный, ДанныеСотрудника[0].Пол);
			
			ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное);

			Если ДанныеСотрудника[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ДанныеПечати.Вставить("Именуемый", НСтр("ru='именуемый';uk='іменований'"));
				ДанныеПечати.Вставить("Занимающий", НСтр("ru='занимающим';uk='що займає'"));
			Иначе
				ДанныеПечати.Вставить("Именуемый", НСтр("ru='именуемая';uk='іменована'"));
				ДанныеПечати.Вставить("Занимающий", НСтр("ru='занимающей';uk='що займає'"));
			КонецЕсли;

		КонецЕсли;

		Если ДанныеСотрудника.Количество() > 0 Тогда
			ДанныеПечати.Вставить("НомерДоговора", ДанныеСотрудника[0].ТрудовойДоговорНомер);
			ДанныеПечати.Вставить("ДатаДоговора", Формат(ДанныеСотрудника[0].ТрудовойДоговорДата, "ДЛФ=D"));
			ДанныеПечати.Вставить("ДатаДоговораПолная", Формат(ДанныеСотрудника[0].ТрудовойДоговорДата, "Л="+КодЯзыкаПечать+";ДЛФ=DD"));
			ДанныеПечати.Вставить("ДолжностьСовмещающегоСотрудника", ДанныеСотрудника[0].Должность);
		КонецЕсли;
		
		// Данные отсутствующего сотрудника.
		ДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ОтсутствующийСотрудник), 
			"Должность", ДокументДляПечати.Дата);
			
		Если ДокументДляПечати.ПричинаСовмещения = Перечисления.ПричиныСовмещения.СовмещениеПрофессийДолжностей Тогда
			ДанныеПечати.Вставить("ДолжностьОтсутствующегоСотрудника", ДокументДляПечати.СовмещаемаяДолжность);
		ИначеЕсли ДанныеСотрудника.Количество() > 0 Тогда
			ДанныеПечати.Вставить("ДолжностьОтсутствующегоСотрудника", ДанныеСотрудника[0].Должность);
		КонецЕсли;
		
		// Данные отсутствующего физического лица.
		ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ОтсутствующееФизическоеЛицо), 
			"ФИОПолные,Пол", ДокументДляПечати.Дата);
			
		Если ДанныеФизическогоЛица.Количество() > 0 Тогда				
			ДанныеПечати.Вставить("ФИООтсутствующегоСотрудника", ДанныеФизическогоЛица[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИООтсутствующегоСотрудникаРодительный", ДанныеФизическогоЛица[0].ФИОПолные);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИООтсутствующегоСотрудникаРодительный),
				2, ДанныеПечати.ФИООтсутствующегоСотрудникаРодительный, ДанныеФизическогоЛица[0].Пол);
		КонецЕсли;
		
		// Сумма договора и валюта
		ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДокументДляПечати.РазмерДоплаты, ВалютаУчета,, КодЯзыкаПечать);
		ДанныеПечати.Вставить("НаименованиеВалюты", ВалютаУчета);
		ДанныеПечати.Вставить("РазмерДоплатыПрописью", СуммаПрописью);
		
		// Приведение значений к требуемому формату.
		Если Не ДанныеПечати.Свойство("ДолжностьСовмещающегоСотрудника") Тогда
			ДанныеПечати.Вставить("ДолжностьСовмещающегоСотрудника", "________________________");
		ИначеЕсли Не ЗначениеЗаполнено(ДанныеПечати.ДолжностьСовмещающегоСотрудника) Тогда
			ДанныеПечати.ДолжностьСовмещающегоСотрудника =  "________________________";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеПечати.ФИОРуководителяСклоняемое) Тогда
			ДанныеПечати.ФИОРуководителяСклоняемое =  "__________________________________";
		КонецЕсли;
		
		Если Не ДанныеПечати.Свойство("Именуемый") Тогда
			ДанныеПечати.Вставить("Именуемый", НСтр("ru='именуемый(ая)';uk='іменований(а)'"));
		КонецЕсли;
		Если Не ДанныеПечати.Свойство("Занимающий") Тогда
			ДанныеПечати.Вставить("Занимающий", НСтр("ru='занимающим(ей)';uk='займаючим(ою)'"));
		КонецЕсли;
		Если Не ДанныеПечати.Свойство("Действующего") Тогда
			ДанныеПечати.Вставить("Действующего", НСтр("ru='действующего(ей)';uk='діючого(ої)'"));
		КонецЕсли;
		Если ВалютаУчета = Справочники.Валюты.НайтиПоКоду("980") Тогда
			ДанныеПечати.НаименованиеВалюты = "грн.";
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное) Тогда
			ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное = "_________________";
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(ДанныеПечати.ФИОРуководителяСокращенное) Тогда
			ДанныеПечати.ФИОРуководителяСокращенное = "_________________";
		КонецЕсли; 
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(ДокументДляПечати.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

#КонецОбласти

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическоеЛицо = ?(ЗначениеЗаполнено(Объект.СовмещающийСотрудник), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СовмещающийСотрудник, "ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

#КонецОбласти

#КонецЕсли