﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	 И ДанныеЗаполнения.Свойство("АктивПассив") Тогда
		АктивПассив = ДанныеЗаполнения.АктивПассив;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
