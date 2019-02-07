﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаказНаПроизводство = Параметры.ЗаказНаПроизводство;
	КлючСвязиПродукция = Параметры.КлючСвязиПродукция;
	КодСтрокиЭтапыГрафик = Параметры.КодСтрокиЭтапыГрафик;
	КлючСвязиЭтапы = Параметры.КлючСвязиЭтапы;
	
		Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Продукция.КодСтроки КАК КодСтрокиПродукция,
	|	Продукция.Номенклатура КАК Номенклатура,
	|	Продукция.Характеристика КАК Характеристика,
	|	Продукция.Спецификация КАК Спецификация,
	|	Продукция.Ссылка.Номер КАК Номер,
	|	Продукция.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.ЗаказНаПроизводство.Продукция КАК Продукция
	|ГДЕ
	|	Продукция.КлючСвязи = &КлючСвязиПродукция
	|	И Продукция.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("КлючСвязиПродукция", КлючСвязиПродукция);
	Запрос.УстановитьПараметр("Ссылка", ЗаказНаПроизводство);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Реквизиты);
	
	ЗаказНаПроизводствоСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='№ %1 от %2';uk='№ %1 від %2'"),
		ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Реквизиты.Номер, Ложь, Истина),
		Формат(Реквизиты.Дата, "ДЛФ=D"));
	
	ПолучитьДанныеОХодеВыполненияЭтапов();
	
	ПланированиеПроизводства.ПостроитьСтруктуруЭтапов(ТаблицаЭтапов);
	
	// Установка заголовка для надписи описания брака.
	
	СтруктураОтбора = Новый Структура("КлючСвязи", КлючСвязиЭтапы);
	ТекущийЭтап = ТаблицаЭтапов.НайтиСтроки(СтруктураОтбора)[0];
	
	ШаблонЗаголовка = НСтр("ru='Описание брака (%1 %2)';uk='Опис браку (%1 %2)'");
	
	Элементы.ГруппаЛево.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонЗаголовка,
		ТекущийЭтап.НомерЭтапаФорма,
		ТекущийЭтап.НаименованиеЭтапа);
	
	ВыделитьЦепочкуВосстановления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаказНаПроизводствоНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Ключ,АктивироватьСтрокуПродукции",
		ЗаказНаПроизводство, КодСтрокиПродукция);
	
	ОткрытьФорму("Документ.ЗаказНаПроизводство.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить(Команда)
	
	ОтметитьСтроки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить(Команда)
	
	ОтметитьСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЭтапов.ВыделенныеСтроки;
	ОтметитьСтроки(Истина, МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЭтапов.ВыделенныеСтроки;
	ОтметитьСтроки(Ложь, МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Режим = "Запись";
	Отказ = Ложь;
	ЗавершитьРедактированиеНаСервере(Режим, , Отказ);
	
	Если Не Отказ Тогда
		Оповестить("Запись_ЗаказНаПроизводство", ЗаказНаПроизводство);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВСпецификацииЗаказа(Команда)
	
	Перем ПараметрыФормы;
	
	Режим = "ПереносВСпецификациюЗаказа";
	ЗавершитьРедактированиеНаСервере(Режим, ПараметрыФормы);
	ПараметрыФормы.Вставить("Модифицированность", Истина);
	ПараметрыФормы.Вставить("ЗаписыватьРезультатРедактирования", Истина);
	ОткрытьФорму("Обработка.РедактированиеСпецификацииСтрокиЗаказа.Форма", ПараметрыФормы, Этаформа.ВладелецФормы);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповВыбран.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповНомерЭтапаФорма.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповНомерСледующегоЭтапаФорма.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповНаименованиеЭтапа.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповПодразделение.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповИзменениеКоличестваЭтапов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.ЭтапВыполнен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСтроки(Значение, МассивСтрок = Неопределено)
	
	Если МассивСтрок = Неопределено Тогда
		
		Для Каждого СтрокаТаблицы Из ТаблицаЭтапов Цикл
			СтрокаТаблицы.Выбран = Значение;
		КонецЦикла;
		
	Иначе
		
		Для Каждого НомерСтроки Из МассивСтрок Цикл
			СтрокаТаблицы = ТаблицаЭтапов.НайтиПоИдентификатору(НомерСтроки);
			Если СтрокаТаблицы <> Неопределено Тогда
				СтрокаТаблицы.Выбран = Значение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеОХодеВыполненияЭтапов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказНаПроизводствоЭтапыГрафик.КлючСвязиЭтапы КАК КлючСвязиЭтапы,
	|	ЗаказНаПроизводствоЭтапыГрафик.КодСтроки КАК КодСтроки
	|ПОМЕСТИТЬ График
	|ИЗ
	|	Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК ЗаказНаПроизводствоЭтапыГрафик
	|ГДЕ
	|	ЗаказНаПроизводствоЭтапыГрафик.Ссылка = &Распоряжение
	|	И ЗаказНаПроизводствоЭтапыГрафик.КлючСвязиПродукция = &КлючСвязиПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	График.КлючСвязиЭтапы КАК КлючСвязиЭтапы,
	|	СУММА(БракВПроизводствеОстаткиИОбороты.КоличествоКонечныйОстаток) КАК Брак
	|ПОМЕСТИТЬ ВТИспорченныеЭтапы
	|ИЗ
	|	График КАК График
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.БракВПроизводстве.ОстаткиИОбороты(, , , , МаршрутныйЛист.Распоряжение = &Распоряжение) КАК БракВПроизводствеОстаткиИОбороты
	|		ПО (БракВПроизводствеОстаткиИОбороты.МаршрутныйЛист.КодСтрокиЭтапыГрафик = График.КодСтроки)
	|ГДЕ
	|	БракВПроизводствеОстаткиИОбороты.КоличествоКонечныйОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	График.КлючСвязиЭтапы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНаПроизводствоЭтапы.Этап КАК Этап,
	|	ЗаказНаПроизводствоЭтапы.НомерЭтапа КАК НомерЭтапа,
	|	ЗаказНаПроизводствоЭтапы.НомерСледующегоЭтапа КАК НомерСледующегоЭтапа,
	|	ЗаказНаПроизводствоЭтапы.Подразделение КАК Подразделение,
	|	ЗаказНаПроизводствоЭтапы.Количество КАК Количество,
	|	ЗаказНаПроизводствоЭтапы.КлючСвязи КАК КлючСвязи,
	|	ЗаказНаПроизводствоЭтапы.КлючСвязиПродукция КАК КлючСвязиПродукция,
	|	ЗаказНаПроизводствоЭтапы.КлючСвязиЭтапы КАК КлючСвязиЭтапы,
	|	ЗаказНаПроизводствоЭтапы.КлючСвязиПолуфабрикат КАК КлючСвязиПолуфабрикат,
	|	ЗаказНаПроизводствоЭтапы.КоличествоЭтаповНаЕдиницуСледующегоЭтапа КАК КоличествоЭтаповНаЕдиницуСледующегоЭтапа,
	|	ЗаказНаПроизводствоЭтапы.НаименованиеЭтапа КАК НаименованиеЭтапа,
	|	ЗаказНаПроизводствоЭтапы.ЭтапВосстановленияБрака КАК ЭтапВосстановленияБрака,
	|	ЗаказНаПроизводствоЭтапы.КлючСвязиЭтапыБрак КАК КлючСвязиЭтапыБрак,
	|	ВТИспорченныеЭтапы.Брак КАК Брак
	|ИЗ
	|	Документ.ЗаказНаПроизводство.Этапы КАК ЗаказНаПроизводствоЭтапы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИспорченныеЭтапы КАК ВТИспорченныеЭтапы
	|		ПО ЗаказНаПроизводствоЭтапы.КлючСвязи = ВТИспорченныеЭтапы.КлючСвязиЭтапы
	|ГДЕ
	|	ЗаказНаПроизводствоЭтапы.Ссылка = &Распоряжение
	|	И ЗаказНаПроизводствоЭтапы.КлючСвязиПродукция = &КлючСвязиПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БракВПроизводствеОстатки.МаршрутныйЛист КАК МаршрутныйЛист,
	|	БракВПроизводствеОстатки.КоличествоОстаток КАК Количество,
	|	&КлючСвязиЭтапы КАК КлючСвязиЭтапыБрак,
	|	&КлючСвязиПродукция КАК КлючСвязиПродукция,
	|	БракВПроизводствеОстатки.МаршрутныйЛист.Номер КАК Номер,
	|	БракВПроизводствеОстатки.МаршрутныйЛист.ОписаниеБрака КАК ОписаниеБрака
	|ИЗ
	|	РегистрНакопления.БракВПроизводстве.Остатки(, МаршрутныйЛист.Распоряжение = &Распоряжение) КАК БракВПроизводствеОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ График КАК График
	|		ПО БракВПроизводствеОстатки.МаршрутныйЛист.КодСтрокиЭтапыГрафик = График.КодСтроки
	|ГДЕ
	|	График.КлючСвязиЭтапы = &КлючСвязиЭтапы
	|	И БракВПроизводствеОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("КлючСвязиПродукция", КлючСвязиПродукция);
	Запрос.УстановитьПараметр("Распоряжение", ЗаказНаПроизводство);
	Запрос.УстановитьПараметр("КлючСвязиЭтапы", КлючСвязиЭтапы);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаЭтапов.Загрузить(МассивРезультатов[2].Выгрузить());
	
	ДанныеОБраке = МассивРезультатов[3].Выгрузить();
	
	ТаблицаУчетаБрака.Загрузить(ДанныеОБраке);
	
	// Формирование представления.
	
	ШаблонПредставленияБрака = НСтр("ru='МЛ №%1 брак %2 единиц/партий изделий (%3)';uk='МЛ №%1 брак %2 одиниць/партій виробів (%3)'");
	
	Для Каждого Строка Из ДанныеОБраке Цикл
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПредставленияБрака,
			ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Строка.Номер),
			Строка.Количество,
			Строка.ОписаниеБрака);
		
		Если ЗначениеЗаполнено(ОписаниеБракаПоТекущемуЭтапу) Тогда
			ОписаниеБракаПоТекущемуЭтапу = ОписаниеБракаПоТекущемуЭтапу + "; " + Представление;
		Иначе
			ОписаниеБракаПоТекущемуЭтапу = Представление;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьЦепочкуВосстановления()
	
	МассивСтрокЦепочки = Новый Массив;
	МассивУдаляемыхСтрок = Новый Массив;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("КлючСвязи", КлючСвязиЭтапы);
	
	ТекущийЭтап = ТаблицаЭтапов.НайтиСтроки(СтруктураОтбора)[0];
	
	ТекущийЭтап.ИзменениеКоличестваЭтапов = ТекущийЭтап.Брак;
	
	МассивСтрокЦепочки.Добавить(ТекущийЭтап);
	
	ДобавитьСвязанныеЭтапы(МассивСтрокЦепочки, ТекущийЭтап.НомерЭтапаФорма, ТекущийЭтап.Брак);
	
	Для Каждого Строка Из ТаблицаЭтапов Цикл
		
		Если МассивСтрокЦепочки.Найти(Строка) = Неопределено Тогда
			МассивУдаляемыхСтрок.Добавить(Строка);
		Иначе
			Строка.Выбран = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Строка из МассивУдаляемыхСтрок Цикл
		ТаблицаЭтапов.Удалить(Строка);
	КонецЦикла;
	
	ТаблицаЭтапов.Сортировать("НомерЭтапаФорма, НомерСледующегоЭтапаФорма, НаименованиеЭтапа, ЭтапВыполнен");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвязанныеЭтапы(МассивСтрокЦепочки, НомерЭтапаФорма, Брак)
	
	СтруктураОтбора = Новый Структура("НомерСледующегоЭтапаФорма", НомерЭтапаФорма);
	
	НайденныеСтроки = ТаблицаЭтапов.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого Строка Из НайденныеСтроки Цикл
		
		Если МассивСтрокЦепочки.Найти(Строка) <> Неопределено Тогда
			Продолжить;
		Иначе
			Строка.ИзменениеКоличестваЭтапов = Брак * Строка.КоличествоЭтаповНаЕдиницуСледующегоЭтапа;
			МассивСтрокЦепочки.Добавить(Строка);
			
			ДобавитьСвязанныеЭтапы(МассивСтрокЦепочки, Строка.НомерЭтапаФорма, Брак);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ЗавершениеРедактирования

&НаСервере
Процедура ЗавершитьРедактированиеНаСервере(Режим, ПараметрыФормы = Неопределено, Отказ = Ложь)
	
	СтруктураОтбора = Новый Структура("Выбран", Истина);
	
	Этапы = ТаблицаЭтапов.Выгрузить(СтруктураОтбора, "КлючСвязи, КлючСвязиПолуфабрикат, ИзменениеКоличестваЭтапов");
	
	Если Этапы.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаказОбъект = ЗаказНаПроизводство.ПолучитьОбъект();
	
	ЗаказОбъект.ДобавитьЭтапыВосстановления(КлючСвязиПродукция, Этапы, ТаблицаУчетаБрака, КлючСвязиЭтапы);
	ЗаказОбъект.СтатусГрафикаПроизводства = Перечисления.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать;
	ДанныеПродукции = ЗаказОбъект.Продукция.Найти(КлючСвязиПродукция, "КлючСвязи");
	ДанныеПродукции.ГрафикРассчитан = Ложь;
	
	Если Режим = "Запись" Тогда
		ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресСпецификация", ДанныеСпецификацииВХранилище(ЗаказОбъект, КлючСвязиПродукция));
		ПараметрыФормы.Вставить("АдресТоварыДляОбеспечения", ТоварыДляОбеспеченияВХранилище(ЗаказОбъект, КлючСвязиПродукция));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеСпецификацииВХранилище(Заказ, КлючСвязи)
	
	Возврат ПланированиеПроизводства.ДанныеСпецификацииЗаказаВХранилилище(Заказ, КлючСвязи, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ТоварыДляОбеспеченияВХранилище(Заказ, КлючСвязи)
	
	Возврат Документы.ЗаказНаПроизводство.ТоварыДляОбеспечения(Заказ, КлючСвязи);
	
КонецФункции

#КонецОбласти

#КонецОбласти
