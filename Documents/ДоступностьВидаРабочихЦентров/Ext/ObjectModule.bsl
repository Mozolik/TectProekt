﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ДоступностьВидаРабочихЦентров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ОтразитьДоступностьВидовРабочихЦентров(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтразитьДоступностьВидовРабочихЦентров(ДополнительныеСвойства, Движения, Отказ)
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоступностьВидовРабочихЦентров;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Набор = Движения.ДоступностьВидовРабочихЦентров;
	Набор.Записывать = Истина;
	Набор.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли