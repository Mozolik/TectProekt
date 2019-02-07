﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("УтверждениеНовойТарифнойСетки")
		И ДополнительныеСвойства.УтверждениеНовойТарифнойСетки = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ТарифнаяСетка");	
	КонецЕсли; 
	
	ДанныеТарифнойСетки = РазрядыКатегорииДолжностей.ДанныеТарифнойСетки(ТарифнаяСетка, ДатаВступленияВСилу, Ссылка);
	ПервоеУтверждениеТарифов = Не ЗначениеЗаполнено(ДанныеТарифнойСетки.ДатаИзменения);
	
	Если Не (ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Тариф
		И ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении")) Тогда
		
		ТарифыДокумента = Тарифы.Выгрузить(Новый Структура("Отменить", Ложь));
		ТарифыДокумента.Колонки.Добавить("РеквизитДопУпорядочивания", Новый ОписаниеТипов("Число"));
		
		СписокРазрядов = ТарифыДокумента.ВыгрузитьКолонку("РазрядКатегория");
		РеквизитыДопУпорядочиванияРазрядов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокРазрядов, "РеквизитДопУпорядочивания");
		Для каждого СтрокаТарифы Из ТарифыДокумента Цикл
			СтрокаТарифы.РеквизитДопУпорядочивания = РеквизитыДопУпорядочиванияРазрядов.Получить(СтрокаТарифы.РазрядКатегория);
		КонецЦикла;
		
		ТарифыДокумента.Сортировать("РеквизитДопУпорядочивания");
		
		ПредыдущаяСтрока = Неопределено;
		Для Каждого ТекСтрока Из ТарифыДокумента Цикл 
			Если ПредыдущаяСтрока = Неопределено Тогда 
				ПредыдущаяСтрока = ТекСтрока;
				Продолжить;
			КонецЕсли;
			Если ТекСтрока.Тариф < ПредыдущаяСтрока.Тариф Тогда 
				ТекстСообщения = НСтр("ru='Значение тарифа для разряда %1 меньше, чем для разряда %2';uk='Значення тарифу для розряду %1 менше, ніж для розряду %2'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ТекСтрока.РазрядКатегория, ПредыдущаяСтрока.РазрядКатегория);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Тарифы[" + Формат(ТекСтрока.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Тариф", , Отказ);
			КонецЕсли;
			ПредыдущаяСтрока = ТекСтрока;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	РазрядыКатегорииДолжностей.СформироватьДвиженияЗначенийРазрядовТарифнойСетки(Движения, ДанныеДляПроведения.ДанныеРазрядовТарифнойСетки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.ДатаВступленияВСилу КАК ДатаСобытия,
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.ТарифнаяСетка КАК ТарифнаяСетка,
		|	УтверждениеТарифнойСеткиТарифы.РазрядКатегория,
		|	ВЫБОР
		|		КОГДА УтверждениеТарифнойСеткиТарифы.Ссылка.ТарифнаяСетка.ПрименениеТарифныхКоэффициентов
		|			ТОГДА УтверждениеТарифнойСеткиТарифы.РазрядныйКоэффициент
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК РазрядныйКоэффициент,
		|	УтверждениеТарифнойСеткиТарифы.Тариф КАК Тариф,
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.БазовыйТарифГруппы КАК БазовыйТарифГруппы,
		|	НЕ УтверждениеТарифнойСеткиТарифы.Отменить КАК Используется
		|ИЗ
		|	Документ.УтверждениеТарифнойСетки.Тарифы КАК УтверждениеТарифнойСеткиТарифы
		|ГДЕ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура;
	
	ДанныеРазрядовТарифнойСетки = РезультатыЗапроса[0].Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеРазрядовТарифнойСетки", ДанныеРазрядовТарифнойСетки);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
