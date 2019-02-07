﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПериодНачисления = Новый СтандартныйПериод;
		ПериодНачисления.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
		Объект.ДатаНачала = ПериодНачисления.ДатаНачала;
		Объект.ДатаОкончания = ПериодНачисления.ДатаОкончания;
		
	КонецЕсли;
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Если РезультатВыбора.Свойство("АдресНачисленийВХранилище") Тогда
			ПолучитьНачисленияИзХранилища(РезультатВыбора.АдресНачисленийВХранилище);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ХозяйственнаяОперацияПриИзмененииСервер();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	ПартнерПриИзмененииНаСервере(ТекущиеДанные.Партнер, ТекущиеДанные.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	Договор = РеквизитыДоговораСервер(ТекущиеДанные.Договор);
	ТекущиеДанные.Партнер = Договор.Партнер;
	ТекущиеДанные.Контрагент = Договор.Контрагент;
	Если ТекущиеДанные.ВалютаВзаиморасчетов <> Договор.ВалютаВзаиморасчетов Тогда
		ТекущиеДанные.ВалютаВзаиморасчетов = Договор.ВалютаВзаиморасчетов;
		ТекущиеДанные.СуммаВзаиморасчетов = 0;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты") Тогда
		ТекущиеДанные.СтатьяДоходовРасходов = Договор.СтатьяДоходовРасходовПроцентов;
	ИначеЕсли ТекущиеДанные.ТипСуммыГрафика = ПредопределенноеЗначение("Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия") Тогда
		ТекущиеДанные.СтатьяДоходовРасходов = Договор.СтатьяДоходовРасходовКомиссии;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	ТекущиеДанные.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Начисления.ТекущиеДанные;	
	НоваяСтатья = ТекущаяСтрока.СтатьяДоходовРасходов;
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.НачисленияПоКредитам") Тогда
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
	Иначе
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
	КонецЕсли;
	Элемент.ОграничениеТипа = ОграничивающиеТипы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Текст  = НСтр("ru='Не указана хозяйственная операция!';uk='Не зазначена господарська операція!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ХозяйственнаяОперация","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Текст  = НСтр("ru='Не указана организация!';uk='Не зазначена організація!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"Организация","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Текст  = НСтр("ru='Не указано начало периода начислений!';uk='Не зазначений початок періоду нарахувань!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ДатаНачала","Объект");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		Текст  = НСтр("ru='Не указан конец периода начислений!';uk='Не зазначений кінець періоду нарахувань!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ДатаОкончания","Объект");
		Возврат;
	КонецЕсли;
	
	АдресНачисленийВХранилище = ПоместитьНачисленияВХранилище();
	ПараметрыОтбора = Новый Структура("
		|АдресНачисленийВХранилище,
		|Организация,
		|Регистратор,
		|ИдентификаторФормыДокумента,
		|ХозяйственнаяОперация,
		|ДатаНачала,
		|ДатаОкончания",
		АдресНачисленийВХранилище,
		Объект.Организация,
		Объект.Ссылка,
		УникальныйИдентификатор,
		Объект.ХозяйственнаяОперация,
		Объект.ДатаНачала,
		Объект.ДатаОкончания);
	
	ОткрытьФорму("Документ.НачисленияКредитовИДепозитов.Форма.ФормаЗаполнения", 
						ПараметрыОтбора,
						ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатьяДоходовРасходов.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Начисления.ТипСуммыГрафика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыСуммГрафикаКредитовИДепозитов.Комиссия;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Начисления.СтатьяДоходовРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()

	УстановитьПараметрыВыбораДоговора();
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачисленияПоКредитам Тогда
		Элементы.СтатьяДоходовРасходов.Заголовок = НСтр("ru='Статья расходов';uk='Стаття витрат'");
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
	Иначе
		Элементы.СтатьяДоходовРасходов.Заголовок = НСтр("ru='Статья доходов';uk='Стаття доходів'");
		ОграничивающиеТипы = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
	КонецЕсли;
	Элементы.СтатьяДоходовРасходов.ОграничениеТипа = ОграничивающиеТипы;
	
	ПартнерыИКонтрагенты.ЗаголовокЭлементаПартнерВЗависимостиОтХозяйственнойОперации( ЭтотОбъект, "Партнер", Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииНаСервере(Партнер, Контрагент)
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыДоговораСервер(Договор)

	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, 
															"Партнер,
															|Контрагент,
															|ВалютаВзаиморасчетов,
															|СтатьяДоходовРасходовПроцентов,
															|СтатьяДоходовРасходовКомиссии,
															|ХарактерДоговора");
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыВыбораДоговора(Партнер = Неопределено, Контрагент = Неопределено)

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления",Ложь));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ХарактерДоговора", Справочники.ДоговорыКредитовИДепозитов.ХарактерДоговораПоОперации(Объект.ХозяйственнаяОперация)));
	Если НЕ Объект.Организация.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Объект.Организация));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Партнер", Партнер));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Контрагент));
	КонецЕсли;
	
	Элементы.Договор.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);

КонецПроцедуры

&НаСервере
Функция ПоместитьНачисленияВХранилище()

	АдресВХранилище = ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(), УникальныйИдентификатор);
	Возврат АдресВХранилище;

КонецФункции

&НаСервере
Процедура ПолучитьНачисленияИзХранилища(АдресНачисленийВХранилище)

	Объект.Начисления.Загрузить(ПолучитьИзВременногоХранилища(АдресНачисленийВХранилище));

КонецПроцедуры

#КонецОбласти

#КонецОбласти
