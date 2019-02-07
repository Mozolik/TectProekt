﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ НЕ УТ
#Область ПрограммныйИнтерфейс
//++ НЕ УТКА

// Определяет источники уточнения счета, доступные в регистре и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиУточненияСчета()
//
Функция ИсточникиУточненияСчета(СвойстваИсточника) Экспорт
	
	ИсточникиУточненияСчета = Новый Соответствие;
	
	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаРасчетовКредита,
		Новый Структура(СвойстваИсточника, "ГФУРасчетов"));

	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаРасчетовДебета,
		Новый Структура(СвойстваИсточника, "КорГФУРасчетов"));

	Возврат ИсточникиУточненияСчета;
	
КонецФункции

// Определяет источники подразделений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений()
//
Функция ИсточникиПодразделений() Экспорт

	ИсточникиПодразделений = Новый Соответствие;
	
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ХозяйственнаяОперация, "Подразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ОбъектРасчетовСКонтрагентом, "ОбъектРасчетовПодразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ОбъектРасчетовСКонтрагентом, "КорОбъектРасчетовПодразделение");
	
    Возврат ИсточникиПодразделений;
	
КонецФункции

// Определяет источники заполнения субконто.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиСубконто()
//
Функция ИсточникиСубконто() Экспорт

	МассивСубконтоДт = Новый Массив;
	МассивСубконтоДт.Добавить("КорПартнер");
	МассивСубконтоДт.Добавить("КорКонтрагент");
	МассивСубконтоДт.Добавить("КорДоговор");
	
	МассивСубконтоКт = Новый Массив;
	МассивСубконтоКт.Добавить("Партнер");
	МассивСубконтоКт.Добавить("Контрагент");
	МассивСубконтоКт.Добавить("Договор");

	Возврат Новый Структура("СубконтоДт, СубконтоКт", МассивСубконтоДт, МассивСубконтоКт);
	
КонецФункции

// Определяет показатели в валюте регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ПоказателиВВалюте()
//
Функция ПоказателиВВалюте(СвойстваПоказателей) Экспорт

	ПоказателиВВалюте = Новый Соответствие;
	
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалюте, Новый Структура(СвойстваПоказателей, "Валюта"));
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалютеВзаиморасчетовКредита, Новый Структура(СвойстваПоказателей, "ВалютаВзаиморасчетов"));
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалютеВзаиморасчетовДебета, Новый Структура(СвойстваПоказателей, "КорВалютаВзаиморасчетов"));
	
	Возврат ПоказателиВВалюте;

КонецФункции

// Определяет документы отражаемые в международном учете.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ДокументыКОтражениюВМФУ()
//
Функция ДокументыКОтражениюВМеждународномУчете() Экспорт

	ДокументыКОтражению = Новый Массив;
	ДокументыКОтражению.Добавить("ВзаимозачетЗадолженности");
	ДокументыКОтражению.Добавить("ПоступлениеТоваровУслуг");
	
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
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "КорСуммаВВалютеВзаиморасчетов", "КорВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРеглБезНДС", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "КорСуммаБезНДСВВалютеВзаиморасчетов", "КорВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "КорСуммаНДСВВалютеВзаиморасчетов", "КорВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
		
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.КонтрагентДебитор КАК КонтрагентДебитор,
	|	ДанныеДокумента.КонтрагентКредитор КАК КонтрагентКредитор,
	|	1 + ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.КонтрагентДебитор) = ТИП(Справочник.Организации)
	|			ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ 
	|	+ ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.КонтрагентКредитор) = ТИП(Справочник.Организации)
	|					И ДанныеДокумента.КонтрагентДебитор <> ДанныеДокумента.КонтрагентКредитор
	|		ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПоДокументу,
	|	ДанныеДокумента.МоментВремени КАК МоментВремени
	|ПОМЕСТИТЬ втДокументы
	|ИЗ
	|	Документ.ВзаимозачетЗадолженности КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И (ТИПЗНАЧЕНИЯ(ДанныеДокумента.КонтрагентДебитор) = ТИП(Справочник.Организации)
	|			ИЛИ ТИПЗНАЧЕНИЯ(ДанныеДокумента.КонтрагентКредитор) = ТИП(Справочник.Организации))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Организация,
	|	КонтрагентДебитор,
	|	КонтрагентКредитор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.Организация,
	|	ДанныеРегистра.МоментВремени
	|ПОМЕСТИТЬ втДанныеРегистра
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентКонтрагент КАК ДанныеРегистра
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|	И (ТИПЗНАЧЕНИЯ(ДанныеРегистра.Контрагент) = ТИП(Справочник.Организации)
	|		ИЛИ ТИПЗНАЧЕНИЯ(ДанныеРегистра.КорКонтрагент) = ТИП(Справочник.Организации))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// взаимозачет между организациями
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Регистратор
	|ИЗ (
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка КАК Ссылка,
	|		ДанныеДокумента.Дата КАК Дата,
	|		ДанныеДокумента.Организация КАК Организация,
	|		ДанныеДокумента.ПоДокументу КАК ПоДокументу,
	|		1 КАК ПоРегистру,
	|		ДанныеДокумента.МоментВремени
	|	ИЗ
	|		втДокументы КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеРегистра КАК ДанныеРегистра
	|		ПО ДанныеДокумента.Ссылка = ДанныеРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ДанныеРегистра.Организация
	|
	|	ОБЪЕДИНИТЬ
	|
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка,
	|		ДанныеДокумента.Дата,
	|		ДанныеДокумента.КонтрагентДебитор,
	|		ДанныеДокумента.ПоДокументу,
	|		1,
	|		ДанныеДокумента.МоментВремени
	|	ИЗ
	|		втДокументы КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеРегистра КАК ДанныеРегистра
	|		ПО ДанныеДокумента.Ссылка = ДанныеРегистра.Регистратор
	|			И ДанныеДокумента.КонтрагентДебитор = ДанныеРегистра.Организация
	|
	|	ОБЪЕДИНИТЬ
	|
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка,
	|		ДанныеДокумента.Дата,
	|		ДанныеДокумента.КонтрагентКредитор,
	|		ДанныеДокумента.ПоДокументу,
	|		1,
	|		ДанныеДокумента.МоментВремени
	|	ИЗ
	|		втДокументы КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеРегистра КАК ДанныеРегистра
	|		ПО ДанныеДокумента.Ссылка = ДанныеРегистра.Регистратор
	|			И ДанныеДокумента.КонтрагентКредитор = ДанныеРегистра.Организация
	|	) КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДокументы КАК ДанныеДокумента
	|		ПО Таблица.Ссылка = ДанныеДокумента.Ссылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Ссылка,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.КонтрагентДебитор,
	|	ДанныеДокумента.КонтрагентКредитор,
	|	Таблица.Дата,
	|	Таблица.ПоДокументу,
	|	Таблица.МоментВремени
	|
	|ИМЕЮЩИЕ
	|	Таблица.ПоДокументу <> СУММА(Таблица.ПоРегистру)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// необосновано разможенные движения
	|ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентКонтрагент КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВзаимозачетЗадолженности КАК ДанныеДокумента
	|		ПО ДанныеРегистра.Регистратор = ДанныеДокумента.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Период,
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.Организация,
	|	ДанныеРегистра.МоментВремени,
	|	ДанныеДокумента.СуммаДокумента
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДанныеРегистра.СуммаВВалюте) > ДанныеДокумента.СуммаДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// валютный взаимозачет
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентКонтрагент КАК ДанныеРегистра
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|	И (ДанныеРегистра.Валюта <> &ВалютаРегламентированногоУчета
	|		ИЛИ ДанныеРегистра.ВалютаВзаиморасчетов <> &ВалютаРегламентированногоУчета
	|		ИЛИ ДанныеРегистра.КорВалютаВзаиморасчетов <> &ВалютаРегламентированногоУчета
	|	)
	|");
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	ПолноеИмяРегистра = "РегистрНакопления.ДвиженияКонтрагентКонтрагент";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, ДанныеКОбработке, ПолноеИмяРегистра);
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Формирует правильные движения по регистру для документов "Взаимозачет задолженности":
//  - по которым имеются необоснованно размноженные движения
//  - проводящие взаимозачет между организациями
//  - с валютой взаиморасчетов отличной от валюты регл
Процедура ИсправитьДвижения(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ВзаимозачетЗадолженности";
	ПолноеИмяРегистра  = "РегистрНакопления.ДвиженияКонтрагентКонтрагент";
	ИмяРегистра        = "ДвиженияКонтрагентКонтрагент";
	
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяДокумента);
	МенеджерРегистра = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяРегистра);
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметры.ДополнительныеИсточникиДанных = МенеджерДокумента.ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра);
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ,
					ДополнительныеПараметры);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВзаимозачетЗадолженности.Ссылка   КАК Регистратор,
	|	ВзаимозачетЗадолженности.Проведен КАК Проведен
	|ИЗ
	|	Документ.ВзаимозачетЗадолженности КАК ВзаимозачетЗадолженности
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ВзаимозачетЗадолженности.Ссылка = ВТДляОбработки.Регистратор
	|";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	ВыборкаПоРегистраторам = Запрос.Выполнить().Выбрать();

	Пока ВыборкаПоРегистраторам.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта
			Блокировка = Новый БлокировкаДанных;
            
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаПоРегистраторам.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
            
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДвиженияКонтрагентКонтрагент.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаПоРегистраторам.Регистратор);
			
			Блокировка.Заблокировать();
			
			// Записать правильные оперативные движения по регистратору
			НаборЗаписей = МенеджерРегистра.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаПоРегистраторам.Регистратор);
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтложенноеПроведение");
			Если ВыборкаПоРегистраторам.Проведен Тогда
				ДопСвойства = Новый Структура;
				ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(ВыборкаПоРегистраторам.Регистратор, ДопСвойства);
				МенеджерДокумента.ИнициализироватьДанныеДокумента(ВыборкаПоРегистраторам.Регистратор, ДопСвойства, ИмяРегистра);
				НаборЗаписей.Загрузить(ДопСвойства.ТаблицыДляДвижений["Таблица" + ИмяРегистра]);
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			Если ТипЗнч(ВыборкаПоРегистраторам.Регистратор) = Тип("ДокументСсылка.ВзаимозачетЗадолженности") Тогда
				
				// Сформировать отложенные движения по взаимозачету
				МассивДокументов = Новый Массив;
				МассивДокументов.Добавить(ВыборкаПоРегистраторам.Регистратор);
				УправленческийУчетПроведениеСервер.СформироватьДвиженияКонтрагентКонтрагент(МассивДокументов);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось перезаписать движения в регистр %ИмяРегистра% по документу %Ссылка% по причине: %Причина%';uk='Не вдалося перезаписати рухи в регістр %ИмяРегистра% по документу %Ссылка% по причині: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ВыборкаПоРегистраторам.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяРегистра);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.НайтиПоПолномуИмени(ПолноеИмяДокумента), ВыборкаПоРегистраторам.Регистратор, ТекстСообщения);
			
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли