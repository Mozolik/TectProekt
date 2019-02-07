﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	// Необходимо определить набор ключевых измерений для записи связанного набора записей сводных данных о времени.
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеНабора.ФизическоеЛицо,
	|	ДанныеНабора.Сотрудник,
	|	ДанныеНабора.ГоловнаяОрганизация,
	|	ДанныеНабора.Месяц
	|ИЗ
	|	РегистрСведений.ДанныеОВремениДляРасчетаСреднегоФСС КАК ДанныеНабора
	|ГДЕ
	|	ДанныеНабора.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	ДополнительныеСвойства.Вставить("КлючевыеИзмерения", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	УчетПособийСоциальногоСтрахованияРасширенный.ЗарегистрироватьДанныеОВремениСреднегоЗаработкаФСС(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли