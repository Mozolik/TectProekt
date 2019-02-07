﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Выгружает данные информационной базы.
//
// Парамтеры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыгрузитьДанныеИнформационнойБазы(Контейнер, Обработчики, Сериализатор) Экспорт
	
	ВыгружаемыеТипы = Контейнер.ПараметрыВыгрузки().ВыгружаемыеТипы;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок.Создать();
	ТекущийПотокЗаписиПересоздаваемыхСсылок.Инициализировать(Контейнер, Сериализатор);
	
	ТекущийПотокЗаписиСопоставляемыхСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиСопоставляемыхСсылок.Создать();
	ТекущийПотокЗаписиСопоставляемыхСсылок.Инициализировать(Контейнер, Сериализатор);
	
	Для Каждого ОбъектМетаданных Из ВыгружаемыеТипы Цикл
		
		Если ИсключаемыеТипы.Найти(ОбъектМетаданных) <> Неопределено Тогда
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru='ВыгрузкаЗагрузкаДанных.ВыгрузкаОбъектаПропущена';uk='ВыгрузкаЗагрузкаДанных.ВыгрузкаОбъектаПропущена'",Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Информация,
				ОбъектМетаданных,
				,
				СтрШаблон(НСтр("ru='Выгрузка данных объекта метаданных %1 пропущена, т.к. он включен в
                          |список объектов метаданных, исключаемых из выгрузки и загрузки данных'
                          |;uk='Вивантаження даних об''єкта метаданих %1 пропущено, оскільки він включений в
                          |список об''єктів метаданих, що виключаються з вивантаження і завантаження даних'",Метаданные.ОсновнойЯзык.КодЯзыка),
					ОбъектМетаданных.ПолноеИмя()
				)
			);
			
			Продолжить;
			
		КонецЕсли;
		
		МенеджерВыгрузкиОбъекта = Создать();
		
		МенеджерВыгрузкиОбъекта.Инициализировать(
			Контейнер,
			ОбъектМетаданных,
			Обработчики,
			Сериализатор,
			ТекущийПотокЗаписиПересоздаваемыхСсылок,
			ТекущийПотокЗаписиСопоставляемыхСсылок);
		
		МенеджерВыгрузкиОбъекта.ВыгрузитьДанные();
		
		МенеджерВыгрузкиОбъекта.Закрыть();
		
	КонецЦикла;
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок.Закрыть();
	ТекущийПотокЗаписиСопоставляемыхСсылок.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
