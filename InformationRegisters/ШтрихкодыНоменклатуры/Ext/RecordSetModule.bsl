﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ СтрокиСОшибками
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|			ИЛИ ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|			ИЛИ ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеЗаполненаХарактеристика
	|ИЗ
	|	СтрокиСОшибками КАК СтрокиСОшибками
	|ГДЕ
	|	ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)";

	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ТаблицаТоваров",  ЭтотОбъект.Выгрузить(,"НомерСтроки,Номенклатура,Характеристика"));
	
	ШаблонСообщения = НСтр("ru='Поле ""%Характеристика%"" не заполнено';uk='Поле ""%Характеристика%"" не заповнено'");
	ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Характеристика%", НСтр("ru='Характеристика';uk='Характеристика'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НеЗаполненаХарактеристика Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Характеристика","Запись",Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли