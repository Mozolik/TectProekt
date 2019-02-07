﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.УвольнениеСписком - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.УвольнениеСписком - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт

	Документы.Увольнение.ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов, Движения, Объект, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.УвольнениеСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ об увольнении
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_УвольнениеСотрудников";
	КомандаПечати.Представление = НСтр("ru='Приказ об увольнении';uk='Наказ про звільнення'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная,ЧтениеНачисленнойЗарплатыРасширенная", , Ложь) 
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		// Записка-расчет при увольнении.
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_РасчетПриУвольнении";
		КомандаПечати.Представление = НСтр("ru='Записка-расчет при увольнении';uk='Записка-розрахунок при звільненні'");
		КомандаПечати.Порядок = 20;
		КомандаПечати.ФункциональныеОпции = "РаботаВХозрасчетнойОрганизации";
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	// Расчет среднего заработка
	УчетСреднегоЗаработка.ДобавитьКомандуПечатиРасчетаСреднегоЗаработка(КомандыПечати, "Документ.УвольнениеСписком");
	УчетСреднегоЗаработка.ДобавитьКомандуПечатиРасчетаСреднегоЗаработкаВыходногоПособия(КомандыПечати, "Документ.УвольнениеСписком");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		МодульГосударственнаяСлужба = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		МодульГосударственнаяСлужба.ДобавитьКомандыПечатиСохраняемогоДенежногоСодержания(КомандыПечати);
	КонецЕсли; 
	
	// Подробный расчет начислений.
	РасчетЗарплатыРасширенный.ДобавитьКомандуПечатиПодробногоРасчетаНачислений(КомандыПечати);

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
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработка") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ДанныеДокументов = ДанныеДокументовДляПечатиРасчетаСреднегоЗаработка(МассивОбъектов);
		ТабличныйДокумент = Обработки.ПечатьРасчетаСреднегоЗаработка.ТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокументов, ОбъектыПечати, "РасчетСреднегоЗаработка", Истина, ПараметрыВывода);
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм, 
				"РасчетСреднегоЗаработка",
				НСтр("ru='Расчет среднего заработка';uk='Розрахунок середнього заробітку'"), 
				ТабличныйДокумент,
				,
				,
				,
				Истина	// ЭтоМногоязычнаяПечатнаяФорма
			);
		КонецЕсли;
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработкаВыходногоПособия") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ДанныеДокументов = ДанныеДокументовДляПечатиРасчетаСреднегоЗаработка(МассивОбъектов, "РасчетСреднегоЗаработкаВыходногоПособия");
		ТабличныйДокумент = Обработки.ПечатьРасчетаСреднегоЗаработка.ТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокументов, ОбъектыПечати, "РасчетСреднегоЗаработкаВыходногоПособия", Истина, ПараметрыВывода);
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм, 
				"РасчетСреднегоЗаработкаВыходногоПособия",
				НСтр("ru='Расчет среднего заработка (для выходного пособия)';uk='Розрахунок середнього заробітку (для вихідної допомоги)'"), 
				ТабличныйДокумент,				
				,
				,
				,
				Истина	// ЭтоМногоязычнаяПечатнаяФорма
			);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Объект.Сотрудники.Выгрузить(, "Сотрудник").ВыгрузитьКолонку("Сотрудник"), "ФизическоеЛицо");
	Если ФизическиеЛицаСотрудников.Количество() > 0 Тогда
		ФизическиеЛица = ОбщегоНазначения.ВыгрузитьКолонку(ФизическиеЛицаСотрудников, "Значение");
	Иначе
		ФизическиеЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ФизическиеЛица.ПустаяСсылка());
	КонецЕсли;
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ФизическиеЛица;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции


#Область ПечатьРасчетаСреднегоЗаработка

// Заполняет таблицу значений - параметры формирования печатной формы расчета среднего заработка.
//
// Параметры:
//	 МассивСсылок 		- массив, печатаемые документы.
//
Функция ДанныеДокументовДляПечатиРасчетаСреднегоЗаработка(МассивСсылок, ИмяМакета = "") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	СоздатьВТКадровыеДанныеСотрудниковДокумента(Запрос);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документ.Сотрудник КАК Сотрудник,
	|	Документ.ДатаУвольнения КАК ДатаНачалаСобытия,
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Ссылка.Организация КАК Организация,
	|	Документ.Ссылка.Дата КАК ДатаДокумента,
	|	Документ.Ссылка.Номер КАК НомерДокумента,
	|	Документ.ДатаУвольнения КАК ДатаНачалаОтсутствия,
	|	Документ.ДатаУвольнения КАК ДатаОкончания,
	|	Документ.ПериодРасчетаСреднегоЗаработкаНачало КАК НачалоРасчетногоПериода,
	|	Документ.ПериодРасчетаСреднегоЗаработкаОкончание КАК ОкончаниеРасчетногоПериода,
	|	Документ.ВидРасчетаКомпенсацииУдержанияОтпуска КАК Начисление,
	|	Документ.СуммированныйУчет,
	|	ЕСТЬNULL(КраткосрочныеТрудовыеДоговорыСотрудников.КраткосрочныйТрудовойДоговор, ЛОЖЬ) КАК КраткосрочныйТрудовойДоговор,
	|	ВТКадровыеДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТКадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
	|	ВТКадровыеДанныеСотрудников.ТабельныйНомер КАК ТабельныйНомер,
	|	ВТКадровыеДанныеСотрудников.Подразделение КАК Подразделение,
	|	ВТКадровыеДанныеСотрудников.Должность КАК Должность,
	|	ВТКадровыеДанныеСотрудников.ВидЗанятости КАК ВидЗанятости,
	|	Организации.Наименование КАК НаименованиеОрганизации,
	|	Организации.НаименованиеПолное КАК ПолноеНаименованиеОрганизации,
	|	Документ.Ссылка.Ответственный
	|ИЗ
	|	Документ.УвольнениеСписком.Сотрудники КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК ВТКадровыеДанныеСотрудников
	|		ПО Документ.Сотрудник = ВТКадровыеДанныеСотрудников.Сотрудник
	|			И Документ.ДатаУвольнения = ВТКадровыеДанныеСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКраткосрочныеТрудовыеДоговорыСотрудников КАК КраткосрочныеТрудовыеДоговорыСотрудников
	|		ПО Документ.Сотрудник = КраткосрочныеТрудовыеДоговорыСотрудников.Сотрудник
	|			И Документ.ДатаУвольнения = КраткосрочныеТрудовыеДоговорыСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Документ.Ссылка.Организация = Организации.Ссылка
	|ГДЕ
	|	Документ.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Сотрудник";
	
	Результат = Запрос.Выполнить();
	
	ДанныеДокументов = Новый Массив;
	
	Если Результат.Пустой() Тогда
		Возврат ДанныеДокументов;
	КонецЕсли;
		
	ТаблицыДанныхОСреднем = УчетСреднегоЗаработка.ТаблицыДанныхОСреднемЗаработке("УвольнениеСписком", МассивСсылок);
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
			Если ИмяМакета = "РасчетСреднегоЗаработкаВыходногоПособия" Тогда
				СпособРасчета = Неопределено;
				ИспользоватьСреднеЧасовойЗаработок = Выборка.СуммированныйУчет;
			Иначе
				ИспользоватьСреднеЧасовойЗаработок = Ложь;
				Если Выборка.КраткосрочныйТрудовойДоговор Тогда
					СпособРасчета = Перечисления.СпособыРасчетаНачислений.ОплатаОтпускаПоШестидневке;
				Иначе 	
					СпособРасчета = Перечисления.СпособыРасчетаНачислений.ОплатаОтпускаПоКалендарнымДням;
				КонецЕсли;
			КонецЕсли;
				
			ДанныеДокумента = Обработки.ПечатьРасчетаСреднегоЗаработка.ПустаяСтруктураДанныхДляПечатиСреднегоЗаработка(); 
			ЗаполнитьЗначенияСвойств(ДанныеДокумента.РеквизитыДокумента, Выборка);
			ДанныеДокумента.РеквизитыДокумента.ВидОтпуска = ?(Выборка.Ссылка.ДополнительныеОтпуска.Количество() = 0, "Основной отпуск", "Дополнительный отпуск");
			ЗаполнитьЗначенияСвойств(ДанныеДокумента.КадровыеДанныеСотрудника, Выборка);
			
			ДанныеОНачислениях 	= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ТаблицыДанныхОСреднем["ДанныеОНачислениях"], 		"Ссылка", 		Выборка.Ссылка);
			ДанныеОНачислениях 	= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ДанныеОНачислениях, 								"Сотрудник", 	Выборка.Сотрудник);
			
			ДанныеОВремени 		= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ТаблицыДанныхОСреднем["ДанныеОВремени"], 			"Ссылка", 		Выборка.Ссылка);
			ДанныеОВремени 		= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ДанныеОВремени, 									"Сотрудник", 	Выборка.Сотрудник);
			
			ДанныеОбИндексации 	= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ТаблицыДанныхОСреднем["ДанныеОбИндексации"], 		"Ссылка", 		Выборка.Ссылка);
			ДанныеОбИндексации 	= УчетСреднегоЗаработка.ТаблицаОтобраннаяПоПолю(ДанныеОбИндексации, 								"Сотрудник", 	Выборка.Сотрудник);
			
			ДополнительныеПараметры = УчетСреднегоЗаработкаКлиентСервер.ДополнительныеПараметрыРасчетаСреднегоЗаработка();
			ДополнительныеПараметры.Индексации = ДанныеОбИндексации;
			ДополнительныеПараметры.ДатаНачалаСобытия = Выборка.ДатаНачалаСобытия;
			ДополнительныеПараметры.НачалоПериода = Выборка.НачалоРасчетногоПериода;
			ДополнительныеПараметры.ОкончаниеПериода = Выборка.ОкончаниеРасчетногоПериода;
			ДополнительныеПараметры.ПоЧасам = ИспользоватьСреднеЧасовойЗаработок;
			ДополнительныеПараметры.СпособРасчетаОтпуска = СпособРасчета;
			ДополнительныеПараметры.ПорядокРасчета = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаСреднегоЗаработкаОбщий.Постановление100Отпускные");
		
			ДанныеДокумента.ДанныеРасчетаСреднего = УчетСреднегоЗаработкаКлиентСервер.ДанныеДляРасчетаСреднегоЗаработка(ДанныеОНачислениях, ДанныеОВремени, ДополнительныеПараметры);
			
			ДанныеДокумента.ПараметрыРасчета.СпособРасчета = СпособРасчета;
			ДанныеДокумента.ПараметрыРасчета.ИспользоватьСреднеЧасовойЗаработок = ИспользоватьСреднеЧасовойЗаработок;
			ДанныеДокумента.ПараметрыРасчета.НачалоРасчетногоПериода = Выборка.НачалоРасчетногоПериода;
			ДанныеДокумента.ПараметрыРасчета.ОкончаниеРасчетногоПериода = Выборка.ОкончаниеРасчетногоПериода;
			
			ДанныеДокументов.Добавить(ДанныеДокумента);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

Процедура СоздатьВТКадровыеДанныеСотрудниковДокумента(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документ.Сотрудник,
	|	Документ.ДатаУвольнения КАК Период
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	Документ.УвольнениеСписком.Сотрудники КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивСсылок)";
	Запрос.Выполнить();
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудники");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(Описатель, Истина, "ФизическоеЛицо,ФИОПолные,ТабельныйНомер,Подразделение,Должность,ВидЗанятости,ДатаПриема,ПриказОПриемеДатаЗавершенияТрудовогоДоговора,КраткосрочныйТрудовойДоговор");
	
	ОстаткиОтпусков.СоздатьВТКраткосрочныеТрудовыеДоговорыСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудники", "Сотрудник,Период", Ложь);
	
	Запрос.Текст = "УНИЧТОЖИТЬ ВТСотрудники";
	Запрос.Выполнить();

КонецПроцедуры

#КонецОбласти


#Область ПечатьПодробногоРасчетаНачислений

// Заполняет структуру - описание документа для формирования печатной формы подробного расчета начислений.
//
// Параметры:
//   ОписаниеДокумента - структура, определяется в Обработки.ПечатьРасчетаНачислений.ОписаниеДокументаРасчетаНачислений.
//
Процедура ЗаполнитьОписаниеДокументаРасчетаНачислений(ОписаниеДокумента) Экспорт
	
	КатегорииСпециализированногоНачисления = Новый Массив;
	КатегорииСпециализированногоНачисления.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияОтпуска);
	КатегорииСпециализированногоНачисления.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособие);
	
	МетаданныеДокумента = ПустаяСсылка().Метаданные();
	
	ОписаниеДокумента.Вставить("ИмяДокумента", 								МетаданныеДокумента.Имя);
	ОписаниеДокумента.Вставить("СинонимДокумента", 							МетаданныеДокумента.Синоним);
	ОписаниеДокумента.Вставить("ЕстьРасчетСреднегоЗаработка", 				Истина);
	ОписаниеДокумента.Вставить("ЕстьРасчетСпециализированныхНачислений",	Истина);
	ОписаниеДокумента.Вставить("ЕстьРасчетЗарплаты", 						Истина);
	ОписаниеДокумента.Вставить("КатегорииСпециализированногоНачисления", 	КатегорииСпециализированногоНачисления);
	ОписаниеДокумента.Вставить("НазваниеСпециализированногоНачисления", 	НСтр("ru='Расчет при увольнении';uk='Розрахунок при звільненні'"));
	
КонецПроцедуры 

// Заполняет таблицу значений - параметры формирования печатной формы подробного расчета начислений.
//
// Параметры:
//	 МассивСсылок 		- массив, печатаемые документы.
//   ДанныеДокумента 	- таблица значений, определяется в
//                      Обработки.ПечатьРасчетаНачислений.ДанныеДокументовДляПодробногоРасчетаНачислений.
//
Процедура ЗаполнитьДанныеДокументовДляПодробногоРасчетаНачислений(МассивСсылок, ДанныеДокументов) Экспорт
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеДокументовДляПодробногоРасчетаНачислений(МассивСсылок, ПустаяСсылка().Метаданные().Имя, ДанныеДокументов, "Сотрудники");	
КонецПроцедуры

// Возвращает структуру с двумя таблицами "Начисления" и "Показатели".
// Данные в таблицах представлены в разрезе ссылки на документ.
// 	Параметры:
//		МассивСсылок - массив ссылок на документы у которых есть табличные части "Начисления" и "Показатели".
//		ИмяДокумента - Имя объекта метаданных (документа) для формирования запроса.
//
Функция НачисленияПоказателиДокументов(МассивСсылок) Экспорт 
	Возврат РасчетЗарплатыРасширенный.НачисленияПоказателиДокументов(МассивСсылок, ПустаяСсылка().Метаданные().Имя);	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
