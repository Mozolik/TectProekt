﻿
#Область ПрограммныйИнтерфейс

//Функция возвращает настройки форм, которые могут открываться при начале работы системы
//
//	Параметры:
//		Форма - ПеречислениеСсылка.ФормыОткрываемыеПриНачалеРаботыСистемы - форма, для которой нужно получить настройки
//	Возвращаемое значение:
//		Структура:
//			ИмяЗапускаемойФормы - Строка - полное имя открываемой формы (для передачи в фукнцию ОткрытьФорму)
//			Роль - Строка - имя роли, которая дает пользователю право на запуск формы
//			НеобходимыНастройки - Булево - для открываемой формы должны быть заданы настройки
//          ИмяФормыНастроек - Строка - если НеобходимыНастройки = ИСТИНА, то в этом параметре указывается полное имя формы
//										редактирования настроек (для передачи в фукнцию ОткрытьФорму)
//          ПараметрЗапуска - Строка - параметр запуска, наличие которого будет проверяться при начале работы системы,
//										форма будет открыта, если передан параметр запуска или настроено, что эту форму
//										нужно открывать по умолчанию (т.е. без проверки параметра запуска)
//
Функция НастройкиФормы(Форма) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруНастройкиФормы();
	
	Если Форма = ПредопределенноеЗначение("Перечисление.ФормыОткрываемыеПриНачалеРаботыСистемы.ПомощникПродаж") Тогда
		  
		СтруктураПараметров.Вставить("ИмяЗапускаемойФормы", "Обработка.ПомощникПродаж.Форма.Форма");
		СтруктураПараметров.Вставить("Роль",                "ИспользованиеПомощникаПродаж");
		СтруктураПараметров.Вставить("ПараметрЗапуска",     "SaleAssistant");
		
	ИначеЕсли Форма = ПредопределенноеЗначение("Перечисление.ФормыОткрываемыеПриНачалеРаботыСистемы.РабочееМестоРаботникаСклада") Тогда
		
		СтруктураПараметров.Вставить("ИмяЗапускаемойФормы", "Обработка.РабочееМестоРаботникаСклада.Форма.ФормаРабочегоМеста");
		СтруктураПараметров.Вставить("Роль",                "ИспользованиеРабочегоМестаРаботникаСклада");
		СтруктураПараметров.Вставить("НеобходимыНастройки", Истина);
		СтруктураПараметров.Вставить("ИмяФормыНастроек",    "Обработка.РабочееМестоРаботникаСклада.Форма.НастройкиПараметров");
		СтруктураПараметров.Вставить("ПараметрЗапуска",     "WarehouseMobileWorkplace");
		
	ИначеЕсли Форма = ПредопределенноеЗначение("Перечисление.ФормыОткрываемыеПриНачалеРаботыСистемы.ЧекККМ") Тогда
		  
		СтруктураПараметров.Вставить("ИмяЗапускаемойФормы", "Документ.ЧекККМ.Форма.ФормаДокументаРМК");
		СтруктураПараметров.Вставить("Роль",                "ДобавлениеИзменениеЧековККМ");
		СтруктураПараметров.Вставить("ПараметрЗапуска",     "CashRegisterReceipt");
		
	ИначеЕсли Форма = ПредопределенноеЗначение("Перечисление.ФормыОткрываемыеПриНачалеРаботыСистемы.РабочееМестоМенеджераПоДоставке") Тогда
		
		СтруктураПараметров.Вставить("ИмяЗапускаемойФормы", "Обработка.РабочееМестоМенеджераПоДоставке.Форма.Форма");
		СтруктураПараметров.Вставить("Роль",                "ИспользованиеРабочегоМестаДоставки");
		СтруктураПараметров.Вставить("ПараметрЗапуска",     "DeliveryWorkplace");
		
	КонецЕсли;
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруНастройкиФормы() Экспорт
	
	Возврат
		Новый Структура(
			"ИмяЗапускаемойФормы, Роль, НеобходимыНастройки, ИмяФормыНастроек, ПараметрЗапуска, ОткрыватьМодально, НастройкиУстановлены, Параметры, ОткрыватьПоУмолчанию",
			"", "ПолныеПрава", Ложь, "", "", Ложь, Ложь, Новый Структура, Ложь);
	
КонецФункции

#КонецОбласти
