﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Статус = "Все";
	
	СкладПомещениеПриИзмененииСервер();
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтандартныеДействияСписка);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании,,,Ложь);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладОтборПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеОтборПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьОтборыВСписках();
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	УстановитьОтборыВСписках();
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


&НаКлиенте
Процедура Подпитать(Команда)
	
	ОчиститьСообщения();
	Структура = Новый Структура;
	Структура.Вставить("Помещение",Помещение);
	Структура.Вставить("Склад",Склад);
	
	ФормаПараметры = Новый Структура("Заголовок ,Операция,ПараметрОбъект", "ОтборРазмещение", "ФормированиеЗаданий",Структура);  
	
	Ответ = Неопределено;
  
	
	ОткрытьФорму("Документ.ОтборРазмещениеТоваров.Форма.ФормаНастроек",ФормаПараметры,ЭтаФорма,,,, Новый ОписаниеОповещения("ПодпитатьЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодпитатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    
    Если Ответ = КодВозвратаДиалога.ОК Тогда
        
        ПодпитатьНаСервере();
        УстановитьОтборыВСписках();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВзятьЗаданияВРаботу(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВзятьЗаданияВРаботуЗавершение", ЭтотОбъект);
	
	СкладыКлиент.ВзятьЗаданияВРаботу(ЭтаФорма, Элементы.Список , "ОтборРазмещение", Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьЗаданияВРаботуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УстановитьОтборыВСписках();

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗадания(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьЗаданияЗавершение", ЭтотОбъект);
	
	СкладыКлиент.ОтметитьВыполненениеЗаданийБезОшибок(ЭтаФорма, Элементы.Список, "ОтборРазмещение", Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаданияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УстановитьОтборыВСписках();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаданиеНаПеремещение(Команда)
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Склад", Склад);
	ПараметрыЗаполнения.Вставить("Помещение", Помещение);
	ПараметрыЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийОтбораРазмещенияТоваров.Перемещение"));
	
	ОткрытьФорму("Документ.ОтборРазмещениеТоваров.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",ПараметрыЗаполнения), ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаданиеНаРазмещение(Команда)
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Склад", Склад);
	ПараметрыЗаполнения.Вставить("Помещение", Помещение);
	ПараметрыЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийОтбораРазмещенияТоваров.Размещение"));
	
	ОткрытьФорму("Документ.ОтборРазмещениеТоваров.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",ПараметрыЗаполнения), ЭтаФорма);
КонецПроцедуры

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

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()
	Элементы.ПомещениеОтбор.Видимость = СкладыСервер.ИспользоватьСкладскиеПомещения(Склад);
	Элементы.РабочийУчасток.Видимость = СкладыСервер.ИспользоватьРабочиеУчастки(Склад, Помещение);
	Элементы.СоздатьЗаданияНаПодпитку.Доступность = СкладыСервер.ИспользоватьПодпиткуЗонБыстрогоОтбора(Склад, Помещение);
	УстановитьОтборыВСписках();
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтборРазмещениеТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Подпитка
 
&НаСервере
Процедура УстановитьОтборыВСписках()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Помещение", Помещение,
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Склад", Склад,
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	Если Статус = "Все" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",,,,Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен",,,,Ложь);
	ИначеЕсли Статус = "Невыполненные" Тогда
		СписокСтатусов = Новый СписокЗначений;
		СписокСтатусов.Добавить(Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе);
		СписокСтатусов.Добавить(Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", СписокСтатусов, ВидСравненияКомпоновкиДанных.ВСписке,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "Подготовленные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "ВРаботе" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.ВРаботе, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "ВыполненныеСОшибками" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоСОшибками, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "ВыполненныеБезОшибок" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидОперации", ВидОперацииОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ВидОперацииОтбор));
	
КонецПроцедуры
 
 &НаСервере
 Процедура ПодпитатьНаСервере()
	 
	СтруктураПараметров = СкладыСервер.СтруктураПараметровСозданияЗаданийНаОтборПодпитку();
	СтруктураПараметров.Вставить("Склад", Склад);
	СтруктураПараметров.Вставить("Помещение", Помещение);
	СтруктураПараметров.Вставить("РабочийУчасток", РабочийУчасток);
	СтруктураПараметров.Вставить("НастройкаФормированияПоРабочимУчасткам", НастройкаФормированияПоРабочимУчасткам);
	СтруктураПараметров.Вставить("Исполнитель", Исполнитель);
	СтруктураПараметров.Вставить("ОграничениеПоВесу", ОграничениеПоВесу);
	СтруктураПараметров.Вставить("ОграничениеПоОбъему", ОграничениеПоОбъему);
	СтруктураПараметров.Вставить("ОграничиватьПоВесу", ОграничиватьПоВесу);
	СтруктураПараметров.Вставить("ОграничиватьПоОбъему", ОграничиватьПоОбъему);
	
	СкладыСервер.СоздатьЗаданияНаПодпитку(СтруктураПараметров);	

КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
