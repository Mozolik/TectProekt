﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы


Процедура ЗаполнитьРесурсыСуммаРеглУпрДанныеДляОбновления(Параметры) Экспорт
	
	ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = "РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.МоментВремени
	|ИЗ
	|	РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов КАК ДанныеРегистра
	|ГДЕ
	|	(ДанныеРегистра.СуммаРегл = 0 ИЛИ ДанныеРегистра.СуммаУпр = 0)
	|	И НЕ ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) В (
	|			ТИП(Документ.ПереоценкаВалютныхСредств),
	|			ТИП(Документ.КорректировкаРегистров))
	|";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКОбработке, ДополнительныеПараметрыОтметки);

КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Заполняет новые ресурсы СуммаРегл и СуммаУпр
Процедура ЗаполнитьРесурсыСуммаРеглУпр(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВводОстатков");
	Регистраторы.Добавить("Документ.НачисленияКредитовИДепозитов");
	Регистраторы.Добавить("Документ.ПоступлениеБезналичныхДенежныхСредств");
	Регистраторы.Добавить("Документ.ПриходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.РасходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	
	// Корректировка движений по оперативным документам
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов";
	ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		"РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов",
		Параметры.Очередь);
	
	// Корректировка движений по документам КорректировкаРегистров
	Запрос = Новый Запрос(ТекстЗапросаДвиженияКорректировкиРегистров());
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь,
					Неопределено,
					ПолноеИмяРегистра,
					Запрос.МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ВыборкаПоДокументу = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоДокументу.Следующий() Цикл
		
		Регистратор = ВыборкаПоДокументу.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			БлокировкаДокумента = Блокировка.Добавить("Документ.КорректировкаРегистров");
			БлокировкаДокумента.УстановитьЗначение("Ссылка", Регистратор);
			
			БлокировкаРегистра = Блокировка.Добавить("РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов.НаборЗаписей");
			БлокировкаРегистра.УстановитьЗначение("Регистратор", Регистратор);
			
			Блокировка.Заблокировать();
		
			// Записать правильные движения
			Набор = РегистрыНакопления.РасчетыПоДоговорамКредитовИДепозитов.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			Выборка = ВыборкаПоДокументу.Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось обработать %Документ% по причине: %Причина%';uk='Не вдалося обробити %Документ% з причини: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Ошибка,
									Регистратор.Метаданные(),
									Регистратор,
									ТекстСообщения);
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаДвиженияКорректировкиРегистров()
	
	Возврат
	"ВЫБРАТЬ
	|	ДанныеРегистра.Период КАК Период,
	|	ДанныеРегистра.Регистратор КАК Регистратор,
	|	ДанныеРегистра.НомерСтроки КАК НомерСтроки,
	|	ДанныеРегистра.Активность КАК Активность,
	|	ДанныеРегистра.ВидДвижения КАК ВидДвижения,
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ДанныеРегистра.Договор КАК Договор,
	|	ДанныеРегистра.Договор.ВалютаВзаиморасчетов КАК Валюта,
	|	ДанныеРегистра.ТипСуммы КАК ТипСуммы,
	|	ДанныеРегистра.СуммаВВалюте КАК СуммаВВалюте,
	|	ДанныеРегистра.СуммаУпр КАК СуммаУпр,
	|	ДанныеРегистра.СуммаРегл КАК СуммаРегл,
	|	ДанныеРегистра.ТипГрафика КАК ТипГрафика,
	|	ДанныеРегистра.СтатьяАналитики КАК СтатьяАналитики,
	|	ДанныеРегистра.МоментВремени КАК МоментВремени
	|ПОМЕСТИТЬ втДанныеРегистра
	|ИЗ
	|	РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов КАК ДанныеРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДляОбработкиРасчетыПоДоговорамКредитовИДепозитов КАК Фильтр
	|		ПО ДанныеРегистра.Регистратор = Фильтр.Регистратор
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) = ТИП(Документ.КорректировкаРегистров)
	|	И (ДанныеРегистра.СуммаУпр = 0 ИЛИ ДанныеРегистра.СуммаРегл = 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДанныеРегистра.Период) КАК Период,
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ДанныеРегистра.Договор КАК Договор,
	|	ДанныеРегистра.Договор.ВалютаВзаиморасчетов КАК Валюта,
	|	ДанныеРегистра.ТипСуммы КАК ТипСуммы,
	|	ДанныеРегистра.ТипГрафика КАК ТипГрафика,
	|	ДанныеРегистра.СтатьяАналитики КАК СтатьяАналитики
	|ПОМЕСТИТЬ втДатыДоговоров
	|ИЗ
	|	втДанныеРегистра КАК ДанныеРегистра
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам,
	|	ДанныеРегистра.Договор,
	|	ДанныеРегистра.ТипСуммы,
	|	ДанныеРегистра.ТипГрафика,
	|	ДанныеРегистра.СтатьяАналитики,
	|	ДанныеРегистра.Договор.ВалютаВзаиморасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыДоговоров.Период КАК Период,
	|	ДатыДоговоров.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ДатыДоговоров.Договор КАК Договор,
	|	ДатыДоговоров.Валюта КАК Валюта,
	|	ДатыДоговоров.ТипСуммы КАК ТипСуммы,
	|	ДатыДоговоров.ТипГрафика КАК ТипГрафика,
	|	ДатыДоговоров.СтатьяАналитики КАК СтатьяАналитики,
	|	ЕСТЬNULL(КурсыВалютыРегл.Курс, 1) КАК КурсРегл,
	|	ЕСТЬNULL(КурсыВалютыРегл.Кратность, 1) КАК КратностьРегл,
	|	ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) КАК КурсУпр,
	|	ЕСТЬNULL(КурсыВалютыУпр.Кратность, 1) КАК КратностьУпр
	|ПОМЕСТИТЬ втКурсыВалют
	|ИЗ
	|	втДатыДоговоров КАК ДатыДоговоров
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалютыРегл
	|		ПО ДатыДоговоров.Валюта = КурсыВалютыРегл.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалютыУпр
	|		ПО ДатыДоговоров.Валюта = КурсыВалютыУпр.Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеРегистра.Период КАК Период,
	|	ДанныеРегистра.Регистратор КАК Регистратор,
	|	ДанныеРегистра.НомерСтроки КАК НомерСтроки,
	|	ДанныеРегистра.Активность КАК Активность,
	|	ДанныеРегистра.ВидДвижения КАК ВидДвижения,
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ДанныеРегистра.Договор КАК Договор,
	|	ДанныеРегистра.ТипСуммы КАК ТипСуммы,
	|	ДанныеРегистра.СуммаВВалюте КАК СуммаВВалюте,
	|	ДанныеРегистра.СуммаВВалюте * КурсыВалют.КурсУпр / КурсыВалют.КратностьУпр КАК СуммаУпр,
	|	ДанныеРегистра.СуммаВВалюте * КурсыВалют.КурсРегл / КурсыВалют.КратностьРегл КАК СуммаРегл,
	|	ДанныеРегистра.ТипГрафика КАК ТипГрафика,
	|	ДанныеРегистра.СтатьяАналитики КАК СтатьяАналитики,
	|	ДанныеРегистра.МоментВремени КАК МоментВремени
	|ИЗ
	|	втДанныеРегистра КАК ДанныеРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ втКурсыВалют КАК КурсыВалют
	|		ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = КурсыВалют.АналитикаУчетаПоПартнерам
	|		И ДанныеРегистра.Договор = КурсыВалют.Договор
	|		И ДанныеРегистра.Валюта = КурсыВалют.Валюта
	|ИТОГИ ПО
	|	Регистратор
	|";
	
КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли