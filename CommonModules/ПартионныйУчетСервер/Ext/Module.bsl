﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Партионный учет".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Метод выполняет проверку возможности отключения партионного учета.
// В случае наличия движений по регистрам партий - будет возвращена Ложь,
// иначе Истина
Функция ПартионныйУчетНельзяВыключать() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Расчет
	|ГДЕ
	|	Расчет.МетодОценки = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|	И Расчет.Проведен
	|	И &ИспользоватьПартионныйУчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК РегУчетнаяПолитика
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетнаяПолитика
	|	ПО РегУчетнаяПолитика.УчетнаяПолитика = СпрУчетнаяПолитика.Ссылка
	|		И (СпрУчетнаяПолитика.МетодОценкиСтоимостиТоваров = 
	|			ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|		)
	|");
	
	Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет"));
	ЕстьЗаписи = НЕ Запрос.Выполнить().Пустой();
	Если ЕстьЗаписи  Тогда
		Константы.ИспользоватьПартионныйУчет.Установить(Истина);
	КонецЕсли;
	
	Возврат ЕстьЗаписи;
	
КонецФункции

// Метод выполняет заполнение реквизита "АналитикаУчетаПартий" в переданной табличной части.
Процедура ЗаполнитьАналитикуУчетаПартийВТабличнойЧастиТовары(МенеджерВременныхТаблиц, ТабличнаяЧастьТовары = Неопределено, АналитикаУчетаПартийДокумента = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Поставщик							КАК Поставщик,
	|	ТаблицаТоваров.Контрагент							КАК Контрагент,
	|	ТаблицаТоваров.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаТоваров.Номенклатура.ГруппаФинансовогоУчета	КАК ГруппаФинансовогоУчета,
	|	АналитикаПартий.КлючАналитики 						КАК АналитикаУчетаПартий,
	|	ТаблицаТоваров.НалоговоеНазначение 					КАК НалоговоеНазначение 
	|ИЗ
	|	ИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.АналитикаУчетаПартий КАК АналитикаПартий
	|		ПО 
	|			ТаблицаТоваров.Поставщик 							 = АналитикаПартий.Поставщик
	|			И ТаблицаТоваров.НалоговоеНазначение  				 = АналитикаПартий.НалоговоеНазначение 
	|			И ТаблицаТоваров.Контрагент 						 = АналитикаПартий.Контрагент
	|			И ТаблицаТоваров.СтавкаНДС 							 = АналитикаПартий.СтавкаНДС
	|			И ТаблицаТоваров.Номенклатура.ГруппаФинансовогоУчета = АналитикаПартий.ГруппаФинансовогоУчета
	|  
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
		
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.АналитикаУчетаПартий) Тогда
			АналитикаУчетаПартий = Выборка.АналитикаУчетаПартий;
		Иначе
			АналитикаУчетаПартий = Справочники.КлючиАналитикиУчетаПартий.КлючиАналитикиУчетаПартийДокумента(Выборка);
		КонецЕсли;

		Если ТабличнаяЧастьТовары <> Неопределено Тогда
			СтрокаТаблицы = ТабличнаяЧастьТовары.Найти(Выборка.НомерСтроки, "НомерСтроки");
			СтрокаТаблицы.АналитикаУчетаПартий = АналитикаУчетаПартий;
		Иначе
			АналитикаУчетаПартийДокумента = АналитикаУчетаПартий;
		КонецЕсли;
				
	КонецЦикла;
		
КонецПроцедуры

// Метод выполняет актуализацию партионного учета
Процедура ФормированиеДвиженийПоПартиямЗатратамНДС() Экспорт
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено ИЛИ ЗакрытиеМесяцаУТВызовСервера.АктивноЗаданиеЗакрытияМесяца() Тогда
		Возврат;
	КонецЕсли;
	ПартионныйУчет.РассчитатьФоновымЗаданием(КонецМесяца(ТекущаяДатаСеанса()));
КонецПроцедуры

#Область ЗаписьДвиженийВРегистры

///////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ЗАПИСИ ДВИЖЕНИЙ В РЕГИСТРЫ

// Процедура формирования движений по регистру "Партии товаров организаций".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииТоваровОрганизаций;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииТоваровОрганизаций.Записывать = Истина;
	Движения.ПартииТоваровОрганизаций.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Партии товаров переданные на комиссию".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииТоваровПереданныеНаКомиссию(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииТоваровПереданныеНаКомиссию;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииТоваровПереданныеНаКомиссию.Записывать = Истина;
	Движения.ПартииТоваровПереданныеНаКомиссию.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Партии расходов на себестоимость товаров".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииРасходовНаСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииРасходовНаСебестоимостьТоваров;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииРасходовНаСебестоимостьТоваров.Записывать = Истина;
	Движения.ПартииРасходовНаСебестоимостьТоваров.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КорректировкаНДС

Процедура СформироватьДвиженияПоКорректировкамНДС(ПериодРасчета, Организация = Неопределено) Экспорт	

	
	Если ТипЗнч(Организация) = Тип("Массив") Тогда
		МассивОрганизаций = Организация;
	Иначе
		МассивОрганизаций = Новый Массив;
		МассивОрганизаций.Добавить(Организация);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ПартионныйУчет.РассчитатьКорректировкиНДС(НачалоМесяца(ПериодРасчета), КонецМесяца(ПериодРасчета), МассивОрганизаций);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры


#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления BAS УТ 3.2.1
// Производит перенос неактуальных границ в регистр заданий для последующей актуализации партионным учетом
Процедура ЗаданияКРасчетуСебестоимости() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
        |   Т.Организация КАК Организация,
		|	ЕСТЬNULL(МИНИМУМ(Т.ПериодПоследовательности), НЕОПРЕДЕЛЕНО) КАК Месяц
		|ИЗ (
		|	ВЫБРАТЬ
        |       Организации.Ссылка КАК Организация,
		|		Регистрации.Номенклатура, 
        |       Регистрации.Характеристика,
		|		МИНИМУМ(Регистрации.Период) КАК ПериодПоследовательности,
		|		ЕСТЬNULL(Границы.Период, &НачалоВремен) КАК ПериодГраницы
		|	ИЗ
		|		Последовательность.УДАЛИТЬПартииТоваровОрганизаций КАК Регистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Последовательность.УДАЛИТЬПартииТоваровОрганизаций.Границы КАК Границы
		|			ПО Границы.Номенклатура = Регистрации.Номенклатура
		|			И Границы.Характеристика = Регистрации.Характеристика
	    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	    |		    ПО (ИСТИНА)
		|	ГДЕ
		|		&ИспользоватьПартионныйУчет
		|		И Регистрации.Период МЕЖДУ ЕСТЬNULL(Границы.Период, &НачалоВремен) И &ОкончаниеПериодаРасчета
	    |	    И НЕ Организации.ПометкаУдаления
	    |	    И ВЫБОР
	    |		    КОГДА НЕ &ИспользоватьУпрОрганизацию
	    |				    И Организации.Ссылка = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	    |			    ТОГДА ЛОЖЬ
	    |			    ИНАЧЕ ИСТИНА
	    |		    КОНЕЦ
		|	СГРУППИРОВАТЬ ПО
		|		Организации.Ссылка, Регистрации.Номенклатура, Регистрации.Характеристика, Границы.Период
		|
		|	ОБЪЕДИНИТЬ ВСЕ
        |
		|	ВЫБРАТЬ
        |       Организации.Ссылка КАК Организация,
		|		НЕОПРЕДЕЛЕНО, 
        |       НЕОПРЕДЕЛЕНО,
		|		МИНИМУМ(Записи.Период) КАК ПериодПоследовательности,
		|		ЕСТЬNULL(Записи.Период, &НачалоВремен) КАК ПериодГраницы
		|	ИЗ
		|		РегистрСведений.УдалитьТребуетсяРаспределениеДопРасходов КАК Записи
	    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	    |		    ПО (ИСТИНА)
		|	ГДЕ
		|		Записи.Период МЕЖДУ ЕСТЬNULL(Записи.Период, &НачалоВремен) И &ОкончаниеПериодаРасчета
	    |	    И НЕ Организации.ПометкаУдаления
	    |	    И ВЫБОР
	    |		    КОГДА НЕ &ИспользоватьУпрОрганизацию
	    |				    И Организации.Ссылка = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	    |			    ТОГДА ЛОЖЬ
	    |			    ИНАЧЕ ИСТИНА
	    |		    КОНЕЦ
		|	СГРУППИРОВАТЬ ПО
        |		Организации.Ссылка, Записи.Период
		|) КАК Т
        |
		|ГДЕ
		|	Т.ПериодПоследовательности >= Т.ПериодГраницы
        |
    	|СГРУППИРОВАТЬ ПО
    	|	Т.Организация
        |
		|");
        
	Запрос.УстановитьПараметр("НачалоВремен", '00010101');
	Запрос.УстановитьПараметр("ОкончаниеПериодаРасчета", '39991231');
	Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", Константы.ИспользоватьПартионныйУчет.Получить());
    Запрос.УстановитьПараметр("ИспользоватьУпрОрганизацию", ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.Месяц) Тогда
			Продолжить;
		КонецЕсли;
		НачатьТранзакцию();
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКРасчетуСебестоимости");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();

		НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьМенеджерЗаписи();
        НаборЗаписей.Организация = Выборка.Организация;
		НаборЗаписей.Месяц = Выборка.Месяц;
		НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКРасчетуСебестоимости.Получить();
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти



#КонецОбласти
