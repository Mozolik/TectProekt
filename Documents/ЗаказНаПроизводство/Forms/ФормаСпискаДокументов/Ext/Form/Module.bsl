﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтветственныйОтбор.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаказНаПроизводство));
		
	УправлениеИндикаторами();
	
	УстановитьВидимостьДоступностьЭлементов();
	
	Список.Параметры.УстановитьЗначениеПараметра("НеАктивен", НСтр("ru='Не активен';uk='Не активний'"));
	Список.Параметры.УстановитьЗначениеПараметра("Закрыт", НСтр("ru='Закрыт';uk='Закритий'"));
	Список.Параметры.УстановитьЗначениеПараметра("ВРаботе", НСтр("ru='В работе';uk='В роботі'"));
	Список.Параметры.УстановитьЗначениеПараметра("Выполнен", НСтр("ru='Выполнен';uk='Виконаний'"));
	Список.Параметры.УстановитьЗначениеПараметра("Построение", НСтр("ru='Построение';uk='Побудова'"));
 	
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказНаПроизводство" Тогда
		УправлениеИндикаторами();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборПоСтатусу();
	УстановитьОтборПоПриоритету();
	УстановитьОтборПоПодразделению();
	УстановитьОтборПоОтветственному();
	
	УправлениеИндикаторами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	УстановитьОтборПоСтатусу();
КонецПроцедуры

&НаКлиенте
Процедура ПриоритетОтборПриИзменении(Элемент)
	
	УстановитьОтборПоПриоритету();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОтборПриИзменении(Элемент)
	УстановитьОтборПоПодразделению();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	УстановитьОтборПоОтветственному();
КонецПроцедуры

&НаКлиенте
Процедура ИндикаторПрименяютсяНедействующиеСпецификацииНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение", Подразделение);
	ПараметрыФормы.Вставить("Ответственный", Ответственный);
	ОткрытьФорму("Документ.ЗаказНаПроизводство.Форма.ЗаменаНедействующихСпецификаций", ПараметрыФормы);
	
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
Процедура КомандаПерейтиКВыпускуПродукцииОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВыпускПродукции.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКВыработкеСотрудниковОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВыработкаСотрудников.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКЗаказамПереработчикамОтЗаказов(Команда)

	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ЗаказПереработчику.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКМаршрутнымЛистамОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ПараметрыФормы.Вставить("НеЗагружатьОтборы", Истина);
	ОткрытьФорму("Документ.МаршрутныйЛистПроизводства.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКПередачеМатериаловОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВнутреннееПотреблениеТоваров.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПланированиеЗаказа(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыЗаказовНаПроизводство.КПроизводству") Тогда
		ПоказатьПредупреждение(,НСтр("ru='Планирование заказа недоступно.
                                        |Заказ должен быть проведен со статусом ""К производству"".'
                                        |;uk='Планування замовлення недоступне.
                                        |Замовлення повинно бути проведене зі статусом ""До виробництва"".'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заказ", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.ДиспетчированиеГрафикаПроизводства.Форма.Планирование", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Номер.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеГрафика.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ответственный.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Комментарий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказовНаПроизводство.Закрыт;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Приоритеты.Ссылка                      КАК Приоритет,
	|	-Приоритеты.РеквизитДопУпорядочивания  КАК ПриоритетНомер,
	|	Приоритеты.Цвет                        КАК Цвет,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Приоритеты.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Элемент = УсловноеОформление.Элементы.Добавить();

			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Приоритет.Имя);
			
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Приоритет");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Выборка.ПриоритетНомер;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Выборка.Цвет.Получить());
			Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Выборка.Представление);
			
			Элемент = УсловноеОформление.Элементы.Добавить();

			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПриоритетОтбор.Имя);

			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Выборка.Приоритет;

			Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Выборка.Цвет.Получить());
			
		КонецЦикла;
		
	КонецЕсли;
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтатусу(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Статус", 
		Статус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Статус));
		
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПриоритету()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"ПриоритетОтбор", 
		Приоритет, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Приоритет));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Подразделение", 
		Подразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Подразделение));
	
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОтветственному(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Ответственный", 
		Ответственный, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Ответственный));
	
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеИндикаторами()
	
	Если ПравоДоступа("Редактирование", Метаданные.Документы.ЗаказНаПроизводство) Тогда
		ВидимостьИндикатора = Документы.ЗаказНаПроизводство.ЕстьЗаказыСНедействующимиСпецификациями(Подразделение, Ответственный);
	Иначе
		ВидимостьИндикатора = Ложь;
	КонецЕсли;
	
	Элементы.ИндикаторПрименяютсяНедействующиеСпецификации.Видимость = ВидимостьИндикатора;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ДиспетчированиеГрафикаПроизводства) Тогда
		Элементы.СписокПланированиеЗаказа.Видимость = Истина;
	Иначе
		Элементы.СписокПланированиеЗаказа.Видимость = Ложь;
	КонецЕсли; 
	
	Элементы.ФормаСписокГруппаСоздать.Видимость = Документы.ЗаказНаПроизводство.ПравоДоступаДобавление();
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеЗаказы()

	Возврат РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);

КонецФункции

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Документ.ЗаказНаПроизводство.ФормаСпискаДокументов.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
