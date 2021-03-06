﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчетПрочихРасходов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов");
	Если НЕ ИспользоватьУчетПрочихРасходов Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаСтр = Строка(ВалютаУправленческогоУчета);
	КоэффициентПересчетаИзВалютыУпрВРегл = КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, Объект.Дата);
	
	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='Сумма';uk='Сума'"), ВалютаСтр);
	Элементы.ПрочиеРасходыСумма.Заголовок = ЗаголовокСумма;
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='Сумма без НДС';uk='Сума без ПДВ'"), ВалютаСтр);
	Элементы.ПрочиеРасходыСуммаБезНДС.Заголовок = ЗаголовокСумма;
	ЗаголовокНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='НДС';uk='ПДВ'"), ВалютаСтр);
	Элементы.ПрочиеРасходыСуммаНДС.Заголовок = ЗаголовокНДС;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	НДСОбщегоНазначенияСервер.ЗаполнитьСписокВыбораНалоговыхНазначенийВыпуска(Элементы.НалоговоеНазначение.СписокВыбора);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ПрочиеРасходы);
		Объект.НалоговоеНазначение = Справочники.Организации.НалоговоеНазначениеНДС(Объект.Организация, Объект.Дата);
	КонецЕсли;
	
	УстановитьЗаголовок();
	УстановитьДоступностьКомандБуфераОбмена();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);


КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ПрочиеРасходы);
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(Объект.ПрочиеРасходы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ПрочиеРасходы);
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(Объект.ПрочиеРасходы);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ПрочиеРасходы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеРасходы

&НаКлиенте
Процедура ПрочиеРасходыСтатьяРасходовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ПрочиеРасходы.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.СтатьяРасходов) Тогда
		СтатьяПрочихРасходовПриИзмененииСервер(КэшированныеЗначения);
	Иначе
		СтрокаТаблицы.АналитикаРасходов = Неопределено;
		СтрокаТаблицы.АналитикаРасходовОбязательна = Ложь;
		СтрокаТаблицы.ПринимаетсяКНУ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.ПрочиеРасходы.ТекущиеДанные;
	Если СтрокаТаблицы.АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", , Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыАналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.ПрочиеРасходы.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) И Элементы.ПрочиеРасходы.ТекущиеДанные.АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) И Элементы.ПрочиеРасходы.ТекущиеДанные.АналитикаРасходовЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрочиеРасходы.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасходыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПрочиеРасходы.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры


&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоСтрокДоВставки = Объект.ПрочиеРасходы.Количество();
	ПолучитьСтрокиИзБуфераОбмена();
	КоличествоВставленных = Объект.ПрочиеРасходы.Количество()-КоличествоСтрокДоВставки;
	КопированиеСтрокКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если КопированиеСтрокКлиент.ВозможноКопированиеСтрок(Элементы.ПрочиеРасходы.ТекущаяСтрока) Тогда
		СкопироватьСтрокиНаСервере();
		КопированиеСтрокКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.ПрочиеРасходы.ВыделенныеСтроки.Количество());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОперацийВводаОстатков.ОстаткиПрочихРасходов;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление, Новый Структура("ПрочиеРасходы"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, ДатаДокумента)
	
	Возврат РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
											ВалютаУправленческогоУчета,
											ВалютаРегламентированногоУчета,
											?(ДатаДокумента = Дата(1,1,1), ТекущаяДатаСеанса(), ДатаДокумента));
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.НалоговоеНазначение = Справочники.Организации.НалоговоеНазначениеНДС(Объект.Организация, Объект.Дата);	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СтатьяПрочихРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.ПрочиеРасходы.НайтиПоИдентификатору(Элементы.ПрочиеРасходы.ТекущаяСтрока);
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		СтрокаТаблицы.СтатьяРасходов,
		СтрокаТаблицы.АналитикаРасходов);
		
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, АналитикаРасходовЗаказРеализация");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

#Область РаботаСБуферомОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	КопированиеСтрокСервер.ПоместитьВыделенныеСтрокиВБуферОбмена(Элементы.ПрочиеРасходы.ВыделенныеСтроки,
																										   Объект.ПрочиеРасходы);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена()
	
	ТаблицаСтрок = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена();
	Для Каждого Строка Из ТаблицаСтрок Цикл
		ТекущаяСтрока = Объект.ПрочиеРасходы.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Строка, "СтатьяРасходов, АналитикаРасходов, Сумма, СуммаБезНДС, СуммаРегл, СуммаПР, СуммаВР");
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ПрочиеРасходыСкопироватьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыВставитьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыКонтекстноеМенюСкопироватьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, 
		МассивЭлементов,
		"Доступность",
		НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ПрочиеРасходыСкопироватьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыВставитьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыКонтекстноеМенюСкопироватьСтроки");
	МассивЭлементов.Добавить("ПрочиеРасходыКонтекстноеМенюВставитьСтроки");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
