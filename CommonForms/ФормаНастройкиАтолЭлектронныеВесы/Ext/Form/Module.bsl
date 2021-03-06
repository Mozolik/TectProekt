﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:';uk='Устаткування:'") + Символы.НПП  + Строка(Идентификатор);
	              
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	СписокМодель = Элементы.Модель.СписокВыбора;
	СписокМодель.Добавить("0",  НСтр("ru='ВР 4149';uk='ВР 4149'"));
	СписокМодель.Добавить("1",  НСтр("ru='ВР 4900';uk='ВР 4900'"));
	СписокМодель.Добавить("2",  НСтр("ru='Штрих ВТ, MP, АС';uk='Штрих ВТ, MP, АС'"));
	СписокМодель.Добавить("3",  НСтр("ru='Штрих АС';uk='Штрих АС'"));
	СписокМодель.Добавить("4",  НСтр("ru='CAS LP v.1.5';uk='CAS LP v.1.5'"));
	СписокМодель.Добавить("5",  НСтр("ru='Штрих АС POS';uk='Штрих АС POS'"));
	СписокМодель.Добавить("6",  НСтр("ru='Штрих АС мини POS';uk='Штрих АС міні POS'"));
	СписокМодель.Добавить("7",  НСтр("ru='CAS AP';uk='CAS AP'"));
	СписокМодель.Добавить("8",  НСтр("ru='CAS AD';uk='CAS AD'"));
	СписокМодель.Добавить("9",  НСтр("ru='CAS SC';uk='CAS SC'"));
	СписокМодель.Добавить("10", НСтр("ru='CAS S-2000';uk='CAS S-2000'"));
	СписокМодель.Добавить("11", НСтр("ru='Петвес серия Е';uk='Петвес серія Е'"));
	СписокМодель.Добавить("12", НСтр("ru='Тензо ТВ-003/05Д';uk='Тензо ТВ-003/05Д'"));
	СписокМодель.Добавить("13", НСтр("ru='Bolet MD-991';uk='Bolet MD-991'"));
	СписокМодель.Добавить("14", НСтр("ru='Масса-К серии ПВ';uk='Масса-К серии ПВ'"));
	СписокМодель.Добавить("15", НСтр("ru='Масса-К серий ВТ, ВТМ';uk='Масса-К серий ВТ, ВТМ'"));
	СписокМодель.Добавить("16", НСтр("ru='Масса-К серий MK-A, MK-T';uk='Масса-К серий MK-A, MK-T'"));
	СписокМодель.Добавить("17", НСтр("ru='Мера (Ока) до 30 кг';uk='Міра (Ока) до 30 кг'"));
	СписокМодель.Добавить("18", НСтр("ru='Мера (Ока) до 150 кг';uk='Міра (Ока) до 150 кг'"));
	СписокМодель.Добавить("19", НСтр("ru='ACOM PC100W';uk='ACOM PC100W'"));
	СписокМодель.Добавить("20", НСтр("ru='ACOM PC100';uk='ACOM PC100'"));
	СписокМодель.Добавить("21", НСтр("ru='ACOM SI-1';uk='ACOM SI-1'"));
	СписокМодель.Добавить("22", НСтр("ru='CAS ER';uk='CAS ER'"));
	СписокМодель.Добавить("23", НСтр("ru='CAS LP v.1.6';uk='CAS LP v.1.6'"));
	СписокМодель.Добавить("023", НСтр("ru='CAS LP v.2.0';uk='CAS LP v.2.0'"));
	СписокМодель.Добавить("24", НСтр("ru='Mettler Toledo 8217';uk='Mettler Toledo 8217'"));
	СписокМодель.Добавить("25", НСтр("ru='Штрих ВМ100';uk='Штрих ВМ100'"));
	СписокМодель.Добавить("26", НСтр("ru='Мера (9 байт) до 30 кг';uk='Міра (9 байт) до 30 кг'"));
	СписокМодель.Добавить("27", НСтр("ru='Мера (9 байт) до 150 кг';uk='Міра (9 байт) до 150 кг'"));

	// Добавлено       
	СписокМодель.Добавить("28", НСтр("ru='CAS BW';uk='CAS BW'"));
	СписокМодель.Добавить("29", НСтр("ru='Масса-К серий МК-ТВ, МК-ТН, ТВ-А';uk='Масса-К серий МК-ТВ, МК-ТН, ТВ-А'"));
	СписокМодель.Добавить("30", НСтр("ru='Mettler Toledo Tiger E';uk='Mettler Toledo Tiger E'"));
	СписокМодель.Добавить("31", НСтр("ru='DIGI DS-788';uk='DIGI DS-788'"));
	СписокМодель.Добавить("32", НСтр("ru='Меркурий 314/315';uk='Меркурій 314/315'"));
	СписокМодель.Добавить("33", НСтр("ru='CAS PDS';uk='CAS PDS'"));
	СписокМодель.Добавить("34", НСтр("ru='DIGI DS';uk='DIGI DS'"));
	
	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(3,  "1200");
	СписокСкорость.Добавить(4,  "2400");
	СписокСкорость.Добавить(5,  "4800");
	СписокСкорость.Добавить(7,  "9600");
	СписокСкорость.Добавить(9,  "14400");
	СписокСкорость.Добавить(10, "19200");
	
	СписокЧетность = Элементы.Четность.СписокВыбора;
	СписокЧетность.Добавить(0, НСтр("ru='Нет';uk='Ні'"));
	СписокЧетность.Добавить(1, НСтр("ru='Нечетность';uk='Непарність'"));
	СписокЧетность.Добавить(2, НСтр("ru='Четность';uk='Парність'"));
	
	времПорт            = Неопределено;
	времСкорость        = Неопределено;
	времЧетность        = Неопределено;
	времМодель          = Неопределено;
	времНаименование    = Неопределено;
	времДесятичнаяТочка = Неопределено;

	Параметры.ПараметрыОборудования.Свойство("Порт"           , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"       , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("Четность"       , времЧетность);
	Параметры.ПараметрыОборудования.Свойство("Модель"         , времМодель);
	Параметры.ПараметрыОборудования.Свойство("Наименование"   , времНаименование);
	Параметры.ПараметрыОборудования.Свойство("ДесятичнаяТочка", времДесятичнаяТочка);
	
	Порт            = ?(времПорт            = Неопределено, 1, времПорт);
	Скорость        = ?(времСкорость        = Неопределено, 7, времСкорость);
	Четность        = ?(времЧетность        = Неопределено, 0, времЧетность);
	Модель          = ?(времМодель          = Неопределено, Элементы.Модель.СписокВыбора[0].Значение, времМодель);
	ДесятичнаяТочка = ?(времДесятичнаяТочка = Неопределено, 0, времДесятичнаяТочка);
	Наименование    = ?(времНаименование    = Неопределено, Элементы.Модель.СписокВыбора[0].Представление, времНаименование);
	
	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МодельОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Наименование = Элементы.Модель.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"           , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"       , Скорость);
	НовыеЗначениеПараметров.Вставить("Четность"       , Четность);
	НовыеЗначениеПараметров.Вставить("Модель"         , Модель);
	НовыеЗначениеПараметров.Вставить("Наименование"   , Наименование);
	НовыеЗначениеПараметров.Вставить("ДесятичнаяТочка", ДесятичнаяТочка);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	Текст = НСтр("ru='Установка производиться средствами дистрибутива поставщика.
        |Перейти на сайт поставщика для скачивания?'
        |;uk='Встановлення проводитися засобами дистрибутиву постачальника.
        |Перейти на сайт постачальника для скачування?'");
	Оповещение = Новый ОписаниеОповещения("УстановкаДрайвераЗавершение",  ЭтотОбъект);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);
	времПараметрыУстройства.Вставить("ДесятичнаяТочка", ДесятичнаяТочка);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);
	  
	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив") И ВыходныеПараметры.Количество(),
	                           НСтр("ru='Дополнительное описание:';uk='Додатковий опис:'") + " " + ВыходныеПараметры[1], "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru='Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%';uk='Тест успішно виконано.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru='Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%';uk='Тест не пройдено.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);
	времПараметрыУстройства.Вставить("ДесятичнаяТочка", ДесятичнаяТочка);
	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена';uk='Не визначена'");
	КонецЕсли;
	
	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен';uk='Не встановлений'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена';uk='Не визначена'"), ЦветОшибки, ЦветТекста);
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен';uk='Встановлений'"));

КонецПроцедуры

#КонецОбласти