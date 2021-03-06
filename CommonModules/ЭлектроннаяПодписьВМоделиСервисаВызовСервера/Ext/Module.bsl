﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция УчетнаяЗапись(Знач Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		Возврат Объект.УчетнаяЗапись;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция РеквизитыУчетнойЗаписи(Знач Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УчетнаяЗапись = УчетнаяЗапись(Объект);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Реквизиты = "ЭлектроннаяПодписьВМоделиСервиса, ТелефонМобильныйДляАвторизации, ИдентификаторДокументооборота, Ссылка";
		РеквизитыУчетнойЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, Реквизиты);
		Если ЗначениеЗаполнено(РеквизитыУчетнойЗаписи.ЭлектроннаяПодписьВМоделиСервиса) Тогда
			Возврат РеквизитыУчетнойЗаписи;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, ТелефонМобильныйДляАвторизации, ИдентификаторДокументооборота, Ссылка",
		Ложь, "", "", Неопределено);
	
КонецФункции

Функция ЭтоЭлектроннаяПодписьВМоделиСервиса(Знач Объект = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбъектЗначение = Объект;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЭлектроннуюПодписьВМоделиСервиса") Тогда
		Если ТипЗнч(ОбъектЗначение) = Тип("ДанныеФормыСтруктура") ИЛИ ЗначениеЗаполнено(ОбъектЗначение) Тогда
			УчетнаяЗапись = УчетнаяЗапись(ОбъектЗначение);
			Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
				Возврат РеквизитыУчетнойЗаписи(УчетнаяЗапись).ЭлектроннаяПодписьВМоделиСервиса;
			Иначе
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ИспользованиеВозможно() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьЭлектроннуюПодписьВМоделиСервиса");
	
КонецФункции
