﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	ТолькоАктуальные = Истина;
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ПланЗакупок));
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Сценарий  = Настройки.Получить("Сценарий");
	Статус = Настройки.Получить("Статус");
	Ответственный = Настройки.Получить("Ответственный");
	ТолькоАктуальные = Настройки.Получить("ТолькоАктуальные");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСценарийПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТолькоАктуальныеПриИзменении(Элемент)
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура УстановитьСтатусВПодготовке(Команда)
	
	УстановитьСтатус("ВПодготовке", НСтр("ru='В подготовке';uk='У підготовці'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаУтверждении(Команда)
	
	УстановитьСтатус("НаУтверждении", НСтр("ru='На утверждении';uk='На затвердженні'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусУтвержден(Команда)
	
	УстановитьСтатус("Утвержден", НСтр("ru='Утвержден';uk='Затверджено'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	УстановитьСтатус("Отменен", НСтр("ru='Отменен';uk='Скасовано'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтатус(Статус, ТексСтатуса)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке планов будет установлен статус ""%Статус%"". По принятым в работу планам могут быть оформлены документы. Продолжить?';uk='У виділених у списку планів буде встановлено статус ""%Статус%"". За прийнятими в роботу планами можуть бути оформлені документи. Продовжити?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Статус%", ТексСтатуса);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Статус", Статус);
	ДополнительныеПараметры.Вставить("ТексСтатуса", ТексСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьСтатусЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
		ДополнительныеПараметры.ВыделенныеСтроки, 
		ДополнительныеПараметры.Статус);
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, 
		КоличествоОбработанных, 
		ДополнительныеПараметры.ВыделенныеСтроки.Количество(), 
		ДополнительныеПараметры.ТексСтатуса);
	
КонецПроцедуры

#КонецОбласти
