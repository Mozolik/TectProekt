﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗагрузитьПриложение();
	
КонецПроцедуры

&НаКлиенте
// Выполняет загрузку приложения из указанного файла
//
Процедура ЗагрузитьПриложение()
	
	#Если Не ВебКлиент Тогда
		
		РежимДиалога = РежимДиалогаВыбораФайла.Открытие;	
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалога);		
		ДиалогВыбораФайла.Заголовок = НСтр("ru='Выберите файл для загрузки';uk='Виберіть файл для завантаження'");
		ДиалогВыбораФайла.Фильтр = "xml";
		ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
		
		ИмяПриложения = Неопределено;
		НомерВерсии = Неопределено;
		Приложение = Неопределено;
		ИспользуемыеМетаданные = Неопределено;
		
		Если ДиалогВыбораФайла.Выбрать() Тогда
			
			ИмяФайла = ДиалогВыбораФайла.ПолноеИмяФайла;		
			
			ЧтениеXML = Новый ЧтениеXML();
			ЧтениеXML.ОткрытьФайл(ИмяФайла);
			
			Попытка
				
				Если ЧтениеXML.Прочитать() Тогда
					Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
						Если ЧтениеXML.Имя <> "MobileApplicationVersionData" Тогда
							ТекстСообщения = НСтр("ru='Ошибка чтения данных из файла';uk='Помилка читання даних з файлу'");
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
							Возврат;
						КонецЕсли;	
					КонецЕсли;
				Иначе
					ТекстСообщения = НСтр("ru='Ошибка чтения данных из файла';uk='Помилка читання даних з файлу'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					Возврат;
				КонецЕсли;	
				
				ИмяТекущегоЭлемента = Неопределено;
				
				Пока ЧтениеXML.Прочитать() Цикл
					
					Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
						ИмяТекущегоЭлемента = ЧтениеXML.Имя;
					ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
						
						Если ИмяТекущегоЭлемента = "ApplicationName" Тогда
							ИмяПриложения = ЧтениеXML.Значение;
						ИначеЕсли ИмяТекущегоЭлемента = "Version" Тогда
							НомерВерсии = ЧтениеXML.Значение;
						ИначеЕсли ИмяТекущегоЭлемента = "Application" Тогда
							Приложение = ЧтениеXML.Значение;
						ИначеЕсли ИмяТекущегоЭлемента = "Metadata" Тогда
							ИспользуемыеМетаданные = ЧтениеXML.Значение;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если ИмяПриложения = Неопределено ИЛИ НомерВерсии = Неопределено 
					ИЛИ Приложение = Неопределено ИЛИ ИспользуемыеМетаданные = Неопределено Тогда
					
					ТекстСообщения = НСтр("ru='Файл содержит некорректные данные';uk='Файл містить некоректні дані'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					Возврат;
					
				КонецЕсли;
				
			Исключение
				
				ТекстСообщения = НСтр("ru='Ошибка чтения данных из файла';uk='Помилка читання даних з файлу'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
			КонецПопытки;
			
			ЧтениеXML.Закрыть();
			
			СтруктураПриложения = ПолучитьСтруктуруПриложенияСервер(ИмяПриложения, НомерВерсии);
			
			Если СтруктураПриложения.Версия <> Неопределено Тогда
				
				ТекстВопроса = НСтр("ru='Загружаемая версия уже существует (%ИмяПриложения%, версия %НомерВерсии% ). Заменить?';uk='Завантажувана версія вже існує (%ИмяПриложения%, версія %НомерВерсии% ). Замінити?'");
				ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяПриложения%", ИмяПриложения);
				ТекстВопроса = СтрЗаменить(ТекстВопроса, "%НомерВерсии%", СокрП(НомерВерсии));
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("ИмяПриложения", ИмяПриложения);
				СтруктураПараметров.Вставить("НомерВерсии", НомерВерсии);
				СтруктураПараметров.Вставить("Приложение", Приложение);
				СтруктураПараметров.Вставить("ИспользуемыеМетаданные", ИспользуемыеМетаданные);
				СтруктураПараметров.Вставить("СтруктураПриложения", СтруктураПриложения);
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьПриложениеЗавершение", ЭтотОбъект, СтруктураПараметров);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
				
			Иначе
				ОбработатьЗаписьПриложения(ИмяПриложения, НомерВерсии, Приложение, ИспользуемыеМетаданные, СтруктураПриложения);
			КонецЕсли;
			
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПриложениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьЗаписьПриложения(ДополнительныеПараметры.ИмяПриложения,
							   ДополнительныеПараметры.НомерВерсии,
							   ДополнительныеПараметры.Приложение,
							   ДополнительныеПараметры.ИспользуемыеМетаданные,
							   ДополнительныеПараметры.СтруктураПриложения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗаписьПриложения(ИмяПриложения, НомерВерсии, Приложение, ИспользуемыеМетаданные, СтруктураПриложения)
	
	ЗаписатьПриложениеСервер(ИмяПриложения, НомерВерсии, Приложение, ИспользуемыеМетаданные, СтруктураПриложения);
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ВерсииМобильныхПриложений"));
	
	ТекстСообщения = НСтр("ru='Приложение загружено';uk='Додаток завантажено'");
	ПоказатьОповещениеПользователя("",,ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруПриложенияСервер(ИмяПриложения, НомерВерсии)
	
	Возврат МобильныеПриложения.ПолучитьСтруктуруПриложения(ИмяПриложения, НомерВерсии);

КонецФункции

&НаСервере
Процедура ЗаписатьПриложениеСервер(ИмяПриложения, НомерВерсии, Приложение, ИспользуемыеМетаданные, СтруктураПриложения)
	
	МобильныеПриложения.ЗаписатьПриложение(ИмяПриложения, НомерВерсии, Приложение, ИспользуемыеМетаданные, СтруктураПриложения);

КонецПроцедуры
