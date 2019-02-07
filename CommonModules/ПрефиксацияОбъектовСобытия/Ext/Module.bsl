﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Префиксация объектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает префикс источника подписки в соответствии с префиксом организации. 
// Источник подписки должен содержать
// обязательный реквизит шапки "Организация", с типом "СправочникСсылка.Организации".
//
// Параметры:
//  Источник - Источник события подписки.
//             Любой объект из множества [Справочник, Документ, План видов характеристик, Бизнес процесс, Задача].
// СтандартнаяОбработка - Булево - флаг стандартной обработки подписки.
// Префикс - Строка - префикс объекта, который нужно изменить.
//
Процедура УстановитьПрефиксОрганизации(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	УстановитьПрефикс(Источник, Префикс, Ложь, Истина);
	
КонецПроцедуры

// Устанавливает префикс источника подписки в соответствии с префиксом информационной базы.
// Ограничения на реквизиты источника не накладываются.
//
// Параметры:
//  Источник - Источник события подписки.
//             Любой объект из множества [Справочник, Документ, План видов характеристик, Бизнес процесс, Задача].
// СтандартнаяОбработка - Булево - флаг стандартной обработки подписки.
// Префикс - Строка - префикс объекта, который нужно изменить.
//
Процедура УстановитьПрефиксИнформационнойБазы(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	УстановитьПрефикс(Источник, Префикс, Истина, Ложь);
	
КонецПроцедуры

// Устанавливает префикс источника подписки в соответствии с префиксом информационной базы и префиксом организации.
// Источник подписки должен содержать
// обязательный реквизит шапки "Организация", с типом "СправочникСсылка.Организации".
//
// Параметры:
//  Источник - Источник события подписки.
//             Любой объект из множества [Справочник, Документ, План видов характеристик, Бизнес процесс, Задача].
// СтандартнаяОбработка - Булево - флаг стандартной обработки подписки.
// Префикс - Строка - префикс объекта, который нужно изменить.
//
Процедура УстановитьПрефиксИнформационнойБазыИОрганизации(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	УстановитьПрефикс(Источник, Префикс, Истина, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для справочников

// Выполняет проверку модифицированности реквизита Организация элемента справочника.
// Если реквизит Организация изменен, то Код элемента обнуляется.
// Это необходимо для назначения нового кода элементу.
//
// Параметры:
//  Источник - СправочникОбъект - источник события подписки.
//  Отказ    - Булево - флаг отказа.
// 
Процедура ПроверитьКодСправочникаПоОрганизации(Источник, Отказ) Экспорт
	
	ПроверитьКодОбъектаПоОрганизации(Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для бизнес-процессов

// Выполняет проверку модифицированности Даты бизнес процесса.
// Если дата не входит в предыдущий период, то номер бизнес процесса обнуляется.
// Это необходимо для назначения нового номера бизнес процессу.
//
// Параметры:
//  Источник - БизнесПроцессОбъект - источник события подписки.
//  Отказ    - Булево - флаг отказа.
// 
Процедура ПроверитьНомерБизнесПроцессаПоДате(Источник, Отказ) Экспорт
	
	ПроверитьНомерОбъектаПоДате(Источник);
	
КонецПроцедуры

// Выполняет проверку модифицированности Даты и Организации бизнес процесса.
// Если дата не входит в предыдущий период или изменен реквизит Организация, то номер бизнес процесса обнуляется.
// Это необходимо для назначения нового номера бизнес процессу.
//
// Параметры:
//  Источник - БизнесПроцессОбъект - источник события подписки.
//  Отказ    - Булево - флаг отказа.
// 
Процедура ПроверитьНомерБизнесПроцессаПоДатеИОрганизации(Источник, Отказ) Экспорт
	
	ПроверитьНомерОбъектаПоДатеИОрганизации(Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для документов

// Выполняет проверку модифицированности Даты документа.
// Если дата не входит в предыдущий период, то номер документа обнуляется.
// Это необходимо для назначения нового номера документу.
//
// Параметры:
//  Источник - ДокументОбъект - источник события подписки.
//  Отказ    - Булево - флаг отказа.
// 
Процедура ПроверитьНомерДокументаПоДате(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ПроверитьНомерОбъектаПоДате(Источник);
	
КонецПроцедуры

// Выполняет проверку модифицированности Даты и Организации документа.
// Если дата не входит в предыдущий период или изменен реквизит Организация, то номер документа обнуляется.
// Это необходимо для назначения нового номера документу.
//
// Параметры:
//  Источник - ДокументОбъект - источник события подписки.
//  Отказ    - Булево - флаг отказа.
// 
Процедура ПроверитьНомерДокументаПоДатеИОрганизации(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ПроверитьНомерОбъектаПоДатеИОрганизации(Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПрефикс(Источник, Префикс, УстановитьПрефиксИнформационнойБазы, УстановитьПрефиксОрганизации)
	
	ПрефиксИнформационнойБазы = "";
	ПрефиксОрганизации        = "";
	ПрефиксНалоговыхДокументов = "";
	
	Если УстановитьПрефиксИнформационнойБазы Тогда
		
		ПерепрефиксацияОбъектов.ПриОпределенииПрефиксаИнформационнойБазы(ПрефиксИнформационнойБазы);
		
		ДополнитьСтрокуНулямиСлева(ПрефиксИнформационнойБазы, 2);
	КонецЕсли;
	
	Если УстановитьПрефиксОрганизации Тогда
		
		Если РеквизитОрганизацияДоступен(Источник) Тогда
			
			ПерепрефиксацияОбъектов.ПриОпределенииПрефиксаОрганизации(
				Источник[ИмяРеквизитаОрганизация(Источник.Метаданные())], ПрефиксОрганизации);
			// Если задана пустая ссылка на организацию.
			Если ПрефиксОрганизации = Ложь Тогда
				
				ПрефиксОрганизации = "";
				
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнитьСтрокуНулямиСлева(ПрефиксОрганизации, 2);
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.НалоговаяНакладная")
	 ИЛИ ТипЗнч(Источник) = Тип("ДокументОбъект.Приложение2КНалоговойНакладной") Тогда
		
		ДобавитьПрефиксыНалоговогоДокумента(Источник, ПрефиксНалоговыхДокументов)
			
	КонецЕсли;
	
	ШаблонПрефикса = "[ОР][ИБ][НД]-[Префикс]";
 	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[ОР]", ПрефиксОрганизации);
	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[ИБ]", ПрефиксИнформационнойБазы);
	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[НД]", ПрефиксНалоговыхДокументов);
	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[Префикс]", Префикс);
	
	Префикс = ШаблонПрефикса;
	
КонецПроцедуры

Процедура ДополнитьСтрокуНулямиСлева(Строка, ДлинаСтроки)
	
	Строка = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Строка, ДлинаСтроки, "0", "Слева");
	
КонецПроцедуры

Процедура ПроверитьНомерОбъектаПоДате(Объект)
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	ИначеЕсли Объект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ШапкаОбъекта.Дата КАК Дата
	|ИЗ
	|	" + МетаданныеОбъекта.ПолноеИмя() + " КАК ШапкаОбъекта
	|ГДЕ
	|	ШапкаОбъекта.Ссылка = &Ссылка
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Не ПрефиксацияОбъектовСлужебный.ДатыОбъектаОдногоПериода(Выборка.Дата, Объект.Дата, Объект.Ссылка) Тогда
		Объект.Номер = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНомерОбъектаПоДатеИОрганизации(Объект)
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	ИначеЕсли Объект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПрефиксацияОбъектовСлужебный.ДатаИлиОрганизацияОбъектаИзменена(Объект.Ссылка, Объект.Дата,
		Объект[ИмяРеквизитаОрганизация(Объект.Метаданные())]) Тогда
		
		Объект.Номер = "";
		
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.НалоговаяНакладная")
	 ИЛИ ТипЗнч(Объект) = Тип("ДокументОбъект.Приложение2КНалоговойНакладной") Тогда
		
		ПроверитьНомерНалоговогоДокумента(Объект);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКодОбъектаПоОрганизации(Объект)
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	ИначеЕсли Объект.ЭтоНовый() Тогда
		Возврат;
	ИначеЕсли Не РеквизитОрганизацияДоступен(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПрефиксацияОбъектовСлужебный.ОрганизацияОбъектаИзменена(Объект.Ссылка,	
		Объект[ИмяРеквизитаОрганизация(Объект.Метаданные())]) Тогда
		
		Объект.Код = "";
		
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитОрганизацияДоступен(Объект)
	
	// Возвращаемое значение функции.
	Результат = Истина;
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	Если   (ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта)
		ИЛИ ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеОбъекта))
		И МетаданныеОбъекта.Иерархический Тогда
		
		ИмяРеквизитаОрганизация = ИмяРеквизитаОрганизация(МетаданныеОбъекта);
		
		РеквизитОрганизация = МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизитаОрганизация);
		
		Если РеквизитОрганизация = Неопределено Тогда
			
			Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ИмяРеквизитаОрганизация) Тогда
				
				// Стандартный реквизит всегда доступен и для элемента и для группы.
				Возврат Истина;
				
			КонецЕсли;
			
			СтрокаСообщения = НСтр("ru='Для объекта метаданных %1 не определен реквизит с именем %2.';uk='Для об''єкта метаданих %1 не визначений реквізит з іменем %2.'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, МетаданныеОбъекта.ПолноеИмя(), ИмяРеквизитаОрганизация);
			ВызватьИсключение СтрокаСообщения;
		КонецЕсли;
			
		Если РеквизитОрганизация.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы И Не Объект.ЭтоГруппа Тогда
			
			Результат = Ложь;
			
		ИначеЕсли РеквизитОрганизация.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента И Объект.ЭтоГруппа Тогда
			
			Результат = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования.
Функция ИмяРеквизитаОрганизация(Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("ОбъектМетаданных") Тогда
		ПолноеИмя = Объект.ПолноеИмя();
	Иначе
		ПолноеИмя = Объект;
	КонецЕсли;
	
	Реквизит = ПрефиксацияОбъектовПовтИсп.ПрефиксообразующиеРеквизиты().Получить(ПолноеИмя);
	
	Если Реквизит <> Неопределено Тогда
		Возврат Реквизит;
	КонецЕсли;
	
	Возврат "Организация";
	
КонецФункции

#Область ПрефиксацияИсходящихНалоговыхДокументов

Процедура ПроверитьНомерНалоговогоДокумента(Документ)
	
	// особые опциональные правила нумерации налоговых документов:
	// возможность вести сквозную нумерацию Налоговых накладных и Приложений 2 к ней
	// возможность вести помесячную нумерацию
	Если  НЕ ТипЗнч(Документ) = Тип("ДокументОбъект.НалоговаяНакладная")
		И НЕ ТипЗнч(Документ) = Тип("ДокументОбъект.Приложение2КНалоговойНакладной") Тогда
		Возврат;
	КонецЕсли;
	
	// поддерживаем особый порядок нумерации налоговых накладных
	// при изменении даты документа возможно потребуется изменение=очистка номера
	
	Если НЕ ЗначениеЗаполнено(Документ.Ссылка) Тогда
		// это новый документ, номер еще не присвоен или задан вручную
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Документ.Номер) Тогда
	    Возврат;
	КонецЕсли;
	
	ЗапросСтарыеДанные = Новый Запрос();
	ЗапросСтарыеДанные.Текст = 
	"ВЫБРАТЬ
	|	НалоговыйДокумент.Дата,
	|	НалоговыйДокумент.ВидОперации,
	|	НалоговыйДокумент.СпецРежимНалогообложения,
	|	НалоговыйДокумент.ОбособленноеПодразделение КАК Филиал,
	|	НалоговыйДокумент.Организация
	|ИЗ
	|	Документ.НалоговаяНакладная КАК НалоговыйДокумент
	|ГДЕ
	|	НалоговыйДокумент.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НалоговыйДокумент.Дата,
	|	НалоговыйДокумент.ВидОперации,
	|	НалоговыйДокумент.СпецРежимНалогообложения,
	|	ВЫБОР
	|		КОГДА НалоговыйДокумент.НалоговаяНакладнаяНеЗарегистрированаВИБ
	|	    	ТОГДА НалоговыйДокумент.ОбособленноеПодразделение
	|	    ИНАЧЕ
	|	    	ЕСТЬNULL(НалоговыйДокумент.НалоговаяНакладная.ОбособленноеПодразделение, ЗНАЧЕНИЕ(Справочник.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка))
	|	КОНЕЦ,
	|	НалоговыйДокумент.Организация
	|ИЗ
	|	Документ.Приложение2КНалоговойНакладной КАК НалоговыйДокумент
	|ГДЕ
	|	НалоговыйДокумент.Ссылка = &Ссылка";
	
	ЗапросСтарыеДанные.УстановитьПараметр("Ссылка",    Документ.Ссылка);
	
	СтарыеДанные = ЗапросСтарыеДанные.Выполнить().Выбрать();
	СтарыеДанные.Следующий();
	
	СтарыеНастройкиНумерации = РегистрыСведений.НастройкаНумерацииНалоговыхДокументов.ПолучитьПоследнее(СтарыеДанные.Дата, Новый Структура("Организация", СтарыеДанные.Организация));
	НовыеНастройкиНумерации  = РегистрыСведений.НастройкаНумерацииНалоговыхДокументов.ПолучитьПоследнее(Документ.Дата, 	 Новый Структура("Организация", Документ.Организация));
				   
	Если  СтарыеНастройкиНумерации.Количество() > 0
		И НовыеНастройкиНумерации.Количество()  > 0 Тогда
		
		Если    СтарыеНастройкиНумерации.ВестиМесячнуюНумерациюНалоговыхДокументов   <> НовыеНастройкиНумерации.ВестиМесячнуюНумерациюНалоговыхДокументов
			ИЛИ СтарыеНастройкиНумерации.ВестиДневнуюНумерациюНалоговыхДокументов    <> НовыеНастройкиНумерации.ВестиДневнуюНумерациюНалоговыхДокументов
			Тогда
		
		    Документ.Номер = "";
			
		ИначеЕсли НовыеНастройкиНумерации.ВестиМесячнуюНумерациюНалоговыхДокументов 
			И НачалоМесяца(СтарыеДанные.Дата) <> НачалоМесяца(Документ.Дата) Тогда
			
			Документ.Номер = "";
			
		ИначеЕсли НовыеНастройкиНумерации.ВестиДневнуюНумерациюНалоговыхДокументов 
			И НачалоДня(СтарыеДанные.Дата) <> НачалоДня(Документ.Дата) Тогда
			
			Документ.Номер = "";
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Если НЕ СтарыеДанные.ВидОперации = Документ.ВидОперации
		  И (   (СтарыеДанные.ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.НеНДСОперации)
			 ИЛИ(Документ.ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.НеНДСОперации))
		  И (     НовыеНастройкиНумерации.ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям = Истина
		      ИЛИ СтарыеНастройкиНумерации.ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям = Истина) Тогда
		   
		Документ.Номер = "";		   
			
	КонецЕсли;
	
	Если НЕ СтарыеДанные.СпецРежимНалогообложения = Документ.СпецРежимНалогообложения Тогда
	
		Документ.Номер = "";
	
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.НалоговаяНакладная")Тогда
		ТекФилиал = Документ.ОбособленноеПодразделение;
	ИначеЕсли Документ.НалоговаяНакладнаяНеЗарегистрированаВИБ Тогда
        ТекФилиал = Документ.ОбособленноеПодразделение;
	Иначе
		ТекФилиал = Документ.НалоговаяНакладная.ОбособленноеПодразделение;
	КонецЕсли;

	Если НЕ СтарыеДанные.Филиал = ТекФилиал 
		И Документ.Дата < НДСОбщегоНазначенияПовтИсп.ДатаВступленияВСилуПриказа1307() 
	 	И (НовыеНастройкиНумерации.ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений = Ложь
	 	ИЛИ СтарыеНастройкиНумерации.ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений = Ложь) Тогда
	
		Документ.Номер = "";
	
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьМесячныйПрефиксНалоговыхДокументов(Дата)

	НомерМесяца = Месяц(Дата);
	Индекс = НомерМесяца*3 - 2;
	
	Возврат Сред("Ян|Фв|Мр|Ап|Ма|Ин|Ил|Ав|Сн|Ок|Но|Дк", Индекс, 2);	

КонецФункции

Процедура ДобавитьПрефиксыНалоговогоДокумента(ДокументОбъект, Префикс)
	
	// особые опциональные правила нумерации налоговых документов:
	// возможность вести сквозную нумерацию Налоговых накладных и Приложений 2 к ней
	// возможность вести помесячную нумерацию
	Если  НЕ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.НалоговаяНакладная")
		И НЕ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.Приложение2КНалоговойНакладной") Тогда
		Возврат;
	КонецЕсли;
	
	СписокНастроекНумерации = РегистрыСведений.НастройкаНумерацииНалоговыхДокументов.СрезПоследних(ДокументОбъект.Дата, Новый Структура("Организация", ДокументОбъект.Организация));
	ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям = Ложь;
	ВестиМесячнуюНумерациюНалоговыхДокументов                   = Ложь;
	ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений = Ложь;
	
	Если СписокНастроекНумерации.Количество() > 0 тогда
		НастройкиНумерации = СписокНастроекНумерации[0];
		
		ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям 		= НастройкиНумерации.ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям;
		ВестиМесячнуюНумерациюНалоговыхДокументов                   		= НастройкиНумерации.ВестиМесячнуюНумерациюНалоговыхДокументов;
		ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений 	= НастройкиНумерации.ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений;
		ВестиДневнуюНумерациюНалоговыхДокументов 							= НастройкиНумерации.ВестиДневнуюНумерациюНалоговыхДокументов;
	КонецЕсли;
	
	ПрефиксНалоговых = "";
	
	Если ВестиРаздельнуюНумерациюНалоговыхДокументовПоНеНДСОперациям = Истина
		И  ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.НеНДСОперации Тогда
	   ПрефиксНалоговых = ПрефиксНалоговых + "Т";//технологические (нераспечатываемые) документы
	   
   КонецЕсли;		
	
   Если ВестиМесячнуюНумерациюНалоговыхДокументов = Истина
	   Или (ВестиДневнуюНумерациюНалоговыхДокументов = Истина И ДокументОбъект.Дата >= '2015-01-01') Тогда
	   // разделяем префиксом по месяцам
	   ПрефиксНалоговых = ПрефиксНалоговых + ПолучитьМесячныйПрефиксНалоговыхДокументов(ДокументОбъект.Дата);
   КонецЕсли;
   
   // разделяем префиксом Налоговые от Приложений
   СпецРежим = ДокументОбъект.СпецРежимНалогообложения;
   
   Если СпецРежим = 0 Тогда
	   ПрефиксНалоговых = ПрефиксНалоговых + "";
   ИначеЕсли СпецРежим = 2 Тогда
	   ПрефиксНалоговых = ПрефиксНалоговых + "U";
   ИначеЕсли СпецРежим = 3 Тогда
	   ПрефиксНалоговых = ПрефиксНалоговых + "V";
   ИначеЕсли СпецРежим = 4 Тогда
	   ПрефиксНалоговых = ПрефиксНалоговых + "W";
   КонецЕсли;
   
   Если ВестиНумерациюНалоговыхДокументовБезУчетаОбособленныхПодразделений = Ложь И ДокументОбъект.Дата < НДСОбщегоНазначенияПовтИсп.ДатаВступленияВСилуПриказа1307() Тогда 	   
	   
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.НалоговаяНакладная") Тогда
			ОбособленноеПодразделение = ДокументОбъект.ОбособленноеПодразделение;
		ИначеЕсли ДокументОбъект.НалоговаяНакладнаяНеЗарегистрированаВИБ Тогда
        	ОбособленноеПодразделение = ДокументОбъект.ОбособленноеПодразделение;
		Иначе
			ОбособленноеПодразделение = ДокументОбъект.НалоговаяНакладная.ОбособленноеПодразделение;
		КонецЕсли;
		Если ЗначениеЗаполнено(ОбособленноеПодразделение.Префикс) Тогда
			ПрефиксНалоговых = ПрефиксНалоговых + Прав("0000" + СокрЛП(ОбособленноеПодразделение.Префикс), 4);
		КонецЕсли;
	КонецЕсли;
	
	Если ВестиДневнуюНумерациюНалоговыхДокументов = Истина
		И ДокументОбъект.Дата >= '2015-01-01'Тогда
		
		// добавляем префикс дня - "Д" + порядковый номер дня.
		ПрефиксНалоговых = ПрефиксНалоговых + ПолучитьДневнойПрефиксНалоговыхДокументов(ДокументОбъект.Дата);
		
	КонецЕсли;
	
	ПрефиксНалоговых = Лев(ПрефиксНалоговых + "0000000", 7);
	
	Префикс = СОКРП(Префикс) + ПрефиксНалоговых; 
	
Конецпроцедуры

Функция ПолучитьДневнойПрефиксНалоговыхДокументов(Дата)
	
	// номер дня с лидирующим нулем
	Возврат "Д" + Формат(День(Дата), "ЧЦ=2; ЧВН=");	
	
КонецФункции

#КонецОбласти

#КонецОбласти
