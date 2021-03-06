﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПровестиКомиссионныеТовары_ДанныеДляОбновления(Параметры) Экспорт
    
	ПолноеИмяРегистра = "РегистрНакопления.СебестоимостьТоваров";
    
	Запрос = Новый Запрос("
    |ВЫБРАТЬ РАЗЛИЧНЫЕ
    |    ТИПЗНАЧЕНИЯ(СебестоимостьТоваров.Регистратор) КАК ТипРегистратора
    |ПОМЕСТИТЬ ТипыРегистраторовРегистра
    |ИЗ
    |    РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров    
    |
    |;
    |////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Товары.Регистратор КАК Ссылка
	|ПОМЕСТИТЬ ДокументыДвижений
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК Товары
	|ГДЕ
	|	Товары.ВидЗапасов.ТипЗапасов В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца))
    |   И ТИПЗНАЧЕНИЯ(Товары.Регистратор) В (ВЫБРАТЬ ТипыРегистраторовРегистра.ТипРегистратора ИЗ ТипыРегистраторовРегистра КАК ТипыРегистраторовРегистра)  
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
    |   И ТИПЗНАЧЕНИЯ(Товары.Регистратор) В (ВЫБРАТЬ ТипыРегистраторовРегистра.ТипРегистратора ИЗ ТипыРегистраторовРегистра КАК ТипыРегистраторовРегистра)  
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
    |   И ТИПЗНАЧЕНИЯ(Товары.Регистратор) В (ВЫБРАТЬ ТипыРегистраторовРегистра.ТипРегистратора ИЗ ТипыРегистраторовРегистра КАК ТипыРегистраторовРегистра)  
	|
	|;
	|////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	ДокументыДвижений КАК Таблица
	|");
    
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
    
    ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
        Параметры, 
        Регистраторы, 
        ПолноеИмяРегистра
    );
	
КонецПроцедуры

// Обработчик обновления УТ 3.2.3
// Выполняется переформирование движений документов, в которых зафиксирован комиссионный товар или материал давальца
// по регистру накопления СебестоимостьТоваров
Процедура ПровестиКомиссионныеТовары(Параметры) Экспорт
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчередиПоВсемДокументам(
	    "РегистрНакопления.СебестоимостьТоваров",
	    Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.[ИмяДокумента] КАК ТаблицаДокумента
	|		ПО ДанныеРегистра.Регистратор = ТаблицаДокумента.Ссылка
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|		ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
	|			И Аналитика.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			И Аналитика.КлючАналитики <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
	|		ПО ТаблицаДокумента.Договор.Ссылка = Договоры.Ссылка";
	
	ТипыДокументов = Новый Массив;
	ТипыДокументов.Добавить("АктВыполненныхРабот");
	ТипыДокументов.Добавить("ВозвратТоваровОтКлиента");
	ТипыДокументов.Добавить("ВозвратТоваровПоставщику");
	ТипыДокументов.Добавить("ОтчетКомиссионера");
	ТипыДокументов.Добавить("ПоступлениеТоваровУслуг");
	ТипыДокументов.Добавить("РеализацияТоваровУслуг");
	
	
	ТекстЗапроса = "";
	ПервыйТип = Истина;
	
	Для Каждого ИмяДокумента Из ТипыДокументов Цикл
		
		СтруктураЗамены = Новый Структура(
			"ИмяДокумента", ИмяДокумента);
		
		Если ПервыйТип Тогда 
			ПервыйТип = Ложь;
		Иначе
			
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
			
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонЗапроса, СтруктураЗамены);
		
	КонецЦикла;
	
	// добавление регистраторов для обновления раздела учета
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|"
	+ ТекстЗапросаРегистраторовДляОбновленияРазделаУчета();
    
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.СебестоимостьТоваров";
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
    
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Производит замену измерения "АналитикаУчетаПоПартнерам" с учетом договора из регистратора.
// 
// Перезаполняет ОТЛОЖЕННО движения документов Перемещение Товаров по РН Себестоимость товаров для документов,
//  которые перемещают комиссионный товар, у которых раздел учета отличен от "Товары принятые на комиссию".
// 
// Производит перезаполнение раздела учета в движениях по себестоимости для документов ТоварыПереданныеПереработчику.
//
Процедура ИсправитьДвижения(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.СебестоимостьТоваров";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
	     Параметры.Очередь,
	     Неопределено,
	     ПолноеИмяРегистра,
	     МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СписокРегистраторов.Регистратор КАК Регистратор,
	|	СписокРегистраторов.Регистратор.Договор КАК Договор
	|ПОМЕСТИТЬ СписокРегистраторов
	|ИЗ
	|	&ВТДляОбработкиСсылка КАК СписокРегистраторов
	|ГДЕ
	|	СписокРегистраторов.Регистратор   ССЫЛКА Документ.АктВыполненныхРабот
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.ВозвратТоваровОтКлиента
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.ВозвратТоваровПоставщику
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.ОтчетКомиссионера
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	|	ИЛИ СписокРегистраторов.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам             КАК КлючАналитикиРегистра,
	|	ЕСТЬNULL(НоваяАналитика.КлючАналитики, НЕОПРЕДЕЛЕНО) КАК КлючНовойАналитики,
	|	АналитикаРегистра.Организация                        КАК Организация,
	|	АналитикаРегистра.Партнер                            КАК Партнер,
	|	АналитикаРегистра.Контрагент                         КАК Контрагент,
	|	АналитикаРегистра.НаправлениеДеятельности            КАК НаправлениеДеятельности,
	|	СписокРегистраторов.Договор                          КАК Договор,
	|	СписокРегистраторов.Регистратор                      КАК Регистратор
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокРегистраторов КАК СписокРегистраторов
	|		ПО ДанныеРегистра.Регистратор = СписокРегистраторов.Регистратор
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаРегистра
	|		ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = АналитикаРегистра.КлючАналитики
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК НоваяАналитика
	|		ПО АналитикаРегистра.Партнер = НоваяАналитика.Партнер
	|			И АналитикаРегистра.Организация = НоваяАналитика.Организация
	|			И АналитикаРегистра.Контрагент = НоваяАналитика.Контрагент
	|			И АналитикаРегистра.НаправлениеДеятельности = НоваяАналитика.НаправлениеДеятельности
	|			И НоваяАналитика.Договор = СписокРегистраторов.Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокРегистраторов.Регистратор КАК Ссылка
	|ИЗ
	|	СписокРегистраторов КАК СписокРегистраторов";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТДляОбработкиСсылка", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Результат = Запрос.ВыполнитьПакет();

	КоличествоЗапросов = Результат.ВГраница();
	
	ТаблицаАналитик = Результат[КоличествоЗапросов-1].Выгрузить();
	Для Каждого СтрокаАналитики Из ТаблицаАналитик Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаАналитики.КлючНовойАналитики) Тогда
			НоваяАналитика = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(СтрокаАналитики);
			СтрокаАналитики.КлючНовойАналитики = НоваяАналитика;
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыПоиска = "КлючАналитикиРегистра, Регистратор";
	ТаблицаАналитик.Индексы.Добавить(РеквизитыПоиска);
	СтруктураПоиска = Новый Структура(РеквизитыПоиска);
	
	Выборка = Результат[КоличествоЗапросов].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыНакопления.СебестоимостьТоваров.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
			НаборЗаписей.Прочитать();
			
			СтруктураПоиска.Вставить("Регистратор", Выборка.Ссылка);
			
			Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
				
				Если ЗначениеЗаполнено(ЗаписьНабора.АналитикаУчетаПоПартнерам) Тогда
					
					СтруктураПоиска.Вставить("КлючАналитикиРегистра", ЗаписьНабора.АналитикаУчетаПоПартнерам);
					МассивСтрок = ТаблицаАналитик.НайтиСтроки(СтруктураПоиска);
					
					ЗаписьНабора.АналитикаУчетаПоПартнерам = МассивСтрок[0].КлючНовойАналитики;
					
				КонецЕсли;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось дополнить аналитику по партнерам договором при обработке документа: %Ссылка% по причине: %Причина%';uk='Не вдалося доповнити аналітику за партнерами договором при обробці документа: %Ссылка% по причині: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
    
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(
        Параметры.Очередь, 
        ПолноеИмяРегистра
    );
	
КонецПроцедуры

// Возвращает текст запроса для получения регистраторов с некорректным разделом учета.
Функция ТекстЗапросаРегистраторовДляОбновленияРазделаУчета() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Записи.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Записи
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Записи.Регистратор) = ТИП(Документ.ПеремещениеТоваров)
	|	И Записи.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|	И Записи.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
