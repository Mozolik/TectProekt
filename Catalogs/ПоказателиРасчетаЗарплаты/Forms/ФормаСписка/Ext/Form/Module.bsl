﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
		Если Параметры.Свойство("ПоказыватьНеиспользуемыеПоказатели") Тогда
			ПоказыватьНеиспользуемыеПоказатели = Параметры.ПоказыватьНеиспользуемыеПоказатели;
		КонецЕсли;
		Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
			ПоказыватьНеиспользуемыеПоказатели = Параметры.ТекущаяСтрока.НеИспользуется;
		КонецЕсли;
	Иначе
		Если Параметры.Свойство("ПоказыватьНеиспользуемыеПоказатели") Тогда
			ПоказыватьНеиспользуемыеПоказатели = Параметры.ПоказыватьНеиспользуемыеПоказатели;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборСписка(Список.Отбор, ПоказыватьНеиспользуемыеПоказатели);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельФормы);
	// Конец СтандартныеПодсистемы.Печать
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "НеИспользуется, ИмяПредопределенныхДанных");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНеиспользуемыеПоказателиПриИзменении(Элемент)
	
	УстановитьОтборСписка(Список.Отбор, ПоказыватьНеиспользуемыеПоказатели);
	
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

#Область ПроцедурыПодсистемыНастройкиПорядкаЭлементов

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(ГруппаОтбора, ПоказыватьНеиспользуемыеПоказатели)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ГруппаОтбора, "НеИспользуется");
	
	Если Не ПоказыватьНеиспользуемыеПоказатели Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "НеИспользуется", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
