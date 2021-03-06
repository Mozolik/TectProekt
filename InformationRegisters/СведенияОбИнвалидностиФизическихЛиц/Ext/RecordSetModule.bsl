﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(Строка.СрокДействияСправки) Тогда
			Строка.ДействуетДо = КонецМесяца(Строка.СрокДействияСправки) + 1;
		Иначе
			Строка.ДействуетДо = ""
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли