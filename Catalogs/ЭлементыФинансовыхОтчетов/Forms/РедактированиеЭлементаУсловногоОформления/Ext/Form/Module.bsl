﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипОформляемойОбласти = Параметры.ТипОформляемойОбласти;
	
	Если Параметры.Свойство("НастройкаЯчеек") Тогда
		ОформляемыеСтроки.Очистить();
		ОформляемыеКолонки.Очистить();
		Для Каждого Строка из Параметры.ОформляемыеСтроки Цикл
			НоваяСтрока = ОформляемыеСтроки.Добавить();
			НоваяСтрока.ЭлементОтчета = Строка;
		КонецЦикла;
		Для Каждого Колонка из Параметры.ОформляемыеКолонки Цикл
			НоваяСтрока = ОформляемыеКолонки.Добавить();
			НоваяСтрока.ЭлементОтчета = Колонка;
		КонецЦикла;
	Иначе
		ОформляемыеСтроки.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ОформляемыеСтроки));
		ОформляемыеКолонки.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ОформляемыеКолонки));
	КонецЕсли;
	
	Для Каждого Строка из ОформляемыеСтроки Цикл
		Если ЗначениеЗаполнено(Строка.ЭлементОтчета) Тогда
			Строка.НаименованиеДляПечати = ПолучитьИзВременногоХранилища(Строка.ЭлементОтчета).НаименованиеДляПечати;
		Иначе
			Строка.НаименованиеДляПечати = НСтр("ru='Заголовок таблицы';uk='Заголовок таблиці'");
		КонецЕсли;
	КонецЦикла;
	Для Каждого Колонка из ОформляемыеКолонки Цикл
		Если ЗначениеЗаполнено(Колонка.ЭлементОтчета) Тогда
			Колонка.НаименованиеДляПечати = ПолучитьИзВременногоХранилища(Колонка.ЭлементОтчета).НаименованиеДляПечати;
		Иначе
			Колонка.НаименованиеДляПечати = НСтр("ru='Заголовок таблицы';uk='Заголовок таблиці'");
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Свойство("КлючЭлементаОформления") Тогда
		КлючЭлементаОформления = Параметры.КлючЭлементаОформления;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючЭлементаОформления) Тогда
		КлючЭлементаОформления = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	СКД = ФинансоваяОтчетностьСервер.НоваяСхема();
	Набор = ФинансоваяОтчетностьСервер.НовыйНабор(СКД, Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	Для Каждого Поле ИЗ Параметры.ПоляОтбора Цикл
		СтруктураЭлемента = ПолучитьИзВременногоХранилища(Поле);
		Если Не (СтруктураЭлемента.ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.Измерение) Тогда
			Продолжить;
		КонецЕсли;
		ТипИзмерения = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ТипИзмерения");
		Если ТипИзмерения <> Перечисления.ТипыИзмеренийФинансовогоОтчета.Аналитика
			И ТипИзмерения <> Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
			Продолжить;
		КонецЕсли;
		Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
			ИмяИзмерения = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ИмяИзмерения");
			Если ИмяИзмерения = "Организация" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
			ИначеЕсли ИмяИзмерения = "Подразделение" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
			ИначеЕсли ИмяИзмерения = "Сценарий" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Сценарии");
			ИначеЕсли ИмяИзмерения = "Валюта" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Валюты");
			КонецЕсли;
		Иначе
			ВидАналитики = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ВидАналитики");
			ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидАналитики, "ТипЗначения");
			ИмяИзмерения = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(ВидАналитики);
		КонецЕсли;
		
		ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, ИмяИзмерения, ИмяИзмерения, СтруктураЭлемента.НаименованиеДляПечати, ТипЗначения);
		ПолеНабора.ОграничениеИспользованияРеквизитов.Условие = Истина;
		
	КонецЦикла;
	
	ЭлементыОтчета = ПолучитьИзВременногоХранилища(Параметры.АдресЭлементовОтчета);
	МассивПоказателей = Новый СписокЗначений;
	Если Не Параметры.ЭтоПростаяТаблица Тогда
		
		МассивПоказателей.Добавить("ЗначениеЯчейки", НСтр("ru='Значение ячейки';uk='Значення комірки'"));
		
	Иначе
		
		Таблица = ФинансоваяОтчетностьКлиентСервер.ТаблицаЭлемента(ЭлементыОтчета, Параметры.АдресЭлементаВХранилище);
		
		НайденныеСтроки = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель));
		Если НайденныеСтроки.Количество() Тогда
			МассивПоказателей.Добавить("Значение", НСтр("ru='Значение (НФП)';uk='Значення (НФП)'"));
		КонецЕсли;
		
		СтатьиБюджета = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов), Истина);
		НайденныеСтроки = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НайденныеСтроки, СтатьиБюджета);
		
		ЕстьСумма = Ложь;
		ЕстьКоличество = Ложь;
		Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
			ВидПоказателей = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(НайденнаяСтрока.АдресСтруктурыЭлемента, "ВыводимыеПоказатели");
			Если ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.Количество
				ИЛИ ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма Тогда
				ЕстьКоличество = Истина;
			КонецЕсли;
			Если ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.Сумма
				ИЛИ ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма Тогда
				ЕстьСумма = Истина;
			КонецЕсли;
			Если ЕстьКоличество И ЕстьСумма Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьКоличество Тогда
			МассивПоказателей.Добавить("Количество");
		КонецЕсли;
		
		Если ЕстьСумма Тогда
			МассивПоказателей.Добавить("Сумма");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЯчейкиНаПересеченииСтрокИКолонок Тогда
		
		Для Каждого Показатель из МассивПоказателей Цикл
		
			ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, Показатель.Значение, Показатель.Значение, 
										Показатель.Представление, ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15, 2));
		
		КонецЦикла;
		
	Иначе
		
		Для Каждого Поле из Параметры.ПоляОтбораЗначений Цикл
			
			Элемент = ПолучитьИзВременногоХранилища(Поле);
			ИмяЯчейки = СтрЗаменить(Элемент.НаименованиеДляПечати, ".", " ");
			
			Для Каждого Показатель из МассивПоказателей Цикл
			
				ИмяПоля = "Отбор_" + ИмяЯчейки + " " + Показатель.Значение;
				
				ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, ИмяПоля, ИмяПоля, 
									"[" + ИмяЯчейки + "] " + Показатель.Значение, ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15, 2));
				
				Если Не РасшифровкаПолейОтбораЭО.НайтиСтроки(
							Новый Структура("ЭлементОтчета, ИмяРесурса", Поле, Показатель)).Количество() Тогда
					НоваяСтрока = РасшифровкаПолейОтбораЭО.Добавить();
					НоваяСтрока.ЭлементОтчета = Поле;
					НоваяСтрока.ИмяПоляОтбора = ИмяПоля;
					НоваяСтрока.ИмяРесурса = Показатель.Значение;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	Условия.Инициализировать(ИсточникДоступныхНастроек);
	Если Параметры.Свойство("Условие") Тогда
		Условия.ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(Параметры.Условие));
	Иначе
		Условия.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	КонецЕсли;
	
	СоответствиеПараметров = Новый Соответствие;
	СоответствиеПараметров.Вставить(НСтр("ru='Цвет фона';uk='Колір фона'"), 				Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ЦветФона", ЦветаСтиля.ЦветФонаПоля, "Цвет", 1));
	СоответствиеПараметров.Вставить(НСтр("ru='Цвет текста';uk='Колір тексту'"),				Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ЦветТекста", ЦветаСтиля.ЦветТекстаПоля, "Цвет", 2));
	СоответствиеПараметров.Вставить(НСтр("ru='Цвет границы';uk='Колір межі'"), 			Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ЦветГраницы", ЦветаСтиля.ЦветЛинииОтчета, "Цвет", 3));
	СоответствиеПараметров.Вставить(НСтр("ru='Шрифт';uk='Шрифт'"), 					Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "Шрифт", ШрифтыСтиля.ШрифтТекста, "Шрифт", 4));
	СоответствиеПараметров.Вставить(НСтр("ru='Горизонтальное положение';uk='Горизонтальне положення'"), Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ГоризонтальноеПоложение", ГоризонтальноеПоложение.Авто, "ГоризонтальноеПоложение", 5));
	СоответствиеПараметров.Вставить(НСтр("ru='Вертикальное положение';uk='Вертикальне положення'"), 	Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ВертикальноеПоложение", ВертикальноеПоложение.Центр, "ВертикальноеПоложение", 6));
	СоответствиеПараметров.Вставить(НСтр("ru='Ориентация текста';uk='Орієнтація тексту'"), 		Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "ОриентацияТекста", 0, "ОриентацияТекста", 7));
	СоответствиеПараметров.Вставить(НСтр("ru='Формат';uk='Формат'"), 					Новый Структура("Имя, ПоУмолчанию, Тип, Порядок", "Формат", "", "Формат", 8));
	
	АдресСоответствияПараметров = ПоместитьВоВременноеХранилище(СоответствиеПараметров, УникальныйИдентификатор);
	
	ПредыдущееОформление = Неопределено;
	Если Параметры.Свойство("Оформление") Тогда
		ПредыдущееОформление = ПолучитьИзВременногоХранилища(Параметры.Оформление);
	КонецЕсли;
	
	Для Каждого КлючИЗначение из СоответствиеПараметров Цикл
		
		НоваяСтрока = Оформление.Добавить();
		НоваяСтрока.Параметр = КлючИЗначение.Ключ;
		НоваяСтрока.Порядок = КлючИЗначение.Значение.Порядок;
		Если ПредыдущееОформление <> Неопределено Тогда
			ЗначениеОформления = ПредыдущееОформление.Найти(КлючИЗначение.Ключ, "Параметр");
			Если ЗначениеОформления <> Неопределено Тогда
				НоваяСтрока.Использование = ЗначениеОформления.Использование;
				НоваяСтрока[КлючИЗначение.Значение.Тип] = ЗначениеОформления.Оформление;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока[КлючИЗначение.Значение.Тип] = КлючИЗначение.Значение.ПоУмолчанию;
		
	КонецЦикла;
	
	Оформление.Сортировать("Порядок");
	ЭтаФорма.КлючСохраненияПоложенияОкна = "ВариантОкна_" + ОбщегоНазначения.ИмяЗначенияПеречисления(ТипОформляемойОбласти);
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ДеревоОформленияФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Конструктор = Новый КонструкторФорматнойСтроки;
	Конструктор.Текст = Элементы.ДеревоОформления.ТекущиеДанные.Формат;
	Конструктор.ДоступныеТипы = Новый ОписаниеТипов("Число, Дата");
	ОписаниеОповещение = Новый ОписаниеОповещения("ПриВыбореФормата", ЭтаФорма);
	Конструктор.Показать(ОписаниеОповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияЦветПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияШрифтПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияФорматПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияГоризонтальноеПоложениеПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияВертикальноеПоложениеПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияОриентацияТекстаПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Закрыть(ПолучитьАдресРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриВыбореФормата(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДеревоОформления.ТекущиеДанные.Формат = Результат;
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагТекущейСтроки()
	
	ТекущиеДанные = Элементы.ДеревоОформления.ТекущиеДанные;
	ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ВидимостьСтрок = Истина;
	ВидимостьКолонок = Истина;
	МожноНакладыватьОтбор = Истина;
	
	Если ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяТаблица Тогда
		ВидимостьСтрок = Ложь;
		ВидимостьКолонок = Ложь;
		МожноНакладыватьОтбор = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяКолонка Тогда
		ВидимостьСтрок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяСтрока Тогда
		ВидимостьКолонок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЗаголовкиКолонок Тогда
		ВидимостьСтрок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЗаголовкиСтрок Тогда
		ВидимостьКолонок = Ложь;
	КонецЕсли;
	
	Элементы.ОформляемыеКолонки.Видимость 	= ВидимостьКолонок;
	Элементы.ОформляемыеСтроки.Видимость 	= ВидимостьСтрок;
	Элементы.СтраницаУсловие.Видимость 		= МожноНакладыватьОтбор;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресРезультата()
	
	РезультатОформления = Оформление.Выгрузить();
	НайденныеСтроки = РезультатОформления.НайтиСтроки(Новый Структура("Использование", Ложь));
	Для Каждого СтрокаТаблицы из НайденныеСтроки Цикл
		РезультатОформления.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	СоответствиеПараметров = ПолучитьИзВременногоХранилища(АдресСоответствияПараметров);
	ПриведенныйРезультат = РезультатОформления.СкопироватьКолонки("Использование, Параметр");
	ПриведенныйРезультат.Колонки.Добавить("Оформление");
	Для Каждого СтрокаРезультата из РезультатОформления Цикл
		НоваяСтрока = ПриведенныйРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		НоваяСтрока.Оформление = СтрокаРезультата[СоответствиеПараметров[СтрокаРезультата.Параметр].Тип];
	КонецЦикла;
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Оформление", ПриведенныйРезультат);
	СтруктураРезультат.Вставить("Условие", Условия.ПолучитьНастройки());
	СтруктураРезультат.Вставить("ТипОформляемойОбласти", ТипОформляемойОбласти);
	СтруктураРезультат.Вставить("КлючЭлементаОформления", КлючЭлементаОформления);
	СтруктураРезультат.Вставить("ОформляемыеСтроки", ОформляемыеСтроки.Выгрузить());
	СтруктураРезультат.Вставить("ОформляемыеКолонки", ОформляемыеКолонки.Выгрузить());
	СтруктураРезультат.Вставить("РасшифровкаПолейОтбораЭО", РасшифровкаПолейОтбораЭО.Выгрузить());
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураРезультат);
	
КонецФункции

#КонецОбласти

