﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.МодельБюджетирования) Или Не ЗначениеЗаполнено(Параметры.ВидБюджета) Тогда
		ВызватьИсключение НСтр("ru='Открытие отчета возможно только из 
                                | - формы справочника ""Вид бюджета"" 
                                | - рабочего места ""Бюджетные отчеты""'
                                |;uk='Відкриття звіту можливе лише з 
                                |- форми довідника ""Вид бюджету"" 
                                |- робочого місця ""Бюджетні звіти""'");
	КонецЕсли;
	
	МодельБюджетирования = Параметры.МодельБюджетирования;
	ВидБюджета           = Параметры.ВидБюджета;
	
	Если Параметры.Свойство("Период") Тогда
		НачалоПериода = Параметры.Период.ДатаНачала;
		КонецПериода = Параметры.Период.ДатаОкончания;
	КонецЕсли;
	
	Если Параметры.Свойство("СформироватьБюджетныйОтчетПриОткрытии") Тогда
		СформироватьОтчет = Параметры.СформироватьБюджетныйОтчетПриОткрытии;
	КонецЕсли;
	
	Если Параметры.Свойство("Сценарий") Тогда
		Сценарий = Параметры.Сценарий;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
		Если Организация.Количество() > 0 Тогда
			ИспользоватьОтборПоОрганизация = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
		Если Подразделение.Количество() > 0 Тогда
			ИспользоватьОтборПоПодразделение = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыБюджетовАналитикиШапки.НомерСтроки КАК НомерСтроки,
		|	ВидыБюджетовАналитикиШапки.ВидАналитики,
		|	ВидыБюджетовАналитикиШапки.ВидАналитики.ТипЗначения КАК ТипЗначения,
		|	ВидыБюджетовАналитикиШапки.ВидАналитики.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ВидыБюджетов.АналитикиШапки КАК ВидыБюджетовАналитикиШапки
		|ГДЕ
		|	ВидыБюджетовАналитикиШапки.Ссылка = &ВидБюджета";
		
	Запрос.УстановитьПараметр("ВидБюджета", ВидБюджета);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	ТипБулево = Новый ОписаниеТипов("Булево");
	ТипСписок = Новый ОписаниеТипов("СписокЗначений");
	МассивРеквизитов = Новый Массив;
	
	СписокАналитикШапки.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(Выборка.ВидАналитики);
		Реквизит = Новый РеквизитФормы(ИмяПоля, ТипСписок, , Выборка.Наименование);
		МассивРеквизитов.Добавить(Реквизит);
		
		Реквизит = Новый РеквизитФормы("ИспользоватьОтборПо" + ИмяПоля, ТипБулево, , Выборка.Наименование);
		МассивРеквизитов.Добавить(Реквизит);
		
		СписокАналитикШапки.Добавить(Выборка.ВидАналитики);
		
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		
		ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(Выборка.ВидАналитики);
		
		ЭтаФорма[ИмяПоля].ТипЗначения = Выборка.ТипЗначения;
		
		Группа = Элементы.Добавить("Группа" + ИмяПоля, Тип("ГруппаФормы"), Элементы.ОтборДанных);
		Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
		Группа.ОтображатьЗаголовок = Ложь;
		
		Элемент = Элементы.Добавить("ИспользоватьОтборПо" + ИмяПоля, Тип("ПолеФормы"), Группа);
		Элемент.Вид = ВидПоляФормы.ПолеФлажка;
		Элемент.ПутьКДанным = "ИспользоватьОтборПо" + ИмяПоля;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
		
		Элемент = Элементы.Добавить(ИмяПоля, Тип("ПолеФормы"), Группа);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = ИмяПоля;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элемент.УстановитьДействие("ПриИзменении", "СписокОтборовПриИзменении");
		
	КонецЦикла;
	
	Если Параметры.Свойство("ДанныеКУтверждению") Тогда
		ДанныеКУтверждению = Параметры.ДанныеКУтверждению;
	КонецЕсли;
	Если Параметры.Свойство("ДанныеВПодготовке") Тогда
		ДанныеВПодготовке = Параметры.ДанныеВПодготовке;
	КонецЕсли;
	
	ПоказыватьПанельНастройки = Истина;
	Если Параметры.Свойство("ПоказыватьПанельНастройки") Тогда
		ПоказыватьПанельНастройки = Параметры.ПоказыватьПанельНастройки;
	КонецЕсли;
	
	ВариантСумм = Перечисления.ВариантыВыводаСуммВБюджетныхОтчетах.ВВалютеУпрУчета;
	
	ДатаАктуальности = ТекущаяДатаСеанса();
	
	ПараметрыВыбора = Отчеты.БюджетныйОтчет.ПараметрыДоступностиОтборов(ВидБюджета);
	ДоступенВыборОрганизация = ПараметрыВыбора.ДоступенВыборОрганизация;
	ДоступенВыборПодразделение = ПараметрыВыбора.ДоступенВыборПодразделение;
	ДоступенВыборСценария = ПараметрыВыбора.ДоступенВыборСценария;
	
	НачалоПериода = ТекущаяДата();
	КонецПериода = ТекущаяДата();
	
	Справочники.ВидыБюджетов.ВыровнятьДатыПоПериодичностиБюджета(ВидБюджета, НачалоПериода, КонецПериода);
	ГраницаФактДанных = Справочники.ВидыБюджетов.ГраницаФактическихДанныхПоВидуБюджета(ВидБюджета, НачалоПериода);
	
	ОтредактироватьСписокВыбораВалюты();
	УправлениеФормой();
	ОтредактироватьЗначенияФильтровИзмерений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если СформироватьОтчет Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("СформироватьНепосредственно", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	СформироватьНепосредственно();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОтменитьВыполнениеЗадания();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.НеИспользоватьСохраненныеНастройки Тогда
		Настройки.Очистить();
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоОрганизациям") Тогда
		Настройки.Удалить("ИспользоватьОтборПоОрганизация");
		Настройки.Удалить("Организация");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоПодразделениям") Тогда
		Настройки.Удалить("ИспользоватьОтборПоПодразделение");
		Настройки.Удалить("Подразделение");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Если Параметры.НеИспользоватьСохраненныеНастройки Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьВидимостьПанелиНастроек(ЭтаФорма);
	ОтредактироватьСписокВыбораВалюты();
	ОтредактироватьЗначенияФильтровИзмерений();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ДоступенВыборСценария Тогда
		НепроверяемыеРеквизиты.Добавить("Сценарий");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	// Проверим правильность настройки структуры
	Если Не Справочники.ВидыБюджетов.ВидБюджетаЗаполненПравильно(ВидБюджета) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтборовПриИзменении(Элемент)
	
	ЭтаФорма["ИспользоватьОтборПо" + Элемент.Имя] = ЭтаФорма[Элемент.Имя].Количество();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьСуммыПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаАктуальностиДанныхПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СУчетомДанныхКУтверждениюПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СУчетомДанныхВПодготовкеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаФактДанныхНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура("ВидБюджета, НачалоПериода, ГраницаФактДанных", ВидБюджета, НачалоПериода, ГраницаФактДанных);
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьГраницуФакта", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.НастройкаГраницыФакта", ПараметрыФормы,,,,,
						ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	КонецПериода = ?(НачалоПериода > КонецПериода, НачалоПериода, КонецПериода);
	ВыровнятьПериодыСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	НачалоПериода = ?(НачалоПериода > КонецПериода, КонецПериода, НачалоПериода);
	ВыровнятьПериодыСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Свойство("ИндексСтрокиДанных") И
				Расшифровка.ИндексСтрокиДанных <> Неопределено Тогда
			
			ПараметрыОткрытия = ПараметрыОткрытияОтчетаРасшифровки(Расшифровка);
			БюджетнаяОтчетностьКлиент.ОткрытьФормуОтчета(ПараметрыОткрытия, ЭтаФорма);
			
		ИначеЕсли Расшифровка.Свойство("Значение") И 
				Расшифровка.Значение <> Неопределено Тогда
			
			ПоказатьЗначение(Неопределено, Расшифровка.Значение);
			
		Иначе
			
			ПоказатьПредупреждение(, НСтр("ru='Нет данных для расшифровки';uk='Немає даних для розшифровки'"));
			
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Нет данных для расшифровки';uk='Немає даних для розшифровки'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	
	ОтредактироватьСписокВыбораВалюты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Отчет.БюджетныйОтчет.ФормаОтчета.Команда.СформироватьОтчет");
	
	СформироватьНепосредственно();
	
КонецПроцедуры

&НаКлиенте
Процедура ПанельНастроек(Команда)
	
	ПоказыватьПанельНастройки = Не ПоказыватьПанельНастройки;
	УстановитьВидимостьПанелиНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	НаименованиеВидаОтчета = Строка(ВидБюджета);
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость = Истина
		И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		
		ТекстВопроса = НСтр("ru='Отчет не сформирован. Сформировать?';uk='Звіт не сформований. Сформувати?'");
		Ответ = Неопределено;

		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОтправитьПоЭлектроннойПочтеЗавершение", 
			ЭтотОбъект, 
			Новый Структура("НаименованиеВидаОтчета", НаименованиеВидаОтчета)), 
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет, 
			60, 
			КодВозвратаДиалога.Да);
			
		Возврат;
	КонецЕсли;
	
	ПоказатьДиалогОтправкиПоЭлектроннойПочте(НаименованиеВидаОтчета);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочтеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	НаименованиеВидаОтчета = ДополнительныеПараметры.НаименованиеВидаОтчета;
	
	Ответ = РезультатВопроса;
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьНепосредственно();
	
	ПоказатьДиалогОтправкиПоЭлектроннойПочте(НаименованиеВидаОтчета);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Сформировать() Экспорт
	
	СформироватьНепосредственно();
	
