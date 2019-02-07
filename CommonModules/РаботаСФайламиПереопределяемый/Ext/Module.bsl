﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Можно ли занять данный файл.
//
// Параметры:
//  ДанныеФайла    - Структура - с данными файла.
//  ОписаниеОшибки - Строка - содержащая текст ошибки в случае невозможности занять.
//                   Если не пустая, тогда файл невозможно занять.
//
Процедура ПриПопыткеЗанятьФайл(ДанныеФайла, ОписаниеОшибки = "") Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании файла.
//
// Параметры:
//  Файл - СправочникСсылка.Файлы - ссылка на созданный файл.
//
Процедура ПриСозданииФайла(Файл) Экспорт
	
КонецПроцедуры

// Вызывается после копирования файла из исходного файла для заполнения таких реквизитов нового файла,
// которые не предусмотрены в БСП и были добавлены к справочнику Файлы или ВерсииФайлов в конфигурации.
//
// Параметры:
//  НовыйФайл    - СправочникСсылка.Файлы - ссылка на новый файл, который надо заполнить.
//  ИсходныйФайл - СправочникСсылка.Файлы - ссылка на исходный файл, откуда надо скопировать реквизиты.
//
Процедура ЗаполнитьРеквизитыФайлаИзИсходногоФайла(НовыйФайл, ИсходныйФайл) Экспорт
	
КонецПроцедуры

// Вызывается при захвате файла.
//
// Параметры:
//  ДанныеФайла - Структура - содержащая сведения о файле
//                см. функцию РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла().
//
//  УникальныйИдентификатор - уникальный идентификатор формы.
//
Процедура ПриЗахватеФайла(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
КонецПроцедуры

// Вызывается при освобождении файла.
//
// Параметры:
//  ДанныеФайла - Структура - содержащая сведения о файле
//                см. функцию РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла().
//
//  УникальныйИдентификатор - уникальный идентификатор формы.
//
Процедура ПриОсвобожденииФайла(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
КонецПроцедуры

// Формирует массив метаданных, которые не должны выводиться в настройках очистки файлов.
//
// Параметры:
//   МассивИсключений   - Массив - метаданные, которые не должны выводиться в настройках очистки файлов.
//
Процедура ПриОпределенииОбъектовИсключенияОчисткиФайлов(МассивИсключений) Экспорт
	
КонецПроцедуры

// Формирует массив метаданных, которые не должны выводиться в настройках синхронизации файлов.
//
// Параметры:
//   МассивИсключений   - Массив - метаданные, которые не должны выводиться в настройках синхронизации файлов.
//
Процедура ПриОпределенииОбъектовИсключенияСинхронизацииФайлов(МассивИсключений) Экспорт
	
	МассивИсключений.Добавить(Метаданные.Справочники.ЭДПрисоединенныеФайлы);
	
КонецПроцедуры

// Устарела.Следует использовать ПриОпределенииОбъектовИсключенияОчисткиФайлов.
//
Функция ОбъектыИсключенияПриОчисткеФайлов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Метаданные.Справочники.ЭДПрисоединенныеФайлы);
	Возврат Массив;
	
КонецФункции

#КонецОбласти

