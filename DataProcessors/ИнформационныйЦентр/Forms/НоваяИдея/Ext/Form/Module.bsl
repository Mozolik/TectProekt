﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеПредметы.Загрузить(Параметры.ДоступныеПредметы.Выгрузить());
	Элементы.Предмет.СписокВыбора.ЗагрузитьЗначения(ДоступныеПредметы.Выгрузить( , "Предмет").ВыгрузитьКолонку("Предмет"));
	
	УстановитьПривилегированныйРежим(Истина);
	СинонимКонфигурации = Метаданные.Синоним;
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	
	НайденныйЭлемент = Элементы.Предмет.СписокВыбора.НайтиПоЗначению(СинонимКонфигурации);
	Если НайденныйЭлемент = Неопределено Тогда 
		Предмет = Элементы.Предмет.СписокВыбора.Получить(0).Значение;
	Иначе
		Предмет = НайденныйЭлемент.Значение;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДобавитьИдею(Команда)
	
	Если ПустаяСтрока(Наименование) Тогда 
		ВызватьИсключение НСтр("ru='Поле Наименование не должно быть пустым';uk='Поле Найменування не повинно бути порожнім'");
	КонецЕсли;
	
	Если ПустаяСтрока(Предмет) Тогда 
		ВызватьИсключение НСтр("ru='Поле Предмет не должно быть пустым';uk='Поле не повинно бути порожнім'");
	КонецЕсли;
	
	ДобавитьИдеюСервер();
	Закрыть();
	Оповестить("НоваяИдея");
	
	ПоказатьОповещениеПользователя("ru = 'Идея добавлена'");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ДобавитьИдеюСервер()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	Содержание.ПолучитьHTML(ТекстHTML, Вложения);
	ПриведенныйСписокВложений = ПривестиСписокВложений(Вложения, WSПрокси.ФабрикаXDTO);
	
	Попытка
		WSПрокси.addIdea(Строка(ИдентификаторПользователя), ТекстHTML, ПриведенныйСписокВложений, Предмет, Наименование);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПривестиСписокВложений(Знач СписокВложений, Знач ФабрикаXDTOВебСервиса)
	
	ТипСпискаВложений    = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/1cFresh/InformationCenter/UsersIdeas/1.0.0.1", "AttachmentList");
	ТипСтруктурыВложения = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/1cFresh/InformationCenter/UsersIdeas/1.0.0.1", "Attachment");
	
	СписокОбъектовВложений = ФабрикаXDTOВебСервиса.Создать(ТипСпискаВложений);
	
	Если СписокВложений.Количество() = 0 Тогда 
		Возврат СписокОбъектовВложений;
	КонецЕсли;
	
	Для Каждого Вложение из СписокВложений Цикл
		
		СтруктураВложения = ФабрикаXDTOВебСервиса.Создать(ТипСтруктурыВложения);
		СтруктураВложения.Name = Вложение.Ключ;
		СтруктураВложения.Data  = Вложение.Значение.ПолучитьДвоичныеДанные();
		
		СписокОбъектовВложений.AttachmentElement.Добавить(СтруктураВложения);
		
	КонецЦикла;
	
	Возврат СписокОбъектовВложений;
	
КонецФункции


