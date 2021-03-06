﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаНачала");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьУдержаниеВФормеДокументаПоРоли(
			ЭтаФорма, 
			Объект.Удержание, 
			Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям, 
			Новый Структура("СпособВыполненияУдержания", Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете));
		Если ЗначениеЗаполнено(Объект.Удержание) Тогда
			УдержаниеДействует = РасчетЗарплатыРасширенныйФормы.УдержаниеДействуетНаДату(
				Объект.Организация, Объект.ФизическоеЛицо, Объект.Удержание, Объект.ДатаНачала, Объект.Ссылка, Объект.ДокументОснование);
			РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийЗаполнитьПоказатели(ЭтаФорма);
		КонецЕсли;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("ФизическоеЛицо", Объект.ФизическоеЛицо);
	
	Оповестить("ИзменилсяСоставУдержанийСотрудника", ПараметрыОповещения, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

&НаКлиенте
Процедура УдержаниеПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	ДействиеПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание);
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание);
	
	РасчетЗарплатыРасширенныйФормы.УстановитьВидимостьВыбораВидаДействия(ЭтаФорма);
	
	УдержаниеДействует = РасчетЗарплатыРасширенныйФормы.УдержаниеДействуетНаДату(
		Объект.Организация, Объект.ФизическоеЛицо, Объект.Удержание, Объект.ДатаНачала, Объект.Ссылка, Объект.ДокументОснование);
	
	РасчетЗарплатыРасширенныйФормы.УстановитьСтраницуДействия(ЭтаФорма);
	УстановитьДоступностьПоляДатаОкончания();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляДатаОкончания()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Изменить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ИзменитьГруппа);
	ИначеЕсли Объект.Действие = Перечисления.ДействияСУдержаниями.Прекратить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ПрекратитьГруппа);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДействиеИПоказатели()
	РасчетЗарплатыРасширенныйФормы.УстановитьВидимостьВыбораВидаДействия(ЭтаФорма);
	РасчетЗарплатыРасширенныйФормы.ЗаполнитьДействиеИПоказатели(ЭтаФорма, Объект.ДокументОснование);
КонецПроцедуры

&НаСервере
Процедура ДействиеПриИзмененииНаСервере()
	
	ЗаполнитьДействиеИПоказатели();
	РасчетЗарплатыРасширенныйФормы.УстановитьДоступностьДокументаОснования(ЭтаФорма);
	УстановитьДоступностьПоляДатаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

#КонецОбласти
