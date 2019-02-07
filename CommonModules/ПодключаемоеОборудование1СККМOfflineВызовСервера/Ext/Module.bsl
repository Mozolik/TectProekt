﻿////////////////////////////////////////////////////////////////////////////////
// Подключаемое оборудование1С: ККМ-Offline вызов сервера: Обработчик 1С: ККМ-offline (серверная часть).
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Функция проверяет, заполнен ли атрибут "Processed" у объектов "ReportTable" или "GoodsTable"
//	Если атрибут заполнено (файл обработан), возвращает "Истина", иначе "Ложь". При возникновении ошибки вернет "Неопределено"
//	Параметры:
//		- Выгрузка - флаг, отвечающий за определение типа объекта XDTO ("ReportTable" или "GoodsTable")
//		- ТекстПакета - текстовое представление содержимого пакета
//		- ВыходныеПараметры -
Функция ПакетыОбработаны(Выгрузка, Пакеты, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	СтрокаТипОбъекта = ?(Выгрузка, "PriceList", "SalesReports");
	
	ОбъектXDTO = Неопределено;
	ТипXDTO = ФабрикаXDTO.Тип("http://www.1c.ru/EquipmentService", СтрокаТипОбъекта);
	
	Для Каждого ТекПакет Из Пакеты Цикл
		
		ЧтениеXML = Неопределено;
		Если Не СоздатьЧтениеXML(ТекПакет, ЧтениеXML, ВыходныеПараметры) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Попытка
			ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипXDTO);
		Исключение
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='При проверке файла на обработанность произошла ошибка.';uk='При перевірці файлу на обробленість сталася помилка.'"));
			Возврат Неопределено;
		КонецПопытки;
		
		Если Не ЗначениеЗаполнено(ОбъектXDTO.Обработан) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция из текста отчета формирует объект ЧтениеXML, из него ОбъектXDTO, проверяет его на обработанность
//	После проверки ставит пометку об обработанности и записывает в текст XML
//	Параметры:
//		- ТекстОтчета - строка, содержимое отчета, куда нужно добавить отметку об обработке
//		- ВыходныеПараметры - 
Процедура ПометитьОтчетКакОбработанный(ТекстОтчета, ВыходныеПараметры, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеXML = Неопределено;
	Если Не СоздатьЧтениеXML(ТекстОтчета, ЧтениеXML, ВыходныеПараметры) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗагружаемыеОтчеты = Неопределено;
	Если Не ЧтениеXMLВОбъектXDTO(ЧтениеXML, ЗагружаемыеОтчеты, "SalesReports", ВыходныеПараметры) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗагружаемыеОтчеты.Обработан) Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Отчет уже помечен как обработанный';uk='Звіт вже позначений як оброблений'"));
		Отказ = Истина;
	КонецЕсли;
	
	ЗагружаемыеОтчеты.Обработан = ТекущаяДата();
	Если Не ОбъектXDTOВТекстXML(ЗагружаемыеОтчеты, ТекстОтчета, ВыходныеПараметры) Тогда
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет в массив выходных параметров сообщение об ошибке
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

// Функция создает объект ЧтениеXML на основании строки, переданной в качетсве параметра "ТекстПакета"
//	В случае успешного чтения вернет "Истина", иначе "Ложь"
//	Параметры:
//		- ТекстПакета - текстовое представление соержимого пакета
//		- ЧтениеXML - создаваяемый объект "ЧтениеXML"
//		- ВыходныеПараметры
Функция СоздатьЧтениеXML(ТекстПакета, ЧтениеXML, ВыходныеПараметры)
	
	Результат = Истина;
	
	ЧтениеXML = Новый ЧтениеXML;
	ПараметрыЧтения = Новый ПараметрыЧтенияXML("1.0");
	ЧтениеXML.УстановитьСтроку(ТекстПакета, ПараметрыЧтения);
	
	Попытка
		ЧтениеXML.Прочитать();
	Исключение
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='При чтении файла произошла ошибка';uk='При читанні файлу сталася помилка'"));
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает созданный объект ЗаписьXML, для записи содержимого в строку
Функция СоздатьЗаписьXML()
	
	ЗаписьXML = Новый ЗаписьXML;
	ПараметрыЗаписиXML = Новый ПараметрыЗаписиXML("UTF-8", "1.0");
	ЗаписьXML.УстановитьСтроку(ПараметрыЗаписиXML);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	Возврат ЗаписьXML;
	
КонецФункции

// Функция записывает содержимое ОбъектаXDTO в ЗаписьXML и помещает в параметр "ТекстXML" текст XML-файла
//	При успешном выполнении вернет "Истина", иначе "Ложь"
//	Параметры:
//		- ОбъектXDTO - объект XDTO, который необходимо записать
//		- ТекстXML - текст полученного XML-файла
//		- ВыходныеПараметры - 
Функция ОбъектXDTOВТекстXML(ОбъектXDTO, ТекстXML, ВыходныеПараметры)
	
	Результат = Истина;
	
	ЗаписьXML = СоздатьЗаписьXML();
	Попытка
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);
		ТекстXML = ЗаписьXML.Закрыть();
	Исключение
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='При формировании файла произошла ошибка.';uk='При формуванні файлу сталася помилка.'"));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция конвертирует объект ЧтениеXML в ОбъектXDTO при помощи фабрики XDTO по имени типа объекта из пространства имен "urn:1C.ru:KKMOffline"
//	При успешном выполнении вернет "Истина", иначе "Ложь"
//	Параметры:
//		- ЧтениеXML - ЧтениеXML на основании файла
//		- ОбъектXDTO - Созданный и заполненый объект XDTO
//		- ТипОбъекта - строка с именем типа объекта XDTO
//		- ВыходныеПараметры
Функция ЧтениеXMLВОбъектXDTO(ЧтениеXML, ОбъектXDTO, ТипОбъекта, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		ТипXDTO = ФабрикаXDTO.Тип("http://www.1c.ru/EquipmentService", ТипОбъекта);
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипXDTO);
	Исключение
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='При чтении файла произошла ошибка.';uk='При читанні файлу виникла помилка.'"));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти