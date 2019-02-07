﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Шаблон = НСтр("ru='Выбор группы значений параметров обеспечения для выбранных позиций (%1)';uk='Вибір групи значень параметрів забезпечення для вибраних позицій (%1)'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметры.ВсегоСтрок);
	ЗагрузитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФорму()
	
	ДанныеВыбора = Справочники.ГруппировкиТоварныхОграничений.ДанныеВыбора(Параметры, Истина);
	Таблица.Очистить();
	ПараметрыКоманд.Очистить();
	Для Индекс = 0 По ВсегоКоманд - 1 Цикл
		Команды.Удалить(Команды.Найти("Команда" + Индекс));
		Элементы.Удалить(Элементы.Найти("КомандаФормы" + Индекс));
	КонецЦикла;
	
	ВсегоКоманд = 0;
	Для Каждого СтрокаТаблицы Из ДанныеВыбора Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Группировка) Тогда
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Представление = ПредставлениеГруппировки(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Склад, СтрокаТаблицы.Группировка);
		Иначе
			
			Представление = ПредставлениеГруппировки(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Склад, СтрокаТаблицы.Группировка);
			НоваяКоманда = Команды.Добавить("Команда" + ВсегоКоманд);
			НоваяКоманда.Действие = "СоздатьНовый";
			НоваяКоманда.Заголовок = Представление;
			НовыйЭлемент = Элементы.Добавить("КомандаФормы" + ВсегоКоманд, Тип("КнопкаФормы"), Элементы.Группа5);
			НовыйЭлемент.ИмяКоманды = "Команда" + ВсегоКоманд;
			НовыйЭлемент.Заголовок = Представление;
			СтрокаПараметров = ПараметрыКоманд.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПараметров, СтрокаТаблицы);
			СтрокаПараметров.Наименование = Представление;
			ВсегоКоманд = ВсегоКоманд + 1;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовый(Команда)
	
	ПараметрыФормы = Новый Структура("Номенклатура, Склад, Наименование");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыКоманд[Число(СтрЗаменить(Команда.Имя, "Команда", ""))]);
	ОткрытьФорму("Справочник.ГруппировкиТоварныхОграничений.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеГруппировки(Номенклатура, Склад, Группировка)
	
	Если Не ЗначениеЗаполнено(Номенклатура) И Не ЗначениеЗаполнено(Склад) Тогда
		
		Возврат Группировка;
		
	ИначеЕсли Не ЗначениеЗаполнено(Номенклатура) И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Любые товары на складах формата ""%1""';uk='Будь-які товари на складах формату ""%1""'"), Склад);
		
	ИначеЕсли Не ЗначениеЗаполнено(Номенклатура) И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Любые товары на складе ""%1""';uk='Будь-які товари на складі ""%1""'"), Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='""%1"" на складах формата ""%2""';uk='""%1"" на складах формату ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И Не ЗначениеЗаполнено(Склад) Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='""%1"" на любом складе';uk='""%1"" на будь-якому складі'"), Номенклатура);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='""%1"" на складах формата ""%2""';uk='""%1"" на складах формату ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='""%1"" с любой характеристикой на складе ""%2""';uk='""%1"" з будь-якою характеристикою на складі ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И Не ЗначениеЗаполнено(Склад) Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Товары категории ""%1"" на любом складе';uk='Товари категорії ""%1"" на будь-якому складі'"), Номенклатура);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Товары категории ""%1"" на складах формата ""%2""';uk='Товари категорії ""%1"" на складах формату ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Товары категории ""%1"" на складе ""%2""';uk='Товари категорії ""%1"" на складі ""%2""'"), Номенклатура, Склад);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	
	ЗначениеВыбора = Новый Структура("Группировка, Номенклатура, Склад");
	ЗаполнитьЗначенияСвойств(ЗначениеВыбора, Элементы.Таблица.ТекущиеДанные);
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьНовую(Команда)
	
	ОткрытьФорму("Справочник.ГруппировкиТоварныхОграничений.ФормаОбъекта");
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьГруппировкиТоварныхОграничений" Тогда
		ЗагрузитьФорму();
	КонецЕсли;
	
КонецПроцедуры

