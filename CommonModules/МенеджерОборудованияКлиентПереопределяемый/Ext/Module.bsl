﻿
#Область ПрограммныйИнтерфейс

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	
	Возврат ТекущаяДата();
	
КонецФункции

// Функция возвращает объект обработчика драйвера по его наименованию.
//
Функция ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер) Экспорт
	
	// Используем универсальный обработчик драйвера по стандарту "1С:Совместимо".
#Если ВебКлиент Тогда
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверАсинхронноКлиент; 
#Иначе
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент;
#КонецЕсли

	// Обработчики драйверов не удовлетворяющие стандарту "1С:Совместимо".
	Если Не ЗагружаемыйДрайвер И ОбработчикДрайвера <> Неопределено Тогда
		
		// Сканеры штрихкода
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудование1ССканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеСканкодСканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеАтолСканерыШтрихкодаКлиент;
		КонецЕсли;
		// Конец Сканеры штрихкода
		
		// Считыватели магнитных карт
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт") Тогда
			Возврат ПодключаемоеОборудование1ССчитывателиМагнитныхКартКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСчитывателиМагнитныхКарт") Тогда
			Возврат ПодключаемоеОборудованиеАтолСчитывателиМагнитныхКартКлиент;
		КонецЕсли;
		// Конец Считыватели магнитных карт.

		// Фискальные регистраторы
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАртСофтФискальныйРегистратор") Тогда
			Возврат ПодключаемоеОборудованиеАртСофтФискальныйРегистратор;
		КонецЕсли;
		// Конец Фискальные регистраторы.
		
		// Дисплеи покупателя
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеАтолДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеСканкодДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеККСДисплеиПокупателяКлиент;
		КонецЕсли;                 
		// Конец Дисплеи покупателя
		
		// Терминалы сбора данных
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеАтолТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканкодТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканситиТерминалыСбораДанныхКлиент;
		КонецЕсли;
		// Конец Терминалы сбора данных.
		
		// Эквайринговые терминалы
		// Конец Эквайринговые терминалы.
		 
		// Электронные весы
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы") Тогда
			Возврат ПодключаемоеОборудованиеАтолЭлектронныеВесыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМЭлектронныеВесы") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМЭлектронныеВесыКлиент;
		КонецЕсли;
		// Конец Электронные весы
		
		// Весы с печатью этикеток
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикACOMВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеACOMВесыСПечатьюЭтикетокКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикScaleCASВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеScaleCASВесыСПечатьюЭтикетокКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМВесыСПечатьюЭтикетокКлиент;
		КонецЕсли;
		// Конец Весы с печатью этикеток.
		
		// ККМ offline
		// Конец ККМ offline
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция формирует шаблон чека.
//
Функция СформироватьШаблонЧека(ВходныеПараметры, ДополнительныйТекст = Неопределено) Экспорт
	
	ТаблицаНоменклатуры = ВходныеПараметры[0];
	ТаблицаОплат        = ВходныеПараметры[1];
	ОбщиеПараметры      = ВходныеПараметры[2];
	
	ТипыЧеков = Новый Соответствие();
	ТипыЧеков.Вставить(0, "ПРОДАЖА"); 
	ТипыЧеков.Вставить(1, "ВОЗВРАТ");
	ТипыЧеков.Вставить(2, "ВНЕСЕНИЕ"); 
	ТипыЧеков.Вставить(3, "ВЫЕМКА");
	ТипыЧеков.Вставить(4, "ОТЧЕТ БЕЗ ГАШЕНИЯ");
	ТипыЧеков.Вставить(5, "ОТЧЕТ С ГАШЕНИЕМ");
	
	// Общие параметры чека
	ПараметрыЧека = Новый Структура();
	ПараметрыЧека.Вставить("ТипЧека"        , ТипыЧеков.Получить(ОбщиеПараметры[0])); 
	ПараметрыЧека.Вставить("ФискальныйЧек"  , ОбщиеПараметры[1]);
	ПараметрыЧека.Вставить("ТекстШапки"     , ?(ОбщиеПараметры.Количество() > 7, ВРег(ОбщиеПараметры[6]), ""));
	ПараметрыЧека.Вставить("ТекстПодвала"   , ?(ОбщиеПараметры.Количество() > 8, ВРег(ОбщиеПараметры[7]), ""));
	ПараметрыЧека.Вставить("НомерЧека"      , ?(ОбщиеПараметры.Количество() > 10, ОбщиеПараметры[9], ""));
	ПараметрыЧека.Вставить("НомерКассы"     , ?(ОбщиеПараметры.Количество() > 11, ОбщиеПараметры[10], ""));
	ПараметрыЧека.Вставить("ДатаВремя"      , ?(ОбщиеПараметры.Количество() > 12, ВРег(ОбщиеПараметры[11]), ""));
	ПараметрыЧека.Вставить("ИмяКассира"     , ?(ОбщиеПараметры.Количество() > 13, ВРег(ОбщиеПараметры[12]), ""));
	ПараметрыЧека.Вставить("ОрганизацияНазвание", ?(ОбщиеПараметры.Количество() > 14, ВРег(ОбщиеПараметры[13]), ""));
	ПараметрыЧека.Вставить("ОрганизацияИНН"     , ?(ОбщиеПараметры.Количество() > 15, ОбщиеПараметры[14], ""));
	
	ТаблицаДопРеквизитов = Новый Массив;
	ТаблицаДопРеквизитов.Добавить(Новый Массив);

	// Формируем позиции чека
	Если ТаблицаНоменклатуры <> Неопределено Тогда
		ПозицииЧека = Новый Массив();
		Для ИндексМассива = 0 По ТаблицаНоменклатуры.Количество() - 1 Цикл
			СтрокаПозицииЧека = Новый Структура();
			СтрокаПозицииЧека.Вставить("ФискальнаяСтрока");
			СтрокаПозицииЧека.Вставить("Наименование", ТаблицаНоменклатуры[ИндексМассива][0].Значение);
			СтрокаПозицииЧека.Вставить("Количество"  , ТаблицаНоменклатуры[ИндексМассива][5].Значение);
			СтрокаПозицииЧека.Вставить("Цена"        , ТаблицаНоменклатуры[ИндексМассива][4].Значение);
			СтрокаПозицииЧека.Вставить("Сумма"       , ТаблицаНоменклатуры[ИндексМассива][9].Значение);
			СтрокаПозицииЧека.Вставить("НомерСекции" , ТаблицаНоменклатуры[ИндексМассива][3].Значение);
			СтрокаПозицииЧека.Вставить("СтавкаНДС"   , ТаблицаНоменклатуры[ИндексМассива][12].Значение);
			
			ТаблицаДопРеквизитов[0].Очистить();
			ТаблицаДопРеквизитов[0].Добавить(ТаблицаНоменклатуры[ИндексМассива][17].Значение);
			ТаблицаДопРеквизитов[0].Добавить(ТаблицаНоменклатуры[ИндексМассива][18].Значение);
			ДопРеквизиты = МенеджерОборудованияВызовСервера.СформироватьТаблицуДопРеквизитов(ТаблицаДопРеквизитов);
			
			СтрокаПозицииЧека.Вставить("ДопРеквизиты", ДопРеквизиты);
			ПозицииЧека.Добавить(СтрокаПозицииЧека);
		КонецЦикла;
	Иначе
		ПозицииЧека = Неопределено;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ДополнительныйТекст) Тогда
		Если ПозицииЧека = Неопределено Тогда
			ПозицииЧека = Новый Массив();
		КонецЕсли;
		СтрокаПозицииЧека = Новый Структура();
		СтрокаПозицииЧека.Вставить("ТекстоваяСтрока");
		СтрокаПозицииЧека.Вставить("Текст",  ДополнительныйТекст);
		ПозицииЧека.Добавить(СтрокаПозицииЧека);
	КонецЕсли;
	
	// Формируем таблицу оплат.
	Если ТаблицаОплат <> Неопределено Тогда
		ОплатаЧека = Новый Массив();
		Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
			СтрокаОплаты = Новый Структура();
			СтрокаОплаты.Вставить("ТипОплаты"   , ТаблицаОплат[ИндексОплаты][0].Значение);
			СтрокаОплаты.Вставить("Сумма"       , ТаблицаОплат[ИндексОплаты][1].Значение);
			СтрокаОплаты.Вставить("Наименование", ТаблицаОплат[ИндексОплаты][2].Значение);
			ОплатаЧека.Добавить(СтрокаОплаты);
		КонецЦикла; 
	Иначе
		ТаблицаОплат = Неопределено;
	КонецЕсли;
	
	// Подготовка данных.
	ШаблонЧека  = Новый Массив();
	ШаблонЧека.Добавить(ПараметрыЧека);
	ШаблонЧека.Добавить(ПозицииЧека);
	ШаблонЧека.Добавить(ОплатаЧека);
	
	Возврат ШаблонЧека;
	
