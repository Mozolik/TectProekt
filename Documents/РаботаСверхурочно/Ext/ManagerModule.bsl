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
		КомандыСозданияДокументов, Метаданные.Документы.РаботаСверхурочно);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о сверхурочной работе.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОСверхурочнойРаботе";
	КомандаПечати.Представление = НСтр("ru='Приказ о сверхурочной работе';uk='Наказ про понаднормову роботу'");
	КомандаПечати.Порядок = 10;
	
	// График сверхурочной работы
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_ГрафикСверхурочнойРаботы";
	КомандаПечати.Представление = НСтр("ru='График сверхурочной работы';uk='Графік понаднормової роботи'");
	КомандаПечати.Порядок = 20;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОСверхурочнойРаботе") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм, 
						"ПФ_MXL_ПриказОСверхурочнойРаботе", 
						("ru = 'Приказ о сверхурочной работе'"), 
						ПечатнаяФормаПриказаОСверхурочнойРаботе(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
						"Документ.РаботаСверхурочно.ПФ_MXL_ПриказОСверхурочнойРаботе",,Истина);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ГрафикСверхурочнойРаботы") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм, 
						"ПФ_MXL_ГрафикСверхурочнойРаботы", 
						("ru = 'График сверхурочной работы'"), 
						ПечатнаяФормаГрафикаСверхурочнойРаботы(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
						"Документ.РаботаСверхурочно.ПФ_MXL_ГрафикСверхурочнойРаботы",,Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеРабочегоВремени", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

#Область ПроцедурыФункцииПечати

Функция ПечатнаяФормаПриказаОСверхурочнойРаботе(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОСверхурочнойРаботе";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РаботаСверхурочно.ПФ_MXL_ПриказОСверхурочнойРаботе", КодЯзыкаПечать);
	
	ОбластьШапка 	  = Макет.ПолучитьОбласть("Шапка");
	ОбластьДатаРаботы = Макет.ПолучитьОбласть("ДатаРаботы");
	ОбластьРаботник   = Макет.ПолучитьОбласть("Работник");
	ОбластьПодвал 	  = Макет.ПолучитьОбласть("Подвал");
	ОбластьОзнакомлен = Макет.ПолучитьОбласть("Ознакомлен");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказаОСверхурочнойРаботе(МассивОбъектов);
	
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоСтрокам 	= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТаблицаСотрудники = Новый ТаблицаЗначений;
	ТаблицаСотрудники.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудники.Колонки.Добавить("ФИО", Новый ОписаниеТипов("Строка"));
	ТаблицаСотрудники.Колонки.Добавить("Должность", Новый ОписаниеТипов("Строка"));
	ТаблицаСотрудники.Колонки.Добавить("ДатаДок", Новый ОписаниеТипов("Дата"));
	
	Пока ВыборкаПоДокументам.Следующий() Цикл  
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		НомерПункта = 0;
		ТаблицаСотрудники.Очистить();
		
		Параметры = ПолучитьСтруктуруПараметровПриказаОСверхурочнойРаботе();
		КадровыйУчет.ЗаполнитьПараметрыКадровогоПриказа(Параметры, ВыборкаПоДокументам);
		
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, Параметры);
		
		ОбластьШапка.Параметры.ДатаДок = Формат(Параметры.ДатаДок, "ДЛФ=D");
	
		ТабДокумент.Вывести(ОбластьШапка);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
		
		ВыборкаПоСтрокам.Сбросить();
		
		Пока ВыборкаПоСтрокам.НайтиСледующий(СтруктураПоиска) Цикл 
			
			ВыборкаПоДатам = ВыборкаПоСтрокам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПоДатам.Следующий() Цикл 
				
				НомерПункта = НомерПункта + 1;
				
				ОбластьДатаРаботы.Параметры.НомерПункта = НомерПункта;
				ОбластьДатаРаботы.Параметры.ДатаРаботы = Формат(ВыборкаПоДатам.Дата, "Л="+КодЯзыкаПечать+";ДЛФ=ДД");
				
				ТабДокумент.Вывести(ОбластьДатаРаботы);
				
				ВыборкаПоСотрудникам = ВыборкаПоДатам.Выбрать();
				
				Пока ВыборкаПоСотрудникам.Следующий() Цикл 
					
					ДанныеСтроки = Новый Структура;
					ДанныеСтроки.Вставить("Сотрудник", ВыборкаПоСотрудникам.Сотрудник);
					ДанныеСтроки.Вставить("ФИО", ВыборкаПоСотрудникам.ФамилияИО);
					ДанныеСтроки.Вставить("Должность", ВыборкаПоСотрудникам.Должность);
					
					ЗаполнитьЗначенияСвойств(ОбластьРаботник.Параметры, ДанныеСтроки);
					ТабДокумент.Вывести(ОбластьРаботник);
					
					Если ТаблицаСотрудники.Найти(ВыборкаПоСотрудникам.Сотрудник, "Сотрудник") = Неопределено Тогда 
						ДанныеСтроки.Вставить("ФИО", ВыборкаПоСотрудникам.ИОФамилия);
						НоваяСтрока = ТаблицаСотрудники.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		ОбластьПодвал.Параметры.НомерПункта1 = НомерПункта + 1;
		
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТаблицаСотрудники.Сортировать("ФИО");
		ТаблицаСотрудники.ЗаполнитьЗначения(ВыборкаПоДокументам.ДатаДок, "ДатаДок");
		
		Для Каждого ТекСтрока Из ТаблицаСотрудники Цикл 
			ЗаполнитьЗначенияСвойств(ОбластьОзнакомлен.Параметры, ТекСтрока);
			ТабДокумент.Вывести(ОбластьОзнакомлен);
		КонецЦикла;
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ДанныеДляПечатиПриказаОСверхурочнойРаботе(МассивОбъектов)
	
	// Запрос по шапкам документов.
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботаСверхурочно.Ссылка КАК Ссылка,
	|	РаботаСверхурочно.Дата КАК Дата,
	|	РаботаСверхурочно.Номер КАК Номер,
	|	РаботаСверхурочно.Причина КАК Причина,
	|	РаботаСверхурочно.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(РаботаСверхурочно.Организация.НаименованиеПолное, 1, 10) = """"
	|			ТОГДА РаботаСверхурочно.Организация.Наименование
	|		ИНАЧЕ РаботаСверхурочно.Организация.НаименованиеПолное
	|	КОНЕЦ КАК НазваниеОрганизации,
	|	РаботаСверхурочно.Руководитель КАК Руководитель,
	|	РаботаСверхурочно.ДолжностьРуководителя КАК ДолжностьРуководителя
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.РаботаСверхурочно КАК РаботаСверхурочно
	|ГДЕ
	|	РаботаСверхурочно.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Номер КАК НомерДок,
	|	ДанныеДокументов.Дата КАК ДатаДок,
	|	ДанныеДокументов.Причина КАК Причина,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
	|	ДанныеДокументов.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
	|		ПО ДанныеДокументов.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо
	|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДок";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке", РезультатЗапроса);
	
	// Запрос по табличным частям
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботаСверхурочноСотрудники.Ссылка КАК Ссылка,
	|	РаботаСверхурочноСотрудники.Сотрудник КАК Сотрудник,
	|	РаботаСверхурочноСотрудники.Дата КАК Дата,
	|	РаботаСверхурочноСотрудники.Ссылка.Дата КАК Период
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.РаботаСверхурочно.Сотрудники КАК РаботаСверхурочноСотрудники
	|ГДЕ
	|	РаботаСверхурочноСотрудники.Ссылка В(&МассивОбъектов)
	|	И РаботаСверхурочноСотрудники.ОтработаноЧасов > 0";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФамилияИО,ИОФамилия,Должность");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Дата КАК Дата,
	|	ДанныеДокументов.Сотрудник КАК Сотрудник,
	|	КадровыеДанныеСотрудников.Должность.Наименование КАК Должность,
	|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
	|	КадровыеДанныеСотрудников.ИОФамилия КАК ИОФамилия
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеДокументов.Период = КадровыеДанныеСотрудников.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Дата,
	|	КадровыеДанныеСотрудников.ФамилияИО
	|ИТОГИ ПО
	|	Ссылка,
	|	Дата";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатЗапроса);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПолучитьСтруктуруПараметровПриказаОСверхурочнойРаботе()
	
	Параметры = КадровыйУчет.ПараметрыКадровогоПриказа();
	
	Параметры.Вставить("Причина");
	
	Возврат Параметры;
	
КонецФункции

Функция ПечатнаяФормаГрафикаСверхурочнойРаботы(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ГрафикСверхурочнойРаботы";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РаботаСверхурочно.ПФ_MXL_ГрафикСверхурочнойРаботы", КодЯзыкаПечать);
	
	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаРаботник 	= Макет.ПолучитьОбласть("Шапка|Работник");
	ОбластьШапкаДатаРаботы 	= Макет.ПолучитьОбласть("Шапка|Дата");
	ОбластьСтрокаРаботник 	= Макет.ПолучитьОбласть("СтрокаТаблицы|Работник");
	ОбластьСтрокаДатаРаботы = Макет.ПолучитьОбласть("СтрокаТаблицы|Дата");
	ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
	
	ВыводимыеОбласти = Новый Массив;
	ВыводимыеОбласти.Добавить(ОбластьСтрокаРаботник);
	ВыводимыеОбласти.Добавить(ОбластьПодвал);
		
	ДанныеДляПечати = ДанныеДляПечатиГрафикаСверхурочнойРаботы(МассивОбъектов);
	
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоСтрокам 	= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоДатам 		= ДанныеДляПечати.РезультатПоДатам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл  
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Параметры = ПолучитьСтруктуруПараметровГрафикаСверхурочнойРаботы();
		КадровыйУчет.ЗаполнитьПараметрыКадровогоПриказа(Параметры, ВыборкаПоДокументам);
			
		ЗаполнитьЗначенияСвойств(ОбластьЗаголовок.Параметры, Параметры);
		
		ОбластьЗаголовок.Параметры.ДатаДок = Формат(Параметры.ДатаДок, "ДЛФ=D");
		
		ТабДокумент.Вывести(ОбластьЗаголовок);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
		
		ВыборкаПоДатам.Сбросить();
		
		Если ВыборкаПоДатам.НайтиСледующий(СтруктураПоиска) Тогда 
			
			ТабДокумент.Вывести(ОбластьШапкаРаботник);
			
			Выборка = ВыборкаПоДатам.Выбрать();
			
			Пока Выборка.Следующий() Цикл 
				
				ОбластьШапкаДатаРаботы.Параметры.ЗаголовокКолонки = Формат(Выборка.Дата, "ДЛФ=Д");
				ТабДокумент.Присоединить(ОбластьШапкаДатаРаботы);
				
			КонецЦикла;
			
		КонецЕсли;	
		
		ВыборкаПоСтрокам.Сбросить();
		
		Если ВыборкаПоСтрокам.НайтиСледующий(СтруктураПоиска) Тогда  
			
			ВыборкаПоСотрудникам = ВыборкаПоСтрокам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоСтрок = ВыборкаПоСотрудникам.Количество();
			НомерСтроки = 0;
			
			Пока ВыборкаПоСотрудникам.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				Если НомерСтроки < КоличествоСтрок 
					И Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, ОбластьСтрокаРаботник) Тогда
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ИначеЕсли НомерСтроки = КоличествоСтрок
					И Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти) Тогда
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				
				ВыборкаПоФИО = ВыборкаПоСотрудникам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаПоФИО.Следующий() Цикл 
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаРаботник.Параметры, ВыборкаПоФИО);
					ТабДокумент.Вывести(ОбластьСтрокаРаботник);
					
					Выборка = ВыборкаПоФИО.Выбрать();
					
					Пока Выборка.Следующий() Цикл
						
						ЗаполнитьЗначенияСвойств(ОбластьСтрокаДатаРаботы.Параметры, Выборка);
						ТабДокумент.Присоединить(ОбластьСтрокаДатаРаботы);
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, ВыборкаПоДокументам);
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ДанныеДляПечатиГрафикаСверхурочнойРаботы(МассивОбъектов)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ИспользуетсяМногофункциональностьДокументов", ПолучитьФункциональнуюОпцию("ИспользоватьМногофункциональностьДокументовЗарплатаКадры"));
	
	// Запрос по шапкам документов.
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РаботаСверхурочно.Ссылка КАК Ссылка,
	               |	РаботаСверхурочно.Дата КАК ДатаДок,
	               |	РаботаСверхурочно.Номер КАК НомерДок,
	               |	РаботаСверхурочно.Причина КАК Причина,
	               |	РаботаСверхурочно.Организация КАК Организация,
	               |	ВЫБОР
	               |		КОГДА ПОДСТРОКА(РаботаСверхурочно.Организация.НаименованиеПолное, 1, 10) = """"
	               |			ТОГДА РаботаСверхурочно.Организация.Наименование
	               |		ИНАЧЕ РаботаСверхурочно.Организация.НаименованиеПолное
	               |	КОНЕЦ КАК НазваниеОрганизации,
	               |	ВЫБОР
	               |		КОГДА &ИспользуетсяМногофункциональностьДокументов
	               |			ТОГДА РаботаСверхурочно.ВремяУчел.Наименование
	               |		ИНАЧЕ РаботаСверхурочно.Ответственный.Наименование
	               |	КОНЕЦ КАК ФИООтветственного
	               |ИЗ
	               |	Документ.РаботаСверхурочно КАК РаботаСверхурочно
	               |ГДЕ
	               |	РаботаСверхурочно.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаДок";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке", РезультатЗапроса);
	
	// Запрос по табличным частям
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РаботаСверхурочноСотрудники.Ссылка КАК Ссылка,
	               |	РаботаСверхурочноСотрудники.Сотрудник КАК Сотрудник,
	               |	РаботаСверхурочноСотрудники.Дата КАК Дата,
	               |	СУММА(РаботаСверхурочноСотрудники.ОтработаноЧасов) КАК ОтработаноЧасов,
	               |	РаботаСверхурочноСотрудники.Ссылка.Дата КАК Период
	               |ПОМЕСТИТЬ ВТДанныеДокументов
	               |ИЗ
	               |	Документ.РаботаСверхурочно.Сотрудники КАК РаботаСверхурочноСотрудники
	               |ГДЕ
	               |	РаботаСверхурочноСотрудники.Ссылка В(&МассивОбъектов)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	РаботаСверхурочноСотрудники.Ссылка,
	               |	РаботаСверхурочноСотрудники.Дата,
	               |	РаботаСверхурочноСотрудники.Сотрудник,
	               |	РаботаСверхурочноСотрудники.Ссылка.Дата";
				   
	Запрос.Выполнить();			   
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФИОПолные, Должность");
				   
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ДанныеДокументов.Ссылка КАК Ссылка,
	               |	ДанныеДокументов.Дата КАК Дата,
	               |	ДанныеДокументов.Сотрудник КАК Сотрудник,
	               |	ДанныеДокументов.ОтработаноЧасов КАК ОтработаноЧасов,
	               |	КадровыеДанныеСотрудников.Должность.Наименование КАК Должность,
	               |	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные
	               |ИЗ
	               |	ВТДанныеДокументов КАК ДанныеДокументов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	               |		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	               |			И ДанныеДокументов.Период = КадровыеДанныеСотрудников.Период
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка,
	               |	ФИОПолные,
	               |	Дата
	               |ИТОГИ ПО
	               |	Ссылка,
	               |	Сотрудник,
	               |	ФИОПолные
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ДанныеДокументов.Ссылка КАК Ссылка,
	               |	ДанныеДокументов.Дата КАК Дата
	               |ИЗ
	               |	ВТДанныеДокументов КАК ДанныеДокументов
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка,
	               |	Дата
	               |ИТОГИ ПО
	               |	Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РезультатПоТабличнойЧасти = РезультатыЗапроса[0];
	РезультатПоДатам = РезультатыЗапроса[1];
	
	ДанныеДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатПоТабличнойЧасти);
	ДанныеДляПечати.Вставить("РезультатПоДатам", РезультатПоДатам);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПолучитьСтруктуруПараметровГрафикаСверхурочнойРаботы()
		
		Параметры = КадровыйУчет.ПараметрыКадровогоПриказа();
		
		Параметры.Вставить("ФИООтветственного");
		
		Возврат Параметры;
		
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли