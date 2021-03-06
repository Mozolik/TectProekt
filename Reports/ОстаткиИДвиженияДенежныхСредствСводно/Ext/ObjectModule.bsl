﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваБезналичные) Тогда
		УдаляемыеЭлементы = ЭлементыПервогоУровняСтруктурыНастроекПоИмени(КомпоновщикНастроекФормы.Настройки, "БезналичныеДС");
		
		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			КомпоновщикНастроекФормы.Настройки.Структура.Удалить(УдаляемыйЭлемент);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваНаличные) Тогда
		УдаляемыеЭлементы = ЭлементыПервогоУровняСтруктурыНастроекПоИмени(КомпоновщикНастроекФормы.Настройки, "НаличныеДС");
		
		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			КомпоновщикНастроекФормы.Настройки.Структура.Удалить(УдаляемыйЭлемент);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц) Тогда
		УдаляемыеЭлементы = ЭлементыПервогоУровняСтруктурыНастроекПоИмени(КомпоновщикНастроекФормы.Настройки, "ПодотчетныеЛица");
		
		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			КомпоновщикНастроекФормы.Настройки.Структура.Удалить(УдаляемыйЭлемент);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваВКассахККМ) Тогда
		УдаляемыеЭлементы = ЭлементыПервогоУровняСтруктурыНастроекПоИмени(КомпоновщикНастроекФормы.Настройки, "ВКассахККМ");
		
		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			КомпоновщикНастроекФормы.Настройки.Структура.Удалить(УдаляемыйЭлемент);
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДанныеПоДенежнымСредствам");
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
		ПараметрДанных.ИдентификаторПользовательскойНастройки);
	
	Если ПользовательскаяНастройка <> Неопределено Тогда
		
		Если ПользовательскаяНастройка.Значение = 2 Тогда // В валюте упр. учета
			
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Валюта",
				Константы.ВалютаУправленческогоУчета.Получить());
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВалютаОтчета",
				Константы.ВалютаУправленческогоУчета.Получить());
			
		ИначеЕсли ПользовательскаяНастройка.Значение = 3 Тогда // В валюте регл. учета
			
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Валюта",
				Константы.ВалютаРегламентированногоУчета.Получить());
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВалютаОтчета",
				Константы.ВалютаРегламентированногоУчета.Получить());
			
		Иначе
			
			ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВалютаОтчета");
			Если ПараметрДанных <> Неопределено Тогда
				ПараметрДанных.Использование = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборыПлатежногоКалендаря = "";
	Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ОтборыПлатежногоКалендаря", ОтборыПлатежногоКалендаря) Тогда
		
		Для каждого ОтборКалендаря из ОтборыПлатежногоКалендаря Цикл
			
			Если Не ЗначениеЗаполнено(ОтборКалендаря.Значение) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ОтборКалендаря.Ключ = "ПериодОтчета" Тогда
				КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
					НастройкиОтчета,
					ОтборКалендаря.Ключ,
					ОтборКалендаря.Значение
				);
			КонецЕсли;
				
			Для каждого Раздел из НастройкиОтчета.Структура Цикл
				Если Раздел.ИдентификаторОбъекта = "БезналичныеДС" Или Раздел.ИдентификаторОбъекта = "НаличныеДС" Тогда
					
					ОтборРаздела = Раздел.Настройки.Отбор;
					Если ОтборРаздела.ДоступныеПоляОтбора.Элементы.Найти(ОтборКалендаря.Ключ) <> Неопределено Тогда
						
						КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
							Раздел.Настройки,
							ОтборКалендаря.Ключ,
							ОтборКалендаря.Значение, , , 
							Истина
						);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ВспомогательныеПараметры = Новый Массив;
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭлементыПервогоУровняСтруктурыНастроекПоИмени(Настройки, ИмяЭлемента)
	
	ИскомыеЭлементы = Новый Массив;
	
	СтруктураНастроек = Настройки.Структура;
	Для каждого ЭлементСтруктуры Из СтруктураНастроек Цикл
		Если ЭлементСтруктуры.ИдентификаторОбъекта = ИмяЭлемента
			ИЛИ ЭлементСтруктуры.Имя = ИмяЭлемента Тогда
			ИскомыеЭлементы.Добавить(ЭлементСтруктуры);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИскомыеЭлементы;
	
КонецФункции

#КонецОбласти

#КонецЕсли