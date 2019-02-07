﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем МенеджерВременныхТаблиц;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УчетРабочегоВремени.КонтрольИзмененияДанныхРегистровПередЗаписью(ЭтотОбъект, МенеджерВременныхТаблиц);
КонецПроцедуры


Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеРегистра = РегистрыНакопления.ДанныеТабельногоУчетаРабочегоВремениСотрудников.ОписаниеРегистра();
	
	ОписаниеРегистра.МетаданныеРегистра = Метаданные();
	ОписаниеРегистра.ИмяПоляСотрудник = "Сотрудник";
	ОписаниеРегистра.ИмяПоляПериод = "Период";
	ОписаниеРегистра.ИмяПоляПериодРегистрации = "ПериодРегистрации";
	ОписаниеРегистра.ИмяПоляВидДанных = Неопределено;
	ОписаниеРегистра.ВидДанных = Перечисления.ВидыДанныхУчетаВремениСотрудников.ДанныеТабельногоУчета;
	
	УчетРабочегоВремени.ЗаписатьПараметрыРегистрируемыхДанных(Отбор.Регистратор.Значение, ОписаниеРегистра);
	
	ДанныеИзменены = Ложь;
	
	УчетРабочегоВремени.КонтрольИзмененияДанныхРегистровПриЗаписи(ЭтотОбъект, МенеджерВременныхТаблиц, ДанныеИзменены);
	
	Если ДанныеИзменены Тогда
		УчетРабочегоВремени.РегистрРасчитанныхДанныхПриИзмененииИсточниковДанных(МенеджерВременныхТаблиц);
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
