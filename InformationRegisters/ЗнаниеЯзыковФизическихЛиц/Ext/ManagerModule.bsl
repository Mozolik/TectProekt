﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеВладениеЯзыкамиФизическогоЛица(ФизическоеЛицоСсылка) Экспорт
	
	ЗнаниеЯзыков = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗнаниеЯзыковФизическихЛиц.Язык,
		|	ЗнаниеЯзыковФизическихЛиц.СтепеньЗнанияЯзыка
		|ИЗ
		|	РегистрСведений.ЗнаниеЯзыковФизическихЛиц КАК ЗнаниеЯзыковФизическихЛиц
		|ГДЕ
		|	ЗнаниеЯзыковФизическихЛиц.ФизическоеЛицо = &ФизическоеЛицоСсылка";
		
	Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	
	Возврат ПредставлениеВладениеЯзыкамиПоКоллекцииЗаписей(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ПредставлениеВладениеЯзыкамиПоКоллекцииЗаписей(НаборЗаписей) Экспорт
	
	ПредставлениеВладениеЯзыками = "";
	
	Для Каждого СтрокаЗнаниеЯзыков Из НаборЗаписей Цикл
		ПредставлениеВладениеЯзыками 	= ПредставлениеВладениеЯзыками + ?(ПустаяСтрока(ПредставлениеВладениеЯзыками), "", ", ") 
									+ ?(ЗначениеЗаполнено(СтрокаЗнаниеЯзыков.Язык), Строка(СтрокаЗнаниеЯзыков.Язык), "")
									+ ?(ЗначениеЗаполнено(СтрокаЗнаниеЯзыков.СтепеньЗнанияЯзыка), " (" + Строка(СтрокаЗнаниеЯзыков.СтепеньЗнанияЯзыка) + ")", "");
	КонецЦикла;
	
	Если ПустаяСтрока(ПредставлениеВладениеЯзыками) Тогда
		ПредставлениеВладениеЯзыками = НСтр("ru='Не владеет языками';uk='Не володіє мовами'");
	КонецЕсли; 
	
	Возврат ПредставлениеВладениеЯзыками;
	
КонецФункции

#КонецОбласти

#КонецЕсли