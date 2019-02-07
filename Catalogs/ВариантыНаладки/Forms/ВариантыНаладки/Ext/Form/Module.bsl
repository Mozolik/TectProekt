﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидРабочегоЦентра = Параметры.ВидРабочегоЦентра;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВариантыНаладки, "Владелец", ВидРабочегоЦентра);
	
	ЕдиницаВремениПереналадки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРабочегоЦентра, "ЕдиницаВремениПереналадки");
	Если ЕдиницаВремениПереналадки = Перечисления.ЕдиницыИзмеренияВремени.Минута Тогда
		ЕдиницаВремениПереналадкиСтрокой = НСтр("ru='в минутах';uk='в хвилинах'");
	ИначеЕсли ЕдиницаВремениПереналадки = Перечисления.ЕдиницыИзмеренияВремени.Час Тогда
		ЕдиницаВремениПереналадкиСтрокой = НСтр("ru='в часах';uk='в годинах'");
	ИначеЕсли ЕдиницаВремениПереналадки = Перечисления.ЕдиницыИзмеренияВремени.Сутки Тогда
		ЕдиницаВремениПереналадкиСтрокой = НСтр("ru='в сутках';uk='у добах'");
	КонецЕсли; 
	
	ОбновитьТаблицуДлительностиПереналадкиНаСервере();
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ДлительностьПереналадки) Тогда
		Элементы.ДлительностьПереналадкиТаблица.ТолькоПросмотр = Истина;
	КонецЕсли; 

	УстановитьОформлениеЦветомВариантовНаладки();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" 
		ИЛИ ИмяСобытия = "Запись_ВидыРабочихЦентров" Тогда
		ОбновитьТаблицуДлительностиПереналадкиНаСервере();
	КонецЕсли; 
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" Тогда
		УстановитьОформлениеЦветомВариантовНаладки();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДлительностьПереналадкиТаблица

&НаКлиенте
Процедура ДлительностьПереналадкиТаблицаПриАктивизацииЯчейки(Элемент)
	
	ПояснениеПоНастройке = Новый ФорматированнаяСтрока("");
	ИндексНастройкиВладельца = -1;
	
	ТекущееПолеТаблицы = Элементы.ДлительностьПереналадкиТаблица.ТекущийЭлемент;
	Если ТекущееПолеТаблицы = Неопределено Тогда
		Возврат
	КонецЕсли; 
	
	Если СтрНайти(ТекущееПолеТаблицы.Имя, "ВариантНаладки") = 0 Тогда
		Возврат
	КонецЕсли; 
	
	ИндексПоля = ИндексПоляПоИмениЭлемента(ТекущееПолеТаблицы.Имя);
	
	ТекстВТаблицеВыделеноЦветом = Новый ФорматированнаяСтрока(НСтр("ru='темно-синим цветом';uk='темно-синім кольором'"), Новый Шрифт(,,Истина), WebЦвета.ТемноСиний);
	
	ТекущиеДанные = Элементы.ДлительностьПереналадкиТаблица.ТекущиеДанные;
	ПриоритетНастройки = ТекущиеДанные["ВариантНаладки" + ИндексПоля + "Приоритет"];
	Если НЕ ТекущиеДанные["ВариантНаладки" + ИндексПоля + "Доступно"] Тогда
		
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(НСтр("ru='Не допускается указывать длительность для одного и того же варианта наладки.';uk='Не допускається вказувати тривалість для одного і того ж варіанту наладки.'"));
		
	ИначеЕсли ТекущиеДанные["ВариантНаладки" + ИндексПоля + "Время"] = 0 Тогда
		
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(НСтр("ru='Длительность не указана.';uk='Тривалість не вказана.'"));
		
	ИначеЕсли ПриоритетНастройки = 1 Тогда
		
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(НСтр("ru='Длительность определяется по индвидуальной настройке.';uk='Тривалість визначається за індвідуальною настройкою.'"));
		
	ИначеЕсли ПриоритетНастройки = 2 Тогда
		
		ПояснениеПоНастройкеТекст = НСтр("ru='Длительность определяется по настройке с варианта наладки ""Любой вариант наладки"" на ""%1""';uk='Тривалість визначається по настройці з варіанту наладки ""Будь-який варіант наладки"" на ""%1""'");
		ПояснениеПоНастройкеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										ПояснениеПоНастройкеТекст, 
										ДлительностьПереналадкиТаблица[Число(ИндексПоля)].ПерваяКолонка);
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(ПояснениеПоНастройкеТекст, НСтр("ru=' (в таблице выделена ';uk=' (в таблиці виділена '"), ТекстВТаблицеВыделеноЦветом, ").");
		
	ИначеЕсли ПриоритетНастройки = 3 Тогда
		
		ПояснениеПоНастройкеТекст = НСтр("ru='Длительность определяется по настройке с варианта наладки ""%1"" на ""Любой вариант наладки""';uk='Тривалість визначається по настройці з варіанту наладки ""%1"" на ""Будь-який варіант наладки""'");
		ПояснениеПоНастройкеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										ПояснениеПоНастройкеТекст, 
										ТекущиеДанные.ПерваяКолонка);
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(ПояснениеПоНастройкеТекст, НСтр("ru=' (в таблице выделена ';uk=' (в таблиці виділена '"), ТекстВТаблицеВыделеноЦветом, ").");
		
	ИначеЕсли ПриоритетНастройки = 4 Тогда
		
		ПояснениеПоНастройкеТекст = НСтр("ru='Длительность определяется по настройке для вида рабочего центра в целом';uk='Тривалість визначається по настройці для виду робочого центру в цілому'");
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока(ПояснениеПоНастройкеТекст, НСтр("ru=' (в таблице выделена ';uk=' (в таблиці виділена '"), ТекстВТаблицеВыделеноЦветом, ").");
		
	Иначе	
		
		ПояснениеПоНастройке = Новый ФорматированнаяСтрока("");
		
	КонецЕсли; 
	
	ИндексНастройкиВладельца = ТекущиеДанные["ВариантНаладки" + ИндексПоля + "ИндексНастройкиВладельца"];
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьПереналадкиТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДлительностьПереналадкиТаблица.ТекущиеДанные;
	
	ТекущийВариантНаладки = ВариантыНаладкиВТаблице.Получить(ДлительностьПереналадкиТаблица.Индекс(ТекущиеДанные)).Значение;
	
	ДанныеСтроки = Новый Массив;
	
	НомерВариантаНаладки = 0;
	Для каждого ЭлСледующийВариантНаладки Из ВариантыНаладкиВТаблице Цикл
		ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерВариантаНаладки, "ЧН=0; ЧГ=");
		СледующийВариантНаладки = ВариантыНаладкиВТаблице.Получить(НомерВариантаНаладки).Значение;
		НомерВариантаНаладки = НомерВариантаНаладки + 1;
		
		Если ТекущийВариантНаладки = СледующийВариантНаладки И ЗначениеЗаполнено(ТекущийВариантНаладки) 
			ИЛИ ТекущиеДанные[ОбщееИмяРеквизита + "НастройкаУнаследована"] Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеПереналадки = Новый Структура;
		ДанныеПереналадки.Вставить("ТекущийВариантНаладки",   ТекущийВариантНаладки);
		ДанныеПереналадки.Вставить("СледующийВариантНаладки", СледующийВариантНаладки);
		ДанныеПереналадки.Вставить("ВремяПереналадки",        ТекущиеДанные[ОбщееИмяРеквизита + "Время"]);
		ДанныеСтроки.Добавить(ДанныеПереналадки);
		
	КонецЦикла; 
	
	ДлительностьПереналадкиМассив = ДлительностьПереналадкиТаблицаПриОкончанииРедактированияНаСервере(ДанныеСтроки, ВидРабочегоЦентра);
	
	ОбновитьДлительностьПереналадки(ДлительностьПереналадкиМассив);
	
	Оповестить("Запись_ДлительностьПереналадки");
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьПереналадкиТаблицаЛюбойВариантНаладкиВремяПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДлительностьПереналадкиТаблица.ТекущиеДанные;
	ИндексПоля = ИндексПоляПоИмениЭлемента(Элемент.Имя);
	
	Если ТекущиеДанные["ВариантНаладки" + ИндексПоля + "НастройкаУнаследована"]
		И ТекущиеДанные["ВариантНаладки" + ИндексПоля + "Время"] <> 0 Тогда
		ТекущиеДанные["ВариантНаладки" + ИндексПоля + "НастройкаУнаследована"] = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеТаблицыДлительностиПереналадки

&НаСервере
Процедура ОбновитьТаблицуДлительностиПереналадкиНаСервере()

	ИмяТаблицы = "ДлительностьПереналадкиТаблица";
	
	ДлительностьПереналадкиТаблица.Очистить();
	ВариантыНаладкиВТаблице.Очистить();
	ИндексНастройкиВладельца = -1;
	
	УдаляемыеРеквизиты = Новый Массив;
	Для Каждого УдаляемыйРеквизит Из ДобавленныеРеквизиты Цикл
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "Время");										
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "Доступно");										
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "НастройкаУнаследована");										
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "Приоритет");										
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "ИндексНастройкиВладельца");										
		УдаляемыеРеквизиты.Добавить("ДлительностьПереналадкиТаблица." + УдаляемыйРеквизит + "ИндексНастройки");										
	КонецЦикла;	
	
	УдалитьДобавленныеЭлементы();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВариантыНаладки.Ссылка КАК ВариантНаладки,
	|	ВариантыНаладки.Наименование КАК Наименование,
	|	2 КАК Очередь
	|ИЗ
	|	Справочник.ВариантыНаладки КАК ВариантыНаладки
	|ГДЕ
	|	ВариантыНаладки.Владелец = &ВидРабочегоЦентра
	|	И НЕ ВариантыНаладки.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка),
	|	&ЛюбойВариантНаладки,
	|	1
	|
	|УПОРЯДОЧИТЬ ПО
	|	Очередь,
	|	Наименование";
	
	Запрос.УстановитьПараметр("ВидРабочегоЦентра", ВидРабочегоЦентра);
	Запрос.УстановитьПараметр("ЛюбойВариантНаладки", НСтр("ru='Любой вариант наладки';uk='Будь-який варіант наладки'"));
	
	ТаблицаВариантыНаладки = Запрос.Выполнить().Выгрузить();
	
	ДобавитьРеквизитыВТаблицу(ТаблицаВариантыНаладки, УдаляемыеРеквизиты);
	ДобавитьРеквизитыНаФорму(ТаблицаВариантыНаладки);
	ЗаполнитьТаблицуПереналадки(ТаблицаВариантыНаладки);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДобавленныеЭлементы()

	ИмяТаблицы = "ДлительностьПереналадкиТаблица";
	
	Для каждого ОбщееИмяРеквизита Из ДобавленныеРеквизиты Цикл
		// Время
		ИмяЭлемента = ИмяТаблицы + ОбщееИмяРеквизита.Значение + "Время";
		Элементы.Удалить(Элементы[ИмяЭлемента]);
	КонецЦикла;
	
	ДобавленныеРеквизиты.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизитыВТаблицу(ТаблицаВариантыНаладки, УдаляемыеРеквизиты)

	ДобавляемыеРеквизиты = Новый Массив;
	
	НомерВариантаНаладки = 0;
	Для каждого Выборка Из ТаблицаВариантыНаладки Цикл
		ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерВариантаНаладки, "ЧН=0; ЧГ=");
		НомерВариантаНаладки = НомерВариантаНаладки + 1;
		
		Если Выборка.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка() Тогда
			// Реквизит для любого варианта наладки уже есть
			Продолжить;
		КонецЕсли;
		
		// Время
		ИмяРеквизита = ОбщееИмяРеквизита + "Время";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)), 
								"ДлительностьПереналадкиТаблица", 
								Выборка.Наименование);
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		// Доступно
		ИмяРеквизита = ОбщееИмяРеквизита + "Доступно";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Булево"), 
								"ДлительностьПереналадкиТаблица");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		// НастройкаУнаследована
		ИмяРеквизита = ОбщееИмяРеквизита + "НастройкаУнаследована";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Булево"), 
								"ДлительностьПереналадкиТаблица");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		// Приоритет
		ИмяРеквизита = ОбщееИмяРеквизита + "Приоритет";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный)), 
								"ДлительностьПереналадкиТаблица");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		// ИндексНастройкиВладельца
		ИмяРеквизита = ОбщееИмяРеквизита + "ИндексНастройкиВладельца";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Любой)), 
								"ДлительностьПереналадкиТаблица");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		// ИндексНастройки
		ИмяРеквизита = ОбщееИмяРеквизита + "ИндексНастройки";
		НовыйРеквизит = Новый РеквизитФормы(
								ИмяРеквизита, 
								Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)), 
								"ДлительностьПереналадкиТаблица");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
		ДобавленныеРеквизиты.Добавить(ОбщееИмяРеквизита);
	КонецЦикла;
	ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);

КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизитыНаФорму(ТаблицаВариантыНаладки)

	ИмяТаблицы = "ДлительностьПереналадкиТаблица";
	
	НомерВариантаНаладки = 0;
	Для каждого Выборка Из ТаблицаВариантыНаладки Цикл
		
		ВариантыНаладкиВТаблице.Добавить(Выборка.ВариантНаладки, Выборка.Наименование);
		
		ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерВариантаНаладки, "ЧН=0; ЧГ=");
		НомерВариантаНаладки = НомерВариантаНаладки + 1;
		
		ДобавитьУсловноеОформление(ОбщееИмяРеквизита);
		
		Если Выборка.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка() Тогда
			// Реквизит для любого варианта наладки уже есть
			Продолжить;
		КонецЕсли;
		
		// Время
		ИмяРеквизита = ОбщееИмяРеквизита + "Время";
		ЭлементВремя = Элементы.Добавить(ИмяТаблицы + ИмяРеквизита, Тип("ПолеФормы"), Элементы.ДлительностьПереналадкиТаблицаГруппаВариантовНаладки);
		ЭлементВремя.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементВремя.ПутьКДанным = ИмяТаблицы + "." + ИмяРеквизита;
		ЭлементВремя.Заголовок = Выборка.Наименование;
		ЭлементВремя.Ширина = 8;
		ЭлементВремя.КнопкаВыбора = Ложь;
		ЭлементВремя.КнопкаРегулирования = Истина;
		ЭлементВремя.УстановитьДействие("ПриИзменении", "ДлительностьПереналадкиТаблицаЛюбойВариантНаладкиВремяПриИзменении");
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПереналадки(ТаблицаВариантыНаладки)

	НастройкаПереналадки = РегистрыСведений.ДлительностьПереналадки.НастройкаПереналадки(ВидРабочегоЦентра);
	ТаблицаДлительностьПереналадки.Загрузить(НастройкаПереналадки);
	
	НомерТекущийВариантНаладки = 0;
	КоличествоВариантовНаладки = ВариантыНаладкиВТаблице.Количество();
	Для каждого ТекущийВариантНаладки Из ТаблицаВариантыНаладки Цикл
		НоваяСтрока = ДлительностьПереналадкиТаблица.Добавить();
		НоваяСтрока.ПерваяКолонка = ТекущийВариантНаладки.Наименование;
		
		НомерТекущийВариантНаладки = НомерТекущийВариантНаладки + 1;
		
		НомерСледующийВариантНаладки = 0;
		Для каждого СледующийВариантНаладки Из ТаблицаВариантыНаладки Цикл
			ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерСледующийВариантНаладки, "ЧН=0; ЧГ=");
			НомерСледующийВариантНаладки = НомерСледующийВариантНаладки + 1;
			
			Если ТекущийВариантНаладки.ВариантНаладки = СледующийВариантНаладки.ВариантНаладки
				И ЗначениеЗаполнено(ТекущийВариантНаладки.ВариантНаладки) Тогда
				НоваяСтрока[ОбщееИмяРеквизита + "Доступно"] = Ложь;
				НоваяСтрока[ОбщееИмяРеквизита + "ИндексНастройкиВладельца"] = -1;
				Продолжить;
			КонецЕсли; 
			
			СтруктураПоиска = Новый Структура("ТекущийВариантНаладки,СледующийВариантНаладки", 
								ТекущийВариантНаладки.ВариантНаладки, 
								СледующийВариантНаладки.ВариантНаладки);
								
	  		СписокСтрок = ТаблицаДлительностьПереналадки.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 Тогда
				ДанныеПереналадки = СписокСтрок[0];
				НоваяСтрока[ОбщееИмяРеквизита + "Время"]                 = ДанныеПереналадки.ВремяПереналадки;
				НоваяСтрока[ОбщееИмяРеквизита + "НастройкаУнаследована"] = ДанныеПереналадки.НастройкаУнаследована;
				НоваяСтрока[ОбщееИмяРеквизита + "Приоритет"]             = ДанныеПереналадки.Приоритет;
			КонецЕсли;
			НоваяСтрока[ОбщееИмяРеквизита + "Доступно"] = Истина;
			
			НоваяСтрока[ОбщееИмяРеквизита + "ИндексНастройкиВладельца"] = ИндексНастройкиВладельца(
																				НоваяСтрока[ОбщееИмяРеквизита + "Приоритет"], 
																				НомерТекущийВариантНаладки - 1, 
																				НомерСледующийВариантНаладки - 1,
																				КоличествоВариантовНаладки);
			
		КонецЦикла;
	КонецЦикла;

	// Заполним ИндексНастройки
	КоличествоВариантовНаладки = ВариантыНаладкиВТаблице.Количество();
	Для НомерТекущийВариантНаладки = 1 По КоличествоВариантовНаладки Цикл
		ТекущиеДанные = ДлительностьПереналадкиТаблица[НомерТекущийВариантНаладки - 1];
		ТекущиеДанные["ВариантНаладки0ИндексНастройки"] = НомерТекущийВариантНаладки;
	КонецЦикла; 
	ТекущиеДанные = ДлительностьПереналадкиТаблица[0];
	Для НомерСледующийВариантНаладки = 2 По КоличествоВариантовНаладки Цикл
		ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерСледующийВариантНаладки-1, "ЧН=0; ЧГ=");
		ТекущиеДанные[ОбщееИмяРеквизита + "ИндексНастройки"] = КоличествоВариантовНаладки + НомерСледующийВариантНаладки - 1;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьУсловноеОформление(ОбщееИмяРеквизита)
	
	// Доступно
	ЭлементУсловноеОформление = УсловноеОформление.Элементы.Добавить(); 
	ЭлементУсловноеОформление.Использование = Истина;
	
	ОтборОформления = ЭлементУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОформления.Использование  = Истина;
	ОтборОформления.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица." + ОбщееИмяРеквизита + "Доступно");
	ОтборОформления.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОформления.ПравоеЗначение = Ложь;
	
	ПолеОформление               = ЭлементУсловноеОформление.Поля.Элементы.Добавить(); 
	ПолеОформление.Использование = Истина;
	ПолеОформление.Поле          = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица" + ОбщееИмяРеквизита + "Время");
	
	НастройкаОформления = ЭлементУсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТолькоПросмотр")); 
	НастройкаОформления.Значение      = Истина; 
	НастройкаОформления.Использование = Истина;
	
	НастройкаОформления = ЭлементУсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЦветФона")); 
	НастройкаОформления.Значение      = ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет; 
	НастройкаОформления.Использование = Истина;

	// НастройкаУнаследована
	ЭлементУсловноеОформление = УсловноеОформление.Элементы.Добавить(); 
	ЭлементУсловноеОформление.Использование = Истина;
	
	ОтборОформления = ЭлементУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОформления.Использование  = Истина;
	ОтборОформления.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица." + ОбщееИмяРеквизита + "НастройкаУнаследована");
	ОтборОформления.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОформления.ПравоеЗначение = Истина;
	
	ОтборОформления = ЭлементУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОформления.Использование  = Истина;
	ОтборОформления.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица." + ОбщееИмяРеквизита + "ИндексНастройки");
	ОтборОформления.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборОформления.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ИндексНастройкиВладельца");
	
	ПолеОформление               = ЭлементУсловноеОформление.Поля.Элементы.Добавить(); 
	ПолеОформление.Использование = Истина;
	ПолеОформление.Поле          = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица" + ОбщееИмяРеквизита + "Время");
	
	НастройкаОформления = ЭлементУсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЦветТекста")); 
	НастройкаОформления.Значение      = ЦветаСтиля.ТекстИнформационнойНадписи; 
	НастройкаОформления.Использование = Истина;
	
	// Выделение цветом ячейки по которой определено время переналадки в активной ячейке
	ЭлементУсловноеОформление = УсловноеОформление.Элементы.Добавить(); 
	ЭлементУсловноеОформление.Использование = Истина;
	
	ОтборОформления = ЭлементУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОформления.Использование  = Истина;
	ОтборОформления.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица." + ОбщееИмяРеквизита + "ИндексНастройки");
	ОтборОформления.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОформления.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ИндексНастройкиВладельца");
	
	ПолеОформление               = ЭлементУсловноеОформление.Поля.Элементы.Добавить(); 
	ПолеОформление.Использование = Истина;
	ПолеОформление.Поле          = Новый ПолеКомпоновкиДанных("ДлительностьПереналадкиТаблица" + ОбщееИмяРеквизита + "Время");
	
	НастройкаОформления = ЭлементУсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЦветТекста")); 
	НастройкаОформления.Значение      = WebЦвета.ТемноСиний; 
	НастройкаОформления.Использование = Истина;
	
	НастройкаОформления = ЭлементУсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Шрифт")); 
	НастройкаОформления.Значение      = Новый Шрифт(,,Истина);
	НастройкаОформления.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДлительностьПереналадки(ДлительностьПереналадкиМассив)

	ТаблицаДлительностьПереналадки.Очистить();
	Для каждого ЭлементКоллекции Из ДлительностьПереналадкиМассив Цикл
		НоваяСтрока = ТаблицаДлительностьПереналадки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
	КонецЦикла; 
	
	НомерТекущийВариантНаладки = 0;
	КоличествоВариантовНаладки = ВариантыНаладкиВТаблице.Количество();
	Для каждого ТекущиеДанные Из ДлительностьПереналадкиТаблица Цикл
		
		ТекущийВариантНаладки = ВариантыНаладкиВТаблице.Получить(НомерТекущийВариантНаладки).Значение;
		
		НомерТекущийВариантНаладки = НомерТекущийВариантНаладки + 1;
		
		НомерСледующийВариантНаладки = 0;
		Для каждого ЭлСледующийВариантНаладки Из ВариантыНаладкиВТаблице Цикл
			ОбщееИмяРеквизита = "ВариантНаладки" + Формат(НомерСледующийВариантНаладки, "ЧН=0; ЧГ=");
			СледующийВариантНаладки = ВариантыНаладкиВТаблице.Получить(НомерСледующийВариантНаладки).Значение;
			
			НомерСледующийВариантНаладки = НомерСледующийВариантНаладки + 1;
			
			Если ТекущийВариантНаладки = СледующийВариантНаладки И ЗначениеЗаполнено(ТекущийВариантНаладки) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("ТекущийВариантНаладки,СледующийВариантНаладки", 
								ТекущийВариантНаладки, 
								СледующийВариантНаладки);
								
	  		СписокСтрок = ТаблицаДлительностьПереналадки.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 Тогда
				ДанныеПереналадки = СписокСтрок[0];
				ТекущиеДанные[ОбщееИмяРеквизита + "Время"]                 = ДанныеПереналадки.ВремяПереналадки;
				ТекущиеДанные[ОбщееИмяРеквизита + "НастройкаУнаследована"] = ДанныеПереналадки.НастройкаУнаследована;
				ТекущиеДанные[ОбщееИмяРеквизита + "Приоритет"]             = ДанныеПереналадки.Приоритет;
			КонецЕсли;
			
			ТекущиеДанные[ОбщееИмяРеквизита + "ИндексНастройкиВладельца"] = ИндексНастройкиВладельца(
																				ТекущиеДанные[ОбщееИмяРеквизита + "Приоритет"], 
																				НомерТекущийВариантНаладки - 1, 
																				НомерСледующийВариантНаладки - 1,
																				КоличествоВариантовНаладки);
			
		КонецЦикла; 
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьОформлениеЦветомВариантовНаладки()

	// Удалим старое оформление
	ЭлементыКУдалению = Новый Массив;
	Для каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = "ЦветОформления" Тогда
			ЭлементыКУдалению.Добавить(ЭлементОформления);
		КонецЕсли; 
	КонецЦикла; 
	Для каждого ЭлементОформления Из ЭлементыКУдалению Цикл
		УсловноеОформление.Элементы.Удалить(ЭлементОформления);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВариантыНаладки.ЦветОформления,
	|	ВариантыНаладки.Ссылка
	|ИЗ
	|	Справочник.ВариантыНаладки КАК ВариантыНаладки
	|ГДЕ
	|	(ВариантыНаладки.Владелец = &ВидРабочегоЦентра
	|			ИЛИ &ВидРабочегоЦентра = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("ВидРабочегоЦентра", ВидРабочегоЦентра);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЦветОформленияОбъекта = Выборка.ЦветОформления.Получить();
		Если ЦветОформленияОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЦветВариантаНаладки = ЦветОформленияОбъекта.ЦветОформления;
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		Элемент.Представление = "ЦветОформления";
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВариантыНаладки.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокВариантыНаладки.Ссылка");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Выборка.Ссылка;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветВариантаНаладки);
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДлительностьПереналадкиТаблицаПриОкончанииРедактированияНаСервере(Знач ДанныеСтроки, Знач ВидРабочегоЦентра)

	СохранитьДанныеСтрокиНаСервере(ДанныеСтроки, ВидРабочегоЦентра);
	
	// Вернем настройку переналадки, чтобы перезаполнить таблицу на клиенте
	ТаблицаДлительностьПереналадки = РегистрыСведений.ДлительностьПереналадки.НастройкаПереналадки(ВидРабочегоЦентра);
	ДлительностьПереналадкиМассив = Новый Массив;
	Для каждого ЭлементКоллекции Из ТаблицаДлительностьПереналадки Цикл
		ДанныеПереналадки = Новый Структура;
		ДанныеПереналадки.Вставить("ТекущийВариантНаладки",   ЭлементКоллекции.ТекущийВариантНаладки);
		ДанныеПереналадки.Вставить("СледующийВариантНаладки", ЭлементКоллекции.СледующийВариантНаладки);
		ДанныеПереналадки.Вставить("ВремяПереналадки",        ЭлементКоллекции.ВремяПереналадки);
		ДанныеПереналадки.Вставить("НастройкаУнаследована",   ЭлементКоллекции.НастройкаУнаследована);
		ДанныеПереналадки.Вставить("Приоритет",               ЭлементКоллекции.Приоритет);
		ДлительностьПереналадкиМассив.Добавить(ДанныеПереналадки);
	КонецЦикла;
	
	Возврат ДлительностьПереналадкиМассив;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеСтрокиНаСервере(Знач ДанныеСтроки, Знач ВидРабочегоЦентра)

	Для каждого ДанныеПереналадки Из ДанныеСтроки Цикл
		РегистрыСведений.ДлительностьПереналадки.УстановитьДлительностьПереналадки(
				ВидРабочегоЦентра,
				ДанныеПереналадки.ТекущийВариантНаладки, 
				ДанныеПереналадки.СледующийВариантНаладки, 
				ДанныеПереналадки.ВремяПереналадки);
	КонецЦикла; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИндексНастройкиВладельца(Приоритет, НомерТекущийВариантНаладки, НомерСледующийВариантНаладки, КоличествоВариантовНаладки)

	ИндексНастройкиВладельца = -1;
	Если Приоритет = 2 Тогда
		ИндексНастройкиВладельца = КоличествоВариантовНаладки + НомерСледующийВариантНаладки;
	ИначеЕсли Приоритет = 3 Тогда
		ИндексНастройкиВладельца = НомерТекущийВариантНаладки + 1;
	ИначеЕсли Приоритет = 4 Тогда
		ИндексНастройкиВладельца = 1;
	КонецЕсли; 
	
	Возврат ИндексНастройкиВладельца;

КонецФункции

&НаКлиенте
Функция ИндексПоляПоИмениЭлемента(ИмяЭлемента)

	НачалоИмени = СтрНайти(ИмяЭлемента, "ВариантНаладки") + СтрДлина("ВариантНаладки");
	ОкончаниеИмени = СтрНайти(ИмяЭлемента, "Время");
	ИндексПоля = Сред(ИмяЭлемента, НачалоИмени, ОкончаниеИмени - НачалоИмени);

	Возврат ИндексПоля;
	
КонецФункции

#КонецОбласти

#КонецОбласти
