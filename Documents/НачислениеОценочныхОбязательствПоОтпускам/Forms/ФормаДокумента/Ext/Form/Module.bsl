﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ДанныеОтредактированы;

&НаКлиенте
Перем ЗакрытьПослеЗаписи;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Организация, Ответственный", 
			"Объект.ПериодРегистрации",
			"Объект.Организация",
			"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Печать"
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ЗакрытьПослеЗаписи = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗакрытьПослеЗаписи И ДанныеОтредактированы И НЕ Объект.КорректировкаОбязательств Тогда
		
		Если Объект.РасчетРезерваОтпусков.Количество() = 0
			И Объект.ОценочныеОбязательства.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаписьюОкончание", ЭтаФорма, ПараметрыЗаписи);
		
		ТекстВопроса = НСтр("ru='Перед записью документа необходимо рассчитать обязательства и резервы текущего месяца.
            |Продолжить?'
            |;uk='Перед записом документа необхідно розрахувати зобов''язання та резерви поточного місяця.
            |Продовжити?'");
			
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.КорректировкаОбязательств Тогда
		Если ТекущийОбъект.РасчетРезерваОтпусков.Количество() <> 0 Тогда
			ТекущийОбъект.РасчетРезерваОтпусков.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗакрытьПослеЗаписи Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КорректировкаОбязательствПриИзменении(Элемент)
	
	Объект.КорректировкаОбязательств = НЕ КорректировкаПредставление;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбязательстваОтраженыВБухучетеПриИзменении(Элемент)
	
	Если Объект.ОбязательстваОтраженыВБухучете Тогда
		Объект.Бухгалтер = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		Объект.Бухгалтер = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРасчетРезерваОтпусков

&НаКлиенте
Процедура РасчетРезерваОтпусковПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНадписиВСтроке(Элементы.РасчетРезерваОтпусков.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОценочныеОбязательстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНадписиВСтроке(Элементы.ОценочныеОбязательства.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковОстатокОтпускаПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "ОстатокОтпуска");
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковОтпускАвансомПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "ОтпускАвансом");
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковСреднийЗаработокПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "СреднийЗаработок");
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковТекущаяСтавкаСтраховыхВзносовПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "ТекущаяСтавкаСтраховыхВзносов");
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковСуммаРезерваИсчисленоПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "СуммаРезерваИсчислено");
	
КонецПроцедуры


&НаКлиенте
Процедура РасчетРезерваОтпусковСуммаРезерваСтраховыхВзносовИсчисленоПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	ПересчитатьНаКлиенте(СтрокаТаблицы, "СуммаРезерваСтраховыхВзносовИсчислено");
	
КонецПроцедуры


