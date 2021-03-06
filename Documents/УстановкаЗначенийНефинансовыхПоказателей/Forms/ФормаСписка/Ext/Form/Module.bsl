﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяПользователя = Строка(Пользователи.АвторизованныйПользователь());
	
	СохраненныеФлагиПоказателей.Загрузить(
		ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
			"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
			"ВыбранныеПоказатели", СохраненныеФлагиПоказателей.Выгрузить(Новый Массив),, ИмяПользователя)
			);
			
	СохраненныеФлагиШаблонов.Загрузить(
		ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
			"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
			"ВыбранныеШаблоны", СохраненныеФлагиШаблонов.Выгрузить(Новый Массив),, ИмяПользователя)
			);
			
	Элементы.ПанельОтбор.ТекущаяСтраница = Элементы[
		ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
			"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
			"ВариантФильтра", "ПоПоказателям",, ИмяПользователя)
			];
			
	ЗаполнитьПоказателиШаблоны(Ложь);
	
	Элементы.ДеревоПоказателейПоПоказателям.Пометка = Истина;
	Элементы.ДеревоШаблоновПоШаблонам.Пометка = Истина;
	
	УстановитьФильтрыСписка();
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_УстановкаЗначенийНФП" Тогда
		УстановитьФильтрыСписка();
		Элементы.Список.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоПоказателям(Команда)
	
	Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям;
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоШаблонам(Команда)
	
	Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоШаблонам;
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоказателейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПоказателей.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПараметрыОткрытия = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.НефинансовыеПоказателиБюджетов.Форма.ФормаЭлемента", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоШаблонов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПараметрыОткрытия = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаЭлемента", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоказателейФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПоказателей.ТекущиеДанные;
	Если Элементы.ДеревоПоказателей.ТекущиеДанные.ЭтоГруппа Тогда
		УстановитьФлагиСтрокРекурсивно(ТекущиеДанные, ТекущиеДанные.Флаг);
	КонецЕсли;
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоШаблоновФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоШаблонов.ТекущиеДанные;
	Если Элементы.ДеревоШаблонов.ТекущиеДанные.ЭтоГруппа Тогда
		УстановитьФлагиСтрокРекурсивно(ТекущиеДанные, ТекущиеДанные.Флаг);
	КонецЕсли;
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	УстановитьФильтрыСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		ТекущиеДанные = Элементы.ДеревоПоказателей.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ДеревоШаблонов.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Ссылка = ТекущиеДанные.Ссылка;
	
	ПараметрыУстановки = Новый Структура();
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ШаблоныВводаНефинансовыхПоказателей") Тогда
		ЗначенияЗаполнения = Новый Структура("ШаблонВвода, ВидОперации", Ссылка, 
			ПредопределенноеЗначение("Перечисление.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону"));
	Иначе
		ЗначенияЗаполнения = Новый Структура("ВидОперации",
				ПредопределенноеЗначение("Перечисление.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенияПоказателя"));
		Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Ссылка, "ЗагружатьИзДругихПодсистем, ПоСценариям");
		ВводНедоступен = Реквизиты.ЗагружатьИзДругихПодсистем И Не Реквизиты.ПоСценариям;
		Если Не ВводНедоступен Тогда
			ЗначенияЗаполнения.Вставить("НефинансовыйПоказатель", Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыУстановки.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.УстановкаЗначенийНефинансовыхПоказателей.Форма.ФормаДокумента", ПараметрыУстановки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьПоказателиШаблоны();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		СтрокиДерева = ДеревоПоказателей.ПолучитьЭлементы();
	Иначе
		СтрокиДерева = ДеревоШаблонов.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого СтрокаДерева из СтрокиДерева Цикл
		СтрокаДерева.Флаг = Истина;
		УстановитьФлагиСтрокРекурсивно(СтрокаДерева, Истина);
	КонецЦикла;
	
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		СтрокиДерева = ДеревоПоказателей.ПолучитьЭлементы();
	Иначе
		СтрокиДерева = ДеревоШаблонов.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого СтрокаДерева из СтрокиДерева Цикл
		СтрокаДерева.Флаг = Ложь;
		УстановитьФлагиСтрокРекурсивно(СтрокаДерева, Ложь);
	КонецЦикла;
	
	УстановитьФильтрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		СтрокиДерева = ДеревоПоказателей.ПолучитьЭлементы();
		ИмяЭлемента = "ДеревоПоказателей";
	Иначе
		СтрокиДерева = ДеревоШаблонов.ПолучитьЭлементы();
		ИмяЭлемента = "ДеревоШаблонов";
	КонецЕсли;
	
	Для Каждого СтрокаДерева из СтрокиДерева Цикл
		Элементы[ИмяЭлемента].Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		СтрокиДерева = ДеревоПоказателей.ПолучитьЭлементы();
		ИмяЭлемента = "ДеревоПоказателей";
	Иначе
		СтрокиДерева = ДеревоШаблонов.ПолучитьЭлементы();
		ИмяЭлемента = "ДеревоШаблонов";
	КонецЕсли;
	
	Для Каждого СтрокаДерева из СтрокиДерева Цикл
		Элементы[ИмяЭлемента].Свернуть(СтрокаДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройки()
	
	СохранитьФлаги();
	
	ИмяПользователя = Строка(Пользователи.АвторизованныйПользователь());
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
		"ВыбранныеПоказатели", СохраненныеФлагиПоказателей.Выгрузить(),, ИмяПользователя);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
		"ВыбранныеШаблоны", СохраненныеФлагиШаблонов.Выгрузить(),, ИмяПользователя);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"Документ.УстановкаЗначенийНефинансовыхПоказателей.ФормаСписка",
		"ВариантФильтра", Элементы.ПанельОтбор.ТекущаяСтраница.Имя,, ИмяПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагиСтрокРекурсивно(ТекущиеДанные, Флаг)
	
	ПодчиненныеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для Каждого СтрокаДерева из ПодчиненныеСтроки Цикл
		СтрокаДерева.Флаг = Флаг;
		УстановитьФлагиСтрокРекурсивно(СтрокаДерева, Флаг);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоказателиШаблоны(СохранятьФлаги = Истина)
	
	Если СохранятьФлаги Тогда
		СохранитьФлаги();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Список.Флаг,
		|	Список.Ссылка
		|ПОМЕСТИТЬ СохраненныеЗначения
		|ИЗ
		|	&Список КАК Список
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НефинансовыеПоказателиБюджетов.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СохраненныеЗначения.Ссылка ЕСТЬ NULL 
		|				ИЛИ СохраненныеЗначения.Флаг = ИСТИНА
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК Флаг,
		|	ВЫБОР
		|		КОГДА НефинансовыеПоказателиБюджетов.ЭтоГруппа
		|			ТОГДА 42
		|		ИНАЧЕ 50
		|	КОНЕЦ КАК ИндексКартинки,
		|	НефинансовыеПоказателиБюджетов.ЭтоГруппа
		|ИЗ
		|	Справочник.НефинансовыеПоказателиБюджетов КАК НефинансовыеПоказателиБюджетов
		|		ЛЕВОЕ СОЕДИНЕНИЕ СохраненныеЗначения КАК СохраненныеЗначения
		|		ПО (СохраненныеЗначения.Ссылка = НефинансовыеПоказателиБюджетов.Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос.УстановитьПараметр("Список", СохраненныеФлагиПоказателей.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	Дерево = РеквизитФормыВЗначение("ДеревоПоказателей");
	Дерево.Строки.Очистить();
	ФинансоваяОтчетностьСервер.РезультатЗапросаВДерево(РезультатЗапроса, Дерево);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоПоказателей");
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Список.Флаг,
		|	Список.Ссылка
		|ПОМЕСТИТЬ СохраненныеЗначения
		|ИЗ
		|	&Список КАК Список
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблоныВводаНефинансовыхПоказателей.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СохраненныеЗначения.Ссылка ЕСТЬ NULL 
		|				ИЛИ СохраненныеЗначения.Флаг = ИСТИНА
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК Флаг,
		|	ВЫБОР
		|		КОГДА ШаблоныВводаНефинансовыхПоказателей.ЭтоГруппа
		|			ТОГДА 42
		|		ИНАЧЕ 50
		|	КОНЕЦ КАК ИндексКартинки,
		|	ШаблоныВводаНефинансовыхПоказателей.ЭтоГруппа
		|ИЗ
		|	Справочник.ШаблоныВводаНефинансовыхПоказателей КАК ШаблоныВводаНефинансовыхПоказателей
		|		ЛЕВОЕ СОЕДИНЕНИЕ СохраненныеЗначения КАК СохраненныеЗначения
		|		ПО (СохраненныеЗначения.Ссылка = ШаблоныВводаНефинансовыхПоказателей.Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос.УстановитьПараметр("Список", СохраненныеФлагиШаблонов.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	Дерево = РеквизитФормыВЗначение("ДеревоШаблонов");
	Дерево.Строки.Очистить();
	ФинансоваяОтчетностьСервер.РезультатЗапросаВДерево(РезультатЗапроса, Дерево);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоШаблонов");
	
КонецПроцедуры

&НаСервере
Процедура ОтобратьПоказатели(Запрос, ЕстьОтбор)
	
	Если Элементы.ПанельОтбор.ТекущаяСтраница = Элементы.ПоПоказателям Тогда
		Дерево = РеквизитФормыВЗначение("ДеревоПоказателей");
		ПоПоказателям = Истина;
	Иначе
		Дерево = РеквизитФормыВЗначение("ДеревоШаблонов");
		ПоПоказателям = Ложь;
	КонецЕсли;
	
	НайденныеСтроки = Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа, Флаг", Ложь, Истина), Истина);
	
	Если НайденныеСтроки.Количество() = 
		Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь), Истина).Количество() Тогда
		Возврат;
	КонецЕсли;
	
	СписокОтбор = Новый СписокЗначений;
	Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
		СписокОтбор.Добавить(НайденнаяСтрока.Ссылка);
	КонецЦикла;
	
	ЕстьОтбор = Истина;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НефинансовыеПоказателиБюджетов.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ ОтобранныеПоказатели
	               |ИЗ
	               |	Справочник.НефинансовыеПоказателиБюджетов КАК НефинансовыеПоказателиБюджетов
	               |ГДЕ
	               |	(&ПоПоказателям
	               |				И НефинансовыеПоказателиБюджетов.Ссылка В (&Список)
	               |			ИЛИ НЕ &ПоПоказателям
	               |				И НефинансовыеПоказателиБюджетов.Ссылка В
	               |					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |						ПоказателейПоказателиШаблона.Показатель
	               |					ИЗ
	               |						Справочник.ШаблоныВводаНефинансовыхПоказателей.ПоказателиШаблона КАК ПоказателейПоказателиШаблона
	               |					ГДЕ
	               |						ПоказателейПоказателиШаблона.Ссылка В (&Список)))
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	УстановкаЗначенийНефинансовыхПоказателейЗначенияПоказателей.Ссылка
	               |ПОМЕСТИТЬ РегистраторыПоПоказателям
	               |ИЗ
	               |	Документ.УстановкаЗначенийНефинансовыхПоказателей.ЗначенияПоказателей КАК УстановкаЗначенийНефинансовыхПоказателейЗначенияПоказателей
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтобранныеПоказатели КАК ОтобранныеПоказатели
	               |		ПО УстановкаЗначенийНефинансовыхПоказателейЗначенияПоказателей.Показатель = ОтобранныеПоказатели.Ссылка
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	УстановкаЗначенийНефинансовыхПоказателейКолонкиДокумента.Ссылка
	               |ИЗ
	               |	Документ.УстановкаЗначенийНефинансовыхПоказателей.КолонкиДокумента КАК УстановкаЗначенийНефинансовыхПоказателейКолонкиДокумента
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтобранныеПоказатели КАК ОтобранныеПоказатели
	               |		ПО УстановкаЗначенийНефинансовыхПоказателейКолонкиДокумента.НефинансовыйПоказатель = ОтобранныеПоказатели.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РегистраторыПоПоказателям.Ссылка КАК Регистратор
	               |ПОМЕСТИТЬ ОтобранныеРегистраторы
	               |ИЗ
	               |	РегистраторыПоПоказателям КАК РегистраторыПоПоказателям
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Ссылка";
	
	Запрос.УстановитьПараметр("Список", СписокОтбор);
	Запрос.УстановитьПараметр("ПоПоказателям", ПоПоказателям);
	
	Запрос.Выполнить();
	
КонецПроцедуры

&НаСервере
Процедура ОтобратьДокументыПериода(Запрос, ЕстьОтбор)
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗначенияНефинансовыхПоказателейСрезПоследних.Регистратор
	|ПОМЕСТИТЬ ВсеРегистраторы
	|ИЗ
	|	РегистрСведений.ЗначенияНефинансовыхПоказателей.СрезПоследних(&НачалоПериода, ) КАК ЗначенияНефинансовыхПоказателейСрезПоследних
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗначенияНефинансовыхПоказателей.Регистратор
	|ИЗ
	|	РегистрСведений.ЗначенияНефинансовыхПоказателей КАК ЗначенияНефинансовыхПоказателей
	|ГДЕ
	|	ЗначенияНефинансовыхПоказателей.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|" + ?(ЕстьОтбор, "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаПоказателей.Регистратор
	|ПОМЕСТИТЬ РегистраторыПоПериоду
	|ИЗ
	|	ВсеРегистраторы КАК ТаблицаПоказателей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтобранныеРегистраторы КАК ОтобранныеРегистраторы
	|		ПО (ОтобранныеРегистраторы.Регистратор = ТаблицаПоказателей.Регистратор)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ОтобранныеРегистраторы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистраторыПоПериоду.Регистратор
	|ПОМЕСТИТЬ ОтобранныеРегистраторы
	|ИЗ
	|	РегистраторыПоПериоду КАК РегистраторыПоПериоду", "
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаПоказателей.Регистратор
	|ПОМЕСТИТЬ ОтобранныеРегистраторы
	|ИЗ
	|	ВсеРегистраторы КАК ТаблицаПоказателей
	|");
	
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", Период.ДатаОкончания);
	
	Запрос.Выполнить();
	
	ЕстьОтбор = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФильтрыСписка()
	
	ОтборыСписковКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ссылка");
	ОтборыСписковКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ответственный");
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ответственный", Ответственный);
	КонецЕсли;
	
	ЕстьОтбор = Ложь;
	
	Менеджер = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	
	ОтобратьПоказатели(Запрос, ЕстьОтбор);
	ОтобратьДокументыПериода(Запрос, ЕстьОтбор);
	
	Если Не ЕстьОтбор Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ Регистратор из ОтобранныеРегистраторы";
	
	Выборка = Запрос.Выполнить().Выбрать();
	СписокДокументов = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СписокДокументов.Добавить(Выборка.Регистратор);
	КонецЦикла;
	
	ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ссылка", СписокДокументов, ВидСравненияКомпоновкиДанных.ВСписке);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьФлаги()
	
	СохраненныеФлагиШаблонов.Очистить();
	Дерево = РеквизитФормыВЗначение("ДеревоШаблонов");
	НайденныеЭлементы = Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь), Истина);
	Для Каждого СтрокаЭлемента из НайденныеЭлементы Цикл
		НоваяСтрока = СохраненныеФлагиШаблонов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭлемента);
	КонецЦикла;
	
	СохраненныеФлагиПоказателей.Очистить();
	Дерево = РеквизитФормыВЗначение("ДеревоПоказателей");
	НайденныеЭлементы = Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь), Истина);
	Для Каждого СтрокаЭлемента из НайденныеЭлементы Цикл
		НоваяСтрока = СохраненныеФлагиПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭлемента);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

