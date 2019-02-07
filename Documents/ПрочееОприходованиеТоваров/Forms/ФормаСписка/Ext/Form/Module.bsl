﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Склад = Настройки.Получить("Склад");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад", Склад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Склад));
	Настройки.Удалить("Склад");
	
	ХозяйственнаяОперация = Настройки.Получить("ХозяйственнаяОперация");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ХозяйственнаяОперация",
		ХозяйственнаяОперация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ХозяйственнаяОперация));
	Настройки.Удалить("ХозяйственнаяОперация");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	СписокВыбора = Элементы.ХозяйственнаяОперация.СписокВыбора;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеИзПроизводства);
	Иначе
		Элементы.СписокСоздатьПоступлениеИзПроизводства.Видимость = Ложь;
	КонецЕсли;
	
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации);
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы);
	
	//++ НЕ УТ
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ПрочееПоступлениеТоваров);
	//-- НЕ УТ
	
	УстановитьВидимость();
	
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
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДата");


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

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад",
		Склад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Склад));
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ХозяйственнаяОперация",
		ХозяйственнаяОперация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ХозяйственнаяОперация));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСторноСписанияНаРасходы(Команда)
	
	СоздатьПрочееОприходованиеТоваров(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы"));
	
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
Процедура СоздатьВозвратИзЭксплуатации(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации");
	СоздатьПрочееОприходованиеТоваров(Операция);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеИзПроизводства(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеИзПроизводства");
	СоздатьПрочееОприходованиеТоваров(Операция);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееПоступлениеТоваров(Команда)
	
	//++ НЕ УТ
	СоздатьПрочееОприходованиеТоваров(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочееПоступлениеТоваров"));
	//-- НЕ УТ
	Возврат; // В УТ11 не используется
	
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

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПрочееОприходованиеТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимость()
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"СписокГруппаСоздать",
			"Видимость", 
			ПравоДоступа("Добавление", Метаданные.Документы.ПрочееОприходованиеТоваров));

	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееОприходованиеТоваров(Операция)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", Операция);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ЗначенияЗаполнения.Вставить("Склад", Склад);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ПрочееОприходованиеТоваров.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
