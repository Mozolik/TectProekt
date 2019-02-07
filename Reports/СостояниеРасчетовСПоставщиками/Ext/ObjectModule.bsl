﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ПараметрыОтчет")
			И Параметры.ПараметрыОтчет.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСПоставщиком" Тогда
			
			СформироватьПараметрыСостояниеРасчетовСПоставщиком(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "СостояниеРасчетовСПоставщикомПоДокументам" Тогда
			
			ПараметрКоманды = Параметры.ПараметрКоманды;
			
			СтруктураНастроек = ПолучитьСтруктуруНастроек(ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;
			СтрокаБазовая = ?(ЗначенияФункциональныхОпций.БазоваяВерсия, "Базовая", "");
			
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
			
			ЭтаФорма.ФормаПараметры.Отбор = СтруктураНастроек.СтруктураОтборов;
			
			Параметры.КлючВарианта = "СостояниеРасчетовПоОбъектуРасчетовКонтекст" + СтрокаБазовая;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	ВзаиморасчетыСервер.ЗаменитьДокументыРасчетовСПоставщиками(ФормаПараметры);

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеПользовательскихНастроекНаСервере
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
	//++ НЕ УТ
	Пакет = СхемаКомпоновкиДанных.НаборыДанных.Расчеты.Элементы.ОстаткиРасчетов;
	Пакет.Запрос = СтрЗаменить(Пакет.Запрос,
		"ДокЗП КАК ДанныеДокумента",
		"Документ.ЗаказПереработчику КАК ДанныеДокумента");
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
	
Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВЗакупках") Тогда
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "АвансДоПодтверждения");
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВЗакупках") Тогда
		КомпоновкаДанныхСервер.ОтключитьВыбранноеПолеВПользовательскихНастройках(КомпоновщикНастроекФормы, "АвансДоПодтверждения");
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПараметрыСостояниеРасчетовСПоставщиком(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ЭтоМассив Тогда
		ЕстьПодчиненныеПартнеры = Ложь;
		Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
			Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
				ЕстьПодчиненныеПартнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
	КонецЕсли;
	
	СтрокаБазовая = ?(ПолучитьФункциональнуюОпцию("БазоваяВерсия"), "Базовая", "");
	
	Если ЕстьПодчиненныеПартнеры Тогда
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		Если ЭтоМассив Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
		Иначе
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ЭлементОтбора.ПравоеЗначение = ПараметрКоманды;
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
		Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		
		Параметры.КлючВарианта = "СостояниеРасчетовСПоставщикамиКонтекст" + СтрокаБазовая;
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			Параметры.КлючВарианта = "СостояниеРасчетовСПоставщикомКонтекст" + СтрокаБазовая;
		Иначе
			Параметры.КлючВарианта = "СостояниеРасчетовСПоставщикамиКонтекст" + СтрокаБазовая;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСтруктуруНастроек(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура;
	ЗначенияФункциональныхОпций.Вставить("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
	Типы.Добавить(Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	Типы.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыУПоставщика"));
	//++ НЕ УТ
	Типы.Добавить(Тип("ДокументСсылка.ЗаказПереработчику"));
	Типы.Добавить(Тип("ДокументСсылка.ОтчетПереработчика"));
	//-- НЕ УТ
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	СтруктураНастроек.Вставить("СтруктураОтборов",
	                           ВзаиморасчетыСервер.СтруктураОтборовОтчетовРасчетыСКлиентами(ПараметрКоманды,
	                                                                                        "СостояниеРасчетовСПоставщиками",
	                                                                                        "СостояниеРасчетовСПоставщикомПоДокументам",
	                                                                                        Типы));
	Возврат СтруктураНастроек
	
КонецФункции

#КонецОбласти

#КонецЕсли