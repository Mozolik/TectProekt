﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	Если ЗначениеЗаполнено(ОбособленноеПодразделение) Тогда
		ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "ОбособленноеПодразделение", "ФизическоеЛицо");
	Иначе
		ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ЕжегодныеОтпуска") Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
				Сотрудник						= ДанныеЗаполнения.Сотрудник;
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("ДатаНачала") Тогда
				ДатаНачала						= ДанныеЗаполнения.ДатаНачала;
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("ДолжностьПоШтатномуРасписанию") Тогда
				ДолжностьПоШтатномуРасписанию	= ДанныеЗаполнения.ДолжностьПоШтатномуРасписанию;
			КонецЕсли;
		КонецЕсли;
		
		СтруктураПараметров = ОстаткиОтпусков.ОписаниеПараметровДляЗаполнитьЕжегоднымиОтпускамиСотрудника();
		СтруктураПараметров.Регистратор = Ссылка;
		СтруктураПараметров.Сотрудник = Сотрудник;
		СтруктураПараметров.ДатаСобытия = ДатаНачала;
		СтруктураПараметров.Организация = ОбособленноеПодразделение;
		СтруктураПараметров.Подразделение = Подразделение;
		СтруктураПараметров.Территория = Территория;
		СтруктураПараметров.Должность = Должность;
		
		ОстаткиОтпусков.ЗаполнитьЕжегоднымиОтпускамиСотрудника(ЕжегодныеОтпуска, СтруктураПараметров);
			
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.КадровыйПеревод.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверкаСтрокиСписочногоДокумента = ДополнительныеСвойства.Свойство("ПроверкаСтрокиСписочногоДокумента");
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	ПараметрыПолученияСотрудниковОрганизаций.ИсключаемыйРегистратор		= Ссылка;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	Если ДатаНачала > ДатаОкончания
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата окончания не может быть меньше даты перевода';uk='Дата закінчення не може бути менша дати переведення'"), ЭтотОбъект, "ДатаОкончания", ,Отказ);
		
	КонецЕсли;
	
	Если Не ИзменитьПодразделениеИДолжность Тогда
		// Не требуется заполнять подразделение и количество ставок, если оно не изменяется.
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОбособленноеПодразделение");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Подразделение");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Должность");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДолжностьПоШтатномуРасписанию");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоСтавок");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидЗанятости");
	Иначе
		// Если изменяем позицию, то требуется проверить ШР.
		ПроверитьСоответствиеПозицииШРПодразделению(Отказ);
	КонецЕсли;
	
	// Не требуется заполнять ОбособленноеПодразделение если в организации не используются обособленные подразделения.
	ПараметрыФО = Новый Структура("Организация", Организация);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияРасширенная", ПараметрыФО) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОбособленноеПодразделение");
	КонецЕсли;
	
	// Не требуется заполнять график, если он не изменяется.
	Если Не ИзменитьГрафикРаботы Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ГрафикРаботы");
	КонецЕсли;
	
	// Не требуется заполнять способ расчета аванса, если он не изменяется.
	Если Не ИзменитьАванс Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СпособРасчетаАванса");
	КонецЕсли;
	
	ПроверяемыйРеквизитЕжегодныеОтпуска = ПроверяемыеРеквизиты.Найти("ЕжегодныеОтпуска");
	Если ПроверяемыйРеквизитЕжегодныеОтпуска <> Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыйРеквизитЕжегодныеОтпуска);
	КонецЕсли;
	
	// проверка КоличествоДнейВГод
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Для каждого Отпуск Из ЕжегодныеОтпуска Цикл
		Если НЕ ЗначениеЗаполнено(Отпуск.КоличествоДнейВГод) И НЕ ОстаткиОтпусков.ЭтоСтажевыйОтпуск(Отпуск.ВидЕжегодногоОтпуска) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не заполнено количество дней в год для отпуска %1';uk='Не заповнено кількість днів на рік для відпустки %1'"), Отпуск.ВидЕжегодногоОтпуска);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "", ,Отказ);
		КонецЕсли;
	КонецЦикла;
	МассивНепроверяемыхРеквизитов.Добавить("ЕжегодныеОтпуска.КоличествоДнейВГод");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Если производится операция бронирования позиции штатного расписания, то никаких действий больше не производится.
	ТолькоБронированиеПозиции = БронированиеПозиции И ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций");
	Если Не ТолькоБронированиеПозиции Тогда
	
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
		
		КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаНачала, "Начисления", "Показатели", Отказ, Истина);
		
		КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаНачала, "Льготы", "Показатели", Отказ, Истина, , "Льгота");
		
		ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Ссылка, ДатаНачала);
		
		ДокументыДляИсключения = Новый Массив;
		ДокументыДляИсключения.Добавить(ЭтотОбъект.Ссылка);
		ДокументыДляИсключения.Добавить(ЭтотОбъект.ИсправленныйДокумент);
		КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(ВремяРегистрации, ЭтотОбъект.Сотрудник, ДокументыДляИсключения, Отказ, Перечисления.ВидыКадровыхСобытий.Перемещение);
		
		ПроверитьИндивидуальныйГрафик(Отказ);
		
		Если Не ПроверкаСтрокиСписочногоДокумента Тогда
			ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		КонецЕсли;
		
		Если ИзменитьНачисления И НачисленияУтверждены Тогда 
			РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениРаботникВШапке(ВремяРегистрации, Сотрудник, Начисления, Ссылка, Отказ, , ИсправленныйДокумент);
			РасчетЗарплатыРасширенный.ПроверитьУникальностьЗапрашиванияПоказателяСотрудникВШапке(Начисления.Выгрузить(), Показатели.Выгрузить(), Сотрудник, ВремяРегистрации, Ссылка, Отказ);
			ПараметрыОтображенияПолейТарифнойСтавки = ЗарплатаКадрыРасширенный.ПараметрыОтображенияТарифнойСтавкиСотрудникВШапке(Сотрудник, Начисления);
			Если Не ПараметрыОтображенияПолейТарифнойСтавки.НесколькоТарифныхСтавок Тогда 
				ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
			КонецЕсли;
			ЗарплатаКадрыРасширенный.ПроверитьЗаполнениеВидаТарифнойСтавки(ЭтотОбъект, Отказ);
		Иначе 
			ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
		КонецЕсли;
		
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда 
			Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
			Модуль.ПроверитьЗаполнениеВидаРезерваВТабличнойЧасти(ЭтотОбъект, "КадровыйРезерв", ПроверяемыеРеквизиты, Отказ);
		КонецЕсли;

	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.КадровыйПеревод.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		ДолжностьПозиции = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДолжностьПоШтатномуРасписанию, "Должность");
		Если Должность <> ДолжностьПозиции Тогда
			Должность = ДолжностьПозиции;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ДолжностьПоШтатномуРасписанию) Тогда
			ДолжностьПоШтатномуРасписанию = Справочники.ШтатноеРасписание.ПустаяСсылка();
		КонецЕсли; 
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПредыдущаяДатаОкончания = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ДатаОкончания");
	Если ЗначениеЗаполнено(ПредыдущаяДатаОкончания) <> ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДополнительныеСвойства.Вставить("ИсключатьНеИзмененные", Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПеревод.ДатаНачала КАК Период,
		|	КадровыйПеревод.Сотрудник,
		|	КадровыйПеревод.СпособОтраженияЗарплатыВБухучете,
		|	КадровыйПеревод.СтатьяФинансирования
		|ИЗ
		|	Документ.КадровыйПеревод КАК КадровыйПеревод
		|ГДЕ
		|	КадровыйПеревод.Ссылка = &Ссылка
		|	И КадровыйПеревод.ИзменитьПодразделениеИДолжность";
	
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыСотрудников(
		ЭтотОбъект, Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьСоответствиеПозицииШРПодразделению(Отказ)
	
	ИспользоватьШтатноеРасписание =  ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	Если ИспользоватьШтатноеРасписание И ЗначениеЗаполнено(ДолжностьПоШтатномуРасписанию) И ЗначениеЗаполнено(Подразделение) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПодразделениеПоШтатномуРасписанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДолжностьПоШтатномуРасписанию, "Подразделение");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ПодразделениеПоШтатномуРасписанию <> Подразделение Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Позиция штатного расписания (%1) не соответствует выбранному подразделению';uk='Позиція штатного розкладу (%1) не відповідає обраному підрозділу'") + " (%2)",
					ДолжностьПоШтатномуРасписанию, Подразделение);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Подразделение", , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ИндивидуальныйГрафикНаМесяцПеревода() Экспорт 
	ДанныеГрафика = Новый Структура("Ссылка,Дата,Номер");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИндивидуальныйГрафик.Ссылка,
	|	ИндивидуальныйГрафик.Номер,
	|	ИндивидуальныйГрафик.Дата
	|ИЗ
	|	Документ.ИндивидуальныйГрафик.ДанныеОВремени КАК ИндивидуальныйГрафикДанныеОВремени
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИндивидуальныйГрафик КАК ИндивидуальныйГрафик
	|		ПО ИндивидуальныйГрафикДанныеОВремени.Ссылка = ИндивидуальныйГрафик.Ссылка
	|ГДЕ
	|	ИндивидуальныйГрафикДанныеОВремени.Сотрудник = &Сотрудник
	|	И НАЧАЛОПЕРИОДА(ИндивидуальныйГрафик.ПериодРегистрации, МЕСЯЦ) = НАЧАЛОПЕРИОДА(&ДатаНачала, МЕСЯЦ)
	|	И ИндивидуальныйГрафик.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	ИндивидуальныйГрафик.Ссылка,
	|	ИндивидуальныйГрафик.Номер,
	|	ИндивидуальныйГрафик.Дата";
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДатаНачала));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеГрафика, Выборка);
	КонецЕсли;
	
	Возврат ДанныеГрафика
КонецФункции

Процедура ПроверитьИндивидуальныйГрафик(Отказ)
	Если НЕ ИзменитьГрафикРаботы
		Или ДатаНачала = НачалоМесяца(ДатаНачала) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИндивидуальныйГрафикПриСменеГрафикаРаботы") Тогда
		Возврат;
	КонецЕсли;
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Ссылка, ДатаНачала);
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), "ОсновноеНачисление,ГрафикРаботы", ВремяРегистрации - 1);
	Если КадровыеДанныеСотрудников.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОсновноеНачисление = КадровыеДанныеСотрудников[0].ОсновноеНачисление;
	Если НЕ ЗначениеЗаполнено(ОсновноеНачисление) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОсновногоНачисления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОсновноеНачисление, "ТребуетсяРасчетНормыВремени,УчетВремениВЧасах");
	ВремяВЧасах = ДанныеОсновногоНачисления.УчетВремениВЧасах;
	ТребуетсяРасчетНормыВремени = ДанныеОсновногоНачисления.ТребуетсяРасчетНормыВремени;
	
	Если ТребуетсяРасчетНормыВремени И НЕ УчетРабочегоВремени.НормыПриСменеГрафиковСовпадают(КадровыеДанныеСотрудников[0].ГрафикРаботы, ГрафикРаботы, ДатаНачала, ВремяВЧасах) Тогда
		ДанныеИндивидуальногоГрафика = ИндивидуальныйГрафикНаМесяцПеревода();
		Если НЕ ЗначениеЗаполнено(ДанныеИндивидуальногоГрафика.Ссылка) Тогда
			ТекстСообщения = НСтр("ru='Изменение графика работы привело к изменению нормы рабочего времени. 
                                |В такой ситуации необходимо обязательно ввести индивидуальный график на месяц в котором происходит перевод сотрудника.'
                                |;uk='Зміна графіка роботи призвела до зміни норми робочого часу. 
                                |У такій ситуації необхідно обов''язково ввести індивідуальний графік на місяць в якому відбувається переведення працівника.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
