﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	
	УстановитьПараметрыФункциональныхОпций(Объект.Владелец);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыФункциональныхОпций(Организация)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Организация));
	
КонецПроцедуры

#КонецОбласти
