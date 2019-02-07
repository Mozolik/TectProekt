﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	

	Если Параметры.СтрокаПоиска = Неопределено Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Ссылка,
		|	ДанныеСправочника.Представление КАК Представление,
		|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.НомераГТД КАК ДанныеСправочника
		|ГДЕ
		|	Не ДанныеСправочника.Предопределенный
		|");
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ПоступлениеТоваровУслугТовары.Номенклатура,
		                      |	ПоступлениеТоваровУслугТовары.Характеристика,
		                      |	ПоступлениеТоваровУслугТовары.НомерГТД,
		                      |	ПоступлениеТоваровУслугТовары.Ссылка,
		                      |	ПоступлениеТоваровУслугТовары.Ссылка.Дата КАК Дата
		                      |ПОМЕСТИТЬ СочетанияНоменклатураГТД
		                      |ИЗ
		                      |	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		                      |ГДЕ
		                      |	ПоступлениеТоваровУслугТовары.Номенклатура = &Номенклатура
		                      |	И ПоступлениеТоваровУслугТовары.Характеристика = &Характеристика
		                      |	И ПоступлениеТоваровУслугТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура,
		                      |	ОприходованиеИзлишковТоваровТовары.Характеристика,
		                      |	ОприходованиеИзлишковТоваровТовары.НомерГТД,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОприходованиеИзлишковТоваровТовары
		                      |ГДЕ
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ОприходованиеИзлишковТоваровТовары.Характеристика = &Характеристика
		                      |	И ОприходованиеИзлишковТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	КорректировкаПоступленияТовары.Номенклатура,
		                      |	КорректировкаПоступленияТовары.Характеристика,
		                      |	КорректировкаПоступленияТовары.НомерГТД,
		                      |	КорректировкаПоступленияТовары.Ссылка,
		                      |	КорректировкаПоступленияТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.КорректировкаПоступления.Товары КАК КорректировкаПоступленияТовары
		                      |ГДЕ
		                      |	КорректировкаПоступленияТовары.Номенклатура = &Номенклатура
		                      |	И КорректировкаПоступленияТовары.Характеристика = &Характеристика
		                      |	И КорректировкаПоступленияТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ПересортицаТоваровТовары.Номенклатура,
		                      |	ПересортицаТоваровТовары.Характеристика,
		                      |	ПересортицаТоваровТовары.НомерГТД,
		                      |	ПересортицаТоваровТовары.Ссылка,
		                      |	ПересортицаТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ПересортицаТоваров.Товары КАК ПересортицаТоваровТовары
		                      |ГДЕ
		                      |	ПересортицаТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ПересортицаТоваровТовары.Характеристика = &Характеристика
		                      |	И ПересортицаТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура,
		                      |	ТаможеннаяДекларацияИмпортТовары.Характеристика,
		                      |	ТаможеннаяДекларацияИмпортТовары.НомерГТД,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ТаможеннаяДекларацияИмпорт.Товары КАК ТаможеннаяДекларацияИмпортТовары
		                      |ГДЕ
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура = &Номенклатура
		                      |	И ТаможеннаяДекларацияИмпортТовары.Характеристика = &Характеристика
		                      |	И ТаможеннаяДекларацияИмпортТовары.Ссылка.Проведен
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Дата УБЫВ
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	ДанныеСправочника.Ссылка КАК Ссылка,
		                      |	ДанныеСправочника.Представление КАК Представление,
		                      |	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		                      |	МАКСИМУМ(СочетанияНоменклатураГТД.Дата) КАК Порядок
		                      |ИЗ
		                      |	Справочник.НомераГТД КАК ДанныеСправочника
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ СочетанияНоменклатураГТД КАК СочетанияНоменклатураГТД
		                      |		ПО (СочетанияНоменклатураГТД.НомерГТД = ДанныеСправочника.Ссылка)
		                      |ГДЕ
		                      |	ДанныеСправочника.Код ПОДОБНО &СтрокаПоиска
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ДанныеСправочника.Ссылка,
		                      |	ДанныеСправочника.Представление,
		                      |	ДанныеСправочника.ПометкаУдаления
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Порядок УБЫВ");
		Запрос.УстановитьПараметр("Номенклатура", ?(Параметры.Свойство("Номенклатура"),Параметры.Номенклатура,Неопределено));
		Запрос.УстановитьПараметр("Характеристика", ?(Параметры.Свойство("Характеристика"),Параметры.Характеристика,Неопределено));
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	ВыборкаГТД = Запрос.Выполнить().Выбрать();
	Пока ВыборкаГТД.Следующий() Цикл
		ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления", ВыборкаГТД.Ссылка, ВыборкаГТД.ПометкаУдаления);
		Представление = СокрЛП(ВыборкаГТД.Представление);
		ДанныеВыбора.Добавить(ЭлементВыбора, Представление);
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли