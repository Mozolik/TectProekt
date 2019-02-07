﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Параметры.ВидНоменклатуры) Тогда
		ВидНоменклатуры = Параметры.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ТекущаяСтрока,
			Новый Структура("ВидНоменклатуры","ВидНоменклатуры"));
			
		ВидНоменклатуры = РеквизитыСерии.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура,
			Новый Структура("ВидНоменклатуры","ВидНоменклатуры"));
			
		ВидНоменклатуры = РеквизитыНоменклатуры.ВидНоменклатуры;
	КонецЕсли;
	
	Элементы.ВидНоменклатуры.ТолькоПросмотр = ЗначениеЗаполнено(ВидНоменклатуры);
	
	НастроитьПоШаблону();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

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
			
			Номер = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр).Штрихкод;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номер", Номер, ВидСравненияКомпоновкиДанных.Содержит,,ЗначениеЗаполнено(Номер));
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номер", Номер, ВидСравненияКомпоновкиДанных.Содержит,,ЗначениеЗаполнено(Номер));
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ГоденДо", ГоденДо, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(ГоденДо));
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	НастроитьПоШаблону();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			ТекстПредупреждения = НСтр("ru='Перед добавлением серии необходимо указать вид номенклатуры.';uk='Перед додаванням серії необхідно вказати вид номенклатури.'");
			
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидНоменклатуры",ВидНоменклатуры);
		ЗначенияЗаполнения.Вставить("Номер",Номер);
		ЗначенияЗаполнения.Вставить("ГоденДо",ГоденДо);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура НастроитьПоШаблону()
	ВладелецСерий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		ПараметрыШаблона = Новый ФиксированнаяСтруктура(
					ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры));
		
		Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.Номер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
		
		Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
			Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			
			Элементы.СписокГоденДо.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.СписокНомер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
		
		ВладелецСерий = ПараметрыШаблона.ВладелецСерий;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"ВидНоменклатуры",
																			ВладелецСерий,
																			ВидСравненияКомпоновкиДанных.Равно,
																			,
																			Истина);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
