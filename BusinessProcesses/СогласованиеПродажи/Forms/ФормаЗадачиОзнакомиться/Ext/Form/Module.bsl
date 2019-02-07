﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ТолькоПросмотр = Объект.Выполнена;
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДата();
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаИсполнения", "ТолькоПросмотр", Не ИзменятьЗаданияЗаднимЧислом);
	
	ХодСогласования.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Объект.БизнесПроцесс);
	
	УстанавливаемыеПараметры = Новый Структура();
	УстанавливаемыеПараметры.Вставить("ТипОбъекта", Объект.Предмет.Метаданные().ПолноеИмя());
	УстановитьПараметрыФункциональныхОпцийФормы(УстанавливаемыеПараметры);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект,
			Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение:';uk='Зміна:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
			
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение:';uk='Зміна:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Ознакомился(Команда)
	
	Если Записать() Тогда 
		ОзнакомилсяСервер();
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Выполнение:';uk='Виконання:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклоненияОтУсловийПродаж(Команда)
	ПараметрыФормы = Новый Структура("ДокументПродажи", Объект.Предмет);
	ОткрытьФорму("Отчет.ОтклоненияОтУсловийПродаж.Форма", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ОзнакомилсяСервер()
	
	БизнесПроцессыИЗадачиВызовСервера.ВыполнитьЗадачу(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
