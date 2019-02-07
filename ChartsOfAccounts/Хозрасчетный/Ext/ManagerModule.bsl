﻿
#Область ПрограммныйИнтерфейс

// Возвращает массив счетов с видами субконто заданными в качестве параметра
//
// Параметры:
// 		ВидыСубконто - Массив, ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные - Массив ссылок или ссылка на субконто, по которому необходимо получить счета
// 		ВидыСубконто - Массив, ПланСчетовСсылка.Хозрасчетный - Массив ссылок или ссылка на исключаемые счета
//
// Возвращаемое значение:
// 		Массив - Массив ссылок <ПланСчетовСсылка.Хозрасчетный>, поддерживающих субконто заданные параметром функции
//
Функция СчетаСНаборомСубконто(ВидыСубконто, ИсключаемыеСсылки=Неопределено) Экспорт
	
	ТипПараметра = ТипЗнч(ВидыСубконто);
	НесколькоСубконто = ((ТипПараметра = Тип("Массив")
		Или ТипПараметра = Тип("ФиксированныйМассив")
		Или ТипПараметра = Тип("СписокЗначений"))
			И ВидыСубконто.Количество()>1);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПланСчетовВидыСубконто.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Счета
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ПланСчетовВидыСубконто
	|ГДЕ
	|	ПланСчетовВидыСубконто.ВидСубконто В(&ВидыСубконто)
	|	И НЕ ПланСчетовВидыСубконто.Ссылка В (&ИсключаемыеСсылки)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланСчетовВидыСубконто.Ссылка КАК Ссылка
	|ИЗ
	|	Счета КАК Счета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ПланСчетовВидыСубконто
	|		ПО Счета.Ссылка = ПланСчетовВидыСубконто.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланСчетовВидыСубконто.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланСчетовВидыСубконто.Ссылка) = &КоличествоВидовСубконто И
	|	СУММА(ВЫБОР
	|			КОГДА ПланСчетовВидыСубконто.ВидСубконто В (&ВидыСубконто)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) = &КоличествоВидовСубконто";
	
	Запрос.УстановитьПараметр("КоличествоВидовСубконто", ?(НесколькоСубконто, ВидыСубконто.Количество(), 1));
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Запрос.УстановитьПараметр("ИсключаемыеСсылки", ИсключаемыеСсылки);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// При вводе кода счета с цифровой клавиатуры заменяем запятую на точку
	Если ТипЗнч(Параметры.СтрокаПоиска) = Тип("Строка") Тогда
		Параметры.СтрокаПоиска = СтрЗаменить(Параметры.СтрокаПоиска, ",", ".");
	КонецЕсли;
	
	Если Параметры.Свойство("ВидыСубконто") Тогда
		ИсключаемыеСсылки = Неопределено;
		Параметры.Свойство("ИсключаемыеСсылки", ИсключаемыеСсылки);
		Параметры.Отбор.Вставить("Ссылка", СчетаСНаборомСубконто(Параметры.ВидыСубконто, ИсключаемыеСсылки));
	КонецЕсли;
	
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьСчетаИсключения() Экспорт
	
	МассивСчетовИсключений = Новый Массив;
	
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ДопРасходыМалоценныеИБыстроизнашивающиесяПредметы);
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ДопРасходыПроизводственныеЗапасы);
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ДопРасходыТовары);
	
	Возврат Новый ФиксированныйМассив(МассивСчетовИсключений);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Простой список
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПростойСписок";
	КомандаПечати.Представление = НСтр("ru='Простой список';uk='Простий список'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='План счетов';uk='План рахунків'");
	КомандаПечати.СписокФорм    = "ФормаСписка, ФормаВыбора";
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// С подробными описаниями
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СПодробнымиОписаниями";
	КомандаПечати.Представление = НСтр("ru='С подробными описаниями';uk='З докладними описами'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='План счетов (с подробными описаниями)';uk='План рахунків (з докладними описами)'");
	КомандаПечати.СписокФорм    = "ФормаСписка, ФормаВыбора";
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Функция ПечатьПланаСчетов(ВыводитьОписания = Ложь)
	
	Макет = ПланыСчетов.Хозрасчетный.ПолучитьМакет("Описание");
	
	Шапка  = Макет.ПолучитьОбласть("Шапка");
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.Вывести(Шапка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИспользоватьВалютныйУчет", БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланСчетов1.Ссылка КАК Ссылка,
	|	КОЛИЧЕСТВО(ПланСчетов2.Ссылка) КАК КоличествоДочерних
	|ПОМЕСТИТЬ ВТ_ГруппыСчетов
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК ПланСчетов1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК ПланСчетов2
	|		ПО ПланСчетов1.Ссылка = ПланСчетов2.Родитель
	|ГДЕ
	|	ПланСчетов1.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланСчетов1.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПланСчетов1.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПланаСчетов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВТ_ГруппыСчетов.КоличествоДочерних > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоГруппа,
	|	ТаблицаПланаСчетов.Код КАК Код,
	|	ТаблицаПланаСчетов.Порядок КАК Порядок,
	|	ТаблицаПланаСчетов.Наименование КАК Наименование,
	|	ТаблицаПланаСчетов.Валютный КАК Валютный,
	|	ТаблицаПланаСчетов.Количественный КАК Количественный,
	|	ТаблицаПланаСчетов.Забалансовый КАК Забалансовый,
	|	ТаблицаПланаСчетов.Вид КАК Вид,
	|	ТаблицаПланаСчетов.ВидыСубконто.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВидСубконто.Наименование КАК Наименование,
	|		ТолькоОбороты КАК ТолькоОбороты
	|	) КАК ВидыСубконто
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК ТаблицаПланаСчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ГруппыСчетов КАК ВТ_ГруппыСчетов
	|		ПО ТаблицаПланаСчетов.Ссылка = ВТ_ГруппыСчетов.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаПланаСчетов.Порядок";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			Строка = Макет.ПолучитьОбласть("Группа");
		Иначе
			Строка = Макет.ПолучитьОбласть("Строка");
		КонецЕсли;
			
		Строка.Параметры.Заполнить(Выборка);
			
		Если Выборка.Вид = ВидСчета.Активный Тогда
			Строка.Параметры.Активность = "А";
		ИначеЕсли Выборка.Вид = ВидСчета.Пассивный Тогда
			Строка.Параметры.Активность = "П";
		Иначе
			Строка.Параметры.Активность = "АП";
		КонецЕсли;
		
		ВидыСубконто = Выборка.ВидыСубконто.Выбрать();
		Пока ВидыСубконто.Следующий() Цикл
			Строка.Параметры["Субконто" + ВидыСубконто.НомерСтроки] = ?(ВидыСубконто.ТолькоОбороты, "(об) ", "") + ВидыСубконто.Наименование;
		КонецЦикла;
			
		ТабДокумент.Вывести(Строка);
		
		Если ВыводитьОписания Тогда
		
			Попытка
				Описание = Макет.ПолучитьОбласть(ПланыСчетов[Выборка.Ссылка.Метаданные().Имя].ПолучитьИмяПредопределенного(Выборка.Ссылка));
				ТабДокумент.Вывести(Описание);
			Исключение
				// Запись в журнал регистрации не требуется
			КонецПопытки;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ТабДокумент.ФиксацияСверху = 2;
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПростойСписок") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПростойСписок", НСтр("ru='Простой список';uk='Простий список'"), ПечатьПланаСчетов());                                            
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СПодробнымиОписаниями") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СПодробнымиОписаниями", НСтр("ru='С подробными описаниями';uk='З докладними описами'"), ПечатьПланаСчетов(Истина));                                            
	КонецЕсли;
		
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Обработчик обновления УП 2.1.2.10
Процедура ОбновитьОбъект_2_1_2() Экспорт
	
	ЗаполнитьКодБыстрогоДоступа();
	
	УстановитьСуммовойУчетПоСкладам();
	
	// Устанавливает запрет на использование в проводках групповых счетов по резервам отпусков.
	УстановитьЗапретНаИспользование();
	
КонецПроцедуры

Процедура ЗаполнитьКодБыстрогоДоступа()
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.КодБыстрогоВыбора = """"
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(Объект.Код, ".", ""));
		Попытка
			Объект.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьСуммовойУчетПоСкладам()
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|		ПО (ХозрасчетныйВидыСубконто.Ссылка = Хозрасчетный.Ссылка)
	|ГДЕ
	|	НЕ ХозрасчетныйВидыСубконто.Суммовой
	|	И ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
	|	И НЕ Хозрасчетный.Забалансовый";
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Пока Выборка.Следующий() Цикл
	
		СчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Для каждого Строка из СчетОбъект.ВидыСубконто Цикл
			Если Строка.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
				Строка.Суммовой = Истина;
			КонецЕсли;
		КонецЦикла;
			
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗапретНаИспользование()
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РезервыПредстоящихРасходов), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОценочныеОбязательстваПоВознаграждениямРаботникам))
	|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			СчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СчетОбъект.ЗапретитьИспользоватьВПроводках = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
		Исключение
			ТекстСообщения = НСтр("ru='Не удалось установить запрет на использование в проводках для счета %1 по причине %2';uk='Не вдалося встановити заборону на використання в проводках для рахунку %1 по причині %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru='Обновление информационной базы';uk='Оновлення інформаційної бази'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецЕсли
