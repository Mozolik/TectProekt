﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт

	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ФактическиеОтпуска");
	НастройкиВарианта.Описание =
		НСтр("ru='Проведенные отпуска за заданный период';uk='Проведені відпустки за заданий період'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли