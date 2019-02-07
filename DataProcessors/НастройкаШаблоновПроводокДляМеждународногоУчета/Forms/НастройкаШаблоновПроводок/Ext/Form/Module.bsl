﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПланаСчетов = "Все";
	
	Если Параметры.Свойство("УчетнаяПолитика") Тогда
		УчетнаяПолитика = Параметры.УчетнаяПолитика;
		ОбновитьДанныеФормыСервер();
	Иначе
		УстановитьПараметрыДинамическихСписков();
	КонецЕсли;
	
	Если Параметры.Свойство("ХозяйственнаяОперация") Тогда
		ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
		Если ТипЗнч(ХозяйственнаяОперация) = Тип("ПеречислениеСсылка.ХозяйственныеОперации") Тогда
			ХозяйственнаяОперация = МеждународныйУчетОбщегоНазначения.ХозяйственнаяОперацияПоПеречислению(ХозяйственнаяОперация);
		КонецЕсли;
		Элементы.ХозяйственныеОперации.ТекущаяСтрока = ХозяйственнаяОперация;
	КонецЕсли;
	
	УстановитьДоступностьВидимостьЭлементовНаСервере();
	
	УстановитьОтборШаблоновПроводок(ЭтотОбъект, Справочники.НастройкиХозяйственныхОпераций.ПустаяСсылка());
	
	ДополнительныеПараметры = Новый Структура;
	ИнтеграцияССППР.ДобавитьРазмещениеКомандСППРВДополнительныеПараметры(Элементы.ГруппаСППР, ДополнительныеПараметры);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаНастроек");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанШаблонПроводки" 
		И Элементы.ХозяйственныеОперации.ТекущаяСтрока <> Неопределено Тогда
		ОповеститьОбИзменении(Элементы.ХозяйственныеОперации.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(УчетнаяПолитика) Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки.Количество() > 0 Тогда
		ОбновитьДанныеФормыСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчетнаяПолитикаПриИзменении(Элемент)
	
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПланаСчетовПриИзменении(Элемент)
	
	ИзменитьОтображениеТаблицыПланаСчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыХозяйственныеоперации

&НаКлиенте
Процедура ХозяйственныеОперацииПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикХозяйственныеОперацииПриАктивизацииСтроки",0.2,Истина);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоныПроводок

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПланСчетовМеждународный

&НаКлиенте
Процедура ПланСчетовМеждународныйПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоныПроводокПоСчету

&НаКлиенте
Процедура ШаблоныПроводокПоСчетуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если Поле = Элементы.ШаблоныПроводокПоСчетуГруппаФинансовогоУчетаПредставление
		И ЗначениеЗаполнено(ТекущиеДанные.ГруппаФинансовогоУчета) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ГруппаФинансовогоУчета);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.ШаблонПроводки);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьХозоперациюВУчетнуюПолитику(Команда)
	
	ИзменитьОтражениеХозяйственныхОперацийВУчетнойПолитике(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьХозоперациюИзУчетнойПолитики(Команда)
	
	ИзменитьОтражениеХозяйственныхОперацийВУчетнойПолитике(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВУчетнуюПолитику(Команда)
	
	МассивШаблонов = Элементы.ШаблоныПроводок.ВыделенныеСтроки;
	Если МассивШаблонов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОтразитьВУчетнойПолитике(МассивШаблонов, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзУчетнойПолитики(Команда)
	
	МассивШаблонов = Элементы.ШаблоныПроводок.ВыделенныеСтроки;
	Если МассивШаблонов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОтразитьВУчетнойПолитике(МассивШаблонов, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВУчетнуюПолитикуШаблоныПроводокПоСчету(Команда)
	
	МассивВыбранныхСтрок = Элементы.ШаблоныПроводокПоСчету.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивШаблонов = МассивВыбранныхШаблоновПроводокПоСчету(МассивВыбранныхСтрок);
	ОтразитьВУчетнойПолитике(МассивШаблонов, Истина);
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьИзУчетнойПолитикиШаблоныПроводокПоСчету(Команда)
	
	МассивВыбранныхСтрок = Элементы.ШаблоныПроводокПоСчету.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивШаблонов = МассивВыбранныхШаблоновПроводокПоСчету(МассивВыбранныхСтрок);
	ОтразитьВУчетнойПолитике(МассивШаблонов, Ложь);
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеФормы(Команда)
	
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппу(Команда)
	
	Если НЕ ПроверитьВозможностьСозданияШаблоновПроводок() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыСоздания = Новый Структура;
	ДополнительныеПараметрыСоздания.Вставить("ЭтоГруппаШаблонов", Истина);
	Элементы.ШаблоныПроводок.ДополнительныеПараметрыСоздания = 
		Новый ФиксированнаяСтруктура(ДополнительныеПараметрыСоздания);
		
	Элементы.ШаблоныПроводок.ДобавитьСтроку();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонПроводки(Команда)
	
	Если НЕ ПроверитьВозможностьСозданияШаблоновПроводок() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметрыСоздания = Новый Структура;
	ДополнительныеПараметрыСоздания.Вставить("УчетнаяПолитика", УчетнаяПолитика);
	ДополнительныеПараметрыСоздания.Вставить("ЭтоГруппаШаблонов", Ложь);
	Элементы.ШаблоныПроводок.ДополнительныеПараметрыСоздания = 
		Новый ФиксированнаяСтруктура(ДополнительныеПараметрыСоздания);
		
	Элементы.ШаблоныПроводок.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПроводокПереместитьВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(ШаблоныПроводок, Элементы.ШаблоныПроводок);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПроводокПереместитьВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(ШаблоныПроводок, Элементы.ШаблоныПроводок);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
 
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Общие

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

#Область ХозяйственныеОперации

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ХозяйственныеОперации.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственныеОперации.НеОтражаетсяВУчетнойПолитике");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

#КонецОбласти

#Область ШаблоныПроводок

#Область ОформлениеЭлементов

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ДействующийШаблон");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ЭтоГруппаШаблонов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	// Отключение видимости колонок
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокВариантСовместногоПрименения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ЭтоГруппаШаблонов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
#КонецОбласти

#Область ОформлениеГрупп

	// Отключение видимости колонок
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокСчетДебетаПоУмолчанию.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокСчетДебетаПоУмолчаниюНаименование.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокСчетКредитаПоУмолчанию.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокСчетКредитаПоУмолчаниюНаименование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ЭтоГруппаШаблонов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	// Справочная надпись для группы с вариантом "Вытеснение"
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокВариантСовместногоПрименения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ЭтоГруппаШаблонов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ВариантСовместногоПрименения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Вытеснение;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Первый в порядке следования шаблон проводки, удовлетворяющий условиям дополнительного отбора';uk='Перший у порядку слідування шаблон проводки, що задовольняє умовам додаткового відбору'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);

	// Справочная надпись для группы с вариантом "Все"
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокВариантСовместногоПрименения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ЭтоГруппаШаблонов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводок.ВариантСовместногоПрименения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Все;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Все шаблоны проводок, входящие в группу';uk='Всі шаблони проводок, що входять в групу'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	
#КонецОбласти

#КонецОбласти

#Область ШаблоныПроводокПоСчету

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокПоСчетуВидДвижения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводокПоСчету.ВидДвижения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДвиженийБухгалтерии.Дебет;

	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Лево);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Дт';uk='Дт'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаДебета);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокПоСчетуВидДвижения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводокПоСчету.ВидДвижения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДвиженийБухгалтерии.Кредит;

	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Кт';uk='Кт'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаКредита);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокПоСчету.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводокПоСчету.ШаблонПроводки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводокПоСчету.Действует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	// Текст для счетов по умолчанию
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШаблоныПроводокПоСчетуГруппаФинансовогоУчетаПредставление.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШаблоныПроводокПоСчету.ГруппаФинансовогоУчета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Счет по умолчанию>';uk='<Рахунок по умовчанню>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

#КонецОбласти

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьВидимостьЭлементовНаСервере()

	ДоступноИзменениеНастроекМФУ = МеждународныйУчетОбщегоНазначения.ДоступноИзменениеНастроекМеждународногоУчета();
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ХозяйственныеОперацииГруппаИзменитьОтражениеВУчетнойПолитике");
	МассивЭлементов.Добавить("ШаблоныПроводокГруппаИзменитьОтражениеВУчетнойПолитике");
	МассивЭлементов.Добавить("ШаблоныПроводокПоСчетуГруппаСоздать");
	МассивЭлементов.Добавить("ШаблоныПроводокПоСчетуГруппаИзменитьОтражениеВУчетнойПолитике");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", ДоступноИзменениеНастроекМФУ);

КонецПроцедуры

&НаКлиенте
Функция УчетнаяПолитикаЗаполнена()

	УчетнаяПолитикаЗаполнена = ЗначениеЗаполнено(УчетнаяПолитика);
	
	Если Не УчетнаяПолитикаЗаполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнена Учетная политика!';uk='Не заповнена Облікова політика!'"), ,"УчетнаяПолитика");
	КонецЕсли;

	Возврат УчетнаяПолитикаЗаполнена;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеФормыСервер()
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область НастройкаПоХозяйственнымОперациям

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ХозяйственныеОперации, "УчетнаяПолитика", УчетнаяПолитика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ШаблоныПроводок, "УчетнаяПолитика", УчетнаяПолитика, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикХозяйственныеОперацииПриАктивизацииСтроки()

	ТекущиеДанные = Элементы.ХозяйственныеОперации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборШаблоновПроводок(ЭтотОбъект, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборШаблоновПроводок(Форма, ХозяйственнаяОперация)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.ШаблоныПроводок, "Операция", ХозяйственнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтражениеХозяйственныхОперацийВУчетнойПолитике(ОтражатьВМеждународномУчете)

	МассивСтрок = Элементы.ХозяйственныеОперации.ВыделенныеСтроки;
	Если МассивСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не УчетнаяПолитикаЗаполнена() Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьОтражениеХозяйственныхОперацийВУчетнойПолитикеСервер(МассивСтрок, УчетнаяПолитика, ОтражатьВМеждународномУчете);
	
	ОповеститьОбИзменении(Элементы.ХозяйственныеОперации.ТекущаяСтрока);
	
	Элементы.ШаблоныПроводок.Обновить();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьОтражениеХозяйственныхОперацийВУчетнойПолитикеСервер(МассивСтрок, УчетнаяПолитика, ОтражатьВМеждународномУчете)
	
	НаборЗаписей = РегистрыСведений.ХозяйственныеОперацииНеОтражаемыеВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	ТаблицаДобавляемыхЗаписей = НаборЗаписей.Выгрузить();
	ТаблицаУдаляемыхЗаписей = НаборЗаписей.Выгрузить();
	
	НаборЗаписей.Прочитать();
	ТаблицаЗаписей = НаборЗаписей.Выгрузить();
	
	Для каждого Строка Из МассивСтрок Цикл
		Запись = ТаблицаЗаписей.Найти(Строка.Ссылка, "Операция");
		Если Запись = Неопределено Тогда
			Если Не ОтражатьВМеждународномУчете Тогда
				НоваяСтрока = ТаблицаДобавляемыхЗаписей.Добавить();
				НоваяСтрока.УчетнаяПолитика = УчетнаяПолитика;
				НоваяСтрока.Операция = Строка;
			КонецЕсли;
		Иначе
			Если ОтражатьВМеждународномУчете Тогда
				НоваяСтрока = ТаблицаУдаляемыхЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Запись);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТаблицаДобавляемыхЗаписей.Количество() > 0 Тогда
		НаборЗаписей.Загрузить(ТаблицаДобавляемыхЗаписей);
		НаборЗаписей.Записать(Ложь);		
	КонецЕсли;
	
	НаборЗаписей.Очистить();
	Для каждого Строка Из ТаблицаУдаляемыхЗаписей Цикл
		НаборЗаписей.Отбор.Операция.Установить(Строка.Операция);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВУчетнойПолитике(МассивШаблонов, ВключитьВУчетнуюПолитику)

	Если Не УчетнаяПолитикаЗаполнена() Тогда
		Возврат;
	КонецЕсли;

	ОтразитьВУчетнойПолитикеНаСервере(МассивШаблонов, ВключитьВУчетнуюПолитику);
	
	ОповеститьОбИзменении(Элементы.ХозяйственныеОперации.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьВУчетнойПолитикеНаСервере(МассивШаблонов, ВключитьВУчетнуюПолитику)
	
	ИзменитьОтражениеШаблоновПроводокВУчетнойПолитике(МассивШаблонов, УчетнаяПолитика, ВключитьВУчетнуюПолитику);
	Элементы.ШаблоныПроводок.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьОтражениеШаблоновПроводокВУчетнойПолитике(МассивШаблонов, УчетнаяПолитика, ВключитьВУчетнуюПолитику)
	
	НаборЗаписей = РегистрыСведений.ПравилаОтраженияВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	ТаблицаДобавляемыхЗаписей = НаборЗаписей.Выгрузить();
	ТаблицаУдаляемыхЗаписей = НаборЗаписей.Выгрузить();
	
	НаборЗаписей.Прочитать();
	ТаблицаЗаписей = НаборЗаписей.Выгрузить();
	
	Для каждого Шаблон Из МассивШаблонов Цикл
		Запись = ТаблицаЗаписей.Найти(Шаблон, "ШаблонПроводки");
		Если Запись = Неопределено Тогда
			Если ВключитьВУчетнуюПолитику Тогда
				НоваяСтрока = ТаблицаДобавляемыхЗаписей.Добавить();
				НоваяСтрока.УчетнаяПолитика = УчетнаяПолитика;
				НоваяСтрока.ШаблонПроводки = Шаблон;
			КонецЕсли;
		Иначе
			Если Не ВключитьВУчетнуюПолитику Тогда
				НоваяСтрока = ТаблицаУдаляемыхЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Запись);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТаблицаДобавляемыхЗаписей.Количество() > 0 Тогда
		НаборЗаписей.Загрузить(ТаблицаДобавляемыхЗаписей);
		НаборЗаписей.Записать(Ложь);
	КонецЕсли;
	
	НаборЗаписей.Очистить();
	Для каждого Строка Из ТаблицаУдаляемыхЗаписей Цикл
		НаборЗаписей.Отбор.ШаблонПроводки.Установить(Строка.ШаблонПроводки);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВозможностьСозданияШаблоновПроводок()

	ТекущиеДанные = Элементы.ХозяйственныеОперации.ТекущиеДанные;
	Возврат ?(ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа, Ложь, Истина);

КонецФункции

#КонецОбласти

#Область НастройкаПоПлануСчетов

&НаКлиенте
Процедура ОбработчикПланСчетовПриАктивизацииСтроки()
	
	ТекущиеДанные = Элементы.ПланСчетовМеждународный.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Счет = Неопределено;
	Иначе
		Счет = ТекущиеДанные.Ссылка;
	КонецЕсли;
	ЗаполнитьТаблицуШаблоновПроводокПоСчету(Счет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуШаблоновПроводокПоСчету(Счет)
	
	ШаблоныПроводокПоСчету.Очистить();
	
	Если Не ЗначениеЗаполнено(Счет) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ШаблоныПроводок.ШаблонПроводки КАК ШаблонПроводки,
	|	ПРЕДСТАВЛЕНИЕ(ШаблоныПроводок.ШаблонПроводки) КАК ШаблонПроводкиПредставление,
	|	ШаблоныПроводок.Операция КАК Операция,
	|	ШаблоныПроводок.ВидДвижения КАК ВидДвижения,
	|	ШаблоныПроводок.УстановленДополнительныйОтбор КАК УстановленДополнительныйОтбор,
	|	ШаблоныПроводок.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ПРЕДСТАВЛЕНИЕ(ШаблоныПроводок.ГруппаФинансовогоУчета) КАК ГруппаФинансовогоУчетаПредставление,
	|	ВЫБОР
	|		КОГДА НЕ ПравилаОтражения.ШаблонПроводки ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|	КОНЕЦ КАК Действует
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШаблоныПроводок.Ссылка КАК ШаблонПроводки,
	|		ШаблоныПроводок.Операция КАК Операция,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Дебет) КАК ВидДвижения,
	|		ШаблоныПроводок.УстановленДополнительныйОтбор КАК УстановленДополнительныйОтбор,
	|		НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчета
	|	ИЗ
	|		Справочник.ШаблоныПроводокДляМеждународногоУчета КАК ШаблоныПроводок
	|	ГДЕ
	|		ШаблоныПроводок.СчетДебетаПоУмолчанию = &Счет
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ШаблоныПроводок.Ссылка,
	|		ШаблоныПроводок.Операция,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Кредит),
	|		ШаблоныПроводок.УстановленДополнительныйОтбор,
	|		НЕОПРЕДЕЛЕНО
	|	ИЗ
	|		Справочник.ШаблоныПроводокДляМеждународногоУчета КАК ШаблоныПроводок
	|	ГДЕ
	|		ШаблоныПроводок.СчетКредитаПоУмолчанию = &Счет
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ШаблоныПроводок.Ссылка,
	|		ШаблоныПроводок.Операция,
	|		ПравилаУточненияСчетов.ВидДвижения,
	|		ШаблоныПроводок.УстановленДополнительныйОтбор,
	|		ПравилаУточненияСчетов.ГруппаФинансовогоУчета
	|	ИЗ
	|		Справочник.ШаблоныПроводокДляМеждународногоУчета КАК ШаблоныПроводок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ПравилаУточненияСчетовВМеждународномУчете КАК ПравилаУточненияСчетов
	|       ПО (ПравилаУточненияСчетов.СчетУчета = &Счет)
	|			И ШаблоныПроводок.Ссылка = ПравилаУточненияСчетов.ШаблонПроводки
	|	) КАК ШаблоныПроводок
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ПравилаОтраженияВМеждународномУчете КАК ПравилаОтражения
	|	ПО 
	|		(ПравилаОтражения.УчетнаяПолитика = &УчетнаяПолитика)
	|		И ШаблоныПроводок.ШаблонПроводки = ПравилаОтражения.ШаблонПроводки
	|";

	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	ТаблицаРезультата.Сортировать("ВидДвижения, ГруппаФинансовогоУчетаПредставление, ШаблонПроводкиПредставление");
	ШаблоныПроводокПоСчету.Загрузить(ТаблицаРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОтображениеТаблицыПланаСчетов()
	
	Если ОтборПланаСчетов = "Все" Тогда
		Элементы.ПланСчетовМеждународный.Отображение = ОтображениеТаблицы.Дерево;
	Иначе
		Элементы.ПланСчетовМеждународный.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		ПланСчетовМеждународный, 
		"ИспользуетсяВШаблонах", 
		Истина, 
		ОтборПланаСчетов = "ИспользуемыеВШаблонах");
	
КонецПроцедуры

&НаКлиенте
Функция МассивВыбранныхШаблоновПроводокПоСчету(МассивВыбранныхСтрок)

	МассивШаблонов = Новый Массив;
	Для каждого Строка Из МассивВыбранныхСтрок Цикл
		Шаблон = ШаблоныПроводокПоСчету.НайтиПоИдентификатору(Строка).ШаблонПроводки;
		Если ЗначениеЗаполнено(Шаблон) Тогда
			МассивШаблонов.Добавить(Шаблон);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивШаблонов;
	
КонецФункции

#КонецОбласти

#КонецОбласти
