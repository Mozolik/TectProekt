﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();	
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыплатыПриИзменении(Элемент)
	ПриЧтенииСозданииНаСервере();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФизическиеЛица

&НаКлиенте
Процедура ФизическиеЛицаФизическоеЛицоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	
	Если ИспользоватьНачислениеЗарплаты И ЗначениеЗаполнено(ТекущиеДанные.ФизическоеЛицо) Тогда
		ФизическоеЛицоПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		
		ТекущиеДанные.ПрочийАкционер = Ложь;
	КонецЕсли;
	
	ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаНачисленоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НДФЛ, ВС, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры


&НаКлиенте
Процедура ФизическиеЛицаНДФЛПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры


&НаКлиенте
Процедура ФизическиеЛицаПриИзменении(Элемент)
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
		УстановитьКодДоходаНДФЛ(ТекущиеДанные.ПолучитьИдентификатор());
		УстановитьКодДоходаВС(ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаКодДоходаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	ФизическиеЛицаКодДоходаПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	СтруктураДействий = Новый Структура("НДФЛ, ВС, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаСервере
Процедура ФизическиеЛицаКодДоходаПриИзмененииНаСервере(Идентификатор)
	
	ТекущиеДанные = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ТекущиеДанные.ВидСтавки = ТекущиеДанные.КодДохода.ВидСтавкиРезидента;
	УстановитьКодДоходаВС(Идентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаКодДоходаВСПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	ФизическиеЛицаКодДоходаВСПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	СтруктураДействий = Новый Структура("ВС, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаСервере
Процедура ФизическиеЛицаКодДоходаВСПриИзмененииНаСервере(Идентификатор)
	ТекущиеДанные = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ТекущиеДанные.ВидСтавкиВС = ТекущиеДанные.КодДоходаВС.ВидСтавкиРезидента;
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВСПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные)
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЮридическиеЛица

&НаКлиенте
Процедура ЮридическиеЛицаПриИзменении(Элемент)
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаНачисленоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаКВыплатеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НачисленоЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ФизическиеЛицаВвестиЗаявкуНаПеречисление(Команда)
	СоздатьЗаявкуНаПеречислениеДенежныхСредств("ФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиЗаявкуНаПеречисление(Команда)
	СоздатьЗаявкуНаПеречислениеДенежныхСредств("ЮридическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВвестиРасходныйОрдер(Команда)
	ВвестиРасходныйОрдер("ФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиРасходныйОрдер(Команда)
	ВвестиРасходныйОрдер("ЮридическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВвестиСписание(Команда)
	ВвестиСписаниеБезналичныхДенежныхСредств("ФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиСписание(Команда)
	ВвестиСписаниеБезналичныхДенежныхСредств("ЮридическиеЛица");
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
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
	УсловноеОформление, Новый Структура("ФизическиеЛица"));
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(
	УсловноеОформление, Новый Структура("ЮридическиеЛица"));
	
	// Не облагается НДФЛ
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаКодДохода.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ФизическиеЛица.КодДохода");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не облагается';uk='Не оподатковується'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Не облагается ВС
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаКодДоходаВС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ФизическиеЛица.КодДоходаВС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не облагается';uk='Не оподатковується'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	

    Ставки = УчетНДФЛ.ПолучитьСтавкиНДФЛНаДату(Объект.Дата);
	ЗначенияСтавок = Новый ФиксированноеСоответствие(Ставки);
	
	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	ВсегоПоДокументу = Объект.ФизическиеЛица.Итог("Начислено") + Объект.ЮридическиеЛица.Итог("Начислено");
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСтроку(Действия, ДанныеСтроки)
	
	Если Действия.Свойство("НачисленоФизическомуЛицу") Тогда
	КонецЕсли;
	
	Если Действия.Свойство("НачисленоЮридическомуЛицу") Тогда
		ДанныеСтроки.Начислено = ДанныеСтроки.КВыплате;
	КонецЕсли;
	
	Если Действия.Свойство("НДФЛ") Тогда
		ДанныеСтроки.НДФЛ = (ДанныеСтроки.Начислено) * ЗначенияСтавок[ДанныеСтроки.ВидСтавки];
	КонецЕсли;
	
	Если Действия.Свойство("ВС") Тогда
		ДанныеСтроки.ВС = (ДанныеСтроки.Начислено) * ЗначенияСтавок[ДанныеСтроки.ВидСтавкиВС];
	КонецЕсли;
	
	
	Если Действия.Свойство("КВыплатеФизическомуЛицу") Тогда
		ДанныеСтроки.КВыплате = ДанныеСтроки.Начислено - ДанныеСтроки.НДФЛ - ДанныеСтроки.ВС;
	КонецЕсли;
	
	Если Действия.Свойство("КВыплатеЮридическомуЛицу") Тогда
		ДанныеСтроки.КВыплате = ДанныеСтроки.Начислено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере(Идентификатор)
	
	ДанныеСтроки = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ДатаПолученияДанных = ?(ЗначениеЗаполнено(Объект.ДатаВыплаты), Объект.ДатаВыплаты, ТекущаяДатаСеанса());
	
	Сотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки.ФизическоеЛицо),
		Истина,
		Объект.Организация,
		ДатаПолученияДанных);
	
	Если Сотрудники.Количество() > 0 И ЗначениеЗаполнено(Сотрудники[0].Сотрудник) Тогда
		ДанныеСтроки.ПрочийАкционер = Ложь;
	Иначе
		ДанныеСтроки.ПрочийАкционер = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодДоходаНДФЛ(Идентификатор)
	
	ТекущиеДанные = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ТекущиеДанные.КодДохода = Справочники.ВидыДоходовНДФЛ.ВидДоходовДивиденды();
	ТекущиеДанные.ВидСтавки = ТекущиеДанные.КодДохода.ВидСтавкиРезидента;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодДоходаВС(Идентификатор)
	
	ТекущиеДанные = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ТекущиеДанные.КодДоходаВС = ТекущиеДанные.КодДохода.ОблагаетсяВоеннымСбором;
	ТекущиеДанные.ВидСтавкиВС = ТекущиеДанные.КодДоходаВС.ВидСтавкиРезидента;
	
КонецПроцедуры


&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаПеречислениеДенежныхСредств(ИмяТаблицы)
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если Не ПроверитьВозможностьОформленияВыплат(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Новый Структура();
	Основание.Вставить("ДокументОснование",         Объект.Ссылка);
	Основание.Вставить("Контрагент",                ТекущиеДанные.Контрагент);
	Основание.Вставить("СуммаДокумента",            ТекущиеДанные.КВыплате);
	Основание.Вставить("Организация",               Объект.Организация);
	Основание.Вставить("ХозяйственнаяОперация",     ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	Основание.Вставить("ФормаОплатыНаличная",       Истина);
	Основание.Вставить("ФормаОплатыБезналичная",    Истина);
	Основание.Вставить("СтатьяАктивовПассивов",     ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки"));
	Основание.Вставить("ЖелательнаяДатаПлатежа",    Объект.ДатаВыплаты);
	
	ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиРасходныйОрдер(ИмяТаблицы)
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если Не ПроверитьВозможностьОформленияВыплат(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Новый Структура();
	Основание.Вставить("ДокументОснование",         Объект.Ссылка);
	Основание.Вставить("Контрагент",                ТекущиеДанные.Контрагент);
	Основание.Вставить("СуммаДокумента",            ТекущиеДанные.КВыплате);
	Основание.Вставить("Организация",               Объект.Организация);
	Основание.Вставить("ХозяйственнаяОперация",     ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	Основание.Вставить("СтатьяАктивовПассивов",     ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки"));
	
	ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСписаниеБезналичныхДенежныхСредств(ИмяТаблицы)
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если Не ПроверитьВозможностьОформленияВыплат(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Новый Структура();
	Основание.Вставить("ДокументОснование",         Объект.Ссылка);
	Основание.Вставить("Контрагент",                ТекущиеДанные.Контрагент);
	Основание.Вставить("СуммаДокумента",            ТекущиеДанные.КВыплате);
	Основание.Вставить("Организация",               Объект.Организация);
	Основание.Вставить("ХозяйственнаяОперация",     ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	Основание.Вставить("СтатьяАктивовПассивов",     ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки"));
	
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВозможностьОформленияВыплат(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Команда не может быть выполнена для указанного объекта';uk='Команда не може бути виконана для зазначеного об''єкта'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	
	Если НепроведенныеДокументы.Количество() > 0 Тогда
		ТекстПредупреждения = НСтр("ru='Оформление выплат возможно только на основании проведенного документа';uk='Оформлення виплат можливе лише на підставі проведеного документа'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры





#КонецОбласти