&НаКлиенте
Процедура РасчетРезерваОтпусковПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если РассчитыватьДокументыПриРедактировании Тогда
		ПересчитатьДокументНаКлиенте();
		ЗакрытьПослеЗаписи    = Истина;
	Иначе
		ДанныеОтредактированы = Истина;
		РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетРезерваОтпусковПослеУдаления(Элемент)
	
	Если РассчитыватьДокументыПриРедактировании Тогда
		ПересчитатьДокументНаКлиенте();
		ЗакрытьПослеЗаписи    = Истина;
	Иначе
		ДанныеОтредактированы = Истина;
		РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДокумент(Команда)
	
	ПересчитатьДокументНаКлиенте();
	РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.РасчетРезерваОтпусков.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Табличные части документа будут очищены. Продолжить?';uk='Табличні частини документа будуть очищені. Продовжити?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОценочныеОбязательстваСпособОтраженияЗарплатыВБухучете.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КорректировкаОбязательств");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция СформироватьОписаниеДокумента()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	ОписаниеДокумента = Новый Структура("Ссылка,
		|Организация, Дата, ПериодРегистрации,
		|КорректировкаОбязательств, ДоляРасходов");
	ЗаполнитьЗначенияСвойств(ОписаниеДокумента, ТекущийОбъект);
	
	ОписаниеДокумента.Вставить("РасчетРезерваОтпусков",                             ТекущийОбъект.РасчетРезерваОтпусков.Выгрузить());
	ОписаниеДокумента.Вставить("ОценочныеОбязательства",                            ТекущийОбъект.ОценочныеОбязательства.Выгрузить());
	ОписаниеДокумента.Вставить("ФизическиеЛица",                                    ТекущийОбъект.ФизическиеЛица.Выгрузить());
	ОписаниеДокумента.Вставить("ОценочныеОбязательстваПоВознаграждениямРаботникам", ТекущийОбъект.ОценочныеОбязательстваПоВознаграждениямРаботникам.Выгрузить());
	
	Возврат ОписаниеДокумента;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	Результат = ЗаполнитьНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Функция ЗаполнитьНаСервере()
	
	ПараметрыЗаполнения = Новый Структура("Объект, ИмяТаблицы",
		СформироватьОписаниеДокумента(),
		"");
	
	НаименованиеЗадания = НСтр("ru='Заполнение документа ""Начисление оценочных обязательств по отпускам""';uk='Заповнення документа ""Нарахування оціночних зобов''язань щодо відпусток""'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Документы.НачислениеОценочныхОбязательствПоОтпускам.ЗаполнитьНачислениеОценочныхОбязательствПоОтпускам", 
		ПараметрыЗаполнения, 
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	КорректировкаПредставление = НЕ Объект.КорректировкаОбязательств;
	
	РассчитыватьДокументыПриРедактировании = Константы.РассчитыватьДокументыПриРедактировании.Получить();

	УстановитьФункциональныеОпцииФормы();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		ОбменИспользуется = Модуль.ОбменИспользуется(Объект.Организация);
	КонецЕсли;
	
	Если ОбменИспользуется Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
			ТолькоПросмотр = Объект.ОбязательстваОтраженыВБухучете;
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбязательстваОтраженыВБухучете", "ТолькоПросмотр", Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Бухгалтер", "ТолькоПросмотр", Истина);
		Иначе
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Заполнить", "Видимость", Ложь);
			
			ПользователюРазрешеноФормированиеПроводок = Пользователи.РолиДоступны("ОтражениеЗарплатыВБухгалтерскомУчете");
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбязательстваОтраженыВБухучете", "ТолькоПросмотр", Не ПользователюРазрешеноФормированиеПроводок);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Бухгалтер", "ТолькоПросмотр", Не ПользователюРазрешеноФормированиеПроводок);
			
			Если НЕ ПользователюРазрешеноФормированиеПроводок Тогда
				ТолькоПросмотр = Объект.ОбязательстваОтраженыВБухучете;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если Объект.КорректировкаОбязательств И Элементы.ОсновныеКоманды.Видимость Тогда
		Элементы.Страницы.ТекущаяСтраница    = Элементы.ГруппаОценочныеОбязательства;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПересчитатьДокумент",
			"Видимость",
			Ложь);
	ИначеЕсли НЕ Объект.КорректировкаОбязательств И НЕ Элементы.ОсновныеКоманды.Видимость Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПересчитатьДокумент",
		"Видимость",
		НЕ РассчитыватьДокументыПриРедактировании И НЕ Объект.КорректировкаОбязательств);
	
	Инвентаризация = КонецМесяца(Объект.ПериодРегистрации) = КонецГода(Объект.ПериодРегистрации);
	МетодОбязательств = Ложь;
	Отбор = Новый Структура("Организация", Объект.Организация);
	НастройкиРасчетаРезервовОтпусков = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СрезПоследних(Объект.ПериодРегистрации, Отбор);
	Если НастройкиРасчетаРезервовОтпусков.Количество()<> 0 Тогда
		МетодОбязательств = НастройкиРасчетаРезервовОтпусков[0].МетодНачисленияРезерваОтпусков = Перечисления.МетодыНачисленияРезервовОтпусков.МетодОбязательств;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РасчетРезерваОтпусковОстатокОтпуска",                   "Видимость", МетодОбязательств ИЛИ Инвентаризация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РасчетРезерваОтпусковОтпускАвансом",                    "Видимость", МетодОбязательств ИЛИ Инвентаризация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РасчетРезерваОтпусковСреднийЗаработок",                 "Видимость", МетодОбязательств ИЛИ Инвентаризация);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РасчетРезерваОтпусковТекущаяСтавкаСтраховыхВзносов",    "Видимость", МетодОбязательств ИЛИ Инвентаризация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОсновныеКоманды", "Видимость", 
		РезервОтпусковПереопределяемый.РезервыРассчитываютсяАвтоматически() И НЕ Объект.КорректировкаОбязательств);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц(ИмяТаблицы = "")
	
	Если ИмяТаблицы = "" Тогда
		Для Каждого СтрокаТаблицы Из Объект.РасчетРезерваОтпусков Цикл
			ЗаполнитьНадписиВСтроке(СтрокаТаблицы);
		КонецЦикла;
		Для Каждого СтрокаТаблицы Из Объект.ОценочныеОбязательства Цикл
			ЗаполнитьНадписиВСтроке(СтрокаТаблицы);
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблицы Из Объект[ИмяТаблицы] Цикл
			ЗаполнитьНадписиВСтроке(СтрокаТаблицы);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНадписиВСтроке(ТекущиеДанные)
	
	ТекущиеДанные.НадписьБУ = НСтр("ru='БУ:';uk='БО:'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьНаКлиенте(ПараметрыСтроки, ИмяРеквизита, Показатель = "")
	
	Если ИмяРеквизита = "ОстатокОтпуска" ИЛИ ИмяРеквизита = "ОтпускАвансом" ИЛИ ИмяРеквизита = "СреднийЗаработок" Тогда
		ПараметрыСтроки.СуммаРезерваИсчислено                     = ПараметрыСтроки.СреднийЗаработок* Макс(0, ПараметрыСтроки.ОстатокОтпуска - ПараметрыСтроки.ОтпускАвансом);
		ПараметрыСтроки.СуммаРезерва                              = ПараметрыСтроки.СуммаРезерваИсчислено - ПараметрыСтроки.СуммаРезерваНакоплено;
		
		ПараметрыСтроки.СуммаРезерваСтраховыхВзносовИсчислено     = ПараметрыСтроки.СуммаРезерваИсчислено*ПараметрыСтроки.ТекущаяСтавкаСтраховыхВзносов/100;
		ПараметрыСтроки.СуммаРезерваСтраховыхВзносов              = ПараметрыСтроки.СуммаРезерваСтраховыхВзносовИсчислено - ПараметрыСтроки.СуммаРезерваСтраховыхВзносовНакоплено;
		
	КонецЕсли;
	
	Если ИмяРеквизита = "ТекущаяСтавкаСтраховыхВзносов" Тогда
		ПараметрыСтроки.СуммаРезерваСтраховыхВзносовИсчислено     = ПараметрыСтроки.СуммаРезерваИсчислено*ПараметрыСтроки.ТекущаяСтавкаСтраховыхВзносов/100;
		ПараметрыСтроки.СуммаРезерваСтраховыхВзносов              = ПараметрыСтроки.СуммаРезерваСтраховыхВзносовИсчислено - ПараметрыСтроки.СуммаРезерваСтраховыхВзносовНакоплено;
	КонецЕсли;
	
	
	Если ИмяРеквизита = "СуммаРезерваИсчислено" Тогда
		ПараметрыСтроки["СуммаРезерва" + Показатель] = ПараметрыСтроки["СуммаРезерваИсчислено" + Показатель] - ПараметрыСтроки["СуммаРезерваНакоплено" + Показатель];
	КонецЕсли;
	
	Если ИмяРеквизита = "СуммаРезерваСтраховыхВзносовИсчислено" Тогда
		ПараметрыСтроки["СуммаРезерваСтраховыхВзносов" + Показатель] = ПараметрыСтроки["СуммаРезерваСтраховыхВзносовИсчислено" + Показатель] - ПараметрыСтроки["СуммаРезерваСтраховыхВзносовНакоплено" + Показатель];
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДокументНаКлиенте()
	
	Результат = ПересчитатьНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПересчитатьНаСервере()
	
	ПараметрыЗаполнения = Новый Структура("Объект, ИмяТаблицы",
		СформироватьОписаниеДокумента(),
		"ОценочныеОбязательства");
	
	НаименованиеЗадания = НСтр("ru='Пересчет документа ""Начисление оценочных обязательств по отпускам""';uk='Перерахунок документа ""Нарахування оціночних зобов''язань щодо відпусток""'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Документы.НачислениеОценочныхОбязательствПоОтпускам.ПеречитатьОценочныеОбязательства", 
		ПараметрыЗаполнения, 
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьРезультат()
		
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если Результат.Свойство("Объект") Тогда
		
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
		
		РезультатОбъект = Результат.Объект;
		
		ТекущийОбъект.РасчетРезерваОтпусков.Загрузить(РезультатОбъект.РасчетРезерваОтпусков);
		ТекущийОбъект.ОценочныеОбязательства.Загрузить(РезультатОбъект.ОценочныеОбязательства);
		ТекущийОбъект.ФизическиеЛица.Загрузить(РезультатОбъект.ФизическиеЛица);
		ТекущийОбъект.ОценочныеОбязательстваПоВознаграждениямРаботникам.Загрузить(РезультатОбъект.ОценочныеОбязательстваПоВознаграждениямРаботникам);
		ТекущийОбъект.ДоляРасходов = РезультатОбъект.ДоляРасходов;
		
		ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
		
		ЗаполнитьДобавленныеКолонкиТаблиц(Результат.ИмяТаблицы);
		
		ДанныеОтредактированы = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюОкончание(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если Объект.РасчетРезерваОтпусков.Количество() = 0 Тогда
			Объект.ОценочныеОбязательства.Очистить();
			ДанныеОтредактированы = Ложь;
		Иначе
			ПересчитатьДокументНаКлиенте();
		КонецЕсли;
		Записать(Параметры);
	Иначе
		ЗакрытьПослеЗаписи = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ОбработатьИзменениеМесяцНачисленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеВыбрано Тогда
		ОбработатьИзменениеМесяцНачисленияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцНачисленияПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцНачисленияПриИзменении()

	ОбработатьИзменениеМесяцНачисленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеМесяцНачисленияНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.ПериодРегистрации));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ЗакрытьПослеЗаписи    = Ложь;
ДанныеОтредактированы = Ложь;