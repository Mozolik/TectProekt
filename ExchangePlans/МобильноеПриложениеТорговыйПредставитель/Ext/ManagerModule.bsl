﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает признак использования плана обмена для организации обмена в модели сервиса.
//  Если признак установлен, то в сервисе можно включить обмен данными
//  с использованием этого плана обмена.
//  Если признак не установлен, то план обмена будет использоваться только 
//  для обмена в локальном режиме работы конфигурации.
// 
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Устанавливает код для узла плана обмена с мобильными приложениям, соответствующего этой ИБ.
// Вызывается при первоначальном заполнении ИБ.
//
Процедура НачальноеЗаполнениеКодаУзлаЭтойИБ() Экспорт
	
	Узел = ПланыОбмена.МобильноеПриложениеТорговыйПредставитель.ЭтотУзел();
	
	Если ЗначениеЗаполнено(Узел) И НЕ ЗначениеЗаполнено(Узел.Код) Тогда
		ОбъектУзла = Узел.ПолучитьОбъект();
		ОбъектУзла.Код = 0;
		ОбъектУзла.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли