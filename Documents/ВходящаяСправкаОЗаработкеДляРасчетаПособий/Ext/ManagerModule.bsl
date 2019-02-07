﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Выполняет поиск документов по заданным параметрам отбора.
//
// Параметры:
//	Организация
//	ФизическоеЛицо
//	Страхователь
//	Месяц
//
// Возвращаемое значение — массив документов.
//
Функция ВходящиеСправкиОЗаработкеПоОтбору(Организация, ФизическоеЛицо, Месяц) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВходящаяСправка.Ссылка
	|ИЗ
	|	Документ.ВходящаяСправкаОЗаработкеДляРасчетаПособий.ДанныеОЗаработке КАК ТаблицаДанныеОЗаработке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВходящаяСправкаОЗаработкеДляРасчетаПособий КАК ВходящаяСправка
	|		ПО ТаблицаДанныеОЗаработке.Ссылка = ВходящаяСправка.Ссылка
	|			И (ВходящаяСправка.Организация = &Организация)
	|			И (ВходящаяСправка.ФизическоеЛицо = &ФизическоеЛицо)
	|			И (ТаблицаДанныеОЗаработке.РасчетныйМесяц = &Месяц)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Месяц", Месяц);
	
	ВходящиеСправки = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВходящиеСправки.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ВходящиеСправки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли