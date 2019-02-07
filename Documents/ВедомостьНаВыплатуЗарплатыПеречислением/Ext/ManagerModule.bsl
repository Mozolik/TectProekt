﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьСостав() Экспорт
	ВзаиморасчетыССотрудниками.ЗаполнитьСоставВедомости("Документ.ВедомостьНаВыплатуЗарплатыПеречислением", "ФизическоеЛицо, БанковскийСчет");
КонецПроцедуры	

#КонецОбласти

Функция РеквизитыОтветственныхЛиц() Экспорт
	Возврат ВзаиморасчетыССотрудниками.ВедомостьРеквизитыОтветственныхЛиц();
КонецФункции	

Функция БанковскиеСчетаСотрудников(Сотрудники, Банк) Экспорт
	
	БанковскиеСчетаСотрудников = Новый Соответствие;
	
	МестаВыплатыЗарплатыСотрудников = 
		ВзаиморасчетыССотрудникамиРасширенный.МестаВыплатыЗарплатыСотрудников(
			Сотрудники,
			Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет);
			
	БанкиМестВыплаты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МестаВыплатыЗарплатыСотрудников.ВыгрузитьКолонку("МестоВыплаты"), "Банк");
	
	Для Каждого Сотрудник Из Сотрудники Цикл
		МестоВыплатыЗарплатыСотрудника = МестаВыплатыЗарплатыСотрудников.Найти(Сотрудник, "Сотрудник");
		Если МестоВыплатыЗарплатыСотрудника = Неопределено 
			ИЛИ (ЗначениеЗаполнено(Банк) И БанкиМестВыплаты[МестоВыплатыЗарплатыСотрудника.МестоВыплаты].Банк <> Банк) Тогда
			БанковскиеСчетаСотрудников.Вставить(Сотрудник, Справочники.БанковскиеСчетаКонтрагентов.ПустаяСсылка());
		Иначе
			БанковскиеСчетаСотрудников.Вставить(Сотрудник, МестоВыплатыЗарплатыСотрудника.МестоВыплаты);
		КонецЕсли
	КонецЦикла;
	
	Возврат БанковскиеСчетаСотрудников
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Список перечислений
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СписокПеречислений";
	КомандаПечати.Представление = НСтр("ru='Список перечислений';uk='Список перерахувань'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
		УчетНДФЛРасширенный.ДобавитьКомандуПечатиРеестраПеречисленногоНалога(КомандыПечати)
	
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
	
	Если УчетНДФЛРасширенный.НужноПечататьРеестрПеречисленногоНалога(КоллекцияПечатныхФорм) Тогда
		УчетНДФЛРасширенный.ВывестиРеестрПеречисленногоНалогаПоПлатежномуДокументу(КоллекцияПечатныхФорм, МассивОбъектов, ОбъектыПечати);	
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокПеречислений") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокПеречислений", НСтр("ru='Список получателей';uk='Список одержувачів'"), ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,,, Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьНаВыплатуЗарплатыВБанк_СписокПеречислений";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьНаВыплатуЗарплатыПеречислением.ПФ_MXL_СписокПеречислений", КодЯзыкаПечать);
	
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицы(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();

		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// Массив с двумя строками - для разбиения на страницы.
	    ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
 		ОбластьМакетаШапкаДокумента.Параметры.Дата = Формат(ВыборкаШапок.Дата, "ДЛФ=D");
 		ОбластьМакетаШапкаДокумента.Параметры.Организация = СокрЛП(ВыборкаШапок.Организация);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// Выводим данные по строкам документа.
		НомерСтроки = 0;
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Ссылка, "Ведомость") Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьМакетаСтрока.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакетаСтрока.Параметры.Физлицо = ВыборкаСтрок.Фамилия +" "+ ВыборкаСтрок.Имя +" "+ ВыборкаСтрок.Отчество;
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
		Для Сч = 1 По ОбластьМакетаСтрока.Параметры.Количество() Цикл
			ОбластьМакетаСтрока.Параметры.Установить(Сч - 1,""); 
		КонецЦикла;
		ОбластьМакетаСтрока.Параметры.Физлицо = " ";
		Пока ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти) Цикл
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаШапок);
		ОбластьМакетаПодвал.Параметры.Итого = Итого;
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует запрос по документу.
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк.
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиШапки(Ведомости) Экспорт
	Возврат ВзаиморасчетыССотрудникамиВнутренний.ВедомостьВБанкВыборкаДляПечатиШапки(Метаданные.Документы.ВедомостьНаВыплатуЗарплатыПеречислением.ПолноеИмя(), Ведомости)
КонецФункции

// Формирует запрос по табличной части документа.
//
// Параметры: 
//  ДокументСсылка	- ссылка на документ.
//  ДатаДокумента	- дата документ.
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиТаблицы(Ведомости) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ведомости", Ведомости);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьЗарплата.Ссылка КАК Ссылка,
	|	ВедомостьЗарплата.Ссылка.Дата КАК Период,
	|	МИНИМУМ(ВедомостьСостав.НомерСтроки) КАК НомерСтроки,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьСостав.БанковскийСчет.НомерСчета КАК НомерСчета,
	|	СУММА(ВедомостьЗарплата.КВыплате) КАК Сумма
	|ПОМЕСТИТЬ ВТСписокФизическихЛиц
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыПеречислением.Зарплата КАК ВедомостьЗарплата
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыПеречислением.Состав КАК ВедомостьСостав
	|		ПО ВедомостьЗарплата.Ссылка = ВедомостьСостав.Ссылка
	|			И ВедомостьЗарплата.ИдентификаторСтроки = ВедомостьСостав.ИдентификаторСтроки
	|ГДЕ
	|	ВедомостьЗарплата.Ссылка В(&Ведомости)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьЗарплата.Ссылка,
	|	ВедомостьЗарплата.Ссылка.Дата,
	|	ВедомостьСостав.ФизическоеЛицо,
	|	ВедомостьСостав.БанковскийСчет.НомерСчета
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВедомостьЗарплата.КВыплате) > 0";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТСписокФизическихЛиц");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");

	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокФизическихЛиц.Ссылка КАК Ведомость,
	|	СписокФизическихЛиц.НомерСчета КАК НомерСчета,
	|	КадровыеДанныеФизическихЛиц.Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество,
	|	СписокФизическихЛиц.Сумма КАК Сумма
	|ИЗ
	|	ВТСписокФизическихЛиц КАК СписокФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО СписокФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И СписокФизическихЛиц.Период = КадровыеДанныеФизическихЛиц.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокФизическихЛиц.НомерСтроки";

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
