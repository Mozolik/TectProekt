﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензированияКлиент.
//
// Внимание. При проверке текста модуля на версии 8.3.6 платформы
// отображаются сообщения об ошибке: "Процедура или функция с указанным
// именем не определена (<Имя процедуры или функции>)".
// Данное сообщение платформы не является ошибкой, т.к.
// код модуля вызывается только при работе на версии платформы
// не ниже 8.3.7.
// Появление сообщений является особенностью библиотеки.
// При работе на версии 8.3.6 не приводит к ошибкам работы конфигурации.
//
// Код модуля вызывается только при работе на версии
// платформы не ниже версии 8.3.7.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Подключает обработчик запроса настроек клиента лицензирования.
//
Процедура ПодключитьОбработчикБИПДляЗапросаНастроекКлиентаЛицензирования() Экспорт
	
	ИмяГлобальногоМетода = "ПриЗапросеНастроекКлиентаЛицензирования";
	
	// Внимание. При проверке текста модуля на версии 8.3.6 платформы
	// отображается сообщение об ошибке: "Процедура или функция с указанным именем не определена
	// (ПодключитьОбработчикЗапросаНастроекКлиентаЛицензирования).
	// Появление этого сообщения является особенностью библиотеки.
	// Код модуля вызывается только при использовании версии платформы не
	// ниже версии 8.3.7.
	// При работе на версии 8.3.6 не приводит к ошибкам работы конфигурации.
	ПодключитьОбработчикЗапросаНастроекКлиентаЛицензирования(ИмяГлобальногоМетода);
	
КонецПроцедуры

#КонецОбласти
