﻿
&НаКлиенте
Перем ОбновитьИнтерфейс;

&НаКлиенте
Перем ОбъектЗаписан;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
		ПриЧтенииСоздании();
	КонецЕсли;
	
	Элементы.ГруппаОбъектыУчета.Видимость = НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	Элементы.ГруппаДенежныеСредстваВнеоборотныеАктивы.Доступность = Объект.УчетЗатрат;
	Элементы.ГруппаВариантОбособленияОтступ.Доступность = Объект.УчетЗатрат;
	Элементы.ГруппаВариантОбособленияОтступ.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСоздании();
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ТекущийОбъект.УчетЗатрат Тогда
		ТекущийОбъект.УчетДенежныхСредствРаздельно = Ложь;
		ТекущийОбъект.УчетДенежныхСредствПоКорреспонденции = Ложь;
		ТекущийОбъект.УчетВнеоборотныхАктивов = Ложь;
	КонецЕсли;
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ОбновитьИнтерфейс = Истина И ОбъектЗаписан = Истина Тогда
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбъектЗаписан = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчетДоходовПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УчетЗатратПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
	Элементы.ГруппаДенежныеСредстваВнеоборотныеАктивы.Доступность = Объект.УчетЗатрат;
	Элементы.ГруппаВариантОбособленияОтступ.Доступность = Объект.УчетЗатрат;
	
	Если Не Объект.УчетЗатрат Тогда
		УчетДенежныхСредств = Ложь;
		Объект.УчетДенежныхСредствРаздельно = Ложь;
		Объект.УчетДенежныхСредствПоКорреспонденции = Ложь;
		Объект.УчетВнеоборотныхАктивов = Ложь;
		Объект.ВариантОбособления = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПустаяСсылка");
		УстановитьПереключательВариантОбособленияНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеСредстваПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
	Элементы.ГруппаСпособУчетаДС.Доступность = УчетДенежныхСредств;
	Если УчетДенежныхСредств Тогда
		Объект.УчетДенежныхСредствРаздельно = Истина;
		СпособУчетаДС = "РаздельныйУчет";
	Иначе
		Объект.УчетДенежныхСредствРаздельно = Ложь;
		Объект.УчетДенежныхСредствПоКорреспонденции = Ложь;
		СпособУчетаДС = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнеоборотныеАктивыПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособУчетаДСПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
	Объект.УчетДенежныхСредствРаздельно = СпособУчетаДС = "РаздельныйУчет";
	Объект.УчетДенежныхСредствПоКорреспонденции = НЕ Объект.УчетДенежныхСредствРаздельно;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияПоНаправлениюВЦеломПриИзменении(Элемент)
	
	Объект.ВариантОбособления = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом");
	УстановитьПереключательВариантОбособленияНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияПоЗаказамНаправленияПриИзменении(Элемент)
	
	Объект.ВариантОбособления = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления");
	УстановитьПереключательВариантОбособленияНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСоздании()
	
	УчетДенежныхСредств = Объект.УчетДенежныхСредствРаздельно ИЛИ Объект.УчетДенежныхСредствПоКорреспонденции;
	Элементы.ГруппаСпособУчетаДС.Доступность = УчетДенежныхСредств;
	УстановитьПереключательВариантОбособленияНаСервере();
	
	Если Объект.УчетДенежныхСредствРаздельно Тогда
		СпособУчетаДС = "РаздельныйУчет";
	ИначеЕсли Объект.УчетДенежныхСредствПоКорреспонденции Тогда
		СпособУчетаДС = "ПоКорреспонденции";
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПереключательВариантОбособленияНаСервере()
	
	ПоЗаказам = Объект.ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления;
	ПоНаправлению = Объект.ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом;
	ВариантОбособленияПоЗаказамНаправления = ?(ПоЗаказам, 1, 0);
	ВариантОбособленияПоНаправлениюВЦелом = ?(ПоНаправлению, 1, 0);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПереключательВариантОбособленияНаКлиенте()
	
	ПоЗаказам = Объект.ВариантОбособления = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления");
	ПоНаправлению = Объект.ВариантОбособления = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом");
	ВариантОбособленияПоЗаказамНаправления = ?(ПоЗаказам, 1, 0);
	ВариантОбособленияПоНаправлениюВЦелом = ?(ПоНаправлению, 1, 0);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

