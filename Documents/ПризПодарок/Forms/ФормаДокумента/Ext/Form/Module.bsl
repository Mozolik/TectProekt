﻿&НаКлиенте
Перем СтарыеЗначенияКонтролируемыхПолей;

&НаКлиенте
Перем АктивизированныйСотрудник;

&НаКлиенте
Перем СотрудникПередУдалением;

&НаКлиенте
Перем СотрудникиКРасчету Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма, ОписаниеДокумента(ЭтаФорма));
	РасчетЗарплатыРасширенныйФормы.ИнициализироватьМеханизмПересчетаДокументаПриРедактировании(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц",
		"Объект.Организация", "Объект.Ответственный", "Объект.ПериодРегистрации");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если Не ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			Объект.ПериодРегистрации = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Объект.ДатаПолученияДохода = ТекущаяДатаСеанса();
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
		УстановитьКодДохода();
		
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "ИзмененоСторнированиеНачислений" Или ИмяСобытия = "ИсправленДокумент") И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизиты();
	ИначеЕсли ИмяСобытия = "ИзмененыПоказателиДокумента" И Источник.ВладелецФормы = ЭтаФорма Тогда
		Если Параметр.Показатели.Количество() > 0 Тогда 
			ОбработатьИзменениеПоказателейНаСервере(Параметр.Показатели);
			СотрудникиКРасчету.Очистить();
			РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПризаПодаркаПриИзменении(Элемент)
	
	ВидПризаПодаркаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КодДоходаНДФЛПриИзменении(Элемент)
	
	 КодДоходаНДФЛПриИзмененииНаСервере();
	 
КонецПроцедуры

&НаКлиенте
Процедура ДатаПолученияДоходаПриИзменении(Элемент)
	
	ДатаПолученияДоходаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредусмотреноКолдоговоромПриИзменении(Элемент)
	
	ПредусмотреноКолдоговоромПриИзмененииНаСервере();
	
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцНачисленияПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцНачисленияПриИзменении()

	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияПриАктивизацииСтроки(Элемент)
	
	РасчетЗарплатыРасширенныйКлиент.ДокументыВыполненияНачисленийПриАктивацииСтроки(ЭтаФорма, "Начисления", Ложь);
	
	Если Элементы.Начисления.ТекущиеДанные <> Неопределено Тогда
		АктивизированныйСотрудник = Элементы.Начисления.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПередУдалением(Элемент, Отказ)
	
	Если Элементы.Начисления.ТекущиеДанные <> Неопределено Тогда
		СотрудникПередУдалением = Элементы.Начисления.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыКлиент.СтрокаРасчетаПриОкончанииРедактирования(ЭтаФорма, ОписаниеТаблицыНачислений(), Истина, , ОписаниеДокумента(ЭтаФорма));
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПослеУдаления(Элемент)
	
	НачисленияПослеУдаленияНаСервере(СотрудникПередУдалением);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникПриИзменении(Элемент)
	
	ОбработатьИзменениеСотрудника(Элементы.Начисления.ТекущаяСтрока, АктивизированныйСотрудник);
	
	ДанныеСтроки = Элементы.Начисления.ТекущиеДанные;
	РасчетЗарплатыРасширенныйКлиент.УстановитьЗначенияКонтролируемыхПолей("Начисления", ДанныеСтроки, ЭтаФорма["КонтролируемыеПоляНачисления"], СтарыеЗначенияКонтролируемыхПолей);
	ДанныеСтроки.ФиксЗаполнение = Ложь;
	ДанныеСтроки.ФиксРасчет = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачисленияОтменитьИсправление(Команда)
	РасчетЗарплатыКлиент.ОтменитьИсправление(ЭтаФорма, ОписаниеТаблицыНачислений());
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачисленияОтменитьВсеИсправления(Команда)
	РасчетЗарплатыКлиент.ОтменитьВсеИсправления(ЭтаФорма, ОписаниеТаблицыНачислений());
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачисленияПересчитатьСотрудника(Команда)
	
	РасчетЗарплатыРасширенныйКлиент.ПересчитатьСотрудника(ЭтаФорма, "Начисления", "Сотрудник", Тип("СправочникСсылка.Сотрудники"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ПризПодарок");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Сторнировать(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Сторнировать(Объект.Ссылка, "Начисление");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ПризПодарок");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ПризПодарок");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКСторно(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКСторно(ЭтаФорма.ДокументСторно);
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	НачалоПериодаПримененияОтбора = НачалоМесяца(Объект.ДатаПолученияДохода);
	ОкончаниеПериодаПримененияОтбора = КонецМесяца(Объект.ДатаПолученияДохода);
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде(
		Элементы.Начисления,
		Объект.Организация, ,
		НачалоПериодаПримененияОтбора, ОкончаниеПериодаПримененияОтбора,
		, АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДокумент(Команда)
	
	ПересчитатьДокументНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказатели(Команда)
	
	МассивПоказателей = Новый Массив;
	
	ПараметрыФормы = Новый Структура("МассивПоказателей", МассивПоказателей);
	ОткрытьФорму("ОбщаяФорма.ГрупповоеЗаполнениеПоказателейДокументов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнитьФорму()
	
	РасчетЗарплатыРасширенныйФормы.ДокументыНачисленийДополнитьФорму(ЭтотОбъект, ОписаниеДокумента(ЭтаФорма));
	
	РасчетЗарплатыРасширенныйФормы.ДокументыВыполненияНачисленийДобавитьКонтрольИсправлений(ЭтотОбъект, ОписаниеТаблицыНачислений(), "", "КомандыНачисления",,Ложь);
	ЭтаФорма["КонтролируемыеПоляНачисления"] = Новый ФиксированнаяСтруктура;
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма);
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ДополнитьФорму();
	УстановитьВидимостьПерерасчетов(ЭтаФорма);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыВыполненияНачисленийДобавитьКонтрольИсправлений(ЭтотОбъект, ОписаниеТаблицыНачислений(), "Начисления",,,Ложь);
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	ЗаполнитьСписокВыбораКодДоходаНДФЛ();
	УстановитьФункциональныеОпцииФормы();
	
	ДанныеВРеквизиты();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПерерасчетов(Форма)
	
	ПерерасчетыДоступны = ИсправлениеДокументовРасчетЗарплатыКлиентСервер.ПерерасчетыДоступны(Форма, , , Ложь);
	Форма.Элементы.НачисленияПерерасчетСтраница.Видимость = ПерерасчетыДоступны;
	Форма.Элементы.Страницы.ОтображениеСтраниц = ?(ПерерасчетыДоступны, ОтображениеСтраницФормы.ЗакладкиСверху, ОтображениеСтраницФормы.Нет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКодДоходаНДФЛ()
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодДохода()
	
	Объект.КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код160;

КонецПроцедуры

&НаСервере
Процедура РассчитатьНДФЛ(Знач СотрудникиФизическиеЛица = Неопределено, РассчитыватьВычет = Истина)
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента(Форма)
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	Описание.МесяцНачисленияИмя				= "ПериодРегистрации";
	Описание.ИменаПолейНачисления			= "ВидПризаПодарка";
	Описание.ВидНачисленияВШапке			= Истина;
	Описание.ВидНачисленияИмя				= "ВидПризаПодарка";
	
	Описание.ПериодДействияВШапке			= Истина;
	Описание.ПланируемаяДатаВыплатыИмя		= "ДатаПолученияДохода";
	Описание.ПорядокВыплатыИмя				= Неопределено;
	
	Описание.НачисленияИмя					= "Начисления";
	Описание.НачисленияКоманднаяПанельИмя	= "КомандыНачисления";
	
	Описание.УстанавливатьФиксРасчет		= Ложь;
	
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Месяц", "МесяцНачисленияСтрокой"));
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Дата получения дохода", "Объект.ДатаПолученияДохода"));
	
	Возврат Описание;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.СодержитПолеСотрудник						= Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник						= "Сотрудник";
	ОписаниеТаблицы.ИмяРеквизитаВидРасчета						= "ВидПризаПодарка";
	ОписаниеТаблицы.СодержитПолеВидРасчета						= Ложь;
	ОписаниеТаблицы.ИмяРеквизитаДатаНачала						= Неопределено;
	ОписаниеТаблицы.ИмяРеквизитаДатаОкончания					= Неопределено;
	ОписаниеТаблицы.ИмяРеквизитаПериод							= "ДатаПолученияДохода";
	
	ОписаниеТаблицы.ОтменятьВсеИсправления						= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

&НаСервере
Процедура НачисленияПослеУдаленияНаСервере(Сотрудник)
	
	РасчетЗарплатыРасширенный.ОчиститьДанныеФормыПоСотруднику(ЭтаФорма, ОписаниеДокумента(ЭтотОбъект), Сотрудник, Объект.Организация);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеСотрудника(ИдентификаторСтроки, ПрежнийСотрудник)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сотрудник = Объект.Начисления.НайтиПоИдентификатору(ИдентификаторСтроки).Сотрудник;
	
	ОписаниеТаблицы = ОписаниеТаблицыНачислений();
	
	ДополнитьСтрокуНаСервере(ИдентификаторСтроки);
	
	РасчетЗарплатыРасширенный.ОбработатьИзменениеСотрудникаВедущейТаблицыФормы(
		ЭтаФорма, ОписаниеДокумента(ЭтаФорма), Сотрудник, ПрежнийСотрудник);
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьСтрокуНаСервере(ИдентификаторСтроки)
	
	ДополнитьСтрокиНаСервере(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторСтроки));
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьСтрокиНаСервере(ИдентификаторыСтрок)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокСотрудников = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл 
		ДанныеСотрудника = Объект.Начисления.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЗначениеЗаполнено(ДанныеСотрудника.Сотрудник) Тогда 
			СписокСотрудников.Добавить(ДанныеСотрудника.Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СписокСотрудников, "Подразделение", Объект.ДатаПолученияДохода);
	
	Для Каждого КадровыеДанныеСотрудника Из КадровыеДанные Цикл 
		НайденныеСтроки = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", КадровыеДанныеСотрудника.Сотрудник));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.Подразделение = КадровыеДанныеСотрудника.Подразделение;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСотрудника(Сотрудник, ОписаниеТаблицы) Экспорт
	
	Если Не РасчетЗарплатыРасширенныйКлиент.ДобавитьСотрудникаКРасчету(ЭтаФорма, Сотрудник, ОписаниеТаблицы) Тогда
		РассчитатьСотрудникаНаСервере(Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСотрудникаНаСервере(Сотрудник)
	
	РассчитатьНДФЛ(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник));
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура ВидПризаПодаркаПриИзмененииНаСервере()
	
	УстановитьКодДохода();
	ЗаполнитьСписокВыбораКодДоходаНДФЛ();
	
КонецПроцедуры

&НаСервере
Процедура КодДоходаНДФЛПриИзмененииНаСервере()
	
	
КонецПроцедуры

&НаСервере
Процедура ДатаПолученияДоходаПриИзмененииНаСервере()
	
	
КонецПроцедуры

&НаСервере
Процедура ПредусмотреноКолдоговоромПриИзмененииНаСервере()
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.ПериодРегистрации));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбработкаПодбораНаСервере(Знач Сотрудники)
	
	ИдентификаторыСтрок = Новый Массив;
	
	Если ТипЗнч(Сотрудники) <> Тип("Массив") Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	Для Каждого Сотрудник Из Сотрудники Цикл
		СтрокиНачислений = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		
		Если СтрокиНачислений.Количество() = 0 Тогда
			СтрокаНачисления = Объект.Начисления.Добавить();
			СтрокаНачисления.Сотрудник = Сотрудник;
		Иначе
			СтрокаНачисления = СтрокиНачислений[0];
		КонецЕсли;
		
		ИдентификаторыСтрок.Добавить(СтрокаНачисления.ПолучитьИдентификатор());
	КонецЦикла;
	
	ОбработатьДобавлениеСотрудников(ИдентификаторыСтрок, Сотрудники);
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНачисленияСотрудника(Сотрудники, СохранятьИсправления = Истина) Экспорт
	ПерезаполнитьДанныеФормыНаСервере(Сотрудники, СохранятьИсправления);
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДанныеФормыНаСервере(Знач Сотрудники, СохранятьИсправления = Истина) Экспорт
	
	Если ТипЗнч(Сотрудники) <> Тип("Массив") Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	ИдентификаторыСтрок = Новый Массив;
	Если НЕ СохранятьИсправления Тогда
		Отбор = Новый Структура("Сотрудник");
		Для каждого Сотрудник Из Сотрудники Цикл
			Отбор.Вставить("Сотрудник", Сотрудник);
			
			// Заполняем поля по итогам заполнения коллекций.
			СтрокиПоСотруднику = Объект.Начисления.НайтиСтроки(Отбор);
			Для каждого СтрокаПоСотруднику Из СтрокиПоСотруднику Цикл
				ИдентификаторыСтрок.Добавить(СтрокаПоСотруднику.ПолучитьИдентификатор());
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ДополнитьСтрокиНаСервере(ИдентификаторыСтрок);
	РассчитатьНДФЛ(Сотрудники);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСотрудника(ИмяТаблицы, ВыбранныеСтроки, ВедущееПоле, ТипВедущегоПоля) Экспорт
	ПересчитатьСотрудникаНаСервере(ИмяТаблицы, ВыбранныеСтроки, ВедущееПоле, ТипВедущегоПоля);
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСотрудникаНаСервере(ИмяТаблицы, ВыбранныеСтроки, ВедущееПоле, ТипВедущегоПоля)
	РасчетЗарплатыРасширенный.ПересчитатьСотрудникаНаСервере(ЭтаФорма, ИмяТаблицы, ВыбранныеСтроки, ВедущееПоле, ТипВедущегоПоля);
КонецПроцедуры

&НаСервере
Процедура ОбработатьДобавлениеСотрудников(ИдентификаторыСтрок, Сотрудники)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнитьСтрокиНаСервере(ИдентификаторыСтрок);
	
	// Заполняем поля по итогам заполнения коллекций.
	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сотрудники, "ФизическоеЛицо");

	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаТаблицыНачислений = Объект.Начисления.НайтиПоИдентификатору(ИдентификаторСтроки);
		ФизическоеЛицоСтроки = ФизическиеЛицаСотрудников[СтрокаТаблицыНачислений.Сотрудник];
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДокументНаКлиенте()
	
	ПересчитатьДокументНаСервере(СотрудникиКРасчету);
	СотрудникиКРасчету.Очистить();
	РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПоказателейНаСервере(ЗначенияПоказателей)
	
	ФиксированнаяСумма = ЗначенияПоказателей[Справочники.ПоказателиРасчетаЗарплаты.ПустаяСсылка()];
	
	Сотрудники = Новый Массив;
	УникальныеСотрудники = Новый Соответствие;
	
	Для Каждого СтрокаСотрудника Из Объект.Начисления Цикл
		
		Если ФиксированнаяСумма <> Неопределено Тогда
			СтрокаСотрудника.Результат = ФиксированнаяСумма;
		КонецЕсли;
		
		Если УникальныеСотрудники[СтрокаСотрудника.Сотрудник] = Неопределено Тогда 
			Сотрудники.Добавить(СтрокаСотрудника.Сотрудник);
			УникальныеСотрудники.Вставить(СтрокаСотрудника.Сотрудник, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	РассчитатьНДФЛ();
	РассчитатьСотрудникаНаСервере(Сотрудники);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьДокументНаСервере(СотрудникиКРасчету)
	
	Для Каждого ТаблицаССотрудниками Из СотрудникиКРасчету Цикл
		Сотрудники = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаССотрудниками.Значение.СписокСотрудников, "Ключ");
		РассчитатьНДФЛ(Сотрудники);
	КонецЦикла;
	
КонецПроцедуры

#Область КонтролируемыеПоля

&НаСервере
Функция ПолучитьКонтролируемыеПоля() Экспорт
	
	НачисленияФиксРасчет = Новый Массив;
	НачисленияФиксРасчет.Добавить("Сотрудник");
	НачисленияФиксРасчет.Добавить("Результат");
	
	
	НачисленияФиксЗаполнение = Новый Массив;
	
	Возврат Новый Структура("Начисления",
		Новый Структура("ФиксРасчет, ФиксЗаполнение", НачисленияФиксРасчет, НачисленияФиксЗаполнение));
	
КонецФункции

&НаКлиенте
Функция ПолучитьСтарыеЗначенияКонтролируемыхПолей() Экспорт
	
	Возврат СтарыеЗначенияКонтролируемыхПолей;
	
КонецФункции

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Начисления");
	Массив.Добавить("Объект.ФизическиеЛица");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", НСтр("ru='организации';uk='організації'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти

СтарыеЗначенияКонтролируемыхПолей = Новый Соответствие;
СотрудникиКРасчету = Новый Соответствие;
