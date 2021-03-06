﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


	Документы.Встреча.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Документы.ЗапланированноеВзаимодействие.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Документы.СообщениеSMS.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Документы.ТелефонныйЗвонок.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Документы.ЭлектронноеПисьмоИсходящее.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Справочники.ПретензииКлиентов.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	Справочники.СделкиСКлиентами.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.Встреча) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.Встреча.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.Встреча);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПрочиеВзаимодействия";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры

// Получает участников встречи.
//
// Параметры:
//  Ссылка  - ДокументСсылка.Встреча - документ, контакты которого необходимо получить.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица, содержащая колонки "Контакт", "Представление" и "Адрес".
//
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Возврат Взаимодействия.ПолучитьУчастниковПоТаблице(Ссылка);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("ДатаНачала");
	Результат.Добавить("ДатаОкончания");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ВзаимодействиеОснование");
	Результат.Добавить("Комментарий");
	Результат.Добавить("Участники.Контакт");
	Результат.Добавить("Участники.ПредставлениеКонтакта");
	Результат.Добавить("Участники.КакСвязаться");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаимодействияВызовСервера.ОбработкаПолученияДанныхВыбора(
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка, 
		"Встреча");
	
КонецПроцедуры

#КонецОбласти

