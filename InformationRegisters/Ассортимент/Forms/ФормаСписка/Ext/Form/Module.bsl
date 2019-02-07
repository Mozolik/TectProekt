﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СписокВидовЦен = Новый СписокЗначений;
	СписокВидовЦен.ЗагрузитьЗначения(Справочники.ВидыЦен.ДоступныеВидыЦен());
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидЦены", СписокВидовЦен, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	
КонецПроцедуры
