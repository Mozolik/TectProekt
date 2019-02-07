﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	ЗаполнитьДоступныеСчета();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ЗаполнитьДоступныеСчета()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	
	// Счета учета в эксплуатации
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоАвансаПолученным)));
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
