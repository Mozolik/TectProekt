﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбъектОтбора", ОбъектСсылка);
	ИсходныйОбъект = ОбъектСсылка;
	Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ОбновитьДеревоСтруктурыПодчиненностиЭД();
	КонецЕсли;
	
	Элементы.ЖурналСобытий.Доступность = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		ОбновитьДеревоСтруктурыПодчиненностиЭД();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбъектРасшифровки = Элемент.ТекущаяОбласть.Расшифровка;
	Если ТипЗнч(ОбъектРасшифровки) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ОбъектРасшифровки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиСтруктуруПодчиненностиЭД();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналСобытий(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВладелецЭД", ОбъектСсылка);
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ОткрытьФорму("РегистрСведений.ЖурналСобытийЭД.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДеревоСтруктурыПодчиненностиЭД()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиОбмена = ОбменСКонтрагентамиСлужебный.ОпределитьНастройкиОбменаЭДПоИсточнику(ОбъектСсылка, Ложь);
	Если НЕ ЗначениеЗаполнено(НастройкиОбмена) Тогда
		ТребуетсяПодпись = Ложь;
	Иначе
		ТребуетсяПодпись = НастройкиОбмена.Подписывать;
		НастройкаЭДО = НастройкиОбмена.СоглашениеЭД;
	КонецЕсли;
	
	СформироватьДеревьяЭД();
	ВывестиТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяЭД()
	
	ДеревоПодчиненныеЭД.ПолучитьЭлементы().Очистить();
	ВывестиПодчиненныеДокументы(ОбъектСсылка, ДеревоПодчиненныеЭД);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыборкуПоРеквизитамДокумента(СсылкаНаОбъект)
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	
	Если ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка.СоглашенияОбИспользованииЭД") Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ссылка,
		|	Ложь КАК Проведен,
		|	ПометкаУдаления,
		|	Представление
		|ИЗ
		|	Справочник." + МетаданныеОбъекта.Имя + "
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ссылка,
		|	Проведен,
		|	ПометкаУдаления,
		|	Представление
		|ИЗ
		|	Документ." + МетаданныеОбъекта.Имя + "
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

&НаСервере
Функция ПолучитьСписокЭДПоВладельцу(ОбъектВладелец)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ОбъектВладелец";
	Запрос.УстановитьПараметр("ОбъектВладелец", ОбъектВладелец);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ВывестиПодчиненныеДокументы(ТекущийДокумент, ДеревоРодитель)
	
	СтрокиДерева = ДеревоРодитель.ПолучитьЭлементы();
	Таблица = ПолучитьСписокЭДПоВладельцу(ТекущийДокумент);
	Если Таблица = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрисоединенныеФайлы.Ссылка,
	|	ПрисоединенныеФайлы.СтатусЭД,
	|	ПрисоединенныеФайлы.НомерВерсииЭД,
	|	ПрисоединенныеФайлы.ДатаИзмененияСтатусаЭД,
	|	ПрисоединенныеФайлы.НаправлениеЭД,
	|	ПрисоединенныеФайлы.Представление,
	|	ПрисоединенныеФайлы.ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА ПодчиненныеПрисоединенныеФайлы.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК НаличиеПодчиненныхДокументов,
	|	ПрисоединенныеФайлы.ВладелецФайла.Дата КАК ДатаВладельца,
	|	ПрисоединенныеФайлы.ВладелецФайла.Номер КАК НомерВладельца,
	|	ПрисоединенныеФайлы.ВидЭД
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭДПрисоединенныеФайлы КАК ПодчиненныеПрисоединенныеФайлы
	|		ПО (ПодчиненныеПрисоединенныеФайлы.ЭлектронныйДокументВладелец = ПрисоединенныеФайлы.Ссылка)
	|ГДЕ
	|	(ПрисоединенныеФайлы.ВладелецФайла = &ОбъектВладелец
	|			ИЛИ ПрисоединенныеФайлы.ЭлектронныйДокументВладелец = &ОбъектВладелец)
	|	И НЕ ПрисоединенныеФайлы.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ДопДанные)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПрисоединенныеФайлы.ДатаСоздания";
	Запрос.УстановитьПараметр("ОбъектВладелец", ТекущийДокумент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДеревоОбъект = РеквизитФормыВЗначение("ДеревоПодчиненныеЭД");
		Если ДеревоОбъект.Строки.Найти(Выборка.Ссылка, , Истина) = Неопределено Тогда
			НоваяСтрока = СтрокиДерева.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка,
				"Ссылка, СтатусЭД, ДатаИзмененияСтатусаЭД, НаправлениеЭД, Представление, ПометкаУдаления");
			Если ЗначениеЗаполнено(Выборка.ДатаВладельца) И ЗначениеЗаполнено(Выборка.НомерВладельца) Тогда
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерВладельца", Выборка.НомерВладельца);
				СтруктураПараметров.Вставить("ДатаВладельца", Выборка.ДатаВладельца);
				СтруктураПараметров.Вставить("ВерсияЭД", Выборка.НомерВерсииЭД);
				НоваяСтрока.Представление = ОбменСКонтрагентамиСлужебный.ОпределитьПредставлениеЭД(Выборка.ВидЭД, СтруктураПараметров);
			КонецЕсли;
			Если Выборка.НаличиеПодчиненныхДокументов Тогда
				ВывестиПодчиненныеДокументы(Выборка.Ссылка, НоваяСтрока);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиТабличныйДокумент()
	
	ТаблицаОтчета.Очистить();
	
	Макет = ПолучитьОбщийМакет("ЭД_Список");
	
	ВывестиТекущийДокумент(Макет);
	ВывестиПодчиненныеЭлементыДерева(ДеревоПодчиненныеЭД.ПолучитьЭлементы(), Макет, 1)
	
КонецПроцедуры

&НаСервере
Процедура ВывестиДокументИКартинку(СтрокаДерева, Макет, ЭтоТекущийДокумент = Ложь, ЭтоПодчиненный = Неопределено)
	
	Если ЭтоТекущийДокумент Тогда
		Если СтрокаДерева.Проведен Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли СтрокаДерева.ПометкаУдаления Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрокаДерева.Ссылка = ОбъектСсылка Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоВерх");
				Иначе	
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ТаблицаОтчета.Вывести(ОбластьКартинка);
	Иначе
		Если СтрокаДерева.ПометкаУдаления Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли СтрокаДерева.НаправлениеЭД = Перечисления.НаправленияЭД.Входящий
			И (ТребуетсяПодпись И СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.ДоставленоПодтверждение
			ИЛИ НЕ ТребуетсяПодпись И (СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.Утвержден
			ИЛИ СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.ОтправленоИзвещение))
			ИЛИ СтрокаДерева.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий
			И (ТребуетсяПодпись И (СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение
			ИЛИ СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.Доставлен)
			ИЛИ НЕ ТребуетсяПодпись И СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.Доставлен)
			ИЛИ СтрокаДерева.НаправлениеЭД = Перечисления.НаправленияЭД.Интеркампани
			И ТребуетсяПодпись И СтрокаДерева.СтатусЭД = Перечисления.СтатусыЭД.ПолностьюПодписан Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрокаДерева.Ссылка = ОбъектСсылка Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоНиз");
				Иначе	
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ТаблицаОтчета.Присоединить(ОбластьКартинка);
	КонецЕсли;
	
	ОбластьДокумент = Макет.ПолучитьОбласть(?(ЭтоТекущийДокумент,"ТекущийДокумент", "Документ"));
	Если ЭтоТекущийДокумент Тогда
		ОбластьДокумент.Параметры.ПредставлениеДокумента = ПолучитьПредставлениеДокументаДляПечати(СтрокаДерева);
	Иначе
		ОбластьДокумент.Параметры.ПредставлениеДокумента = ПолучитьПредставлениеЭД(СтрокаДерева);
	КонецЕсли;
	ОбластьДокумент.Параметры.Документ = СтрокаДерева.Ссылка;
	ТаблицаОтчета.Присоединить(ОбластьДокумент);
	
КонецПроцедуры

&НаСервере
Функция НеобходимоВывестиВертикальныйКоннектор(УровеньВверх, СтрокаДерева, ИщемСредиПодчиненных = Истина)
	
	ТекущаяСтрока = СтрокаДерева;
	
	Для инд=1 По УровеньВверх Цикл
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
		Если инд = УровеньВверх Тогда
			ИскомыйРодитель = ТекущаяСтрока;
		ИначеЕсли инд = (УровеньВверх-1) Тогда
			ИскомаяСтрока = ТекущаяСтрока;
		КонецЕсли;
	КонецЦикла;
	
	Если ИскомыйРодитель = Неопределено Тогда
		Если ИщемСредиПодчиненных Тогда
			ПодчиненныеЭлементыРодителя = ДеревоПодчиненныеЭД.ПолучитьЭлементы();
		Иначе
			ПодчиненныеЭлементыРодителя = ДеревоРодительскиеЭД.ПолучитьЭлементы();
		КонецЕсли;
	Иначе
		ПодчиненныеЭлементыРодителя = ИскомыйРодитель.ПолучитьЭлементы();
	КонецЕсли;
	
	Возврат ПодчиненныеЭлементыРодителя.Индекс(ИскомаяСтрока) < (ПодчиненныеЭлементыРодителя.Количество()-1);
	
КонецФункции

// Выводит в табличный документ строку с документом, для которого формируется структура подчиненности
//
// Параметры
// Макет - МакетТабличногоДокумента - макет, на основании которого формируется табличный документ.
&НаСервере
Процедура ВывестиТекущийДокумент(Макет)
	
	Выборка = ПолучитьВыборкуПоРеквизитамДокумента(ОбъектСсылка);
	Если Выборка.Следующий() Тогда
		ВывестиДокументИКартинку(Выборка, Макет, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление документа для вывода в табличный документ
//
// Параметры
// Выборка - ВыборкаИзРезультатаЗапроса или ДанныеФормыЭлементДерева - набор данных
//   на основании которого формируется представление.
//
// Возвращаемое значение:
// Строка - сформированное представление
//
&НаСервере
Функция ПолучитьПредставлениеДокументаДляПечати(Выборка)
	
	ПредставлениеДокумента = Выборка.Представление;
	
	Возврат ПредставлениеДокумента;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеЭД(Выборка)
	
	ПредставлениеДокумента = Выборка.Представление;
	ПредставлениеДокумента = ПредставлениеДокумента + " <" + Выборка.СтатусЭД + ", "
		+ Формат(Выборка.ДатаИзмененияСтатусаЭД, "ДЛФ=") + ">";
	
	Возврат ПредставлениеДокумента;
	
КонецФункции

// Выводит строки дерева подчиненных документов
//
// Параметры
// СтрокиДерева - ДанныеФормыКоллекцияЭлементовДерева - строки дерева
//   которые выводятся в табличный документ
// Макет - МакетТабличногоДокумента - макет, на основании которого
//   происходит вывод в табличный документ
// УровеньРекурсии - Число - уровень рекурсии процедуры
//
&НаСервере
Процедура ВывестиПодчиненныеЭлементыДерева(СтрокиДерева, Макет, УровеньРекурсии)
	
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		ЭтоТекущийОбъект = (СтрокаДерева.Ссылка = ОбъектСсылка);
		ЭтоИсходныйОбъект = (СтрокаДерева.Ссылка = ИсходныйОбъект);
		ПодчиненныеЭлементыДерева = СтрокаДерева.ПолучитьЭлементы();
		
		Для инд = 1 По УровеньРекурсии Цикл
			Если УровеньРекурсии > инд Тогда
				
				Если НеобходимоВывестиВертикальныйКоннектор(УровеньРекурсии - инд + 1,СтрокаДерева) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
			Иначе 
				
				Если СтрокиДерева.Количество() > 1 И (СтрокиДерева.Индекс(СтрокаДерева) <> (СтрокиДерева.Количество()-1)) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("КоннекторВерхПраво");
				КонецЕсли;
				
			КонецЕсли;
			
			Область.Параметры.Документ = ?(ЭтоИсходныйОбъект,Неопределено,СтрокаДерева.Ссылка);
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;
		
		ВывестиДокументИКартинку(СтрокаДерева,Макет,Ложь,Истина);
		
		// Вывод подчиненных элементов дерева
		ВывестиПодчиненныеЭлементыДерева(ПодчиненныеЭлементыДерева,Макет,УровеньРекурсии + 1);
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтруктуруПодчиненностиЭД()
	
	ОбновитьДеревоСтруктурыПодчиненностиЭД();
	
КонецПроцедуры

#КонецОбласти