КонецФункции

// Функция формирует текст нефискального чека по шаблону.
//
Функция СформироватьТексНефискальногоЧека(ШиринаСтроки, ОбщиеПараметры, ПозицииЧека, ТаблицаОплат) Экспорт
	
	Разделитель = МенеджерОборудованияКлиент.ПостроитьПоле("", ШиринаСтроки, "=") + Символы.ПС;
	РазделительВнут = МенеджерОборудованияКлиент.ПостроитьПоле("", ШиринаСтроки, "-") + Символы.ПС;
	
	// Сформировать шапку чека.
	Текст = Разделитель;
	Если ОбщиеПараметры.Свойство("ОрганизацияНазвание") И НЕ ПустаяСтрока(ОбщиеПараметры.ОрганизацияНазвание) Тогда
		Текст = Текст + МенеджерОборудованияКлиент.ВыстроитьПоля(ОбщиеПараметры.ОрганизацияНазвание, , ШиринаСтроки) + Символы.ПС;
	КонецЕсли;
	
	Если ОбщиеПараметры.Свойство("ТекстШапки") И НЕ ПустаяСтрока(ОбщиеПараметры.ТекстШапки) Тогда
		Текст = Текст + МенеджерОборудованияКлиент.ВыстроитьПоля(ОбщиеПараметры.ТекстШапки, , ШиринаСтроки) + Символы.ПС;
	КонецЕсли;
	
	НомерКассы = ?(ОбщиеПараметры.Свойство("НомерКассы") И НЕ ПустаяСтрока(ОбщиеПараметры.НомерКассы), 
		НСтр("ru='КАССА';uk='КАСА'") + Символы.НПП + ОбщиеПараметры.НомерКассы, "");
	
	ОрганизацияИНН = ?(ОбщиеПараметры.Свойство("ОрганизацияИНН") И НЕ ПустаяСтрока(ОбщиеПараметры.ОрганизацияИНН), 
		НСтр("ru='ИНН';uk='ІПН'") + Символы.НПП + ОбщиеПараметры.ОрганизацияИНН, "");
	
	Если Не ПустаяСтрока(НомерКассы) Или НЕ ПустаяСтрока(ОрганизацияИНН) Тогда
		Текст = Текст + МенеджерОборудованияКлиент.ВыстроитьПоля(НомерКассы, ОрганизацияИНН, ШиринаСтроки) + Символы.ПС;
	КонецЕсли;
	
	НомерЧека = ?(ОбщиеПараметры.Свойство("НомерЧека") И НЕ ПустаяСтрока(ОбщиеПараметры.НомерЧека),
		НСтр("ru='ЧЕК №';uk='ЧЕК №'") + ОбщиеПараметры.НомерЧека, "");
	Если Не ПустаяСтрока(НомерЧека) Тогда
		Текст = Текст + МенеджерОборудованияКлиент.ВыстроитьПоля(ОбщиеПараметры.ТипЧека, НомерЧека, ШиринаСтроки) + Символы.ПС;
	Иначе
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(ОбщиеПараметры.ТипЧека, ШиринаСтроки) + Символы.ПС;
	КонецЕсли;
	
	ДатаВремя = ?(ОбщиеПараметры.Свойство("ДатаВремя") И НЕ ПустаяСтрока(ОбщиеПараметры.ДатаВремя), ОбщиеПараметры.ДатаВремя, ТекущаяДата());
	ДатаВремя = Формат(ДатаВремя, "ДФ=""дд.ММ.гггг ЧЧ:мм""");
	Если Не ПустаяСтрока(ДатаВремя) Тогда
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(ДатаВремя, ШиринаСтроки, , Ложь) + Символы.ПС;
	КонецЕсли;
	
	Текст = Текст + РазделительВнут;
	
	ФорматЧисла = "ЧРД=,;ЧЦ=10;ЧДЦ=2;ЧН=0,00;ЧГ=0";
	СуммаЧека = 0;
	
	// Формируем строки чека.
	Если ПозицииЧека <> Неопределено Тогда
		
		Для ИндексМассива = 0 По ПозицииЧека.Количество() - 1 Цикл
			
			ПозицияЧека = ПозицииЧека[ИндексМассива];
			
			Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
				Наименование = ?(ПозицияЧека.Свойство("Наименование"), ПозицияЧека.Наименование, "");
				Количество   = ?(ПозицияЧека.Свойство("Количество")  , ПозицияЧека.Количество  , 1);
				Цена         = ?(ПозицияЧека.Свойство("Цена")        , ПозицияЧека.Цена        , 0);
				Сумма        = ?(ПозицияЧека.Свойство("Сумма")       , ПозицияЧека.Сумма       , 0);
				НомерСекции  = ?(ПозицияЧека.Свойство("НомерСекции") , ПозицияЧека.НомерСекции , 0);
				СтавкаНДС    = ?(ПозицияЧека.Свойство("СтавкаНДС")   , ПозицияЧека.СтавкаНДС   , 0);
				
				ТекстСтроки  = МенеджерОборудованияКлиент.ПостроитьПолеПереносом(Наименование, ШиринаСтроки) + Символы.ПС;
				СтрокаТовара = Формат(Количество, "ЧРД=,;ЧЦ=10;ЧДЦ=3;ЧН=0,000;ЧГ=0") + " х " + Формат(Цена, ФорматЧисла) 
					+ " = " + Формат(Количество * Цена, ФорматЧисла) + Символы.ПС;
				ТекстСтроки = ТекстСтроки + МенеджерОборудованияКлиент.ПостроитьПоле(СтрокаТовара, ШиринаСтроки, , Ложь);
				Если Окр(Количество * Цена, 2) > Сумма Тогда
					ТекстСтроки = ТекстСтроки + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='СКИДКА =';uk='ЗНИЖКА ='") + Символы.НПП
									+ Формат(Количество * Цена - Сумма, ФорматЧисла) + " ", ШиринаСтроки, , Ложь)  + Символы.ПС;
				ИначеЕсли Окр(Количество * Цена, 2) < Сумма Тогда
					ТекстСтроки = ТекстСтроки + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='НАДБАВКА =';uk='НАДБАВКА ='") + Символы.НПП
									+ Формат(Сумма - Количество * Цена, ФорматЧисла) + " ", ШиринаСтроки, , Ложь) + Символы.ПС;
				КонецЕсли;
				Текст = Текст + ТекстСтроки;
				СуммаЧека = СуммаЧека + Сумма;
			ИначеЕсли ПозицияЧека.Свойство("ТекстоваяСтрока") Тогда
				ТекстСтроки = ?(ПозицияЧека.Свойство("Текст"), ПозицияЧека.Текст, "");
				Текст = Текст + ТекстСтроки + Символы.ПС;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Формируем подвал чека
	Если ТаблицаОплат <> Неопределено Тогда
		СуммаНаличнойОплаты     = 0;
		СуммаБезналичнойОплаты1 = 0;
		СуммаБезналичнойОплаты2 = 0;
		СуммаБезналичнойОплаты3 = 0;
		Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
			Если ТаблицаОплат[ИндексОплаты].ТипОплаты = 0 Тогда
				СуммаНаличнойОплаты = СуммаНаличнойОплаты + ТаблицаОплат[ИндексОплаты].Сумма;
			ИначеЕсли ТаблицаОплат[ИндексОплаты].ТипОплаты = 1 Тогда
				СуммаБезналичнойОплаты1 = СуммаБезналичнойОплаты1 + ТаблицаОплат[ИндексОплаты].Сумма;
			ИначеЕсли ТаблицаОплат[ИндексОплаты].ТипОплаты = 2 Тогда
				СуммаБезналичнойОплаты2 = СуммаБезналичнойОплаты2 + ТаблицаОплат[ИндексОплаты].Сумма;
			Иначе
				СуммаБезналичнойОплаты3 = СуммаБезналичнойОплаты3 + ТаблицаОплат[ИндексОплаты].Сумма;
			КонецЕсли;
		КонецЦикла;
		СуммаОплаты = СуммаНаличнойОплаты + СуммаБезналичнойОплаты1 + СуммаБезналичнойОплаты2 + СуммаБезналичнойОплаты3;
	
		Текст = Текст + РазделительВнут;
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='ИТОГ =';uk='ПІДСУМОК ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаЧека, ФорматЧисла) + Символы.ПС;
		Текст = Текст + РазделительВнут;
		
		Если СуммаНаличнойОплаты > 0 Тогда
			Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='НАЛИЧНЫМИ =';uk='ГОТІВКОЮ ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаНаличнойОплаты, ФорматЧисла) + Символы.ПС;
		КонецЕсли;
		Если СуммаБезналичнойОплаты1 > 0 Тогда
			Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='ПЛАТ.КАРТОЙ =';uk='ПЛАТ.КАРТОЮ ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаБезналичнойОплаты1, ФорматЧисла) + Символы.ПС;
		КонецЕсли;
		Если СуммаБезналичнойОплаты2 > 0 Тогда
			Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='КРЕДИТОМ =';uk='КРЕДИТОМ ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаБезналичнойОплаты2, ФорматЧисла) + Символы.ПС;
		КонецЕсли;
		Если СуммаБезналичнойОплаты3 > 0 Тогда
			Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='СЕРТИФИКАТОМ =';uk='СЕРТИФІКАТОМ ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаБезналичнойОплаты3, ФорматЧисла) + Символы.ПС;
		КонецЕсли;          
		
		Текст = Текст + РазделительВнут;
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru='СДАЧА =';uk='ЗДАЧА ='"), 16, ,Ложь) + Символы.НПП + Формат(СуммаОплаты - СуммаЧека, ФорматЧисла) + Символы.ПС;
		Текст = Текст + РазделительВнут;
		
		ИмяКассира = ?(ОбщиеПараметры.Свойство("ИмяКассира"), ОбщиеПараметры.ИмяКассира, "");
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле(НСтр("ru=' КАССИР:';uk=' КАСИР:'") + Символы.НПП + ИмяКассира, ШиринаСтроки) + Символы.ПС;                        
		Текст = Текст + МенеджерОборудованияКлиент.ПостроитьПоле("ПОДПИСЬ:", ШиринаСтроки, "_") + Символы.ПС + Символы.ПС;
		
		Если ОбщиеПараметры.Свойство("ТекстПодвала") И НЕ ПустаяСтрока(ОбщиеПараметры.ТекстПодвала) Тогда
			Текст = Текст + МенеджерОборудованияКлиент.ВыстроитьПоля(ОбщиеПараметры.ТекстПодвала, , ШиринаСтроки) + Символы.ПС;
		КонецЕсли;
	
	КонецЕсли;
	
	Текст = Текст + Разделитель;
	
	Возврат Текст;
	
