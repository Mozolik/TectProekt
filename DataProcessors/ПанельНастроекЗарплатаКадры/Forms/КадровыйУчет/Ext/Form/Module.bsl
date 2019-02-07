﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Определяем показывать ли глобальную настройку по отключению и кадрами, и зарплатой.
	ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты = Ложь;
	ЗарплатаКадрыРасширенныйПереопределяемый.ОпределитьДоступностьУстановкиИспользованияЗарплатаКадры(ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты);
	Если ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты Тогда
		Элементы.ГруппаИспользоватьКадровыйУчетИРасчетЗарплаты.Видимость = Истина;
	КонецЕсли;
	
	ПрочитатьНастройки();
	ОбновитьОписаниеНастроекШтатногоРасписания(ЭтаФорма);
	// Установка доступности элементов формы в зависимости от текущих настроек.
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	УстановитьВидимостьЭлементовФормы(ЭтаФорма);
	УстановитьТекстПояснениеИспользоватьПереносОстатковОтпуска(ЭтотОбъект);
	
	Если ЗарплатаКадры.ЭтоБазоваяВерсияКонфигурации() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаИспользоватьПодработки",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаПереносОстатковОтпуска",
			"Видимость",
			Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаИспользоватьУчетСпецстажа",
			"Видимость",
			Ложь);
	
			
	КонецЕсли; 
	
	//ERP начало
	Элементы.НастройкиКадровогоУчета.Видимость = Ложь;
	//ERP конец
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ЭтаФорма.ТребуетсяОбновлениеИнтерфейса Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНастройкиШтатногоРасписания" Тогда
		ПрочитатьНастройкиШтатногоРасписания();
		ОбновитьОписаниеНастроекШтатногоРасписания(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьКадровыйУчетИРасчетЗарплатыПриИзменении(Элемент)
	
	ИспользоватьКадровыйУчет = ИспользоватьКадровыйУчетИРасчетЗарплаты;
	ИспользоватьНачислениеЗарплаты = ИспользоватьКадровыйУчетИРасчетЗарплаты;
	
	Если ИспользоватьКадровыйУчетИРасчетЗарплаты Тогда
		// Восстанавливаем ранее запомненное состояние настроек.
		ЗаполнитьЗначенияСвойств(НастройкиВоинскогоУчета, НастройкиВоинскогоУчетаПрежняя);
		ЗаполнитьЗначенияСвойств(НастройкиКадровогоУчета, НастройкиКадровогоУчетаПрежняя);
	Иначе
		// Сохраняем состояние
		ЗаполнитьЗначенияСвойств(НастройкиВоинскогоУчетаПрежняя, НастройкиВоинскогоУчета);
		ЗаполнитьЗначенияСвойств(НастройкиКадровогоУчетаПрежняя, НастройкиКадровогоУчета);
		// Сбрасываем настройки
		НастройкиВоинскогоУчета.ИспользоватьВоинскийУчет = Ложь;
		НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан = Ложь;
		НастройкиКадровогоУчета.ИспользоватьРаботуНаНеполнуюСтавку = Ложь;
		НастройкиКадровогоУчета.ИспользоватьПереносОстатковОтпускаПриУвольненииПереводом = Ложь;
		ИспользоватьАттестацииСотрудников = Ложь;
		
		// ERP начало: 00-00052344
		НастройкиШтатногоРасписания.ИспользоватьШтатноеРасписание = Ложь;
		// ERP конец
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
	// ERP начало
	Оповестить("ИспользоватьКадровыйУчетИРасчетЗарплаты", ИспользоватьКадровыйУчетИРасчетЗарплаты);
	// ERP конец
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета,НастройкиВоинскогоУчета,ИспользоватьКадровыйУчет,ИспользоватьНачислениеЗарплаты,ИспользоватьАттестацииСотрудников");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаКонтролироватьУникальностьТабельныхНомеровПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.КонтролироватьУникальностьТабельныхНомеров = НастройкиКадровогоУчета.КонтролироватьУникальностьТабельныхНомеров;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаПечататьТ6ДляОтпусковПоБеременностиИРодамПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.ПечататьТ6ДляОтпусковПоБеременностиИРодам = НастройкиКадровогоУчета.ПечататьТ6ДляОтпусковПоБеременностиИРодам;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаПравилоФормированияПредставленияЭлементовСправочникаСотрудникиПриИзменении(Элемент)
	
	ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники = Истина;
	НастройкиКадровогоУчетаПрежняя.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники = НастройкиКадровогоУчета.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРаботуНаНеполнуюСтавкуПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.ИспользоватьРаботуНаНеполнуюСтавку = НастройкиКадровогоУчета.ИспользоватьРаботуНаНеполнуюСтавку;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодработкиПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьПодработки");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетСпецстажаПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьУчетСпецстажа");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВоинскийУчетПриИзменении(Элемент)
	
	Если НастройкиВоинскогоУчета.ИспользоватьВоинскийУчет Тогда
		НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан;
	Иначе
		НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;
		НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Элементы, НастройкиВоинскогоУчета);
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
		
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБронированиеГражданПриИзменении(Элемент)
	
	
	Если НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан Тогда
	Иначе
	КонецЕсли;
	
	НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаШтатногоРасписания(Команда)
	ОткрытьФорму("Обработка.ПанельНастроекЗарплатаКадры.Форма.НастройкаШтатногоРасписания");
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАттестацииСотрудниковПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;

	ЗаписатьНастройкиНаКлиенте("ИспользоватьАттестацииСотрудников");
	УстановитьДоступностьЭлементовФормыАттестацииСотрудников(ЭтотОбъект);
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеДокументаФормированиеАттестационнойКомиссииПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСпециальностиФизическихЛицПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьСпециальностиФизическихЛиц");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчета(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ПолеСортировкиРазделов", 3); 
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	ПараметрыФормы.Вставить("КлючВарианта", "НастройкиПоРазделам");
	
	ОткрытьФорму("Отчет.НастройкиПрограммыЗарплатаКадры.Форма", ПараметрыФормы, ЭтотОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОписаниеНастроекШтатногоРасписания(Форма)

	Настройки = Форма.НастройкиШтатногоРасписания;
	ИспользоватьШтатноеРасписание = Настройки.ИспользоватьШтатноеРасписание;
	Если Не ИспользоватьШтатноеРасписание Тогда
		Описание = НСтр("ru='Возможность ведения штатного расписания отключена';uk='Можливість ведення штатного розкладу відключена'");
	Иначе
		
		РаботаВБюджетномУчреждении = Форма.РаботаВБюджетномУчреждении;
		ИспользоватьНачислениеЗарплаты = Форма.ИспользоватьНачислениеЗарплаты;
		ШтатноеРасписаниеВсегдаИспользуется = Форма.ШтатноеРасписаниеВсегдаИспользуется;
		
		Автопроверка = Настройки.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически;
		ИспользоватьИсторию = Настройки.ИспользоватьИсториюИзмененияШтатногоРасписания;
		ИспользоватьВилку = Настройки.ИспользоватьВилкуСтавокВШтатномРасписании;
		ИспользоватьРазрядыКатегории = Настройки.ИспользоватьПриОписанииПозицииШтатногоРасписанияРазрядыКатегорииКлассыДолжностейИПрофессий;
		ИспользоватьБронированиеПозиций = Настройки.ИспользоватьБронированиеПозиций;
		ТекстАвтопроверка = ?(Автопроверка, НСтр("ru='Выполняется';uk='Виконується'"), НСтр("ru='Не выполняется';uk='Не виконується'"));
		ТекстИспользоватьИсторию = ?(ИспользоватьИсторию, НСтр("ru='Ведется';uk='Ведеться'"), НСтр("ru='Не ведется';uk='Не ведеться'"));
		ТекстИспользоватьРазрядыКатегории = ?(РаботаВБюджетномУчреждении,"",?(ИспользоватьРазрядыКатегории, НСтр("ru='Используются';uk='Використовуються'"), НСтр("ru='Не используются';uk='Не використовуються'")));
		ТекстИспользоватьВилку = ?(ИспользоватьНачислениеЗарплаты,?(ИспользоватьВилку, НСтр("ru='Используется';uk='Використовується'"), НСтр("ru='Не используется';uk='Не використовується'")),"");
		ТекстПредставлениеТарифовИНадбавок = ?(ИспользоватьНачислениеЗарплаты, Настройки.ПредставлениеТарифовИНадбавок,"");
		ТекстИспользоватьБронирование = ?(ИспользоватьБронированиеПозиций, НСтр("ru='Используется';uk='Використовується'"), НСтр("ru='Не используется';uk='Не використовується'"));

		Описание = ?(ШтатноеРасписаниеВсегдаИспользуется, "", НСтр("ru='Ведется штатное расписание.';uk='Ведеться штатний розклад.'") + Символы.ПС);
		
		Описание = Описание + 
		НСтр("ru='%1 автоматическая проверка кадровых документов на соответствие штатному расписанию.
        |%2 история изменения штатного расписания.'
        |;uk='%1 автоматична перевірка кадрових документів на відповідність штатному розкладу.
        |%2 історія зміни штатного розкладу.'");
		
		Описание = ?(Не РаботаВБюджетномУчреждении, Описание + " 
		|" + НСтр("ru='%3 разряды и категории в позиции штатного расписания.';uk='%3 розряди і категорії в позиції штатного розкладу.'"), Описание);
		
		Описание = ?(ИспользоватьНачислениеЗарплаты, Описание + "
		|" + НСтр("ru='%4 ""вилка"" окладов и надбавок.';uk='%4 ""вилка"" окладів і надбавок.'"), Описание);
		
			
		Описание = ?(ИспользоватьНачислениеЗарплаты, Описание + "
		|" + НСтр("ru='Надбавки в печатной форме отображаются как: %5';uk='Надбавки в друкованій формі відображаються як: %5'"), Описание);
		
		
		Описание = ?(ИспользоватьБронированиеПозиций, Описание + " 
		|" + НСтр("ru='%6 бронирование позиций штатного расписания.';uk='%6 бронювання позицій штатного розкладу.'"), Описание);

		
		Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание,
			ТекстАвтопроверка,
			ТекстИспользоватьИсторию,
			ТекстИспользоватьРазрядыКатегории,
			ТекстИспользоватьВилку,
			ТекстПредставлениеТарифовИНадбавок,
			ТекстИспользоватьБронирование);
		
	КонецЕсли;
	
	Форма.ОписаниеНастроекШтатногоРасписания = Описание;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройки()
	
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	ШтатноеРасписаниеВсегдаИспользуется = ЗарплатаКадрыРасширенный.ШтатноеРасписаниеВсегдаИспользуется();
	
	ИспользоватьКадровыйУчетИРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") И ИспользоватьНачислениеЗарплаты;
	
	Настройки = РегистрыСведений.НастройкиКадровогоУчета.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	ЗначениеВРеквизитФормы(Настройки, "НастройкиКадровогоУчета");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиКадровогоУчетаПрежняя");
	
	Настройки = РегистрыСведений.НастройкиВоинскогоУчета.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	ЗначениеВРеквизитФормы(Настройки, "НастройкиВоинскогоУчета");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиВоинскогоУчетаПрежняя");
	
	ПрочитатьНастройкиШтатногоРасписания();
	
	ПрочитатьНастройкиАттестацииСотрудников();
	
	ИспользоватьСпециальностиФизическихЛиц = Константы.ИспользоватьСпециальностиФизическихЛиц.Получить();
	ИспользоватьПодработки = Константы.ИспользоватьПодработки.Получить();
	ИспользоватьУчетСпецстажа = Константы.ИспользоватьУчетСпецстажа.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиШтатногоРасписания()

	Настройки = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	ЗначениеВРеквизитФормы(Настройки, "НастройкиШтатногоРасписания");

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиАттестацииСотрудников()
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("АттестацииСотрудников");
	
	ИспользоватьАттестацииСотрудников = Модуль.ИспользуетсяАттестацияСотрудников();
	
	Если Модуль.ГрафикАттестацииИКомиссияУтверждаютсяОднимДокументом() Тогда
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 0;
	Иначе 
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 1	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиНаСервере(ИмяНастройки)
	
	ПараметрыНастроек = Обработки.ПанельНастроекЗарплатаКадры.ЗаполнитьСтруктуруПараметровНастроек(ИмяНастройки);
	ПараметрыНастроек.НастройкиКадровогоУчета = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиКадровогоУчета, Метаданные.РегистрыСведений.НастройкиКадровогоУчета);
	ПараметрыНастроек.НастройкиВоинскогоУчета = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиВоинскогоУчета, Метаданные.РегистрыСведений.НастройкиВоинскогоУчета);
	
	// ERP начало: 00-00052344
	ПараметрыНастроек.НастройкиШтатногоРасписания = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиШтатногоРасписания, Метаданные.РегистрыСведений.НастройкиШтатногоРасписания);
	// ERP конец
	
	ПараметрыНастроек.ИспользоватьКадровыйУчет = ИспользоватьКадровыйУчет;
	ПараметрыНастроек.ИспользоватьНачислениеЗарплаты = ИспользоватьНачислениеЗарплаты;
	ПараметрыНастроек.ИспользоватьАттестацииСотрудников = ИспользоватьАттестацииСотрудников;
	ПараметрыНастроек.ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии > 0;
	ПараметрыНастроек.ИспользоватьСпециальностиФизическихЛиц = ИспользоватьСпециальностиФизическихЛиц;
	ПараметрыНастроек.ИспользоватьПодработки = ИспользоватьПодработки;
	ПараметрыНастроек.ИспользоватьУчетСпецстажа = ИспользоватьУчетСпецстажа;
		
	НаименованиеЗадания = НСтр("ru='Сохранение настроек кадрового учета';uk='Збереження настройок кадрового обліку'");
	Если ИмяНастройки = "НастройкиВоинскогоУчета" Тогда
		НаименованиеЗадания = НСтр("ru='Сохранение настроек воинского учета';uk='Збереження настройок військового обліку'");
	КонецЕсли;
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ПанельНастроекЗарплатаКадры.ЗаписатьНастройки",
		ПараметрыНастроек,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьНастройкиНаКлиенте(ИмяНастройки)
	
	Результат = ЗаписатьНастройкиНаСервере(ИмяНастройки);
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте();
		
		// ERP начало: 00-00052344
		ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
		// ERP конец
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстПояснениеИспользоватьПереносОстатковОтпуска(Форма)
	Текст = НСтр("ru='На предприятии разрешается переносить остатки отпусков при переводе сотрудников между организациями';uk='На підприємстві дозволяється переносити залишки відпусток при переведенні працівників між організаціями'");
	Форма.ПояснениеИспользоватьПереносОстатковОтпускаПриУвольненииПереводом = Текст;	
КонецПроцедуры

#Область ОбновлениеИнтерфейса

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияОбновленияИнтерфейса()
	
	ТребуетсяОбновлениеИнтерфейса = Истина;
	
	#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОбновленияИнтерфейса", 1, Истина);
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбработчикОжиданияОбновленияИнтерфейса()
	
	ЗарплатаКадрыРасширенныйВызовСервера.ПередОбновлениемИнтерфейса();
	
	ОбновитьИнтерфейс();
		
	ЭтаФорма.ТребуетсяОбновлениеИнтерфейса = Ложь;
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	ДоступностьНастроек = Форма.ИспользоватьКадровыйУчетИРасчетЗарплаты;
	
	Форма.Элементы.НастройкаШтатногоРасписания.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаНеполнаяСтавка.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаПереносОстатковОтпуска.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаВоинскийУчет.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаАттестацииСотрудников.Доступность = ДоступностьНастроек;
	УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Форма.Элементы, Форма.НастройкиВоинскогоУчета);
	УстановитьДоступностьЭлементовФормыАттестацииСотрудников(Форма);
	
	// ERP начало
	Форма.Элементы.ГруппаКонтролироватьУникальностьТабельныхНомеров.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаИспользоватьПодработки.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаПечататьТ6ДляОтпусковПоБеременностиИРодам.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаИспользоватьСпециальностиФизическихЛиц.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаНастройкиКадровогоУчетаПравилоФормированияПредставленияЭлементовСправочникаСотрудники.Доступность = ДоступностьНастроек;
	// Конец
	Форма.Элементы.ГруппаИспользоватьУчетСпецстажа.Доступность = ДоступностьНастроек;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы(Форма)
	
	УстановитьВидимостьЭлементовФормыАттестацииСотрудников(Форма);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Элементы, НастройкиВоинскогоУчета)

	Элементы.ГруппаНастройкиВоинскогоУчета.Доступность = НастройкиВоинскогоУчета.ИспользоватьВоинскийУчет;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормыАттестацииСотрудников(Форма)
	
	#Если Клиент Тогда
		АттестацииСотрудниковСуществует = ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников");
	#Иначе
		АттестацииСотрудниковСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников");
	#КонецЕсли
	
	Если НЕ АттестацииСотрудниковСуществует Тогда
		Возврат;	
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии", "Доступность", Форма.ИспользоватьАттестацииСотрудников);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормыАттестацииСотрудников(Форма)
	
	Видимость = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ГруппаАттестацииСотрудников", "Видимость", Видимость);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ОбновитьПовторноИспользуемыеЗначения();
				ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				// ERP начало: 00-00052344
				ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
				// конец
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте()
	
	Если ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники Тогда
			
		ОбновитьПравилоФормированияПредставленияСправочникаСотрудники();
		ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники = Ложь;
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьПравилоФормированияПредставленияСправочникаСотрудники()
	
	КадровыйУчетРасширенный.УстановитьПараметрСеансаПравилоФормированияПредставленияЭлементовСправочникаСотрудники();
		
КонецПроцедуры


#КонецОбласти
