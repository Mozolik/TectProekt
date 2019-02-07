﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();
	
	СтруктураЗамены = Новый Соответствие();
 	СтруктураЗамены.Вставить("Прочие доходы",НСтр("ru='Прочие доходы';uk='Інші доходи'"));
 	СтруктураЗамены.Вставить("Выплата бывшим сотрудникам",НСтр("ru='Выплата бывшим сотрудникам';uk='Виплата колишнім співробітникам'"));
 	СтруктураЗамены.Вставить("Прочее",НСтр("ru='Прочее';uk='Інше'"));
	
	Локализация.ЛокализацияЗапросовСКД(СхемаКомпоновкиДанных, СтруктураЗамены); 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	СтрокаПоиска = "КОГДА ТИПЗНАЧЕНИЯ(НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор) = ТИП(Документ.ВыплатаБывшимСотрудникам)";
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Дивиденды") Тогда
		
		Для каждого НаборДанных Из СхемаКомпоновкиДанных.НаборыДанных Цикл
			
			Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") Тогда
				
				Если СтрНайти(НаборДанных.Запрос, СтрокаПоиска) > 0 Тогда
					
					НаборДанных.Запрос = СтрЗаменить(НаборДанных.Запрос, СтрокаПоиска,
						"КОГДА ТИПЗНАЧЕНИЯ(НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор) = ТИП(Документ.ДивидендыФизическимЛицам)
						|	ТОГДА ""Дивиденды""" + Символы.ПС + СтрокаПоиска);
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

