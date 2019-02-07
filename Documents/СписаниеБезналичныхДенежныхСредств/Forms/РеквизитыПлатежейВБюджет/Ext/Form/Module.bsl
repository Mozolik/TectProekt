﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОбъекта = Новый Структура;
	СтруктураОбъекта.Вставить("КодОрганизации", 	Параметры.Объект.БанковскийСчет.Владелец.КодПоЕДРПОУ);
	СтруктураОбъекта.Вставить("СчетПолучателя", 	Параметры.Объект["БанковскийСчетКонтрагента"]);
	СтруктураОбъекта.Вставить("НазначениеПлатежа", 	Параметры.Объект["НазначениеПлатежа"]);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураОбъекта,
		"КодОрганизации, НазначениеПлатежа, СчетПолучателя");
		
	Элементы.Поле2.СписокВыбора.Добавить(";101", "(101) Сплата суми податків і зборів / єдиного внеску*"); 
	Элементы.Поле2.СписокВыбора.Добавить(";109", "(109) Оплата податкового векселя*");
	Элементы.Поле2.СписокВыбора.Добавить(";121", "(121) Сплата адміністративного штрафу*");
	Элементы.Поле2.СписокВыбора.Добавить(";125", "(125) Авансові внески, нараховані на суму дивідендів та прирівняних до них платежів*");
	Элементы.Поле2.СписокВыбора.Добавить(";130", "(130) Сплата грошового зобов'язання, визначеного за результатами камеральної перевірки підрозділів податкового та митного аудиту*");
	Элементы.Поле2.СписокВыбора.Добавить(";131", "(131) Сплата грошового зобов'язання, визначеного за результатами документальної/фактичної перевірки підрозділів податкового та митного аудиту*");
	Элементы.Поле2.СписокВыбора.Добавить(";132", "(132) Сплата грошового зобов'язання, визначеного за результатами документальної перевірки підрозділів оподаткування та контролю об'єктів і операцій*");
	Элементы.Поле2.СписокВыбора.Добавить(";133", "(133) Сплата суми податків і зборів / єдиного внеску, визначених за результатами документальної перевірки підрозділів доходів і зборів з фізичних осіб*");
	Элементы.Поле2.СписокВыбора.Добавить(";134", "(134) Сплата грошового зобов'язання, визначеного за результатами перевірки підрозділів податкового та митного аудиту (інші надходження)*");
	Элементы.Поле2.СписокВыбора.Добавить(";135", "(135) Сплата фінансових санкцій, визначених підрозділом контролю за обігом та оподаткуванням підакцизних товарів*");
	Элементы.Поле2.СписокВыбора.Добавить(";054", "(054) Погашення суми податкового боргу юридичних осіб*");
	Элементы.Поле2.СписокВыбора.Добавить(";055", "(055) Погашення суми податкового боргу фізичних осіб*");
	Элементы.Поле2.СписокВыбора.Добавить(";056", "(056) Погашення суми податкового боргу з акцизного податку*");
	Элементы.Поле2.СписокВыбора.Добавить(";057", "(057) Погашення суми податкового боргу за результатами контрольно-перевірочної роботи*");
	Элементы.Поле2.СписокВыбора.Добавить(";017", "(017) Надходження до бюджету коштів платника податків, щодо якого порушено провадження у справі про визнання банкрутом платника податку (юридичних осіб)*");
	Элементы.Поле2.СписокВыбора.Добавить(";018", "(018) Надходження до бюджету коштів платника податків, щодо якого порушено провадження у справі про визнання банкрутом платника податку (фізичних осіб - підприємців)*");
	Элементы.Поле2.СписокВыбора.Добавить(";019", "(019) Надходження до бюджету коштів платника податків, щодо якого порушено провадження у справі про визнання банкрутом платника податку (з акцизного податку)*");
	Элементы.Поле2.СписокВыбора.Добавить(";139", "(139) Надходження до бюджету коштів платника податків, щодо якого порушено провадження у справі про банкрутство (за результатами контрольно-перевірочної роботи)*");
	Элементы.Поле2.СписокВыбора.Добавить(";196", "(196) Надходження розстрочених (відстрочених) сум юридичних осіб*");
	Элементы.Поле2.СписокВыбора.Добавить(";197", "(197) Надходження розстрочених (відстрочених) сум фізичних осіб*");
	Элементы.Поле2.СписокВыбора.Добавить(";198", "(198) Надходження розстрочених (відстрочених) сум з акцизного податку*");
	Элементы.Поле2.СписокВыбора.Добавить(";199", "(199) Надходження розстрочених (відстрочених) сум за результатами контрольно-перевірочної роботи*");
	Элементы.Поле2.СписокВыбора.Добавить(";160", "(160) Сплата грошового зобов'язання, визначеного територіальним органом Міндоходів за результатами перевірки підрозділів оперативного управління*");
	Элементы.Поле2.СписокВыбора.Добавить(";161", "(161) Сплата грошового зобов'язання, визначеного територіальним органом Міндоходів за результатами перевірки підрозділів слідчого управління фінансових розслідувань*");
	Элементы.Поле2.СписокВыбора.Добавить(";350", "(350) Передоплата (доплата) митних платежів*");
	Элементы.Поле2.СписокВыбора.Добавить(";354", "(354) Сплата грошового зобов'язання, визначеного за результатами документальної невиїзної перевірки підрозділів податкового та митного аудиту*");
	Элементы.Поле2.СписокВыбора.Добавить(";355", "(355) Сплата грошового зобов'язання, визначеного за результатами документальної виїзної перевірки підрозділів податкового та митного аудиту*");
	Элементы.Поле2.СписокВыбора.Добавить(";356", "(356) Погашення суми податкового боргу за результатами контрольної роботи підрозділів податкового та митного аудиту*");
	Элементы.Поле2.СписокВыбора.Добавить(";355", "(355) Сплата грошового зобов'язання, визначеного за результатами документальної виїзної перевірки підрозділів податкового та митного аудиту*");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ПустаяСтрока(НазначениеПлатежа) Тогда
	
		НачальноеЗаполнение();
		
	Иначе		
		
		РазобратьНазначение();
		ЕстьОшибкиЗаполненияРеквизитов();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина; // Примем решение позже, в зависимости от ответа пользователя
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВопросПеренестиЗначенияВДокументЗавершение", ЭтотОбъект),
		НСтр("ru='Перенести указанные значения в документ?';uk='Перенести зазначені значення в документ?'"),
		РежимДиалогаВопрос.ДаНетОтмена,
		, // Заголовок
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренестиЗначенияВДокументЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Если ЕстьОшибкиЗаполненияРеквизитов() Тогда
			Возврат;
		КонецЕсли;
		ИзменитьРеквизитыДокумента();
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
	
	ОбновитьНазначениеПлатежа();

КонецПроцедуры

&НаКлиенте
Процедура НазначениеПлатежаПриИзменении(Элемент)
	
	РазобратьНазначение();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	НачальноеЗаполнение();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)

	Если ЕстьОшибкиЗаполненияРеквизитов() Тогда
		Возврат;
	КонецЕсли;

	ИзменитьРеквизитыДокумента();

	ЭтаФорма.Модифицированность = Ложь;
	ЭтаФорма.Закрыть();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ЕстьОшибкиЗаполненияРеквизитов()
	
	ЕстьОшибки = Ложь;
	
	// ПОЛЕ 1
	Если Поле1 <> "*" Тогда
		
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "1",,,НСтр("ru='ожидается  "" * ""';uk='очікується "" * ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Поле1");
		ЕстьОшибки = Истина;
		
	КонецЕсли;
	
	// ПОЛЕ 2
	Если Лев(Поле2,1) <> ";" Тогда
		         
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "2",,,НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле2");
		ЕстьОшибки = Истина;
		
	Иначе
		
		Код = Сред(Поле2, 2);
		
		Попытка
		
			Код = Число(Код);
			Если Код < 17 Тогда
			
				ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
					"Поле", "Корректность", "2",,, НСтр("ru='неверный код платежа';uk='невірний код платежу'"));		
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле2");
				ЕстьОшибки = Истина;
			КонецЕсли;
		
		Исключение
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
					"Поле", "Корректность", "2",,, НСтр("ru='неверный код платежа';uk='невірний код платежу'"));		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле2");
			ЕстьОшибки = Истина;
			
		КонецПопытки; 
		
		
	КонецЕсли;		
	
	// ПОЛЕ 3
	Если Лев(Поле3,1) <> ";" Тогда
		
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "3",,, НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле3");
		ЕстьОшибки = Истина;
		
	Иначе 
		
		Код = Сред(Поле3, 2);
		Попытка
		
			Код = Число(Код);
			Если Код > 0 И Код < 100000000 Тогда
				
				// КОД ЕДРПОУ должен быть с ведущими нулями до 8 символов
				Если СтрДлина(Сред(Поле3, 2)) < 8 Тогда
				
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Поле", "Корректность", "3",,, НСтр("ru='неверный код контрагента';uk='невірний код контрагента'"));			
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле3");
					ЕстьОшибки = Истина;
		
				КонецЕсли; 
			
			КонецЕсли;
		
		Исключение
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Поле", "Корректность", "3",,, НСтр("ru='неверный код контрагента';uk='невірний код контрагента'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Поле3");
			ЕстьОшибки = Истина;
		
		КонецПопытки; 
		
	КонецЕсли;		
	
	// ПОЛЕ 4
	Если Лев(Поле4,1) <> ";" Тогда
		         
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "4",,, НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле4);
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	// ПОЛЕ 5
	Если Лев(Поле5,1) <> ";" Тогда
		         
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "5",,, НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле5);
		ЕстьОшибки = Истина;
		
	КонецЕсли;			
	
	// ПОЛЕ 6
	Если Не ПустаяСтрока(Поле6) И Лев(Поле6,1) <> ";" Тогда
		         
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "6",,, НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле6);
		ЕстьОшибки = Истина;
		
	КонецЕсли;			
	
	// ПОЛЕ 7
	Если Не ПустаяСтрока(Поле7) И Лев(Поле7,1) <> ";" Тогда
		         
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Корректность", "7",,, НСтр("ru='поле должно начинаться со знака "" ; ""';uk='поле повинно починатися зі знака "" ; ""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле7);
		ЕстьОшибки = Истина;
		
	КонецЕсли;			
	
	Возврат ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьРеквизитыДокумента()
	
	СтруктураРезультата = Новый Структура("НазначениеПлатежа");

	ЗаполнитьЗначенияСвойств(СтруктураРезультата, ЭтаФорма);
	
	Оповестить("ВыборРеквизитовПлатежейВБюджет", СтруктураРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура РазобратьНазначение()

	НазначениеПлатежа = СокрЛ(НазначениеПлатежа);
	
	Копия = НазначениеПлатежа;
	
	Если Найти(Копия, Символы.ПС) > 0  Тогда
	
		Копия = СтрЗаменить(Копия, Символы.ПС, " "); 
		
	Иначе
		
		Копия = СтрЗаменить(Копия, ";", Символы.ПС + ";");
		 
	КонецЕсли;
	
	Для Инд = 1 По СтрЧислоСтрок(Копия) Цикл
		
		Поле = СтрПолучитьСтроку(Копия, Инд);
		
		Если Инд > 7 Тогда
			Продолжить;
		КонецЕсли;
		
		// инд лежит в диапазоне 1...7
		ЭтаФорма["Поле"+Инд] = Поле;
		
	КонецЦикла;
	
	ОбновитьНазначениеПлатежа();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНазначениеПлатежа()
	
	Для Инд = 2 По 7 Цикл
		
		ПолеЗначение = ЭтаФорма["Поле"+Инд];
		Если Лев(ПолеЗначение,1) = ";" Тогда
			ПолеЗначение = ";" +СокрЛП(Сред(ПолеЗначение, 2));
		КонецЕсли;
		ЭтаФорма["Поле"+Инд] = ПолеЗначение;
		
	КонецЦикла;
	
	НазначениеПлатежа = Поле1 + Поле2 + Поле3 + Поле4 + Поле5 + Поле6 + Поле7;
	
КонецПроцедуры	

&НаСервере
Процедура НачальноеЗаполнение()

	Поле1 = "*";
	Поле2 = ";101";
	Поле3 = ";"+СокрЛП(КодОрганизации);
	
	Поле4 = ";";
	//Если Поле4 до этого не заполнено, и если заполнен "Банковский счет получателя",записывает "текст назначения" из него в Поле4
	Если Поле4 = ";" И Не СчетПолучателя.Пустая() Тогда
		Поле4 = Поле4 + СчетПолучателя.ТекстНазначения;
	КонецЕсли;
	
	Поле5 = ";";
	Поле6 = "";
	Поле7 = "";
	
	Модифицированность = Истина;
	
	ОбновитьНазначениеПлатежа();
	
КонецПроцедуры

