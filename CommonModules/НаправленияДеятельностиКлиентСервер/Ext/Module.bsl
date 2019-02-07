﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "НаправленияДеятельностиКлиентСервер" содержит процедуры,
// связанные с интерактивной работой пользователя в формах документов.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура СтруктураДействийВставитьПриДобавленииСтроки(Форма, СтруктураДействий) Экспорт
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначение", Кэш.НазначениеПоУмолчанию);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

