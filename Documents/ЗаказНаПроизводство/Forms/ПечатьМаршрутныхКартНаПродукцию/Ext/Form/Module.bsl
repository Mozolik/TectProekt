﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокПродукцииДерево = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
	ЗначениеВРеквизитФормы(СписокПродукцииДерево, "СписокПродукции");
	УдалитьИзВременногоХранилища(Параметры.АдресХранилища);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбратьВсе(Команда)
	
	УстановитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомадаСнятьВыборСоВсех(Команда)
	
	УстановитьПометки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечать(Команда)
	
	ПараметрыПечати = СформироватьПараметрыПечати();
	
	Закрыть(ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "СписокПродукцииХарактеристика",
																		     "СписокПродукции.ХарактеристикиИспользуются");

КонецПроцедуры

#Область Прочее

&НаКлиенте
Функция СформироватьПараметрыПечати()
	
	ДанныеДляПечати = Новый Массив;
	МассивОбъектов = Новый Массив;
	
	ЭлементыПродукция = СписокПродукции.ПолучитьЭлементы();
	Для каждого СтрокаПродукция Из ЭлементыПродукция Цикл
		Если МассивОбъектов.Найти(СтрокаПродукция.Заказ) = Неопределено Тогда
			МассивОбъектов.Добавить(СтрокаПродукция.Заказ);
		КонецЕсли; 
		Если СтрокаПродукция.Пометка Тогда
			СтруктураДанных = Новый Структура("Заказ,НомерСтроки");
			ЗаполнитьЗначенияСвойств(СтруктураДанных, СтрокаПродукция);
			СтруктураДанных.Вставить("ЭтоПолуфабрикат", Ложь);
			ДанныеДляПечати.Добавить(СтруктураДанных);
		КонецЕсли; 
		ЭлементыПолуфабрикаты = СтрокаПродукция.ПолучитьЭлементы();
		Для каждого СтрокаПолуфабрикат Из ЭлементыПолуфабрикаты Цикл
			Если СтрокаПолуфабрикат.Пометка Тогда
				СтруктураДанных = Новый Структура("Заказ,НомерСтроки");
				ЗаполнитьЗначенияСвойств(СтруктураДанных, СтрокаПолуфабрикат);
				СтруктураДанных.Вставить("ЭтоПолуфабрикат", Истина);
				ДанныеДляПечати.Добавить(СтруктураДанных);
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ДанныеДляПечати", ДанныеДляПечати);
	ПараметрыПечати.Вставить("МассивОбъектов", МассивОбъектов);
	
	Возврат ПараметрыПечати;
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометки(Пометка)

	ЭлементыПродукция = СписокПродукции.ПолучитьЭлементы();
	Для каждого СтрокаПродукция Из ЭлементыПродукция Цикл
		СтрокаПродукция.Пометка = Пометка;
		ЭлементыПолуфабрикаты = СтрокаПродукция.ПолучитьЭлементы();
		Для каждого СтрокаПолуфабрикат Из ЭлементыПолуфабрикаты Цикл
			СтрокаПолуфабрикат.Пометка = Пометка;
		КонецЦикла; 
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
