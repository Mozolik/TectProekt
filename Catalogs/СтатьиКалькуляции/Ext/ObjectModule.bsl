﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИндентификаторУникален() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		СтрЗаменить(НСтр("ru='В базе данных уже содержится статья калькуляции с идентификатором ""%Идентификатор%"".
            |Идентификатор должен быть уникальным'
            |;uk='У базі даних вже міститься стаття калькуляції з ідентифікатором ""%Идентификатор%"".
            |Ідентифікатор повинен бути унікальним'"), "%Идентификатор%", Идентификатор), 
		ЭтотОбъект, "Идентификатор",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет поиск идентификатора, совпадающего с заполненным в объекте
//
// Возвращаемое значение:
//	Булево
//	Истина, если идентификатор не найден, Ложь в противном случае
//
Функция ИндентификаторУникален()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции
	|ГДЕ
	|	СтатьиКалькуляции.Идентификатор = &Идентификатор
	|	И СтатьиКалькуляции.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
