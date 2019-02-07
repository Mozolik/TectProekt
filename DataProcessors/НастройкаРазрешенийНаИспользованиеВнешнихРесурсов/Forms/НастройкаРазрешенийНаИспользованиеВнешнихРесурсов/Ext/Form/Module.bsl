﻿&НаКлиенте
Перем ИтерацияПроверки;
&НаКлиенте
Перем АдресХранилища;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресХранилищаНаСервере = Параметры.АдресХранилища;
	РезультатОбработкиЗапросов = ПолучитьИзВременногоХранилища(АдресХранилищаНаСервере);
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить() Тогда
		Если Параметры.РежимПроверки Тогда
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаТребуетсяОтменитьНеактуальныеРазрешенияВКластере;
		ИначеЕсли Параметры.РежимВосстановления Тогда
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаПриВосстановленииБудутУстановленыСледующиеНастройкиВКластере;
		Иначе
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаТребуетсяВнестиИзмененияВКластере;
		КонецЕсли;
	Иначе
		Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаПриВключенииБудутУстановленыСледующиеНастройкиВКластере;
	КонецЕсли;
	
	СценарийПримененияЗапросов = РезультатОбработкиЗапросов.Сценарий;
	
	Если СценарийПримененияЗапросов.Количество() = 0 Тогда
		ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Ложь;
		Возврат;
	КонецЕсли;
	
	ПредставлениеРазрешений = РезультатОбработкиЗапросов.Представление;
	
	ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Истина;
	ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Ложь;
	Для Каждого ШагСценария Из СценарийПримененияЗапросов Цикл
		Если ШагСценария.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Назначение
				Или ШагСценария.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.УдалениеНазначения Тогда
			ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
		Если ПользовательИБ <> Неопределено Тогда
			ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	ТипПодключения = ПараметрыАдминистрирования.ТипПодключения;
	ПортКластераСерверов = ПараметрыАдминистрирования.ПортКластера;
	
	АдресАгентаСервера = ПараметрыАдминистрирования.АдресАгентаСервера;
	ПортАгентаСервера = ПараметрыАдминистрирования.ПортАгентаСервера;
	
	АдресСервераАдминистрирования = ПараметрыАдминистрирования.АдресСервераАдминистрирования;
	ПортСервераАдминистрирования = ПараметрыАдминистрирования.ПортСервераАдминистрирования;
	
	ИмяВКластере = ПараметрыАдминистрирования.ИмяВКластере;
	ИмяАдминистратораКластера = ПараметрыАдминистрирования.ИмяАдминистратораКластера;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
	Если ПользовательИБ <> Неопределено Тогда
		ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
	КонецЕсли;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторАдминистратораИБ);
	АдминистраторИБ = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ИдентификаторАдминистратораИБ);
	
	Элементы.ГруппаАдминистрирование.Видимость = ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	Элементы.ГруппаПредупреждениеОНеобходимостиПерезапуска.Видимость = ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	
	Элементы.ФормаРазрешить.Заголовок = НСтр("ru='Далее >';uk='Далі >'");
	Элементы.ФормаНазад.Видимость = Ложь;
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПоказатьОшибкуОперацияНеПоддерживаетсяВВебКлиенте();
		Возврат;
	#КонецЕсли
	
	Если ТребуетсяВнесениеИзмененийВПрофиляхБезопасности Тогда
		
		АдресХранилища = АдресХранилищаНаСервере;
		
	Иначе
		
		Закрыть(КодВозвратаДиалога.Пропустить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТребуютсяПараметрыАдминистрированияИнформационнойБазы Тогда
		
		Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		
		ИмяПоля = "АдминистраторИБ";
		ПользовательИБ = ПолучитьАдминистратораИБ();
		Если ПользовательИБ = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Указанный пользователь не имеет доступа к информационной базе.';uk='Зазначений користувач не має доступу до інформаційної бази.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='У пользователя нет административных прав.';uk='У користувача немає адміністративних прав.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения Тогда
		
		ТекстОшибки = "";
		Элементы.ГруппаОшибка.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru='Настроить разрешения в кластере серверов';uk='Настроїти дозволи в кластері серверів'");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение;
		Элементы.ФормаНазад.Видимость = Истина;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		
		ТекстОшибки = "";
		Попытка
			
			ПрименитьРазрешения();
			ЗавершитьПрименениеЗапросов(АдресХранилища);
			ОжидатьПримененияНастроекВКластере();
			
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке()); 
			Элементы.ГруппаОшибка.Видимость = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения;
		Элементы.ФормаНазад.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru='Далее >';uk='Далі >'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеререгистрироватьCOMСоединитель(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостью()
	
	Если ТипПодключения = "COM" Тогда
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруCOM;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Истина;
	Иначе
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруRAS;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаОшибкаВерсииCOMСоединителя.Видимость = ВидимостьГруппыОшибкиВерсииCOMСоединителя;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуОперацияНеПоддерживаетсяВВебКлиенте()
	
	Элементы.СтраницыГлобальный.ТекущаяСтраница = Элементы.СтраницаОперацияНеПоддерживаетсяВВебКлиенте;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдминистратораИБ()
	
	Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		АдминистраторИБ.ИдентификаторПользователяИБ);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяПользователяИнформационнойБазы(Знач Пользователь)
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		Возврат ПользовательИБ.Имя;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПрименитьРазрешения()
	
	ПараметрыПрименения = НачатьПрименениеЗапросов(АдресХранилища);
	
	ВидыОпераций = ПараметрыПрименения.ВидыОпераций;
	Сценарий = ПараметрыПрименения.СценарийПримененияЗапросов;
	ТребуютсяПараметрыАдминистрированияИБ = ПараметрыПрименения.ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	
	ПараметрыАдминистрированияКластера = АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияКластера();
	ПараметрыАдминистрированияКластера.ТипПодключения = ТипПодключения;
	ПараметрыАдминистрированияКластера.АдресАгентаСервера = АдресАгентаСервера;
	ПараметрыАдминистрированияКластера.ПортАгентаСервера = ПортАгентаСервера;
	ПараметрыАдминистрированияКластера.АдресСервераАдминистрирования = АдресСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортСервераАдминистрирования = ПортСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортКластера = ПортКластераСерверов;
	ПараметрыАдминистрированияКластера.ИмяАдминистратораКластера = ИмяАдминистратораКластера;
	ПараметрыАдминистрированияКластера.ПарольАдминистратораКластера = ПарольАдминистратораКластера;
	
	Если ТребуютсяПараметрыАдминистрированияИБ Тогда
		ПараметрыАдминистрированияИБ = АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияИнформационнойБазыКластера();
		ПараметрыАдминистрированияИБ.ИмяВКластере = ИмяВКластере;
		ПараметрыАдминистрированияИБ.ИмяАдминистратораИнформационнойБазы = ИмяПользователяИнформационнойБазы(АдминистраторИБ);
		ПараметрыАдминистрированияИБ.ПарольАдминистратораИнформационнойБазы = ПарольАдминистратораИБ;
	Иначе
		ПараметрыАдминистрированияИБ = Неопределено;
	КонецЕсли;
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ПрименитьИзмененияРазрешенийВПрофиляхБезопасностиВКластереСерверов(
		ВидыОпераций, Сценарий, ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИБ);
	
