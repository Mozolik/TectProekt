﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Заголовок,СотрудникСсылка,ФизическоеЛицоСсылка,НеРегистрироватьОткрытиеФормы");
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		ОткрытаИзФормыСотрудника = Истина;
		
		Если Не ЗначениеЗаполнено(ФизическоеЛицоСсылка) Тогда
			ФизическоеЛицоСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СотрудникСсылка, "ФизическоеЛицо");
		КонецЕсли;
		
	КонецЕсли; 
	
	ЗначениеВРеквизитФормы(СотрудникиФормы.ФизическоеЛицоФормыСотрудника(ФизическоеЛицоСсылка), "ФизическоеЛицо");
	
	Если Не ПустаяСтрока(Параметры.АдресВХранилище) Тогда
		
		СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
			ЭтаФорма,
			СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы),
			Параметры.АдресВХранилище);
			
	КонецЕсли;
	
	Если ПустаяСтрока(Заголовок) Тогда
		Если ОбщегоНазначения.СсылкаСуществует(ФизическоеЛицоСсылка) Тогда
			Заголовок = Строка(ФизическоеЛицоСсылка);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РеквизитыФизическогоЛицаГруппа",
		"Видимость",
		Не НеРегистрироватьОткрытиеФормы
	);
		
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не НеРегистрироватьОткрытиеФормы Тогда
		СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтаФорма, ИмяФормы);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	Если Источник = ЭтаФорма Тогда
		
		Если ИмяСобытия = "ИзмененоЗнаниеЯзыковФизическихЛиц" Тогда
			
			ФизическоеЛицоЗнаниеЯзыковТекст = Параметр;
			
		ИначеЕсли ИмяСобытия = "ИзмененыПрофессииФизическихЛиц" Тогда
			
			ФизическоеЛицоПрофессииТекст = Параметр;
			
		ИначеЕсли ИмяСобытия = "ИзмененыСпециальностиФизическихЛиц" Тогда
			
			ФизическоеЛицоСпециальностиТекст = Параметр;
			
		ИначеЕсли ИмяСобытия = "ИзмененыУченыеЗванияФизическихЛиц" Тогда
			
			ФизическоеЛицоУченыеЗванияТекст = Параметр;
			
		ИначеЕсли ИмяСобытия = "ИзмененыУченыеСтепениФизическихЛиц" Тогда
			
			ФизическоеЛицоУченыеСтепениТекст = Параметр;
			
		КонецЕсли; 
			
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФизическоеЛицоУченыеСтепениТекстНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("РегистрСведений.УченыеСтепениФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоУченыеЗванияТекстНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("РегистрСведений.УченыеЗванияФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИмеетНаучныеТрудыПриИзменении(Элемент)
	
	Если ОткрытаИзФормыСотрудника Тогда
		СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоИмеетИзобретенияПриИзменении(Элемент)
	
	Если ОткрытаИзФормыСотрудника Тогда
		СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы); 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФизическоеЛицоПрофессииИзменить(Команда)

	СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("РегистрСведений.ПрофессииФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоСпециальностиИзменить(Команда)

	СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина") 
		И ПолучитьФункциональнуюОпциюФормы("РаботаВМедицинскомУчреждении") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("МедицинаКлиент");
		Модуль.ОткрытьФормуСпециальностиСертификатыФизическихЛиц(ПараметрыОткрытия, ЭтаФорма);
	иначе	
		ОткрытьФорму("РегистрСведений.СпециальностиФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоЗнаниеЯзыковИзменить(Команда)

	СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("РегистрСведений.ЗнаниеЯзыковФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроинициализироватьФорму()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОбразованиеФизическихЛиц, "Владелец", ФизическоеЛицоСсылка, ВидСравненияКомпоновкиДанных.Равно);
		
	ФизическоеЛицоПрофессииТекст = 
		РегистрыСведений.ПрофессииФизическихЛиц.ПредставлениеПрофессийФизическогоЛица(ФизическоеЛицоСсылка);
	ФизическоеЛицоСпециальностиТекст = 
		РегистрыСведений.СпециальностиФизическихЛиц.ПредставлениеСпециальностейФизическогоЛица(ФизическоеЛицоСсылка);
	ФизическоеЛицоЗнаниеЯзыковТекст = 
		РегистрыСведений.ЗнаниеЯзыковФизическихЛиц.ПредставлениеВладениеЯзыкамиФизическогоЛица(ФизическоеЛицоСсылка);
	ФизическоеЛицоУченыеСтепениТекст = 
		РегистрыСведений.УченыеСтепениФизическихЛиц.ПредставлениеУченойСтепениФизическогоЛица(ФизическоеЛицоСсылка);
	ФизическоеЛицоУченыеЗванияТекст = 
		РегистрыСведений.УченыеЗванияФизическихЛиц.ПредставлениеУченогоЗванияФизическогоЛица(ФизическоеЛицоСсылка);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ) Экспорт
	
	Если Модифицированность Тогда
		
		Если НЕ Отказ Тогда
			
			Если ПроверитьЗаполнение() Тогда
				
				Возвращаемыйпараметр = Новый Структура;
				Возвращаемыйпараметр.Вставить("ИмяФормы", ИмяФормы);
				Возвращаемыйпараметр.Вставить("АдресВХранилище", АдресДанныхДополнительнойФормыНаСервере(СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы)));
				
				Оповестить(
					"ИзмененыДанныеДополнительнойФормы",
					Возвращаемыйпараметр,
					ВладелецФормы);
				
			Иначе
				Отказ = Истина;
			КонецЕсли;
				
		КонецЕсли; 
			
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт 

	Если НЕ ТолькоПросмотр Тогда
		ТекущийЭлемент = Элементы.ФормаОк;
	КонецЕсли; 
	
	Отказ = Ложь;
	СохранитьДанные(Отказ);
	
	Если НЕ Отказ Тогда
		
		Модифицированность = Ложь;
		Если ЗакрытьФорму И Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы)
	
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтаФорма);
	
КонецФункции

#КонецОбласти
