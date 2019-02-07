﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если РольДоступна(Метаданные.Роли.АдминистраторСистемы)
			И РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Истина;
	Иначе
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицыФормы
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьОтборы(Команда)

	// Удалить некорректные категории для отборов
	ОбработкаНовостейВызовСервера.ОптимизироватьОтборыПоНовостям();

	// Пересчитать отборы
	ОбработкаНовостейВызовСервера.ПересчитатьОтборыПоНовостям_Пользовательские(Неопределено); // По всем пользователям

КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьОтобразитьПодсказку(Команда)

	Если Элементы.ДекорацияПодсказка.Высота = 1 Тогда
		Элементы.ДекорацияПодсказка.Высота = 5;
	Иначе
		Элементы.ДекорацияПодсказка.Высота = 1;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти