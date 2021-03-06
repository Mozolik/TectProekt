﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ТипИтога");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПравил.РазделИсточникаДанных,
	|	ТаблицаПравил.ТипИтога
	|ПОМЕСТИТЬ ТаблицаПравил
	|ИЗ
	|	&ТаблицаПравил КАК ТаблицаПравил
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА (ТаблицаПравил.РазделИсточникаДанных = ЗНАЧЕНИЕ(Перечисление.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет)
	|				ИЛИ ТаблицаПравил.РазделИсточникаДанных = ЗНАЧЕНИЕ(Перечисление.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет))
	|				И ТаблицаПравил.ТипИтога = ЗНАЧЕНИЕ(Перечисление.ТипыИтогов.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеЗаполненТипИтога
	|ИЗ
	|	ТаблицаПравил КАК ТаблицаПравил";
	Запрос.УстановитьПараметр("ТаблицаПравил", ЭтотОбъект.Выгрузить(,"РазделИсточникаДанных, ТипИтога"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.НеЗаполненТипИтога Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Поле Тип итога не заполнено';uk='Поле Тип підсумку не заповнено'"), ,"ТипИтога", "Запись", Отказ);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
