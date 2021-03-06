﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗапретОтгрузкиПоКредитуИПросрочке");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗапретОтгрузкиПоКредиту");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗапретОтгрузкиПоПросрочке");
	
КонецПроцедуры // НастроитьВариантыОтчета

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецЕсли