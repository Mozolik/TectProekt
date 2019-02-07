﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком);
	
КонецФункции

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт
	
	Если НЕ ДокументОбъект.ИзменитьНачисления Тогда
		Возврат;
	КонецЕсли; 
	
	// Подготовка к расчету ФОТ
	РассчитываемыеОбъекты = Новый Соответствие;
	
	Сотрудники = Новый Соответствие;
	
	ТаблицаСотрудников = ДокументОбъект.Начисления.Выгрузить(, "РабочееМесто");
	ТаблицаСотрудников.Свернуть("РабочееМесто");
	
	Для каждого СтрокаТаблицыСотрудников Из ТаблицаСотрудников Цикл
		
		ОписаниеСотрудника = Новый Структура;
		ОписаниеСотрудника.Вставить("Организация", ДокументОбъект.Организация);
		ОписаниеСотрудника.Вставить("ДатаРасчета", ДокументОбъект.ДатаИзменения);
		ОписаниеСотрудника.Вставить("Начисления", РасчетЗарплатыРасширенный.ПустаяТаблицаДанныеНачисленийДляРасчетаФОТ());
		ОписаниеСотрудника.Вставить("Показатели", РасчетЗарплатыРасширенный.ПустаяТаблицаДанныеПоказателейДляРасчетаФОТ());
		
		НачисленияСотрудника = ДокументОбъект.Начисления.НайтиСтроки(Новый Структура("РабочееМесто", СтрокаТаблицыСотрудников.РабочееМесто));
		
		СписокНачислений = Новый Массив;
		Для Каждого СтрокаНачисления Из НачисленияСотрудника Цикл
			
			ДанныеНачисления = ОписаниеСотрудника.Начисления.Добавить();
			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
			ДанныеНачисления.Размер = 0;
			
			ПоказателиНачисления = ДокументОбъект.Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиВидаРасчета", СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
			Для Каждого СтрокаПоказателя Из ПоказателиНачисления Цикл
				ДанныеПоказателя = ОписаниеСотрудника.Показатели.Добавить();
				ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
				ДанныеПоказателя.ДокументОснование = СтрокаНачисления.ДокументОснование;
				ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
			КонецЦикла;
			
		КонецЦикла;
		
		Сотрудники.Вставить(СтрокаТаблицыСотрудников.РабочееМесто, ОписаниеСотрудника);
		
	КонецЦикла;
	
	РассчитываемыеОбъекты.Вставить(ДокументОбъект.Ссылка, Сотрудники);
	
	// Расчет ФОТ
	РасчетЗарплатыРасширенный.РассчитатьФОТСотрудников(РассчитываемыеОбъекты, ДокументОбъект.Организация, ДокументОбъект.ДатаИзменения);
	
	// Заполнение документа результатами расчета.
	ОписаниеОбъекта = РассчитываемыеОбъекты.Получить(ДокументОбъект.Ссылка);
	
	Для Каждого СтрокаТаблицыСотрудников Из ТаблицаСотрудников Цикл
		
		ОписаниеСотрудника = ОписаниеОбъекта.Получить(СтрокаТаблицыСотрудников.РабочееМесто);
		
		Для Каждого ОписаниеНачисления Из ОписаниеСотрудника.Начисления Цикл
			
			Отбор = Новый Структура("РабочееМесто, Начисление, ДокументОснование", 
				СтрокаТаблицыСотрудников.РабочееМесто, ОписаниеНачисления.Начисление, ОписаниеНачисления.ДокументОснование);
			СтрокиДокумента = ДокументОбъект.Начисления.НайтиСтроки(Отбор);
			
			Если СтрокиДокумента.Количество() > 0 Тогда
				СтрокиДокумента[0].Размер = ОписаниеНачисления.Размер;
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЦикла;
	
	РасчетЗарплатыРасширенный.ЗаполнитьФОТВДвиженияхЗагружаемогоДокумента(ДокументОбъект.Движения.ПлановыеНачисления, ДокументОбъект.Начисления, "РабочееМесто");
	
КонецПроцедуры

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОВыходеНаНеполноеРабочееВремя";
	КомандаПечати.Представление = НСтр("ru='Приказ о работе на условиях неполного рабочего времени';uk='Наказ про роботу на умовах неповного робочого часу'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли