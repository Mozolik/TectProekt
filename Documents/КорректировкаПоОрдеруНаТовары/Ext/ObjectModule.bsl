﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаПоОрдеруНаТовары));

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.КорректировкаПоОрдеруНаТовары.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СкладыСервер.ОтразитьТоварыКОтбору(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	СкладыСервер.ОтразитьСостоянияПересчетовЯчеек(ЭтотОбъект.Ссылка, Неопределено, Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаПоОрдеруНаТовары),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Помещение");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		ТекстСообщения = НСтр("ru='В настройках программы не включено использование упаковок номенклатуры, 
        |поэтому нельзя оформить документ по складу с адресным хранением остатков. Обратитесь к администратору'
        |;uk='У настройках програми не включено використання упаковок номенклатури, 
        |тому не можна оформити документ по складу з адресним зберіганням залишків. Зверніться до адміністратора'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;
	
	ЕстьПеренос 				   = Ложь;
	ЕстьОприходованиеВЗонуОтгрузки = Ложь;
	
	Для каждого СтрТабл из Товары Цикл
		
		Если СтрТабл.ВидОперации = Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ПеренестиВДругойОрдер Тогда
			ЕстьПеренос = Истина;
		ИначеЕсли СтрТабл.ВидОперации = Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОтразитьИзлишекОставитьВЗонеОтгрузки
			Или СтрТабл.ВидОперации = Перечисления.ВидыОперацийКорректировкиОрдераНаТовары.ОставитьВЗонеОтгрузки Тогда
			ЕстьОприходованиеВЗонуОтгрузки = Истина;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если Не ЕстьПеренос Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрдерПолучатель");
	КонецЕсли;	
	
	Если Не ЕстьОприходованиеВЗонуОтгрузки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗонаОтгрузки");
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли