﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	#Область АктуализацияВзаиморасчетов
	УстановитьПривилегированныйРежим(Истина);
	ПоляОтбора = РаспределениеВзаиморасчетов.ПоляОтбораПоУмолчанию();
	ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	РаспределениеВзаиморасчетов.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства, "РасчетыСКлиентами");
	УстановитьПривилегированныйРежим(Ложь);
	#КонецОбласти
	
	// Получим внешний источник данных
	НастройкаПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодОтчета");
	НастройкаПериодичностьОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Периодичность");
	
	Если НастройкаПериодОтчета.Значение.ДатаОкончания > ТекущаяДата() Тогда
		ДатаОкончания = ТекущаяДата();
	Иначе
		ДатаОкончания = НастройкаПериодОтчета.Значение.ДатаОкончания;
	КонецЕсли;
	
	ТаблицаПериодов = МониторингЦелевыхПоказателей.ПолучитьТаблицуПериодов_ДатыНаКонецПериода(НастройкаПериодОтчета.Значение.ДатаНачала,
		ДатаОкончания,
		НастройкаПериодичностьОтчета.Значение);
		
	Если ТаблицаПериодов.Количество() Тогда
		ТаблицаПериодов[ТаблицаПериодов.Количество() - 1].ДатаРасчета = ДатаОкончания;
	КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаПериодов", ТаблицаПериодов);
	
	// Сформируем отчет
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.ВывестиАктуальностьРасчета(ДокументРезультат, ДопСвойства);
	#КонецОбласти
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалют(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	УстановитьПериодОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
КонецПроцедуры

Процедура УстановитьПериодОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	НастройкаПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодОтчета");
	Если ТипЗнч(НастройкаПериодОтчета.Значение) = Тип("СтандартныйПериод") Тогда
		Если НЕ ЗначениеЗаполнено(НастройкаПериодОтчета.Значение.ДатаНачала) Тогда
			НастройкаПериодОтчета.Значение.ДатаНачала = НачалоГода(ТекущаяДата());			
			
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(НастройкаПериодОтчета.Значение.ДатаОкончания) Тогда
			НастройкаПериодОтчета.Значение.ДатаОкончания = КонецГода(ТекущаяДата());			
			
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	Иначе
		Если НЕ ЗначениеЗаполнено(НастройкаПериодОтчета.Значение) Тогда
			ПериодЭтотГод = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотГод);
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета", ПериодЭтотГод);
			
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НастройкаПериодичностьОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Периодичность");
	Если НЕ ЗначениеЗаполнено(НастройкаПериодичностьОтчета.Значение) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Перечисления.Периодичность.Месяц);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Организация");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли