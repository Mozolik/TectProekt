﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			ДанныеЗаполнения = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
		ГоловнойСотрудник = ДанныеЗаполнения;
		
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	// Движения по регистру сведений "Состояния подработок".
	РегистрыСведений.СостоянияПодработок.СформироватьДвижения(ЭтотОбъект, Движения, ДанныеДляПроведения.СостоянияПодработок);
	
	КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков(Движения, ДанныеДляПроведения.ИсторияГрафиков);	
	РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников(Движения, ДанныеДляПроведения.РазрядыКатегорииСотрудников);
	РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников(Движения, ДанныеДляПроведения.ПКУСотрудников);
	
	Если Утверждено Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
		СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения.ПрименениеДополнительныхПоказателей);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения.ПорядокПересчетаТарифнойСтавки);
		РасчетЗарплатыРасширенный.СформироватьДвиженияЗначенийСовокупныхТарифныхСтавок(Движения, ДанныеДляПроведения.ДанныеСовокупныхТарифныхСтавок);
		
	КонецЕсли;

	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДатаИзменения = ДатаНачала;
		
	Если ДатаНачала > ДатаОкончания	И ЗначениеЗаполнено(ДатаОкончания) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата окончания не может быть меньше даты назначения';uk='Дата закінчення не може бути менша дати призначення'"), ЭтотОбъект, "ДатаОкончания", , Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СовмещающийСотрудник) Тогда 
		Если ГоловнойСотрудник <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СовмещающийСотрудник, "ГоловнойСотрудник") Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Нельзя изменять сотрудника подработки';uk='Не можна змінювати співробітника підробітку'"), ЭтотОбъект, "ГоловнойСотрудник", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	КадровыеДанныеГоловногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ГоловнойСотрудник, "ОформленПоТрудовомуДоговору, ДатаУвольнения", ДатаНачала);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если КадровыеДанныеГоловногоСотрудника.Количество() > 0 Тогда
		
		Если КадровыеДанныеГоловногоСотрудника[0].ОформленПоТрудовомуДоговору <> Истина Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Подработку можно назначить только работнику, оформленному по трудовому договору.';uk='Підробіток можна призначити тільки працівнику, оформленим за трудовим договором.'"), ЭтотОбъект, "ГоловнойСотрудник", , Отказ);
		КонецЕсли;
		
		Если КадровыеДанныеГоловногоСотрудника[0].ДатаУвольнения >= ДатаНачала Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Сотрудник уволен.';uk='Співробітник звільнений.'"), ЭтотОбъект, "ГоловнойСотрудник", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаИзменения, "Начисления", "Показатели", Отказ, Истина);
	
	Если Утверждено Тогда
		
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениРаботникВШапке(ДатаИзменения, СовмещающийСотрудник, Начисления, Ссылка, Отказ);
		РасчетЗарплатыРасширенный.ПроверитьУникальностьЗапрашиванияПоказателяСотрудникВШапке(Начисления.Выгрузить(), Показатели.Выгрузить(), СовмещающийСотрудник, ДатаИзменения, Ссылка, Отказ);
		ПараметрыОтображенияПолейТарифнойСтавки = ЗарплатаКадрыРасширенный.ПараметрыОтображенияТарифнойСтавкиСотрудникВШапке(ГоловнойСотрудник, Начисления);
		Если Не ПараметрыОтображенияПолейТарифнойСтавки.НесколькоТарифныхСтавок Тогда 
			ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
		КонецЕсли;
		ЗарплатаКадрыРасширенный.ПроверитьЗаполнениеВидаТарифнойСтавки(ЭтотОбъект, Отказ);
	Иначе 
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	Если Не Утверждено Или Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Начисление");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Показатели");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Должность");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Подразделение");
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДолжностьПоШтатномуРасписанию");
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
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
	
	ОбновитьСовмещающегоСотрудника(РежимЗаписи);
	
	// Заполнение физических лиц по сотрудникам.
	// В документе два реквизита с типом "Справочник.Сотрудники", в силу этой особенности
	// типовой механизм через подписки на события не подошел.
	ЭтотОбъект.ФизическиеЛица.Очистить();
	
	Сотрудники = Новый Массив;
	Сотрудники.Добавить(ГоловнойСотрудник);
	Сотрудники.Добавить(ОтсутствующийСотрудник);
	
	ФизическиеЛицаДокумента = КадровыйУчет.ФизическиеЛицаСотрудников(Сотрудники);
	
	Для Каждого ФизическоеЛицоДокумента Из ФизическиеЛицаДокумента Цикл
		СтрокаФизическогоЛица = ЭтотОбъект.ФизическиеЛица.Добавить();
		СтрокаФизическогоЛица.ФизическоеЛицо = ФизическоеЛицоДокумента;
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
		УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.БухучетЗарплатыСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументОснование.Установить(Ссылка);
		
	Если Проведен
		И (ЗначениеЗаполнено(СтатьяФинансирования) 
			Или ЗначениеЗаполнено(СпособОтраженияЗарплатыВБухучете)
			) Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		
		НоваяЗапись.Период = ДатаНачала;
		НоваяЗапись.Сотрудник = СовмещающийСотрудник;
		НоваяЗапись.ДокументОснование = Ссылка;
		
		НоваяЗапись.СпособОтраженияЗарплатыВБухучете = СпособОтраженияЗарплатыВБухучете;
		НоваяЗапись.СтатьяФинансирования = СтатьяФинансирования;
		
	КонецЕсли; 
	
	НаборЗаписей.Записать();		

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидЗанятости", Перечисления.ВидыЗанятости.Подработка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработкиПоказатели.Ссылка,
		|	НазначениеПодработкиПоказатели.Показатель
		|ПОМЕСТИТЬ ВТПоказателиНачислений
		|ИЗ
		|	Документ.НазначениеПодработки.Показатели КАК НазначениеПодработкиПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НазначениеПодработки.Начисления КАК НазначениеПодработкиНачисления
		|		ПО НазначениеПодработкиПоказатели.Ссылка = НазначениеПодработкиНачисления.Ссылка
		|			И НазначениеПодработкиПоказатели.ИдентификаторСтрокиВидаРасчета = НазначениеПодработкиНачисления.ИдентификаторСтрокиВидаРасчета
		|ГДЕ
		|	НазначениеПодработкиПоказатели.Ссылка = &Ссылка
		|	И НазначениеПодработкиНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработки.ДолжностьПоШтатномуРасписанию КАК Позиция,
		|	НазначениеПодработки.Подразделение КАК Подразделение,
		|	НазначениеПодработки.Должность КАК Должность,
		|	НазначениеПодработки.КоличествоСтавок,
		|	НазначениеПодработки.ГрафикРаботы КАК ГрафикРаботы,
		|	&ВидЗанятости КАК ВидЗанятости,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием) КАК ВидСобытия,
		|	НазначениеПодработки.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработки.ГоловнойСотрудник КАК ГоловнойСотрудник,
		|	НазначениеПодработки.ОтсутствующийСотрудник КАК ОтсутствующийСотрудник
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка";
	
	ДанныеДляПроведения = Новый Структура;
	
	// Первый набор данных для проведения - для формирования  движений по РС СостоянияПодработок.
	КадровыеДвижения = Запрос.Выполнить().Выгрузить();
	КадровыеДвиженияДляИсторииГрафиковРаботы = КадровыеДвижения.Скопировать();
	ДанныеДляПроведения.Вставить("СостоянияПодработок", КадровыеДвижения);
	
	// Для формирования истории графиков.
	КадровыеДвиженияДляИсторииГрафиковРаботы.Колонки.Удалить("ГоловнойСотрудник");
	КадровыеДвиженияДляИсторииГрафиковРаботы.Колонки.Удалить("ОтсутствующийСотрудник");
	ДанныеДляПроведения.Вставить("ИсторияГрафиков", КадровыеДвиженияДляИсторииГрафиковРаботы);

	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработкиНачисления.Начисление,
		|	НазначениеПодработкиНачисления.ДокументОснование,
		|	ВЫБОР
		|		КОГДА НазначениеПодработкиНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	НазначениеПодработки.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработки.СовмещающийСотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	НазначениеПодработкиНачисления.Размер
		|ИЗ
		|	Документ.НазначениеПодработки.Начисления КАК НазначениеПодработкиНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НазначениеПодработки КАК НазначениеПодработки
		|		ПО НазначениеПодработкиНачисления.Ссылка = НазначениеПодработки.Ссылка
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка";
	
	// Второй набор данных для проведения - таблица для формирования плановых начислений
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если Утверждено Тогда
		ПлановыеНачисления = Запрос.Выполнить().Выгрузить();
	Иначе	
		ПлановыеНачисления = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработки.Организация КАК Организация,
		|	НазначениеПодработки.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработкиПоказатели.Показатель,
		|	НазначениеПодработкиНачисления.ДокументОснование,
		|	НазначениеПодработкиПоказатели.Значение,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ПОМЕСТИТЬ ВТВсеПоказатели
		|ИЗ
		|	Документ.НазначениеПодработки.Показатели КАК НазначениеПодработкиПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НазначениеПодработки.Начисления КАК НазначениеПодработкиНачисления
		|		ПО НазначениеПодработкиПоказатели.Ссылка = НазначениеПодработкиНачисления.Ссылка
		|			И НазначениеПодработкиПоказатели.ИдентификаторСтрокиВидаРасчета = НазначениеПодработкиНачисления.ИдентификаторСтрокиВидаРасчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НазначениеПодработки КАК НазначениеПодработки
		|		ПО НазначениеПодработкиПоказатели.Ссылка = НазначениеПодработки.Ссылка
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка
		|	И НазначениеПодработкиНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НазначениеПодработкиПоказатели.Ссылка.ДатаНачала,
		|	НазначениеПодработкиПоказатели.Ссылка.Организация,
		|	НазначениеПодработкиПоказатели.Ссылка.СовмещающийСотрудник.ФизическоеЛицо,
		|	НазначениеПодработкиПоказатели.Ссылка.СовмещающийСотрудник,
		|	НазначениеПодработкиПоказатели.Показатель,
		|	НЕОПРЕДЕЛЕНО,
		|	НазначениеПодработкиПоказатели.Значение,
		|	ВЫБОР
		|		КОГДА НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания
		|	КОНЕЦ
		|ИЗ
		|	Документ.НазначениеПодработки.Показатели КАК НазначениеПодработкиПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
		|		ПО НазначениеПодработкиПоказатели.Ссылка = ПоказателиНачислений.Ссылка
		|			И НазначениеПодработкиПоказатели.Показатель = ПоказателиНачислений.Показатель
		|ГДЕ
		|	НазначениеПодработкиПоказатели.Ссылка = &Ссылка
		|	И НазначениеПодработкиПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И НазначениеПодработкиПоказатели.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|	И НазначениеПодработкиПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И ПоказателиНачислений.Показатель ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеПоказатели.ДатаСобытия,
		|	ВсеПоказатели.Организация,
		|	ВсеПоказатели.ФизическоеЛицо,
		|	ВсеПоказатели.Сотрудник,
		|	ВсеПоказатели.Показатель,
		|	ВсеПоказатели.ДокументОснование,
		|	МАКСИМУМ(ВсеПоказатели.Значение) КАК Значение,
		|	ВсеПоказатели.ДействуетДо
		|ИЗ
		|	ВТВсеПоказатели КАК ВсеПоказатели
		|
		|СГРУППИРОВАТЬ ПО
		|	ВсеПоказатели.ДатаСобытия,
		|	ВсеПоказатели.Организация,
		|	ВсеПоказатели.ФизическоеЛицо,
		|	ВсеПоказатели.Сотрудник,
		|	ВсеПоказатели.Показатель,
		|	ВсеПоказатели.ДокументОснование,
		|	ВсеПоказатели.ДействуетДо";
	
	// Третий набор данных для проведения - таблица значений показателей расчета зарплаты
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если Утверждено Тогда
		ЗначенияПоказателей = Запрос.Выполнить().Выгрузить();
	Иначе	
		ЗначенияПоказателей = Неопределено;
	КонецЕсли;

	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);

	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработкиПоказатели.Ссылка.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработкиПоказатели.Ссылка.Организация КАК Организация,
		|	НазначениеПодработкиПоказатели.Ссылка.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработкиПоказатели.Ссылка.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработкиПоказатели.Показатель КАК Показатель,
		|	ВЫБОР
		|		КОГДА НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработкиПоказатели.Ссылка.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо,
		|	ВЫБОР
		|		КОГДА НазначениеПодработкиПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Применение
		|ИЗ
		|	Документ.НазначениеПодработки.Показатели КАК НазначениеПодработкиПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
		|		ПО НазначениеПодработкиПоказатели.Ссылка = ПоказателиНачислений.Ссылка
		|			И НазначениеПодработкиПоказатели.Показатель = ПоказателиНачислений.Показатель
		|ГДЕ
		|	НазначениеПодработкиПоказатели.Ссылка = &Ссылка
		|	И НазначениеПодработкиПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И НазначениеПодработкиПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И ПоказателиНачислений.Показатель ЕСТЬ NULL ";
	
	// Четвертый набор данных для проведения - таблица применения дополнительных показателей
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если Утверждено Тогда
		ПрименениеДополнительныхПоказателей = Запрос.Выполнить().Выгрузить();
	Иначе 
		ПрименениеДополнительныхПоказателей = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПрименениеДополнительныхПоказателей", ПрименениеДополнительныхПоказателей);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработки.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработки.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка";
	
	// Пятый набор данных для проведения - таблица значений порядка пересчета тарифной ставки
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок.
	Если Утверждено Тогда
		ПорядокПересчетаТарифнойСтавки = Запрос.Выполнить().Выгрузить();
	Иначе 
		ПорядокПересчетаТарифнойСтавки = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПорядокПересчетаТарифнойСтавки", ПорядокПересчетаТарифнойСтавки);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработки.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НазначениеПодработки.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ НазначениеПодработки.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка";
	
	// Шестой набор данных для проведения - таблица значений совокупной тарифной ставки
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияЗначенийСовокупныхТарифныхСтавок.
	Если Утверждено Тогда
		ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
	Иначе 
		ДанныеСовокупныхТарифныхСтавок = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработки.РазрядКатегория КАК РазрядКатегория,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка
		|	И НазначениеПодработки.РазрядКатегория <> ЗНАЧЕНИЕ(Справочник.РазрядыКатегорииДолжностей.ПустаяСсылка)";
	
	// Седьмой набор данных для проведения - таблица значений разряда сотрудника
	// см. описание РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников.
	РазрядыКатегорииСотрудников = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("РазрядыКатегорииСотрудников", РазрядыКатегорииСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НазначениеПодработки.ДатаНачала КАК ДатаСобытия,
		|	НазначениеПодработки.СовмещающийСотрудник КАК Сотрудник,
		|	НазначениеПодработки.ПКУ КАК ПКУ,
		|	ВЫБОР
		|		КОГДА НазначениеПодработки.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(НазначениеПодработки.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ НазначениеПодработки.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.Ссылка = &Ссылка
		|	И НазначениеПодработки.ПКУ <> ЗНАЧЕНИЕ(Справочник.РазрядыКатегорииДолжностей.ПустаяСсылка)";
	
	// Восьмой набор данных для проведения - таблица значений ПКУ сотрудника
	// см. описание РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников.
	ПКУСотрудников = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ПКУСотрудников", ПКУСотрудников);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ОбновитьСовмещающегоСотрудника(Знач РежимЗаписи)

	// Проверим на установку/ снятие пометки удаления.
	Если РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		
		Если ЗначениеЗаполнено(СовмещающийСотрудник) Тогда
			СотрудникПодработки = СовмещающийСотрудник.ПолучитьОбъект();
			СотрудникПодработки.УстановитьПометкуУдаления(ПометкаУдаления);
			СотрудникПодработки.Записать();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	УточнениеНаименования = УточнениеНаименованияПодработки();
		
	// Если нет подрабатывающего сотрудника, то создадим его.
	Если Не ЗначениеЗаполнено(СовмещающийСотрудник) Тогда
		СовмещающийСотрудник = КадровыйУчетРасширенный.СоздатьПодработкуСотрудника(ГоловнойСотрудник, УточнениеНаименования);
		Возврат;
	КонецЕсли;
	
	// Для существовавшего ранее подрабатывающего сотрудника обновляем уточнение наименования.
	ТекущееУточнение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СовмещающийСотрудник, "УточнениеНаименования");
	
	Если ТекущееУточнение <> УточнениеНаименования Тогда
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, ГоловнойСотрудник, "ГоловнойСотрудник,Фамилия,Имя,Отчество");
			
		Если КадровыеДанные.Количество() = 0
				Или ГоловнойСотрудник <> КадровыеДанные[0].ГоловнойСотрудник Тогда
				
			ВызватьИсключение НСтр("ru='Неверно указан основной сотрудник';uk='Невірно вказаний основний співробітник'");
			
		КонецЕсли; 
		
		КадровыеДанныеСотрудника = КадровыеДанные[0];
		
		СотрудникОбъект = СовмещающийСотрудник.ПолучитьОбъект();
		СотрудникОбъект.ГоловнойСотрудник = ГоловнойСотрудник;
		СотрудникОбъект.УточнениеНаименования = УточнениеНаименования;
		
		СотрудникОбъект.Наименование = КадровыйУчетКлиентСервер.ПолноеНаименованиеСотрудника(
			КадровыеДанныеСотрудника.Фамилия,
			КадровыеДанныеСотрудника.Имя,
			КадровыеДанныеСотрудника.Отчество,
			,
			СотрудникОбъект.УточнениеНаименования);
		
		СотрудникОбъект.Записать();

	КонецЕсли;
	
КонецПроцедуры

// Возвращает Строку:
//	НаименованиеКраткое из должности + Количество подработок с таким же кратким наименованием.
//
Функция УточнениеНаименованияПодработки() Экспорт
	
	Если ДополнительныеСвойства.Свойство("УточнениеНаименования") Тогда
		Возврат ДополнительныеСвойства.УточнениеНаименования;
	КонецЕсли;

	// 1 Получаем Все действующие подработки сотрудника 
	//  по условию ГоловнойСотрудник и совпадение НаименованиеКраткое у должности.
	// 2 Возвращаем НаименованиеКраткое + Количество подработок.
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Сотрудник", ГоловнойСотрудник);
	Запрос.УстановитьПараметр("ДатаСобытия", ДатаНачала);
		
	ДолжностьПодработки = Справочники.Должности.ПустаяСсылка();			   
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") 
					   И ЗначениеЗаполнено(ДолжностьПоШтатномуРасписанию) Тогда
		ДолжностьПодработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДолжностьПоШтатномуРасписанию, "Должность");
	ИначеЕсли ЗначениеЗаполнено(Должность) Тогда
		ДолжностьПодработки = Должность;
	КонецЕсли;	
	Запрос.УстановитьПараметр("Должность", ДолжностьПодработки);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Сотрудник,
	               |	&ДатаСобытия КАК НачалоПериода,
	               |	&ДатаСобытия КАК ОкончаниеПериода
	               |ПОМЕСТИТЬ ВТСотрудникиПериоды
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |ГДЕ
	               |	Сотрудники.ГоловнойСотрудник = &Сотрудник";
				   
	Запрос.Выполнить();
	
	ПараметрыПолученияПодработок = КадровыйУчет.ПараметрыДляЗапросВТРабочиеМестаСотрудниковПоВременнойТаблице();
	
	ПараметрыПолученияПодработок.РаботникиПоТрудовымДоговорам = Неопределено;
	ПараметрыПолученияПодработок.ПодработкиРаботниковПоТрудовымДоговорам = Истина;
	ПараметрыПолученияПодработок.РаботникиПоДоговорамГПХ = Неопределено;
	
	КадровыйУчет.СоздатьВТРабочиеМестаСотрудниковПоВременнойТаблице(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияПодработок);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Должности.НаименованиеКраткое КАК НаименованиеКраткое,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РабочиеМестаСотрудников.Сотрудник) КАК КоличествоПодработок
	               |ИЗ
	               |	Справочник.Должности КАК Должности
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМестаСотрудников КАК РабочиеМестаСотрудников
	               |		ПО (РабочиеМестаСотрудников.Должность.НаименованиеКраткое = Должности.НаименованиеКраткое)
	               |ГДЕ
	               |	Должности.Ссылка = &Должность
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Должности.НаименованиеКраткое";               
				   
	Выборка = Запрос.Выполнить().Выбрать();			   
	
	Если Не Выборка.Следующий() Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Возврат Выборка.НаименованиеКраткое + " " + ?(Выборка.КоличествоПодработок > 0 ,Выборка.КоличествоПодработок + 1, ""); 
	
КонецФункции

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
	
 ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
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
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.НазначениеПодработки КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СовмещающийСотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаОкончания, МЕСЯЦ),
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.НазначениеПодработки КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|	И ТаблицаДокумента.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
