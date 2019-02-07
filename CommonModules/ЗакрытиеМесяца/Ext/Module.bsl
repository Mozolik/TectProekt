﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЗАКРЫТИЯ МЕСЯЦА


// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПодготовитьПараметрыТаблицаРеквизиты(ТаблицаРеквизиты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы Параметры.Реквизиты
	
	СписокОбязательныхКолонок = ""
	+ "Период,"       // <Дата>
	+ "Организация,"  // <СправочникСсылка.Организации>
	+ "Регистратор"   // <ДокументСсылка.*>
	;
	
	ТаблицаПараметров = УправлениеВнеоборотнымиАктивамиПереопределяемый.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты,
		СписокОбязательныхКолонок);
	Параметры.Вставить("Реквизиты", ТаблицаПараметров);
	
	Возврат Параметры;
	
КонецФункции

// Выполняет запись в регистры информации параметров расчетов по рег.операциям
// по данным которых будут построены справки - расчеты
Процедура ЗаписьВоВспомогательныеРегистрыСведений(Движения, ТаблицаДвижений, ТаблицаРеквизиты,
										ВспомогательныйРегистр, СтрокаГруппировки = Неопределено, СтрокаСуммирования = Неопределено) Экспорт
	
	Если ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВспомогательныйРасчет = Движения[ВспомогательныйРегистр];
	Параметры = ПодготовитьПараметрыТаблицаРеквизиты(ТаблицаРеквизиты);
	
	Если Параметры.Реквизиты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = Параметры.Реквизиты[0];
	
	Если ТаблицаДвижений.Колонки.Найти("Организация") = Неопределено Тогда
		ТаблицаДвижений.Колонки.Добавить("Организация",
			Новый ОписаниеТипов("СправочникСсылка.Организации"));
	КонецЕсли;
	
	ТаблицаДвижений.ЗаполнитьЗначения(Реквизиты.Организация, "Организация");
	Если СтрокаГруппировки <> Неопределено И СтрокаСуммирования <> Неопределено Тогда
		ТаблицаДвижений.Свернуть(СтрокаГруппировки, СтрокаСуммирования);
	КонецЕсли;
	
	Если ТаблицаДвижений.Колонки.Найти("ПериодРасчета") = Неопределено Тогда
		ТаблицаДвижений.Колонки.Добавить("ПериодРасчета",
			Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	КонецЕсли;
	
	ТаблицаДвижений.ЗаполнитьЗначения(Реквизиты.Период, "ПериодРасчета");
	
	Для Каждого СтрокаТаблицы Из ТаблицаДвижений Цикл
		ВспомогательныйРасчетЗапись = ВспомогательныйРасчет.Добавить();
		ЗаполнитьЗначенияСвойств(ВспомогательныйРасчетЗапись, СтрокаТаблицы);
	КонецЦикла;
	
	ВспомогательныйРасчет.Записывать = Истина;
	
КонецПроцедуры

#Область НЕУКР
	


#КонецОбласти 


