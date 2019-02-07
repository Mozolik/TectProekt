﻿#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает структуру с данными драйвера оборудования
// (со значениями реквизитов элемента справочника).
//
Функция ПолучитьДанныеДрайвера(Идентификатор) Экспорт

	ДанныеДрайвера = Новый Структура();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СпрДрайверыОборудования.Ссылка,
	|	СпрДрайверыОборудования.ИмяПредопределенныхДанных КАК Имя,
	|	СпрДрайверыОборудования.ТипОборудования КАК ТипОборудования,
	|	СпрДрайверыОборудования.Предопределенный КАК ВСоставеКонфигурации,
	|	СпрДрайверыОборудования.ИдентификаторОбъекта КАК ИдентификаторОбъекта, 
	|	СпрДрайверыОборудования.ОбработчикДрайвера КАК ОбработчикДрайвера,
	|	СпрДрайверыОборудования.ПоставляетсяДистрибутивом КАК ПоставляетсяДистрибутивом, 
	|	СпрДрайверыОборудования.ЗагруженныйДрайвер КАК ЗагруженныйДрайвер,  
	|	СпрДрайверыОборудования.ИмяФайлаДрайвера  КАК ИмяФайлаДрайвера,  
	|	СпрДрайверыОборудования.ИмяМакетаДрайвера КАК ИмяМакетаДрайвера,
	|	СпрДрайверыОборудования.ВерсияДрайвера    КАК ВерсияДрайвера
	|ИЗ
	|	Справочник.ДрайверыОборудования КАК СпрДрайверыОборудования
	|ГДЕ
	|	 СпрДрайверыОборудования.Ссылка = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	                                                           
	Если Выборка.Следующий() Тогда
		// Заполним структуру данных устройства.
		ДанныеДрайвера.Вставить("ДрайверОборудования"       , Выборка.Ссылка);
		ДанныеДрайвера.Вставить("ДрайверОборудованияИмя"    , Выборка.Имя);
		ДанныеДрайвера.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеДрайвера.Вставить("ВСоставеКонфигурации"      , Выборка.ВСоставеКонфигурации);
		ДанныеДрайвера.Вставить("ИдентификаторОбъекта"      , Выборка.ИдентификаторОбъекта);
		ДанныеДрайвера.Вставить("ОбработчикДрайвера"        , Выборка.ОбработчикДрайвера);
		ДанныеДрайвера.Вставить("ПоставляетсяДистрибутивом" , Выборка.ПоставляетсяДистрибутивом);
		ДанныеДрайвера.Вставить("ИмяМакетаДрайвера"         , Выборка.ИмяМакетаДрайвера);
		ДанныеДрайвера.Вставить("ИмяФайлаДрайвера"          , Выборка.ИмяФайлаДрайвера);
		ДанныеДрайвера.Вставить("ВерсияДрайвера"            , Выборка.ВерсияДрайвера);
	КонецЕсли;
	
	Возврат ДанныеДрайвера;
	
	
КонецФункции

Процедура ЗаполнитьПредопределенныйЭлемент(ОбработчикДрайвера, ИдентификаторОбъекта = Неопределено, ИмяМакетаДрайвера = Неопределено, 
	ПоставляетсяДистрибутивом = Ложь, ВерсияДрайвера = Неопределено, СнятСПоддержки = Ложь) Экспорт
	
	Параметры = МенеджерОборудованияВызовСервера.ПолучитьПараметрыДрайвераПоОбработчику(Строка(ОбработчикДрайвера));
	
	ВремИмяЭлемента = СтрЗаменить(Параметры.Имя, "Обработчик", "Драйвер");
	
	Попытка
		Драйвер = МенеджерОборудованияВызовСервера.ПредопределенныйЭлемент("Справочник.ДрайверыОборудования." + ВремИмяЭлемента);
	Исключение
		Сообщение = НСтр("ru='Предопределенный элемент ""%Параметр%"" не найден.';uk='Напередвизначений елемент ""%Параметр%"" не знайдено.'");
		Сообщение = СтрЗаменить(Сообщение, "%Параметр%", "Справочник.ДрайверыОборудования." + ВремИмяЭлемента);
		ВызватьИсключение Сообщение;
	КонецПопытки;
		
	Если Драйвер = Неопределено Тогда  
		Драйвер = Справочники.ДрайверыОборудования.СоздатьЭлемент();
		Драйвер.ИмяПредопределенныхДанных = ВремИмяЭлемента;     
		Драйвер.ТипОборудования           = Параметры.ТипОборудования;
		Драйвер.ОбработчикДрайвера        = ОбработчикДрайвера;
	Иначе 
		Драйвер = Драйвер.ПолучитьОбъект();
	КонецЕсли;
	
	Драйвер.Наименование              = Параметры.Наименование;
	Драйвер.ИдентификаторОбъекта      = ИдентификаторОбъекта;
	Драйвер.ИмяМакетаДрайвера         = ИмяМакетаДрайвера; 
	Драйвер.ПоставляетсяДистрибутивом = ПоставляетсяДистрибутивом;
	Драйвер.ВерсияДрайвера            = ВерсияДрайвера;
	Драйвер.СнятСПоддержки            = СнятСПоддержки;
	Драйвер.Записать();
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти