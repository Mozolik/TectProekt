﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Статус     = Параметры.Статус;
	ДатаНачала = Параметры.ДатаНачала;
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Источник) = Тип("Массив") Тогда
		Для Каждого Источник Из Параметры.Источник Цикл
			НоваяСтрока = Источники.Добавить();
			НоваяСтрока.Ссылка = Источник;
		КонецЦикла;
	Иначе
		НоваяСтрока = Источники.Добавить();
		НоваяСтрока.Ссылка = Параметры.Источник;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СкидкаНаценка) Тогда
		Если ТипЗнч(Параметры.СкидкаНаценка) = Тип("Массив") Тогда
			Для Каждого Источник Из Параметры.СкидкаНаценка Цикл
				НоваяСтрока = СкидкиНаценки.Добавить();
				НоваяСтрока.Ссылка = Источник;
			КонецЦикла;
		Иначе
			НоваяСтрока = СкидкиНаценки.Добавить();
			НоваяСтрока.Ссылка = Параметры.СкидкаНаценка;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПозицияНоменклатуры) Тогда
		Если ТипЗнч(Параметры.ПозицияНоменклатуры) = Тип("Массив") Тогда
			Для Каждого ПозицияНоменклатуры Из Параметры.ПозицияНоменклатуры Цикл
				ЗаполнитьЗначенияСвойств(Товары.Добавить(), ПозицияНоменклатуры);
			КонецЦикла;
		Иначе
			ЗаполнитьЗначенияСвойств(Товары.Добавить(), Параметры.ПозицияНоменклатуры);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статус) Тогда
		Элементы.Статус.Видимость = Ложь;
	Иначе
		Элементы.Статус.Видимость = Истина;
	КонецЕсли;
	
	НастроитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусДействуетДоМаксимальнойДатыПриИзменении(Элемент)
	ВариантВыбораДатыОкончанияПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДействуетДоДатыПриИзменении(Элемент)
	ВариантВыбораДатыОкончанияПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальнаяДатаНеОпределенаСтатусДействуетБессрочноПриИзменении(Элемент)
	ВариантВыбораДатыОкончанияПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальнаяДатаНеОпределенаДействуетДоДатыПриИзменении(Элемент)
	ВариантВыбораДатыОкончанияПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Статус) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Статус""';uk='Не заповнене поле ""Статус""'"), ,"Статус",,Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнено поле ""Дата начала""';uk='Не заповнене поле ""Дата початку""'"), ,"ДатаНачала",,Отказ);
	КонецЕсли;
	
	Если МаксимальнаяДатаОпределена Тогда
		
		Если Не ЗначениеЗаполнено(ДатаОкончания)
			И ВариантВыбораДатыОкончания = 0
			И Статус = ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует") Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнено поле ""Дата окончания""';uk='Не заповнене поле ""Дата закінчення""'"), ,"ДатаОкончания",,Отказ);
		КонецЕсли;
	
		Если ДатаОкончания > МаксимальнаяДатаНовогоСтатуса
			И ВариантВыбораДатыОкончания = 0 Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Дата окончания действия не может быть позже %1';uk='Дата закінчення дії не може бути пізніше %1'"),
					Формат(МаксимальнаяДатаНовогоСтатуса, НСтр("ru='ДФ=dd.MM.yyyy';uk='ДФ=dd.MM.yyyy'"))),
					,
					"ДатаОкончания",
					,
					Отказ);
		КонецЕсли;
	
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИзменениеНаСервере();
	
	Если СкидкиНаценки.Количество() > 0 Тогда
	
		МассивСкидкиНаценки = Новый Массив;
		МассивИсточники = Новый Массив;
		
		Для Каждого СтрокаТЧ Из СкидкиНаценки Цикл
			МассивСкидкиНаценки.Добавить(СтрокаТЧ.Ссылка);
		КонецЦикла;
		Для Каждого СтрокаТЧ Из Источники Цикл
			МассивИсточники.Добавить(СтрокаТЧ.Ссылка);
		КонецЦикла;
		
		Параметр = Новый Структура;
		Параметр.Вставить("СкидкаНаценка", МассивСкидкиНаценки);
		Параметр.Вставить("Источник", МассивИсточники);
		
		Оповестить("Запись_ДействиеСкидокНаценок", Параметр, ЭтаФорма);
	
	КонецЕсли;
	
	Если Товары.Количество() > 0 Тогда
	
		МассивИсточники = Новый Массив;
		Для Каждого СтрокаТЧ Из Источники Цикл
			МассивИсточники.Добавить(СтрокаТЧ.Ссылка);
		КонецЦикла;
		
		Параметр = Новый Структура;
		Параметр.Вставить("Источник", МассивИсточники);
		
		Оповестить("Запись_ДействиеСкидокНаценокПоНоменклатуре", Параметр, ЭтаФорма);
	
	КонецЕсли;
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФорму()
	
	Если СкидкиНаценки.Количество() > 0 Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Минимум(Т.Период) КАК Период
		|ИЗ
		|	РегистрСведений.ДействиеСкидокНаценок КАК Т
		|ГДЕ
		|	Т.Период > &ДатаНачала
		|	И Т.Источник В (&Источники)
		|	И Т.СкидкаНаценка В (&Таблица)";
		
		Таблица = СкидкиНаценки.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;
	
	Если Товары.Количество() > 0 Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Т.Номенклатура,
		|	Т.Характеристика
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Таблица КАК Т
		|;
		|
		|ВЫБРАТЬ
		|	Минимум(Т.Период) КАК Период
		|ИЗ
		|	РегистрСведений.ДействиеСкидокНаценокПоНоменклатуре КАК Т
		|ГДЕ
		|	Т.Период > &ДатаНачала
		|	И Т.Источник В (&Источники)
		|	И (Т.Номенклатура, Т.Характеристика) В (ВЫБРАТЬ Т.Номенклатура, Т.Характеристика Из Товары КАК Т)";
		
		Таблица = Товары.Выгрузить();
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("Источники", Источники.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	Запрос.УстановитьПараметр("Таблица", Таблица);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МаксимальнаяДатаНовогоСтатуса = '00010101';
	ВариантВыбораДатыОкончания = 0;
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Период) Тогда
		МаксимальнаяДатаНовогоСтатуса = НачалоДня(Выборка.Период - 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МаксимальнаяДатаНовогоСтатуса) Тогда
		ВариантВыбораДатыОкончания = 1;
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыДействияСкидок.НеДействует Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.НеДействует;
	Иначе
		Если ЗначениеЗаполнено(МаксимальнаяДатаНовогоСтатуса) Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.МаксимальнаяДатаОпределена;
			МаксимальнаяДатаОпределена = Истина;
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.МаксимальнаяДатаНеОпределена;
			МаксимальнаяДатаОпределена = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтатусДействуетДоМаксимальнойДаты.СписокВыбора[0].Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"по %1", Формат(МаксимальнаяДатаНовогоСтатуса,НСтр("ru='ДФ=dd.MM.yyyy';uk='ДФ=dd.MM.yyyy'")));
	
	ВариантВыбораДатыОкончанияПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВариантВыбораДатыОкончанияПриИзменении(Форма)

	Форма.Элементы.МаксимальнаяДатаНеОпределенаДатаОкончания.Доступность = (Форма.ВариантВыбораДатыОкончания = 1);
	Форма.Элементы.ДатаОкончания.Доступность = (Форма.ВариантВыбораДатыОкончания = 0);

КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзменениеНаСервере()
	
	НачатьТранзакцию();
	
	ДатаОкончанияДействия = Неопределено;
	Если МаксимальнаяДатаОпределена Тогда
		
		Если ВариантВыбораДатыОкончания = 0 Тогда
			ДатаОкончанияДействия = ДатаОкончания;
		Иначе
			ДатаОкончанияДействия = МаксимальнаяДатаНовогоСтатуса;
		КонецЕсли;
		
	Иначе
		
		Если ВариантВыбораДатыОкончания = 1 Тогда
			ДатаОкончанияДействия = ДатаОкончания;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаИсточник Из Источники Цикл
		
		Для Каждого СтрокаСкидкаНаценка Из СкидкиНаценки Цикл
			
			МенеджерЗаписи = РегистрыСведений.ДействиеСкидокНаценок.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период        = ДатаНачала;
			МенеджерЗаписи.Источник      = СтрокаИсточник.Ссылка;
			МенеджерЗаписи.СкидкаНаценка = СтрокаСкидкаНаценка.Ссылка;
			МенеджерЗаписи.Статус        = Статус;
			МенеджерЗаписи.Ответственный = Пользователи.ТекущийПользователь();
			МенеджерЗаписи.Комментарий   = Комментарий;
			МенеджерЗаписи.Записать(Истина);
			
			Если ЗначениеЗаполнено(ДатаОкончанияДействия) И Статус = Перечисления.СтатусыДействияСкидок.Действует Тогда
				МенеджерЗаписи = РегистрыСведений.ДействиеСкидокНаценок.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период        = КонецДня(ДатаОкончанияДействия) + 1;
				МенеджерЗаписи.Источник      = СтрокаИсточник.Ссылка;
				МенеджерЗаписи.СкидкаНаценка = СтрокаСкидкаНаценка.Ссылка;
				МенеджерЗаписи.Статус        = Перечисления.СтатусыДействияСкидок.НеДействует;
				МенеджерЗаписи.Ответственный = Пользователи.ТекущийПользователь();
				МенеджерЗаписи.Записать(Истина);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого ПозицияНоменклатуры Из Товары Цикл
			
			МенеджерЗаписи = РегистрыСведений.ДействиеСкидокНаценокПоНоменклатуре.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период         = ДатаНачала;
			МенеджерЗаписи.Источник       = СтрокаИсточник.Ссылка;
			МенеджерЗаписи.Номенклатура   = ПозицияНоменклатуры.Номенклатура;
			МенеджерЗаписи.Характеристика = ПозицияНоменклатуры.Характеристика;
			МенеджерЗаписи.Статус         = Статус;
			МенеджерЗаписи.Ответственный  = Пользователи.ТекущийПользователь();
			МенеджерЗаписи.Комментарий    = Комментарий;
			МенеджерЗаписи.Записать(Истина);
			
			Если ЗначениеЗаполнено(ДатаОкончанияДействия) И Статус = Перечисления.СтатусыДействияСкидок.Действует Тогда
				МенеджерЗаписи = РегистрыСведений.ДействиеСкидокНаценокПоНоменклатуре.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период         = КонецДня(ДатаОкончанияДействия) + 1;
				МенеджерЗаписи.Источник       = СтрокаИсточник.Ссылка;
				МенеджерЗаписи.Номенклатура   = ПозицияНоменклатуры.Номенклатура;
				МенеджерЗаписи.Характеристика = ПозицияНоменклатуры.Характеристика;
				МенеджерЗаписи.Статус         = Перечисления.СтатусыДействияСкидок.НеДействует;
				МенеджерЗаписи.Ответственный  = Пользователи.ТекущийПользователь();
				МенеджерЗаписи.Записать(Истина);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти
