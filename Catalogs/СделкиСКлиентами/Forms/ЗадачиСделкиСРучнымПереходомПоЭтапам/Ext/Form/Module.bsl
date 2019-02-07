﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//получить информацию о сделке
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СделкиСКлиентами.Ссылка,
		|	СделкиСКлиентами.ДатаНачала,
		|	СделкиСКлиентами.Статус,
		|	СделкиСКлиентами.ПотенциальнаяСуммаПродажи
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &Сделка");
	Запрос.УстановитьПараметр("Сделка", Параметры.Ключ);
	Выборка = Запрос.Выполнить().Выбрать();

	//определить состав этапов и доступность редактирования
	Если Выборка.Следующий() Тогда
		Сделка     = Выборка.Ссылка;
		ДатаНачала = Выборка.ДатаНачала;
		Потенциал  = Выборка.ПотенциальнаяСуммаПродажи;

		//получить план и фактические даты выполнения задач по сделке
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ПланСделки.ЭтапПроцессаПродажи,
			|	СтатистикаСделокСКлиентами.ДатаНачала,
			|	СтатистикаСделокСКлиентами.ДатаОкончания
			|ИЗ
			|	(ВЫБРАТЬ
			|		СделкиСКлиентами.Ссылка КАК Сделка,
			|		ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.НомерСтроки КАК НомерСтроки,
			|		ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.ЭтапПроцессаПродажи КАК ЭтапПроцессаПродажи
			|	ИЗ
			|		Справочник.СделкиСКлиентами КАК СделкиСКлиентами
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыСделокСКлиентами.ЭтапыСделкиПоПродаже КАК ВидыСделокСКлиентамиЭтапыСделкиПоПродаже
			|			ПО СделкиСКлиентами.ВидСделки = ВидыСделокСКлиентамиЭтапыСделкиПоПродаже.Ссылка
			|	ГДЕ
			|		СделкиСКлиентами.Ссылка = &Сделка) КАК ПланСделки
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатистикаСделокСКлиентами КАК СтатистикаСделокСКлиентами
			|		ПО ПланСделки.Сделка = СтатистикаСделокСКлиентами.Сделка
			|			И ПланСделки.ЭтапПроцессаПродажи = СтатистикаСделокСКлиентами.ЭтапПроцесса
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПланСделки.НомерСтроки");
		Запрос.УстановитьПараметр("Сделка", Сделка);
		ТаблицаЭтапов = Запрос.Выполнить();

		//проконтролировать корректность настройки вида сделки
		Если ТаблицаЭтапов.Пустой() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Вид сделки настроен некорректно.';uk='Вид угоди налаштований некоректно.'"));
			Доступность = Ложь;
			Возврат;
		КонецЕсли;//проконтролировать корректность настройки вида сделки

		ТаблицаЭтапов = ТаблицаЭтапов.Выгрузить();
		ТаблицаЭтапов.Колонки.Вставить(0, "ФлагЭтапа");
		ТаблицаЭтапов.ЗаполнитьЗначения(Ложь, "ФлагЭтапа");
		ТекущийЭтап = СделкиСервер.ПолучитьТекущийЭтап(Сделка);

		КоличествоЭтапов = ТаблицаЭтапов.Количество() - 1;
		СтрокаСписка = ТаблицаЭтапов.Найти(ТекущийЭтап, "ЭтапПроцессаПродажи");
		Если СтрокаСписка = Неопределено Тогда
			ИндексТекущегоЭтапа = 0;
			ТаблицаЭтапов[0].ДатаНачала = ДатаНачала;
		Иначе
			ИндексТекущегоЭтапа = ТаблицаЭтапов.Индекс(СтрокаСписка);
		КонецЕсли;

		ЗначениеВРеквизитФормы(ТаблицаЭтапов, "Список");

		Если Выборка.Статус <> Перечисления.СтатусыСделок.ВРаботе Тогда
			Элементы.ДатаНачала.ТолькоПросмотр = Истина;

			Элементы.ЗаписатьИЗакрыть.Доступность       = Ложь;
			Элементы.ГруппаДвижениеПоЭтапам.Доступность = Ложь;
			Элементы.ПерейтиНаВыбранныйЭтап.Доступность = Ложь;
			Элементы.КнопкаОтменить.КнопкаПоУмолчанию   = Истина;

			Элементы.ГруппаДвижениеПоЭтапамКонтекстное.Доступность  = Ложь;
			Элементы.КнопкаПерейтиНаВыбранныйЭтап.Доступность       = Ложь;
		Иначе
			УстановитьДоступностьУправления();
		КонецЕсли;
	КонецЕсли;//определить состав этапов и доступность редактирования

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	Если Элемент.ТекущийЭлемент.Имя = "ЭтапПроцессаПродажи" Тогда
		Отказ = Истина;
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЭтапПроцессаПродажи);
		Возврат;
	КонецЕсли;

	Если Элемент.ТекущаяСтрока = 0 Тогда
		Отказ = Истина;
	Иначе
		ТекущаяДатаНачала = Элемент.ТекущиеДанные.ДатаНачала;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)

	Если Элемент.ТекущийЭлемент.Имя = "ЭтапПроцессаПродажи" Тогда
		ОтменаРедактирования = Истина;
		Отказ = Истина;
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЭтапПроцессаПродажи);
		Возврат;
	КонецЕсли;

	НоваяДатаНачала = Элемент.ТекущиеДанные.ДатаНачала;
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Если НоваяДатаНачала < ДатаНачала Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата начала задачи не должна быть раньше начала сделки.';uk='Дата початку задачі не повинна бути раніше початку угоди.'"));
		Отказ = Истина;
	ИначеЕсли ТекущаяДатаНачала = '0001.01.01' Тогда //переход на новый этап
		ИндексНовогоЭтапа = ТекущаяСтрока;
		Для счЭтапов = 0 По ИндексНовогоЭтапа - 1 Цикл
			Этап = Список.Получить(счЭтапов);
			Если Этап.ДатаНачала = '0001.01.01' ИЛИ Этап.ДатаНачала > НоваяДатаНачала Тогда
				Этап.ДатаНачала = НоваяДатаНачала;
			КонецЕсли;
			Если Этап.ДатаОкончания = '0001.01.01' ИЛИ Этап.ДатаОкончания > НоваяДатаНачала Тогда
				Этап.ДатаОкончания = НоваяДатаНачала;
			КонецЕсли;
			Если счЭтапов = ИндексТекущегоЭтапа Тогда
				Список.Получить(счЭтапов).ДатаОкончания = НоваяДатаНачала;
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Истина;
	ИначеЕсли НоваяДатаНачала < ТекущаяДатаНачала Тогда // более ранняя дата
		Для счЭтапов = 0 По ТекущаяСтрока - 1 Цикл
			Этап = Список.Получить(счЭтапов);
			Если Этап.ДатаНачала > НоваяДатаНачала Тогда
				Этап.ДатаНачала = НоваяДатаНачала;
			КонецЕсли;
			Если Этап.ДатаОкончания > НоваяДатаНачала Тогда
				Этап.ДатаОкончания = НоваяДатаНачала;
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Истина;
	ИначеЕсли НоваяДатаНачала > ТекущаяДатаНачала Тогда // более поздняя дата
		Список.Получить(ТекущаяСтрока - 1).ДатаОкончания = НоваяДатаНачала;
		Для счЭтапов = ТекущаяСтрока По КоличествоЭтапов Цикл
			Этап = Список.Получить(счЭтапов);
			Если Этап.ДатаНачала <> '0001.01.01' И Этап.ДатаНачала < НоваяДатаНачала Тогда
				Этап.ДатаНачала = НоваяДатаНачала;
			КонецЕсли;
			Если Этап.ДатаОкончания <> '0001.01.01' И Этап.ДатаОкончания < НоваяДатаНачала Тогда
				Этап.ДатаОкончания = НоваяДатаНачала;
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)

	Если Модифицированность Тогда
		ЗаписатьСтатистику();
		Оповестить("Запись_СтатистикаСделокСКлиентами", Новый Структура("Сделка",Сделка));
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СледующийЭтап(Команда)

	ИзменитьЭтап(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийЭтап(Команда)

	ИзменитьЭтап(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаВыбранныйЭтап(Команда)

	ИндексНовогоЭтапа = Элементы.Список.ТекущаяСтрока;

	Если ИндексНовогоЭтапа = ИндексТекущегоЭтапа Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Необходимо выбрать этап отличный от текущего';uk='Необхідно вибрати етап відмінний від поточного'"));
	Иначе

		//переход на более поздний этап
		Если ИндексНовогоЭтапа > ИндексТекущегоЭтапа Тогда
			Список.Получить(ИндексТекущегоЭтапа).ДатаОкончания = ТекущаяДата();
			Список.Получить(ИндексНовогоЭтапа).ДатаНачала      = ТекущаяДата();
			Для счЭтапов = ИндексТекущегоЭтапа + 1 По ИндексНовогоЭтапа - 1 Цикл
				Этап = Список.Получить(счЭтапов);
				Этап.ДатаНачала = ТекущаяДата();
				Этап.ДатаОкончания = Этап.ДатаНачала;
			КонецЦикла;
		Иначе //переход на более ранний этап
			Список.Получить(ИндексТекущегоЭтапа).ДатаНачала  = '0001.01.01';
			Список.Получить(ИндексНовогоЭтапа).ДатаОкончания = '0001.01.01';
			Для счЭтапов = ИндексНовогоЭтапа + 1 По ИндексТекущегоЭтапа - 1 Цикл
				Этап = Список.Получить(счЭтапов);
				Этап.ДатаНачала = '0001.01.01';
				Этап.ДатаОкончания = '0001.01.01';
			КонецЦикла;
		КонецЕсли;
		ИндексТекущегоЭтапа = ИндексНовогоЭтапа;
		Модифицированность = Истина;
		УстановитьДоступностьУправления();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
//Установить доступность команд переходов в зависисмости от текущего этапа
Процедура УстановитьДоступностьУправления()

	Элементы.ПредыдущийЭтап.Доступность       = ИндексТекущегоЭтапа > 0;
	Элементы.СледующийЭтап.Доступность        = ИндексТекущегоЭтапа < Список.Количество() - 1;
	Элементы.КнопкаПредыдущийЭтап.Доступность = Элементы.ПредыдущийЭтап.Доступность;
	Элементы.КнопкаСледующийЭтап.Доступность  = Элементы.СледующийЭтап.Доступность;

	Для СчетчикЭтапов = 0 По КоличествоЭтапов Цикл
		Список[СчетчикЭтапов].ФлагЭтапа = (СчетчикЭтапов = ИндексТекущегоЭтапа);
	КонецЦикла;

КонецПроцедуры

&НаСервере
//Записать изменения в регистр статистики
Процедура ЗаписатьСтатистику()
	
	УстановитьПривилегированныйРежим(Истина);

	Ответственный = Пользователи.ТекущийПользователь();
	Статистика = РегистрыСведений.СтатистикаСделокСКлиентами.СоздатьНаборЗаписей();
	Статистика.Отбор.Сделка.Установить(Сделка);
	Для счЭтапов = 0 По ИндексТекущегоЭтапа Цикл
		Этап = Список.Получить(счЭтапов);
		Запись = Статистика.Добавить();
		Запись.Сделка = Сделка;
		Запись.ЭтапПроцесса = Этап.ЭтапПроцессаПродажи;
		Запись.ДатаНачала = Этап.ДатаНачала;
		Запись.ДатаОкончания = Этап.ДатаОкончания;
		Запись.Потенциал = Потенциал;
		Запись.Ответственный = Ответственный;
		Запись.Результат = ?(
			Этап.ДатаОкончания = '0001.01.01',
			Перечисления.СтатусыСделок.ВРаботе,
			Перечисления.СтатусыСделок.Выиграна);
	КонецЦикла;
	Статистика.Записать();

КонецПроцедуры

&НаКлиенте
//Перевести текущий этап на следующий или предыдущий
//Параметры:
//Вперед - направление перехода (истина если вперед)
//
Процедура ИзменитьЭтап(Вперед)

	Если Вперед Тогда
		Список.Получить(ИндексТекущегоЭтапа).ДатаОкончания  = ТекущаяДата();
		ИндексТекущегоЭтапа = ИндексТекущегоЭтапа + 1;
		Список.Получить(ИндексТекущегоЭтапа).ДатаНачала = ТекущаяДата();
	Иначе
		Список.Получить(ИндексТекущегоЭтапа).ДатаНачала = '0001.01.01';
		ИндексТекущегоЭтапа = ИндексТекущегоЭтапа - 1;
		Список.Получить(ИндексТекущегоЭтапа).ДатаОкончания = '0001.01.01';
	КонецЕсли;

	УстановитьДоступностьУправления();
	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти
