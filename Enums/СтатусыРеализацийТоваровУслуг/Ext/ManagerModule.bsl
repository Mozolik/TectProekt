﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	Если (Параметры.Свойство("ПоказатьВсе") И Параметры.ПоказатьВсе)
		ИЛИ ((Параметры.Свойство("РеализацияПоЗаказам") И НЕ Параметры.РеализацияПоЗаказам) 
			И Параметры.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию) Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате);
	КонецЕсли;
	Если (Параметры.Свойство("ПереходПравСобственности") И Параметры.ПереходПравСобственности)
		ИЛИ (Параметры.Свойство("ХозяйственнаяОперация") 
			И Параметры.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности) Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыРеализацийТоваровУслуг.ВПути);
	КонецЕсли;
	ДанныеВыбора.Добавить(Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено);
	
КонецПроцедуры

