﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.Вставить("УчетнаяПолитика", Параметры.ПараметрКоманды);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	

	Параметры = ЭтаФорма.ФормаПараметры;
	Если Параметры.Свойство("УчетнаяПолитика") Тогда
		
		КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
		
		// Установка значений параметров при контекстном вызове
		НастроитьПараметры(КомпоновщикНастроекФормы, Параметры);
		
		НовыеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкаУчетнойПолитики = НастройкаПараметра("УчетнаяПолитика");
	Если Не ЗначениеЗаполнено(НастройкаУчетнойПолитики.Значение) Тогда
		ТекстСообщения = НСтр("ru='Не выбрана учетная политика.';uk='Не вибрана облікова політика.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Функция НастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

Процедура НастроитьПараметры(КомпоновщикНастроекФормы, Параметры)
	
	ПользНастройка = ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, "УчетнаяПолитика");
	Если ПользНастройка <> Неопределено Тогда
		ПользНастройка.Значение = Параметры.УчетнаяПолитика;
		ПользНастройка.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроекФормы.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецЕсли