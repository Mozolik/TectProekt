﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбъектАвторизации = ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя();
	Партнер = ДанныеОбъектАвторизации.Партнер;
		
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		 Отказ = Истина;
		 Возврат;
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("Партнер",Партнер);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата",ТекущаяДатаСеанса());
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");

	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПланПродаж" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыПланов.ВПодготовке" ) Тогда
		Отказ = Истина;
		ВыполнитьПечать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ВыполнитьПечать()

	МассивСсылок = Новый Массив;
	Для Каждого Ссылка Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	СамообслуживаниеКлиент.ПечатьДокументПлан(МассивСсылок);
	
КонецПроцедуры

#КонецОбласти
