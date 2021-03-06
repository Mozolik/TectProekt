﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидПоказателей = Параметры.ВидПоказателей;
	ОбновитьДеревоНовыхЭлементов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БыстрыйПоискНовыхПриИзменении(Элемент)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаОтчета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаОтчета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоНовыхЭлементов

&НаКлиенте
Процедура ДеревоНовыхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоСохраненныхЭлементов

&НаКлиенте
Процедура ДеревоСохраненныхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСохраненныйЭлемент(Команда)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискСохранненыхПриИзменении(Элемент)

	ОбновитьДеревоСохраненныхЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоВидуОтчетаПриИзменении(Элемент)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиНовыйЭлемент(Команда)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаОтчета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаОтчета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораЭлементаОтчета()
	
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВидЭлемента)
			ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Элемент не может быть выбран!';uk='Елемент не може бути вибраний!'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ЭлементОтчета,ВидЭлемента,НаименованиеДляПечати");
	Результат.ВидЭлемента = ТекущиеДанные.ВидЭлемента;
	Результат.НаименованиеДляПечати = ТекущиеДанные.НаименованиеДляПечати;
	Если ТекущиеДанные.Свойство("ЭтоСвязанный") Тогда
		Результат.Вставить("СвязанныйЭлемент", ТекущиеДанные.СвязанныйЭлемент);
		Результат.Вставить("ЭтоСвязанный", Истина);
	Иначе
		Результат.Вставить("ЭлементОтчета", ТекущиеДанные.ЭлементВидаОтчетности);
		Результат.Вставить("ЭтоСвязанный", Ложь);
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоНовыхЭлементов()
	
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискНовых;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоНовыхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСохраненныхЭлементов()

	ОбновитьДеревоСохраненныхЭлементовНаСервере();
	//++ НЕ УТКА
	Если ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		МеждународнаяОтчетностьКлиент.РазвернутьДеревоСохраненныхЭлеметов(ЭтаФорма, ДеревоСохраненныхЭлементов);
	КонецЕсли;
	//-- НЕ УТКА

КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоСохраненныхЭлементовНаСервере()
	
	Если НЕ ЗначениеЗаполнено(БыстрыйПоискСохраненных)
		И НЕ ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		СохраненныеЭлементы = ДеревоСохраненныхЭлементов.ПолучитьЭлементы();
		СохраненныеЭлементы.Очистить();
		Возврат;
	КонецЕсли;
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ИмяЭлементаДерева = "ДеревоСохраненныхЭлементов";
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.ФильтрПоВидуОтчета = ФильтрПоВидуОтчета;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискСохраненных;
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоСохраненныхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА

КонецПроцедуры

#КонецОбласти
