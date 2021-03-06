﻿
&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ОтражениеАмортизационныхРасходов,
		"СтатьяРасходов, АналитикаРасходов");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьТекущиеЗначенияРеквизитов();
	КонецЕсли;
	
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если (Объект.ОС.Количество() > 0)
		ИЛИ (ЗначениеЗаполнено(Объект.ДокументОснование)
			И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПринятиеКУчетуОС")) Тогда
		
		ДатаПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
		
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьТекущиеЗначенияРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУПриИзменении(Элемент)
	
	СрокИспользованияБУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияБУ);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУПриИзменении(Элемент)
	
	СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияНУ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикАмортизацииФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Элементы.ГрафикАмортизации.ПодсказкаВвода = "" Тогда
		Элементы.ГрафикАмортизации.ПодсказкаВвода = НСтр("ru='<без графика>';uk='<без графіка>'")
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Не Объект.СрокИспользованияБУФлаг Тогда
		СрокИспользованияБУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияБУ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Не Объект.СрокИспользованияНУФлаг Тогда
		СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияНУ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъемНаработкиБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииНУФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры



&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовФлагПриИзменении(Элемент)
	
	ОтражениеАмортизационныхРасходовФлагПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОтражениеАмортизационныхРасходовФлагПриИзмененииНаСервере()
	
	ТаблицаПустая = Объект.ОтражениеАмортизационныхРасходов.Количество()=0;
	
	Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
	Элементы.ОтражениеАмортизационныхРасходов.АвтоОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.ОтражениеАмортизационныхРасходов.ОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг И ТаблицаПустая;
	
	Элементы.ОСОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаПараметры И ОбновитьТекущиеЗначения Тогда
		СтраницыПриСменеСтраницыНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	ЗаполнитьТекущиеЗначенияРеквизитов(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОС

&НаКлиенте
Процедура ОСПриИзменении(Элемент)
	ОбновитьТекущиеЗначения = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
			ЗаполнитьЗначенияСвойств(
				СтрокаТЧ,
				ТекущиеЗначенияРеквизитовОсновногоСредства(ОсновноеСредство, Объект.Дата, Объект.Организация));
		Иначе
			ЗаполнитьЗначенияСвойств(
				СтрокаТЧ,
				ПустыеЗначенияРеквизитовОсновногоСредства());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОтражениеРасходов

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеАмортизационныхРасходов.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.СтатьяРасходов) Тогда
		ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения);
	Иначе
		СтрокаТаблицы.АналитикаРасходов = Неопределено;
		СтрокаТаблицы.АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.ОтражениеАмортизационныхРасходов.НайтиПоИдентификатору(
		Элементы.ОтражениеАмортизационныхРасходов.ТекущаяСтрока);
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		СтрокаТаблицы.СтатьяРасходов,
		СтрокаТаблицы.АналитикаРасходов);
		
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовПередаватьРасходыВДругуюОрганизациюПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеАмортизационныхРасходов.ТекущиеДанные;
	Если Не СтрокаТаблицы.ПередаватьРасходыВДругуюОрганизацию Тогда
		СтрокаТаблицы.ОрганизацияПолучательРасходов = Неопределено;
		СтрокаТаблицы.СчетПередачиРасходов = Неопределено;
	КонецЕсли;
	
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
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	
	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	
	#Область АналитикиРасходов
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление,
		Новый Структура(
			"ОтражениеАмортизационныхРасходов",
			"СтатьяРасходов, АналитикаРасходов"));
	
	#КонецОбласти
	
	#Область ПередачаРасходов
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовПодразделение.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСтатьяРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовАналитикаРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСчетПередачиРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовОрганизацияПолучательРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовКоэффициент.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтражениеАмортизационныхРасходовФлаг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
	#Область ПередачаРасходовВДругуюОрганизацию
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСчетПередачиРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовОрганизацияПолучательРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтражениеАмортизационныхРасходов.ПередаватьРасходыВДругуюОрганизацию");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПриИзменении(ИмяФлага)
	
	ФлагУстановлен = Объект[ИмяФлага];
	Имя = СтрЗаменить(ИмяФлага, "Флаг", "");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Имя, "Доступность", ФлагУстановлен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОС"+Имя, "Видимость", ФлагУстановлен);
	
	Если Объект[ИмяФлага] Тогда
		Элементы[Имя].ПодсказкаВвода = "";
	Иначе
		Объект[Имя] = ТекущиеЗначенияРеквизитов[Имя];
		Если ТипЗнч(ТекущиеЗначенияРеквизитов[Имя]) = Тип("Строка") Тогда
			Элементы[Имя].ПодсказкаВвода = ТекущиеЗначенияРеквизитов[Имя];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеЗначенияРеквизитов(ЗаполнитьДоступность=Ложь)
	
	Структура = СтруктураИзменяемыхРеквизитов();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДокумента.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ДанныеДокумента.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации) КАК ОсновноеСредство
		|ПОМЕСТИТЬ ДанныеДокумента
		|ИЗ
		|	&ДанныеДокумента КАК ДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
		|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ПервоначальныеСведенияОСБУ.СпособНачисленияАмортизации   КАК СпособНачисленияАмортизацииБУ,
		|	ПервоначальныеСведенияОСБУ.ЛиквидационнаяСтоимость   	 КАК ЛиквидационнаяСтоимость,
		|	ПервоначальныеСведенияОСНУ.СпособНачисленияАмортизацииНУ КАК СпособНачисленияАмортизацииНУ,
		|	ЕСТЬNULL(ГрафикиАмортизацииОСБУ.ГрафикАмортизации, ЗНАЧЕНИЕ(Справочник.ГодовыеГрафикиАмортизацииОС.ПустаяСсылка)) КАК ГрафикАмортизации,
		|	ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияБУ,
		|	ПараметрыАмортизацииОСБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемНаработкиБУ,
		|	ПараметрыАмортизацииОСНУ.СрокПолезногоИспользования КАК СрокИспользованияНУ,
		|	МестонахождениеОСБУ.Местонахождение КАК Подразделение,
		|	СпособыОтраженияРасходовПоАмортизацииОСБУ.СтатьяРасходов КАК СтатьяРасходов,
		|	СпособыОтраженияРасходовПоАмортизацииОСБУ.АналитикаРасходов КАК АналитикаРасходов,
		// |	СпособыОтраженияРасходовПоИмущественнымНалогам.СтатьяРасходов КАК СтатьяРасходовНалог,
		// |	СпособыОтраженияРасходовПоИмущественнымНалогам.АналитикаРасходов КАК АналитикаРасходовНалог,
		|	СчетаБухгалтерскогоУчета.СчетУчета КАК СчетУчета,
		|	СчетаБухгалтерскогоУчета.СчетНачисленияАмортизации КАК СчетАмортизации,
		|	1 КАК Коэффициент
		|ПОМЕСТИТЬ ТекущиеДанные
		|ИЗ
		|	ДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И (Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС
		|						ИЛИ Регистратор ССЫЛКА Документ.ВводОстатковВнеоборотныхАктивов)
		|					И Регистратор <> &ТекущийРегистратор) КАК ПервоначальныеСведенияОСБУ
		|		ПО ДанныеДокумента.ОсновноеСредство = ПервоначальныеСведенияОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет.СрезПоследних(
		|				&Дата,
		|				ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И (Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС
		|						ИЛИ Регистратор ССЫЛКА Документ.ВводОстатковВнеоборотныхАктивов)
		|					И Регистратор <> &ТекущийРегистратор) КАК ПервоначальныеСведенияОСНУ
		|		ПО ДанныеДокумента.ОсновноеСредство = ПервоначальныеСведенияОСНУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиАмортизацииОСБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК ГрафикиАмортизацииОСБУ
		|		ПО ДанныеДокумента.ОсновноеСредство = ГрафикиАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК ПараметрыАмортизацииОСБУ
		|		ПО ДанныеДокумента.ОсновноеСредство = ПараметрыАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСНалоговыйУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК ПараметрыАмортизацииОСНУ
		|		ПО ДанныеДокумента.ОсновноеСредство = ПараметрыАмортизацииОСНУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК СпособыОтраженияРасходовПоАмортизацииОСБУ
		|		ПО ДанныеДокумента.ОсновноеСредство = СпособыОтраженияРасходовПоАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК МестонахождениеОСБУ
		|		ПО ДанныеДокумента.ОсновноеСредство = МестонахождениеОСБУ.ОсновноеСредство
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОтраженияРасходовПоИмущественнымНалогам.СрезПоследних(
		//|				&Дата,
		//|				Организация = &Организация
		//|				И ОсновноеСредство В
		//|						(ВЫБРАТЬ
		//|							ДанныеДокумента.ОсновноеСредство
		//|						ИЗ
		//|							ДанныеДокумента КАК ДанныеДокумента)
		//|					И Регистратор <> &ТекущийРегистратор) КАК СпособыОтраженияРасходовПоИмущественнымНалогам
		//|		ПО ДанныеДокумента.ОсновноеСредство = СпособыОтраженияРасходовПоИмущественнымНалогам.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|				&Дата,
		|				Организация = &Организация
		|				И ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК СчетаБухгалтерскогоУчета
		|		ПО ДанныеДокумента.ОсновноеСредство = СчетаБухгалтерскогоУчета.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекущиеДанные.НомерСтроки,
		|	ТекущиеДанные.ИнвентарныйНомер,
		|	ТекущиеДанные.ГрафикАмортизации,
		|	ТекущиеДанные.СрокИспользованияБУ,
		|	ТекущиеДанные.ОбъемНаработкиБУ,
		|	ТекущиеДанные.СпособНачисленияАмортизацииБУ,
		|	ТекущиеДанные.ЛиквидационнаяСтоимость,
		|	ТекущиеДанные.СпособНачисленияАмортизацииНУ,
		|	ТекущиеДанные.СрокИспользованияНУ,
		|	ТекущиеДанные.Подразделение,
		|	ТекущиеДанные.СтатьяРасходов,
		|	ТекущиеДанные.АналитикаРасходов,
		|	ТекущиеДанные.СчетУчета,
		|	ТекущиеДанные.СчетАмортизации
		|ИЗ
		|	ТекущиеДанные КАК ТекущиеДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТекущиеДанные.СчетУчета) КАК СчетУчета,
		|	МАКСИМУМ(ТекущиеДанные.СчетАмортизации) КАК СчетАмортизации,
		|	МАКСИМУМ(ТекущиеДанные.ГрафикАмортизации) КАК ГрафикАмортизации,
		|	МАКСИМУМ(ТекущиеДанные.СрокИспользованияБУ) КАК СрокИспользованияБУ,
		|	МАКСИМУМ(ТекущиеДанные.ОбъемНаработкиБУ) КАК ОбъемНаработкиБУ,
		|	МАКСИМУМ(ТекущиеДанные.СпособНачисленияАмортизацииБУ) КАК СпособНачисленияАмортизацииБУ,
		|	МАКСИМУМ(ТекущиеДанные.ЛиквидационнаяСтоимость) 	  КАК ЛиквидационнаяСтоимость,
		|	МАКСИМУМ(ТекущиеДанные.СпособНачисленияАмортизацииНУ) КАК СпособНачисленияАмортизацииНУ,
		|	МАКСИМУМ(ТекущиеДанные.СрокИспользованияНУ) КАК СрокИспользованияНУ,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетУчета) КАК СчетУчетаКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетАмортизации) КАК СчетАмортизацииКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ГрафикАмортизации) КАК ГрафикАмортизацииКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СрокИспользованияБУ) КАК СрокИспользованияБУКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ОбъемНаработкиБУ) КАК ОбъемНаработкиБУКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СпособНачисленияАмортизацииБУ) КАК СпособНачисленияАмортизацииБУКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ЛиквидационнаяСтоимость)		  КАК ЛиквидационнаяСтоимостьКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СпособНачисленияАмортизацииНУ) КАК СпособНачисленияАмортизацииНУКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СрокИспользованияНУ) КАК СрокИспользованияНУКоличествоРазличных
		|ИЗ
		|	ТекущиеДанные КАК ТекущиеДанные");
	
	Запрос.УстановитьПараметр("Дата", Новый Граница(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ДанныеДокумента", Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"));
	Запрос.УстановитьПараметр("ТекущийРегистратор", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не Результат[3].Пустой() Тогда
		Выборка = Результат[3].Выбрать();
		Выборка.Следующий();
		Для Каждого КлючИЗначение Из Структура Цикл
			Имя = КлючИЗначение.Ключ;
			Если Выборка[Имя+"КоличествоРазличных"] > 1 Тогда
				Структура[Имя] = СтрЗаменить(НСтр("ru='% различных';uk='% '"), "%", Формат(Выборка[Имя+"КоличествоРазличных"], "ЧЦ=1; ЧГ=0"));
			Иначе
				Структура[Имя] = Выборка[Имя];
			КонецЕсли;
		КонецЦикла;
		
		
	КонецЕсли;
	
	Если ЗаполнитьДоступность И Не Результат[2].Пустой() Тогда
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.ОС[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Структура Цикл
		Имя = КлючИЗначение.Ключ;
		Если Не Объект[Имя+"Флаг"] Тогда
			Объект[Имя] = Структура[Имя];
			Если ТипЗнч(Структура[Имя]) = Тип("Строка") Тогда
				Элементы[Имя].ПодсказкаВвода = Структура[Имя];
			КонецЕсли;
		КонецЕсли;
		Если ЗаполнитьДоступность Тогда
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Имя, "Доступность", Объект[Имя + "Флаг"]);
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОС"+Имя, "Видимость", Объект[Имя + "Флаг"]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗаполнитьДоступность Тогда
		Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
		Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
		Элементы.ОтражениеАмортизационныхРасходов.АвтоОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг;
		Элементы.ОСОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
		
		Если Не Объект.СрокИспользованияБУФлаг Тогда
			СрокИспользованияБУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
				Объект.СрокИспользованияБУ);
		КонецЕсли;
		Если Не Объект.СрокИспользованияНУФлаг Тогда
			СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
				Объект.СрокИспользованияНУ);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущиеЗначенияРеквизитов = Новый ФиксированнаяСтруктура(Структура);
	
	ОбновитьТекущиеЗначения = Ложь;
	
	Если Элементы.ГрафикАмортизации.ПодсказкаВвода = "" Тогда
		Элементы.ГрафикАмортизации.ПодсказкаВвода = НСтр("ru='<без графика>';uk='<без графіка>'")
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураИзменяемыхРеквизитов()
	
	Возврат Новый Структура(
		"СчетУчета, СчетАмортизации,
		|ГрафикАмортизации, СрокИспользованияБУ, СрокИспользованияНУ,
	    | СпособНачисленияАмортизацииБУ, СпособНачисленияАмортизацииНУ, ЛиквидационнаяСтоимость,
		|ОбъемНаработкиБУ");
		
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустыеЗначенияРеквизитовОсновногоСредства()
	
	Возврат Новый Структура(
		"ИнвентарныйНомер, СчетУчета, СчетАмортизации,
		|ГрафикАмортизации, СрокИспользованияБУ, СрокИспользованияНУ,
	    | СпособНачисленияАмортизацииБУ, СпособНачисленияАмортизацииНУ, ЛиквидационнаяСтоимость,
		|ОбъемНаработкиБУ");
		
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекущиеЗначенияРеквизитовОсновногоСредства(ОсновноеСредство, Дата, Организация)
	
	Структура = ПустыеЗначенияРеквизитовОсновногоСредства();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПервоначальныеСведенияОСБУ.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета КАК СчетУчета,
		|	СчетаБухгалтерскогоУчетаОС.СчетНачисленияАмортизации КАК СчетАмортизации,
		|	ГрафикиАмортизацииОСБУ.ГрафикАмортизации КАК ГрафикАмортизации,
		|	ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияБУ,
		|	ПараметрыАмортизацииОСБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемНаработкиБУ,
		|	ПервоначальныеСведенияОСБУ.СпособНачисленияАмортизации   КАК СпособНачисленияАмортизацииБУ,
		|	ПервоначальныеСведенияОСБУ.ЛиквидационнаяСтоимость   	 КАК ЛиквидационнаяСтоимость,
		|	ПервоначальныеСведенияОСНУ.СпособНачисленияАмортизацииНУ КАК СпособНачисленияАмортизацииНУ,
		|	ПараметрыАмортизацииОСНУ.СрокПолезногоИспользования КАК СрокИспользованияНУ
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&Дата, ОсновноеСредство В (&ОсновноеСредство)) КАК ПервоначальныеСведенияОСБУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ПервоначальныеСведенияОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиАмортизацииОСБухгалтерскийУчет.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК ГрафикиАмортизацииОСБУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ГрафикиАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК ПараметрыАмортизацииОСБУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ПараметрыАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСНалоговыйУчет.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК ПараметрыАмортизацииОСНУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ПараметрыАмортизацииОСНУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК ПервоначальныеСведенияОСНУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ПервоначальныеСведенияОСНУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК СчетаБухгалтерскогоУчетаОС
		|		ПО ОбъектыЭксплуатации.Ссылка = СчетаБухгалтерскогоУчетаОС.ОсновноеСредство
		|ГДЕ
		|	ОбъектыЭксплуатации.Ссылка = &ОсновноеСредство");
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Структура;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(Структура, Выборка);
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ЦветФонаФормы = ЦветаСтиля.ЦветФонаФормы;
	ЦветФонаПоля = ЦветаСтиля.ЦветФонаПоля;
	
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ОтражениеАмортизационныхРасходов,
		"СтатьяРасходов, АналитикаРасходов");
	ЗаполнитьСпискиСпособовАмортизации();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиСпособовАмортизации()
	
	Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокСпособовАмортизации());
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокСпособовАмортизации(Ложь));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УчетОСВызовСервера.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);
	
КонецПроцедуры

Функция ПолучитьСписокСпособовАмортизации(СписокСпособовБУ=Истина) Экспорт
	
	СписокПеречисления = Новый Массив;
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Линейный);
	
	Если СписокСпособовБУ Тогда
		СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции);
	КонецЕсли; 		
				
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный);		
	
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._50_50);
	СписокПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._100);
	
	Возврат СписокПеречисления;
	
КонецФункции


&НаСервере
Процедура УстановитьДоступностьПередачиАмортизационныхРасходов() Экспорт
	
	ЕстьСвязанныеОрганизации = Справочники.Организации.ОрганизацияВзаимосвязанаСДругимиОрганизациями(Объект.Организация);
	Элементы.ГруппаПередачаРасходовПоАмортизации.Видимость = ЕстьСвязанныеОрганизации;
	
КонецПроцедуры




#КонецОбласти
