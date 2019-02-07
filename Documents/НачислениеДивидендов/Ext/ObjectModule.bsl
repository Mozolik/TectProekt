﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ФизическиеЛица.Количество() = 0 И ЮридическиеЛица.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указаны акционеры в списках получателей дивидендов';uk='Не зазначені акціонери в списках одержувачів дивідендів'"),
			ЭтотОбъект,
			"ФизическиеЛица",
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СуммаДокумента = ФизическиеЛица.Итог("Начислено") + ЮридическиеЛица.Итог("Начислено");
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.НачислениеДивидендов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		
		УчетНДФЛРасширенный.СформироватьДоходыИНДФЛСДивидендов(
			Движения,
			Отказ,
			Организация,
			ДатаВыплаты,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДивиденды, Ссылка);

			
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(
			Движения,
			Отказ,
			Организация,
			ДатаВыплаты,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНачисления,
			,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНДФЛ);
			
	КонецЕсли;
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыПоУмолчанию()
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	Ответственный = Пользователи.ТекущийПользователь();
	Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли