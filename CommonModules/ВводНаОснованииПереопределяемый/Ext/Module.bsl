﻿
#Область ПрограммныйИнтерфейс

Процедура ПередДобавлениемКомандСоздатьНаОсновании(ИмяФормы, КомандыСоздатьНаОсновании, СтандартнаяОбработка) Экспорт
	
	МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы,".");
	
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.ИнтеграцияС1СДокументооборот) Тогда
		КомандаСозданияНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСозданияНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.ИнтеграцияС1СДокументооборотСоздатьПисьмо";
		КомандаСозданияНаОсновании.Идентификатор = "ИнтеграцияС1СДокументооборотСоздатьПисьмо";
		КомандаСозданияНаОсновании.Представление = НСтр("ru='Документооборот: Письмо';uk='Документообіг: Лист'");
		КомандаСозданияНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСозданияНаОсновании.ФункциональныеОпции = "ИспользоватьЭлектроннуюПочту1СДокументооборота";
		КомандаСозданияНаОсновании.Порядок = 98;
		
		КомандаСозданияНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСозданияНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.ИнтеграцияС1СДокументооборотСоздатьБизнесПроцесс";
		КомандаСозданияНаОсновании.Идентификатор = "ИнтеграцияС1СДокументооборотСоздатьБизнесПроцесс";
		КомандаСозданияНаОсновании.Представление = НСтр("ru='Документооборот: Процесс...';uk='Документообіг: Процес...'");
		КомандаСозданияНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСозданияНаОсновании.ФункциональныеОпции = "ИспользоватьПроцессыИЗадачи1СДокументооборота";
		КомандаСозданияНаОсновании.Порядок = 99;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОбработкиСозданияСвязанныхОбъектов", 
			Новый Структура("ДополнительныеОтчетыИОбработкиОбъектНазначения,ДополнительныеОтчетыИОбработкиТипФормы", 
			Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя",МассивПолей[0]+"."+МассивПолей[1]), МассивПолей[3]))
			или ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОбработкиСозданияСвязанныхОбъектов", 
			Новый Структура("ДополнительныеОтчетыИОбработкиОбъектНазначения,ДополнительныеОтчетыИОбработкиТипФормы", 
			Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя",МассивПолей[0]+"."+МассивПолей[1]), 
			?(СтрНайти(МассивПолей[3], "ФормаСписка") <> 0,ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка(),
			ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта()))) Тогда
		
		КомандаСозданияНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСозданияНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.СозданиеСвязанныхОбъектов";
		КомандаСозданияНаОсновании.Идентификатор = "СозданиеСвязанныхОбъектов";
		КомандаСозданияНаОсновании.Представление = НСтр("ru='Создание связанных объектов...';uk='Створення зв''язаних об''єктів...'");
		КомандаСозданияНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСозданияНаОсновании.Порядок = 100;
	КонецЕсли;
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании) Экспорт

	Если ПравоДоступа("Добавление", Метаданные.БизнесПроцессы.Задание) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.БизнесПроцессы.Задание.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.БизнесПроцессы.Задание);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьБизнесПроцессыИЗадачи";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ДобавитьКомандыСоздатьНаОснованииПисмаПоШаблону(КомандыСоздатьНаОсновании) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Обработки.СообщениеПоШаблону) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.СоздатьПисьмоПоШаблону";
		КомандаСоздатьНаОсновании.Идентификатор = "СоздатьПисьмоПоШаблону";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru='Письмо по шаблону';uk='Лист за шаблоном'");
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПочтовыйКлиент";
		
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.СоздатьСообщениеSMSПоШаблону";
		КомандаСоздатьНаОсновании.Идентификатор = "СоздатьСообщениеSMSПоШаблону";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru='Сообщение SMS по шаблону';uk='Повідомлення SMS за шаблоном'");
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПрочиеВзаимодействия";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти 