﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет проверку необходимости обновления конфигурации базы данных в подчиненном узле.
//
Процедура ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзла() Экспорт
	
	ТребуетсяОбновление = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ТребуетсяОбновлениеКонфигурацииУзлаРИБ;
	ПроверитьНеобходимостьОбновления(ТребуетсяОбновление);
	
КонецПроцедуры

// Выполняет проверку необходимости обновления конфигурации базы данных в подчиненном узле при запуске.
//
Процедура ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзлаПриЗапуске() Экспорт
	
	ТребуетсяОбновление = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ТребуетсяОбновлениеКонфигурацииУзлаРИБ;
	ПроверитьНеобходимостьОбновления(ТребуетсяОбновление);
	
КонецПроцедуры

Процедура ПроверитьНеобходимостьОбновления(ТребуетсяОбновлениеКонфигурацииУзлаРИБ)
	
	Если ТребуетсяОбновлениеКонфигурацииУзлаРИБ Тогда
		Пояснение = НСтр("ru='Получено обновление программы из ""%1"".
            |Необходимо установить обновление программы, после чего синхронизация данных будет продолжена.'
            |;uk='Отримано оновлення програми з ""%1"".
            |Необхідно встановити оновлення програми, після чого синхронізація даних буде продовжена.'");
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Пояснение, СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ГлавныйУзел);
		ПоказатьОповещениеПользователя(НСтр("ru='Установить обновление';uk='Установити оновлення'"), "e1cib/app/Обработка.ВыполнениеОбменаДанными",
			Пояснение, БиблиотекаКартинок.Предупреждение32);
		Оповестить("ВыполненОбменДанными");
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзла", 60 * 60, Истина); // раз в час
	
КонецПроцедуры

#КонецОбласти
