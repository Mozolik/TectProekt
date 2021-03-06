﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	РаспределениеРасходов.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверим соответствие сумм документа и табличной части.
	Если СуммаДокумента <> РаспределениеРасходов.Итог("Сумма")
//++ НЕ УТ
		ИЛИ СуммаДокументаРегл <> РаспределениеРасходов.Итог("СуммаРегл")
		ИЛИ СуммаДокументаРеглБезНДС <> РаспределениеРасходов.Итог("СуммаРеглБезНДС")
		ИЛИ СуммаДокументаНДСРегл <> РаспределениеРасходов.Итог("НДСРегл")
		ИЛИ СуммаДокументаПР <> РаспределениеРасходов.Итог("ПостояннаяРазница")
		ИЛИ СуммаДокументаВР <> РаспределениеРасходов.Итог("ВременнаяРазница")
//-- НЕ УТ
		Тогда
		Текст = НСтр("ru='Сумма по строкам в табличной части должна равняться сумме документа';uk='Сума за рядками у табличній частині повинна дорівнювати сумі документа'");
//++ НЕ УТ
		Текст = НСтр("ru='Сумма по строкам в табличной части должна равняться соответствующим суммам документа';uk='Сума по рядках у табличній частині повинна дорівнювати відповідним сумам документа'");
//-- НЕ УТ
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"РаспределениеРасходов[0].Дата",
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	РеквизитыПроверкиАналитик = Новый Массив;
	РеквизитыПроверкиАналитик.Добавить("СтатьяРасходов, АналитикаРасходов");
	РеквизитыПроверкиАналитик.Добавить(Новый Структура("РаспределениеРасходов"));
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, РеквизитыПроверкиАналитик, МассивНепроверяемыхРеквизитов, Отказ);
		
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоМесяцев");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	//++ НЕ УТ
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете();
	КонецЕсли;
	//-- НЕ УТ
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеРасходовБудущихПериодов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	// Запись наборов записей
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
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

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	Если ДанныеЗаполнения <> Неопределено Тогда
		СуммаДокумента = СуммаДокумента + ?(ДанныеЗаполнения.Свойство("СуммаДокумента"), ДанныеЗаполнения.СуммаДокумента, 0);
		СуммаДокументаРегл = СуммаДокументаРегл + ?(ДанныеЗаполнения.Свойство("СуммаДокументаРегл"), ДанныеЗаполнения.СуммаДокументаРегл, 0);
		СуммаДокументаРеглБезНДС = СуммаДокументаРеглБезНДС + ?(ДанныеЗаполнения.Свойство("СуммаДокументаРеглБезНДС"), ДанныеЗаполнения.СуммаДокументаРеглБезНДС, 0);
		СуммаДокументаНДСРегл = СуммаДокументаНДСРегл + ?(ДанныеЗаполнения.Свойство("СуммаДокументаНДСРегл"), ДанныеЗаполнения.СуммаДокументаНДСРегл, 0);
		СуммаДокументаПР = СуммаДокументаПР + ?(ДанныеЗаполнения.Свойство("СуммаДокументаПР"), ДанныеЗаполнения.СуммаДокументаПР, 0);
		СуммаДокументаВР = СуммаДокументаВР + ?(ДанныеЗаполнения.Свойство("СуммаДокументаВР"), ДанныеЗаполнения.СуммаДокументаВР, 0);
	Иначе
		Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Контроль при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ПрочиеРасходы);
	КонецЕсли;

	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ПрочиеРасходы);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

//++ НЕ УТ

Процедура УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете()
	
	Если НЕ Проведен Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Структура;
	НепроверяемыеРеквизиты.Вставить("Комментарий");
	НепроверяемыеРеквизиты.Вставить("НачалоПериода");
	НепроверяемыеРеквизиты.Вставить("КонецПериода");
	НепроверяемыеРеквизиты.Вставить("КоличествоМесяцев");
	НепроверяемыеРеквизиты.Вставить("СуммаДокумента");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаРегл");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаРеглБезНДС");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаНДСРегл");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаПР");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаВР");
	
	ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(ЭтотОбъект, НепроверяемыеРеквизиты);
	
	Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
		РеглУчетПроведениеСервер.НеРегистрироватьКОтражениюВРеглУчете(ДополнительныеСвойства);
	Иначе
		Если ИзмененияДокумента.ТабличныеЧасти.Количество() = 1
			И ИзмененияДокумента.ТабличныеЧасти.Свойство("РаспределениеРасходов") Тогда
			Для Каждого Строка Из ИзмененияДокумента.ТабличныеЧасти.РаспределениеРасходов Цикл
				
				РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
				ДополнительныеСвойства, 
				Организация, 
				Строка.Дата);
				
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#КонецЕсли
