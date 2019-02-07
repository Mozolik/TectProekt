﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема «Учет штатного расписания».
//
// Методы, обслуживающие подписки на события.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет настройки учета среднего заработка в зависимости 
//  от количества в информационной базе специализированных начислений.
//
Процедура УстановитьИспользованиеИндексацииШтатногоРасписания(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Или Источник.Количество() = 0  Тогда
		Возврат;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьИндексациюШтатногоРасписания") <> 
		Источник[0].ИспользоватьИндексациюЗаработка И ПолучитьФункциональнуюОпцию("ИспользоватьИсториюИзмененияШтатногоРасписания") Тогда
		НаборНастройкиШтатногоРасписания = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьНаборЗаписей();
		НаборНастройкиШтатногоРасписания.Прочитать();
		НаборНастройкиШтатногоРасписания[0].ИспользоватьИндексациюШтатногоРасписания = Источник[0].ИспользоватьИндексациюЗаработка И ПолучитьФункциональнуюОпцию("ИспользоватьИсториюИзмененияШтатногоРасписания");
		НаборНастройкиШтатногоРасписания.ОбменДанными.Загрузка = Истина;
		НаборНастройкиШтатногоРасписания.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
