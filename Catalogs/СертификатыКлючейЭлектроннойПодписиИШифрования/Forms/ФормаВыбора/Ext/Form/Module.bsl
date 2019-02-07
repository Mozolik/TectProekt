﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.УстановитьУсловноеОформлениеСпискаСертификатов(Список);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	
	ОбщиеНастройки = ЭлектроннаяПодпись.ОбщиеНастройки();
	
	Если Не ОбщиеНастройки.ИспользоватьШифрование
	   И Не ОбщиеНастройки.ЗаявлениеНаВыпускСертификатаДоступно Тогда
		
		Элементы.ФормаСоздать.Заголовок = НСтр("ru='Добавить';uk='Додати'");
		Элементы.СписокКонтекстноеМенюСоздать.Заголовок = НСтр("ru='Добавить';uk='Додати'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования")
	   И Параметр.Свойство("ЭтоНовый") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
	// При изменении настроек использования.
	Если ВРег(ИмяСобытия) <> ВРег("Запись_НаборКонстант") Тогда
		Возврат;
	КонецЕсли;
	
	Если ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
	 Или ВРег(Источник) = ВРег("ИспользоватьШифрование") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененияИспользованияПодписанияИлиШифрования", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Не Копирование Тогда
		
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
		ПараметрыСоздания.Вставить("Организация", Организация);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененияИспользованияПодписанияИлиШифрования()
	
	ОбщиеНастройки = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки();
	
	Если ОбщиеНастройки.ИспользоватьШифрование
	 Или ОбщиеНастройки.ЗаявлениеНаВыпускСертификатаДоступно Тогда
		
		Элементы.ФормаСоздать.Заголовок = НСтр("ru='Добавить...';uk='Додати...'");
		Элементы.СписокКонтекстноеМенюСоздать.Заголовок = НСтр("ru='Добавить...';uk='Додати...'");
	Иначе
		Элементы.ФормаСоздать.Заголовок = НСтр("ru='Добавить';uk='Додати'");
		Элементы.СписокКонтекстноеМенюСоздать.Заголовок = НСтр("ru='Добавить';uk='Додати'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
