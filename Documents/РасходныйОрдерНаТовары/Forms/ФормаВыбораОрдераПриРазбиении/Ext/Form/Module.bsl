﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Ордер = Параметры.Ордер;
	РеквизитыОрдера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ордер, "Склад,Помещение,СкладскаяОперация,Получатель,ОтгрузкаПоЗаданиюНаПеревозку");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,РеквизитыОрдера); 
	
	ЭлементВыбора = Элементы.ОтборПоРаспоряжениям.СписокВыбора.НайтиПоЗначению("ОрдераПоПолучателю");
	ЭлементВыбора.Представление = СтрЗаменить(ЭлементВыбора.Представление, "%Получатель%", Получатель);

	Элементы.РасходныеОрдераТранспортноеСредство.Видимость = ОтгрузкаПоЗаданиюНаПеревозку;
	Элементы.РасходныеОрдераЗаданиеНаПеревозкуНомер.Видимость = ОтгрузкаПоЗаданиюНаПеревозку;
	
	ОтборПоРаспоряжениям = "ОрдераПоРаспоряжениям";
	
	ЗаполнитьСписокОрдеров();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоРаспоряжениямПриИзменении(Элемент)
	ЗаполнитьСписокОрдеров();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоРаспоряжениямОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаспоряжения

&НаКлиенте
Процедура РасходныеОрдераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.РасходныеОрдера.ТекущиеДанные;
	ОповеститьОВыборе(ТекущиеДанные.РасходныйОрдер);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущиеДанные = Элементы.РасходныеОрдера.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупрежедения = НСтр("ru='Выберите расходный ордер.';uk='Виберіть видатковий ордер.'");
		ПоказатьПредупреждение(,ТекстПредупрежедения);
		Возврат;
	КонецЕсли;
		
	ОповеститьОВыборе(ТекущиеДанные.РасходныйОрдер);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСписокОрдеров()
	
	Если ПустаяСтрока(ОтборПоРаспоряжениям) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОтборПоРаспоряжениям = "ОрдераПоРаспоряжениям" Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение
		|ПОМЕСТИТЬ РаспоряженияОрдера
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
		|ГДЕ
		|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка = &Ордер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РасходныйОрдерРаспоряжения.Ссылка КАК Ссылка,
		|	РасходныйОрдерРаспоряжения.Распоряжение КАК Распоряжение
		|ПОМЕСТИТЬ ДругиеРасходныеОрдераРаспоряжения
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерРаспоряжения
		|ГДЕ
		|	РасходныйОрдерРаспоряжения.Ссылка <> &Ордер
		|	И РасходныйОрдерРаспоряжения.Ссылка.Склад = &Склад
		|	И РасходныйОрдерРаспоряжения.Ссылка.Помещение = &Помещение
		|	И РасходныйОрдерРаспоряжения.Ссылка.ОтгрузкаПоЗаданиюНаПеревозку = &ОтгрузкаПоЗаданиюНаПеревозку
		|	И РасходныйОрдерРаспоряжения.Ссылка.СкладскаяОперация = &СкладскаяОперация
		|	И РасходныйОрдерРаспоряжения.Ссылка.Получатель = &Получатель
		|	И РасходныйОрдерРаспоряжения.Ссылка.Проведен
		|	И РасходныйОрдерРаспоряжения.Распоряжение В
		|			(ВЫБРАТЬ
		|				РаспоряженияОрдера.Распоряжение
		|			ИЗ
		|				РаспоряженияОрдера)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.Ссылка
		|ПОМЕСТИТЬ ОтобранныеОрдера
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДругиеРасходныеОрдераРаспоряжения.Ссылка КАК Ссылка,
		|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДругиеРасходныеОрдераРаспоряжения.Распоряжение) КАК КоличествоРаспоряженийВДругомОрдере
		|	ИЗ
		|		ДругиеРасходныеОрдераРаспоряжения КАК ДругиеРасходныеОрдераРаспоряжения
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДругиеРасходныеОрдераРаспоряжения.Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЕСТЬNULL(ДругиеРасходныеОрдераРаспоряжения.Ссылка, НЕОПРЕДЕЛЕНО),
		|		-КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РаспоряженияОрдера.Распоряжение)
		|	ИЗ
		|		РаспоряженияОрдера КАК РаспоряженияОрдера
		|			ЛЕВОЕ СОЕДИНЕНИЕ ДругиеРасходныеОрдераРаспоряжения КАК ДругиеРасходныеОрдераРаспоряжения
		|			ПО РаспоряженияОрдера.Распоряжение = ДругиеРасходныеОрдераРаспоряжения.Распоряжение
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ЕСТЬNULL(ДругиеРасходныеОрдераРаспоряжения.Ссылка, НЕОПРЕДЕЛЕНО)) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Ссылка
		|
		|ИМЕЮЩИЕ
		|	СУММА(ВложенныйЗапрос.КоличествоРаспоряженийВДругомОрдере) = 0";
	ИначеЕсли ОтборПоРаспоряжениям = "ОрдераПоПолучателю" Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	РасходныйОрдер.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ОтобранныеОрдера
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары КАК РасходныйОрдер
		|ГДЕ
		|	РасходныйОрдер.Ссылка <> &Ордер
		|	И РасходныйОрдер.Склад = &Склад
		|	И РасходныйОрдер.Помещение = &Помещение
		|	И РасходныйОрдер.ОтгрузкаПоЗаданиюНаПеревозку = &ОтгрузкаПоЗаданиюНаПеревозку
		|	И РасходныйОрдер.СкладскаяОперация = &СкладскаяОперация
		|	И РасходныйОрдер.Получатель = &Получатель
		|	И РасходныйОрдер.Проведен";
	КонецЕсли;
	
	ТекстЗапроса = 	ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапроса = 	ТекстЗапроса + 	
	"ВЫБРАТЬ
	|	ОтобранныеОрдера.Ссылка КАК РасходныйОрдер,
	|	ОтобранныеОрдера.Ссылка.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|	ОтобранныеОрдера.Ссылка.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ОтобранныеОрдера.Ссылка.ЗаданиеНаПеревозку.ТранспортноеСредство КАК ТранспортноеСредство
	|ИЗ
	|	ОтобранныеОрдера КАК ОтобранныеОрдера
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтгрузки УБЫВ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ордер",Ордер);
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("Помещение",Помещение);
	Запрос.УстановитьПараметр("ОтгрузкаПоЗаданиюНаПеревозку",ОтгрузкаПоЗаданиюНаПеревозку);
	Запрос.УстановитьПараметр("СкладскаяОперация",СкладскаяОперация);
	Запрос.УстановитьПараметр("Получатель",Получатель);
	
	
	РасходныеОрдера.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

#КонецОбласти