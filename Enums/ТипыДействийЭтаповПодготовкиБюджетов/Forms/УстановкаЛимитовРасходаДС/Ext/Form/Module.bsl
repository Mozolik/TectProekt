﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	
	НастройкиДействия = ПолучитьИзВременногоХранилища(Адрес);
	Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВосстановитьНастройкиДействия(НастройкиДействия, ЭтаФорма);
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(СохранитьНастройкиНаСервере());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Настройки = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.НастройкиДействия(ЭтаФорма);
	Возврат ПоместитьВоВременноеХранилище(Настройки, Адрес);
	
КонецФункции

#КонецОбласти