КонецФункции

// Осуществляет печать чека по шаблону.
//
Функция ПечатьЧекаПоШаблону(ОбщийМодульОборудования, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
	Результат  = Истина;
	
	ОбщиеПараметры = ВходныеПараметры[0];
	ПозицииЧека    = ВходныеПараметры[1];
	ТаблицаОплат   = ВходныеПараметры[2];

	ФискальныйЧек = ?(ОбщиеПараметры.Свойство("ФискальныйЧек"), ОбщиеПараметры.ФискальныйЧек, Ложь);
	ТипЧека =  ?(ОбщиеПараметры.Свойство("ТипЧека"), ?(ВРег(ОбщиеПараметры.ТипЧека) = "ПРОДАЖА", Ложь, Истина), Ложь);
	
	// Открываем чек
	Результат = ОбщийМодульОборудования.ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипЧека, ФискальныйЧек, ВыходныеПараметры);
	
	// Печатаем строки чека   
	Если Результат Тогда
		
		ОшибкаПриПечати = Ложь;
		
		// Печатаем позиции чека
		Для ИндексМассива = 0 По ПозицииЧека.Количество() - 1 Цикл
			
			ПозицияЧека = ПозицииЧека[ИндексМассива];
			
			Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
				
				Наименование  = ?(ПозицияЧека.Свойство("Наименование") , ПозицияЧека.Наименование, "");
				Количество    = ?(ПозицияЧека.Свойство("Количество")   , ПозицияЧека.Количество  , 1);
				Цена          = ?(ПозицияЧека.Свойство("Цена")         , ПозицияЧека.Цена        , 0);
				Сумма         = ?(ПозицияЧека.Свойство("Сумма")        , ПозицияЧека.Сумма       , 0);
				НомерСекции   = ?(ПозицияЧека.Свойство("НомерСекции")  , ПозицияЧека.НомерСекции , 0);
				СтавкаНДС     = ?(ПозицияЧека.Свойство("СтавкаНДС")    , ПозицияЧека.СтавкаНДС   , 0);
				ДопРеквизиты  = ?(ПозицияЧека.Свойство("ДопРеквизиты") , ПозицияЧека.ДопРеквизиты, 0);
				Если НЕ ОбщийМодульОборудования.НапечататьФискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
									Наименование, Количество, Цена, Сумма, НомерСекции, СтавкаНДС, ДопРеквизиты, ВыходныеПараметры) Тогда
					ОшибкаПриПечати = Истина;   
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ПозицияЧека.Свойство("ТекстоваяСтрока") Тогда
				
				Текст = ?(ПозицияЧека.Свойство("Текст"), ПозицияЧека.Текст, "");
				Если НЕ ОбщийМодульОборудования.НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
											Текст, ВыходныеПараметры) Тогда
					ОшибкаПриПечати = Истина;   
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ПозицияЧека.Свойство("Штрихкод") Тогда
				
				ВремВыходныеПараметры = Новый Массив();
				ТипШтрихКода2 = ?(ПозицияЧека.Свойство("ТипШтрихКода"), ПозицияЧека.ТипШтрихКода, "");
				ШтрихКод     = ?(ПозицияЧека.Свойство("ШтрихКод")    , ПозицияЧека.ШтрихКод    , "");
				Если НЕ ОбщийМодульОборудования.ПечатьШтрихкода(ОбъектДрайвера, Параметры, ПараметрыПодключения,
											ТипШтрихКода2, ШтрихКод, ВремВыходныеПараметры) Тогда
					Текст = НСтр("ru='<Штрихкод %ТипШтрихКода% не распечатан>';uk='<Штрихкод %ТипШтрихКода% не роздрукований>'");
					Текст = СтрЗаменить(Текст, "%ТипШтрихКода%", ТипШтрихКода2);
					Если НЕ ОбщийМодульОборудования.НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
						Текст, ВремВыходныеПараметры) Тогда
						ОшибкаПриПечати = Истина;   
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
			
		Если НЕ ОшибкаПриПечати Тогда
		  	// Закрываем чек
			ТаблицаОплатЧека = Новый Массив();
			Если ТаблицаОплат <> Неопределено Тогда
				Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
					СтрокаОплаты = Новый СписокЗначений();
					СтрокаОплаты.Добавить(ТаблицаОплат[ИндексОплаты].ТипОплаты);
					СтрокаОплаты.Добавить(ТаблицаОплат[ИндексОплаты].Сумма);
					СтрокаОплаты.Добавить(ТаблицаОплат[ИндексОплаты].Наименование);
					СтрокаОплаты.Добавить("");
					ТаблицаОплатЧека.Добавить(СтрокаОплаты);
				КонецЦикла;
			КонецЕсли;
			Результат = ОбщийМодульОборудования.ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплатЧека, ВыходныеПараметры);
		Иначе
			Результат = Ложь;
		КонецЕсли;
			
		КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Осуществляет печать фискального чека.
