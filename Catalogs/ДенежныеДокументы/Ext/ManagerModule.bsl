﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Цена");
	Результат.Добавить("Валюта");
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
