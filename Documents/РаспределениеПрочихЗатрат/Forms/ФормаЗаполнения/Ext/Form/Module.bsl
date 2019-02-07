﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Период") Тогда
		Период = Параметры.Период;
	КонецЕсли;
	ВариантРаспределения = Перечисления.СпособыРаспределенияСтатейРасходов.ПоПодразделениямИЭтапамПоПравилам;

	Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		Элементы.НадписьПоЭтапам.Заголовок = НСтр("ru='По выпускам продукции';uk='По випусках продукції'");
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивРеквизитовОперации = Новый Массив;
	
	МассивРеквизитовОперации.Добавить("ВариантРаспределения");
	
	
	Если ВариантРаспределения = 
			Перечисления.СпособыРаспределенияСтатейРасходов.ПоПодразделениямИЭтапамПоПравилам Тогда
				МассивРеквизитовОперации.Добавить("ПравилоРаспределенияПоЭтапам");
				МассивРеквизитовОперации.Добавить("ПравилоРаспределенияПоПодразделениям");
	Иначе
		МассивРеквизитовОперации.Добавить("ПравилоРаспределенияПоЭтапам");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		ПроверяемыеРеквизиты,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантРаспределенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияПриИзменении(Элемент)
	
	УстановитьВидимостьПравилРаспределения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьДокументы(Команда)
	
	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("ВариантРаспределения", ВариантРаспределения);
		ДанныеЗаполнения.Вставить("ПравилоРаспределенияПоЭтапам", ПравилоРаспределенияПоЭтапам);
		ДанныеЗаполнения.Вставить("ПравилоРаспределенияПоПодразделениям", ПравилоРаспределенияПоПодразделениям);
		Закрыть(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьПравилРаспределения()
	
	Если ВариантРаспределения = ПредопределенноеЗначение("Перечисление.СпособыРаспределенияСтатейРасходов.ПоПодразделениямИЭтапамПоПравилам") Тогда
		Элементы.ГруппаПравилаРаспределенияСтраницы.ТекущаяСтраница = Элементы.СтраницаПодразделенияЭтапы;
	ИначеЕсли ВариантРаспределения = 
		ПредопределенноеЗначение("Перечисление.СпособыРаспределенияСтатейРасходов.ПоЭтапамПоПравилуВДанномПодразделении")
		ИЛИ ВариантРаспределения = 
			ПредопределенноеЗначение("Перечисление.СпособыРаспределенияСтатейРасходов.ПоЭтапамПоПравилуПоВсемПодразделениям") Тогда
		Элементы.ГруппаПравилаРаспределенияСтраницы.ТекущаяСтраница = Элементы.СтраницаЭтапы;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
