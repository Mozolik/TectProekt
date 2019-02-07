﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПоказыватьНедействительныхПользователей = Ложь;
	
	Если Не Параметры.РежимВыбора Тогда
		
		// только если не режим выбора, делаем фильтрацию
		
		Если ПоказыватьНедействительныхПользователей Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ПользователиСписок, "Недействителен");
		Иначе	
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ПользователиСписок,
				"Недействителен",
				Ложь);
		КонецЕсли;
			
	КонецЕсли;
	
	ИспользоватьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	
	Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		Если ИспользоватьГруппы Тогда
			Элементы.ГруппыПользователей.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		Иначе
			Параметры.ТекущаяСтрока = Неопределено;
		КонецЕсли;
	Иначе
		ТекущийЭлемент = Элементы.ПользователиСписок;
		Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", Справочники.ГруппыПользователей.ВсеПользователи);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", Истина);
	КонецЕсли;
	
	// Настройка постоянных данных для списка пользователей
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ПустойУникальныйИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ГруппаПользователейВсеПользователи = Справочники.ГруппыПользователей.ВсеПользователи;
	
	ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям = ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям");
	ИспользоватьРозничныеПродажи = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	
	Элементы.ПользователиСписокМаксимальныйПроцент.Видимость  = ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям;
	Элементы.ГруппыПользователейМаксимальныйПроцент.Видимость = ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям;
	
	Элементы.ГруппыПользователейРМК_Использовать.Видимость = ИспользоватьРозничныеПродажи;
	Элементы.РМК_Использовать.Видимость                    = ИспользоватьРозничныеПродажи;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ГруппыПользователей" Тогда
		Если Источник = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
			Элементы.ПользователиСписок.Обновить();
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НастройкиПродажДляПользователей" Тогда
		Элементы.ПользователиСписок.Обновить();
		Элементы.ГруппыПользователей.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки[ВыбиратьИерархически] = Неопределено Тогда
		ВыбиратьИерархически = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыПользователей

&НаКлиенте
Процедура ГруппыПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ГруппыПользователей.ТекущиеДанные;
	
	Ссылка = НастройкиПродажДляПользователейВызовСервера.НастройкаОграниченийПоОбъекту(ТекущиеДанные.Ссылка);
	Если Ссылка = Неопределено Тогда
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("Владелец", ТекущиеДанные.Ссылка));
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", Ссылка);
	КонецЕсли;
	ПараметрыФормы.Вставить("ИмяПоля", Поле.Имя);
	ОткрытьФорму("Справочник.НастройкиПродажДляПользователей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиСписок

&НаКлиенте
Процедура ПользователиСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ПользователиСписок.ТекущиеДанные;
	
	Ссылка = НастройкиПродажДляПользователейВызовСервера.НастройкаОграниченийПоОбъекту(ТекущиеДанные.Ссылка);
	Если Ссылка = Неопределено Тогда
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("Владелец", ТекущиеДанные.Ссылка));
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", Ссылка);
	КонецЕсли;
	ПараметрыФормы.Вставить("ИмяПоля", Поле.Имя);
	ОткрытьФорму("Справочник.НастройкиПродажДляПользователей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ПоказыватьНедействительныхПользователей = Не ПоказыватьНедействительныхПользователей;
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	
	Если ПоказыватьНедействительныхПользователей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ПользователиСписок, "Недействителен");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок,
			"Недействителен",
			Ложь);
	КонецЕсли;
		
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

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентРучнойСкидки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентРучнойНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСписок.ЕстьУточненияПоЦеновымГруппам");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ИндивидуальнаяЦена);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойСкидки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПользователей.ЕстьУточненияПоЦеновымГруппам");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ИндивидуальнаяЦена);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойСкидки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПользователей.ОграничиватьРучныеСкидки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Нет ограничений';uk='Немає обмежень'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентРучнойСкидки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентРучнойНаценки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойСкидки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейПроцентРучнойНаценки.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "ЧДЦ=2; ЧН=0,00");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РМК_Использовать.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСписок.РМК_Использовать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Есть ограничения';uk='Є обмеження'"));
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РМК_Использовать.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСписок.РМК_Использовать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Нет ограничений';uk='Немає обмежень'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейРМК_Использовать.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПользователей.РМК_Использовать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Есть ограничения';uk='Є обмеження'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейРМК_Использовать.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПользователей.РМК_Использовать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));
	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Нет ограничений';uk='Немає обмежень'"));

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы()
	
	Если НЕ ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыПользователей.ТекущаяСтрока = ГруппаПользователейВсеПользователи Тогда
		//
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаНельзяУстановитьСвойство;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", Истина);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", ГруппаПользователейВсеПользователи);
	Иначе
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаУстановитьСвойство;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", ВыбиратьИерархически);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
