﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерСчета = "";
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВалютаДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаДенежныхСредств);
	
	ДенежныеСредстваСервер.ОбработкаЗаполненияСправочников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Не ИспользоватьОбменСБанком Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Программа");
		МассивНепроверяемыхРеквизитов.Добавить("Кодировка");
	КонецЕсли;
	
	
	Если Не ЗначениеНастроекПовтИсп.УказыватьНаправлениеНаБанковскихСчетахИКассах() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	ТекстОшибки = "";
	Если Не ИностранныйБанк
		И Не РегламентированныеДанныеКлиентСервер.ПроверитьКорректностьНомераСчета(НомерСчета, , ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "НомерСчета", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов") Тогда
		УстановитьПривилегированныйРежим(Истина);
 		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БанковскиеСчетаОрганизаций.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
		|ГДЕ
		|	БанковскиеСчетаОрганизаций.Ссылка <> &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьНесколькоРасчетныхСчетов.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
