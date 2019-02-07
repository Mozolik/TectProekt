﻿
#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Блок функций первоначального заполнения и обновления ИБ.

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
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.0.0.0";
	Обработчик.Процедура = "УчетХозрасчетныхОрганизаций.УстановитьНастройкиУчетХозрасчетныхОрганизаций";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.0.0.0";
	Обработчик.Процедура = "УчетХозрасчетныхОрганизаций.УстановитьНастройкиИспользоватьСтатьиРасходов";
	Обработчик.НачальноеЗаполнение = Истина;
	
КонецПроцедуры

#Область НачальнаяНастройкаПрограммы

Процедура ЗаписатьНастройкиНачальнаяНастройкаПрограммы(Параметры) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПараметрыПрограммы.ИспользоватьСтатьиФинансирования Тогда
		ПервоначальноеЗаполнениеОбъектовАналитики();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область НастройкаРасчетаЗарплаты

Процедура ЗаписатьНастройкиНастройкаПрограммы(Параметры) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПараметрыНастроек.ИспользоватьСтатьиФинансирования Тогда
		Константы.ИспользоватьСтатьиФинансированияЗарплата.Установить(Параметры.ИспользоватьСтатьиФинансирования);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

Процедура УстановитьНастройкиИспользоватьСтатьиРасходов() Экспорт

	ИспользоватьСтатьиРасходов = Константы.ИспользоватьСтатьиРасходовЗарплата.Получить();
	Если ИспользоватьСтатьиРасходов Тогда
		Константы.ИспользоватьСтатьиРасходовЗарплата.Установить(Ложь);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьНастройкиУчетХозрасчетныхОрганизаций() Экспорт
	
	РаботаВХозрасчетнойОрганизации = Константы.РаботаВХозрасчетнойОрганизации.Получить();
	Если Не РаботаВХозрасчетнойОрганизации Тогда
		Константы.РаботаВХозрасчетнойОрганизации.Установить(Истина);
	КонецЕсли;
	
	РаботаВБюджетномУчреждении = Константы.РаботаВБюджетномУчреждении.Получить();
	Если РаботаВБюджетномУчреждении Тогда
		Константы.РаботаВБюджетномУчреждении.Установить(Ложь);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеСтатьиБюджетноеФинансирование()
	
	Возврат Новый Структура("Код, Наименование",  НСтр("ru='БФ';uk='БФ'"),  НСтр("ru='Бюджетное финансирование';uk='Бюджетне фінансування'"));
	
КонецФункции

Функция СоздатьСтатьюФинансированияПоОписанию(ОписаниеСтатьи)

	СправочникСтатьиФинансирования = Справочники.СтатьиФинансированияЗарплата;
	СтатьяФинансирования = СправочникСтатьиФинансирования.НайтиПоНаименованию(ОписаниеСтатьи.Наименование, Истина);
	Если СтатьяФинансирования.Пустая() Тогда
		
		НовыйЭлемент = СправочникСтатьиФинансирования.СоздатьЭлемент();
		НовыйЭлемент.Наименование = ОписаниеСтатьи.Наименование;
		НовыйЭлемент.Код = ОписаниеСтатьи.Код;
		НовыйЭлемент.Записать();
		СтатьяФинансирования = НовыйЭлемент.Ссылка;
		
	Иначе
		
		СтатьяФинансированияОбъект = СтатьяФинансирования.ПолучитьОбъект();
		Если Не ЗначениеЗаполнено(СтатьяФинансированияОбъект.Код) Тогда
			СтатьяФинансированияОбъект.Код = ОписаниеСтатьи.Код;
			СтатьяФинансированияОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтатьяФинансирования;

КонецФункции

Функция ОписаниеСтатьиПредпринимательскаяДеятельность()

	Возврат Новый Структура("Код, Наименование",  НСтр("ru='ПД';uk='ПД'"),  НСтр("ru='Предпринимательская деятельность';uk='Підприємницька діяльність'"));

КонецФункции

Функция НаименованиеОсновногоСпособаОтражения()

	Возврат НСтр("ru='26. Общехозяйственные расходы';uk='26. Загальногосподарські витрати'");

КонецФункции

Функция СоздатьСпособОтраженияПоНаименованию(НаименованиеСпособаОтражения)

	СправочникиСпособыОтраженияЗарплатыВБухУчете = Справочники.СпособыОтраженияЗарплатыВБухУчете;
	СпособОтражения = СправочникиСпособыОтраженияЗарплатыВБухУчете.НайтиПоНаименованию(НаименованиеСпособаОтражения, Истина);
	Если СпособОтражения.Пустая() Тогда
		
		НовыйЭлемент = СправочникиСпособыОтраженияЗарплатыВБухУчете.СоздатьЭлемент();
		НовыйЭлемент.Наименование = НаименованиеСпособаОтражения;
		НовыйЭлемент.Записать();
		СпособОтражения = НовыйЭлемент.Ссылка;
		
	КонецЕсли;
	
	Возврат СпособОтражения;

КонецФункции

Процедура ПервоначальноеЗаполнениеОбъектовАналитики() Экспорт
	
	СоздатьСтатьюФинансированияПоОписанию(ОписаниеСтатьиБюджетноеФинансирование());
	СоздатьСтатьюФинансированияПоОписанию(ОписаниеСтатьиПредпринимательскаяДеятельность());
	СоздатьСпособОтраженияПоНаименованию(НаименованиеОсновногоСпособаОтражения());

КонецПроцедуры

Функция БухучетОрганизацииПоУмолчанию() Экспорт

	Настройки = РегистрыСведений.БухучетЗарплатыОрганизаций.СоздатьМенеджерЗаписи();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		ОписаниеСтатьи = ОписаниеСтатьиПредпринимательскаяДеятельность();
		СтатьяФинансирования = Справочники.СтатьиФинансированияЗарплата.НайтиПоНаименованию(ОписаниеСтатьи.Наименование, Истина);
		Если СтатьяФинансирования.Пустая() Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	БухучетЗарплатыОрганизаций.СтатьяФинансирования
			|ИЗ
			|	РегистрСведений.БухучетЗарплатыОрганизаций КАК БухучетЗарплатыОрганизаций
			|ГДЕ
			|	БухучетЗарплатыОрганизаций.СтатьяФинансирования <> ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка)";
			
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				СтатьяФинансирования = СоздатьСтатьюФинансированияПоОписанию(ОписаниеСтатьи);
			Иначе
				Выборка = Результат.Выбрать();
				СтатьяФинансирования = Выборка.СтатьяФинансирования;
			КонецЕсли;	
			
		КонецЕсли;
		
		Настройки.СтатьяФинансирования = СтатьяФинансирования;
		
	КонецЕсли;	
	
	НаименованиеСпособаОтражения = НаименованиеОсновногоСпособаОтражения();
	СпособОтражения = Справочники.СпособыОтраженияЗарплатыВБухУчете.НайтиПоНаименованию(НаименованиеСпособаОтражения, Истина);
	Если СпособОтражения.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БухучетЗарплатыОрганизаций.СпособОтраженияЗарплатыВБухучете
		|ИЗ
		|	РегистрСведений.БухучетЗарплатыОрганизаций КАК БухучетЗарплатыОрганизаций
		|ГДЕ
		|	БухучетЗарплатыОрганизаций.СпособОтраженияЗарплатыВБухучете <> ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка)";
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			СпособОтражения = СоздатьСпособОтраженияПоНаименованию(НаименованиеСпособаОтражения);
		Иначе
			Выборка = Результат.Выбрать();
			СпособОтражения = Выборка.СпособОтраженияЗарплатыВБухучете;
		КонецЕсли;	
		
	КонецЕсли;
	
	Настройки.СпособОтраженияЗарплатыВБухучете = СпособОтражения;
	Настройки.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц();
	
	Возврат Настройки;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределение методов Общего модуля ОбновлениеКонфигурацииПереопределяемый.

// Определяет короткое имя (идентификатор) конфигурации.
//
// Параметры:
//	КраткоеИмя - Строка- короткое имя конфигурации.
//
Процедура ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя) Экспорт
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		КраткоеИмя = "HRMBase";
	Иначе
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
			КраткоеИмя = "HRMCorp";
		Иначе
			КраткоеИмя = "HRM";	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределение методов Общего модуля РегламентированнаяОтчетностьПереопределяемый.

// Функция возвращает идентификатор конфигурации.
// Длина идентификатора не должна превышать 8 символов.
//
// Пример:
//  Возврат "БПКОРП";
//
Функция ИДКонфигурации() Экспорт
	
	Возврат "ЗУП";
	
КонецФункции

#КонецОбласти
