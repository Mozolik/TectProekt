﻿// Возвращает код языка интерфейса в формате ru/uk
Функция КодЯзыкаИнтерфейса() Экспорт
	Возврат ЛокализацияПовтИсп.КодЯзыкаИнтерфейса();
КонецФункции // КодЯзыкаИнтерфейса()

// Возвращает код языка информационной базы, который указан 
// в региональных настройках (в конфигураторе)
Функция КодЯзыкаИнформационнойБазы() Экспорт
	Возврат ЛокализацияПовтИсп.КодЯзыкаИнформационнойБазы();
КонецФункции //КодЯзыкаИнформационнойБазы()

// Функция возвращает имя языка для формирования нерегламент печатных форм
// документов и некоторых справочников с учетом установленного режима в настройках
// пользователя. По-умолчанию это язык информционной базы.
//
// Параметры
//
// Возвращаемое значение:
//		Строка   – код языка
//
Функция ПолучитьЯзыкФормированияПечатныхФорм() Экспорт
	Возврат ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФорм();
КонецФункции // ПолучитьЯзыкФормированияПечатныхФорм()

// Преобразует код языка в формат понятный системной фунции Формат()
// Параметры
//  КодЯзыка  	 – Строка – код языка в формате uk/ru
//
// Возвращаемое значение:
//   Строка   	 – код языка в формате ru_RU/uk_UA
//
Функция ОпределитьКодЯзыкаДляФормат(КодЯзыка) Экспорт
	Возврат ЛокализацияПовтИсп.ОпределитьКодЯзыкаДляФормат(КодЯзыка);
КонецФункции // ОпределитьКодЯзыкаДляФормат()

// Функция Формат() на языке интерфейса
// Параметры
//  Значение  	 – Число;Дата;Булево - Форматируемое значение.
//  ФорматнаяСтрока - аналогично функции Формат()
// Возвращаемое значение:
//   Строка   	 – строка, полученная в результате форматирования переданного значения
//
Функция ФорматДляИнтерфейса(Значение,ФорматнаяСтрока) Экспорт

	КодЯзыкаДляФормат = ЛокализацияПовтИсп.ОпределитьКодЯзыкаДляФормат();
	
	Если ЗначениеЗаполнено(ФорматнаяСтрока) Тогда
		ФорматнаяСтрока = ФорматнаяСтрока + ";Л="+КодЯзыкаДляФормат;
	Иначе	
		ФорматнаяСтрока = ФорматнаяСтрока + "Л="+КодЯзыкаДляФормат;
	КонецЕсли; 
	
	Возврат Формат(Значение,ФорматнаяСтрока);

КонецФункции // ФорматЛокализованный()
 
 

// По коду языка возвращает строку параметров прописи из справочника Валюты 
//(ПараметрыПрописиНаРусском или ПараметрыПрописиНаУкраинском).
Функция ПараметрыПрописи(Валюта, КодЯзыка) Экспорт
	Возврат ЛокализацияПовтИсп.ПараметрыПрописи(Валюта, КодЯзыка);
КонецФункции // ПараметрыПрописи()

// Возвращает представление объекта на указанном языке
// Фактически обрабатываются документы и перечисления
// Параметры
//  Ссылка    – <произвольный>
//  КодЯзыка  – <строка> – код языка
//
// Возвращаемое значение:
//   <Строка>   – представление объекта
//
Функция ПолучитьЛокализованноеПредставление(Ссылка, КодЯзыка, УдалитьТолькоЛидирующиеНулиИзНомераОбъекта = Ложь) Экспорт	

	ТипЗначенияСсылки = ТипЗнч(Ссылка);
	
	Если Ссылка = Неопределено ИЛИ Ссылка = NULL Тогда
		
		Возврат "";
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗначенияСсылки) Тогда
		
		Возврат ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
					Ссылка, 
					ПолучитьЛокализованныйСинонимОбъекта(Ссылка, КодЯзыка), 
					КодЯзыка,
					УдалитьТолькоЛидирующиеНулиИзНомераОбъекта
					);
		
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначенияСсылки) Тогда

		Возврат ПолучитьЛокализованныйСинонимОбъекта(Ссылка, КодЯзыка);
		
	Иначе
		
		Возврат Строка(Ссылка);
		
	КонецЕсли;	
	
КонецФункции // ПолучитьЛокализованноеПредставление()

// Если параметр КодЯзыка совпадает с кодом языка интерфейса,
// то представление получается через ОбъектМетаданных.Представление()
// Если не совпадает, то возвращаются синонимы в зависимости от имени объекта
// 
// Параметры
//  Ссылка		 - Ссылка на объект, для которого нужно получить перевод
//  КодЯзыка  	 – Строка – код языка в формате uk/ru
//
Функция ПолучитьЛокализованныйСинонимОбъекта(Ссылка, КодЯзыка)

	МетаданныеДляСсылки = Ссылка.Метаданные();
	
	Если Метаданные.Документы.Содержит(МетаданныеДляСсылки) Тогда
		// это документ
		
		Если КодЯзыка = ЛокализацияПовтИсп.КодЯзыкаИнтерфейса() Тогда
			// "переводить" не нужно
			Возврат МетаданныеДляСсылки.Синоним;
		КонецЕсли;
		
		ИмяДляПеревода = МетаданныеДляСсылки.Имя;
		
	ИначеЕсли Метаданные.Перечисления.Содержит(МетаданныеДляСсылки) Тогда
		// это перечисление
		
		//обработаем попытку получения синонима пустого значения перечисления
		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
			Возврат "";
		КонецЕсли;
		
		Если КодЯзыка = ЛокализацияПовтИсп.КодЯзыкаИнтерфейса() Тогда
			// "переводить" не нужно
			Возврат Строка(Ссылка);
		КонецЕсли;
		
		// получим имя значения перечисления 
		ИндексЗначения = Перечисления[МетаданныеДляСсылки.Имя].Индекс(Ссылка);
		ИмяДляПеревода = МетаданныеДляСсылки.ЗначенияПеречисления[ИндексЗначения].Имя;
		
	КонецЕсли; 
	
	РезультатПеревода = ЛокализацияПовтИсп.ОбработатьПереводы(МетаданныеДляСсылки.ПолноеИмя(), ИмяДляПеревода, КодЯзыка);
	
	Возврат РезультатПеревода;
	
КонецФункции // ПолучитьЛокализованныйСинонимОбъекта()

// Проверяет, соответствует ли язык платформы языку интерфейса пользователя 
Процедура ПроверитьСоответствиеЯзыкаПлатформыИПользователя() Экспорт
	ЛокализацияПовтИсп.ПроверитьСоответствиеЯзыкаПлатформыИПользователя();
КонецПроцедуры // ПроверитьСоответствиеЯзыкаПлатформыИПользователя

// Функция возвращает текстовую строку, сформированную на основании спец. шаблона,
// подставляя значения переданных параметров.	
// 
// Параметры
//  СтрокаШаблон – Строка – Строка шаблон, в тексте которой
//                 есть указания на то, куда вставить представления 
//                 параметров. 
//                 Параметры отмечаются текстом ¤1¤...¤20¤.
//                 Символ "¤" можно набрать при помощи Alt+0164
//  Пар1...Пар20 – произвольного типа – параметры,
//                 строковое представление которых будет 
//                 подставлятся в шаблон.
//
// Возвращаемое значение:
//   Строка   – сформированная текстовая строка
//
Функция СтрШаблонУкр(Знач СтрокаШаблон, 
										Знач Пар1  = "", Знач Пар2  = "",
										Знач Пар3  = "", Знач Пар4  = "", Знач Пар5  = "",
										Знач Пар6  = "", Знач Пар7  = "", Знач Пар8  = "",
										Знач Пар9  = "", Знач Пар10 = "", Знач Пар11 = "",
										Знач Пар12 = "", Знач Пар13 = "", Знач Пар14 = "",
										Знач Пар15 = "", Знач Пар16 = "", Знач Пар17 = "",
										Знач Пар18 = "", Знач Пар19 = "", Знач Пар20 = "") Экспорт
										
	ПризнакПараметра = "¤";
	МетаСимвол       = "\¤"; //заменяется на признак параметра
	
	Для Счетчик = 1 По 20 Цикл
			
		ПерваяПозицияВхожденияПараметра = Найти(СтрокаШаблон, ""+ ПризнакПараметра + Счетчик + ПризнакПараметра);
				
		Если ПерваяПозицияВхожденияПараметра = 0 Тогда
			// этот параметр не используется
			Продолжить;	
		КонецЕсли; 
				
		ПараметрВСтроку = "";
		Выполнить("ПараметрВСтроку = Строка(Пар" + Счетчик + ")");
				
		СтрокаШаблон = СтрЗаменить(СтрокаШаблон, ПризнакПараметра + Счетчик + ПризнакПараметра, ПараметрВСтроку);
				
	КонецЦикла;									
		
	ПозицияМетаСимвола = СтрЗаменить(СтрокаШаблон, МетаСимвол, ПризнакПараметра);

	Возврат СтрокаШаблон;
	
КонецФункции // СтрШаблонУкр()

Процедура ОтключитьИспользованиеНЕУКРОбъектов() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Если Константы.ИспользоватьНЕУКРОбъекты.Получить() Тогда
		Константы.ИспользоватьНЕУКРОбъекты.Установить(Ложь); 
	КонецЕсли;
	
КонецПроцедуры
 

Процедура ЛокализацияЗапросовСКД(СхемаКомпоновкиДанных, СтруктураЗамены) Экспорт
	
	Для каждого НаборДанных Из СхемаКомпоновкиДанных.НаборыДанных Цикл
			
			Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") Тогда
				
				Для Каждого ПодстрокаПоиска ИЗ СтруктураЗамены Цикл
					Если СтрНайти(НаборДанных.Запрос, ПодстрокаПоиска.Ключ) > 0 Тогда
						
						НаборДанных.Запрос = СтрЗаменить(НаборДанных.Запрос, """"+ПодстрокаПоиска.Ключ+"""",""""+ПодстрокаПоиска.Значение+"""");
						
					КонецЕсли; 
				КонецЦикла;		
				
			КонецЕсли; 
			
	КонецЦикла;
	
КонецПроцедуры
