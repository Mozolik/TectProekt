﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПоказателей = Параметры.ВидПоказателей;
	
	Элементы.ГруппаМеждународный.Доступность = Параметры.ЕстьПоказателиМУ;
	Элементы.ГруппаРегламентированный.Доступность = Параметры.ЕстьПоказателиБУ;
	
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаМУ = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	ВалютаОК = ВалютаРегл = ВалютаМУ.Функциональная ИЛИ ВалютаРегл = ВалютаМУ.Представления;
	Если НЕ ВалютаОК Тогда
		Шаблон = НСтр("ru='Валюта регл. учета %1; Функциональная валюта %2; Валюта представления %3.
                            |Совместное использование показателей недоступно.'
                            |;uk='Валюта регл. обліку %1; Функціональна валюта %2; Валюта представлення %3.
                            |Спільне використання показників недоступне.'");
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ВалютаРегл, ВалютаМУ.Функциональная,  ВалютаМУ.Представления);
		Элементы.ПояснениеПочему.Заголовок = Текст;
		Элементы.ГруппаСмешанный.Доступность = Ложь;
	КонецЕсли;
	
	Текст = ?(ПустаяСтрока(Элементы.ПояснениеПочему.Заголовок),"",Элементы.ПояснениеПочему.Заголовок + Символы.ПС);
	Если Параметры.ЕстьПоказателиМУ И Параметры.ЕстьПоказателиБУ Тогда
		Элементы.ГруппаМеждународный.Доступность = Ложь;
		Элементы.ГруппаРегламентированный.Доступность = Ложь;
		Текст = Текст + НСтр("ru='Текущий отчет содержит показатели международного и регламентированного плана счетов.
                            |Использование показателей только одного вида недоступно.'
                            |;uk='Поточний звіт містить показники міжнародного і регламентованого плану рахунків.
                            |Використання показників тільки одного виду недоступно.'");
		
	ИначеЕсли Параметры.ЕстьПоказателиМУ И НЕ Параметры.ЕстьПоказателиБУ Тогда
		Текст = Текст + НСтр("ru='Текущий отчет содержит показатели только международного плана счетов.';uk='Поточний звіт містить показники тільки міжнародного плану рахунків.'");
		
	ИначеЕсли НЕ Параметры.ЕстьПоказателиМУ И Параметры.ЕстьПоказателиБУ Тогда
		Текст = Текст + НСтр("ru='Текущий отчет содержит показатели только регламентированного плана счетов.';uk='Поточний звіт містить показники тільки регламентованого плану рахунків.'");
		
	ИначеЕсли ВалютаОК Тогда
		Элементы.ГруппаМеждународный.Доступность = Истина;
		Элементы.ГруппаРегламентированный.Доступность = Истина;
		Элементы.ГруппаКомментарийПочему.Видимость = Ложь;
		
	КонецЕсли;
	Элементы.ПояснениеПочему.Заголовок = Текст;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВидПоказателей(Команда)
	
	Закрыть(ВидПоказателей);
	
КонецПроцедуры

#КонецОбласти