КонецПроцедуры

&НаСервере
Процедура ВыровнятьПериодыСервер()
	
	Справочники.ВидыБюджетов.ВыровнятьДатыПоПериодичностиБюджета(ВидБюджета, НачалоПериода, КонецПериода);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияОтчетаРасшифровки(Расшифровка)

	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	Возврат БюджетнаяОтчетностьВызовСервера.ПараметрыОткрытияОтчетаРасшифровки(ПараметрыОтчета, Расшифровка, АдресДанныхЯчеек);
	
КонецФункции

&НаСервере
Процедура ОтредактироватьСписокВыбораВалюты()
	
	НуженВыборВВалюте = Отчеты.БюджетныйОтчет.ДоступенВыборОценкиВВалюте(ВидБюджета, ДоступенВыборСценария, Сценарий, ВалютаСценария);
	СписокВыбора = Элементы.ВыводитьСуммы.СписокВыбора;
	ВыводВВалюте = Перечисления.ВариантыВыводаСуммВБюджетныхОтчетах.ВВалютеСценария;
	
	Элемент = СписокВыбора.НайтиПоЗначению(ВыводВВалюте);
	Если Элемент <> Неопределено
		И Не НуженВыборВВалюте Тогда
		СписокВыбора.Удалить(Элемент);
		Если ВариантСумм = ВыводВВалюте
			ИЛИ Не ЗначениеЗаполнено(ВариантСумм) Тогда
			ВариантСумм = Перечисления.ВариантыВыводаСуммВБюджетныхОтчетах.ВВалютеУпрУчета;
		КонецЕсли;
	ИначеЕсли Элемент = Неопределено И НуженВыборВВалюте Тогда
		СписокВыбора.Вставить(0, ВыводВВалюте);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтредактироватьЗначенияФильтровИзмерений()
	
	Если Не ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоОрганизациям") Тогда
		ИспользоватьОтборПоОрганизация = Ложь;
		Организация = Неопределено;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоПодразделениям") Тогда
		ИспользоватьОтборПоПодразделение = Ложь;
		Подразделение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНепосредственно()
	
	РезультатВыполнения = СформироватьОтчетСервер();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	Иначе
		ОтчетыУПКлиентПереопределяемый.ПослеФормированияНаКлиенте(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПанелиНастроек(Форма)
	
	Форма.Элементы.ГруппаПанельНастроек.Видимость = Форма.ПоказыватьПанельНастройки;
	Форма.Элементы.ПанельНастроек.Пометка = Форма.ПоказыватьПанельНастройки;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВидБюджета",    ВидБюджета);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода",  КонецПериода);
	ПараметрыОтчета.Вставить("ДатаАктуальности", КонецДня(ДатаАктуальности));
	ПараметрыОтчета.Вставить("ГраницаФактДанных", ГраницаФактДанных);
	ПараметрыОтчета.Вставить("Сценарий", Сценарий);
	Если ИспользоватьОтборПоОрганизация Тогда
		ПараметрыОтчета.Вставить("Организация", Организация);
	КонецЕсли;
	Если ИспользоватьОтборПоПодразделение Тогда
		ПараметрыОтчета.Вставить("Подразделение", Подразделение);
	КонецЕсли;
	Если ИспользоватьОтборПоВалюта Тогда
		ПараметрыОтчета.Вставить("ВалютаХранения", Валюта);
	КонецЕсли;
	
	СтатусыДанных = Новый СписокЗначений;
	СтатусыДанных.Добавить(Перечисления.СтатусыПланов.Утвержден);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", 
		Новый Структура("МодельБюджетирования", ВидБюджета.Владелец)) Тогда
		Если ДанныеКУтверждению Тогда
			СтатусыДанных.Добавить(Перечисления.СтатусыПланов.НаУтверждении);
		КонецЕсли;
		Если ДанныеВПодготовке Тогда
			СтатусыДанных.Добавить(Перечисления.СтатусыПланов.ВПодготовке);
		КонецЕсли;
	Иначе
		СтатусыДанных.Добавить(Перечисления.СтатусыПланов.НаУтверждении);
		СтатусыДанных.Добавить(Перечисления.СтатусыПланов.ВПодготовке);
	КонецЕсли;
	ПараметрыОтчета.Вставить("Статус", СтатусыДанных);
	ПараметрыОтчета.Вставить("ВариантСумм", ВариантСумм);
	ПараметрыОтчета.Вставить("ВалютаСценария", ВалютаСценария);
	ПараметрыОтчета.Вставить("РежимФормирования", Перечисления.РежимыФормированияБюджетныхОтчетов.Отчет);
	
	ДополнительныеФильтрыПоАналитикам = Новый Структура;
	Для Каждого ВидАналитики из СписокАналитикШапки Цикл
		ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(ВидАналитики.Значение);
		ДополнительныеФильтрыПоАналитикам.Вставить(ИмяПоля);
		Если ЭтаФорма["ИспользоватьОтборПо" + ИмяПоля] Тогда
			ПараметрыОтчета.Вставить(ИмяПоля, ЭтаФорма[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОтчета.Вставить("ДополнительныеФильтрыПоАналитикам", ДополнительныеФильтрыПоАналитикам);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)

	ПериодСтрокой = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.НачалоПериода, Форма.КонецПериода);
	
	Если ЗначениеЗаполнено(Форма.ВидБюджета) Тогда
		ЗаголовокОтчета = Строка(Форма.ВидБюджета);
	Иначе
		ЗаголовокОтчета = НСтр("ru='Отчет по виду бюджета';uk='Звіт по виду бюджету'");
	КонецЕсли;
	
	Форма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2", ЗаголовокОтчета, ПериодСтрокой);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетСервер() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		
		ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
		Результат.Очистить();
		ОтображениеСостояния.Видимость  = Истина;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
		ОтображениеСостояния.Картинка   = Новый Картинка;
		ОтображениеСостояния.Текст  = НСтр("ru='Ошибки в виде бюджета';uk='Помилки у виді бюджету'");
		
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		ДанныеДляБюджетногоОтчета = БюджетнаяОтчетностьВыводСервер.ДанныеДляБюджетногоОтчета(ПараметрыОтчета);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БюджетнаяОтчетностьВыводСервер.ПоместитьДанныеДляБюджетногоОтчетаВХранилище",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные(ДанныеДляБюджетногоОтчета);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если СкрыватьНастройкиПриФормированииОтчета Тогда
		ПоказыватьПанельНастройки = Ложь;
		УстановитьВидимостьПанелиНастроек(ЭтаФорма);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура УправлениеФормой()
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	Элементы.Сценарий.Видимость = ДоступенВыборСценария;
	Элементы.ГруппаОтборПоОрганизациям.Видимость = ДоступенВыборОрганизация;
	Элементы.ГруппаОтборПоПодразделениям.Видимость = ДоступенВыборПодразделение;
	
	УстановитьВидимостьПанелиНастроек(ЭтаФорма);
	
	Справочники.ВидыБюджетов.НастроитьГруппуЭлементовПериода(ВидБюджета, Элементы, ГраницаФактДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Знач РезультатВыполнения = Неопределено)
	Перем КоличествоДокументов;
	
	Если РезультатВыполнения = Неопределено Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	КонецЕсли;
	Результат           = РезультатВыполнения.Результат;
	ДанныеЯчеек         = РезультатВыполнения.ДанныеЯчеек;
	
	АдресДанныхЯчеек = ПоместитьВоВременноеХранилище(ДанныеЯчеек, УникальныйИдентификатор);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	//++ НЕ УТКА
	#Область ЗапускФоновогоОтраженияДокументовВБюджетировании
		ДопСвойства = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		
		ДопСвойства.Удалить("КоличествоДокументовКОтражениюВБюджетировании");
		Если РегистрыСведений.ЗаданияКОтражениюВБюджетировании.ТребуетсяОтражениеВБюджетированииДляОтчетаЗаПериод(
																	НачалоПериода, КонецПериода, КоличествоДокументов) Тогда
			
			ФактическиеДанныеБюджетированияСервер.ОтразитьДокументыФоновымЗаданием(НачалоПериода, КонецПериода);
			ДопСвойства.Вставить("КоличествоДокументовКОтражениюВБюджетировании", КоличествоДокументов);
			ДопСвойства.Вставить("НачалоПериода", НачалоПериода);
			ДопСвойства.Вставить("КонецПериода", КонецПериода);
			
		КонецЕсли;
	#КонецОбласти
	
	ФактическиеДанныеБюджетированияСервер.ВывестиАктуальностьОтраженияФактическихДанных(Результат, ДопСвойства, Ложь);
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОтчетыУТКлиентПереопределяемый.ПослеФормированияНаКлиенте(ЭтаФорма);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	НачалоПериода = РезультатВыбора.НачалоПериода;
	КонецПериода = РезультатВыбора.КонецПериода;
	
	ВыровнятьПериодыСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьГраницуФакта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ГраницаФактДанных = Результат;
		Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
		КонецЕсли;
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте(НаименованиеВидаОтчета)
	ТабличныеДокументы = Новый СписокЗначений;
	ТабличныеДокументы.Добавить(ЭтаФорма.Результат, НаименованиеВидаОтчета);
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("ТабличныеДокументы", ТабличныеДокументы);
	ПараметрыОтправки.Вставить("Тема", НаименованиеВидаОтчета);
	ПараметрыОтправки.Вставить("Заголовок", 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Отправка отчета ""%1"" по почте';uk='Відправлення звіту ""%1"" поштою'"), НаименованиеВидаОтчета));
	ПараметрыОтправки = Новый Структура("Тема", НаименованиеВидаОтчета);
	
	МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
	МодульРаботаСПочтовымиСообщениямиКлиент.ОтправитьТабличныеДокументы(ТабличныеДокументы, НаименованиеВидаОтчета, ПараметрыОтправки);
КонецПроцедуры

#КонецОбласти

