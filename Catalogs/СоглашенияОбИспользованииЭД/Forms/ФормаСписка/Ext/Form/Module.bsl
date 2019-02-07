﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("РаботаСЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		ЭтаФорма.РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	Если Параметры.Свойство("НеОтображатьБыстрыеОтборы") Тогда
		Элементы.ГруппаБыстрыеОтборы.Видимость = Ложь;
	КонецЕсли;
	
	Контрагент = Параметры.Контрагент;
	ПрофильНастроекЭДО = Параметры.ПрофильНастроекЭДО;
	Организация = Параметры.Организация;
	
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокСоглашенийСКонтрагентами.Отбор, "Контрагент",
			Контрагент, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	Если ОбменСКонтрагентамиПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Тогда
		
		СписокСоглашенийСКонтрагентами.ТекстЗапроса = СтрЗаменить(
			СписокСоглашенийСКонтрагентами.ТекстЗапроса, """Партнер""", "Соглашение.Контрагент.Партнер");
		Если ЗначениеЗаполнено(Параметры.Партнер) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокСоглашенийСКонтрагентами.Отбор, "Партнер",
				Параметры.Партнер, ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;
	Иначе
		СписокСоглашенийСКонтрагентами.ТекстЗапроса = СтрЗаменить(
			СписокСоглашенийСКонтрагентами.ТекстЗапроса, """Партнер"" КАК Партнер,", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
		ИЛИ ЗначениеЗаполнено(ПрофильНастроекЭДО)
		ИЛИ ЗначениеЗаполнено(Параметры.Партнер)
		ИЛИ Параметры.НастройкиЭДОСКонтрагентами Тогда
		
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = НСтр("ru='Настройки ЭДО с контрагентами';uk='Настройки ЕДО з контрагентами'");
		Элементы.ГруппаСоглашения.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаСоглашения.ТекущаяСтраница = Элементы.ГруппаНастроек;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокСоглашенийСКонтрагентами.Отбор, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокСоглашенийМеждуОрганизациями.Отбор, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	// Скроем группу "Всех соглашений" от пользователей с ограниченными правами или принудительно.
	СкрытьЗакладкуВсехСоглашений = Не Пользователи.ЭтоПолноправныйПользователь()
		ИЛИ ЗначениеЗаполнено(Параметры.Контрагент)
		ИЛИ ЗначениеЗаполнено(Параметры.Организация)
		ИЛИ ЗначениеЗаполнено(Параметры.ПрофильНастроекЭДО)
		ИЛИ ЗначениеЗаполнено(Параметры.Партнер)
		ИЛИ Параметры.НастройкиЭДОСКонтрагентами;
	
	Элементы.ГруппаВсеСоглашения.Видимость = Не СкрытьЗакладкуВсехСоглашений;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСКонтрагентамиСлужебныйКлиент.ЗаполнитьДанныеСлужбыПоддержки(ТелефонСлужбыПоддержки, АдресЭлектроннойПочтыСлужбыПоддержки);
	
	НастроитьОтображениеСтраниц();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.СписокСоглашенийСКонтрагентами.Обновить();
		
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант" Тогда
		
		Если Источник = "ИспользоватьОбменЭДМеждуОрганизациями" Тогда
			
			НастроитьОтображениеСтраниц();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборПоКонтрагенту(ЭтотОбъект, Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборПоОрганизации(ЭтотОбъект, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусуПодключения(ЭтотОбъект, СтатусПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеСоглашенияПриИзменении(Элемент)
	УстановитьОтборПоСостояниюСоглашения(ЭтотОбъект, СостояниеСоглашения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНастроекСКонтрагентами

&НаКлиенте
Процедура СоздатьЭлементСпискаНастроекСКонтрагентами(Команда)
	
	ПараметрыФормы = Новый Структура;
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	ЗначенияЗаполнения.Вставить("Контрагент", Контрагент);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыНастроекЭДО(Команда)
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ОбновитьСтатусыНастроекЗавершить", ЭтотОбъект);
	ОбменСКонтрагентамиСлужебныйКлиент.ПолучитьСоответствиеСоглашенийИПараметровСертификатов(ОбработкаОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыНастроекЗавершить(Результат, Контекст) Экспорт
	
	СоотвСоглашенийИСтруктурСертификатов = Неопределено;
	Если ТипЗнч(Результат) <> Тип("Структура")
		ИЛИ Не Результат.Свойство("СоответствиеПрофилейИПараметровСертификатов", СоотвСоглашенийИСтруктурСертификатов) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Выполняется получение информации о приглашениях. Подождите...';uk='Виконується отримання інформації про запрошення. Почекайте...'");
	Состояние(НСтр("ru='Получение.';uk='Отримання.'"), , ТекстСообщения);
	ОбменСКонтрагентамиСлужебныйВызовСервера.ОбновитьСтатусыПодключенияНастроекЭДО(СоотвСоглашенийИСтруктурСертификатов);
	
	Оповестить("ОбновитьСостояниеЭД");
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокИнтеркампани

&НаКлиенте
Процедура СписокИнтеркампаниПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Параметр = ?(Копирование, Новый Структура("ЗначениеКопирования", Элементы.СписокИнтеркампани.ТекущаяСтрока),
		Новый Структура);
	
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлементаИнтеркампани", Параметр,
		Элементы.СписокИнтеркампани);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСсылкуНаСтатьюПо1СБухфон(Команда)
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьИнструкциюПо1СБухфон();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоКонтрагенту(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"Контрагент",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОрганизации(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"Организация",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусуПодключения(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"СтатусПодключения",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСостояниюСоглашения(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"СостояниеСоглашения",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеСтраниц()
	
	ОтображатьЗакладки = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции(
				"ИспользоватьОбменЭДМеждуОрганизациями");
				
	Элементы.ГруппаВсеСоглашения.Видимость = ОтображатьЗакладки;
	Если ОтображатьЗакладки Тогда
		Элементы.ГруппаСоглашения.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ГруппаСоглашения.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
