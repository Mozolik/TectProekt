﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВосстановитьНастройкиОформленияСервер(Параметры.СтруктураНастроекОформления);
	
	УстановитьВидимостьДоступностьЭлементовФормы(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГрадиентДляПокомпонетногоСравненияПриИзменении(Элемент)
	Если Не ГрадиентДляПокомпонетногоСравнения Тогда
		ВыделятьМаксимальноеЗначениеДляПокомпонетногоСравнения = Ложь;
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ТолькоЦветОсновнойСерииПриИзменении(Элемент)
	Если Не ТолькоЦветОсновнойСерии Тогда
		ГрадиентДляПокомпонетногоСравнения = Ложь;
		ВыделятьМаксимальноеЗначениеДляПокомпонетногоСравнения = Ложь;
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	РезультатЗакрытия  = Новый Структура("ХранилищеНастроекОформления, 
		|ТолькоЦветОсновнойСерии,
		|ГрадиентДляПокомпонетногоСравнения,
		|ВыделятьМаксимальноеЗначениеДляПокомпонетногоСравнения,
		|ВыводитьМаркерыТочек,
		|ВыводитьМаркерТочекПрогноза,
		|ОтображатьЛегенду,
		|ВыводитьПодписиКДиаграммам,
		|ОкантовкаДиаграмм,
		|РежимСглаживанияДиаграмм,
		|РежимШкалыЗначений,
		|ВключатьНоль", 
		ХранилищеНастроекОформленияСервер(), 
		ТолькоЦветОсновнойСерии,
		ГрадиентДляПокомпонетногоСравнения,
		ВыделятьМаксимальноеЗначениеДляПокомпонетногоСравнения,
		ВыводитьМаркерыТочек,
		ВыводитьМаркерТочекПрогноза,
		ОтображатьЛегенду,
		ВыводитьПодписиКДиаграммам,
		ОкантовкаДиаграмм,
		РежимСглаживанияДиаграмм,
		РежимШкалыЗначений,
		ВключатьНоль);
	
	Закрыть(РезультатЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройкиОформления(Команда)
	ВосстановитьНастройкиОформленияСервер();
	
	УстановитьВидимостьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиентеНаСервереБезКонтекста 
Функция УстановитьВидимостьДоступностьЭлементовФормы(Форма)
	Форма.Элементы.ГруппаЦветаПокомпонентногоСравнения.Видимость = Форма.ОформлениеПокомпонентногоСравненияДоступно;
	
	ДоступностьГрадиента = Форма.ОформлениеПокомпонентногоСравненияДоступно И Форма.ТолькоЦветОсновнойСерии;
	Форма.Элементы.ГрадиентДляПокомпонетногоСравнения.Доступность = ДоступностьГрадиента;
	
	ДоступностьВыделенияМаксимальногоЗначения = Форма.ОформлениеПокомпонентногоСравненияДоступно И Форма.ГрадиентДляПокомпонетногоСравнения;
	Форма.Элементы.ВыделятьМаксимальноеЗначениеДляПокомпонетногоСравнения.Доступность = ДоступностьВыделенияМаксимальногоЗначения;
	
	Форма.Элементы.ВыводитьМаркерыТочек.Видимость = Форма.ВыводитьМаркерыТочекДоступно;
	Форма.Элементы.ВыводитьМаркерТочекПрогноза.Видимость = Форма.ВыводитьМаркерТочекПрогнозаДоступно;
	
	Форма.Элементы.ВыводитьПодписиКДиаграммам.Видимость = Форма.ВыводитьПодписиКДиаграммамДоступно;
	Форма.Элементы.ОкантовкаДиаграмм.Видимость = Форма.ОкантовкаДиаграммДоступно;
	Форма.Элементы.РежимСглаживанияДиаграмм.Видимость = Форма.РежимСглаживанияДиаграммДоступно;
	
	Форма.Элементы.ВключатьНоль.Доступность = (Форма.РежимШкалыЗначений = ПредопределенноеЗначение("Перечисление.РежимШкалыЗначенийДиаграмм.Авто"));
КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере 
Процедура ВосстановитьНастройкиОформленияСервер(СтруктураНастроекОформления = Неопределено)
	Если НЕ СтруктураНастроекОформления = Неопределено Тогда
		ХранилищеНастроекОформления = СтруктураНастроекОформления.ХранилищеНастроекОформления;
		
		Если НЕ ХранилищеНастроекОформления = Неопределено 
			И НЕ ХранилищеНастроекОформления.Получить() = Неопределено Тогда
			
			СтруктураЦветовыхНастроек = ХранилищеНастроекОформления.Получить();
		Иначе
			СтруктураНастроекОформления = Справочники.ВариантыАнализаЦелевыхПоказателей.НастройкиОформленияПоУмолчанию();
			
			СтруктураЦветовыхНастроек = СтруктураНастроекОформления.ХранилищеНастроекОформления.Получить();
		КонецЕсли;	
	Иначе
		СтруктураНастроекОформления = Справочники.ВариантыАнализаЦелевыхПоказателей.НастройкиОформленияПоУмолчанию();
		
		СтруктураЦветовыхНастроек = СтруктураНастроекОформления.ХранилищеНастроекОформления.Получить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураНастроекОформления);
	
	Цвета = СтруктураЦветовыхНастроек.Цвета;
	
	ЦветОсновнойСерии = Цвета["Значение"];
	ЦветПрогноза = Цвета["Прогноз"];
	ЦветЦелевогоЗначения = Цвета["ЦелевоеЗначение"];
	ЦветПозитивноеОтклонение = Цвета["ПозитивноеОтклонение"];
	ЦветНегативноеОтклонение = Цвета["НегативноеОтклонение"];
	ЦветЗоныДопустимыхОтклонений = Цвета["ЗонаДопустимыхОтклонений"];
КонецПроцедуры

&НаСервере 
Функция ХранилищеНастроекОформленияСервер()
	СтруктураНастроекОформления = Новый Структура;
	
	НаборЦветов = Новый Соответствие;
	НаборЦветов.Вставить("Значение", ЦветОсновнойСерии);
	НаборЦветов.Вставить("Прогноз", ЦветПрогноза);
	НаборЦветов.Вставить("ЦелевоеЗначение", ЦветЦелевогоЗначения);
	НаборЦветов.Вставить("ПозитивноеОтклонение", ЦветПозитивноеОтклонение);
	НаборЦветов.Вставить("НегативноеОтклонение", ЦветНегативноеОтклонение);
	НаборЦветов.Вставить("ЗонаДопустимыхОтклонений", ЦветЗоныДопустимыхОтклонений);
	
	СтруктураНастроекОформления.Вставить("Цвета", НаборЦветов);
	
	Возврат Новый ХранилищеЗначения(СтруктураНастроекОформления);
КонецФункции

&НаКлиенте
Процедура РежимШкалыЗначенийПоМинимумуПриИзменении(Элемент)
	РежимШкалыЗначенийПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РежимШкалыЗначенийАвтоПриИзменении(Элемент)
	РежимШкалыЗначенийПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте 
Процедура РежимШкалыЗначенийПриИзменении(Элемент)
	Если РежимШкалыЗначений <> ПредопределенноеЗначение("Перечисление.РежимШкалыЗначенийДиаграмм.Авто") Тогда
		ВключатьНоль = Ложь;
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
