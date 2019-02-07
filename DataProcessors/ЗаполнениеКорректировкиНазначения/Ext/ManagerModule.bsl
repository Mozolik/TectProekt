﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОснованииСнятиеРезерва(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаНазначенияТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Обработки.ЗаполнениеКорректировкиНазначения.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.ОткрытьМастерСнятияРезерва";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru='Корректировка назначения товаров (снятие резерва)';uk='Коригування призначення товарів (зняття резерву)'");
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ДобавитьКомандуСоздатьНаОснованииРезервирование(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаНазначенияТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Обработки.ЗаполнениеКорректировкиНазначения.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "ВводНаОснованииУТКлиент.ОткрытьМастерРезервирования";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru='Корректировка назначения товаров (резервирование)';uk='Коригування призначення товарів (резервування)'");
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли
