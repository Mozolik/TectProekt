﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа = 
		ПолучитьФункциональнуюОпцию("ИспользуетсяТрудЧленовЛетныхЭкипажей") И ЯвляетсяДолжностьюЛетногоЭкипажа;
		
	ЗначениеЯвляетсяШахтерскойДолжностью =
		ПолучитьФункциональнуюОпцию("ИспользуетсяТрудШахтеров") И ЯвляетсяШахтерскойДолжностью;
		

	ТекстСообщения = "";
	
	Если ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа И ЗначениеЯвляетсяШахтерскойДолжностью Тогда
		ТекстСообщения = НСтр("ru='члена летного экипажа и шахтера';uk='члена льотного екіпажу і шахтаря'");
	КонецЕсли;
	
		
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		
		ТекстСообщения = НСтр("ru='Должность не может одновременно являться должностью';uk='Посада не може одночасно бути посадою'") + " " + ТекстСообщения + ".";
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	Если НЕ ВведенаВШтатноеРасписание Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаВвода");
	КонецЕсли; 

	Если НЕ ИсключенаИзШтатногоРасписания Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаИсключения");
	КонецЕсли; 
	
	Если (Не ИсключенаИзШтатногоРасписания) И ПометкаУдаления Тогда
		ТекстСообщения = НСтр("ru='У помеченной на удаление должности нельзя снять флаг ""Исключена из штатного расписания""!''';uk='У позначеної на видалення посади не можна зняти прапор ""Виключена з штатного розкладу""!''",);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, , , Отказ);
	КонецЕсли;	

	Если ЗначениеЗаполнено(ДатаИсключения) И ЗначениеЗаполнено(ДатаВвода) И ДатаВвода > ДатаИсключения Тогда
		ТекстСообщения = НСтр("ru='Дата ввода должности в штатное расписание не может быть больше даты исключения!''';uk='Дата введення посади в штатний розклад не може бути більше дати виключення!''",);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, , , Отказ);	
	КонецЕсли;		

	Если ИсключенаИзШтатногоРасписания Тогда 
		ПроверкаИспользованияВШтатномРасписании(Отказ);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПроверкаИспользованияВШтатномРасписании(Отказ)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Должность", Ссылка);
	Запрос.УстановитьПараметр("ДатаИсключения", ДатаИсключения);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтатноеРасписание.Наименование КАК ПозицияШтатногоРасписания,
	|	ШтатноеРасписание.Ссылка
	|ИЗ
	|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
	|ГДЕ
	|	ШтатноеРасписание.Должность = &Должность
	|	И НЕ ШтатноеРасписание.ЭтоГруппа
	|	И НЕ(ШтатноеРасписание.Закрыта
	|				И ШтатноеРасписание.ДатаЗакрытия <= &ДатаИсключения)";
	
	Результат = Запрос.Выполнить();
		
	Если Не Результат.Пустой() Тогда
		
		ТекстСообщения = НСтр("ru='Должность ""%1"" не может быть исключена из штатного расписания, т.к. она используется в действующих позициях:';uk='Посада ""%1"" не може бути виключена з штатного розкладу, оскільки вона використовується в діючих позиціях:'"); 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Ссылка,
			); 
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ИсключенаИзШтатногоРасписания" , , Отказ);

		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = НСтр("ru='- позиция ""%1""';uk='- позиція ""%1""'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.ПозицияШтатногоРасписания);
	        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ИсключенаИзШтатногоРасписания" , , Отказ);
		КонецЦикла;	
		
	КонецЕсли;	    
		
КонецПроцедуры	

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		Если ПометкаУдаления И ВведенаВШтатноеРасписание И (Не ИсключенаИзШтатногоРасписания) Тогда
			ТекстСообщения = НСтр("ru='Нельзя пометить на удаление действующую должность';uk='Неможна відмітити на вилучення діючу посаду'");
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	
	КонецЕсли;
	
	Если ПустаяСтрока(НаименованиеКраткое) Тогда
		НаименованиеКраткое = Наименование;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


#КонецЕсли
