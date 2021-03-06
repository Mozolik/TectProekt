﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ВместимостьПредставление = "";
	ПробелВСередине = "";
	Если ЗначениеЗаполнено(ГрузоподъемностьВТоннах) Тогда
		ВместимостьПредставление = Строка(ГрузоподъемностьВТоннах) + НСтр("ru=' т';uk=' т'");
		ПробелВСередине = " ";
	КонецЕсли;
	Если ЗначениеЗаполнено(ВместимостьВКубическихМетрах) Тогда
		ВместимостьПредставление = ВместимостьПредставление + ПробелВСередине + Строка(ВместимостьВКубическихМетрах) + НСтр("ru=' м3';uk=' м3'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли