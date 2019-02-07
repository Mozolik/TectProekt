﻿////////////////////////////////////////////////////////////////////////////////
// Содержит события форм, вызываемые на клиенте
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма	- УправляемаяФорма - форма, в которой расположена команда
//  Команда	- КомандаФормы - команда формы
//  ДополнительныеПараметры	- Структура - дополнительные параметры
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ НЕ УТ
	ИнтеграцияССППРКлиент.ВыполнитьКомандуИнтеграцииССППР(Форма, Команда, ДополнительныеПараметры);
	
	ПроверкаДокументовКлиент.ВыполнитьКомандуИзмененияСтатусаПроверкиДокумента(Форма, Команда);
	//-- НЕ УТ
	
	МодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры);
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма					- УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//  ИмяСобытия				- Строка - идентификатор сообщения принимающей формой (см. метод Оповестить)
//	Параметр				- Произвольный - параметр сообщения (см. метод Оповестить)
//	Источник				- Произвольный - источник события (см. метод Оповестить)
//  ДополнительныеПараметры	- Структура - дополнительные параметры
//
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ НЕ УТ
	ПроверкаДокументовКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	//-- НЕ УТ
	
	Возврат; // Чтобы в УТ не был пустым обработчиком
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма					- УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ					- Булево - признак отказа от записи документа
//	ПараметрыЗаписи			- Структура - параметры записи (см. событие ПередЗаписью)
//
Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	//++ НЕ УТ
	ПроверкаДокументовКлиент.ПередЗаписью(Форма, Отказ, ПараметрыЗаписи);
	//-- НЕ УТ
	
	Возврат; // Чтобы в УТ не был пустым обработчиком
	
КонецПроцедуры

#КонецОбласти
