﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ПредставлениеТипаДоначислениеПерерасчет", Документы.НачислениеЗарплаты.ПредставлениеТипаДоначислениеПерерасчет());
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУтвердить", "Видимость", Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ДобавлениеИзменениеНачисленнойЗарплатыРасширенная"));
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтаФорма);
	
	// ТехнологияСервиса.ИнформационныйЦентр
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ИнформационныйЦентрСервер");
		Модуль.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);
	КонецЕсли;
	// Конец ТехнологияСервиса.ИнформационныйЦентр
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		Модуль.ДоработатьЗапросЖурналаНачислений(ЭтотОбъект);
	КонецЕсли;
	
	ОписаниеТипаФизическоеЛицо = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	СтруктураПараметраФизическоеЛицо = Новый Структура("ТипПараметра, ИмяПараметра", ОписаниеТипаФизическоеЛицо, "МассивДокументов");
	СтруктураПараметровОтбора = Новый Структура(НСтр("ru='Сотрудник';uk='Співробітник'"), СтруктураПараметраФизическоеЛицо);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", "СписокНастройкиОтбора",
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	ЗарплатаКадрыРасширенный.СформироватьПодменюСоздатьФормыСпискаДокументов(ЭтаФорма, "ЖурналДокументов.НачислениеЗарплаты");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрКритерияОтбораПриИзменении(Элемент)
	ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(ИмяЭлемента)
	ЗарплатаКадры.ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, ИмяЭлемента);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// ТехнологияСервиса.ИнформационныйЦентр
&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформационныйЦентрКлиент");
		Модуль.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформационныйЦентрКлиент");
		Модуль.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);
	КонецЕсли;
	
КонецПроцедуры
// Конец ТехнологияСервиса.ИнформационныйЦентр

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, КомандыСозданияДокументов.Получить(Команда.Имя).ПолноеИмя);
	
	ЗарплатаКадрыРасширенныйКлиент.СоздатьДокументПоОписанию(ЭтаФорма, Команда.Имя, ПараметрыОткрытия.ЗначенияЗаполнения);
	
КонецПроцедуры

#КонецОбласти
