﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОтразитьЗатратыПо8и9КлассуСчетов(Проводки) Экспорт

	КвоПроводок    = Проводки.Количество();
	КвоДобавленных = 0;
	
	СтруктураПараметров = Новый Структура;
	
	Для К = 1 По КвоПроводок Цикл
		
		Индекс = К - 1 + КвоДобавленных;
		Проводка = Проводки[Индекс];
		
		Если ПровестиПоЗатратам(Проводки, Проводка, Индекс, СтруктураПараметров) Тогда
			КвоДобавленных = КвоДобавленных + 1;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ПровестиЛокализациюСодержания(Проводки) Экспорт
	
	КодЯзыка = ЛокализацияПовтИсп.КодЯзыкаИнформационнойБазы();
	Если КодЯзыка = "ru" Тогда
	    Возврат;
	КонецЕсли;
	Для Каждого Проводка Из Проводки Цикл
		
		Если ПустаяСтрока(Проводка.Содержание) Тогда
			Продолжить;
		КонецЕсли;
		СодержаниеЛок = ЛокализацияПовтИсп.ПолучитьЛокализованноеСодержаниеПроводки(Проводка.Содержание,КодЯзыка);
		Если НЕ ПустаяСтрока(СодержаниеЛок) Тогда
			Проводка.Содержание = СодержаниеЛок;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


Функция СчетВИерархииВМассиве(Счет, Эталон)

	Результат = Ложь;
	Если ЗначениеЗаполнено(Счет) Тогда
		Если ТипЗнч(Эталон) = Тип("Массив") Тогда
			Для каждого СчетЭталон Из Эталон Цикл
				Если БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(Счет, СчетЭталон) Тогда
					Результат = Истина;
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		Иначе	
			Результат = БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(Счет, Эталон);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Функция ПровестиПоЗатратам(Проводки, Проводка, Индекс, СтруктураПараметров)
	
	Организация = Проводка.Организация;
	
	Если СтруктураПараметров.Свойство("СоответствиеИспользуемыеКлассыСчетовРасходов") = Истина Тогда
		СоответствиеИспользуемыеКлассыСчетовРасходов = СтруктураПараметров.СоответствиеИспользуемыеКлассыСчетовРасходов;
		ИспользуемыеКлассыСчетовРасходов = СоответствиеИспользуемыеКлассыСчетовРасходов[Организация];
		Если ИспользуемыеКлассыСчетовРасходов = Неопределено Тогда
			ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Организация, Проводка.Период);
			СоответствиеИспользуемыеКлассыСчетовРасходов.Вставить(Организация, ИспользуемыеКлассыСчетовРасходов);
		КонецЕсли;
	Иначе	
		СтруктураПараметров.Вставить("СоответствиеИспользуемыеКлассыСчетовРасходов", Новый Соответствие);
		СоответствиеИспользуемыеКлассыСчетовРасходов = СтруктураПараметров.СоответствиеИспользуемыеКлассыСчетовРасходов;
		ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Организация, Проводка.Период);
		СоответствиеИспользуемыеКлассыСчетовРасходов.Вставить(Организация, ИспользуемыеКлассыСчетовРасходов);
	КонецЕсли; 

	Если СтруктураПараметров.Свойство("СоответствиеНужноДелитьПроводку") = Ложь Тогда
		СтруктураПараметров.Вставить("СоответствиеНужноДелитьПроводку", Новый Соответствие);
	КонецЕсли;
	СоответствиеНужноДелитьПроводку = СтруктураПараметров.СоответствиеНужноДелитьПроводку;
	
	Если СтруктураПараметров.Свойство("ИспользоватьКлассыСчетовВКачествеГрупп") = Ложь Тогда
		СтруктураПараметров.Вставить("ИспользоватьКлассыСчетовВКачествеГрупп", Истина);
	КонецЕсли;
	ИспользоватьКлассыСчетовВКачествеГрупп = СтруктураПараметров.ИспользоватьКлассыСчетовВКачествеГрупп;
	
	КлассыСчетов = Перечисления.КлассыСчетовРасходов;
	
	Если ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс9 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СчетДт         = Проводка.СчетДт;
	СчетДтСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
	
	СчетКт         = Проводка.СчетКт;
	СчетКтСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
	
	Ключ = Строка(СчетДт) + "|" + Строка(СчетКт) + "|" + Строка(ИспользуемыеКлассыСчетовРасходов);
	//Проверм, не определяли ли мы уже для этого сочетания параметров
	СтруктураЗначение = СоответствиеНужноДелитьПроводку[Ключ];
	Если СтруктураЗначение = Неопределено Тогда
	
		СчетЗатратыБудущихПериодов 	= ПланыСчетов.Хозрасчетный.ЗатратыБудущихПериодов;
		СчетПолуфабрикаты 			= ПланыСчетов.Хозрасчетный.Полуфабрикаты;
		СчетГотоваяПродукция 		= ПланыСчетов.Хозрасчетный.ГотоваяПродукция;
		СчетПроизводство 			= ПланыСчетов.Хозрасчетный.Производство;
		СчетБракВПроизводстве 		= ПланыСчетов.Хозрасчетный.БракВПроизводстве;
		СчетСебестоимостьРеализации = ПланыСчетов.Хозрасчетный.СебестоимостьРеализации;
		СчетСебестоимостьРеализованныхПроизводственныхЗапасов = ПланыСчетов.Хозрасчетный.СебестоимостьРеализованныхПроизводственныхЗапасов;
		
		Если ИспользоватьКлассыСчетовВКачествеГрупп Тогда
			СчетЗатратыПоЭлементам 		= ПланыСчетов.Хозрасчетный.ЗатратыПоЭлементам;
			СчетЗатратыДеятельности 	= ПланыСчетов.Хозрасчетный.ЗатратыДеятельности;
			
		Иначе
			СчетЗатратыПоЭлементам	= Новый Массив;
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.Амортизация);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты);
			СчетЗатратыПоЭлементам.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам);
			
			СчетЗатратыДеятельности	= Новый Массив;
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности);
			СчетЗатратыДеятельности.Добавить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль);
		
		КонецЕсли;
		
		
		СчетДругиеЗатратыПоЭлементам = ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам;
		
		Если    // Счет дебета не указан
			    СчетДт.Пустая()
				// Счет кредита не указан
			ИЛИ СчетКт.Пустая()
			    // Списание на затраты будущих периодов
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетЗатратыБудущихПериодов)
				// Себестоимость реализации 
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетСебестоимостьРеализации)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетСебестоимостьРеализованныхПроизводственныхЗапасов)
				// Списание полуфабриката на затраты 
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетПолуфабрикаты)
			    // Списание продукции на затраты
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетГотоваяПродукция)
			    // Списание затрат из производства в производство или на брак (перераспределение затрат)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетПроизводство)
			    // Списание затрат на брак в производство или на брак (перераспределение затрат)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетБракВПроизводстве) 
			    // Списание со счета 8 класса
			ИЛИ СчетВИерархииВМассиве(СчетКт, СчетЗатратыПоЭлементам)
			    // Списание со счета 9 класса
			ИЛИ СчетВИерархииВМассиве(СчетКт, СчетЗатратыДеятельности)
			    // проводка только по налоговому учету
			ИЛИ ( БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, ПланыСчетов.Хозрасчетный.Вспомогательный)
			     И Проводка.Сумма = 0) Тогда
			
			ИзменятьПроводку = Ложь;
			ДелитьПроводку   = Ложь;
			
		Иначе
			
			ИзменятьПроводку = Ложь;
			ДелитьПроводку   = Ложь;
			
			Если СчетВИерархииВМассиве(СчетДт, СчетЗатратыДеятельности)
				И (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9
				  ИЛИ  ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8)  Тогда
				// Списание на счета 9 класса
				ИзменятьПроводку = Истина;
				ДелитьПроводку   = (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9);
			КонецЕсли;
			
			Если (БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетПроизводство) ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетДт, СчетБракВПроизводстве))
				И (ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9 ИЛИ  ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8)  Тогда
				// Списание на счета 23 или 24 и используется 8 класс или 8 и 9 классы одновременно
				ИзменятьПроводку = Истина;
				ДелитьПроводку   = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		//Для того чтобы во второй раз не проверять, запишем в соответсвие результат проверки
		СтруктураЗначение = Новый Структура("ИзменятьПроводку,ДелитьПроводку",ИзменятьПроводку,ДелитьПроводку);
	    СоответствиеНужноДелитьПроводку.Вставить(Ключ, СтруктураЗначение);
		
	КонецЕсли;
	
	ИзменятьПроводку = СтруктураЗначение.ИзменятьПроводку;
	ДелитьПроводку   = СтруктураЗначение.ДелитьПроводку;
	
	Если НЕ ИзменятьПроводку Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТипСтатьиРасходов = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов");
	ЕстьСчет8Класса = Ложь;
	
	Для К = 1 По СчетДтСвойства.КоличествоСубконто Цикл
		
		
		Если БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСубконтоСтатьиЗатрат(СчетДтСвойства["ВидСубконто"+К]) Тогда
			//Субконто составного типа
			ЗначениеСубконтоСтатьиРасходов = Проводка.СубконтоДт[СчетДтСвойства["ВидСубконто"+К]];
			Если НЕ ТипЗнч(ЗначениеСубконтоСтатьиРасходов) = ТипСтатьиРасходов Тогда
				ЗначениеСубконтоСтатьиРасходов = Неопределено
			КонецЕсли; 
		КонецЕсли;
		Если СчетДтСвойства["ВидСубконто"+К] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ТипыЗатрат Тогда
			ЗначениеСубконтоТипыЗатрат = Проводка.СубконтоДт[СчетДтСвойства["ВидСубконто"+К]];
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ЗначениеСубконтоСтатьиРасходов) Тогда
		Счет8Класса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеСубконтоСтатьиРасходов, "СчетУчета8Класс");
	ИначеЕсли ЗначениеЗаполнено(ЗначениеСубконтоТипыЗатрат) Тогда
		Счет8Класса = БухгалтерскийУчетВызовСервераПовтИсп.Счет8КлассаПоТипуЗатрат(ЗначениеСубконтоТипыЗатрат);
	Иначе
		Счет8Класса = Неопределено;
	КонецЕсли;
	
	СчетДругиеЗатратыПоЭлементам = ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам;
	
	Если    НЕ ЗначениеЗаполнено(Счет8Класса)
		ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетКт, СчетДругиеЗатратыПоЭлементам)
		    И ИспользуемыеКлассыСчетовРасходов = КлассыСчетов.Класс8и9 Тогда
		// Счет неопределен или это 85 счет и используются 8 и 9 классы одновременно
		ЕстьСчет8Класса = Ложь;
	Иначе
		ЕстьСчет8Класса = Истина;
		Счет8КлассаСвойства = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет8Класса);
	КонецЕсли;
	
		
	Если НЕ ЕстьСчет8Класса Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ДелитьПроводку Тогда
		// новая проводка
		НоваяПроводка = Проводки.Вставить(Индекс);
		
		ЗаполнитьЗначенияСвойств(НоваяПроводка, Проводка);
		Для К = 1 По СчетКтСвойства.КоличествоСубконто Цикл
			НоваяПроводка.СубконтоКт[СчетКтСвойства["ВидСубконто"+К]] = Проводка.СубконтоКт[СчетКтСвойства["ВидСубконто"+К]];
		КонецЦикла;
		НоваяПроводка.СчетДт = Счет8Класса;
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			НоваяПроводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]] = Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]];
		КонецЦикла;
		
		// исправим кредитовую сторону проводки
		Проводка.СчетКт             = Счет8Класса;
		Проводка.СубконтоКт.Очистить();
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			Проводка.СубконтоКт[Счет8КлассаСвойства["ВидСубконто"+К]] = Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]];
		КонецЦикла; 		
		Проводка.ВалютаКт        = Проводка.ВалютаДт;
		Проводка.ВалютнаяСуммаКт = Проводка.ВалютнаяСуммаДт;
		Проводка.КоличествоКт    = Проводка.КоличествоДт;
		Проводка.НаправлениеДеятельностиКт = Проводка.НаправлениеДеятельностиДт;
		Проводка.ПодразделениеКт = Проводка.ПодразделениеДт;
		
		Проводка.НалоговоеНазначениеКт = Проводка.НалоговоеНазначениеДт;
		Проводка.СуммаНУКт = Проводка.СуммаНУДт;
		
		
		Возврат Истина;
		
	Иначе
		// исправим дебетовый счет проводки
		Проводка.СчетДт = Счет8Класса;
		СоответсвиеСубконто = Новый Соответствие;
		Для К = 1 По СчетДтСвойства.КоличествоСубконто Цикл
			СоответсвиеСубконто.Вставить(СчетДтСвойства["ВидСубконто"+К], Проводка.СубконтоДт[СчетДтСвойства["ВидСубконто"+К]]);
		КонецЦикла;
		Проводка.СубконтоДт.Очистить();
		Для К = 1 По Счет8КлассаСвойства.КоличествоСубконто Цикл
			Проводка.СубконтоДт[Счет8КлассаСвойства["ВидСубконто"+К]] = СоответсвиеСубконто.Получить(Счет8КлассаСвойства["ВидСубконто"+К]);
		КонецЦикла; 		
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции // ПровестиПоЗатратам()


#КонецОбласти

#КонецЕсли