КонецПроцедуры

&НаСервере
Функция НачатьПрименениеЗапросов(Знач АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	СценарийПримененияЗапросов = Результат.Сценарий;
	
	ВидыОпераций = Новый Структура();
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ОперацииАдминистрированияПрофилейБезопасности.ЗначенияПеречисления Цикл
		ВидыОпераций.Вставить(ЗначениеПеречисления.Имя, Перечисления.ОперацииАдминистрированияПрофилейБезопасности[ЗначениеПеречисления.Имя]);
	КонецЦикла;
	
	Возврат Новый Структура("ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы",
		ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы);
	
КонецФункции

&НаСервере
Процедура ЗавершитьПрименениеЗапросов(Знач АдресХранилища)
	
	Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ЗафиксироватьПрименениеЗапросов(ПолучитьИзВременногоХранилища(АдресХранилища).Состояние);
	СохранитьПараметрыАдминистрирования();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыАдминистрирования()
	
	СохраняемыеПараметрыАдминистрирования = Новый Структура();
	
	// Параметры администрирования кластера.
	СохраняемыеПараметрыАдминистрирования.Вставить("ТипПодключения", ТипПодключения);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресАгентаСервера", АдресАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортАгентаСервера", ПортАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресСервераАдминистрирования", АдресСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортСервераАдминистрирования", ПортСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортКластера", ПортКластераСерверов);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораКластера", ИмяАдминистратораКластера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораКластера", "");
	
	// Параметры администрирования информационной базы.
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяВКластере", ИмяВКластере);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораИнформационнойБазы", ИмяПользователяИнформационнойБазы(АдминистраторИБ));
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораИнформационнойБазы", "");
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыАдминистрирования(СохраняемыеПараметрыАдминистрирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьПримененияНастроекВКластере()
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти