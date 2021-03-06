﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("Владелец") Тогда
			МодельБюджетирования = Параметры.Отбор.Владелец;
			СсылкаНаМодель = ПолучитьНавигационнуюСсылку(МодельБюджетирования);
			Элементы.НадписьМодельБюджетирования.Заголовок = 
				Новый ФорматированнаяСтрока(
					НСтр("ru='Модель бюджетирования: ';uk='Модель бюджетування: '"),
					Новый ФорматированнаяСтрока(Строка(МодельБюджетирования), , , , СсылкаНаМодель),
					" ( ",
					Новый ФорматированнаяСтрока(НСтр("ru='Обзор бюджетного процесса';uk='Огляд бюджетного процесу'"), , , , "Обзор"),
					" )");
			
		КонецЕсли;
	КонецЕсли;
	
	МодельОпределенаОтбором = ЗначениеЗаполнено(МодельБюджетирования);
	Элементы.СведенияОМоделиБюджетирования.Видимость = МодельОпределенаОтбором;
	Элементы.МодельБюджетирования.Видимость = Не МодельОпределенаОтбором;
	
	Если Не ЗначениеЗаполнено(МодельБюджетирования) Тогда
		МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
				Список, "Владелец", МодельБюджетирования, ЗначениеЗаполнено(МодельБюджетирования));
	КонецЕсли;
	
	Если Элементы.Найти("ФормаПереместитьВыше") <> Неопределено Тогда
		Элементы.ФормаПереместитьВыше.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.ЭтапыПодготовкиБюджетов);
	КонецЕсли;
	Если Элементы.Найти("ФормаПереместитьНиже") <> Неопределено Тогда
		Элементы.ФормаПереместитьНиже.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.ЭтапыПодготовкиБюджетов);
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьМодельБюджетированияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "Обзор" Тогда
		ОткрытьФорму("Обработка.МониторБюджетныхПроцессов.Форма", 
				Новый Структура("МодельБюджетирования, СформироватьПриОткрытии", МодельБюджетирования, Истина), 
				ЭтаФорма, 
				МодельБюджетирования);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СместитьЭлемент(Ссылка, Направление)
	
	Справочники.ЭтапыПодготовкиБюджетов.СдвинутьЭлемент(Ссылка, Направление);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВыше(Команда)
	
	СместитьЭлемент(Элементы.Список.ТекущаяСтрока, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьНиже(Команда)
	
	СместитьЭлемент(Элементы.Список.ТекущаяСтрока, 1);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура МодельБюджетированияПриИзменении(Элемент)
	
	Если НЕ МодельБюджетирования.Пустая() Тогда
		КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Список.Отбор, "Владелец", МодельБюджетирования);
	Иначе
		КомпоновкаДанныхКлиентСервер.УдалитьОтбор(Список.Отбор, "Владелец");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

