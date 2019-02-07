﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура формирует строки списка участников.
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Если Не Взаимодействия.КонтактыЗаполнены(Контакты) Тогда
		Возврат;
	КонецЕсли;
	
	// В телефонный звонок переносим первого контакта.
	Параметр = Контакты[0];
	Если ТипЗнч(Параметр) = Тип("Структура") Тогда
		АбонентКонтакт       = Параметр.Контакт;
		АбонентКакСвязаться  = Параметр.Адрес;
		АбонентПредставление = Параметр.Представление;
	Иначе
		АбонентКонтакт = Параметр;
	КонецЕсли;
	
	Взаимодействия.ДозаполнитьПоляКонтактов(АбонентКонтакт, АбонентПредставление, 
		АбонентКакСвязаться, Перечисления.ТипыКонтактнойИнформации.Телефон);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	// Логика ограничения следующая: объект доступен если доступен  "Автор" или "Ответственный".
	// Логика "ИЛИ" реализуется через различные номера наборов.
	// Ограничение по "УчетныеЗаписиЭлектроннойПочты".
	НомерНабора = 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ЗначениеДоступа = Автор;

	// Ограничение по "Ответственный".
	НомерНабора = НомерНабора + 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ЗначениеДоступа = Ответственный;

	Если ЗначениеЗаполнено(АбонентКонтакт) Тогда

		Если ТипЗнч(АбонентКонтакт) = Тип("СправочникСсылка.Партнеры") Тогда

			НомерНабора = НомерНабора + 1;

			СтрокаТаб = Таблица.Добавить();
			СтрокаТаб.НомерНабора     = НомерНабора;
			СтрокаТаб.ЗначениеДоступа = АбонентКонтакт;

		ИначеЕсли ТипЗнч(АбонентКонтакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
			|ИЗ
			|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|ГДЕ
			|	КонтактныеЛицаПартнеров.Ссылка =&АбонентКонтакт
			|");
			Запрос.УстановитьПараметр("АбонентКонтакт", АбонентКонтакт);
			Выборка = Запрос.Выполнить().Выбрать();

			Пока Выборка.Следующий() Цикл

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли