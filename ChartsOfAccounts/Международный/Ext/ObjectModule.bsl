﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Валютный Тогда
		ИсключитьИзРасчетаКурсовыхРазниц = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли