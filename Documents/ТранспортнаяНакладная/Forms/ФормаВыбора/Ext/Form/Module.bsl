﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала = Дата(1,1,1);
	ДокументОснование = Документы.РеализацияТоваровУслуг.ПустаяСсылка();
	АдресХранилища = "";
		
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("ДокументОснование", ДокументОснование);
		Параметры.Отбор.Свойство("ДатаНачала", 		  ДатаНачала);
		Параметры.Отбор.Свойство("АдресХранилища", 	  АдресХранилища);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДокументСсылка", ДокументОснование);
	Список.Параметры.УстановитьЗначениеПараметра("ДокументСсылкаНеЗаполнен", Не ЗначениеЗаполнено(ДокументОснование));
	
	Если Не ПустаяСтрока(АдресХранилища) Тогда 
		
		ТаблицаПараметровОтбора = ПолучитьИзВременногоХранилища(АдресХранилища);
		
		ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		ГруппаИли = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтборДинамическогоСписка.Элементы, "ГруппаИли", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		Для Каждого ПараметрыОтбора Из ТаблицаПараметровОтбора Цикл
			ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ГруппаИли.Элементы, "ГруппаИ", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "АдресДоставки", ПараметрыОтбора.АдресДоставки, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.АдресДоставки));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Грузополучатель", ПараметрыОтбора.Грузополучатель, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.Грузополучатель));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Организация", ПараметрыОтбора.Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.Организация));
					
			Перевозчик = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ПараметрыОтбора.ПеревозчикПартнер);		
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Перевозчик", Перевозчик, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Перевозчик));
		КонецЦикла;
		
	КонецЕсли;	
					
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "Дата", ДатаНачала, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры

#КонецОбласти
