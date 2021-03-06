﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	БюджетированиеСервер.ЗаполнитьВспомогательныеРеквизитыПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Если Не ЭтоГруппа Тогда
		Если Не ПоПериодам и Не УстанавливатьЗначениеНаКаждыйПериод Тогда
			ПроверенныеРеквизитыОбъекта.Добавить("Периодичность");
		КонецЕсли;
		
		Если Не ПоПериодам Тогда
			ПроверенныеРеквизитыОбъекта.Добавить("ПериодичностьПодпериодов");
		КонецЕсли;
		
		Если ВидПоказателя <> Перечисления.ВидыНефинансовыхПоказателей.Денежный Тогда
			ПроверенныеРеквизитыОбъекта.Добавить("АналитикаВалюты");
		ИначеЕсли Не ВалютаОпределяетсяАналитикой Тогда
			ПроверенныеРеквизитыОбъекта.Добавить("АналитикаВалюты");
		КонецЕсли;
		
		Если ВидПоказателя <> Перечисления.ВидыНефинансовыхПоказателей.Количественный Тогда
			ПроверенныеРеквизитыОбъекта.Добавить("ЕдиницаИзмерения");
			ПроверенныеРеквизитыОбъекта.Добавить("АналитикаЕдиницыИзмерения");
		Иначе
			Если ЕдиницаИзмеренияОпределяетсяАналитикой Тогда
				ПроверенныеРеквизитыОбъекта.Добавить("ЕдиницаИзмерения");
			Иначе
				ПроверенныеРеквизитыОбъекта.Добавить("АналитикаЕдиницыИзмерения");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли