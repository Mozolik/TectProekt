﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
	Возврат "РегистрНакопления.ПартииТоваровОрганизаций";
КонецФункции

Процедура ПровестиКомиссионныеТовары_ДанныеДляОбновления(Параметры) Экспорт
    
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Товары.Регистратор КАК Ссылка
	|ПОМЕСТИТЬ ДокументыДвижений
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК Товары
	|ГДЕ
	|	Товары.ВидЗапасов.ТипЗапасов В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Товары.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию КАК Товары
	|ГДЕ
	|	Товары.ВидЗапасов.ТипЗапасов В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Товары.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту КАК Товары
	|ГДЕ
	|	Товары.ВидЗапасов.ТипЗапасов В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца))
	|
	|;
	|////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	ДокументыДвижений КАК Таблица
	|ГДЕ
    // Типы документов, которые могут делать приходные движения по рн ПартииТоваровОрганизаций
	|	Таблица.Ссылка ССЫЛКА Документ.ВводОстатков
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ВозвратТоваровМеждуОрганизациями
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ВозвратТоваровОтКлиента
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ОприходованиеИзлишковТоваров
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ОтчетКомитентуОСписании
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ПередачаТоваровМеждуОрганизациями
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ПересортицаТоваров
	|	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ПорчаТоваров
    |	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ПоступлениеТоваровУслуг
    |	ИЛИ Таблица.Ссылка ССЫЛКА Документ.ПрочееОприходованиеТоваров
    |	ИЛИ Таблица.Ссылка ССЫЛКА Документ.СборкаТоваров
	|");
    
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
    
    ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
        Параметры, 
        Регистраторы, 
        ПолноеИмяРегистра()
    );
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Выполняется переформирование движений документов, в которых зафиксирован комиссионный товар или материал давальца
// по регистру накопления ПартииТоваровОрганизаций
Процедура ПровестиКомиссионныеТовары(Параметры) Экспорт
	
	ТипыРегистраторов = Новый Массив;
    // Типы документов, которые могут делать движения по рн ТоварыОрганизаций или ТоварыПереданныеНаКомиссию или ТоварыКОформлениюОтчетовКомитенту
    // и могут делать приходные движения по рн ПартииТоваровОрганизаций
	ТипыРегистраторов.Добавить("Документ.ВводОстатков");
	ТипыРегистраторов.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	ТипыРегистраторов.Добавить("Документ.ВозвратТоваровОтКлиента");
    ТипыРегистраторов.Добавить("Документ.ОприходованиеИзлишковТоваров");
	ТипыРегистраторов.Добавить("Документ.ОтчетКомитентуОСписании");
    ТипыРегистраторов.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании");
	ТипыРегистраторов.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	ТипыРегистраторов.Добавить("Документ.ПересортицаТоваров");
    ТипыРегистраторов.Добавить("Документ.ПорчаТоваров");
    ТипыРегистраторов.Добавить("Документ.ПоступлениеТоваровУслуг");
    ТипыРегистраторов.Добавить("Документ.ПрочееОприходованиеТоваров");
    ТипыРегистраторов.Добавить("Документ.СборкаТоваров");

	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		ТипыРегистраторов,
	    "РегистрНакопления.ПартииТоваровОрганизаций",
		Параметры.Очередь
    );
    
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ВосстановитьДвиженияПоПартиямТоваров_ДанныеДляОбновления(Параметры) Экспорт
    
    УстановитьПривилегированныйРежим(Истина);
    
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	ДД.Ссылка КАК Ссылка
	|ИЗ (
	|	ВЫБРАТЬ
	|		ДД.Ссылка КАК Ссылка
	|	ИЗ (
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|			ДД.Регистратор КАК Ссылка
	|		ИЗ 
	|			РегистрНакопления.ТоварыОрганизаций КАК ДД
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровОрганизаций КАК Партии
	|				ПО Партии.Период = ДД.Период
	|				И Партии.Регистратор = ДД.Регистратор
	|				И Партии.АналитикаУчетаНоменклатуры = ДД.АналитикаУчетаНоменклатуры
	|		ГДЕ
	|			&ИспользоватьПартионныйУчет
	|			И ДД.Первичное
	|			И ДД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			И Партии.Регистратор ЕСТЬ NULL
	|		) КАК ДД
	|
	|	ОБЪЕДИНИТЬ ВСЕ
    |
	|	ВЫБРАТЬ
	|		ДД.Ссылка КАК Ссылка
	|	ИЗ (
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|			ДД.Регистратор КАК Ссылка
	|		ИЗ 
	|			РегистрНакопления.ТоварыОрганизацийКОформлению КАК ДД
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровОрганизаций КАК Партии
	|				ПО Партии.Период = ДД.Период
	|				И Партии.Регистратор = ДД.Регистратор
	|				И Партии.АналитикаУчетаНоменклатуры = ДД.АналитикаУчетаНоменклатуры
	|		ГДЕ
	|			&ИспользоватьПартионныйУчет
	|			И ДД.Первичное
	|			И ДД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			И Партии.Регистратор ЕСТЬ NULL
	|		) КАК ДД
	|	) КАК ДД
	|");
    
    Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", Константы.ИспользоватьПартионныйУчет.Получить());
    
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
    
    ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
        Параметры, 
        Регистраторы, 
        ПолноеИмяРегистра()
    );
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Формирует движения по регистру "Партии товаров организаций" для документов,
// у которых эти движения ошибочно отсутствуют.
Процедура ВосстановитьДвиженияПоПартиямТоваров(Параметры) Экспорт
    
    
    УстановитьПривилегированныйРежим(Истина);
    
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(
        Параметры.Очередь, 
        Неопределено, 
        ПолноеИмяРегистра()
    );
    
	НаборЗаписейПартииТоваров = РегистрыНакопления.ПартииТоваровОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписейПартииТоваров.ДополнительныеСвойства.Вставить(
        "ДляПроведения", Новый Структура(
            "СтруктураВременныеТаблицы, ПартионныйУчет", 
		    Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц), Истина
        )
    );
	
	ДополнительныеСвойства = Новый Структура(
        "ЭтоНовый, РежимЗаписи", 
        Ложь, РежимЗаписиДокумента.Проведение
    );
    
    Пока Выборка.Следующий() Цикл
        
        ИмяДокумента       = Выборка.Регистратор.Метаданные().Имя;
        ПолноеИмяДокумента = "Документ." + ИмяДокумента;
        МенеджерДокумента  = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяДокумента);
        
		НачатьТранзакцию();
        
		Попытка
            
            Блокировка = Новый БлокировкаДанных;
            
            ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра() + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
            
			Блокировка.Заблокировать();
		
			ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(
				Выборка.Регистратор,
				ДополнительныеСвойства,
				РежимПроведенияДокумента.Неоперативный
            );
				
			МенеджерДокумента.ИнициализироватьДанныеДокумента(
				Выборка.Регистратор,
				ДополнительныеСвойства,
                "ПартииТоваровОрганизаций"
            );
				
			НаборЗаписейПартииТоваров.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписейПартииТоваров.Записывать = Истина;
			НаборЗаписейПартииТоваров.Загрузить(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииТоваровОрганизаций);
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписейПартииТоваров);
			
			ЗафиксироватьТранзакцию();
            
		Исключение
            
            ОтменитьТранзакцию();
            
			ТекстСообщения = НСтр("ru='Не удалось обработать движения документа %Документ% по регистру ""Партии товаров организаций"". Причина: %Причина%';uk='Не вдалося обробити рухи документу %Документ% регістру ""Партії товарів організацій"". Причина: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Выборка.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
                ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
                УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Регистратор.Метаданные(), 
                Выборка.Регистратор, 
                ТекстСообщения
            );
            
		КонецПопытки;

	КонецЦикла;
    
    Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(
        Параметры.Очередь, 
        ПолноеИмяРегистра()
    );
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
