﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Функция СинонимКонтрагента(ТипЗадолженности) экспорт
	Если ТипЗадолженности=Перечисления.ТипыЗадолженности.Дебиторская Тогда
		ТекстСинонима = НСтр("ru='Дебитор';uk='Дебітор'");
	ИначеЕсли ТипЗадолженности=Перечисления.ТипыЗадолженности.Кредиторская Тогда
		ТекстСинонима = НСтр("ru='Кредитор';uk='Кредитор'");
	Иначе
		ТекстСинонима = НСтр("ru='Контрагент';uk='Контрагент'");
	КонецЕсли;
	Возврат ТекстСинонима;
КонецФункции
#КонецЕсли