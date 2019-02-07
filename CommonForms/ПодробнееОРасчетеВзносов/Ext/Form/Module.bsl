﻿&НаКлиенте
Перем СтарыеЗначенияКонтролируемыхПолей;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаКнопокПросмотр.Видимость			= ТолькоПросмотр;
	Элементы.ГруппаКнопокРедактирование.Видимость	= Не ТолькоПросмотр;
	Если ТолькоПросмотр Тогда
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию	= Истина;
	Иначе
		Элементы.ФормаОК.КнопкаПоУмолчанию		= Истина;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	МесяцНачисления = Параметры.МесяцНачисления;
	ИмяДокумента = Параметры.ИмяДокумента;
	ОписаниеДокумента = Новый ФиксированнаяСтруктура(Параметры.ОписаниеДокумента);
	
	СписокСотрудников = Параметры.УчитываемыеСотрудники;
	Если ТипЗнч(СписокСотрудников) = Тип("Строка")
		И Не ПустаяСтрока(СписокСотрудников) Тогда
		
		СписокСотрудников = ПолучитьИзВременногоХранилища(СписокСотрудников);
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(СписокСотрудников) Тогда
		
		Если ТипЗнч(СписокСотрудников) <> Тип("Массив") Тогда
			СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СписокСотрудников);
		КонецЕсли;
		
		Если СписокСотрудников.Количество() > 0 Тогда
			
			Если ТипЗнч(СписокСотрудников[0]) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				УчитываемыеСотрудники = Новый ФиксированныйМассив(СписокСотрудников);
			Иначе
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("СписокСотрудников", СписокСотрудников);
				Запрос.Текст =
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
					|	Сотрудники.ФизическоеЛицо
					|ИЗ
					|	Справочник.Сотрудники КАК Сотрудники
					|ГДЕ
					|	Сотрудники.Ссылка В(&СписокСотрудников)
					|
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	ФизическиеЛица.Ссылка
					|ИЗ
					|	Справочник.ФизическиеЛица КАК ФизическиеЛица
					|ГДЕ
					|	ФизическиеЛица.Ссылка В(&СписокСотрудников)";
					
				УчитываемыеСотрудники = Новый ФиксированныйМассив(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо"));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	ЗаполнитьФормуНаСервере(Параметры.СведенияОВзносах, Истина);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыНДФЛ

&НаКлиенте
Процедура ВзносыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ЗаполнитьНовуюСтроку(Элементы.Взносы.ТекущиеДанные);
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПеренестиИзмененияВОбъектФормыВладельца();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзмененияВОбъектФормыВладельца()
	
	Если Модифицированность Тогда
		
		Оповестить(
			"ИзмененыРезультатыРасчетаВзносов",
			ПоместитьИзмененныеДанныеВоВременноеХранилище(),
			ЭтаФорма);
		
		Модифицированность = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	
	ВозвращаемыеСведения = Новый Структура;
	ВозвращаемыеСведения.Вставить("ВзносыФОТ", Взносы);
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьФормуНаСервере(Знач СведенияОВзносах, Знач ПервичноеЗаполнение)
	
	ТабличныеЧасти = ПолучитьИзВременногоХранилища(СведенияОВзносах);
	
	Если ТолькоПросмотр И ТабличныеЧасти.ВзносыФОТ.Количество() = 0
		Или УчитываемыеСотрудники = Неопределено ИЛИ УчитываемыеСотрудники.Количество() = 0 Тогда
		
		ВызватьИсключение  НСтр("ru='Нет сведений о расчете взносов';uk='Немає відомостей про розрахунок внесків'");
		
	КонецЕсли; 
	
	ЕдинственныйСотрудник = УчитываемыеСотрудники.Количество() < 2;
	Если ПервичноеЗаполнение Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВзносыФизическоеЛицо",
			"ПараметрыВыбора",
			Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый ПараметрВыбора("Отбор.Ссылка", УчитываемыеСотрудники))));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВзносыФизическоеЛицо",
			"Видимость",
			Не ЕдинственныйСотрудник);
		
		Элементы.Взносы.ТекущаяСтрока	= 0;
		
		Если ТолькоПросмотр Тогда
			Элементы.Взносы.ПоложениеКоманднойПанели	= ПоложениеКоманднойПанелиЭлементаФормы.Нет;
			Элементы.Взносы.ИзменятьСоставСтрок		= Ложь;
		КонецЕсли;
			
	КонецЕсли; 
	
	// Инициализация табличных частей
	Взносы.Загрузить(ТабличныеЧасти.ВзносыФОТ);
	
	//ОписаниеТаблицы = УчетНДФЛКлиентСервер.ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ();
	//ОписаниеТаблицы.ОтменятьВсеИсправления = Не ЕдинственныйСотрудник;
	//
	//УчетНДФЛФормы.ФормаПодробнееОРасчетеНДФЛПриЗаполнении(ЭтаФорма, ОписаниеТаблицы, ОписанияТаблицДляРаспределенияРезультата());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНовуюСтроку(НоваяСтрока)
	
	Если УчитываемыеСотрудники.Количество() = 1 И ЕдинственныйСотрудник Тогда
		НоваяСтрока.ФизическоеЛицо = УчитываемыеСотрудники[0];
	КонецЕсли; 
	
	НоваяСтрока.ДатаНачала = НачалоМесяца(МесяцНачисления);
	НоваяСтрока.ДатаОкончания = КонецМесяца(МесяцНачисления);

КонецПроцедуры

#КонецОбласти

