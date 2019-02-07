﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтветственныйОтбор.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.РазрешениеНаЗаменуМатериалов));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокРазрешений, "ОтборПоНоменклатуре", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокРазрешений, "РазрешенияНоменклатура", Справочники.Номенклатура.ПустаяСсылка());
		
	Если Параметры.Свойство("Основание") Тогда
		
		Если ТипЗнч(Параметры.Основание) = Тип("СправочникСсылка.Номенклатура") Тогда
			Номенклатура = Параметры.Основание;
			УстановитьОтборПоНоменклатуре();
			
			Элементы.НоменклатураОтбор.Видимость		= Ложь;
			
		ИначеЕсли ТипЗнч(Параметры.Основание) = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
			Спецификация = Параметры.Основание;
			УстановитьОтборПоСпецификации();
			
			Элементы.СпецификацияОтбор.Видимость		= Ложь;
			
		КонецЕсли;
		
	КонецЕсли;

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	УстановитьОтборПоСтатусу();
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияОтборПриИзменении(Элемент)
	УстановитьОтборПоСпецификации();
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	УстановитьОтборПоНоменклатуре();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	УстановитьОтборПоОтветственному();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование и НЕ Номенклатура.Пустая() и Спецификация.Пустая() Тогда
		
		Отказ = Истина;
		
		Основание = Новый Структура;
		
		Основание.Вставить("Материал", Номенклатура);
		
		ПараметрыФормы = Новый Структура("Основание", Основание);
		
		ОткрытьФорму("Документ.РазрешениеНаЗаменуМатериалов.ФормаОбъекта", ПараметрыФормы, , Истина);
		
	КонецЕсли;
	
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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Номер.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УказаниеПоПрименению.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаНачалаДействия.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаОкончанияДействия.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ответственный.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ответственный.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРазрешений.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыРазрешенийНаЗаменуМатериалов.Прекращено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеактуальногоСписка);
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтатусу()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРазрешений,
		"Статус",
		Статус,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСпецификации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРазрешений,
		"Спецификация",
		Спецификация,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Спецификация));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОтветственному()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРазрешений,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоНоменклатуре()
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокРазрешений, "ОтборПоНоменклатуре", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокРазрешений, "РазрешенияНоменклатура", Номенклатура);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокРазрешений, "ОтборПоНоменклатуре", Ложь);
	КонецЕсли;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Аналог);
	СписокЗначений.Добавить(Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Изделие);
	СписокЗначений.Добавить(Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Материал);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокРазрешений,
		"ИспользуетсяКак",
		СписокЗначений,
		ВидСравненияКомпоновкиДанных.ВСписке,
		, // Представление - автоматически
		ЗначениеЗаполнено(Номенклатура));
	
КонецПроцедуры

#КонецОбласти
