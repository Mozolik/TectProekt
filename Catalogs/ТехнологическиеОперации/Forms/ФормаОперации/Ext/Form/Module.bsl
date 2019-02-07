﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
   		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ СинхроннаяЗагрузка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВремяРаботыПриСинхроннойЗагрузке");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ТехнологическиеОперации", ПараметрыЗаписи);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" ИЛИ ИмяСобытия = "Запись_ВидыРабочихЦентров" Тогда
		ПрочитатьРеквизитыРабочегоЦентра();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	РабочийЦентрПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиПриИзменении(Элемент)
	
	ВариантНаладкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НастройкиОтбора = Новый Структура("Владелец", ВидРабочегоЦентра(Объект.РабочийЦентр));
		ПараметрыФормы = Новый Структура("Отбор", НастройкиОтбора);
		
		ОткрытьФорму("Справочник.ВариантыНаладки.ФормаВыбора", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	// Инициализация служебных реквизитов.
	СтатусВладельца = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Статус");
	ДоступностьЭлементов = (СтатусВладельца = Перечисления.СтатусыМаршрутныхКарт.ВРазработке);
	
	ПрочитатьРеквизитыРабочегоЦентра();
	НастроитьДоступностьПриЧтенииСоздании();
	НастроитьПараметрыВыбораРабочихЦентров();
		
	Если Объект.СодержитВложенныйМаршрут Тогда
		ПриИзмененииВидаОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаОперации()
	
	// Выполняется смена вида операции
	Объект.СодержитВложенныйМаршрут = Ложь;
	Объект.РабочийЦентр = Неопределено;
	Объект.ВариантНаладки = Неопределено;
	Объект.ВремяШтучное = 0;
	Объект.ВремяПЗ = 0;
	Объект.Загрузка = 0;
	Объект.Непрерывная = Ложь;
	Объект.ВспомогательныеРабочиеЦентры.Очистить();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьПриЧтенииСоздании()
	
	Если НЕ ТолькоПросмотр Тогда
		
		Элементы.НомерОперации.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.НомерСледующейОперации.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.РабочийЦентр.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВариантНаладки.Доступность = ДоступностьЭлементов;
		Элементы.ВремяШтучное.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяШтучноеЕдИзм.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяПЗ.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяПЗЕдИзм.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.Загрузка.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.Непрерывная.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВспомогательныеРабочиеЦентры.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВариантНаладки.Доступность = ДоступностьЭлементов И ИспользуютсяВариантыНаладки;
		
	КонецЕсли;
	
	НастроитьДоступностьПоРеквизитамРЦ();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьПоРеквизитамРЦ()
	
	Если ДоступностьЭлементов Тогда
		Элементы.ВариантНаладки.Доступность = ИспользуютсяВариантыНаладки;
	КонецЕсли;
	
	Элементы.Загрузка.Видимость = ПараллельнаяЗагрузка;
	Элементы.ЕдиницаИзмеренияЗагрузки.Видимость = ПараллельнаяЗагрузка;
	
	
	Элементы.ВремяШтучное.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяШтучноеЕдИзм.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяПЗ.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяПЗЕдИзм.Видимость = НЕ СинхроннаяЗагрузка;
	
	Элементы.ВремяРаботыПриСинхроннойЗагрузке.Видимость = СинхроннаяЗагрузка;
	Элементы.ЕдиницаИзмеренияПриСинхроннойЗагрузке.Видимость = СинхроннаяЗагрузка;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьЗначенияНедоступныхРеквизитов()
	
	Если НЕ Элементы.Загрузка.Видимость Тогда
		Объект.Загрузка = 0;
	КонецЕсли;
	Если НЕ Элементы.ВремяШтучное.Видимость Тогда
		Объект.ВремяШтучное = 0;
	КонецЕсли;
	Если НЕ Элементы.ВремяПЗ.Видимость Тогда
		Объект.ВремяПЗ = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РабочийЦентрПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		ПрочитатьРеквизитыРабочегоЦентра();
	Иначе
		ОчиститьРеквизитыРабочегоЦентра();
	КонецЕсли;
	
	НастроитьДоступностьПоРеквизитамРЦ();
	ОчиститьЗначенияНедоступныхРеквизитов();
	
	ПроверитьКорректностьВариантаНаладки();
	
КонецПроцедуры

&НаСервере
Процедура ВариантНаладкиПриИзмененииНаСервере()
	
	Если РеквизитыЗависятОтВариантаНаладки() Тогда
		ПрочитатьРеквизитыВариантаНаладки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораРабочихЦентров()
	
	ИмяПараметра = "Отбор.Подразделение";
	ЗначениеПараметра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Подразделение");
	
	НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, Элементы.РабочийЦентр);
	НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, Элементы.ВспомогательныеРабочиеЦентрыРабочийЦентр);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, ЭлементФормы)
	
	ПараметрыВыбораЭлемента = Новый Массив(ЭлементФормы.ПараметрыВыбора);
	
	Индекс = 0;
	Пока Индекс <= ПараметрыВыбораЭлемента.ВГраница() Цикл
		Если ПараметрыВыбораЭлемента[Индекс].Имя = ИмяПараметра Тогда
			ПараметрыВыбораЭлемента.Удалить(Индекс);
		Иначе
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		НовыйПараметр = Новый ПараметрВыбора(ИмяПараметра, ЗначениеПараметра);
		ПараметрыВыбораЭлемента.Добавить(НовыйПараметр);
	КонецЕсли;
	
	ЭлементФормы.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыРабочегоЦентра()
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("ИспользуютсяВариантыНаладки", "ИспользуютсяВариантыНаладки");
		Реквизиты.Вставить("ПараллельнаяЗагрузка", "ПараллельнаяЗагрузка");
		Реквизиты.Вставить("ВремяРаботыПриСинхроннойЗагрузке", "ВремяРаботы");
		Реквизиты.Вставить("ЕдиницаИзмеренияПриСинхроннойЗагрузке", "ЕдиницаИзмерения");
		Реквизиты.Вставить("ЕдиницаИзмеренияЗагрузки", "ЕдиницаИзмеренияЗагрузки");
		Реквизиты.Вставить("ВариантЗагрузки", "ВариантЗагрузки");
		
		Если ТипЗнч(Объект.РабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры") Тогда
			Для каждого Элемент Из Реквизиты Цикл
				Реквизиты.Вставить(Элемент.Ключ, "ВидРабочегоЦентра." + Элемент.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РабочийЦентр, Реквизиты);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		
		Если ЗначенияРеквизитов.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный Тогда
			СинхроннаяЗагрузка = Истина;
		Иначе
			СинхроннаяЗагрузка = Ложь;
		КонецЕсли;
		
		Если РеквизитыЗависятОтВариантаНаладки() Тогда
			ПрочитатьРеквизитыВариантаНаладки();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьРеквизитыРабочегоЦентра()
	
	ИспользуютсяВариантыНаладки = Ложь;
	ПараллельнаяЗагрузка = Ложь;
	СинхроннаяЗагрузка = Ложь;
	
	ВремяРаботыПриСинхроннойЗагрузке = 0;
	ЕдиницаИзмеренияПриСинхроннойЗагрузке = Перечисления.ЕдиницыИзмеренияВремени.ПустаяСсылка();
	ЕдиницаИзмеренияЗагрузки = "";
		
КонецПроцедуры

&НаСервере
Функция РеквизитыЗависятОтВариантаНаладки()

	Возврат СинхроннаяЗагрузка И ИспользуютсяВариантыНаладки;

КонецФункции

&НаСервере
Процедура ПрочитатьРеквизитыВариантаНаладки()
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВремяРаботыПриСинхроннойЗагрузке", "ВремяРаботы");
	Реквизиты.Вставить("ЕдиницаИзмеренияПриСинхроннойЗагрузке", "ЕдиницаИзмерения");
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВариантНаладки, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидРабочегоЦентра(РабочийЦентр)
	
	Если ТипЗнч(РабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров") Тогда
		
		Возврат РабочийЦентр;
		
	Иначе
		
		Возврат ЗначениеРеквизитаОбъекта(РабочийЦентр, "ВидРабочегоЦентра");
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

&НаСервере
Процедура ПроверитьКорректностьВариантаНаладки()
	
	Если ЗначениеЗаполнено(Объект.ВариантНаладки) Тогда
		
		Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
			
			ВладелецВН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВариантНаладки, "Владелец");
			ВидРабочегоЦентра = ВидРабочегоЦентра(Объект.РабочийЦентр);
			
			Если НЕ ВладелецВН = ВидРабочегоЦентра Тогда
				
				Объект.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка();
				
			КонецЕсли;
			
		Иначе
			
			Объект.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
