﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М21") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"М21",
			"Инветаризационная опись",
			СформироватьПечатнуюФормуМ21(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуМ21(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_М21";
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		Если СтруктураОбъектов.Ключ <> "Документ.ИнвентаризационнаяОпись" Тогда 
			ТекстСообщения = НСтр("ru='Формирование печатной формы ""М-21"" доступно только для документов ""%ТипДокумента%"".';uk='Формування друкованої форми ""М-21"" доступно тільки для документів ""%ТипДокумента%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокумента%", Метаданные.Документы.ИнвентаризационнаяОпись.Синоним);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		Для Каждого ДокументОснование Из СтруктураОбъектов.Значение Цикл
			
			НомерДокумента = НомерДокумента + 1;
			Если НомерДокумента > 1 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
						
			ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыМ21(ПараметрыПечати, ДокументОснование);
			Если НЕ ДанныеДляПечати = Неопределено Тогда
				ЗаполнитьТабличныйДокументМ21(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ДокументОснование);
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументМ21(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ИнвентаризационнаяОпись)
	
	ТабличныйДокумент.ПолеСверху = 10;
	ТабличныйДокумент.ПолеСлева = 10;
	ТабличныйДокумент.ПолеСнизу = 10;
	ТабличныйДокумент.ПолеСправа = 10;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ТабличнаяЧасть = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать();
	
	Шапка.Следующий();
	СтруктураРеквизитов = Новый Структура("Дата, Склад");
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шапка.Ссылка, СтруктураРеквизитов);
			
	Если ДанныеДляПечати.РезультатКурсВалюты <> Неопределено Тогда
		КурсВалюты = ДанныеДляПечати.РезультатКурсВалюты.Выбрать();
		Если КурсВалюты.Следующий() Тогда
			КоэффициентПересчета = КурсВалюты.КоэффициентПересчета;
		Иначе
			КоэффициентПересчета = 1;
		КонецЕсли;
	Иначе  
		КоэффициентПересчета = 1;		
	КонецЕсли;
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если ТабличнаяЧасть.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='В рамках периода документа ""%Опись%"" не были оформлены складские акты или не было проведено ни одного пересчета товаров. Нет данных для формирования печатной формы ""М-21""';uk='В рамках періоду документа ""%Опись%"" не були оформлені складські акти чи не було проведено жодного перерахунку товарів. Немає даних для формування друкованої форми ""М-21""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Опись%", ИнвентаризационнаяОпись);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнвентаризационнаяОпись);
		Возврат;
	КонецЕсли;
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьМ21.ПФ_MXL_UK_М21");
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ИнвентаризационнаяОпись.Организация, ИнвентаризационнаяОпись.ДатаОкончания);	
	
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкиТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");     
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОбластьШапки.Параметры.Заполнить(Шапка);
	ОбластьШапки.Параметры.КодПоЕДРПОУ = СведенияОбОрганизации.КодПоЕДРПОУ;
	ОбластьШапки.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.НомерДокумента, Ложь, Истина);
	ОбластьШапки.Параметры.ОснованиеНомер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.ОснованиеНомер, Ложь, Истина);	
	
	ТабличныйДокумент.Вывести(ОбластьШапки);
	ТабличныйДокумент.Вывести(ОбластьШапкиТаблицы);
	НомерСтроки = 0;
	Пока ТабличнаяЧасть.Следующий() Цикл
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтроки.Параметры.Заполнить(ТабличнаяЧасть);
		ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтроки.Параметры.Цена = ТабличнаяЧасть.Цена * КоэффициентПересчета;
		ТабличныйДокумент.Вывести(ОбластьСтроки);
	КонецЦикла;
	
	ОбластьПодвал.Параметры.Заполнить(Шапка);
	ОбластьПодвал.Параметры.КоличествоПорядковыхНомеровПрописью  = ЧислоПрописью(НомерСтроки, "Л=uk; НП=Ложь",",,,,,,,,0");

	ОбластьПодвал.Параметры.НачальныйНомерПоПорядку = 1;
    ОбластьПодвал.Параметры.КонечныйНомерПоПорядку	= НомерСтроки;
		
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
