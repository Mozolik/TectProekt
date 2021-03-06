﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);

	ТекстЗаголовка = НСтр("ru='Взаимодействия (%КоличествоВзаимодействий%)';uk='Взаємодії (%КоличествоВзаимодействий%)'");
	ТекстЗаголовка =  СтрЗаменить(ТекстЗаголовка, "%КоличествоВзаимодействий%", КоличествоВзаимодействий(Задание.Предмет));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Взаимодействия", "Заголовок", ТекстЗаголовка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Источник) И Параметр.Предмет = Задание.Предмет  Тогда
		ТекстЗаголовка = НСтр("ru='Взаимодействия (%КоличествоВзаимодействий%)';uk='Взаємодії (%КоличествоВзаимодействий%)'");
		Элементы.Взаимодействия.Заголовок = СтрЗаменить(
		ТекстЗаголовка, "%КоличествоВзаимодействий%", КоличествоВзаимодействий(Задание.Предмет));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("Сделка",Объект.Предмет));

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КоличествоВзаимодействий(Сделка)

	Если НЕ ПравоДоступа("Чтение",Метаданные.ЖурналыДокументов.Взаимодействия) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК КоличествоВзаимодействий
		|ИЗ
		|	ЖурналДокументов.Взаимодействия КАК Взаимодействия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ПО Взаимодействия.Ссылка = ПредметыПапкиВзаимодействий.Взаимодействие
		|ГДЕ
		|	(НЕ Взаимодействия.ПометкаУдаления)
		|	И ТИПЗНАЧЕНИЯ(Взаимодействия.Ссылка) <> ТИП(Документ.ЗапланированноеВзаимодействие)
		|	И ПредметыПапкиВзаимодействий.Предмет = &Предмет");
	Запрос.УстановитьПараметр("Предмет", Сделка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КоличествоВзаимодействий;

КонецФункции

#КонецОбласти
