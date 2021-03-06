﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			ОбъектОснование = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование, , Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Сотрудник", ОбъектОснование);
		Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДатаСеанса());
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	НазначениеПодработки.Ссылка
			|ИЗ
			|	Документ.НазначениеПодработки КАК НазначениеПодработки
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПрекращениеПодработки КАК ПрекращениеПодработки
			|		ПО НазначениеПодработки.Ссылка = ПрекращениеПодработки.ДокументОснование
			|			И (ПрекращениеПодработки.Проведен)
			|ГДЕ
			|	НазначениеПодработки.ГоловнойСотрудник = &Сотрудник
			|	И (НазначениеПодработки.ДатаОкончания >= &ДатаОкончания
			|			ИЛИ НазначениеПодработки.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
			|	И НазначениеПодработки.Проведен
			|	И ПрекращениеПодработки.Ссылка ЕСТЬ NULL ";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				
				Выборка.Следующий();
				ОбъектОснование = Выборка.Ссылка
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.НазначениеПодработки") Тогда
		Документы.ПрекращениеПодработки.ЗаполнитьОбъектПоНазначениюПодработки(ЭтотОбъект, ОбъектОснование);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Кадровый учет
	НеобходимыеДанные = "ФизическоеЛицо,ДолжностьПоШтатномуРасписанию,КоличествоСтавок,ВидЗанятости";
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СовмещающийСотрудник), НеобходимыеДанные, ДатаОкончания);
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудника[0];
	
	КадровыеСобытия = Документы.ПрекращениеПодработки.КадровыеСобытияУвольнение(СовмещающийСотрудник, ДатаОкончания, ФизическоеЛицо, КадровыеДанныеСотрудника.ДолжностьПоШтатномуРасписанию, КадровыеДанныеСотрудника.КоличествоСтавок);
	
	РегистрыСведений.СостоянияПодработок.СформироватьДвижения(ЭтотОбъект, Движения, КадровыеСобытия);
	
	// Прекращаем плановые начисления и удержания.
	РасчетЗарплатыРасширенный.ПрекратитьВсеПлановыеНачисленияУдержания(Движения, СовмещающийСотрудник, КонецДня(ДатаОкончания) + 1, Организация, Ложь);
	
	СостоянияСотрудников.ЗарегистрироватьСостояниеСотрудника(Движения, Ссылка, СовмещающийСотрудник, Перечисления.СостоянияСотрудника.Увольнение, КонецДня(ДатаОкончания) + 1);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ГоловнойСотрудник) И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ИсключаемыеСсылки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект.Ссылка);
		КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(ЭтотОбъект.ДатаОкончания, ЭтотОбъект.СовмещающийСотрудник, ИсключаемыеСсылки, Отказ );
		
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ,"ПериодическиеСведения");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	КадровыеДанныеПодработки = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СовмещающийСотрудник, "ГоловнойСотрудник,ФизическоеЛицо,НазначениеПодработки");
	Если КадровыеДанныеПодработки.Количество() > 0 Тогда
		
		ДанныеПодработки = КадровыеДанныеПодработки[0];
		
		ФизическоеЛицо = ДанныеПодработки.ФизическоеЛицо;
		ГоловнойСотрудник = ДанныеПодработки.ГоловнойСотрудник;
		
		Если ДокументОснование <> ДанныеПодработки.НазначениеПодработки Тогда
			ДокументОснование = ДанныеПодработки.НазначениеПодработки;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СовмещающийСотрудник КАК Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаОкончания, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ПрекращениеПодработки КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли