﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	СегментыСервер.ПриСозданииНаСервере(ЭтаФорма);
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	СегментыСервер.ПередЗаписьюНаСервере(ЭтаФорма,ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособФормированияПриИзменении(Элемент)
	
	Если НЕ Объект.Ссылка.Пустая() И Объект.СпособФормирования <> ПредыдущийСпособФормирования Тогда
		ОбработчикОповещенияЗавершения = Новый ОписаниеОповещения("ИзменениеСпособаФормированияВопросПриЗавершения", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещенияЗавершения,НСтр("ru='Способ формирования был изменен. Текущий состав сегмента будет очищен. Продолжить?';uk='Спосіб формування був змінений. Поточний склад сегмента буде очищений. Продовжити?'"), РежимДиалогаВопрос.ОКОтмена); 
	Иначе
		ПриИзмененииСпособаФормирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособФормированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		ПредыдущийСпособФормирования = Объект.СпособФормирования;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСпособаФормированияВопросПриЗавершения(ОтветНаВопрос, ДополнительныеПараметры) Экспорт

	Если ОтветНаВопрос = КодВозвратаДиалога.ОК Тогда
		СегментыВызовСервера.Очистить(Объект.Ссылка);
		ПриИзмененииСпособаФормирования();
	Иначе
		Объект.СпособФормирования = ПредыдущийСпособФормирования;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСпособаФормирования()
	
	Если Объект.СпособФормирования <>
		ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьВручную") Тогда
		
		Элементы.ДатаОчистки.ТолькоПросмотр = Истина;
		Объект.ДатаОчистки = '00010101';
		
	Иначе
		
		Элементы.ДатаОчистки.ТолькоПросмотр = Ложь;
		
	КонецЕсли;
		
	Если Объект.СпособФормирования <> 
		ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ПериодическиОбновлять") Тогда
		
		Объект.ПроверятьНаВхождениеПриСозданииНового = Ложь;
		
	КонецЕсли;
	
	Если Объект.СпособФормирования = 
		ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьДинамически") Тогда
		
		Объект.ЗапретОтгрузки = Ложь;
		
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Сначала необходимо записать сегмент.';uk='Спочатку необхідно записати сегмент.'"));
		Возврат;
	КонецЕсли;

	Если Объект.СпособФормирования =
			ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьДинамически") Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Формирование доступно только для нединамических сегментов.';uk='Формування доступне тільки для нединамічних сегментів.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("СформироватьЗавершение", ЭтотОбъект), 
		НСтр("ru='Перед формированием необходимо записать сегмент. Записать?';uk='Перед формуванням необхідно записати сегмент. Записати?'"),
		РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;

	СформироватьФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    Иначе
        Записать();
    КонецЕсли;
    
    СформироватьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура СформироватьФрагмент()
    
    СегментыВызовСервера.Сформировать(Объект.Ссылка);
    ПоказатьОповещениеПользователя(
    НСтр("ru='Формирование сегмента партнеров';uk='Формування сегменту партнерів'"),,
    НСтр("ru='Сегмент сформирован.';uk='Сегмент сформований.'"));
    Оповестить("ДобавлениеПартнераВСегмент");

КонецПроцедуры

&НаКлиенте
Процедура МаркетинговыеМероприятия(Команда)

	ОткрытьФорму("Справочник.МаркетинговыеМероприятия.ФормаСписка",
		Новый Структура("Отбор",Новый Структура("СегментПартнеров",Объект.Ссылка)),
		ЭтаФорма,
		КлючУникальности,
		Окно);

КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)

	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru='Настройки сегмента ""%ИмяСегмента%""';uk='Настройки сегмента ""%ИмяСегмента%""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%ИмяСегмента%", Объект.Наименование);
	
	Адреса = СегментыВызовСервера.ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(
		Объект.Ссылка,
		Объект.ИмяШаблонаСКД,
		АдресСКД, 
		АдресНастроекСКД,
		УникальныйИдентификатор);
	
	Результат = Неопределено;

	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
			"АдресСхемыКомпоновкиДанных,
			|АдресНастроекКомпоновкиДанных,
			|ИсточникШаблонов,
			|Заголовок,
			|НеПомещатьНастройкиВСхемуКомпоновкиДанных,
			|НеНастраиватьУсловноеОформление,
			|НеНастраиватьПорядок,
			|НеНастраиватьВыбор,
			|УникальныйИдентификатор,
			|ИмяШаблонаСКД,
			|ВозвращатьИмяТекущегоШаблонаСКД",
			Адреса.СхемаКомпоновкиДанных,
			Адреса.НастройкиКомпоновкиДанных,
			Объект.Ссылка,
			ЗаголовокФормыНастройкиСхемыКомпоновкиДанных,
			Истина,
			Истина,
			Истина,
			Истина,
			УникальныйИдентификатор,
			Объект.ИмяШаблонаСКД,
			Истина),,,,, Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект, Новый Структура("Адреса", Адреса)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Адреса = ДополнительныеПараметры.Адреса;
    
    
    Если Результат <> Неопределено Тогда
        
        Объект.ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
        
        Изменения = СегментыВызовСервера.ПрименитьИзмененияКСхемеКомпоновкиДанных(
        Объект.Ссылка,
        Объект.ИмяШаблонаСКД, 
        Адреса.СхемаКомпоновкиДанных,
        Результат.АдресХранилищаНастройкиКомпоновщика,
        УникальныйИдентификатор);
        
        Объект.ИмяШаблонаСКД = Изменения.ИмяШаблонаСКД;
        ПредставлениеШаблонаСКД = Изменения.ПредставлениеШаблонаСКД;
        АдресСКД = Изменения.АдресСКД;
        АдресНастроекСКД = Изменения.АдресНастроекСКД;
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ДиалогРасписания.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, Новый Структура("ДиалогРасписания", ДиалогРасписания)));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание1, ДополнительныеПараметры) Экспорт
    
    ДиалогРасписания = ДополнительныеПараметры.ДиалогРасписания;
    
    
    Если Расписание1 <> Неопределено Тогда
        
        Модифицированность = Истина;
        Расписание         = ДиалогРасписания.Расписание;
        РасписаниеСтрокой  = Строка(Расписание);
        
    КонецЕсли;

КонецПроцедуры

// Команда подсистемы "Запрет редактирования реквизитов"
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		ОткрытьФорму("Справочник.СегментыПартнеров.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеДоступностью()
	
	Элементы.СтраницаРасписание.Доступность =
		(Объект.СпособФормирования = ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ПериодическиОбновлять"));
	Элементы.ПроверятьНаВхождениеПриСозданииНового.Доступность =
		(Объект.СпособФормирования = ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ПериодическиОбновлять"));
		
	ФормироватьСегментДинамически = (Объект.СпособФормирования =
		ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ФормироватьДинамически"));
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ЗапретОтгрузки",
		"Видимость",
		НЕ ФормироватьСегментДинамически);
		
КонецПроцедуры

#КонецОбласти
