﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		
		ЗаполнитьНаОснованииПартнера(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьПоОтбору(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьСправочник(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Дата начала действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала действия договора должна быть не меньше даты договора';uk='Дата початку дії договору повинна бути не менше дати договору'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты договора';uk='Дата закінчення дії договору повинна бути не менше дати договору'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты начала действия';uk='Дата закінчення дії договору повинна бути не менше дати початку дії'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	Если ВариантУчетаИмущества <> Перечисления.ВариантыУчетаИмуществаПриЛизинге.НаБалансе Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаАрендныеОбязательства");
	КонецЕсли;
	Если Не ЕстьОбеспечительныйПлатеж Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаОбеспечительныйПлатеж");
	КонецЕсли;
	Если Не ЕстьВыкупПредметаЛизинга Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаВыкупПредметаЛизинга");
	КонецЕсли;
	Если НЕ ЗначениеНастроекПовтИсп.УказыватьНаправлениеВЗатратах() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ПроверитьЗаполнениеСчетовУчетаРасчетов(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';
	ИдентификаторПлатежа	= Неопределено;

	ИнициализироватьСправочник();

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВариантУчетаИмущества <> Перечисления.ВариантыУчетаИмуществаПриЛизинге.НаБалансе 
		 И ЗначениеЗаполнено(СчетУчетаАрендныеОбязательства) Тогда
		СчетУчетаАрендныеОбязательства = Неопределено;
	КонецЕсли;
	Если Не ЕстьОбеспечительныйПлатеж И ЗначениеЗаполнено(СчетУчетаОбеспечительныйПлатеж) Тогда
		СчетУчетаОбеспечительныйПлатеж = Неопределено;
	КонецЕсли;
	Если Не ЕстьВыкупПредметаЛизинга И ЗначениеЗаполнено(СчетУчетаВыкупПредметаЛизинга) Тогда
		СчетУчетаВыкупПредметаЛизинга = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииПартнера(Знач Партнер, ДанныеЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("Партнер", Партнер);
	ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер));
	ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(Партнер));
	
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("ПартнерПоУмолчанию") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ДанныеЗаполнения.ПартнерПоУмолчанию);
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
		
	ИначеЕсли ДанныеЗаполнения.Свойство("Контрагент") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Контрагент, "Партнер"));
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		Если НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
			ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
		Если НЕ (ДанныеЗаполнения.Свойство("КонтактноеЛицо") И ЗначениеЗаполнено(ДанныеЗаполнения.КонтактноеЛицо)) Тогда
			ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
	КонецЕсли;;
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения);
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") И Не ДанныеЗаполнения.Свойство("ПорядокОплаты") Тогда
		ДанныеЗаполнения.Вставить("ПорядокОплаты",
			Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ДанныеЗаполнения.ВалютаВзаиморасчетов));
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчет") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчет)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Организация") И ЗначениеЗаполнено(ДанныеЗаполнения.Организация)) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ДанныеЗаполнения.Свойство("ПорядокОплаты") И ДанныеЗаполнения.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И ((БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаОрганизаций.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Организация", ДанныеЗаполнения.Организация);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчет", Выборка.БанковскийСчет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчетКонтрагента") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчетКонтрагента)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ДанныеЗаполнения.Свойство("ПорядокОплаты") И ДанныеЗаполнения.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаКонтрагентов.Ссылка КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|ГДЕ
	|	БанковскиеСчетаКонтрагентов.Владелец = &Контрагент
	|	И ((БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаКонтрагентов.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Контрагент", ДанныеЗаполнения.Контрагент);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчетКонтрагента", Выборка.БанковскийСчетКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет реквизиты справочника значениями "по умолчанию".
//
Процедура ИнициализироватьСправочник(ДанныеЗаполнения = Неопределено) Экспорт
	
	Менеджер = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") Тогда
		ВалютаВзаиморасчетов = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ПорядокОплаты") Тогда
		ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов);
	КонецЕсли;
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация = Организация;
	СтруктураПараметров.БанковскийСчет = БанковскийСчет;
	
	ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьЗаполнениеСчетовУчетаРасчетов(Отказ)
	
	ШаблонСообщения = НСтр("ru='Счет учета в поле ""%1"" должен отличаться от счета учета, указанного в поле ""%2""';uk='Рахунок обліку в полі ""%1"" повинен відрізнятися від рахунку обліку, зазначеного в полі ""%2""'");
	
	СчетаУчета = Новый Соответствие;
	
	Если ЕстьОбеспечительныйПлатеж И ЗначениеЗаполнено(СчетУчетаОбеспечительныйПлатеж) Тогда
		СчетаУчета.Вставить(СчетУчетаОбеспечительныйПлатеж, НСтр("ru='Обеспечительный платеж';uk='Забезпечувальний платіж'"));
	КонецЕсли;
	
	Если ВариантУчетаИмущества = Перечисления.ВариантыУчетаИмуществаПриЛизинге.НаБалансе
		 И ЗначениеЗаполнено(СчетУчетаАрендныеОбязательства) Тогда
		 
		ИмяПоля =  НСтр("ru='Арендные обязательства';uk='Орендні зобов''язання'");
		
		Если СчетаУчета[СчетУчетаАрендныеОбязательства] <> Неопределено Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонСообщения, ИмяПоля, СчетаУчета[СчетУчетаАрендныеОбязательства]);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"СчетУчетаАрендныеОбязательства",
				,
				Отказ);
		Иначе
			СчетаУчета.Вставить(СчетУчетаАрендныеОбязательства, ИмяПоля);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетУчетаУслугиПоЛизингу) Тогда
		 
		ИмяПоля =  НСтр("ru='Лизинговые услуги';uk='Лізингові послуги'");
		
		Если СчетаУчета[СчетУчетаУслугиПоЛизингу] <> Неопределено Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонСообщения, ИмяПоля, СчетаУчета[СчетУчетаУслугиПоЛизингу]);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"СчетУчетаУслугиПоЛизингу",
				,
				Отказ);
		Иначе
			СчетаУчета.Вставить(СчетУчетаУслугиПоЛизингу, ИмяПоля);
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьВыкупПредметаЛизинга И ЗначениеЗаполнено(СчетУчетаВыкупПредметаЛизинга) Тогда
		 
		ИмяПоля =  НСтр("ru='Выкуп предмета лизинга';uk='Викуп предмета лізингу'");
		
		Если СчетаУчета[СчетУчетаВыкупПредметаЛизинга] <> Неопределено Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонСообщения, ИмяПоля, СчетаУчета[СчетУчетаВыкупПредметаЛизинга]);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"СчетУчетаВыкупПредметаЛизинга",
				,
				Отказ);
		Иначе
			СчетаУчета.Вставить(СчетУчетаВыкупПредметаЛизинга, ИмяПоля);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли
