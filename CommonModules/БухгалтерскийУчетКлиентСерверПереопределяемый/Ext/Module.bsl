﻿
///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ТИПОВ

// Функция описание типа договора
//
Функция ПолучитьОписаниеТиповДоговора() Экспорт
	
	Возврат Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	
КонецФункции

// Функция возвращает описание типа банковского счета организации
//
Функция ТипЗначенияБанковскогоСчетаОрганизации() Экспорт
	
	Возврат Тип("СправочникСсылка.БанковскиеСчетаОрганизаций");

КонецФункции

// Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации ОписаниеТипов
// для банковских счетов организаций.
//
Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчетаОрганизаций");	

КонецФункции // ПолучитьОписаниеТиповБанковскогоСчетаОрганизации()

// Функция ПолучитьОписаниеТиповНоменклатурнойГруппы возвращает 
// тип для номенклатурной группы.
//
Функция ПолучитьОписаниеТиповНоменклатурнойГруппы() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.ГруппыФинансовогоУчетаНоменклатуры");

КонецФункции

// Функция ОписаниеТиповПодразделения возвращает 
// описание типов для справочника подразделений.
//
Функция ОписаниеТиповПодразделения() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");

КонецФункции

// Функция возвращает тип для справочника подразделений.
//
Функция ТипПодразделения() Экспорт
	
	Возврат Тип("СправочникСсылка.СтруктураПредприятия");

КонецФункции

//++ НЕ УТ
// Функция возвращает тип для справочника основные средства
Функция ТипОсновныеСредства() Экспорт

	Возврат Тип("СправочникСсылка.ОбъектыЭксплуатации");

КонецФункции
//-- НЕ УТ

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ХАРАКТЕРА ОПЕРАЦИИ ПО ТИПУ РЕГИСТРАТОРОВ

// Функция проверяет, является ли переданный по ссылке документ документом возврата товаров.
//
Функция ДокументЯвляетсяВозвратом(СсылкаНаДокумент) Экспорт
	
	ТипДокумента = ТипЗнч(СсылкаНаДокумент);
	
	Возврат ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровПоставщику");
	
КонецФункции // ДокументЯвляетсяВозвратом()

// Функция проверяет, является ли переданный по ссылке документ документом реализации отгруженных товаров.
//
Функция ДокументЯвляетсяРеализациейОтгруженныхТоваров(СсылкаНаДокумент) Экспорт

	Возврат Ложь;	
	
КонецФункции // ДокументЯвляетсяРеализациейОтгруженныхТоваров()

// Функция ДокументЯвляетсяРеализацией возвращает Истина, если переданный по ссылке документ
// является документом реализации (товаров, услуг, ОС, НМА)
//
Функция ДокументЯвляетсяРеализацией(СсылкаНаДокумент) Экспорт

	ТипДокумента = ТипЗнч(СсылкаНаДокумент);
	
	Возврат ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями");

КонецФункции // ДокументЯвляетсяРеализацией()

// Функция ДокументЯвляетсяКорректировкойРеализации возвращает Истина, если переданный по ссылке документ
// является документом корректировки реализации.
//
Функция ДокументЯвляетсяКорректировкойРеализации(СсылкаНаДокумент) Экспорт

	ТипДокумента = ТипЗнч(СсылкаНаДокумент);
	
	Возврат ТипДокумента = Тип("ДокументСсылка.КорректировкаРеализации");

КонецФункции // ДокументЯвляетсяКорректировкойРеализации()

// Функция ДокументЯвляетсяКорректировкойПоступления возвращает Истина, если переданный по ссылке документ
// является документом корректировки поступления.
//
Функция ДокументЯвляетсяКорректировкойПоступления(СсылкаНаДокумент) Экспорт

	ТипДокумента = ТипЗнч(СсылкаНаДокумент);
	
	Возврат ТипДокумента = Тип("ДокументСсылка.КорректировкаПоступления");

КонецФункции // ДокументЯвляетсяКорректировкойПоступления()

//++ НЕ УТ
// Функция ЭтоРегламентнаяОперация возвращает Истина, если переданный по ссылке документ
// является документом регламентной операции.
//
Функция ЭтоРегламентнаяОперация(СсылкаНаДокумент) Экспорт
	
	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.РегламентнаяОперация");
	
КонецФункции // ЭтоРегламентнаяОперация()
//-- НЕ УТ

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ИМЕН РЕКВИЗИТОВ

// Функция ПолучитьИмяРеквизитаКонтрагентДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, в котором храниться ссылка на контрагента-владельца.
//
Функция ПолучитьИмяРеквизитаКонтрагентДоговора() Экспорт

	Возврат "Контрагент";

КонецФункции

// Функция ПолучитьИмяРеквизитаВидДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, по которому определяется вид договора.
//
Функция ПолучитьИмяРеквизитаВидДоговора() Экспорт

	Возврат "ХозяйственнаяОперация";

КонецФункции

// Функция ПолучитьИмяРеквизитаНоменклатурнаяГруппаНоменклатуры возвращает 
// имя реквизита НоменклатурнаяГруппа в справочнике Номенклатура
//
Функция ПолучитьИмяРеквизитаНоменклатурнаяГруппаНоменклатуры() Экспорт

	Возврат "ГруппаФинансовогоУчета";

КонецФункции

Функция ПолучитьИмяСправочникаНоменклатурныеГруппы() Экспорт

	Возврат "ГруппыФинансовогоУчетаНоменклатуры";

КонецФункции

// Функция возвращает строку с именем реквизита в справочнике подразделений,
// определяющего владельца подразделения, либо пустую строку, если справочник 
// подразделений не является подчиненным справочником.
//
Функция ИмяРеквизитаОрганизацияПодразделения() Экспорт
	
	Возврат "";

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ СООБЩЕНИЙ

// Функция возвращает строку с навигационной ссылкой для открытия учетной политики организации.
//
Функция ПолучитьНавигационнуюСсылкуНаУчетнуюПолитикуОрганизации() Экспорт

	Возврат "";

КонецФункции // ПолучитьНавигационнуюСсылкуНаУчетнуюПолитикуОрганизации()

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОБЕСПЕЧЕНИЯ РАБОТЫ ФОРМ ДОКУМЕНТОВ С ИМУЩЕСТВОМ В ЭКСПЛУАТАЦИИ

// Функция возвращает расшифровку срока полезного использования в годах и 
// месяцах.
//
// Параметры:
//  СрокПолезногоИспользования - срок полезного использования (в месяцах),
//                 подлежащий расшифровке
//
// Возвращаемое значение:
//  Строка       - расшифровка срока полезного использования в годах и 
//                 месяцах
//
Функция РасшифровкаСрокаПолезногоИспользования(СрокПолезногоИспользования) Экспорт
	
	РасшифровкаСрокаПолезногоИспользования = "";
	
	Если ЗначениеЗаполнено(СрокПолезногоИспользования) Тогда
	
		ЧислоЛет     = Цел(СрокПолезногоИспользования / 12);
		ЧислоМесяцев = (СрокПолезногоИспользования % 12);
		
		Если НЕ (ЧислоЛет = 0) Тогда
			
			// Построим строку с числом лет
			Если (СтрДлина(ЧислоЛет) > 1) И (Число(Сред(ЧислоЛет, СтрДлина(ЧислоЛет) - 1, 1)) = 1) Тогда
				СтрокаГод = " лет";
			ИначеЕсли Число(Прав(ЧислоЛет, 1)) = 1 Тогда
				СтрокаГод = " год";
			ИначеЕсли (Число(Прав(ЧислоЛет, 1)) > 1) И (Число(Прав(ЧислоЛет, 1)) < 5) Тогда
				СтрокаГод = " года";
			Иначе
				СтрокаГод = " лет";
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + Строка(ЧислоЛет) + СтрокаГод;
			
		КонецЕсли;
		
		Если НЕ (ЧислоМесяцев = 0) Тогда
			
			// Построим строку с числом месяцев
			Если (СтрДлина(ЧислоМесяцев) > 1) И (Число(Сред(ЧислоМесяцев, СтрДлина(ЧислоМесяцев) - 1, 1)) = 1) Тогда
				СтрокаМесяц = " месяцев";
			ИначеЕсли Число(Прав(ЧислоМесяцев, 1)) = 1 Тогда
				СтрокаМесяц = " месяц";
			ИначеЕсли (Число(Прав(ЧислоМесяцев, 1)) > 1) И (Число(Прав(ЧислоМесяцев, 1)) < 5) Тогда
				СтрокаМесяц = " месяца";
			Иначе
				СтрокаМесяц = " месяцев";
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + ?(НЕ ЗначениеЗаполнено(РасшифровкаСрокаПолезногоИспользования), "", " ") + Строка(ЧислоМесяцев) + СтрокаМесяц;
		
		КонецЕсли;
		
		РасшифровкаСрокаПолезногоИспользования = "(" + РасшифровкаСрокаПолезногоИспользования + ")";
		
	КонецЕсли;
	
	Возврат РасшифровкаСрокаПолезногоИспользования;
	
КонецФункции // РасшифровкаСрокаПолезногоИспользования()
