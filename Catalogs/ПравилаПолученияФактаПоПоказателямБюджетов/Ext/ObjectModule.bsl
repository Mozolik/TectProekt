﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ТипИтога");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НеЗаполненТипИтога = (РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет
							ИЛИ РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет)
						И Не ЗначениеЗаполнено(ТипИтога);
	
	Если НеЗаполненТипИтога Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле Тип итога не заполнено';uk='Поле Тип підсумку не заповнено'"), ,"ТипИтога", "Запись", Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Наименование = Строка(РазделИсточникаДанных) + ": " + ИсточникДанных;
	Если ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
		Наименование = Наименование + ", " + ПредставлениеОтбора;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	РегистрыСведений.КэшПримененияПравилПолученияФакта.СброситьКэш(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
