﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ХостСервисаОбновлений(Домен)
	
	Возврат "update-api.1c.eu";
	
КонецФункции

Функция URLСервисаОбновленийПлатформы()
	
	Возврат "https://"
		+ ХостСервисаОбновлений(ИнтернетПоддержкаПользователейКлиентСервер.НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП)
		+ "/update-platform/ws/platform?wsdl";
	
КонецФункции

Функция НовыйНастройкиАвтоматическогоОбновления() Экспорт
	
	Возврат Новый Структура(
		"СпособАвтоматическойПроверки, Расписание, ДатаПоследнейПроверки,
		|КаталогДистрибутивовПлатформы, РежимУстановки",
		1, // 1 - При запуске программы, 2 - по расписанию, 0 - не проверять автоматически;
		Неопределено, // Расписание не настроено
		'00010101',
		Неопределено, // Каталог по умолчанию
		0); // По умолчанию - "тихий" режим установки
	
КонецФункции

Функция ОповещатьОбОбновленияхВТекущихДелах() Экспорт
	
	
	
КонецФункции

Функция ТекущаяВерсияПлатформы1СПредприятие() Экспорт
	
	СистИнфо = Новый СистемнаяИнформация;
	Возврат СистИнфо.ВерсияПриложения;
	
КонецФункции

Функция ЭтоКодВозвратаПриОграниченииСистемныхПолитик(КодВозврата) Экспорт
	
	Возврат (КодВозврата = 1625 Или КодВозврата = 1643 Или КодВозврата = 1644);
	
КонецФункции

#Если Не ВебКлиент Тогда

Функция ФайлСуществует(ПутьФайла) Экспорт
	
	ОписательФайла = Новый Файл(ПутьФайла);
	Возврат ОписательФайла.Существует();
	
КонецФункции

Функция СистемныйКаталог(Идентификатор)
	
	App = Новый COMОбъект("Shell.Application");
	Folder = App.Namespace(Идентификатор);
	Возврат Folder.Self.Path;
	
КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// Обновление платформы

#Если Не ВебКлиент Тогда

Функция КаталогУстановкиПлатформы1СПредприятие(НомерВерсии) Экспорт
	
	КаталогProgramData = СистемныйКаталог(35);
	Если Прав(КаталогProgramData, 1) <> "\" Тогда
		КаталогProgramData = КаталогProgramData + "\";
	КонецЕсли;
	
	ПутьКонфигурационногоФайла = КаталогProgramData + "1C\1CEStart\1CEStart.cfg";
	ОписательФайла = Новый Файл(ПутьКонфигурационногоФайла);
	Если НЕ ОписательФайла.Существует() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Неопределено;
	
	// Чтение каталогов установки и поиск каталогов установки платформы
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКонфигурационногоФайла);
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	Пока ПрочитаннаяСтрока <> Неопределено Цикл
		Если ВРег(Лев(ПрочитаннаяСтрока, 17)) = "INSTALLEDLOCATION" Тогда
			ПутьКаталогаУстановки = Сред(ПрочитаннаяСтрока, 19);
			Если НЕ ПустаяСтрока(ПутьКаталогаУстановки) Тогда
				ПутьКаталогаВерсииПлатформы = ПутьКаталогаУстановки
					+ ?(Прав(ПутьКаталогаУстановки, 1) = "\", "", "\")
					+ НомерВерсии + "\bin\";
				ОписательФайла = Новый Файл(ПутьКаталогаВерсииПлатформы);
				Если ОписательФайла.Существует() Тогда
					ЧтениеТекста.Закрыть();
					Возврат ПутьКаталогаВерсииПлатформы;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();
	
	Возврат Неопределено;
	
КонецФункции

Функция КаталогДляРаботыСОбновлениямиПлатформы() Экспорт
	
	КаталогAppData = СистемныйКаталог(28);
	ПутьКаталога = КаталогAppData + ?(Прав(КаталогAppData, 1) = "\", "", "\")
		+ "1C\1Cv8PlatformUpdate";
	
	ОписательФайла = Новый Файл(ПутьКаталога);
	Если НЕ ОписательФайла.Существует() Тогда
		СоздатьКаталог(ПутьКаталога);
	КонецЕсли;
	
	Возврат ПутьКаталога + "\";
	
КонецФункции

Функция КаталогСодержитДистрибутивПлатформы1СПредприятие(Знач Каталог, Версия) Экспорт
	
	Если Прав(Каталог, 1) <> "\" Тогда
		Каталог = Каталог + "\";
	КонецЕсли;
	
	Если НЕ ФайлСуществует(Каталог)
		ИЛИ НЕ ФайлСуществует(Каталог + "setup.exe")
		ИЛИ НЕ ФайлСуществует(Каталог + "Setup.ini") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Чтение строк *.ini-файла
	ЧтениеТекста = Новый ЧтениеТекста(Каталог + "Setup.ini");
	ЕстьИмяПродукта = Ложь;
	ЕстьНомерВерсии = Ложь;
	ИскомаяСтрокаПродукта = "PRODUCT=1C:ENTERPRISE 8";
	ИскомаяСтрокаВерсии   = "PRODUCTVERSION=" + Версия;
	
	Попытка
		
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
		Пока ПрочитаннаяСтрока <> Неопределено Цикл
			ПрочитаннаяСтрокаВРег = ВРег(СокрЛП(ПрочитаннаяСтрока));
			Если ПрочитаннаяСтрокаВРег = ИскомаяСтрокаПродукта Тогда
				ЕстьИмяПродукта = Истина;
			ИначеЕсли ПрочитаннаяСтрокаВРег = ИскомаяСтрокаВерсии Тогда
				ЕстьНомерВерсии = Истина;
			КонецЕсли;
			
			Если ЕстьИмяПродукта И ЕстьНомерВерсии Тогда
				ЧтениеТекста.Закрыть();
				Возврат Истина;
			КонецЕсли;
			
			ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
		КонецЦикла;
		
		ЧтениеТекста.Закрыть();
		
	Исключение
		
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Ложь;
	
КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// Вызов операций сервиса обновлений

#Если Не ВебКлиент Тогда

Функция ПроксиВебСервисаОбновлений() Экспорт
	
	Возврат ИнтернетПоддержкаПользователейКлиентСервер.НовыйПроксиВебСервиса(
		URLСервисаОбновленийПлатформы(),
		"http://platform.api.update.company1c.com",
		"UpdatePlatformApiImplService",
		"UpdatePlatformApiImplPort",
		6);
	
КонецФункции

// Прокси-функция для вызова операции getPlatformUpdateInfo веб-сервиса
// Интернет-обновлений.
//
Функция СервисОбновлений_getPlatformUpdateInfo(ПроксиСервиса, ПараметрОперации) Экспорт
	
	Результат = Новый Структура(
		"КодОшибки, СообщениеОбОшибке, ИнформацияОбОшибке, ВозвращенноеЗначение",
		"",
		"",
		"",
		Неопределено);
	
	ТипСообщения = ПроксиСервиса.ФабрикаXDTO.Тип(
		"http://platform.api.update.company1c.com",
		"getPlatformUpdateInfo");
	Сообщение = ПроксиСервиса.ФабрикаXDTO.Создать(ТипСообщения);
	Сообщение.platformUpdateInfoRequest = ПараметрОперации;
	
	ЗаписьКонверта = ИнтернетПоддержкаПользователейКлиентСервер.НовыйЗаписьКонвертаSOAP();
	ПроксиСервиса.ФабрикаXDTO.ЗаписатьXML(
		ЗаписьКонверта,
		Сообщение,
		"getPlatformUpdateInfo",
		,
		ФормаXML.Элемент,
		НазначениеТипаXML.Явное);
	
	ТекстКонверта  = ИнтернетПоддержкаПользователейКлиентСервер.ТекстВКонвертеSOAP(ЗаписьКонверта);
	ОписаниеОтвета = ИнтернетПоддержкаПользователейКлиентСервер.ОтправитьЗапросSOAP(ТекстКонверта, ПроксиСервиса);
	
	ЗаполнитьЗначенияСвойств(Результат, ОписаниеОтвета, "КодОшибки, СообщениеОбОшибке, ИнформацияОбОшибке");
	Если ПустаяСтрока(ОписаниеОтвета.КодОшибки) Тогда
		ТипСообщенияОтвета = ПроксиСервиса.ФабрикаXDTO.Тип(
			"http://platform.api.update.company1c.com", "getPlatformUpdateInfoResponse");
		
		ОписаниеОтветаSOAP = ИнтернетПоддержкаПользователейКлиентСервер.ПрочитатьОтветВКонвертеSOAP(
			ОписаниеОтвета.ТелоОтвета,
			ПроксиСервиса,
			ТипСообщенияОтвета);
		
		Если ОписаниеОтветаSOAP.Ошибка Тогда
			Результат.КодОшибки = "ServerError";
			Результат.СообщениеОбОшибке = ОписаниеОтветаSOAP.СообщениеОбОшибке;
			Результат.ИнформацияОбОшибке =
				НСтр("ru='Ошибка вызова операции getPlatformUpdateInfo().';uk='Помилка виклику операції getPlatformUpdateInfo().'") + " "
				+ ОписаниеОтветаSOAP.ИнформацияОбОшибке
				+ Символы.ПС + НСтр("ru='Тело ответа:';uk='Тіло відповіді:'") + " " + Лев(ОписаниеОтвета.ТелоОтвета, 1024 * 5);
			Возврат Результат;
		КонецЕсли;
		
		Результат.ВозвращенноеЗначение = ОписаниеОтветаSOAP.ВозвращенноеЗначение.platformUpdateInfoResult;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Прокси-функция для вызова операции getPlatformUpdate веб-сервиса
// Интернет-обновлений.
//
Функция СервисОбновлений_getPlatformUpdate(ПроксиСервиса, ПараметрОперации) Экспорт
	
	Результат = Новый Структура(
		"КодОшибки, СообщениеОбОшибке, ИнформацияОбОшибке, ВозвращенноеЗначение",
		"",
		"",
		"",
		Неопределено);
	
	ТипСообщения = ПроксиСервиса.ФабрикаXDTO.Тип(
		"http://platform.api.update.company1c.com",
		"getPlatformUpdate");
	Сообщение = ПроксиСервиса.ФабрикаXDTO.Создать(ТипСообщения);
	Сообщение.platformUpdateRequest = ПараметрОперации;
	
	ЗаписьКонверта = ИнтернетПоддержкаПользователейКлиентСервер.НовыйЗаписьКонвертаSOAP();
	ПроксиСервиса.ФабрикаXDTO.ЗаписатьXML(
		ЗаписьКонверта,
		Сообщение,
		"getPlatformUpdate",
		,
		ФормаXML.Элемент,
		НазначениеТипаXML.Явное);
	
	ТекстКонверта  = ИнтернетПоддержкаПользователейКлиентСервер.ТекстВКонвертеSOAP(ЗаписьКонверта);
	ОписаниеОтвета = ИнтернетПоддержкаПользователейКлиентСервер.ОтправитьЗапросSOAP(ТекстКонверта, ПроксиСервиса);
	
	ЗаполнитьЗначенияСвойств(Результат, ОписаниеОтвета, "КодОшибки, СообщениеОбОшибке, ИнформацияОбОшибке");
	Если ПустаяСтрока(ОписаниеОтвета.КодОшибки) Тогда
		ТипСообщенияОтвета = ПроксиСервиса.ФабрикаXDTO.Тип(
			"http://platform.api.update.company1c.com", "getPlatformUpdateResponse");
		
		ОписаниеОтветаSOAP = ИнтернетПоддержкаПользователейКлиентСервер.ПрочитатьОтветВКонвертеSOAP(
			ОписаниеОтвета.ТелоОтвета,
			ПроксиСервиса,
			ТипСообщенияОтвета);
		
		Если ОписаниеОтветаSOAP.Ошибка Тогда
			Результат.КодОшибки = "ServerError";
			Результат.СообщениеОбОшибке = ОписаниеОтветаSOAP.СообщениеОбОшибке;
			Результат.ИнформацияОбОшибке =
				НСтр("ru='Ошибка вызова операции getPlatformUpdate().';uk='Помилка виклику операції getPlatformUpdate().'") + " "
				+ ОписаниеОтветаSOAP.ИнформацияОбОшибке
				+ Символы.ПС + НСтр("ru='Тело ответа:';uk='Тіло відповіді:'") + " " + Лев(ОписаниеОтвета.ТелоОтвета, 1024 * 5);
			Возврат Результат;
		КонецЕсли;
		
		Результат.ВозвращенноеЗначение = ОписаниеОтветаSOAP.ВозвращенноеЗначение.platformUpdateResult;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли

#КонецОбласти