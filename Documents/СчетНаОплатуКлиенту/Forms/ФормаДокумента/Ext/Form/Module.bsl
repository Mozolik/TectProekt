﻿&НаКлиенте
Перем ОтветПередЗаписью;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ДенежныеСредстваСервер.УстановитьВидимостьОплатыПлатежнойКартой(Элементы.ФормаОплаты);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		Если Параметры.Свойство("Основание") Тогда
			Основание = Параметры.Основание;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Видимость", ЗначениеЗаполнено(Объект.ДокументОснование));
	
	// Подсистема "ЭлектронныеДокументы"
	УстановитьТекстСостоянияЭДНаСервере();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// КомандыЭДО
	ОбменСКонтрагентами.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюЭДО);
	// Конец КомандыЭДО
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Объект.Ссылка);
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьСчетНаОплату(МассивСсылок);
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФинансыКлиент.ПроверитьЗаполнениеДокументаНаОсновании(
			Объект,
			Основание);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ТребуетсяОткрытиеПечатнойФормы = Истина;
		Возврат;
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СуммаЭтаповОплаты = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
		
		Если Объект.СуммаДокумента = 0 Тогда
			
			Объект.СуммаДокумента = СуммаЭтаповОплаты;
			
		ИначеЕсли НЕ ОтветПередЗаписью и Объект.СуммаДокумента <> СуммаЭтаповОплаты Тогда
			Отказ = Истина;
			ТекстВопроса = НСтр("ru='Сумма этапов графика оплаты не совпадает с суммой документа. Скорректировать сумму этапов оплаты?';uk='Сума етапів графіка оплати не збігається з сумою документа. Скоригувати суму етапів оплати?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
		Записать();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// Подсистема "ЭлектронныеДокументы"
	УстановитьТекстСостоянияЭДНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		УстановитьТекстСостоянияЭДНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНазначениеПлатежа(Команда)
	ЗаполнитьНазначениеПлатежа();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетНаОплатуКлиенту.Форма.РеквизитыПечати" Тогда
		
		Если ВыбранноеЗначение <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормаОплатыПриИзменении(Элемент)

	ПриИзмененииФормыОплатыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПриИзменении(Элемент)
	
	Если Не Объект.ЧастичнаяОплата И ЗначениеЗаполнено(ОБъект.ДокументОснование) Тогда
		Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
			ОтветНаВопрос = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ЧастичнаяОплатаПриИзмененииЗавершение", ЭтотОбъект), НСтр("ru='Таблица этапов оплаты будет заполнена по основанию. Продолжить?';uk='Таблиця етапів оплати буде заповнена по підставі. Продовжити?'"), РежимДиалогаВопрос.ДаНет);
            Возврат;
		КонецЕсли;
		ЗаполнитьЭтапыОплатыПоОснованиюСервер();

	Иначе
		УстановитьДоступностьЭлементовПоЧастичнойОплате();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ОтветНаВопрос = РезультатВопроса;
    Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
        Объект.ЧастичнаяОплата = Истина;
        Возврат;
    КонецЕсли;
    
    ЗаполнитьЭтапыОплатыПоОснованиюСервер();

КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЭДНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСКонтрагентамиКлиент.ОткрытьДеревоЭД(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭтапыГрафикаОплаты

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	
	ЭтапыОплатыКлиент.ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)

	ЭтапыОплатыКлиент.ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РеквизитыПечати(Команда)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Дата",							 	Объект.Дата);
	СтруктураПараметров.Вставить("Организация", 						Объект.Организация);
	СтруктураПараметров.Вставить("ПредставительОрганизации", 			Объект.ПредставительОрганизации);
	СтруктураПараметров.Вставить("ПредставительОрганизацииДолжность", 	Объект.ПредставительОрганизацииДолжность);
	
	ОткрытьФорму("Документ.СчетНаОплатуКлиенту.Форма.РеквизитыПечати", СтруктураПараметров, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

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
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура НастроитьПодпискуНаОповещения(Команда)
	
	ТипыСобытий = Новый Массив();
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.ВыпискаСчета"));
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.АннулированиеСчета"));
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.ИзменениеСчета"));
	
	РассылкиИОповещенияКлиентамКлиент.НастроитьПодпискуНаОповещенияИзОбъекта(
		Объект.Партнер,
		ТипыСобытий);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплаты.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыНомерСтроки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыДатаПлатежа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыСуммаПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЧастичнаяОплата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыДатаПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ДатаЗаполненаНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.НомерСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Seagreen);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ЭтоЗалогЗаТару");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<залог за тару>';uk='<застава за тару>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область ПодсистемаЭлектронныедокументы

&НаСервере
Процедура УстановитьТекстСостоянияЭДНаСервере()
	
	ТекстСостоянияЭД = ОбменСКонтрагентамиКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	Элементы.ЧастичнаяОплата.Видимость = ТипЗнч(Объект.ДокументОснование) <> Тип("СправочникСсылка.ДоговорыКонтрагентов");
	
	ТипыСобытий = Новый Массив();
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.ВыпискаСчета);
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.АннулированиеСчета);
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.ИзменениеСчета);
	
	РассылкиИОповещенияКлиентам.УстановитьВидимостьПодпискиНаОповещенияВОбъекте(
		Элементы.ГруппаПодпискаНаОповещения,
		Объект.Партнер,
		ТипыСобытий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(Форма)
	
	ПроцентПлатежейОбщий = 0;
	ПредыдущееЗначениеДаты = Дата(1, 1, 1);
	Форма.НомерСтрокиПолнойОплаты = 0;
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаОплаты Цикл
		ПроцентПлатежейОбщий = ПроцентПлатежейОбщий + ТекСтрока.ПроцентПлатежа;
		ТекСтрока.ПроцентЗаполненНеВерно = (ПроцентПлатежейОбщий > 100);
		ТекСтрока.ДатаЗаполненаНеВерно = (ПредыдущееЗначениеДаты > ТекСтрока.ДатаПлатежа);
		ПредыдущееЗначениеДаты = ТекСтрока.ДатаПлатежа;
		Если ПроцентПлатежейОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ЛюбаяОплата      = Не ЗначениеЗаполнено(Объект.ФормаОплаты);
	ДоступностьКассы = ЛюбаяОплата Или (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная);
	ДоступностьСчета = ЛюбаяОплата Или (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Касса", "Доступность", ДоступностьКассы);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БанковскийСчет", "Доступность", ДоступностьСчета);
	
	УстановитьПривилегированныйРежим(Истина);
	Если ТипЗнч(Объект.ДокументОснование) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
	 //++ НЕ УТКА
	 Или ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетДавальцу")
	 Или ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказДавальца")
	 //-- НЕ УТКА
	 Тогда
		Соглашение = Неопределено;
	Иначе
		Соглашение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Соглашение");
	КонецЕсли;
	
	Если ТипЗнч(Соглашение) = Тип("СправочникСсылка.СоглашенияСКлиентами")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ИспользуютсяДоговорыКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	Иначе
		ИспользуютсяДоговорыКонтрагентов =
			ЗначениеЗаполнено(Соглашение)
			И ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов");
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Договор", "Видимость", ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииФормыОплатыСервер()
	
	УправлениеЭлементамиФормы();
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Объект.Организация;
	СтруктураПараметров.БанковскийСчет		= Объект.БанковскийСчет;
	Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоЧастичнойОплате()
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ЭтапыГрафикаОплаты");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СуммаДокумента", "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭтапыОплатыПоОснованиюСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	1 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|	И ЭтапыОплаты.СуммаПлатежа <> 0
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	2 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентЗалогаЗаТару КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаЗалогаЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|	И ЭтапыОплаты.Ссылка.ТребуетсяЗалогЗаТару
			|	И ЭтапыОплаты.СуммаЗалогаЗаТару <> 0
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПлатежа,
			|	Порядок
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	1 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	2 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентЗалогаЗаТару КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаЗалогаЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПлатежа,
			|	Порядок
			|";
		
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	1 КАК НомерСтроки,
			|	ДанныеДокумента.Дата КАК ДатаПлатежа,
			|	0 КАК ПроцентПлатежа,
			|	ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|	И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|	И ДанныеДокумента.СуммаПредоплатыЗаТару > 0
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	2 КАК НомерСтроки,
			|	ДанныеДокумента.Дата КАК ДатаПлатежа,
			|	
			|	(ДанныеДокумента.СуммаПредоплаты - ДанныеДокумента.СуммаПредоплатыЗаТару)
			|		/ (ДанныеДокумента.СуммаВзаиморасчетов - ЕСТЬNULL(СУММА(Тара.СуммаВзаиморасчетов), 0)) * 100 КАК ПроцентПлатежа,
			|	
			|	ДанныеДокумента.СуммаПредоплаты - ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|	И ДанныеДокумента.СуммаПредоплаты > ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	3 КАК НомерСтроки,
			|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
			|	0 КАК ПроцентПлатежа,
			|	
			|	СУММА(Тара.СуммаВзаиморасчетов) - ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ИМЕЮЩИЕ
			|	СУММА(Тара.СуммаВзаиморасчетов) > ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	4 КАК НомерСтроки,
			|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
			|	
			|	(ДанныеДокумента.СуммаВзаиморасчетов - ЕСТЬNULL(СУММА(Тара.СуммаВзаиморасчетов), 0)
			|		- ДанныеДокумента.СуммаПредоплаты + ДанныеДокумента.СуммаПредоплатыЗаТару)
			|		/ (ДанныеДокумента.СуммаВзаиморасчетов - ЕСТЬNULL(СУММА(Тара.СуммаВзаиморасчетов), 0)) * 100 КАК ПроцентПлатежа,
			|	
			|	ДанныеДокумента.СуммаВзаиморасчетов - ЕСТЬNULL(СУММА(Тара.СуммаВзаиморасчетов), 0) 
			|		- ДанныеДокумента.СуммаПредоплаты + ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ИМЕЮЩИЕ
			|	ДанныеДокумента.СуммаВзаиморасчетов - ДанныеДокумента.СуммаПредоплаты
			|		> ЕСТЬNULL(СУММА(Тара.СуммаВзаиморасчетов), 0) - ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка,
			|	НомерСтроки
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа         КАК ДатаПлатежа,
			|	100                                 КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаВознаграждения КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомитенту КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионера КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионераОСписании КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	Иначе
		ТекстЗапроса = "";
	КонецЕсли;
	
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			
			Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
				Объект.ЭтапыГрафикаОплаты.Очистить();
			КонецЕсли;
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НовыйЭтап = Объект.ЭтапыГрафикаОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйЭтап, Выборка);
			КонецЦикла;
			
			Объект.СуммаДокумента = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНазначениеПлатежа()
	
	ДокументОснование = Объект.ДокументОснование;
	
	Если НЕ ПустаяСтрока(ДокументОснование) Тогда
		Объект.НазначениеПлатежа = Документы.СчетНаОплатуКлиенту.СформироватьНазначениеПлатежа(
			ДокументОснование.Номер,
			ДокументОснование);
	Иначе
		НазначениеПлатежа = НСтр("ru='По счету № %НомерСчета% от %ДатаСчета%';uk='За рахунком № %НомерСчета% від %ДатаСчета%'");
		НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа, 
			"%НомерСчета%", 
		ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Объект.Номер));
		НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа, "%ДатаСчета%", Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
		Объект.НазначениеПлатежа = НазначениеПлатежа;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ОтветПередЗаписью = Ложь;