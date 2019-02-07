﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизационнаяСтруктураСобытия.ОбновитьСтруктуруПредприятия(Отказ);
	
	Если ЭтотОбъект.Значение = Истина Тогда 
		ОрганизационнаяСтруктура.СоздатьУправленческуюОрганизацию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли