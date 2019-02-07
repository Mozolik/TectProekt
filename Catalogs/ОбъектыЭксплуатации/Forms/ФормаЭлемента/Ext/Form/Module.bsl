﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Ложь);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриСозданииЧтенииНаСервере();
		
	КонецЕсли;
	
	//++ НЕ УТКА
	Если Параметры.Свойство("СообщитьОбОшибках") И Параметры.СообщитьОбОшибках Тогда
		
		ВыполнитьПроверкуЗаполненияНаСервере();
		
	КонецЕсли;
	//-- НЕ УТКА
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, "ФормаОбъекта");
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты,, Ложь);
	
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	//++ НЕ УТКА
	Если ИспользоватьУправлениеРемонтами Тогда
		
		Если ПроверитьЗаполнениеПриЗаписи Тогда
			
			ВыполнитьПроверкуЗаполненияНаСервере(Отказ);
			
		КонецЕсли
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	
	ТекущийОбъект.ПараметрыУчетаНаработок.Загрузить(
		ПараметрыУчетаНаработок.Выгрузить( , "ПоказательНаработки, НазначенныйРесурс, Источник"));
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьЗаполнениеПриЗаписи = Ложь;
	ЕстьОшибкиВПодчиненных = Ложь;
	
	ЗаполнитьПараметрыОтображения(ТекущийОбъект);
	
	//++ НЕ УТКА
	ЗаполнитьПараметрыУчетаНаработок(ТекущийОбъект.ПараметрыУчетаНаработок, ТекущийОбъект.Класс);
	//-- НЕ УТКА
	
	УстановитьДоступностьЭлементовНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РазблокировкаОбъектаЭксплуатации" Тогда
		Если Параметр.ОбъектЭксплуатации = Объект.Ссылка Тогда
			Редактируется = Истина;
			ПодключитьОбработчикОжидания("Подключаемый_ОбновитьФорму", 1);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_КлассыОбъектовЭксплуатации" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьФорму", 1);
	КонецЕсли;
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕстьОшибкиВПодчиненныхНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//++ НЕ УТКА
	Если ЗначениеЗаполнено(УзелСОшибками) Тогда
		
		ОткрытьФорму(
			"Справочник.УзлыОбъектовЭксплуатации.ФормаОбъекта",
			Новый Структура(
				"Ключ, СообщитьОбОшибках",
				УзелСОшибками, Истина));
		
	Иначе
		
		ОткрытьФорму(
			"Отчет.КонтрольКорректностиЗаполненияОбъектовЭксплуатации.Форма",
			Новый Структура(
				"ОбъектЭксплуатации",
				Объект.Ссылка));
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Элементы.НаименованиеПолное.СписокВыбора.Очистить();
	Элементы.НаименованиеПолное.СписокВыбора.Добавить(Объект.Наименование);
	
	Если Не ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассПриИзменении(Элемент)
	
	КлассПриИзмененииНаСервере();
	ОчиститьСообщения();
	
КонецПроцедуры

&НаСервере
Процедура КлассПриИзмененииНаСервере()
	
	ОбновитьЭлементыДополнительныхРеквизитов();
	ИспользуютсяПодклассы = Ложь;
	
	//++ НЕ УТКА
	Если ЗначениеЗаполнено(Объект.Класс) Тогда
		ИспользуютсяПодклассы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Класс, "ИспользуютсяПодклассы");
		СоставРеквизитов.Загрузить(СоставРеквизитовПоКлассуОбъектаЭксплуатации());
	Иначе
		ИспользуютсяПодклассы = Ложь;
		СоставРеквизитов.Загрузить(Справочники.ОбъектыЭксплуатации.СоставРеквизитов());
	КонецЕсли;
	
	ЗаполнитьПараметрыУчетаНаработок(ПараметрыУчетаНаработок, Объект.Класс);
	//-- НЕ УТКА
	
	УстановитьДоступностьЭлементовНаСервере();
	//++ НЕ УТКА
	НастроитьЭлементыФормыПоКлассуОбъекта();
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПроверкуЗаполнения(Команда)
	
	//++ НЕ УТКА
	Отказ = Ложь;
	ВыполнитьПроверкуЗаполненияНаСервере(Отказ);
	Если Не Отказ Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Проверка выполнена';uk='Перевірка виконана'"),
			,
			НСтр("ru='Ошибок заполнения реквизитов не обнаружено';uk='Помилок заповнення реквізитів не виявлено'"),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	//-- НЕ УТКА
	
	Возврат; // Пустой обработчик для УТ и КА
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусВЭксплуатации(Команда)
	
	ПроверитьЗаполнениеПриЗаписи = Истина;
	УстановитьНовыйСтатусИЗаписать(СтатусВЭксплуатации);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЛиквидирован(Команда)
	
	ПроверитьЗаполнениеПриЗаписи = Истина;
	УстановитьНовыйСтатусИЗаписать(СтатусЛиквидирован);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусРедактируется(Команда)
	
	УстановитьНовыйСтатусИЗаписать(СтатусРедактируется);
	
КонецПроцедуры

#Область СтандартныеПодсистемы

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура УстановитьНовыйСтатусИЗаписать(Статус)
	
	ТекущийСтатус = Объект.Статус;
	Объект.Статус = Статус;
	
	Если Не Записать() Тогда
		Объект.Статус = ТекущийСтатус;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИспользоватьПроизводство = Ложь;
	ИспользоватьУправлениеРемонтами = Ложь;
	//++ НЕ УТКА
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	ИспользоватьУправлениеРемонтами = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами");
	//-- НЕ УТКА
	
	СтатусВЭксплуатации = Перечисления.СтатусыОбъектовЭксплуатации.ВЭксплуатации;
	СтатусЛиквидирован = Перечисления.СтатусыОбъектовЭксплуатации.Ликвидирован;
	СтатусРедактируется = Перечисления.СтатусыОбъектовЭксплуатации.Редактируется;
	ПроверитьЗаполнениеПриЗаписи = Ложь;
	ЕстьОшибкиВПодчиненных = Ложь;
	
	Элементы.НаименованиеПолное.СписокВыбора.Очистить();
	Элементы.НаименованиеПолное.СписокВыбора.Добавить(Объект.Наименование);
	
	ЗаполнитьПараметрыОтображения(Объект);
	
	//++ НЕ УТКА
	ЗаполнитьПараметрыУчетаНаработок(Объект.ПараметрыУчетаНаработок, Объект.Класс);
	//-- НЕ УТКА
	
	УстановитьДоступностьЭлементовНаСервере();
	
	//++ НЕ УТКА
	НастроитьЭлементыФормыПоКлассуОбъекта();
	//-- НЕ УТКА
	
	УказыватьНаправлениеВоВнеоборотныхАктивах = ЗначениеНастроекПовтИсп.УказыватьНаправлениеВоВнеоборотныхАктивах();
	Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = УказыватьНаправлениеВоВнеоборотныхАктивах;
	Элементы.НаправлениеДеятельности.ОтметкаНезаполненного = УказыватьНаправлениеВоВнеоборотныхАктивах И Не ЗначениеЗаполнено(Объект.НаправлениеДеятельности);
	
КонецПроцедуры

// Процедура обновления элементов дополнительных реквизитов объекта в форме
//
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Обработка установки доступности элементов формы
//
&НаСервере
Процедура УстановитьДоступностьЭлементовНаСервере()
	
	МассивЭлементов = Новый Массив();
	// Элементы управления шапки
	МассивЭлементов.Добавить("ДатаСведений");
	МассивЭлементов.Добавить("Родитель");
	МассивЭлементов.Добавить("Код");
	МассивЭлементов.Добавить("Наименование");
	МассивЭлементов.Добавить("НаименованиеПолное");
	МассивЭлементов.Добавить("ГруппаОсновныеРеквизиты");
	МассивЭлементов.Добавить("Описание");
	// Табличные части
	МассивЭлементов.Добавить("РабочиеЦентры");
	МассивЭлементов.Добавить("ПараметрыУчетаНаработок");
	
	// Дополнительные реквизиты
	МассивЭлементов.Добавить("ГруппаДополнительныеРеквизиты");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Не Редактируется);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подкласс", "Видимость", ИспользуютсяПодклассы);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаРабочиеЦентры", "Видимость", ИспользоватьПроизводство И ИспользоватьУправлениеРемонтами);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияКартинкаЕстьОшибкиПодчиненных", "Видимость", ЕстьОшибкиВПодчиненных);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УстановитьСтатусРедактируется", "Доступность", Объект.Статус<>СтатусРедактируется);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УстановитьСтатусВЭксплуатации", "Доступность", Объект.Статус<>СтатусВЭксплуатации);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УстановитьСтатусЛиквидирован", "Доступность", Объект.Статус<>СтатусЛиквидирован);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаПараметрыУчетаНаработок", "Видимость", ПараметрыУчетаНаработок.Количество()>0);
	
	Элементы.КоманднаяПанельСтатус.Видимость = ДоступноИзменениеСтатуса;
	
	Элементы.ГруппаСтатус.Видимость = ИспользоватьУправлениеРемонтами;
	
КонецПроцедуры

// Возвращает структуру с параметрами отображения элемента справочника в форме
//
&НаСервере
Процедура ЗаполнитьПараметрыОтображения(ОбъектЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтатусЗаписанногоОбъекта = ОбъектЗаполнения.Статус;
	
	Редактируется = (Не ИспользоватьУправлениеРемонтами) Или (Не ЗначениеЗаполнено(ОбъектЗаполнения.Статус) Или ОбъектЗаполнения.Статус = СтатусРедактируется);
	ИспользуютсяПодклассы = Ложь;
	//++ НЕ УТКА
	Если ИспользоватьУправлениеРемонтами И ЗначениеЗаполнено(Объект.Класс) Тогда
		ИспользуютсяПодклассы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектЗаполнения.Класс, "ИспользуютсяПодклассы");
		СоставРеквизитов.Загрузить(СоставРеквизитовПоКлассуОбъектаЭксплуатации());
	Иначе
		ИспользуютсяПодклассы = Ложь;
		СоставРеквизитов.Загрузить(Справочники.ОбъектыЭксплуатации.СоставРеквизитов());
	КонецЕсли;
	//-- НЕ УТКА
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ДоступноИзменениеСтатуса = ПравоДоступа("Изменение", Метаданные.Справочники.ОбъектыЭксплуатации);
	
КонецПроцедуры

//++ НЕ УТКА
&НаСервере
Процедура НастроитьЭлементыФормыПоКлассуОбъекта()
	
	Для Каждого Реквизит Из СоставРеквизитов Цикл
		
		Имя = СокрЛП(Реквизит.Имя);
		
		Элемент = Элементы.Найти(Имя);
		Если Элемент <> Неопределено Тогда
			
			Элемент.АвтоОтметкаНезаполненного = Реквизит.ОбязателенДляЗаполнения;
			Элемент.ОтметкаНезаполненного = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура проверки заполнения
//
&НаСервере
Процедура ВыполнитьПроверкуЗаполненияНаСервере(Отказ=Ложь)
	
	ПараметрыПроверки = Справочники.ОбъектыЭксплуатации.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.Форма = ЭтаФорма;
	ПараметрыПроверки.СообщатьОшибки = Ложь;
	
	Справочники.ОбъектыЭксплуатации.ПроверитьЗаполнение(Объект, ПараметрыПроверки, Отказ);
	
	Если Отказ Тогда
		
		ЕстьОшибкиВПодчиненных = ПараметрыПроверки.ОтказПроверкиУзлов;
		
		ОбъектыЭксплуатации.СообщитьОшибкиПроверкиЗаполнения(ПараметрыПроверки.ПотокОшибок);
		
	КонецЕсли;
	
	Если ЕстьОшибкиВПодчиненных Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Есть ошибки заполнения подчиненных узлов';uk='Є помилки заповнення підпорядкованих вузлів'"),
			,
			"ЕстьОшибкиВПодчиненных");
		
		УзелСОшибками = Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка();
		Если ПараметрыПроверки.ПараметрыПроверкиУзлов.ПотокОшибок.СчетчикОшибок.Количество() = 1 Тогда
			Для Каждого ОбъектОшибок Из ПараметрыПроверки.ПараметрыПроверкиУзлов.ПотокОшибок.СчетчикОшибок Цикл
				УзелСОшибками = ОбъектОшибок.Ключ;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияКартинкаЕстьОшибкиПодчиненных",
		"Видимость",
		ЕстьОшибкиВПодчиненных);
	
КонецПроцедуры

