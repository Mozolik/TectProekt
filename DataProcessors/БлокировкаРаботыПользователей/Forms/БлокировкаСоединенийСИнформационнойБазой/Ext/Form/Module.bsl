﻿&НаКлиенте
Перем ПараметрыАдминистрирования, ТекущееЗначениеБлокировки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	СеансЗапущенБезРазделителей = ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей();
	
	Если ЭтоФайловаяБаза Или Не ЭтоАдминистраторСистемы Тогда
		Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Или Не Пользователи.РолиДоступны("ПолныеПрава") Тогда
		Элементы.КодДляРазблокировки.Видимость = Ложь;
	КонецЕсли;
	
	ПолучитьПараметрыБлокировки();
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	ОбновитьСтраницуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлиентПодключенЧерезВебСервер = ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер();
	Если СоединенияИБКлиент.РаботаПользователейЗавершается() Тогда
		Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаСостоянияБлокировки;
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ИнформацияОБлокирующихСеансах = СоединенияИБ.ИнформацияОБлокирующихСеансах(НСтр("ru='Блокировка не установлена.';uk='Блокування не встановлене.'"));
	
	Если ИнформацияОБлокирующихСеансах.ИмеютсяБлокирующиеСеансы Тогда
		ВызватьИсключение ИнформацияОБлокирующихСеансах.ТекстСообщения;
	КонецЕсли;
	
	КоличествоСеансов = ИнформацияОБлокирующихСеансах.КоличествоСеансов;
	
	// Проверки возможности установки блокировки.
	Если Объект.НачалоДействияБлокировки > Объект.ОкончаниеДействияБлокировки 
		И ЗначениеЗаполнено(Объект.ОкончаниеДействияБлокировки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата окончания блокировки не может быть меньше даты начала блокировки. Блокировка не установлена.';uk='Дата закінчення блокування не може бути менше дати початку блокування. Блокування не встановлене.'"),,
			"Объект.ОкончаниеДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.НачалоДействияБлокировки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указана дата начала блокировки.';uk='Не зазначена дата початку блокування.'"),,	"Объект.НачалоДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершениеРаботыПользователей" Тогда
		КоличествоСеансов = Параметр.КоличествоСеансов;
		ОбновитьСостояниеБлокировки(ЭтотОбъект);
		Если Параметр.Статус = "Готово" Тогда
			Закрыть();
		ИначеЕсли Параметр.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(,НСтр("ru='Не удалось завершить работу всех активных пользователей.
                |Подробности см. в Журнале регистрации.'
                |;uk='Не вдалося завершити роботу всіх активних користувачів.
                |Подробиці див. у Журналі реєстрації.'"), 30);
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АктивныеПользователи(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	
	Объект.ВременноЗапретитьРаботуПользователей = Не НачальныйСтатусЗапретаРаботыПользователейЗначение;
	Если Объект.ВременноЗапретитьРаботуПользователей Тогда
		
		КоличествоСеансов = 1;
		Попытка
			Если Не ПроверитьПредусловияБлокировки() Тогда
				Возврат;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		ЗаголовокВопроса = НСтр("ru='Блокировка работы пользователей';uk='Блокування роботи користувачів'");
		Если КоличествоСеансов > 1 И Объект.НачалоДействияБлокировки < ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60 Тогда
			ТекстВопроса = НСтр("ru='Указано слишком близкое время начала действия блокировки, к которому пользователи могут не успеть сохранить все свои данные и завершить работу.
                |Рекомендуется установить время начала на 5 минут относительно текущего времени.'
                |;uk='Зазначене занадто близький час початку дії блокування, до якого користувачі можуть не встигнути зберегти всі свої дані й завершити роботу.
                |Рекомендується встановити час початку на 5 хвилин щодо поточного часу.'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Заблокировать через 5 минут';uk='Заблокувати через 5 хвилин'"));
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Заблокировать сейчас';uk='Заблокувати зараз'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "СлишкомБлизкоеВремяБлокировки");
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,,, ЗаголовокВопроса);
		ИначеЕсли Объект.НачалоДействияБлокировки > ОбщегоНазначенияКлиент.ДатаСеанса() + 60 * 60 Тогда
			ТекстВопроса = НСтр("ru='Указано слишком большое время начала действия блокировки (более, чем через час).
                |Запланировать блокировку на указанное время?'
                |;uk='Зазначене занадто великий час початку дії блокування (більш, ніж через годину).
                |Запланувати блокування на зазначений час?'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Запланировать';uk='Запланувати'"));
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Заблокировать сейчас';uk='Заблокувати зараз'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "СлишкомБольшоеВремяБлокировки");
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,,, ЗаголовокВопроса);
		Иначе
			Если Объект.НачалоДействияБлокировки - ОбщегоНазначенияКлиент.ДатаСеанса() > 15*60 Тогда
				ТекстВопроса = НСтр("ru='Завершение работы всех активных пользователей будет произведено в период с %1 по %2.
                    |Продолжить?'
                    |;uk='Завершення роботи всіх активних користувачів буде зроблено в період з %1 по %2.
                    |Продовжити?'");
			Иначе
				ТекстВопроса = НСтр("ru='Сеансы всех активных пользователей будут завершены к %2.
                    |Продолжить?'
                    |;uk='Сеанси всіх активних користувачів будуть завершені до %2.
                    |Продовжити?'");
			КонецЕсли;
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "Подтверждение");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Объект.НачалоДействияБлокировки - 900, Объект.НачалоДействияБлокировки);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,,, ЗаголовокВопроса);
		КонецЕсли;
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "Подтверждение");
		ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.ОК);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьЗавершение(Ответ, Вариант) Экспорт
	
	Если Вариант = "СлишкомБлизкоеВремяБлокировки" Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
		ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Вариант = "СлишкомБольшоеВремяБлокировки" Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
		ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Вариант = "Подтверждение" Тогда
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ВведеныКорректныеПараметрыАдминистрирования И ЭтоАдминистраторСистемы И Не ЭтоФайловаяБаза
		И ТекущееЗначениеБлокировки <> Объект.ЗапретитьРаботуРегламентныхЗаданий Тогда
		
		Попытка
			
			Если КлиентПодключенЧерезВебСервер Тогда
				УстановитьБлокировкуРегламентныхЗаданийНаСервере(ПараметрыАдминистрирования);
			Иначе
				АдминистрированиеКластераКлиентСервер.УстановитьБлокировкуРегламентныхЗаданийИнформационнойБазы(
					ПараметрыАдминистрирования, Неопределено, Объект.ЗапретитьРаботуРегламентныхЗаданий);
			КонецЕсли;
			
		Исключение
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(), "Ошибка",
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),, Истина);
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
	Если Не ЭтоФайловаяБаза И Не ВведеныКорректныеПараметрыАдминистрирования И СеансЗапущенБезРазделителей Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрированияПриБлокировке", ЭтотОбъект);
		ЗаголовокФормы = НСтр("ru='Управление блокировкой сеансов';uk='Управління блокуванням сеансів'");
		ПоясняющаяНадпись = НСтр("ru='Для управления блокировкой сеансов необходимо ввести
            |параметры администрирования кластера серверов и информационной базы'
            |;uk='Для управління блокуванням сеансів необхідно ввести
            |параметри адміністрування кластера серверів й інформаційної бази'");
		СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
			Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		
	Иначе
		
		ПослеПолученияПараметровАдминистрированияПриБлокировке(Истина, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	Если Не ЭтоФайловаяБаза И Не ВведеныКорректныеПараметрыАдминистрирования И СеансЗапущенБезРазделителей Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки", ЭтотОбъект);
		ЗаголовокФормы = НСтр("ru='Управление блокировкой сеансов';uk='Управління блокуванням сеансів'");
		ПоясняющаяНадпись = НСтр("ru='Для управления блокировкой сеансов необходимо ввести
            |параметры администрирования кластера серверов и информационной базы'
            |;uk='Для управління блокуванням сеансів необхідно ввести
            |параметри адміністрування кластера серверів й інформаційної бази'");
		СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
			Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		
	Иначе
		
		ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки(Истина, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАдминистрирования(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрирования", ЭтотОбъект);
	ЗаголовокФормы = НСтр("ru='Управление блокировкой регламентных заданий';uk='Управління блокуванням регламентних завдань'");
	ПоясняющаяНадпись = НСтр("ru='Для управления блокировкой регламентных заданий необходимо
        |ввести параметры администрирования кластера серверов и информационной базы'
        |;uk='Для управління блокуванням регламентних завдань необхідно
        |ввести параметри адміністрування кластера серверів й інформаційної бази'");
	СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
		Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru='Запрещено';uk='Заборонено'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru='Запланировано';uk='Заплановано'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru='Истекло';uk='Минуло'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗаблокированныйРеквизитЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru='Разрешено';uk='Дозволено'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаФормы);

КонецПроцедуры

&НаСервере
Функция ПроверитьПредусловияБлокировки()
	
	Возврат ПроверитьЗаполнение();

КонецФункции

&НаСервере
Функция УстановитьСнятьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ВыполнитьУстановку();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	КоличествоСеансов = СоединенияИБ.КоличествоСеансовИнформационнойБазы();
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОтменитьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ОтменитьБлокировку();
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаНастройки;
	ОбновитьСтраницуНастройки();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСтраницуНастройки()
	
	Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Доступность = Истина;
	Элементы.КомандаПрименить.Видимость = Истина;
	Элементы.КомандаПрименить.КнопкаПоУмолчанию = Истина;
	Элементы.КомандаОстановить.Видимость = Ложь;
	Элементы.КомандаПрименить.Заголовок = ?(Объект.ВременноЗапретитьРаботуПользователей,
		НСтр("ru='Снять блокировку';uk='Зняти блокування'"), НСтр("ru='Установить блокировку';uk='Установити блокування'"));
	Элементы.ЗапретитьРаботуРегламентныхЗаданий.Заголовок = ?(Объект.ЗапретитьРаботуРегламентныхЗаданий,
		НСтр("ru='Оставить блокировку работы регламентных заданий';uk='Залишити блокування роботи регламентних завдань'"), НСтр("ru='Также запретить работу регламентных заданий';uk='Також заборонити роботу регламентних задач'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтраницуСостояния(Форма)
	
	Форма.Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Доступность = Ложь;
	Форма.Элементы.КомандаОстановить.Видимость = Истина;
	Форма.Элементы.КомандаПрименить.Видимость = Ложь;
	Форма.Элементы.КомандаЗакрыть.КнопкаПоУмолчанию = Истина;
	ОбновитьСостояниеБлокировки(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеБлокировки(Форма)
	
	Форма.Элементы.Состояние.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Пожалуйста, подождите...
            |Работа пользователей завершается. Осталось активных сеансов: %1'
            |;uk='Будь ласка, почекайте...
            |Робота користувачів завершується. Залишилося активних сеансів: %1'"),
			Форма.КоличествоСеансов);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметрыБлокировки()
	Обработка = РеквизитФормыВЗначение("Объект");
	Попытка
		Обработка.ПолучитьПараметрыБлокировки();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
	КонецПопытки;
	
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
КонецПроцедуры

&НаСервере
Функция КраткоеОписаниеОшибки(ОписаниеОшибки)
	ТекстОшибки = ОписаниеОшибки;
	Позиция = СтрНайти(ТекстОшибки, "}:");
	Если Позиция > 0 Тогда
		ТекстОшибки = СокрЛП(Сред(ТекстОшибки, Позиция + 2, СтрДлина(ТекстОшибки)));
	КонецЕсли;
	Возврат ТекстОшибки;
КонецФункции	

&НаСервере
Процедура УстановитьНачальныйСтатусЗапретаРаботыПользователей()
	
	НачальныйСтатусЗапретаРаботыПользователейЗначение = Объект.ВременноЗапретитьРаботуПользователей;
	Если Объект.ВременноЗапретитьРаботуПользователей Тогда
		Если ТекущаяДатаСеанса() < Объект.НачалоДействияБлокировки Тогда
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru='Работа пользователей в программе будет запрещена в указанное время';uk='Робота користувачів у програмі буде заборонена в зазначений час'");
			СтатусЗапретаРаботыПользователей = "Запланировано";
		ИначеЕсли ТекущаяДатаСеанса() > Объект.ОкончаниеДействияБлокировки И Объект.ОкончаниеДействияБлокировки <> '00010101' Тогда
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru='Работа пользователей в программе разрешена (истек срок запрета)';uk='Робота користувачів у програмі дозволена (минув строк заборони)'");;
			СтатусЗапретаРаботыПользователей = "Истекло";
		Иначе
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru='Работа пользователей в программе запрещена';uk='Робота користувачів у програмі заборонена'");
			СтатусЗапретаРаботыПользователей = "Запрещено";
		КонецЕсли;
	Иначе
		НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru='Работа пользователей в программе разрешена';uk='Робота користувачів у програмі дозволена'");
		СтатусЗапретаРаботыПользователей = "Разрешено";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрирования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		
		Попытка
			Если КлиентПодключенЧерезВебСервер Тогда
				Объект.ЗапретитьРаботуРегламентныхЗаданий = БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования);
			Иначе
				Объект.ЗапретитьРаботуРегламентныхЗаданий = АдминистрированиеКластераКлиентСервер.БлокировкаРегламентныхЗаданийИнформационнойБазы(ПараметрыАдминистрирования);
			КонецЕсли;
			ТекущееЗначениеБлокировки = Объект.ЗапретитьРаботуРегламентныхЗаданий;
		Исключение;
			ВведеныКорректныеПараметрыАдминистрирования = Ложь;
			ВызватьИсключение;
		КонецПопытки;
		
		Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.ТекущаяСтраница = Элементы.ГруппаУправлениеРегламентнымиЗаданиями;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрированияПриБлокировке(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		ВключитьУправлениеБлокировкойРегламентныхЗаданий();
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	ИначеЕсли ТипЗнч(Результат) = Тип("Булево") И ВведеныКорректныеПараметрыАдминистрирования Тогда
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	КонецЕсли;
	
	Если Не УстановитьСнятьБлокировку() Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru='Блокировка работы пользователей';uk='Блокування роботи користувачів'"),
		"e1cib/app/Обработка.БлокировкаРаботыПользователей",
		?(Объект.ВременноЗапретитьРаботуПользователей, НСтр("ru='Блокировка установлена.';uk='Блокування встановлено.'"), НСтр("ru='Блокировка снята.';uk='Блокування знято.'")),
		БиблиотекаКартинок.Информация32);
	СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(	Объект.ВременноЗапретитьРаботуПользователей);
	
	Если Объект.ВременноЗапретитьРаботуПользователей Тогда
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	Иначе
		ОбновитьСтраницуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		ВключитьУправлениеБлокировкойРегламентныхЗаданий();
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	ИначеЕсли ТипЗнч(Результат) = Тип("Булево") И ВведеныКорректныеПараметрыАдминистрирования Тогда
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	КонецЕсли;
	
	Если Не ОтменитьБлокировку() Тогда
		Возврат;
	КонецЕсли;
	
	СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Ложь);
	ПоказатьПредупреждение(,НСтр("ru='Завершение работы активных пользователей отменено. 
        |Вход в программу новых пользователей оставлен заблокированным.'
        |;uk='Завершення роботи активних користувачів скасоване. 
        |Вхід у програму нових користувачів залишений заблокованим.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьУправлениеБлокировкойРегламентныхЗаданий()
	
	Если КлиентПодключенЧерезВебСервер Тогда
		Объект.ЗапретитьРаботуРегламентныхЗаданий = БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования);
	Иначе
		Объект.ЗапретитьРаботуРегламентныхЗаданий = АдминистрированиеКластераКлиентСервер.БлокировкаРегламентныхЗаданийИнформационнойБазы(ПараметрыАдминистрирования);
	КонецЕсли;
	ТекущееЗначениеБлокировки = Объект.ЗапретитьРаботуРегламентныхЗаданий;
	Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.ТекущаяСтраница = Элементы.ГруппаУправлениеРегламентнымиЗаданиями;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБлокировкуРегламентныхЗаданийНаСервере(ПараметрыАдминистрирования)
	
	АдминистрированиеКластераКлиентСервер.УстановитьБлокировкуРегламентныхЗаданийИнформационнойБазы(
		ПараметрыАдминистрирования, Неопределено, Объект.ЗапретитьРаботуРегламентныхЗаданий);
	
КонецПроцедуры
	
&НаСервере
Функция БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования)
	
	Возврат АдминистрированиеКластераКлиентСервер.БлокировкаРегламентныхЗаданийИнформационнойБазы(ПараметрыАдминистрирования);
	
КонецФункции

#КонецОбласти