//
Функция ПечатьЧека(ОбщийМодульОборудования, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
	ШаблонЧека = СформироватьШаблонЧека(ВходныеПараметры);
	Возврат ПечатьЧекаПоШаблону(ОбщийМодульОборудования, ОбъектДрайвера, Параметры, ПараметрыПодключения, ШаблонЧека, ВыходныеПараметры);
	
КонецФункции

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриОткрытии".
//
Процедура ЭкземплярОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗакрытием".
//
Процедура ЭкземплярОборудованияПередЗакрытием(Объект, ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписью".
//
Процедура ЭкземплярОборудованияПередЗаписью(Объект, ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписи".
//
Процедура ЭкземплярОборудованияПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ТипОборудованияОбработкаВыбора".
//
Процедура ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодключенияОтключенияОборудования

// Начать подключение необходимых типов оборудования при открытии формы.
//
// Параметры:
// Форма - УправляемаяФорма
// ПоддерживаемыеТипыПодключаемогоОборудования - Строка
//  Содержит перечень типов подключаемого оборудования, разделенных запятыми.
//
Процедура НачатьПодключениеОборудованиеПриОткрытииФормы(Форма, ПоддерживаемыеТипыПодключаемогоОборудования) Экспорт
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", МенеджерОборудованияКлиентПереопределяемый);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		Форма,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".';uk='При підключенні устаткування виникла помилка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

// Начать отключать оборудование по типу при закрытии формы.
//
Процедура НачатьОтключениеОборудованиеПриЗакрытииФормы(Форма) Экспорт
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", МенеджерОборудованияКлиентПереопределяемый); 
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, Форма);
	
КонецПроцедуры

Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".';uk='При відключенні обладнання сталася помилка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция ОборудованиеПодключено(ИдентификаторУстройства) Экспорт
	
	ПодключенноеУстройство = МенеджерОборудованияКлиент.ПолучитьПодключенноеУстройство(глПодключаемоеОборудование.ПараметрыПодключенияПО, ИдентификаторУстройства);

	Если ПодключенноеУстройство = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ЕстьНеобработанноеСобытие() Экспорт
	
	Возврат (глПодключаемоеОборудованиеСобытиеОбработано = Ложь);
	
КонецФункции

Процедура ОбработатьСобытие() Экспорт
	
	глПодключаемоеОборудованиеСобытиеОбработано = Истина;
	
КонецПроцедуры

Процедура СообщитьОбОшибке(РезультатВыполнения) Экспорт
	
	ТекстСообщения = НСтр("ru='При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".';uk='При виконанні операції виникла помилка:""%ОписаниеОшибки%"".'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти
