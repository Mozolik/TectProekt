﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	УстановитьУсловноеОформление();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриСозданииЧтенииНаСервере();
		
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ЗаполнитьДополнительныеРеквизитыНаработок(Объект.Наработки);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СохранитьДополнительныеРеквизитыНаработок(ТекущийОбъект.Наработки);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонОшибки = НСтр("ru='Не заполнена колонка ""Объект эксплуатации"" в строке %НомерСтроки% списка ""Наработки""';uk='Не заповнена колонка ""Об''єкт експлуатації"" в рядку %НомерСтроки% списку ""Напрацювання""'");
	
	Для Каждого СтрокаНаработки Из Объект.Наработки Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаНаработки.ОбъектФормы) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(ШаблонОшибки, "%НомерСтроки%", СтрокаНаработки.НомерСтроки),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Наработки", СтрокаНаработки.НомерСтроки, "ОбъектФормы"),,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

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


// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НаработкиОбъектФормы.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Наработки.ОбъектФормы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизитыНаработок(ДанныеЗаполнения, Строки=Неопределено)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	(ВЫРАЗИТЬ(ДанныеЗаполнения.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
		|	ДанныеЗаполнения.ОбъектЭксплуатации КАК ОбъектЭксплуатации
		|ПОМЕСТИТЬ ДанныеЗаполнения
		|ИЗ
		|	&ДанныеЗаполнения КАК ДанныеЗаполнения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеЗаполнения.ИндексСтроки,
		|	ЕСТЬNULL(Объекты.Ссылка, Узлы.Владелец) КАК ОбъектФормы,
		|	ЕСТЬNULL(Узлы.Ссылка, ЗНАЧЕНИЕ(Справочник.УзлыОбъектовЭксплуатации.ПустаяСсылка)) КАК УзелФормы
		|ИЗ
		|	ДанныеЗаполнения КАК ДанныеЗаполнения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ПО ДанныеЗаполнения.ОбъектЭксплуатации = Объекты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|		ПО ДанныеЗаполнения.ОбъектЭксплуатации = Узлы.Ссылка И (&ИспользоватьУзлы)");
	
	Запрос.УстановитьПараметр("ИспользоватьУзлы", ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации"));
	Запрос.УстановитьПараметр(
		"ДанныеЗаполнения",
		ДанныеЗаполнения.Выгрузить(
			Строки,
			"НомерСтроки, ОбъектЭксплуатации"));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(Объект.Наработки[Выборка.ИндексСтроки], Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДополнительныеРеквизитыНаработок(ТекущиеНаработки)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	(ВЫРАЗИТЬ(ДанныеЗаполнения.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
		|	ДанныеЗаполнения.ОбъектФормы КАК ОбъектФормы,
		|	ДанныеЗаполнения.УзелФормы КАК УзелФормы,
		|	ДанныеЗаполнения.ПоказательНаработки КАК ПоказательНаработки,
		|	ДанныеЗаполнения.Значение КАК Значение,
		|	ДанныеЗаполнения.СреднесуточноеЗначение КАК СреднесуточноеЗначение
		|ПОМЕСТИТЬ ДанныеЗаполнения
		|ИЗ
		|	&ДанныеЗаполнения КАК ДанныеЗаполнения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеЗаполнения.ИндексСтроки,
		|	ЕСТЬNULL(Узлы.Ссылка, Объекты.Ссылка) КАК ОбъектЭксплуатации,
		|	ДанныеЗаполнения.ПоказательНаработки КАК ПоказательНаработки,
		|	ДанныеЗаполнения.Значение КАК Значение,
		|	ДанныеЗаполнения.СреднесуточноеЗначение КАК СреднесуточноеЗначение
		|ИЗ
		|	ДанныеЗаполнения КАК ДанныеЗаполнения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ПО ДанныеЗаполнения.ОбъектФормы = Объекты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|		ПО ДанныеЗаполнения.УзелФормы = Узлы.Ссылка И (&ИспользоватьУзлы)");
	
	Запрос.УстановитьПараметр("ДанныеЗаполнения", Объект.Наработки.Выгрузить());
	Запрос.УстановитьПараметр("ИспользоватьУзлы", ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации"));
	
	ТекущиеНаработки.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьДополнительныеРеквизитыНаработок(Объект.Наработки);
	
КонецПроцедуры

#КонецОбласти
