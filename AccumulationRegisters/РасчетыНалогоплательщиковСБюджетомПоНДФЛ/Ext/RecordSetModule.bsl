﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДатыУдержанияНалога = Новый Массив;
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		Если СтрокаНабора.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
			СтрокаНабора.ДокументОснование = Регистратор
		КонецЕсли;
	КонецЦикла;
	
	Если ДатыУдержанияНалога.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли