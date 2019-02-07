﻿////////////////////////////////////////////////////////////////////////////////
// ОБЩАЯ РЕАЛИЗАЦИЯ ОБРАБОТКИ СООБЩЕНИЙ УПРАВЛЕНИЯ ДОПОЛНИТЕЛЬНЫМИ ОТЧЕТАМИ И ОБРАБОТКАМИ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}InstallExtension
//
// Параметры:
//  ОписаниеИнсталляции - Структура, ключи:
//    Идентификатор - УникальныйИдентификатор, уникальный идентификатор ссылки
//      элемента справочника ПоставляемыеДополнительныеОтчетыИОбработки,
//    Представление - строка, представление инсталляции поставляемой дополнительной
//      обработки (будет использоваться в качестве наименования элемента справочника
//      ДополнительныеОтчетыИОбработки),
//    Инсталляция - УникальныйИдентификатор, уникальный идентификатор инсталляции
//      поставляемой дополнительной обработки (будет использоваться в качестве
//      уникального идентификатора ссылки справочника ДополнительныеОтчетыИОбработки),
//  НастройкиКоманд - ТаблицаЗначений, содержащая настройки команд для инсталляции
//      поставляемой дополнительной обработки, колонки:
//    Идентификатор - строка, идентификатор команды,
//    БыстрыйДоступ - Массив(УникальныйИдентификатор), массив уникальный идентификаторов,
//      определяющих пользователей сервиса, которым команда должна быть включена в
//      быстрый доступ,
//    Расписание - РасписаниеРегламентногоЗадания, расписание для задания команды
//      дополнительной обработки (если для команды включено выполнение в качестве
//      регламентного задания),
//  Разделы - ТаблицаЗначений, содержащая настройки включения команд для инсталляции
//      поставляемой дополнительной обработки в разделы командного интерфейса, колонки:
//    Раздел - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//  СправочникиИДокументы - ТаблицаЗначений, содержащая настройки включения команд для инсталляции
//      поставляемой дополнительной обработки в интерфейс форм список и элементов, колонки:
//    ОбъектНазначения - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//  ВариантыДополнительногоОтчета - Массив(Строка), массив, содержащий ключи вариантов отчетов
//    дополнительного отчета,
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор, определяющий пользователя
//    сервиса, который инициировал инсталляцию поставляемой дополнительной обработки.
//
Процедура УстановитьДополнительныйОтчетИлиОбработку(Знач ОписаниеИнсталляции,
		Знач НастройкиКоманд, Знач НастройкиРасположенияКоманд, Знач Разделы, Знач СправочникиИДокументы, Знач ВариантыДополнительногоОтчета,
		Знач ИдентификаторПользователяСервиса) Экспорт
	
	// Настройки заполняются по данным из сообщения
	БыстрыйДоступ = Новый ТаблицаЗначений();
	БыстрыйДоступ.Колонки.Добавить("ИдентификаторКоманды", Новый ОписаниеТипов("Строка"));
	БыстрыйДоступ.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	Задания = Новый ТаблицаЗначений();
	Задания.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Задания.Колонки.Добавить("РегламентноеЗаданиеРасписание", Новый ОписаниеТипов("СписокЗначений"));
	Задания.Колонки.Добавить("РегламентноеЗаданиеИспользование", Новый ОписаниеТипов("Булево"));
	
	Для Каждого НастройкаКоманды Из НастройкиКоманд Цикл
		
		Если ЗначениеЗаполнено(НастройкаКоманды.БыстрыйДоступ) Тогда
			
			Для Каждого ИдентификаторПользователя Из НастройкаКоманды.БыстрыйДоступ Цикл
				
				ТекстЗапроса = "ВЫБРАТЬ
				               |	Пользователи.Ссылка
				               |ИЗ
				               |	Справочник.Пользователи КАК Пользователи
				               |ГДЕ
				               |	Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса";
				Запрос = Новый Запрос(ТекстЗапроса);
				Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ИдентификаторПользователя);
				Результат = Запрос.Выполнить();
				Если Результат.Пустой() Тогда
					
					Продолжить;
					
				Иначе
					
					Выборка = Результат.Выбрать();
					Выборка.Следующий();
					ЭлементБыстрогоДоступа = БыстрыйДоступ.Добавить();
					ЭлементБыстрогоДоступа.ИдентификаторКоманды = НастройкаКоманды.Идентификатор;
					ЭлементБыстрогоДоступа.Пользователь = Выборка.Ссылка;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если НастройкаКоманды.Расписание <> Неопределено Тогда
			
			Задание = Задания.Добавить();
			Задание.Идентификатор = НастройкаКоманды.Идентификатор;
			РегламентноеЗаданиеРасписание = Новый СписокЗначений();
			РегламентноеЗаданиеРасписание.Добавить(НастройкаКоманды.Расписание);
			Задание.РегламентноеЗаданиеРасписание= РегламентноеЗаданиеРасписание;
			Задание.РегламентноеЗаданиеИспользование = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеОтчетыИОбработкиВМоделиСервиса.УстановитьПоставляемуюОбработкуВОбластьДанных(
		ОписаниеИнсталляции,
		БыстрыйДоступ,
		Задания,
		Разделы,
		СправочникиИДокументы,
		НастройкиРасположенияКоманд,
		ВариантыДополнительногоОтчета,
		ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(
			ИдентификаторПользователяСервиса));
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DeleteExtension
//
// Параметры:
//  ИдентификаторПоставляемойОбработки - УникальныйИдентификатор, ссылка на элемент
//    справочника ПоставляемыеДополнительныеОтчетыИОбработки;
//  ИдентификаторИспользуемойОбработки - УникальныйИдентификатор, ссылка на элемент
//    справочника ДополнительныеОтчетыИОбработки.
//
Процедура УдалитьДополнительныйОтчетИлиОбработку(Знач ИдентификаторПоставляемойОбработки, Знач ИдентификаторИспользуемойОбработки) Экспорт
	
	ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(
			ИдентификаторПоставляемойОбработки);
	
	ДополнительныеОтчетыИОбработкиВМоделиСервиса.УдалитьПоставляемуюОбработкуИзОбластиДанных(
		ПоставляемаяОбработка,
		ИдентификаторИспользуемойОбработки);
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DisableExtension
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//    справочника ПоставляемыеДополнительныеОтчетыИОбработки,
//  ПричинаОтключения - ПеречислениеСсылка.ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса.
//
Процедура ОтключитьДополнительныйОтчетИлиОбработку(Знач ИдентификаторРасширения, Знач ПричинаОтключения = Неопределено) Экспорт
	
	Если ПричинаОтключения = Неопределено Тогда
		ПричинаОтключения = Перечисления.ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса.БлокировкаАдминистраторомСервиса;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(
		ИдентификаторРасширения);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемаяОбработка) Тогда
		
		Объект = ПоставляемаяОбработка.ПолучитьОбъект();
		
		Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
		Объект.ПричинаОтключения = ПричинаОтключения;
		
		Объект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}EnableExtension
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//  справочника ПоставляемыеДополнительныеОтчетыИОбработки
//
Процедура ВключитьДополнительныйОтчетИлиОбработку(Знач ИдентификаторРасширения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(
		ИдентификаторРасширения);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемаяОбработка) Тогда
		
		Объект = ПоставляемаяОбработка.ПолучитьОбъект();
		
		Объект.Публикация =
			Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
		
		Объект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DropExtension
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//  справочника ПоставляемыеДополнительныеОтчетыИОбработки
//
Процедура ОтозватьДополнительныйОтчетИлиОбработку(Знач ИдентификаторПоставляемойОбработки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(
		ИдентификаторПоставляемойОбработки);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемаяОбработка) Тогда
		ДополнительныеОтчетыИОбработкиВМоделиСервиса.ОтозватьПоставляемуюДополнительнуюОбработку(
			ПоставляемаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}SetExtensionSecurityProfile
//
// Параметры:
//  ИдентификаторПоставляемойОбработки - УникальныйИдентификатор, ссылка на элемент
//    справочника ПоставляемыеДополнительныеОтчетыИОбработки;
//  ИдентификаторИспользуемойОбработки - УникальныйИдентификатор, ссылка на элемент
//    справочника ДополнительныеОтчетыИОбработки.
//
Процедура УстановитьРежимПодключенияДополнительногоОтчетаИлиОбработкиВОбластиДанных(Знач ИдентификаторПоставляемойОбработки, Знач ИдентификаторИспользуемойОбработки, Знач РежимПодключения) Экспорт
	
	ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(
		ИдентификаторПоставляемойОбработки);
	
	ИспользуемаяОбработка = Справочники.ДополнительныеОтчетыИОбработки.ПолучитьСсылку(
		ИдентификаторИспользуемойОбработки);
	
	Если ОбщегоНазначения.СсылкаСуществует(ИспользуемаяОбработка) Тогда
		
		Менеджер = РегистрыСведений.РежимыПодключенияВнешнихМодулейОбластейДанных.СоздатьМенеджерЗаписи();
		Менеджер.ВнешнийМодуль = ПоставляемаяОбработка;
		Менеджер.БезопасныйРежим = РежимПодключения;
		Менеджер.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(Знач ИдентификаторПользователяСервиса)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса";
	Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ИдентификаторПользователяСервиса);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		ШаблонСообщения = НСтр("ru='Не найден пользователь с идентификатором пользователя сервиса %1';uk='Не знайдений користувач з ідентифікатором користувача сервісу %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ИдентификаторПользователяСервиса);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции
