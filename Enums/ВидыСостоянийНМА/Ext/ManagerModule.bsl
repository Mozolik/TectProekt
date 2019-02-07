﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	Для Каждого ТекЭлемент Из Перечисления.ВидыСостоянийНМА Цикл
		Если ТекЭлемент <> Перечисления.ВидыСостоянийНМА.Поступил Тогда
			ДанныеВыбора.Добавить(ТекЭлемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли