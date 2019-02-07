﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаСтр = Строка(ВалютаУправленческогоУчета);
	КоэффициентПересчетаИзВалютыУпрВРегл = КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, Объект.Дата);
	
	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокЦена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='Цена';uk='Ціна'"), ВалютаСтр);
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='Сумма';uk='Сума'"), ВалютаСтр);
	ЗаголовокНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru='НДС';uk='ПДВ'"), ВалютаСтр);
	Элементы.ОптовыеПродажиЦена.Заголовок = ЗаголовокЦена;
	Элементы.ОптовыеПродажиСумма.Заголовок = ЗаголовокСумма;
	Элементы.ОптовыеПродажиСуммаНДС.Заголовок = ЗаголовокНДС;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	УстановитьЗаголовок();
	УстановитьПараметрыВыбораПартнера();
	ИмяТекущейТаблицыФормы = Элементы.ОптовыеПродажи.Имя;
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ОптовыеПродажи,ПараметрыЗаполненияРеквизитов);
	УстановитьУсловноеОформление();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);

	УстановитьНалогообложениеНДСПоУмолчанию(Истина);
 
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ОптовыеПродажи, ПараметрыЗаполненияРеквизитов);
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма" Тогда
		ПолучитьЗагруженныеТоварыИзХранилища(ВыбранноеЗначение.АдресТоваровВХранилище, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеСКлиентомНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПродажиКлиент.НачалоВыбораСоглашенияСКлиентом(
		Элемент,
		СтандартнаяОбработка,
		Объект.Партнер,
		Объект.СоглашениеСКлиентом,
		Объект.Дата,
		,
		,
		,
		Объект);
	
	КонецПроцедуры

&НаКлиенте
Процедура СоглашениеСКлиентомПриИзменении(Элемент)
	СоглашениеСКлиентомПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОптовыеПродажи

&НаКлиенте
Процедура ОптовыеПродажиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, ИмяТекущейТаблицыФормы)); 
		
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.СтавкаНДС) Тогда
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);
	КонецЕсли;
	УпаковкаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОптовыеПродажиУпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОптовыеПродажиКоличествоПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ОптовыеПродажиЦенаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ОптовыеПродажиСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОптовыеПродажи.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОптовыеПродажиСуммаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме", "Количество");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Документ.ВводОстатков.ФормаОптовыеПродажи.Команда.ОткрытьПодбор");
	
	Отказ = Ложь;

	ПараметрЗаголовок = НСтр("ru='Подбор товаров в %Документ%';uk='Підбір товарів у %Документ%'");
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Объект.Ссылка);
	Иначе
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='ввод остатков';uk='введення залишків'"));
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Соглашение",		Объект.СоглашениеСКлиентом);
	ПараметрыФормы.Вставить("Валюта",			Объект.Валюта);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС",	Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Ложь);
	ПараметрыФормы.Вставить("РежимПодбораИспользоватьСкладыВТабличнойЧасти", Ложь);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки", Истина);
	ПараметрыФормы.Вставить("ИспользоватьДатыОтгрузки", Ложь);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры", Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах", Истина);
	ПараметрыФормы.Вставить("ПоказыватьПодобранныеТовары", Истина);
	ПараметрыФормы.Вставить("ЗапрашиватьКоличество", Истина);
	ПараметрыФормы.Вставить("Заголовок", ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",  Объект.Ссылка);
	ПараметрыФормы.Вставить("БезОтбораПоВключениюНДСВЦену", Истина);

	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗагружатьЦены", Истина);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("НалоговоеНазначение", Объект.НалоговоеНазначение);
	
	ОткрытьФорму(
		"Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ОптовыеПродажиХарактеристика",
																			 "Объект.ОптовыеПродажи.ХарактеристикиИспользуются");
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "ОптовыеПродажиНоменклатураЕдиницаИзмерения",
																   "Объект.ОптовыеПродажи.Упаковка");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Контрагент.Имя);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОптовыеПродажиУпаковка.Имя);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОперацийВводаОстатков.ОптовыеПродажиЗаПрошлыеПериоды;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	Ценообразование.УстановитьУсловноеОформлениеСуммНДС(ЭтаФорма,
	                                                    "ОптовыеПродажиСтавкаНДС",
														"ОптовыеПродажиСуммаНДС",
														"ОптовыеПродажиНДСРегл");
 	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Форма)

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);

	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", Форма.КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", Форма.КоэффициентПересчетаИзВалютыУпрВРегл);

КонецПроцедуры

&НаСервере
Процедура ПолучитьЗагруженныеТоварыИзХранилища(АдресТоваровВХранилище, КэшированныеЗначения)
	
	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);

	Для Каждого СтрокаТоваров Из ТоварыИзХранилища Цикл
		СтрокаТЧТовары = Объект.ОптовыеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, СтрокаТоваров);
		СтрокаТЧТовары.СуммаНДС = 0;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧТовары, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		ТекущаяСтрока = Объект.ОптовыеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, Упаковка, КоличествоУпаковок, Цена");
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ОптовыеПродажи,ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, ДатаДокумента)
	
	Возврат РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
											ВалютаУправленческогоУчета,
											ВалютаРегламентированногоУчета,
											?(ДатаДокумента = Дата(1,1,1), ТекущаяДатаСеанса(), ДатаДокумента));
	
КонецФункции

&НаКлиенте
Процедура УпаковкаПриИзменении()

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", ТекущаяСтрока.Количество);
	КонецЕсли;

	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СтавкаНДСНоменклатуры(Номенклатура)

	Возврат Справочники.Номенклатура.ЗначенияРеквизитовНоменклатуры(Номенклатура).СтавкаНДС;

КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()


	УстановитьНалогообложениеНДСПоУмолчанию();
 	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораПартнера()
	
	МассивНастроек = Новый Массив;
	МассивНастроек.Добавить(Истина);
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.Клиент",Новый ФиксированныйМассив(МассивНастроек));
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ПараметрВыбора);
	Элементы.Партнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура СоглашениеСКлиентомПриИзмененииНаСервере()
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(Объект.НаправлениеДеятельности, Объект.СоглашениеСКлиентом, Объект.Договор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьНалогообложениеНДСПоУмолчанию(ПриОткрытииФормы = Ложь)
	
	НалогообложениеНДСПоУмолчаниюИзменено = Ложь;
	ДоступностьНалогообложенияНДСПоУмолчанию = Истина;
	ЗаполнитьСтавкиНДС = Ложь;
	
	НовоеНалогообложениеНДСПоУмолчанию       = НДСОбщегоНазначенияСервер.ПолучитьНалогообложениеНДСПоУмолчанию(Объект.Организация, Объект.Контрагент, Объект.СоглашениеСКлиентом, Объект.Дата, Истина, Неопределено);
	ДоступностьНалогообложенияНДСПоУмолчанию = НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Объект.Организация, Объект.Дата);
	Если НалогообложениеНДСПоУмолчанию <> НовоеНалогообложениеНДСПоУмолчанию Тогда
		ЗаполнитьСтавкиНДС = НДСОбщегоНазначенияСервер.НужноОбработатьНовоеНалогообложениеНДС(НалогообложениеНДСПоУмолчанию, НовоеНалогообложениеНДСПоУмолчанию);
		НалогообложениеНДСПоУмолчанию = НовоеНалогообложениеНДСПоУмолчанию;
		НалогообложениеНДСПоУмолчаниюИзменено = Истина;
	КонецЕсли;
	
	Если НалогообложениеНДСПоУмолчаниюИзменено И ЗаполнитьСтавкиНДС И НЕ ПриОткрытииФормы Тогда
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(Объект);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", НалогообложениеНДСПоУмолчанию);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
		СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
		СтруктураДействий.Вставить("ПересчитатьНДСРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.ОптовыеПродажи, СтруктураДействий, Неопределено);
	
	КонецЕсли; 
	
КонецПроцедуры // УстановитьНалогообложениеНДСПоУмолчанию

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	УстановитьНалогообложениеНДСПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	УстановитьНалогообложениеНДСПоУмолчанию();
КонецПроцедуры
 

#КонецОбласти
