﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описания всех библиотек конфигурации, включая
// описание самой конфигурации.
//
Функция ОписанияПодсистем() Экспорт
	
	МодулиПодсистем = Новый Массив;
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБСП");
	
	ПодсистемыКонфигурацииПереопределяемый.ПриДобавленииПодсистем(МодулиПодсистем);
	
	ОписаниеКонфигурацииНайдено = Ложь;
	ОписанияПодсистем = Новый Структура;
	ОписанияПодсистем.Вставить("Порядок",  Новый Массив);
	ОписанияПодсистем.Вставить("ПоИменам", Новый Соответствие);
	
	ВсеТребуемыеПодсистемы = Новый Соответствие;
	
	Для каждого ИмяМодуля Из МодулиПодсистем Цикл
		
		Описание = НовоеОписаниеПодсистемы();
		Модуль = ОбщегоНазначения.ОбщийМодуль(ИмяМодуля);
		Модуль.ПриДобавленииПодсистемы(Описание);
		
		Если Описание.Имя = "СтандартныеПодсистемы" Тогда
			// <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
			Описание.ДобавлятьСлужебныеСобытия            = Истина;
			Описание.ДобавлятьОбработчикиСлужебныхСобытий = Истина;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.Проверить(ОписанияПодсистем.ПоИменам.Получить(Описание.Имя) = Неопределено,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при подготовке описаний подсистем:
                           |в описании подсистемы (см. процедуру %1.ПриДобавленииПодсистемы)
                           |указано имя подсистемы ""%2"", которое уже зарегистрировано ранее.'
                           |;uk='Помилка при підготовці описів підсистем:
                           |в описі підсистеми (див. процедуру %1.ПриДобавленииПодсистемы)
                           |зазначено ім''я підсистеми ""%2"", що уже зареєстровано раніше.'"),
				ИмяМодуля, Описание.Имя));
		
		Если Описание.Имя = Метаданные.Имя Тогда
			ОписаниеКонфигурацииНайдено = Истина;
			Описание.Вставить("ЭтоКонфигурация", Истина);
		Иначе
			Описание.Вставить("ЭтоКонфигурация", Ложь);
		КонецЕсли;
		
		Описание.Вставить("ОсновнойСерверныйМодуль", ИмяМодуля);
		
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		// Настройка порядка подсистем с учетом порядка добавления основных модулей.
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
		// Сборка всех требуемых подсистем.
		Для каждого ТребуемаяПодсистема Из Описание.ТребуемыеПодсистемы Цикл
			Если ВсеТребуемыеПодсистемы.Получить(ТребуемаяПодсистема) = Неопределено Тогда
				ВсеТребуемыеПодсистемы.Вставить(ТребуемаяПодсистема, Новый Массив);
			КонецЕсли;
			ВсеТребуемыеПодсистемы[ТребуемаяПодсистема].Добавить(Описание.Имя);
		КонецЦикла;
	КонецЦикла;
	
	// Проверка описания основной конфигурации.
	Если ОписаниеКонфигурацииНайдено Тогда
		Описание = ОписанияПодсистем.ПоИменам[Метаданные.Имя];
		
		ОбщегоНазначенияКлиентСервер.Проверить(Описание.Версия = Метаданные.Версия,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при подготовке описаний подсистем:
                           |версия ""%2"" конфигурации ""%1"" (см. процедуру %3.ПриДобавленииПодсистемы)
                           |не совпадает с версией конфигурации в метаданных ""%4"".'
                           |;uk='Помилка при підготовці описів підсистем:
                           |версія ""%2"" конфігурації ""%1"" (див. процедуру %3.ПриДобавленииПодсистемы)
                           |не збігається з версією конфігурації в метаданих ""%4"".'"),
				Описание.Имя,
				Описание.Версия,
				Описание.ОсновнойСерверныйМодуль,
				Метаданные.Версия));
	Иначе
		Описание = НовоеОписаниеПодсистемы();
		Описание.Вставить("Имя",    Метаданные.Имя);
		Описание.Вставить("Версия", Метаданные.Версия);
		Описание.Вставить("ЭтоКонфигурация", Истина);
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
	КонецЕсли;
	
	// Проверка наличия всех требуемых подсистем.
	Для каждого КлючИЗначение Из ВсеТребуемыеПодсистемы Цикл
		Если ОписанияПодсистем.ПоИменам.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			ЗависимыеПодсистемы = "";
			Для каждого ЗависимаяПодсистема Из КлючИЗначение.Значение Цикл
				ЗависимыеПодсистемы = Символы.ПС + ЗависимаяПодсистема;
			КонецЦикла;
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при подготовке описаний подсистем:
                           |не найдена подсистема ""%1"" требуемая для подсистем: %2.'
                           |;uk='Помилка при підготовці описів підсистем:
                           |не знайдена підсистема ""%1"" необхідна для підсистем: %2.'"),
				КлючИЗначение.Ключ,
				ЗависимыеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
	// Настройка порядка подсистем с учетом зависимостей.
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		Имя = КлючИЗначение.Ключ;
		Порядок = ОписанияПодсистем.Порядок.Найти(Имя);
		Для каждого ТребуемаяПодсистема Из КлючИЗначение.Значение.ТребуемыеПодсистемы Цикл
			ПорядокТребуемойПодсистемы = ОписанияПодсистем.Порядок.Найти(ТребуемаяПодсистема);
			Если Порядок < ПорядокТребуемойПодсистемы Тогда
				Взаимозависимость = ОписанияПодсистем.ПоИменам[ТребуемаяПодсистема
					].ТребуемыеПодсистемы.Найти(Имя) <> Неопределено;
				Если Взаимозависимость Тогда
					НовыйПорядок = ПорядокТребуемойПодсистемы;
				Иначе
					НовыйПорядок = ПорядокТребуемойПодсистемы + 1;
				КонецЕсли;
				Если Порядок <> НовыйПорядок Тогда
					ОписанияПодсистем.Порядок.Вставить(НовыйПорядок, Имя);
					ОписанияПодсистем.Порядок.Удалить(Порядок);
					Порядок = НовыйПорядок - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// Смещение описания конфигурации в конец массива.
	Индекс = ОписанияПодсистем.Порядок.Найти(Метаданные.Имя);
	Если ОписанияПодсистем.Порядок.Количество() > Индекс + 1 Тогда
		ОписанияПодсистем.Порядок.Удалить(Индекс);
		ОписанияПодсистем.Порядок.Добавить(Метаданные.Имя);
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		
		КлючИЗначение.Значение.ТребуемыеПодсистемы =
			Новый ФиксированныйМассив(КлючИЗначение.Значение.ТребуемыеПодсистемы);
		
		ОписанияПодсистем.ПоИменам[КлючИЗначение.Ключ] =
			Новый ФиксированнаяСтруктура(КлючИЗначение.Значение);
	КонецЦикла;
	
	ОписанияПодсистем.Порядок  = Новый ФиксированныйМассив(ОписанияПодсистем.Порядок);
	ОписанияПодсистем.ПоИменам = Новый ФиксированноеСоответствие(ОписанияПодсистем.ПоИменам);
	
	Возврат Новый ФиксированнаяСтруктура(ОписанияПодсистем);
	
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
//
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
Функция ПривилегированныйРежимУстановленПриЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
		"ПривилегированныйРежимУстановленПриЗапуске") = Истина;
	
КонецФункции

// Возвращает соответствие имен предопределенных значений ссылкам на них.
//
// Параметры:
//  ПолноеИмяОбъектаМетаданных - Строка, например, "Справочник.ВидыНоменклатуры",
//                               Поддерживаются только таблицы
//                               с предопределенными элементами:
//                               - Справочники,
//                               - Планы видов характеристик,
//                               - Планы счетов,
//                               - Планы видов расчета.
// 
// Возвращаемое значение:
//  Соответствие, где
//   Ключ     - Строка - имя предопределенного,
//   Значение - Ссылка предопределенного.
//
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка КАК Ссылка,
	|	ТекущаяТаблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Предопределенный = ИСТИНА";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", ПолноеИмяОбъектаМетаданных);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПредопределенныеЗначения = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ИмяПредопределенного = Выборка.ИмяПредопределенныхДанных;
		ПредопределенныеЗначения.Вставить(ИмяПредопределенного, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ПредопределенныеЗначения;
	
КонецФункции

// Возвращает признак использования в информационной базе полного РИБ (без фильтров).
// Проверка выполняется по более точному алгоритму, если используется подсистема "Обмен данными".
//
// Параметры:
//  ФильтрПоНазначению - Строка - Уточняет, наличие какого РИБ проверяется.
//                        Допустимые значения:
//                        - Пустая строка - любого РИБ
//                        - "СФильтром" - РИБ с фильтром
//                        - "Полный" - РИБ без фильтров.
// 
// Возвращаемое значение: Булево.
//
Функция ИспользуетсяРИБ(ФильтрПоНазначению = "") Экспорт
	
	Если УзлыРИБ(ФильтрПоНазначению).Количество() > 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает список используемых в информационной базе узлов РИБ (без фильтров).
// Проверка выполняется по более точному алгоритму, если используется подсистема "Обмен данными".
//
// Параметры:
//  ФильтрПоНазначению - Строка - Задает назначение узлов планов обмена РИБ, которые необходимо вернуть.
//                        Допустимые значения:
//                        - Пустая строка - будут возвращены все узлы РИБ
//                        - "СФильтром" - будут возвращены узлы РИБ с фильтром
//                        - "Полный" - будут возвращены узлы РИБ без фильтров.
// 
// Возвращаемое значение: СписокЗначений.
//
Функция УзлыРИБ(ФильтрПоНазначению = "") Экспорт
	
	ФильтрПоНазначению = ВРег(ФильтрПоНазначению);
	
	СписокУзлов = Новый СписокЗначений;
	
	ПланыОбменаРИБ = ПланыОбменаРИБ();
	Запрос = Новый Запрос();
	Для Каждого ИмяПланаОбмена Из ПланыОбменаРИБ Цикл
		
		Если ЗначениеЗаполнено(ФильтрПоНазначению)
			И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
			
			ОбщийМодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
			НазначениеРИБ = ВРег(ОбщийМодульОбменДаннымиСервер.НазначениеПланаОбмена(ИмяПланаОбмена));
			
			Если ФильтрПоНазначению = "СФИЛЬТРОМ" И НазначениеРИБ <> "РИБСФИЛЬТРОМ"
				Или ФильтрПоНазначению = "ПОЛНЫЙ" И НазначениеРИБ <> "РИБ" Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланОбмена.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.[ИмяПланаОбмена] КАК ПланОбмена
		|ГДЕ
		|	НЕ ПланОбмена.ЭтотУзел
		|	И НЕ ПланОбмена.ПометкаУдаления";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ИмяПланаОбмена]", ИмяПланаОбмена);
		ВыборкаУзлов = Запрос.Выполнить().Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			СписокУзлов.Добавить(ВыборкаУзлов.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат СписокУзлов;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Использование идентификаторов объектов метаданных конфигурации и расширений.

// Только для внутреннего использования.
Функция ОтключитьИдентификаторыОбъектовМетаданных() Экспорт
	
	ОбщиеПараметры = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности();
	
	Если НЕ ОбщиеПараметры.ОтключитьИдентификаторыОбъектовМетаданных Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		
		ВызватьИсключение
			НСтр("ru='Невозможно отключить справочник Идентификаторы объектов метаданных,
                       |если используется любая из следующих подсистем:
                       |- ВариантыОтчетов,
                       |- ДополнительныеОтчетыИОбработки,
                       |- РассылкаОтчетов,
                       |- УправлениеДоступом.'
                       |;uk='Неможливо відключити довідник Ідентифікатори об''єктів метаданих,
                       |якщо використовується кожна з наступних підсистем:
                       |- ВариантыОтчетов,
                       |- ДополнительныеОтчетыИОбработки,
                       |- РассылкаОтчетов,
                       |- УправлениеДоступом.'");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Функция ИдентификаторыОбъектовМетаданныхПроверкаИспользования(ПроверитьОбновление = Ложь, ОбъектыРасширений = Ложь) Экспорт
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверкаИспользования(ОбъектыРасширений);
	
	Если ПроверитьОбновление Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ДанныеОбновлены(Истина, ОбъектыРасширений);
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции работы с обменом данными.

// Возвращает список планов обмена РИБ.
// Если конфигурация работает в модели сервиса,
// то возвращает список разделенных планов обмена РИБ.
//
Функция ПланыОбменаРИБ() Экспорт
	
	Результат = Новый Массив;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если Лев(ПланОбмена.Имя, 7) = "Удалить" Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза
				И ОбщегоНазначенияПовтИсп.ЭтоРазделенныйОбъектМетаданных(ПланОбмена.ПолноеИмя(),
					ОбщегоНазначенияПовтИсп.РазделительОсновныхДанных()) Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если Лев(ПланОбмена.Имя, 7) = "Удалить" Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Определяет режим регистрации данных на узлах плана обмена.
// 
// Параметры:
//  ПолноеИмяОбъекта - Строка - Полное имя проверяемого объекта метаданных.
//  ИмяПланаОбмена - Строка - Проверяемый план обмена.
//
// Возвращаемое значение:
//  Неопределено - объект не включен в состав плана обмена,
//  "АвторегистрацияВключена"  - объект включен в состав плана обмена, авторегистрация включена,
//  "АвторегистрацияОтключена" - объект включен в состав плана обмена, авторегистрация отключена,
//                               объекты обрабатываются при создания начального образа РИБ.
//  "ПрограммнаяРегистрация"   - объект включен в состав плана обмена, авторегистрация отключена,
//                               регистрация осуществляется программно с помощью подписок на события,
//                               объекты обрабатываются при создания начального образа РИБ.
//
Функция РежимРегистрацииДанныхДляПланаОбмена(ПолноеИмяОбъекта, ИмяПланаОбмена) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	ЭлементСоставаПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав.Найти(ОбъектМетаданных);
	Если ЭлементСоставаПланаОбмена = Неопределено Тогда
		Возврат Неопределено;
	ИначеЕсли ЭлементСоставаПланаОбмена.Авторегистрация = АвторегистрацияИзменений.Разрешить Тогда
		Возврат "АвторегистрацияВключена";
	КонецЕсли;
	
	// Анализ подписок на события для более сложных вариантов использования,
	// когда механизм платформенной авторегистрации отключен для объекта метаданных.
	Для каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		НачалоНазванияПодписки = ИмяПланаОбмена + "Зарегистрировать";
		Если ВРег(Лев(Подписка.Имя, СтрДлина(НачалоНазванияПодписки))) = ВРег(НачалоНазванияПодписки) Тогда
			Для каждого Тип Из Подписка.Источник.Типы() Цикл
				Если ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип) Тогда
					Возврат "ПрограммнаяРегистрация";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "АвторегистрацияОтключена";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Содержит сохраненные параметры, используемые подсистемой.
Функция ПараметрыПрограммныхСобытий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыСлужебныхСобытий");
	УстановитьПривилегированныйРежим(Ложь);
	
	СтандартныеПодсистемыСервер.ПроверитьОбновлениеПараметровРаботыПрограммы(
		"ПараметрыСлужебныхСобытий",
		"ОбработчикиСобытий");
	
	Если НЕ СохраненныеПараметры.Свойство("ОбработчикиСобытий") Тогда
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыСлужебныхСобытий");
	УстановитьПривилегированныйРежим(Ложь);
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("ОбработчикиСобытий") Тогда
		ПредставлениеПараметра = НСтр("ru='Обработчики событий';uk='Обробники подій'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка обновления информационной базы.
                       |Не заполнен параметр служебных событий:
                       |""%1"".'
                       |;uk='Помилка оновлення інформаційної бази.
                       |Не заповнений параметр службових подій:
                       |""%1"".'")
				+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Возвращает массив описаний обработчиков серверного события.
Функция ОбработчикиСерверногоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

// Возвращает соответствие имен "функциональных" подсистем и значения Истина.
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
Функция ИменаПодсистем() Экспорт
	
	Имена = Новый Соответствие;
	ВставитьИменаПодчиненныхПодсистем(Имена, Метаданные);
	
	Возврат Новый ФиксированноеСоответствие(Имена);
	
КонецФункции

// Только для внутреннего использования.
Функция ПараметрыРаботыПрограммы(ИмяКонстанты) Экспорт
	
	Параметры = Константы[ИмяКонстанты].Получить().Получить();
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Параметры);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для справочника ИдентификаторыОбъектовМетаданных.

// Только для внутреннего использования.
Функция ИдентификаторОбъектаМетаданныхПоПолномуИмени(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ИдентификаторОбъектаМетаданныхПоПолномуИмени(
		ПолноеИмяОбъектаМетаданных);
	
КонецФункции

// Только для внутреннего использования.
Функция ТаблицаПереименованияДляТекущейВерсии() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ТаблицаПереименованияДляТекущейВерсии();
	
КонецФункции

// Только для внутреннего использования.
Функция СвойстваКоллекцийОбъектовМетаданных(ОбъектыРасширений = Ложь) Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.СвойстваКоллекцийОбъектовМетаданных(ОбъектыРасширений);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными.

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	ИмяПредопределенного = ВРег(ПолноеИмяПредопределенного);
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяКоллекции = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяТаблицы = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1 Ссылка ИЗ &ПолноеИмяТаблицы ГДЕ ИмяПредопределенныхДанных = &ИмяПредопределенного";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолноеИмяТаблицы", ИмяКоллекции + "." + ИмяТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИмяПредопределенного", ИмяПредопределенного);

	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НовоеОписаниеПодсистемы()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя",    "");
	Описание.Вставить("Версия", "");
	Описание.Вставить("ТребуемыеПодсистемы", Новый Массив);
	
	// Свойство устанавливается автоматически.
	Описание.Вставить("ЭтоКонфигурация", Ложь);
	
	// Имя основного модуля библиотеки.
	// Может быть пустым для конфигурации.
	Описание.Вставить("ОсновнойСерверныйМодуль", "");
	
	// Режим выполнения отложенных обработчиков обновления.
	// По умолчанию Последовательно.
	Описание.Вставить("РежимВыполненияОтложенныхОбработчиков", "Последовательно");
	Описание.Вставить("ОбновлятьПараллельноСПодсистемами", Новый Массив);
	
	//  <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
	
	Описание.Вставить("ДобавлятьСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСобытий", Ложь);
	
	//  ДобавлятьСлужебныеСобытия - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия)
	//                         из основного модуля библиотеки.
	// 
	//  ДобавлятьОбработчикиСлужебныхСобытий - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики)
	//                         из основного модуля библиотеки.
	
	Описание.Вставить("ДобавлятьСлужебныеСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСлужебныхСобытий", Ложь);
	
	Возврат Описание;
	
КонецФункции

Процедура ВставитьИменаПодчиненныхПодсистем(Имена, РодительскаяПодсистема, Все = Ложь, ИмяРодительскойПодсистемы = "")
	
	Для каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Если ТекущаяПодсистема.ВключатьВКомандныйИнтерфейс И Не Все Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТекущейПодсистемы = ИмяРодительскойПодсистемы + ТекущаяПодсистема.Имя;
		Имена.Вставить(ИмяТекущейПодсистемы, Истина);
		
		Если ТекущаяПодсистема.Подсистемы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВставитьИменаПодчиненныхПодсистем(Имена, ТекущаяПодсистема, Все, ИмяТекущейПодсистемы + ".");
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыПовтИсп.ПараметрыПрограммныхСобытий().ОбработчикиСобытий.НаСервере;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не найдено серверное служебное событие ""%1"".';uk='Не знайдене серверна службова подія ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не найдено серверное событие ""%1"".';uk='Не знайдене серверна подія ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначения.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначения.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

#КонецОбласти