&НаСервере
Функция СоставРеквизитовПоКлассуОбъектаЭксплуатации()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(СоставРеквизитов.Имя КАК СТРОКА(255)) КАК Имя,
		|	ВЫРАЗИТЬ(СоставРеквизитов.Синоним КАК СТРОКА(255)) КАК Синоним,
		|	ВЫРАЗИТЬ(СоставРеквизитов.ОбязателенДляЗаполнения КАК БУЛЕВО) КАК ОбязателенДляЗаполнения,
		|	ВЫРАЗИТЬ(СоставРеквизитов.ТолькоПросмотрОбязательности КАК БУЛЕВО) КАК ТолькоПросмотрОбязательности
		|ПОМЕСТИТЬ РеквизитыОбъектов
		|ИЗ
		|	&СоставРеквизитовОбъекта КАК СоставРеквизитов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Реквизиты.ИмяРеквизита КАК Имя,
		|	Реквизиты.ОбязателенДляЗаполнения КАК ОбязателенДляЗаполнения
		|ПОМЕСТИТЬ РеквизитыОбъектовКласса
		|ИЗ
		|	Справочник.КлассыОбъектовЭксплуатации.РеквизитыДляКонтроля КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Класс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(Реквизиты.Имя, РеквизитыДляКонтроляОбъектов.Имя) КАК Имя,
		|	ЕСТЬNULL(Реквизиты.ОбязателенДляЗаполнения, ЛОЖЬ) КАК ОбязателенДляЗаполнения
		|ИЗ
		|	РеквизитыОбъектовКласса КАК Реквизиты
		|		ПОЛНОЕ СОЕДИНЕНИЕ РеквизитыОбъектов КАК РеквизитыДляКонтроляОбъектов
		|		ПО Реквизиты.Имя = РеквизитыДляКонтроляОбъектов.Имя"
	);
	Запрос.УстановитьПараметр("СоставРеквизитовОбъекта", Справочники.ОбъектыЭксплуатации.СоставРеквизитов());
	Запрос.УстановитьПараметр("Класс", Объект.Класс);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Заполняет таблицу параметров учета наработки по данным выбранного класса и текущих заполненных значений
//
&НаСервере
Процедура ЗаполнитьПараметрыУчетаНаработок(ТаблицаЗаполнения, КлассЗаполнения)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаЗаполнения.ПоказательНаработки,
		|	ТаблицаЗаполнения.НазначенныйРесурс,
		|	ТаблицаЗаполнения.Источник
		|ПОМЕСТИТЬ ТаблицаЗаполнения
		|ИЗ
		|	&ТаблицаЗаполнения КАК ТаблицаЗаполнения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоказателиНаработкиПоКлассификации.ПоказательНаработки КАК ПоказательНаработки,
		|	ТаблицаЗаполнения.НазначенныйРесурс КАК НазначенныйРесурс,
		|	ТаблицаЗаполнения.Источник КАК Источник,
		|	ПоказателиНаработкиПоКлассификации.РасчитыватьОстаточныйРесурс КАК ЗаполнятьНазначенныйРесурс,
		|	ПоказателиНаработкиПоКлассификации.РегистрироватьОтИсточника КАК ЗаполнятьИсточник
		|ИЗ
		|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработкиПоКлассификации
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗаполнения КАК ТаблицаЗаполнения
		|		ПО ПоказателиНаработкиПоКлассификации.ПоказательНаработки = ТаблицаЗаполнения.ПоказательНаработки
		|ГДЕ
		|	ПоказателиНаработкиПоКлассификации.Ссылка = &Класс
		|	И (ПоказателиНаработкиПоКлассификации.РасчитыватьОстаточныйРесурс
		|			ИЛИ ПоказателиНаработкиПоКлассификации.РегистрироватьОтИсточника)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПоказателиНаработкиПоКлассификации.НомерСтроки");
	Запрос.УстановитьПараметр("ТаблицаЗаполнения", ТаблицаЗаполнения.Выгрузить(, "ПоказательНаработки, НазначенныйРесурс, Источник"));
	Запрос.УстановитьПараметр("Класс", КлассЗаполнения);
	
	ПараметрыУчетаНаработок.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

//-- НЕ УТКА

&НаКлиенте
Процедура Подключаемый_ОбновитьФорму()
	
	Если ЭтаФорма.ВводДоступен() Тогда
		
		ОтключитьОбработчикОжидания("Подключаемый_ОбновитьФорму");
		
		ЭтаФорма.Прочитать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//++ НЕ УТКА
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыУчетаНаработокНазначенныйРесурс.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.ЗаполнятьНазначенныйРесурс");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='< не требуется >';uk='< не потрібно >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыУчетаНаработокИсточник.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.ЗаполнятьИсточник");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='< не требуется >';uk='< не потрібно >'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыУчетаНаработокНазначенныйРесурс.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.ЗаполнятьНазначенныйРесурс");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.НазначенныйРесурс");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыУчетаНаработокИсточник.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.ЗаполнятьИсточник");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыУчетаНаработок.Источник");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти
