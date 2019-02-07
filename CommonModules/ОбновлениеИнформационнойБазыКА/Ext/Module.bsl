﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки КомплекснаяАвтоматизацияДляУкраины.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СведенияОБиблиотекеИлиКонфигурации

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                  Обработчики обновления таких библиотек должны быть вызваны ранее
//                                  обработчиков обновления данной библиотеки.
//                                  При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                  порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                  в процедуре ПриДобавленииПодсистем общего модуля ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "BASКомплекснаяАвтоматизация";
	Описание.Версия = "2.0.1.1";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
	//++ НЕ УТКА
 	Описание.ОбновлятьПараллельноСПодсистемами.Добавить("BASERP");
	//-- НЕ УТКА
	
	Описание.ОбновлятьПараллельноСПодсистемами.Добавить("BASУправлениеТорговлей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//
// Параметры:
//  Обработчики - это таблица значений, возвращаемая функцией
//                НоваяТаблицаОбработчиковОбновления модуля ОбновлениеИнформационнойБазы.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия    = "1.0.0.0";
//  Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
// 
//  Все свойства обработчика см. в комментарии к функции
//  НоваяТаблицаОбработчиковОбновления в модуле ОбновлениеИнформационнойБазы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

#Область Монопольно

#Область НаКаждуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Процедура = "Справочники.ВидыБюджетов.ОчиститьКэшВспомогательныхДанных";
	Обработчик.Комментарий = НСтр("ru='Очищает кэш вспомогательных данных бюджетирования.';uk='Очищає кеш допоміжних даних бюджетування.'");

#КонецОбласти

#Область НачальноеЗаполнение

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.ПервыйЗапуск";
	Обработчик.Комментарий = НСтр("ru='Иницализация настроек программы при первом запуске.';uk='Ініцалізація настройок програми при першому запуску.'");

#КонецОбласти


#КонецОбласти

#Область Отложенно


#КонецОбласти

КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
		ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "КомплекснаяАвтоматизация";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "BASУправлениеТорговлей";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.ПервыйЗапуск";
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	Если ПредыдущееИмяКонфигурации = "BASУправлениеТорговлей" Тогда	
		Параметры.ОчиститьСведенияОПредыдущейКонфигурации = Ложь;
		Параметры.ВерсияКонфигурации = "0.0.0.0";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереименованныеОбъектыМетаданных

// Заполняет переименования объектов метаданных (подсистемы и роли).
//
// Подробнее: см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	//ОписаниеПодсистемы = Новый Структура("Имя, Версия");
	//ПриДобавленииПодсистемы(ОписаниеПодсистемы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполненияПустойИБ

// Обработчик первого запуска КА.
//
Процедура ПервыйЗапуск() Экспорт
	
	ЗаполнитьКонстантуИспользоватьБюджетирование();
	ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ЗаполнитьПредопределенныеАналитикиСтатейБюджетов();
	УправлениеДоступомКА.УстановитьРодителяПрофилейДоступаЗарплатаИКадры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеНовыхВерсийИБ

// Обработчик первого запуска КА.
// Включает константу "ИспользоватьБюджетирование".
//
Процедура ЗаполнитьКонстантуИспользоватьБюджетирование() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьБюджетирование.Установить(Истина);
	Константы.ИнтерфейсВерсии82.Установить(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
