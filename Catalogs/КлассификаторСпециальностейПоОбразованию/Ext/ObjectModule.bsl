﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли; 
	
	// Разрешена неуникальность пустого кода.
	Если НЕ ПустаяСтрока(Код) Тогда
		
		// Проверка уникальности кода справочника.
		КодПредыдущий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Код");
		Если КодПредыдущий <> Код Тогда
		
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Код", Код);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	КлассификаторСпециальностейПоОбразованию.Ссылка
				|ИЗ
				|	Справочник.КлассификаторСпециальностейПоОбразованию КАК КлассификаторСпециальностейПоОбразованию
				|ГДЕ
				|	КлассификаторСпециальностейПоОбразованию.Код = &Код
				|	И КлассификаторСпециальностейПоОбразованию.Ссылка <> &Ссылка";
				
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Значение ""%1"" поля ""Код"" не уникально';uk='Значення ""%1"" поля ""Код"" не унікально'"),
					Код);
					
				ВызватьИсключение ТекстИсключения;
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
