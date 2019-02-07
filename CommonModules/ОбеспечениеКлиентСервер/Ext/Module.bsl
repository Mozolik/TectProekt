﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "ОбеспечениеКлиентСервер", содержит вспомогательные процедуры
// и функции для интерактивной работы пользователей с обеспечением потребностей
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область МеханизмыОбеспечения

//Возвращает массив значений перечисления "Варианты обеспечения", с учетом типа номенклатуры.
//
//Параметры:
// ТипНоменклатуры 				- ПеречислениеСсылка.ТипыНоменклатуры - тип номенклатуры.
// ДоступныеВариантыОбеспечения - СписокЗначений - список доступных вариантов.
//
//Возвращаемое значение:
// Массив - массив значений перечисления "Варианты обеспечения".
//
Функция ПереченьВариантовОбеспечения(ТипНоменклатуры = Неопределено, ДоступныеВариантыОбеспечения = Неопределено) Экспорт

	УдаляемыеВарианты = Новый Массив();
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада"));
		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ИзЗаказов"));
		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));

	ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Тогда

		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада"));
		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ИзЗаказов"));
		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));

		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно"));
		УдаляемыеВарианты.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно"));

	КонецЕсли;

	Если ДоступныеВариантыОбеспечения = Неопределено Тогда
		ВариантыОбеспечения = Новый СписокЗначений;
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ИзЗаказов"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));
		ВариантыОбеспечения.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется"));
	Иначе
		ВариантыОбеспечения = ДоступныеВариантыОбеспечения;
	КонецЕсли; 

	Для Каждого Элемент Из УдаляемыеВарианты Цикл

		Вариант = ВариантыОбеспечения.НайтиПоЗначению(Элемент);

		Если Вариант <> Неопределено Тогда
			ВариантыОбеспечения.Удалить(Вариант);
		КонецЕсли;

	КонецЦикла;

	Возврат ВариантыОбеспечения;

КонецФункции

Процедура ЗаполнитьЗначенияСвойствСРазличемИмен(Приемник, Источник, СоответствиеИмен) Экспорт

	ЗаполнитьЗначенияСвойств(Приемник, Источник);
	Для Каждого Свойство Из СоответствиеИмен Цикл

		Если Свойство.Ключ = "Данные" Тогда // свойство Данные - служебное, используется для заполнения полей из внешней структуры данных
			Продолжить;
		КонецЕсли;

		Приемник[Свойство.Ключ] = Источник[Свойство.Значение];

	КонецЦикла;

	// Если в результате заполнения по реквизитам табличной части Назначение осталось пустым, нужно снова взять его из реквизитов шапки.
	Если Источник.Свойство("НазначениеШапки") И 
		(Не ЗначениеЗаполнено(Приемник.Назначение)
			Или СоответствиеИмен.Получить("Назначение") = "НазначениеТовары") // Это сборка
		И ЗначениеЗаполнено(Источник.НазначениеШапки) Тогда
		Приемник.Назначение = Источник.НазначениеШапки;
	КонецЕсли;

КонецПроцедуры

