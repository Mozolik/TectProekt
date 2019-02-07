﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ИмяСобытия = "Новости. Изменился статус операции" Тогда
		Если (Источник = ЭтаФорма.УникальныйИдентификатор) ИЛИ (Источник = "*") Тогда
			Элементы.ДекорацияСостояниеОперации.Заголовок = Параметр;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Новости. Операция завершена" Тогда
		Если (Источник = ЭтаФорма.УникальныйИдентификатор) ИЛИ (Источник = "*") Тогда
			ЭтаФорма.Закрыть(Истина);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтаФорма.ТолькоПросмотр = Истина;

	ЭтаФорма.Заголовок                            = Параметры.Заголовок;
	Элементы.ДекорацияСостояниеОперации.Заголовок = Параметры.СостояниеОперации;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицыФормы
#КонецОбласти

#Область ОбработчикиКомандФормы
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти
