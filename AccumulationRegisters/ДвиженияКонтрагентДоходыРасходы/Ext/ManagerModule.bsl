﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ НЕ УТ
#Область ПрограммныйИнтерфейс
//++ НЕ УТКА

// Определяет источники уточнения счета, доступные в регистре и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиУточненияСчета()
//
Функция ИсточникиУточненияСчета(СвойстваИсточника) Экспорт
	
	ИсточникиУточненияСчета = Новый Соответствие;
	
	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаРасчетов,
		Новый Структура(СвойстваИсточника, "ГФУРасчетов"));
		
	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаДоходовРасходов,
		Новый Структура(СвойстваИсточника, "ГФУДоходовРасходов"));
		
	Возврат ИсточникиУточненияСчета;
	
КонецФункции

// Определяет источники подразделений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений()
//
Функция ИсточникиПодразделений() Экспорт

	ИсточникиПодразделений = Новый Соответствие;
	
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ХозяйственнаяОперация, "Подразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ОбъектРасчетовСКонтрагентом, "ОбъектРасчетовПодразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.АналитикаУчетаДоходовРасходов, "АналитикаДоходовРасходовПодразделение");
	
    Возврат ИсточникиПодразделений;
	
КонецФункции

// Определяет источники заполнения субконто.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиСубконто()
//
Функция ИсточникиСубконто() Экспорт

	МассивСубконто = Новый Массив;
	МассивСубконто.Добавить("Партнер");
	МассивСубконто.Добавить("Контрагент");
	МассивСубконто.Добавить("Договор");
	МассивСубконто.Добавить("СтатьяДоходовРасходов");
	МассивСубконто.Добавить("АналитикаДоходов");
	МассивСубконто.Добавить("АналитикаРасходов");

	Возврат Новый Структура("СубконтоДт, СубконтоКт", МассивСубконто, МассивСубконто);
	
КонецФункции

// Определяет показатели в валюте регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ПоказателиВВалюте()
//
Функция ПоказателиВВалюте(СвойстваПоказателей) Экспорт

	ПоказателиВВалюте = Новый Соответствие;
	
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалюте, Новый Структура(СвойстваПоказателей, "Валюта"));
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалютеВзаиморасчетов, Новый Структура(СвойстваПоказателей, "ВалютаВзаиморасчетов"));
	
	Возврат ПоказателиВВалюте;

КонецФункции

// Определяет документы отражаемые в международном учете.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ДокументыКОтражениюВМФУ()
//
Функция ДокументыКОтражениюВМеждународномУчете() Экспорт

	ДокументыКОтражению = Новый Массив;
	ДокументыКОтражению.Добавить("ВыбытиеДенежныхДокументов");
	ДокументыКОтражению.Добавить("ВыкупВозвратнойТарыКлиентом");
	ДокументыКОтражению.Добавить("КорректировкаПоступления");
	ДокументыКОтражению.Добавить("КорректировкаРеализации");
	ДокументыКОтражению.Добавить("НачисленияКредитовИДепозитов");
	ДокументыКОтражению.Добавить("ОтчетКомиссионера");
	ДокументыКОтражению.Добавить("ОтчетКомиссионераОСписании");
	ДокументыКОтражению.Добавить("ПередачаТоваровМеждуОрганизациями");
	ДокументыКОтражению.Добавить("ПереоценкаВалютныхСредств");
	ДокументыКОтражению.Добавить("ПоступлениеТоваровУслуг");
	ДокументыКОтражению.Добавить("ПоступлениеУслугПрочихАктивов");
	ДокументыКОтражению.Добавить("РеализацияУслугПрочихАктивов");
	ДокументыКОтражению.Добавить("СписаниеЗадолженности");
	ДокументыКОтражению.Добавить("ТаможеннаяДекларацияИмпорт");
	
	Возврат ДокументыКОтражению;

КонецФункции
//-- НЕ УТКА

// Определяет показатели регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.Показатели()
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРеглБезНДС", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ОбновлениеИнформационнойБазы


Процедура СформироватьДвиженияКонтрагентДоходыРасходыДанныеДляОбновления(Параметры) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = "РегистрНакопления.ДвиженияКонтрагентДоходыРасходы";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДД.Ссылка
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов КАК ДД
	|ГДЕ
	|	ДД.Проведен");
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКОбработке, ДополнительныеПараметрыОтметки);
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Переформирует движения по регистру накопления "Движения Контрагент - Доходы\Расходы" по документу АннулированиеПодарочныхСертификатов
Процедура СформироватьДвиженияКонтрагентДоходыРасходы(Параметры) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
										"Документ.АннулированиеПодарочныхСертификатов",
										"РегистрНакопления.ДвиженияКонтрагентДоходыРасходы",
										Параметры.Очередь);
	
КонецПроцедуры



Процедура ЗарегистироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ДвиженияКонтрагентДоходыРасходы";
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Регистратор КАК Регистратор,
	|	ДокументПереоценки.ХозяйственнаяОперация КАК ХозОперацияДокумента,
	|	Т.ХозяйственнаяОперация КАК ХозОперацияРегистра,
	|	Т.Договор КАК Договор,
	|	&ОбъектРасчетовДоговор КАК ОбъектРасчетовДоговор
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентДоходыРасходы КАК Т
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереоценкаВалютныхСредств КАК ДокументПереоценки
	|	ПО Т.Регистратор = ДокументПереоценки.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Регистратор КАК Регистратор
	|ИЗ
	|	вт КАК Т
	|ГДЕ 
	|		//Договор заполнен в объекте расчетов и НЕ заполнен в измерении регистра
	|		ВЫБОР
	|			КОГДА Т.ОбъектРасчетовДоговор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|					ИЛИ Т.ОбъектРасчетовДоговор = НЕОПРЕДЕЛЕНО
	|					ИЛИ Т.ОбъектРасчетовДоговор ЕСТЬ NULL 
	|				ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ Т.ОбъектРасчетовДоговор
	|		КОНЕЦ <> НЕОПРЕДЕЛЕНО
	|		И
	|		ВЫБОР
	|			КОГДА Т.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|					ИЛИ Т.Договор = НЕОПРЕДЕЛЕНО
	|					ИЛИ Т.Договор ЕСТЬ NULL 
	|				ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ Т.Договор
	|		КОНЕЦ = НЕОПРЕДЕЛЕНО
	|	ИЛИ
	|		// под документом переоценки расчетов с клиентами в регистре записаны хоз.операции для поставщиков
	|		Т.ХозОперацияДокумента = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами)
	|		И
	|		Т.ХозОперацияРегистра В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыПоставщикиПрибыль),
	|								ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыПоставщикиУбыток))
	|	
	|";
	
	ПолеДоговора = ДенежныеСредстваПовтИсп.ТекстЗапросаРеквизитаОбъектаРасчетов();
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОбъектРасчетовДоговор", ПолеДоговора);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Заполняет где это возможно поле "Договор" под документом "ПереоценкаВалютныхСредств"
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ПереоценкаВалютныхСредств");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		"РегистрНакопления.ДвиженияКонтрагентДоходыРасходы",
		Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
