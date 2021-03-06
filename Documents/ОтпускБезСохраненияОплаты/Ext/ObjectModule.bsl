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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИСотрудникам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОтпускБезСохраненияОплаты.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	Документы.ОтпускБезСохраненияОплаты.СоздатьВТДанныеДокументов(Ссылка, ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьРаботающихСотрудников(Отказ); 
	
	Если ОтсутствиеВТечениеЧастиСмены Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ЧасовОтпуска");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОтсутствия");
	КонецЕсли;
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(ЭтотОбъект);
	
	Если ПраваНаДокумент.ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений Тогда
		
		Если ОтсутствиеВТечениеЧастиСмены Тогда
					
			ДанныеОВремениДляПроверки = Документы.ОтпускБезСохраненияОплаты.ДанныеОВремени(ЭтотОбъект);
			ОшибкиВводаВремени = УчетРабочегоВремени.ПроверитьРегистрациюВнутрисменногоВремени(Ссылка, ДанныеОВремениДляПроверки, ПериодРегистрации);
			
			Ошибки = Новый Соответствие;
			Для Каждого ОписаниеОшибки Из ОшибкиВводаВремени Цикл				
				
				УчетРабочегоВремени.ДобавитьОшибкуПоСотруднику(Ошибки, ОписаниеОшибки.Сотрудник, ОписаниеОшибки.ТекстОшибки, "", ОписаниеОшибки.Документ);		
				
			КонецЦикла;	

			УчетРабочегоВремени.ВывестиОшибкиПоСотрудникам(Ошибки, Отказ);
		КонецЕсли;		
		
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
		
		ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		
		Если Не ЗначениеЗаполнено(ВидРасчета) 
			И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОтпускБезОплаты") Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Документы.ОтпускБезСохраненияОплаты.ТекстСообщенияНеЗаполненВидРасчета(ВидОтпуска, ОтсутствиеВТечениеЧастиСмены),
			Ссылка,
			,
			,
			Отказ);
		КонецЕсли;
		
		Если ПерерасчетВыполнен Тогда 
			
			ПроверитьПериодДействияНачислений(Отказ);
			
			Если Не Отказ Тогда
				
				ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
				ПараметрыПроверки.Организация = Организация;
				ПараметрыПроверки.ПериодРегистрации = ПериодРегистрации;
				ПараметрыПроверки.Документ = Ссылка;
				ПараметрыПроверки.Начисления = Начисления;
				ПараметрыПроверки.НачисленияПерерасчет = НачисленияПерерасчет;
				ПараметрыПроверки.ИсправленныйДокумент = ИсправленныйДокумент;
				ПараметрыПроверки.ОсновныеНачисления = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидРасчета);
				
				РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРаботающихСотрудников(Отказ)
	
	Если ОтсутствиеВТечениеЧастиСмены Тогда
		НачалоПериода 		= НачалоДня(ДатаОтсутствия);
		ОкончаниеПериода	= КонецДня(ДатаОтсутствия);
	Иначе 	
		НачалоПериода 		= ДатаНачала;
		ОкончаниеПериода	= ДатаОкончания;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация)
		Или Не ЗначениеЗаполнено(Сотрудник)
		Или Не ЗначениеЗаполнено(НачалоПериода)
		Или Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Возврат;	
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ОкончаниеПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект")
	);
КонецПроцедуры


// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие")Тогда 
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				
				ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
						ДанныеЗаполнения.Ссылка, 
						, 
						"Начисления,НачисленияПерерасчет,
						|Показатели,РаспределениеРезультатовНачислений");
				
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			ИначеЕсли ДанныеЗаполнения.Действие = "Заполнить" Тогда
				   ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = ЭтотОбъект.Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru='Перерасчет прошлого периода';uk='Перерахунок минулого періоду'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
