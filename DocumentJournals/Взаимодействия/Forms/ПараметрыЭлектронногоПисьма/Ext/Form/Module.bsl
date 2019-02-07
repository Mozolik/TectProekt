﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормыИзПараметров(Параметры);
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Папка <> ТекущаяПапка Тогда
		ВзаимодействияВызовСервера.УстановитьПапкуЭлектронногоПисьма(Письмо,Папка);
	КонецЕсли;
	
	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" И ОтправленоПолучено = Дата(1,1,1) И Модифицированность Тогда
		
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("УведомитьОДоставке", УведомитьОДоставке);
		РезультатВыбора.Вставить("УведомитьОПрочтении", УведомитьОПрочтении);
		РезультатВыбора.Вставить("ВключатьТелоИсходногоПисьма", ВключатьТелоИсходногоПисьма);
		РезультатВыбора.Вставить("Папка", Неопределено);
		
	Иначе
		
		РезультатВыбора = Неопределено;
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,ИмяПараметра,ИмяРеквизита = "")

	Если ПереданныеПараметры.Свойство(ИмяПараметра) Тогда
		
		ЭтотОбъект[?(ПустаяСтрока(ИмяРеквизита),ИмяПараметра,ИмяРеквизита)] = ПереданныеПараметры[ИмяПараметра];
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыИзПараметров(ПереданныеПараметры)

	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ВнутреннийНомер");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ЗаголовкиИнтернета");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Создано");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Получено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Отправлено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УведомитьОДоставке");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УведомитьОПрочтении");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Письмо");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ТипПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ВключатьТелоИсходногоПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УчетнаяЗапись");
	
	Папка = Взаимодействия.ПолучитьПапкуЭлектронногоПисьма(Письмо);
	ТекущаяПапка = Папка;

КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()

	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" Тогда
		Элементы.Заголовки.Заголовок = НСтр("ru='Идентификаторы';uk='Ідентифікатори'");
		Если ОтправленоПолучено = Дата(1,1,1) Тогда
			Элементы.УведомитьОДоставке.ТолькоПросмотр          = Ложь;
			Элементы.УведомитьОПрочтении.ТолькоПросмотр         = Ложь;
			Элементы.ВключатьТелоИсходногоПисьма.ТолькоПросмотр = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтправленоПолучено.Заголовок = НСтр("ru='Получено';uk='Отримане'");
		Элементы.ВключатьТелоИсходногоПисьма.Видимость =Ложь;
	КонецЕсли;
	
	Элементы.Папка.Доступность = ЗначениеЗаполнено(УчетнаяЗапись);
	
КонецПроцедуры

#КонецОбласти
