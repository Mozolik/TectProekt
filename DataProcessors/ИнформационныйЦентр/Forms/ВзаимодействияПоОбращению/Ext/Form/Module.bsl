﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторОбращения = Параметры.ИдентификаторОбращения;
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	ТекущаяСтраница = 1;
	Рассмотрено = Ложь;
	
	ЗаполнитьСодержаниеОбращения();
	ЗаполнитьПерепискуПоОбращению();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтправкаСообщенияВСлужбуПоддержки" Или ИмяСобытия = "ПросмотреноВзаимодействиеПоОбращению" Тогда 
		ПодключитьОбработчикОжидания("ЗаполнитьПерепискуПоОбращениюКлиент", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокВзаимодействийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	ИнформационныйЦентрКлиент.ОткрытьВзаимодействиеВСлужбуПоддержки(ИдентификаторОбращения, ТекущиеДанные.Идентификатор, ТекущиеДанные.Тип, ТекущиеДанные.Входящее, ТекущиеДанные.Просмотрено);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЛевоНажатие(Элемент)
	
	ТекущаяСтраница = ТекущаяСтраница - 1;
	ЗаполнитьПерепискуПоОбращению();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПравоНажатие(Элемент)
	
	ТекущаяСтраница = ТекущаяСтраница + 1;
	ЗаполнитьПерепискуПоОбращению();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	ИнформационныйЦентрКлиент.ОткрытьФормуОтправкиСообщенияВСлужбуПоддержки(Ложь, ИдентификаторОбращения);
	
КонецПроцедуры

&НаКлиенте
Процедура Рассмотрено(Команда)
	
	РассмотреноНаСервере();
	
	Если Рассмотрено Тогда 
		Оповестить("ПросмотреноВзаимодействиеПоОбращению");
	КонецЕсли;
	
	Рассмотрено = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСодержаниеОбращения()
	
	Попытка
		ДанныеПоОбращению = ПолучитьДанныеПоОбращению();
		ЗаполнитьСодержание(ДанныеПоОбращению);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,
		                         ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоОбращению()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
	
	Результат = WSПрокси.getIncident(Строка(ИдентификаторПользователя), Строка(ИдентификаторОбращения));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСодержание(ДанныеПоОбращению)
	
	ЭтотОбъект.Заголовок = ДанныеПоОбращению.Name + " (" + ДанныеПоОбращению.Number + ")";
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПерепискуПоОбращениюКлиент()
	
	ЗаполнитьПерепискуПоОбращению();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПерепискуПоОбращению()
	
	Попытка
		ДанныеПоПереписке = ПолучитьДанныеПоПереписке();
		ЗаполнитьПереписку(ДанныеПоПереписке);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,
		                         ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоПереписке()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
	
	Результат = WSПрокси.getInteractions(Строка(ИдентификаторПользователя), Строка(ИдентификаторОбращения), ТекущаяСтраница);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПереписку(ДанныеПоПереписке)
	
	СписокВзаимодействий.Очистить();
	
	Для Каждого ЭлементВзаимодействия Из ДанныеПоПереписке.Interactions Цикл 
		НовоеВзаимодействие = СписокВзаимодействий.Добавить();
		НовоеВзаимодействие.Идентификатор = Новый УникальныйИдентификатор(ЭлементВзаимодействия.Id);
		НовоеВзаимодействие.Тема = ЭлементВзаимодействия.Name;
		НовоеВзаимодействие.Описание = ?(ПустаяСтрока(ЭлементВзаимодействия.Description), НСтр("ru='<Без текста>';uk='<Без тексту>'"), ЭлементВзаимодействия.Description);
		НовоеВзаимодействие.Дата = ЭлементВзаимодействия.Date;
		НовоеВзаимодействие.НомерКартинки = ИнформационныйЦентрСервер.НомерКартинкиПоВзаимодействию(ЭлементВзаимодействия.Type, ЭлементВзаимодействия.Incoming);
		НовоеВзаимодействие.КартинкаВложения = ?(ЭлементВзаимодействия.IsFiles, БиблиотекаКартинок.Скрепка, Неопределено);
		НовоеВзаимодействие.ПояснениеККартинке = ?(ЭлементВзаимодействия.Incoming, НСтр("ru='Вх.';uk='Вх.'"), НСтр("ru='Исх.';uk='Вих.'"));
		НовоеВзаимодействие.Входящее = ЭлементВзаимодействия.Incoming;
		НовоеВзаимодействие.Тип = ЭлементВзаимодействия.Type;
		НовоеВзаимодействие.Просмотрено = ЭлементВзаимодействия.Viewed;
	КонецЦикла;
	
	ЗаполнитьПодвал(ДанныеПоПереписке);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодвал(ДанныеПоПереписке)
	
	ЕстьСтраницыДо = (ТекущаяСтраница > 1);
	ЕстьСтраницыПосле = ДанныеПоПереписке.IsStill;
	
	Элементы.КнопкаЛево.Гиперссылка = ЕстьСтраницыДо;
	Элементы.КнопкаЛево.Картинка = ?(ЕстьСтраницыДо, БиблиотекаКартинок.ПереходВлевоАктивный, БиблиотекаКартинок.ПереходВлевоНеАктивный);
	Элементы.КнопкаПраво.Картинка = ?(ЕстьСтраницыПосле, БиблиотекаКартинок.ПереходВправоАктивный, БиблиотекаКартинок.ПереходВправоНеАктивный);
	Элементы.КнопкаПраво.Гиперссылка = ЕстьСтраницыПосле;
	Элементы.ТекущаяСтраница.Заголовок = ТекущаяСтраница;
	
КонецПроцедуры

&НаСервере
Процедура РассмотреноНаСервере()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
	
	Фабрика = WSПрокси.ФабрикаXDTO;
	
	ТипСписокВзаимодействий = Фабрика.Тип("http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1", "ListInteraction");
	СписокВзаимодействийXDTO = Фабрика.Создать(ТипСписокВзаимодействий);
	
	МассивСтрок = Элементы.СписокВзаимодействий.ВыделенныеСтроки;
	Для Каждого ЭлементМассива Из МассивСтрок Цикл 
		НайденнаяСтрока = СписокВзаимодействий.НайтиПоИдентификатору(ЭлементМассива);
		Если НайденнаяСтрока = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Если НайденнаяСтрока.Просмотрено Тогда 
			Продолжить;
		КонецЕсли;
		
		Рассмотрено = Истина;
		
		ВзаимодействиеXDTO = СформироватьВзаимодействиеXDTO(НайденнаяСтрока, Фабрика);
		СписокВзаимодействийXDTO.Interactions.Добавить(ВзаимодействиеXDTO);
		
	КонецЦикла;
	
	WSПрокси.setInteractionsViewed(Строка(ИдентификаторПользователя), СписокВзаимодействийXDTO);
	
КонецПроцедуры

&НаСервере
Функция СформироватьВзаимодействиеXDTO(НайденнаяСтрока, Фабрика)
	
	ТипВзаимодействия = Фабрика.Тип("http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1", "Interaction");
	Взаимодействие = Фабрика.Создать(ТипВзаимодействия);
	
	Взаимодействие.Id = Строка(НайденнаяСтрока.Идентификатор);
	Взаимодействие.Type = НайденнаяСтрока.Тип;
	Взаимодействие.Incoming = НайденнаяСтрока.Входящее;
	
	Возврат Взаимодействие;
	
КонецФункции



