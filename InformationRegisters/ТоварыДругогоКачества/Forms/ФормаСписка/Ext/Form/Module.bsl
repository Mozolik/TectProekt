﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Номенклатура") Тогда
		ОтборНоменклатура = Параметры.Номенклатура;
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОтборНоменклатура, Новый Структура("Качество"));
		ИмяЭлементаОтбора = ?(Реквизиты.Качество <> Перечисления.ГрадацииКачества.Новый, "НоменклатураБрак", "Номенклатура");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ИмяЭлементаОтбора,
			ОтборНоменклатура,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
	Иначе
		ВызватьИсключение НСтр("ru='Список товаров другого качества можно посмотреть
                                     |только в форме номенклатуры.'
                                     |;uk='Список товарів іншої якості можна подивитися
                                     |лише у формі номенклатури.'");		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ТоварыДругогоКачества", ОтборНоменклатура);
КонецПроцедуры
