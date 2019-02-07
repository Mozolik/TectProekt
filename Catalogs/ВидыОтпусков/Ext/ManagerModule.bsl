﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#Область СлужебныйПрограммныйИнтерфейс

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

// Процедура создает виды отпусков в зависимости от настроек расчета зарплаты.
//  Параметры: 
//		ПараметрыПланаВидовРасчета - см. РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета.
//
Процедура СоздатьВидыОтпусковПоНастройкам(ПараметрыПланаВидовРасчета = Неопределено, НастройкиРасчетаЗарплаты = Неопределено) Экспорт
	

КонецПроцедуры

Процедура СоздатьВидОтпускаЗаВредныеУсловияТруда(НастройкиРасчетаЗарплаты) Экспорт
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность Тогда
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускЗаВредность";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru='Отпуск за вредность';uk='Відпустка за шкідливість'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru='Отпуск за вредность';uk='Відпустка за шкідливість'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтРабочегоМеста");
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
		ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Ложь;
		ОписаниеВидаОтпуска.КоличествоДнейВГод			= 0;
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускЗаВредность", НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность);
	
КонецПроцедуры

Процедура ЗаполнитьСпособРасчетаВидовОтпуска() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОтпусков.Ссылка
	|ИЗ
	|	Справочник.ВидыОтпусков КАК ВидыОтпусков
	|ГДЕ
	|	ВидыОтпусков.СпособРасчетаОтпуска = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОтпуска.ПустаяСсылка)";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидОтпуска = Выборка.Ссылка.ПолучитьОбъект();
		ВидОтпуска.СпособРасчетаОтпуска = Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ВидОтпуска.ОбменДанными.Загрузка = Истина;
		ВидОтпуска.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Функция КоличествоВидовОтпуска() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыОтпусков.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВидыОтпусков КАК ВидыОтпусков
	|ГДЕ
	|	ВидыОтпусков.Предопределенный = ЛОЖЬ");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	КадровыйУчетРасширенныйВызовСервера.ОбработкаПолученияДанныхВыбораСправочникаВидыОтпусков(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Или ВидФормы = "ФормаСписка" Тогда
		ПараметрИзменен = Ложь;
		
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура("Недействителен", Ложь));
			ПараметрИзменен = Истина;
		ИначеЕсли Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
			ПараметрИзменен = Истина;
		КонецЕсли;
		
		// Этот код нужен, чтобы были использованы измененные нами значения параметров.
		Если ПараметрИзменен Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСписка"; // передаем имя формы выбора
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПустоеОписаниеВидаОтпуска()
	
	Возврат Новый Структура("
	|Наименование,
	|НаименованиеПолное,
	|ОтпускБезОплаты,
	|ОтпускЯвляетсяЕжегодным,
	|ПредоставлятьОтпускВсемСотрудникам,
	|КоличествоДнейВГод,
	|СпособРасчетаОтпуска,
	|ПредопределенныйВидОтпуска,
	|ИмяПредопределенныхДанных,
	|ХарактерЗависимостиДнейОтпуска,
	|ВидСтажа,
	|ОсновнойОтпуск");
	
КонецФункции

Функция НовыйВидОтпуска(ОписаниеВидаОтпуска)
	
	ВидОтпускаОбъект = Неопределено;
	Если ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска Тогда 
		ВидОтпускаСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ОписаниеВидаОтпуска.ИмяПредопределенныхДанных);
		Если ВидОтпускаСсылка <> Неопределено Тогда 
			ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
			Возврат ВидОтпускаОбъект;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОтпускаОбъект = Неопределено Тогда 
		ВидОтпускаОбъект = Справочники.ВидыОтпусков.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидОтпускаОбъект, ОписаниеВидаОтпуска);
	ВидОтпускаОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат ВидОтпускаОбъект;
	
КонецФункции

Процедура ОбновитьИспользуемостьВидаОтпуска(ИмяПредопределенныхДанных, Действителен)
	
	ВидОтпускаСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ИмяПредопределенныхДанных);
	
	Если ВидОтпускаСсылка <> Неопределено Тогда 
		ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
		ВидОтпускаОбъект.Недействителен = Не Действителен;
		ВидОтпускаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры


// Процедура производит первоначальное заполнение предопределенных видов отпуска.
Процедура ОписатьВидОтпускаОсновнойОтпуск() Экспорт

	ОбновитьПовторноИспользуемыеЗначения();
	
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска			= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных			= "Основной";
	ОписаниеВидаОтпуска.Наименование						= НСтр("ru='Основной';uk='Основний'");
	ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru='Основной отпуск';uk='Основна відпустка'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска				= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхИлиРабочихДняхВЗависимостиОтТрудовогоДоговора;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным				= Истина;
	ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Истина;
	ОписаниеВидаОтпуска.КоличествоДнейВГод					= 28;
	ОписаниеВидаОтпуска.ОсновнойОтпуск						= Истина;
	
	НовыйВидОтпуска(ОписаниеВидаОтпуска);
	
КонецПроцедуры


	
	

#КонецОбласти

#КонецЕсли