Функция КлючиПотребностей(ВидПотребности) Экспорт

	Результат = Новый Структура("");

	Результат.Вставить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Результат.Вставить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));

	Если ВидПотребности = "Товар" Тогда

		Результат.Вставить("Склад",      Новый ОписаниеТипов("СправочникСсылка.Склады"));

	ИначеЕсли ВидПотребности = "ТоварОбособленный" Тогда

		Результат.Вставить("Склад",      Новый ОписаниеТипов("СправочникСсылка.Склады"));
		Результат.Вставить("Назначение", Новый ОписаниеТипов("СправочникСсылка.Назначения"));

	ИначеЕсли ВидПотребности = "Работа" Тогда

		Результат.Вставить("Подразделение",  Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
		Результат.Вставить("Назначение",     Новый ОписаниеТипов("СправочникСсылка.Назначения"));

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает параметры для открытия формы Перечисление.ВариантыОбеспечения.Форма.ИсполнениеЗаказа
//
// Параметры:
//  ИдентификаторНастройки - Строка - Идентификатор настройки, используется для сохранения выбранных вариантов обеспечения
// 
// Возвращаемое значение:
//  Структура
//
Функция ПараметрыФормыИсполнениеЗаказа(ИдентификаторНастройки) Экспорт

	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Тип", ИдентификаторНастройки);
	ПараметрыФормы.Вставить("СписокВыбора", ПереченьВариантовОбеспечения());
	
	//Направление деятельности из шапки документа (для подсказки к варианту "Обособленно").
	ПараметрыФормы.Вставить("НаправлениеДеятельности");
	
	Возврат ПараметрыФормы;

КонецФункции

#КонецОбласти

#Область СтруктурыДанных

// Возвращает структуру с номенклатурой, характеристикой и складом
//
// Возвращаемое значение:
//	Структура
//
Функция КлючНоменклатураХарактеристикаСклад() Экспорт

	Возврат Новый Структура(
		"Номенклатура,
		|Характеристика,
		|Склад");

КонецФункции

// Возвращает структуру с номенклатурой, характеристикой, складом, назначением
//
// Возвращаемое значение:
//	Структура
//
Функция КлючНоменклатураХарактеристикаСкладНазначение() Экспорт

	Возврат Новый Структура(
		"Номенклатура,
		|Характеристика,
		|Склад,
		|Назначение");

КонецФункции

// Возвращает структуру с номенклатурой, характеристикой, подразделением, назначением
//
// Возвращаемое значение:
//	Структура
//
Функция КлючНоменклатураХарактеристикаПодразделениеНазначение() Экспорт

	Возврат Новый Структура(
		"Номенклатура,
		|Характеристика,
		|Подразделение,
		|Назначение");

КонецФункции

// Возвращает структуру с номенклатурой, характеристикой, подразделением, складом, назначением
//
// Возвращаемое значение:
//	Структура
//
Функция КлючНоменклатураХарактеристикаПодразделениеНазначениеСклад() Экспорт

	Возврат Новый Структура(
		"Номенклатура,
		|Характеристика,
		|Подразделение,
		|Назначение,
		|Склад");

КонецФункции

// Возвращает структуру с номенклатурой, характеристикой
//
// Возвращаемое значение:
//	Структура
//
Функция КлючНоменклатураХарактеристика() Экспорт

	Возврат Новый Структура(
		"Номенклатура,
		|Характеристика");

КонецФункции

// Возвращает структуру действий с заказом
//
// Возвращаемое значение:
//	Структура
//
Функция ДействияСЗаказом() Экспорт
	Возврат Новый Структура("Исправить, СнятьРезервы, СнятьРезервыСоСклада, Ускорить, ЕстьОтгружатьЧастями, ОтгружатьЧастями");
КонецФункции

// Возвращает структуру варианта обеспечения
//
// Возвращаемое значение:
//	Структура
//
Функция СтруктураВариантаОбеспечения() Экспорт

	Возврат Новый Структура("ВариантОбеспечения, ДатаОтгрузки, Склад, Количество");

КонецФункции

// Возвращает структуру заполнения варианта обеспечения
//
// Возвращаемое значение:
//	Структура
//
Функция СтруктураЗаполненияВариантаОбеспечения(Объект, ДатаОтгрузки) Экспорт

	Результат = Новый Структура("Объект, ДатаОтгрузки, ИмяПоляВШапке, ИмяТипНоменклатуры", Объект, ДатаОтгрузки);

	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказКлиента") Или
		ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		Если Объект.НеОтгружатьЧастями Тогда
			Результат.Вставить("ИмяПоляВШапке", "ДатаОтгрузки");
		КонецЕсли;
		Результат.Вставить("ИмяТипНоменклатуры", "ТипНоменклатуры");

	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
		Если Объект.НеОтгружатьЧастями Тогда
			Результат.Вставить("ИмяПоляВШапке", "ДатаОтгрузки");
		КонецЕсли;
		Результат.Вставить("ИмяТипНоменклатуры", "ТипНоменклатуры");
		
	//++ НЕ УТ
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказМатериаловВПроизводство") Тогда
		Если Объект.НеОтгружатьЧастями Тогда
			Результат.Вставить("ИмяПоляВШапке", "ДатаОтгрузки");
		КонецЕсли;
		Результат.Вставить("ИмяТипНоменклатуры", "ТипНоменклатуры");
	//-- НЕ УТ
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказНаСборку") Тогда
		Результат.Вставить("ИмяПоляВШапке", "НачалоСборкиРазборки");
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СостояниеОбеспеченияЗаказов

// Создает описание типов всех заказов, которые могут обеспечиваться
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типов заказов.
//
Функция ОписаниеТиповЗаказыКОбеспечению() Экспорт

	ОписаниеТипов = Новый ОписаниеТипов(
		"ДокументСсылка.ЗаказКлиента,
		|ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента,
		|ДокументСсылка.ЗаказНаПеремещение,
		|ДокументСсылка.ЗаказНаСборку,
//++ НЕ УТ
		|ДокументСсылка.ЗаказМатериаловВПроизводство,
		|ДокументСсылка.ЗаказПереработчику,
//-- НЕ УТ
//++ НЕ УТКА
		|ДокументСсылка.ЗаказДавальца,
		|ДокументСсылка.ЗаказНаРемонт,
		|ДокументСсылка.ЗаказНаПроизводство,
//-- НЕ УТКА
		|ДокументСсылка.ЗаказНаВнутреннееПотребление");

	Возврат ОписаниеТипов;

КонецФункции

// Возвращает структуру фильтра состояния обеспечения
//
// Возвращаемое значение:
//	Структура
//
Функция ФильтрыСостоянияОбеспечения() Экспорт

	Возврат Новый Структура("Номенклатура");

КонецФункции

// Инициализирует параметры получения состояния обеспечения
//
Процедура ИнициализироватьПараметрыПолученияСостоянияОбеспечения(Параметры, ДанныеДляОбеспечения) Экспорт

	ЗаполнитьЗначенияСвойств(Параметры, ДанныеДляОбеспечения.ПараметрыОбеспечения);
	ЗаполнитьЗначенияСвойств(Параметры, ДанныеДляОбеспечения.ПараметрыОтгрузки);
	ЗаполнитьЗначенияСвойств(Параметры, ДанныеДляОбеспечения.Модификация);
	Параметры.СпособКорректировкиОбособленныхОстатков = "НеКорректировать";

КонецПроцедуры

// Инициализирует действия с заказом
//
Процедура ИнициализироватьДействияСЗаказом(ДействияСЗаказом) Экспорт
	ДействияСЗаказом.Исправить = Ложь;
	ДействияСЗаказом.СнятьРезервы = Ложь;
	ДействияСЗаказом.СнятьРезервыСоСклада = Ложь;
	ДействияСЗаказом.Ускорить = Ложь;
	ДействияСЗаказом.ОтгружатьЧастями = Ложь;
	ДействияСЗаказом.ЕстьОтгружатьЧастями = Ложь;
КонецПроцедуры

// Инициализирует фильтры состояния обеспечения
//
Процедура ИнициализироватьФильтрыСостоянияОбеспечения(Фильтры, ЕстьФильтрПоНоменклатуре) Экспорт

	Фильтры.Номенклатура = ЕстьФильтрПоНоменклатуре;

КонецПроцедуры

// Возвращает структуру параметров для передачи в форму обработки Состояние обеспечение заказов.
// 
//  Возвращаемое значение:
//   Структура - структура с полями:
//               ВызовИзФормыЗаказа          - Булево    - признак, что форма открывается из формы, содержащей список товаров.
//               РеквизитыЗаказа             - Структура - содержит ключевые реквизиты - параметры обеспечения, относящиеся ко всем товарам списка (напрмер, желаемая дата отгрузки).
//               АдресТаблицыТовары          - Строка    - адрес во временном хранилище, для передачи в форму обработки списка товаров.
//               ПараметрыВыполненияДействий - Структура - содержит параметры, необходимые для выполнения рекомендаций по обеспечению из открываемой формы обработки.
//               НастройкаЭлементовФормы     - Структура - содержит настройки отображения открываемой формы, с полями:
//                                                         Заголовок                      - Строка, Неопределено - заголовок формы.
//                                                         ТекстКомандыПеренестиВДокумент - Строка, Неопределено - заголовок команды "Перенести в документ".
//
Функция ПараметрыФормыСостояниеОбеспеченияЗаказов() Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВызовИзФормыЗаказа");
	ПараметрыФормы.Вставить("РеквизитыЗаказа");
	ПараметрыФормы.Вставить("АдресТаблицыТовары");
	ПараметрыФормы.Вставить("ПараметрыВыполненияДействий");
	
	НастройкаЭлементовФормы = Новый Структура();
	НастройкаЭлементовФормы.Вставить("Заголовок");
	НастройкаЭлементовФормы.Вставить("ТекстКомандыПеренестиВДокумент");
	
	ПараметрыФормы.Вставить("НастройкаЭлементовФормы", НастройкаЭлементовФормы);
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеОбеспечения

Функция ПроверитьЗаполнение(Объект, ТаблицаТовары, Строки, ПараметрыПроверки, ПутиКДанным = Неопределено, Склад = Неопределено) Экспорт

	Пути = "НомерСтроки,
	       |Отменено,
	       |Номенклатура, Характеристика, Склад, Подразделение, Назначение,
	       |ТипНоменклатуры, ХарактеристикиИспользуются, КлючСвязиЭтапы,
	       |Количество, КоличествоУпаковок";

	ДанныеСтроки = Новый Структура(Пути);
	Ошибки = Новый Массив();

	Хранилище = Новый Структура(Пути);

	Если ПутиКДанным = Неопределено Тогда
		ПутиКДанным = Новый Соответствие();
	КонецЕсли;

	Для Каждого Свойство Из ПутиКДанным Цикл
		Хранилище.Вставить(Свойство.Значение);
	КонецЦикла;

	ЗаполнитьЗначенияСвойств(Хранилище, Объект);

	Если ТипЗнч(Строки) = Тип("Массив") Тогда
		ИдентификаторыСтрок = Строки;
	Иначе
		ИдентификаторыСтрок = Новый Массив();
		ИдентификаторыСтрок.Добавить(Строки);
	КонецЕсли;

	Если ИдентификаторыСтрок.Количество() = 0 Тогда

		#Если Клиент Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для заполнения обеспечения необходимо выделить строки.';uk='Для заповнення забезпечення необхідно виділити рядки.'"));
		#КонецЕсли

		Возврат Ложь;

	КонецЕсли;

	СкладВТабЧасти         = ПараметрыПроверки.Поля.Свойство("Склад")
		И СтрНайти(ПараметрыПроверки.Поля["Склад"], "[") > 0;
		
	ПодразделениеВТабЧасти = ПараметрыПроверки.Поля.Свойство("Подразделение")
		И СтрНайти(ПараметрыПроверки.Поля["Подразделение"], "[") > 0;

	ЕстьОшибкиСклад         = Ложь;
	ЕстьОшибкиПодразделение = Ложь;
	
	Для Каждого Идентификатор Из ИдентификаторыСтрок Цикл

		СтрокаТовары = ТаблицаТовары.НайтиПоИдентификатору(Идентификатор);
		ЗаполнитьЗначенияСвойств(Хранилище, СтрокаТовары);

		ЗаполнитьЗначенияСвойствСРазличемИмен(ДанныеСтроки, Хранилище, ПутиКДанным);

		Если ДанныеСтроки.Отменено = Истина Тогда
			
			Если ИдентификаторыСтрок.Количество() = 1 Тогда

				#Если Клиент Тогда
				ПоказатьПредупреждение(, НСтр("ru='Для отмененной строки обеспечение и отгрузка невозможны.';uk='Для скасованого рядка забезпечення і відвантаження неможливі.'"));
				#КонецЕсли

				Возврат Ложь;

			Иначе
				Продолжить;
			КонецЕсли;

		КонецЕсли;

		Если ДанныеСтроки.Количество = 0 И ДанныеСтроки.КоличествоУпаковок = 0 Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Количество", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если ДанныеСтроки.Количество = 0 И ДанныеСтроки.КоличествоУпаковок <> 0 Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "КоличествоУпаковок", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Номенклатура", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если Не ЗначениеЗаполнено(ДанныеСтроки.Характеристика) И ДанныеСтроки.ХарактеристикиИспользуются = Истина Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Характеристика", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("Склад") И Не ЗначениеЗаполнено(Склад) И Не ЗначениеЗаполнено(ДанныеСтроки.Склад)
			И (ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар")
				Или ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара")) Тогда

			Если СкладВТабЧасти Или Не ЕстьОшибкиСклад Тогда
				Ошибка = Новый Структура("Поле, НомерСтроки", "Склад", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);
				ЕстьОшибкиСклад = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("Подразделение") И Не ЗначениеЗаполнено(ДанныеСтроки.Подразделение)
			И ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

			Если ПодразделениеВТабЧасти Или Не ЕстьОшибкиПодразделение Тогда
				Ошибка = Новый Структура("Поле, НомерСтроки", "Подразделение", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);
				ЕстьОшибкиПодразделение = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("КлючСвязиЭтапы") И Не ЗначениеЗаполнено(ДанныеСтроки.КлючСвязиЭтапы)
			И ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

				Ошибка = Новый Структура("Поле, НомерСтроки", "КлючСвязиЭтапы", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);

		КонецЕсли;

	КонецЦикла;

	ОшибкиПользователю = Неопределено;

	Для Каждого Ошибка Из Ошибки Цикл

		Поле  = СтрЗаменить(ПараметрыПроверки.Поля[Ошибка.Поле], "%1", Ошибка.НомерСтроки - 1);
		Текст = СтрЗаменить(ПараметрыПроверки.Тексты[Ошибка.Поле], "%1", Ошибка.НомерСтроки);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ОшибкиПользователю, Поле, Текст, "");

	КонецЦикла;

	#Если Клиент Тогда
	ОчиститьСообщения();
	#КонецЕсли
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиПользователю);

	Возврат Ошибки.Количество() = 0;

КонецФункции

Функция ИнициализироватьПараметрыПроверкиЗаполнения(ИмяТабличнойЧасти = Неопределено, Синоним = Неопределено) Экспорт

	Поля = Новый Структура();
	Поля.Вставить("Номенклатура",   "Объект.Товары[%1].Номенклатура");
	Поля.Вставить("Характеристика", "Объект.Товары[%1].Характеристика");
	Поля.Вставить("Склад",          "Объект.Склад");
	Поля.Вставить("Подразделение",  "Объект.Подразделение");
	Поля.Вставить("Количество",     "Объект.Товары[%1].КоличествоУпаковок");
	Поля.Вставить("КоличествоУпаковок", "Объект.Товары[%1].КоличествоУпаковок");

	Тексты = Новый Структура();
	Тексты.Вставить("Номенклатура",   НСтр("ru='Не заполнена колонка ""Номенклатура"" в строке %1 списка ""Товары""';uk='Не заповнена колонка ""Номенклатура"" в рядку %1 списку ""Товари""'"));
	Тексты.Вставить("Характеристика", НСтр("ru='Не заполнена колонка ""Характеристика"" в строке %1 списка ""Товары""';uk='Не заповнена колонка ""Характеристика"" в рядку %1 списку ""Товари""'"));
	Тексты.Вставить("Склад",          НСтр("ru='Поле ""Склад"" не заполнено';uk='Поле ""Склад"" не заповнено'"));
	Тексты.Вставить("Подразделение",  НСтр("ru='Поле ""Подразделение"" не заполнено (необходимо для обеспечения работ)';uk='Полі ""Підрозділ"" не заповнено (необхідно для забезпечення робіт)'"));
	Тексты.Вставить("Количество",     НСтр("ru='Не заполнена колонка ""Количество"" в строке %1 списка ""Товары""';uk='Не заповнена колонка ""Кількість"" в рядку %1 списку ""Товари""'"));
	Тексты.Вставить("КоличествоУпаковок", НСтр("ru='Обнаружено нулевое количество при пересчете в единицу хранения в строке %1 списка ""Товары""';uk='Виявлена нульова кількість при перерахунку на одиницю зберігання в рядку %1 списку ""Товари""'"));

	Если ИмяТабличнойЧасти <> Неопределено Тогда

		Для Каждого Поле Из Поля Цикл

			Поля[Поле.Ключ]   = СтрЗаменить(Поля[Поле.Ключ],   "Товары", ИмяТабличнойЧасти);
			Тексты[Поле.Ключ] = СтрЗаменить(Тексты[Поле.Ключ], "Товары", ?(Синоним <> Неопределено, Синоним, ИмяТабличнойЧасти));

		КонецЦикла;

	КонецЕсли;

	Возврат Новый Структура("Поля, Тексты", Поля, Тексты);

КонецФункции

//Возвращает структуру, содержащую необходимые данные для генерации сообщения об ошибках пользователю,
//используется при выборе и заполнении обеспечения.
//
//Параметры:
// ДанныеЗаполнения - Массив - массив, содержащий структуры данных аналитики каждой ошибки.
//
//Возвращаемое значение
// Структура - содержит необходимые данные для генерации сообщения об ошибках пользователю.
//
Функция ОшибкиКонтроляОтгрузкиИОбеспечения(ДанныеЗаполнения, ИмяСписка, СинонимСписка) Экспорт

	Ошибки = Неопределено;
	Для Каждого РеквизитыОшибки Из ДанныеЗаполнения Цикл

		Если РеквизитыОшибки.Регистр = "Заказы" Тогда

			ШаблонСообщенияСоСкладом = НСтр("ru='Номенклатура %НоменклатураХарактеристика%, склад %Склад%. По строке %НомерСтроки% списка ""%СинонимСписка%"" уже оформлена накладная в количестве большем, чем указано в документе, на %Количество% %Единица%';uk='Номенклатура %НоменклатураХарактеристика%, склад %Склад%. По рядку %НомерСтроки% списку ""%СинонимСписка%"" вже оформлена накладна в кількості більшій, ніж зазначено в документі, %Количество% %Единица%'");
		
			ШаблонСообщенияБезСклада = НСтр("ru='Номенклатура %НоменклатураХарактеристика%. По строке %НомерСтроки% списка ""%СинонимСписка%"" уже оформлена накладная в количестве большем, чем указано в документе, на %Количество% %Единица%';uk='Номенклатура %НоменклатураХарактеристика%. По рядку %НомерСтроки% списку ""%СинонимСписка%"" вже оформлена накладна в кількості більшій, ніж зазначено в документі, %Количество% %Единица%'");

			ШаблонСообщения = ?(ЗначениеЗаполнено(РеквизитыОшибки.Склад), ШаблонСообщенияСоСкладом, ШаблонСообщенияБезСклада);
			Поле = СтрЗаменить("Объект.ИмяСписка[%НомерСтроки%].НомерСтроки", "ИмяСписка", ИмяСписка);
			Поле = СтрЗаменить(Поле, "%НомерСтроки%", РеквизитыОшибки.НомерСтроки - 1);

		ИначеЕсли РеквизитыОшибки.Регистр = "ТоварыКОтгрузке" Тогда

			ШаблонСообщения = НСтр("ru='Номенклатура %НоменклатураХарактеристика% %Назначение%. Отгружено со склада %Склад% больше, чем указано в документе, на %Количество% %Единица%';uk='Номенклатура %НоменклатураХарактеристика% %Назначение%. Відвантажено зі складу %Склад% більше, ніж зазначено в документі, %Количество% %Единица%'");
			Поле = Неопределено;

		КонецЕсли;

		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НоменклатураХарактеристика%",
			НоменклатураКлиентСервер.ПредставлениеНоменклатуры(РеквизитыОшибки.Номенклатура, РеквизитыОшибки.Характеристика));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%",  Строка(РеквизитыОшибки.Количество));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Строка(РеквизитыОшибки.НомерСтроки));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СинонимСписка%",   Строка(СинонимСписка));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Единица%",     Строка(РеквизитыОшибки.ЕдиницаИзмерения));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%",       Строка(РеквизитыОшибки.Склад));
		Если РеквизитыОшибки.Регистр = "ТоварыКОтгрузке" Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Назначение%",  Строка(РеквизитыОшибки.Назначение));
		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстСообщения,);

	КонецЦикла;

	Возврат Ошибки;

КонецФункции

// Возвращает счетчик изменений
//
Функция СчетИзменений(Счетчик, СтарыеЗначения, НовыеЗначения) Экспорт

	Если СтарыеЗначения.КодСтроки             <> НовыеЗначения.КодСтроки
		Или СтарыеЗначения.Количество         <> НовыеЗначения.Количество
		Или СтарыеЗначения.ВариантОбеспечения <> НовыеЗначения.ВариантОбеспечения
		Или СтарыеЗначения.Склад              <> НовыеЗначения.Склад
		Или СтарыеЗначения.ДатаОтгрузки       <> НовыеЗначения.ДатаОтгрузки Тогда

		Счетчик = Счетчик + 1;

	КонецЕсли;

КонецФункции

// Возвращает текст "Заполнение обеспечения"
//
// Возвращаемое значение:
//	Строка
//
Функция ТекстЗаполнениеОбеспечения() Экспорт
	Возврат НСтр("ru='Заполнение обеспечения';uk='Заповнення забезпечення'");
КонецФункции

// Возвращает текст "Обработано строк"
//
// Возвращаемое значение:
//	Строка
//
Функция ТекстОбработаноСтрок(Количество) Экспорт
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Обработано строк: %1';uk='Оброблено рядків: %1'"), Количество);
КонецФункции

#КонецОбласти

#Область Автозаказ

// Проверка на пересечение настроек
//
// Возвращаемое значение:
//	Булево
//
Функция ПроверитьПересечениеНастроек(КомпоновщикНастроек) Экспорт

	Для Каждого Элемент Из КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы Цикл

		ПолеСклад = Новый ПолеКомпоновкиДанных("Склад");
		Если Элемент.ЛевоеЗначение = ПолеСклад И ПолеИспользуется(КомпоновщикНастроек, ПолеСклад) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недопустимые условия отбора. Отбор по складу уже установлен в основной форме обработки.';uk='Неприпустимі умови відбору. Відбір за складом вже встановлений в основній формі обробки.'"));
			Возврат Ложь;

		КонецЕсли;

		ПолеНоменклатура = Новый ПолеКомпоновкиДанных("Номенклатура");
		Если Элемент.ЛевоеЗначение = ПолеНоменклатура И ПолеИспользуется(КомпоновщикНастроек, ПолеНоменклатура) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недопустимые условия отбора. Отбор по номенклатуре уже установлен в основной форме обработки.';uk='Неприпустимі умови відбору. Відбір за номенклатурою вже встановлений в основній формі обробки.'"));
			Возврат Ложь;

		КонецЕсли;

		ПолеПодразделение = Новый ПолеКомпоновкиДанных("Подразделение");
		Если Элемент.ЛевоеЗначение = ПолеПодразделение И ПолеИспользуется(КомпоновщикНастроек, ПолеПодразделение) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недопустимые условия отбора. Отбор по подразделению уже установлен в основной форме обработки.';uk='Неприпустимі умови відбору. Відбір по підрозділу вже встановлений в основній формі обробки.'"));
			Возврат Ложь;

		КонецЕсли;

		ПолеМенеджер = Новый ПолеКомпоновкиДанных("Менеджер");
		Если Элемент.ЛевоеЗначение = ПолеМенеджер И ПолеИспользуется(КомпоновщикНастроек, ПолеМенеджер) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недопустимые условия отбора. Отбор по менеджеру/ответственному уже установлен в основной форме обработки.';uk='Неприпустимі умови відбору. Відбір за менеджером/відповідальним вже встановлений в основній формі обробки.'"));
			Возврат Ложь;

		КонецЕсли;

	КонецЦикла;

	Возврат Истина;

КонецФункции

// Проверяет наличие настройки
//
// Возвращаемое значение:
//	Булево
//
Функция ПроверитьНаличиеНастройки(КомпоновщикНастроек, Поле, ТекстСообщения) Экспорт

	Если ПолеИспользуется(КомпоновщикНастроек, Поле, ТекстСообщения = "") Тогда

		Если ЗначениеЗаполнено(ТекстСообщения) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
		КонецЕсли;
		Возврат Ложь;

	КонецЕсли;

	Возврат Истина;

КонецФункции

// Создает структуру данных, содержащую параметры объединения таблиц
//
// Возвращаемое значение:
//  Структура - структура данных, содержащая параметры объединения таблиц.
//
Функция ПараметрыОбъединенияТаблиц() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("ОбновлятьСтроки",  Истина);
	Результат.Вставить("ДобавлятьСтроки",  Ложь);
	Результат.Вставить("НовыеСтроки",      Неопределено);
	Результат.Вставить("ИзмененныеСтроки", Неопределено);
	Результат.Вставить("Умолчания",        Неопределено);
	Возврат Результат;

КонецФункции

#КонецОбласти

Процедура СтруктураДействийВставитьПриИзмененииНазначения(СтруктураДействий) Экспорт
	
	СтруктураДействий.Вставить("ПриИзмененииНазначения");
	
КонецПроцедуры

Функция ПараметрыДействияПроверитьЗаполнитьОбеспечениеВДокументеПродажи(ЗаполнитьОбособленно, Статус, ЖелаемаяДатаОтгрузки) Экспорт
	
	ПараметрыДействия = Новый Структура("ПродажаОбособленаПоСоглашению, ВариантОбеспеченияПоСтатусу, ЖелаемаяДатаОтгрузки, Склад");
	
	ПараметрыДействия.ПродажаОбособленаПоСоглашению = ЗаполнитьОбособленно;
	ПараметрыДействия.ЖелаемаяДатаОтгрузки = ЖелаемаяДатаОтгрузки;
	
	СтатусыОтгрузить = Новый Массив;
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОтгрузке"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.Закрыт"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОтгрузке"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Выполнена"));
	
	СтатусыСоСклада = Новый Массив;
	СтатусыСоСклада.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОбеспечению"));
	СтатусыСоСклада.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению"));
	
	СтатусыНеТребуется = Новый Массив;
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.НеСогласован"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КВозврату"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Отклонена"));
	
	Если СтатусыОтгрузить.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспеченияПоСтатусу = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
		
	ИначеЕсли СтатусыСоСклада.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспеченияПоСтатусу = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
		
	ИначеЕсли СтатусыНеТребуется.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспеченияПоСтатусу = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется");
		
	КонецЕсли;
	
	ПараметрыДействия.ВариантОбеспеченияПоСтатусу = ВариантОбеспеченияПоСтатусу;
	Возврат ПараметрыДействия;
	
КонецФункции

//Возвращает параметры, используемые для заполнения варианта обеспечения по умолчанию
//Используется в методе ОбеспечениеКлиентСервер.ВариантОбеспеченияПоУмолчанию
//Возвращаемое значение:
//Структура с ключами
//	ТипНоменклатуры,
//	ЗаполнитьОбособленно,
//	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента,
//	СтатусЗаказаКлиента.
//
Функция ПараметрыЗаполненияВариантаОбеспеченияПоУмолчанию() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ТипНоменклатуры");
	Параметры.Вставить("ЗаполнитьОбособленно");
	Параметры.Вставить("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	Параметры.Вставить("СтатусЗаказаКлиента");
	Возврат Параметры;
	
КонецФункции

//Возвращает вариант обеспечения используемый по умолчанию в заказах для номенклатуры.
//Функция используется, например, при заполнении варианта обеспечения для строки, добавляемой в заказ,
//при копировании заказов, создании заказов на основании других заказов.
//
//Параметры:
// ПараметрыЗаполнения - Структура - см. ПараметрыЗаполненияВариантаОбеспеченияПоУмолчанию(), содержит ключи:
//	ТипНоменклатуры - ПеречислениеСсылка.ТипыНоменклатуры - Тип номенклатуры, для которой
//                   необходимо получить вариант обеспечения по умолчанию,
//	ЗаполнитьОбособленно - Булево - Признак, что для номенклатуры предпочтительно использовать обособленное обеспечение.
//	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента - признак использования соответствующей ФО
//	СтатусЗаказаКлиента - статус заполняемого заказа клиента, используется при отключенной ФО ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
//
//Возвращаемое значение:
//ПеречислениеСсылка.ВариантыОбеспечения - Вариант обеспечения по умолчанию.
//
Функция ВариантОбеспеченияПоУмолчанию(ПараметрыЗаполнения) Экспорт
	
	ТипНоменклатуры = ПараметрыЗаполнения.ТипНоменклатуры;
	ЗаполнитьОбособленно = ПараметрыЗаполнения.ЗаполнитьОбособленно;
	Статус = ПараметрыЗаполнения.СтатусЗаказаКлиента;
	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = ПараметрыЗаполнения.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента;
	
	// Особое заполнение для Заказов клиента (в т.ч. Заявок на возврат) в случае, когда не используется построчная отгрузка
	СтатусыОтгрузить = Новый Массив;
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОтгрузке"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.Закрыт"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОтгрузке"));
	СтатусыОтгрузить.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Выполнена"));
	
	СтатусыСоСклада = Новый Массив;
	СтатусыСоСклада.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОбеспечению"));
	СтатусыСоСклада.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению"));
	
	СтатусыНеТребуется = Новый Массив;
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.НеСогласован"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КВозврату"));
	СтатусыНеТребуется.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Отклонена"));
	
	Если Не ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
		И СтатусыОтгрузить.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
		
	ИначеЕсли Не ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
		И СтатусыСоСклада.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
		
	ИначеЕсли Не ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
		И СтатусыНеТребуется.Найти(Статус) <> Неопределено Тогда
		
		ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется");
		
		
	ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Тогда

		ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется");

	ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

		ВариантОбеспечения = ?(ЗаполнитьОбособленно = Истина,
		                     ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно"),
		                     ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется"));

	ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара") Тогда

		ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется");

	Иначе //товар

		ВариантОбеспечения = ?(ЗаполнитьОбособленно = Истина,
		                     ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно"),
		                     ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));

	КонецЕсли;
	
	Возврат ВариантОбеспечения;

КонецФункции

Процедура ВставитьПоля(Структура, СтруктураЗаполнения) Экспорт

	Для Каждого Свойство Из СтруктураЗаполнения Цикл

		Структура.Вставить(Свойство.Ключ, Свойство.Значение);

	КонецЦикла;

КонецПроцедуры

// Проверяет ключ на изменение
//
// Возвращаемое значение:
//	Булево
//
Функция ИзменилсяКлюч(Ключ, ПроверяемаяСтрока) Экспорт

	Для Каждого Свойство Из Ключ Цикл

		Если ПроверяемаяСтрока[Свойство.Ключ] <> Свойство.Значение Тогда
			Возврат Истина;
		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

//Перенос результатов заполнения обеспечения в документ
// Возвращает структуру ключа обеспечения
//
// Возвращаемое значение:
//	Структура
//
Функция КлючОбеспечения() Экспорт
	Возврат Новый Структура("КодСтроки, Количество, ВариантОбеспечения, Склад, ДатаОтгрузки");
КонецФункции

// Возвращает массив имен функциональных опций, определяющих использование статусов в заказах на отгрузку
// Возвращаемое значение
//  Массив - массив элементов типа Строка, имена функциональных опций.
//
Функция ИменаФункциональныхОпцийСтатусовЗаказовНаОтгрузку() Экспорт

	ИменаФункциональныхОпций = Новый Массив();
	ИменаФункциональныхОпций.Добавить("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	ИменаФункциональныхОпций.Добавить("ИспользоватьСтатусыЗаказовНаВнутреннееПотребление");
	ИменаФункциональныхОпций.Добавить("ИспользоватьСтатусыЗаказовНаПеремещение");
	ИменаФункциональныхОпций.Добавить("ИспользоватьСтатусыЗаказовНаСборку");
//++ НЕ УТ
	ИменаФункциональныхОпций.Добавить("ИспользоватьСтатусыЗаказовПереработчикам");
//-- НЕ УТ
//++ НЕ УТКА
	ИменаФункциональныхОпций.Добавить("ИспользоватьСтатусыЗаказовДавальцев");
//-- НЕ УТКА
	Возврат ИменаФункциональныхОпций;

КонецФункции

// Создает и заполняет структуру для хранения параметров, передаваемых при открытии формы обработки
//
// Параметры:
//  ДанныеЗаполнения - Структура - содержит данные для заполнения структуры параметров.
//
// Возвращаемое значение
//  Структура - Структура - структруа определяеющая контекст использования формы обработки. Содержит поля:
//   ТипОбеспечения - ПеречислениеСсылка.ТипыОбеспечения - определяет тип документа, создаваемого обработкой.
//
Функция ФормированиеЗаказовУпрощенноеКонтекст(ДанныеЗаполнения = Неопределено) Экспорт

	Поля = "ТипОбеспечения";
	Контекст = Новый Структура(Поля);

	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Контекст, ДанныеЗаполнения);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Контекст.ТипОбеспечения) Тогда
		Контекст.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка");
	КонецЕсли;

	Возврат Контекст;

КонецФункции

#КонецОбласти

#Область СлужебныепроцедурыИФункции

#Область Прочие

Функция ПолеИспользуется(КомпоновщикНастроек, Поле, ПроверятьРеквизиты = Ложь, ЭлементСтруктуры = Неопределено)

	Если ЭлементСтруктуры = Неопределено Тогда
		ЭлементСтруктуры = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	КонецЕсли;

	Для Каждого Элемент Из ЭлементСтруктуры Цикл

		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда

			Если Элемент.Использование И(
				Элемент.ЛевоеЗначение = Неопределено И НайтиПолеВНастройках(КомпоновщикНастроек, Элемент) = Поле Или
				Элемент.ЛевоеЗначение = Поле Или
				ПроверятьРеквизиты И Лев(Элемент.ЛевоеЗначение, СтрДлина(Поле)) = Строка(Поле)) Тогда
				Возврат Истина;
			КонецЕсли;

		ИначеЕсли ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда

			Если Элемент.Использование И ПолеИспользуется(КомпоновщикНастроек, Поле, ПроверятьРеквизиты, Элемент.Элементы) Тогда
				Возврат Истина;
			КонецЕсли;

		ИначеЕсли ТипЗнч(Элемент) = Тип("ОтборКомпоновкиДанных") Тогда

			Если ПолеИспользуется(КомпоновщикНастроек, Поле, ПроверятьРеквизиты, Элемент.Элементы) Тогда
				Возврат Истина;
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция НайтиПолеВНастройках(КомпоновщикНастроек, ИскомыйЭлемент)

	Для Каждого Элемент Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл

		Если Элемент.ИдентификаторПользовательскойНастройки = ИскомыйЭлемент.ИдентификаторПользовательскойНастройки Тогда
			Возврат Элемент.ЛевоеЗначение;
		КонецЕсли;

	КонецЦикла;

КонецФункции

#КонецОбласти

#КонецОбласти


