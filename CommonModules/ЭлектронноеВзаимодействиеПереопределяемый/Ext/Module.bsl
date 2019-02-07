﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Изменяет поведение элементов управляемой или обычной формы.
//
// Параметры:
//  Форма - <Управляемая или обычная форма> - управляемая или обычная форма для изменения.
//  СтруктураПараметров - <Структура> - параметры процедуры
//
Процедура ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров) Экспорт
	
	Если СтруктураПараметров.Свойство("ВидОперации")
		И СтруктураПараметров.Свойство("ЗначениеПараметра") Тогда
		Если ВРег(СтруктураПараметров.ВидОперации) = ВРег("УстановкаГиперссылки")
			И СтруктураПараметров.Свойство("ТекстСостоянияЭДО") Тогда
			
			// Определим элемент формы.
			НайденныйЭлементФормы = Неопределено;
			Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда // только для управляемой формы
				Если НЕ Форма.Элементы.Найти("СостояниеЭД") = Неопределено Тогда
					НайденныйЭлементФормы = Форма.Элементы.СостояниеЭД;
				КонецЕсли;
				
				// Заполним свойство найденного элемента.
				Если НЕ НайденныйЭлементФормы = Неопределено
					И НайденныйЭлементФормы.Вид = ВидПоляФормы.ПолеНадписи Тогда
					НайденныйЭлементФормы.Гиперссылка = СтруктураПараметров.ЗначениеПараметра;
				КонецЕсли;
			Иначе // для обычной формы
				Если НЕ Форма.ЭлементыФормы.Найти("ТекстСостоянияЭДО") = Неопределено Тогда
					НайденныйЭлементФормы = Форма.ЭлементыФормы.ТекстСостоянияЭД;
				КонецЕсли;
				
				// Заполним свойство найденного элемента.
				Если НЕ НайденныйЭлементФормы = Неопределено
					И ТипЗнч(НайденныйЭлементФормы) = Тип("Надпись") Тогда
					НайденныйЭлементФормы.Гиперссылка = СтруктураПараметров.ЗначениеПараметра;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда // только для управляемой формы
		Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЕстьПравоЧтенияЭД(Ложь) 
						ИЛИ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
			Если НЕ Форма.Элементы.Найти("ГруппаСостояниеЭД") = Неопределено Тогда
				Форма.Элементы.ГруппаСостояниеЭД.Видимость = Ложь;
			ИначеЕсли НЕ Форма.Элементы.Найти("СостояниеЭД") = Неопределено Тогда
				Форма.Элементы.СостояниеЭД.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

// При необходимости, в функции можно определить каталог для временных файлов,
// отличный от устанавливаемого по умолчанию в библиотеке ЭД.
//
// Параметры:
//  ТекущийКаталог - путь к каталогу временных файлов.
//
Процедура ТекущийКаталогВременныхФайлов(ТекущийКаталог) Экспорт
	
	ТекущийКаталог = КаталогВременныхФайлов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка метаданных

// Определяет соответствие функциональных опций библиотеки и прикладного решения,
// в случае различий в наименовании.
//
// Параметры:
//  СоответствиеФО - Соответствие - список функциональных опций.
//
Процедура ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО) Экспорт
	
	// Электронные документы
	СоответствиеФО.Вставить("ИспользоватьОбменЭДМеждуОрганизациями",  "ИспользоватьОбменЭДМеждуОрганизациями");
	СоответствиеФО.Вставить("ИспользоватьОбменЭД",                    "ИспользоватьОбменЭД");
	СоответствиеФО.Вставить("ИспользоватьЭлектронныеПодписи", 		 "ИспользоватьЭлектронныеПодписи");
	// Конец электронные документы
	
	СоответствиеФО.Вставить("ИспользоватьРучныеСкидкиВПродажах", 	 	"ИспользоватьРучныеСкидкиВПродажах");
	СоответствиеФО.Вставить("ИспользоватьАвтоматическиеСкидкиВПродажах", "ИспользоватьАвтоматическиеСкидкиВПродажах");
	СоответствиеФО.Вставить("ИспользоватьРучныеСкидкиВЗакупках", 		"ИспользоватьРучныеСкидкиВЗакупках");
	СоответствиеФО.Вставить("ИспользоватьПартнеровИКонтрагентов", 		"ИспользоватьПартнеровИКонтрагентов");
	
КонецПроцедуры

// Определяет соответствие справочников библиотеки и прикладного решения,
// в случае различий в наименовании справочников.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	
	СоответствиеСправочников.Вставить("Организации",                 "Организации");
	СоответствиеСправочников.Вставить("Контрагенты",                 "Контрагенты");
	СоответствиеСправочников.Вставить("Партнеры",                    "Партнеры");
	СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
	СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры",  "ХарактеристикиНоменклатуры");
	СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "УпаковкиЕдиницыИзмерения");
	СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "НоменклатураПоставщиков");
	СоответствиеСправочников.Вставить("Валюты",                      "Валюты");
	СоответствиеСправочников.Вставить("Банки",                       "КлассификаторБанковРФ");
	СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "УпаковкиЕдиницыИзмерения");
	СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчетаОрганизаций");
	СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчетаКонтрагентов");
	СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
	
КонецПроцедуры

// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента",
// то для этих реквизитов необходимо добавить в соответствие записи виде
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита"
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
// 
// Параметры:
// СоответствиеРеквизитовОбъекта - Соответствие, в котором
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДиРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	
	// Обмен с банками начало
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеПоручениеВМетаданных", 		"СписаниеБезналичныхДенежныхСредств");
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеТребованиеВМетаданных", 		"ПоступлениеБезналичныхДенежныхСредств");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации",   	"Наименование");
	// Обмен с банками конец
	
	// Обмен с контрагентами начало
	СоответствиеРеквизитовОбъекта.Вставить("РеализацияТоваровУслугВМетаданных", 	"РеализацияТоваровУслуг");
	СоответствиеРеквизитовОбъекта.Вставить("ПоступлениеТоваровУслугВМетаданных", 	"ПоступлениеТоваровУслуг");
	СоответствиеРеквизитовОбъекта.Вставить("КоммерческоеПредложениеКлиенту",       	"КоммерческоеПредложениеКлиенту");
	СоответствиеРеквизитовОбъекта.Вставить("РегистрацияЦенНоменклатурыПоставщика", 	"РегистрацияЦенНоменклатурыПоставщика");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаВыставленияВСчетеФактуреВыданном", 	"ДатаВыставления");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаПолученияВСчетеФактуреПолученном", 	"Дата");
	СоответствиеРеквизитовОбъекта.Вставить("ИННКонтрагента",                       	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППКонтрагента",                       	"КПП");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагента",              	"Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагентаДляСообщенияПользователю", "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("ВнешнийКодКонтрагента",                	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("ПартнерКонтрагента",                   	"Партнер");
	СоответствиеРеквизитовОбъекта.Вставить("ИННОрганизации",                       	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППОрганизации",                       	"КПП");
	СоответствиеРеквизитовОбъекта.Вставить("ОГРНОрганизации",                      	"ОГРН");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеОрганизации",              	"Наименование");
	
	СоответствиеРеквизитовОбъекта.Вставить("КоммерческоеПредложениеКлиенту.Контрагент", "ТипДокумента.Соглашение.Контрагент");
	// Обмен с контрагентами конец
	
КонецПроцедуры

// Заполняет соответствие кодов реквизитов схем электронных документов их пользовательскому представлению.
//
// Параметры:
//  СоответствиеВозврата - Соответствие, исходное соответствие для заполнения.
//
Процедура СоответствиеКодовРеквизитовИПредставлений(СоответствиеВозврата) Экспорт
	

КонецПроцедуры

// Получает ключевые реквизиты объекта по текстовому представлению.
//
// Параметры:
//  ИмяОбъекта - Строка, текстовое представление объекта, ключевые реквизиты которого необходимо получить.
//
// Возвращаемое значение:
//  СтруктураКлючевыхРеквизитов - перечень параметров объекта.
//
Процедура ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов) Экспорт
	
	Если ИмяОбъекта = "Документ.КоммерческоеПредложениеКлиенту" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.РеализацияТоваровУслуг" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПоступлениеТоваровУслуг" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ЗаказКлиента" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		//ЭтапыГрафикаОплаты
		СтрокаРеквизитовОбъекта = ("ВариантОплаты, ДатаПлатежа, ПроцентПлатежа, СуммаПлатежа");
		СтруктураКлючевыхРеквизитов.Вставить("ЭтапыГрафикаОплаты", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ЗаказПоставщику" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, НоменклатураПоставщика, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		//ЭтапыГрафикаОплаты
		СтрокаРеквизитовОбъекта = ("ВариантОплаты, ДатаПлатежа, ПроцентПлатежа, СуммаПлатежа");
		СтруктураКлючевыхРеквизитов.Вставить("ЭтапыГрафикаОплаты", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПроизвольныйЭД" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент, Партнер, Сообщение");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.СчетНаОплатуКлиенту" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, БанковскийСчет");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		//ЭтапыГрафикаОплаты
		СтрокаРеквизитовОбъекта = ("ДатаПлатежа, ПроцентПлатежа, СуммаПлатежа");
		СтруктураКлючевыхРеквизитов.Вставить("ЭтапыГрафикаОплаты", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ОтчетКомитенту" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, НоменклатураПоставщика, Цена, Сумма, СуммаНДС, СтавкаНДС, СуммаПродажи, СуммаВознаграждения");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		//ЭтапыГрафикаОплаты
		СтрокаРеквизитовОбъекта = ("ДатаПлатежа, ПроцентПлатежа, СуммаПлатежа");
		СтруктураКлючевыхРеквизитов.Вставить("ЭтапыГрафикаОплаты", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ОтчетКомитентуОСписании" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, НоменклатураПоставщика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.АктВыполненныхРабот" Тогда 
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Услуги", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПередачаТоваровМеждуОрганизациями" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, ОрганизацияПолучатель, 
			|ЦенаВключаетНДС, РасчетыЧерезОтдельногоКонтрагента");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ВозвратТоваровМеждуОрганизациями" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, ОрганизацияПолучатель, 
			|ЦенаВключаетНДС, РасчетыЧерезОтдельногоКонтрагента");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ЗаявкаНаРасходованиеДенежныхСредств" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Партнер, Сумма");
		СтруктураКлючевыхРеквизитов.Вставить("РасшифровкаПлатежа", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.КорректировкаРеализации" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Валюта, СуммаДокумента, Партнер, Контрагент, ЦенаВключаетНДС, ХозяйственнаяОперация");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Количество, Номенклатура, Характеристика, Цена, Сумма, СуммаНДС, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Товары", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.СписаниеБезналичныхДенежныхСредств" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, БанковскийСчет, ТипПлатежногоДокумента, ХозяйственнаяОперация,
			|СуммаДокумента, Контрагент, БанковскийСчетКонтрагента, БанковскийСчетПолучатель, ПодотчетноеЛицо,
			|НазначениеПлатежа, Валюта, ВидПлатежа, ОчередностьПлатежа, ПеречислениеВБюджет, ВидПеречисленияВБюджет,
			|СтатусСоставителя, КодБК, КодОКАТО, ПоказательОснования, ПоказательПериода, ПоказательНомера, ПоказательДаты");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПоступлениеБезналичныхДенежныхСредств" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, БанковскийСчет, ТипПлатежногоДокумента, ХозяйственнаяОперация,
			|СуммаДокумента, Контрагент, БанковскийСчетКонтрагента, БанковскийСчетОтправитель, ПодотчетноеЛицо,
			|НазначениеПлатежа, Валюта");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение текстовых сообщений

// Определяет текст сообщения о необходимости настройки системы в зависимости от вида операции.
//
// Параметры:
//  ВидОперации    - строка - признак выполняемой операции;
//  ТекстСообщения - строка - текст сообщения.
//
Процедура ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения) Экспорт
	
	Если ВРег(ВидОперации) = "РАБОТАСЭД" Тогда
		ТекстСообщения = НСтр("ru='Для работы с электронными документами необходимо
            |в настройках системы включить использование обмена электронными документами'
            |;uk='Для роботи з електронними документами
            |в настройках системи включити використання обміну електронними документами'");
	ИначеЕсли ВРег(ВидОперации) = "ПОДПИСАНИЕЭД" Тогда
		ТекстСообщения = НСтр("ru='Для возможности подписания ЭД необходимо
            |в настройках системы включить опцию использования электронных цифровых подписей'
            |;uk='Для можливості підписання ЕД необхідно
            |в настройках системи включити опцію використання електронних цифрових підписів'");
	ИначеЕсли ВРег(ВидОперации) = "НАСТРОЙКАКРИПТОГРАФИИ" Тогда
		ТекстСообщения = НСтр("ru='Для возможности настройки криптографии необходимо 
            |в настройках системы включить опцию использования электронных цифровых подписей'
            |;uk='Для можливості настройки криптографії необхідно 
            |в настройках системи включити опцію використання електронних цифрових підписів'");
	ИначеЕсли ВРег(ВидОперации) = "ДОПОЛНИТЕЛЬНЫЕОТЧЕТЫИОБРАБОТКИ" Тогда
		ТекстСообщения = НСтр("ru='Для возможности подключения через дополнительную обработку необходимо 
            |в настройках системы включить опцию использования дополнительных отчетов и обработок'
            |;uk='Для можливості підключення через додаткову обробку необхідно 
            |в настройках системи включити опцію використання додаткових звітів і обробок'");
	Иначе
		ТекстСообщения = НСтр("ru='Операция не может быть выполнена';uk='Операція не може бути виконана'");
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет выводимое сообщение об ошибке
// КодОшибки - строка
// ТекстОшибки - строка
Процедура ИзменитьСообщениеОбОшибке(КодОшибки, ТекстОшибки) Экспорт
	
КонецПроцедуры

// Переопределяет сообщение о нехватке прав доступа
//
// Параметры:
//  ТекстСообщения - строка сообщения
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение данных

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам
// 
// Параметры:
//  ТипОбъекта - Строка, идентификатор типа объекта, который необходимо найти,
//  ИДОбъекта - Строка, идентификатор объекта заданного типа,
//  ДополнительныеРеквизиты - Структура, набор дополнительных полей объекта для поиска.
//
Функция НайтиСсылкуНаОбъект(ТипОбъекта, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено, ИДЭД = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Неопределено;

	Если ТипОбъекта = "Валюты" ИЛИ ТипОбъекта = "ЕдиницыИзмерения" Тогда
		Если ТипОбъекта = "ЕдиницыИзмерения" Тогда
			ТипОбъекта = "УпаковкиЕдиницыИзмерения";
		КонецЕсли;
		Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Код", ИдОбъекта);   
	ИначеЕсли ТипОбъекта = "Банки" Тогда
		Результат = НайтиСсылкуНаОбъектПоРеквизиту("КлассификаторБанковРФ", "Код", ИдОбъекта);   
		
	ИначеЕсли ТипОбъекта = "Партнеры" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		Контрагент = Неопределено;
		Если ДополнительныеРеквизиты.Свойство("Контрагент", Контрагент) И ЗначениеЗаполнено(Контрагент) Тогда
			Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Партнер");
		КонецЕсли;
	ИначеЕсли (ТипОбъекта = "Контрагенты" ИЛИ ТипОбъекта = "Организации") И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		ПараметрПоиска = "";
		ИНН = Неопределено;
		ДополнительныеРеквизиты.Свойство("ИНН", ИНН);
		Если ИНН = Неопределено Тогда
			ИНН = "";
		КонецЕсли;
		КПП = Неопределено;
		ДополнительныеРеквизиты.Свойство("КПП", КПП);
		Если КПП = Неопределено Тогда
			КПП = "";
		КонецЕсли;
		Если ЗначениеЗаполнено(ИНН + КПП) Тогда // по ИНН + КПП
			Результат = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП(ТипОбъекта, ИНН, КПП); 
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("Наименование", ПараметрПоиска) Тогда // по Наименованию
			Если ТипОбъекта = "Организации" Тогда
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "НаименованиеСокращенное", ПараметрПоиска);
			Иначе
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Наименование", ПараметрПоиска);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "НоменклатураПоставщиков" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		Владелец = "";
		ПараметрПоиска = "";
		Если ДополнительныеРеквизиты.Свойство("Идентификатор", ПараметрПоиска) Тогда // по Идентификатору
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Идентификатор", ПараметрПоиска);
		ИначеЕсли ДополнительныеРеквизиты.Свойство("Ид", ПараметрПоиска) Тогда
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Идентификатор", ПараметрПоиска);
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "Номенклатура" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		ПараметрПоиска = "";
		Если ДополнительныеРеквизиты.Свойство("Идентификатор", ПараметрПоиска) Тогда // по Идентификатору
			Результат = НайтиСсылкуНаНоменклатуруПоИдентификаторуНоменклатурыПоставщика(ПараметрПоиска);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("НоменклатураПоставщика", ПараметрПоиска) Тогда // по НоменклатуреПоставщика
			Результат = НайтиСсылкуНаНоменклатуруПоНоменклатуреПоставщика(ПараметрПоиска);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("Артикул", ПараметрПоиска) Тогда // по Коду номенклатуры своей компании
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Код", ПараметрПоиска);
		КонецЕсли;
	ИначеЕсли (ТипОбъекта = "БанковскиеСчетаОрганизаций" ИЛИ ТипОбъекта = "БанковскиеСчетаКонтрагентов") И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		ПараметрПоиска 	= "";
		Владелец 		= "";
		Если ДополнительныеРеквизиты.Свойство("НомерСчета", ПараметрПоиска) Тогда // по Номеру счета
			Если ДополнительныеРеквизиты.Свойство("Владелец", Владелец) И ТипЗнч(Владелец) <> Тип("Строка") Тогда
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "НомерСчета", ПараметрПоиска, Владелец);
			Иначе
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "НомерСчета", ПараметрПоиска); 
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ВРег(ТипОбъекта) = ВРег("ДоговорыКонтрагентов") Тогда		
		Результат = ДоговорКонтрагентаПоРеквизитам(ДополнительныеРеквизиты);		
	ИначеЕсли ТипОбъекта = "ВидыКонтактнойИнформации" Тогда
		Если ИдОбъекта = "ФаксКонтрагента" Тогда
			Результат = Неопределено;
		Иначе
			Результат = Справочники[ТипОбъекта][ИдОбъекта];
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "СтраныМира" Тогда	
		Результат =  "--";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - документссылка - ссылка на документ информационной базы.
//
// Возвращаемое значение:
//  НомерОбъекта - номер документа.
//
Функция ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект) Экспорт
	
	Возврат ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(СсылкаНаОбъект.Номер, Истина, Истина);
	
КонецФункции

// Проверяет, готовность документов ИБ для формирования ЭД, и удаляет из массива не готовые документы
//
// Параметры
//  ДокументыМассив - Массив   - ссылки на документы, которые должны быть проверены перед формированием ЭД.
//
Процедура ПроверитьГотовностьИсточников(ДокументыМассив, ФормаИсточник = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияТипаИзМассива(ДокументыМассив, Тип("СтрокаГруппировкиДинамическогоСписка"));
	
	// Удалим из массива документы, которые не могут быть выставлены в электронном виде.
	ДокументыКорректировкиРеализацияУслугПрочихАктивов = Новый Массив();
	ДокументыБезУказанияКонтрагента = Новый Массив();
	Для каждого Документ из ДокументыМассив Цикл
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
			ДокументаОснования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ДокументОснование");
			Если ТипЗнч(ДокументаОснования) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				ДокументыКорректировкиРеализацияУслугПрочихАктивов.Добавить(Документ);
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") Тогда
			Контрагент = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Соглашение.Контрагент");
			Если Не ЗначениеЗаполнено(Контрагент.СоглашениеКонтрагент) Тогда
				ДокументыБезУказанияКонтрагента.Добавить(Документ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументыКорректировкиРеализацияУслугПрочихАктивов.Количество() > 0 Тогда
		УдалитьДокументыНеподходящиеДляФормированияЭД(
			ДокументыМассив,
			ДокументыКорректировкиРеализацияУслугПрочихАктивов,
			НСтр("ru='Документ %1 введен на основании документа ""Реализация услуг и прочих активов"". Электронный документ не сформирован.';uk='Документ %1 уведений на підставі документа ""Реалізація послуг і інших активів"". Електронний документ не сформований.'"));
	КонецЕсли;
	
	// Перед формированием ЭД документы ИБ должны быть проведены
	ДокументыПодлежащиеПроведению = Новый Массив;
	Для каждого Элемент Из ДокументыМассив Цикл
		МетаданныеДокумента = Элемент.Метаданные();
		Если ОбщегоНазначения.ЭтоДокумент(МетаданныеДокумента)
			 И МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
			ДокументыПодлежащиеПроведению.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Если ДокументыПодлежащиеПроведению.Количество() = 0 Тогда
		// Проверку выполнять не требуется
		Возврат;
	КонецЕсли;
	
	МассивНепроведенныхДокументов = ОбщегоНазначения.ПроверитьПроведенностьДокументов(ДокументыПодлежащиеПроведению);
	КоличествоНепроведенныхДокументов = МассивНепроведенныхДокументов.Количество();
	
	Если КоличествоНепроведенныхДокументов <> 0 Тогда	
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			Текст = НСтр("ru='Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.';uk='Для того щоб сформувати електронну версію документа, його необхідно попередньо провести.'");
		Иначе
			Текст = НСтр("ru='Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.';uk='Для того щоб сформувати електронні версії документів, їх необхідно попередньо провести.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		
		УдалитьДокументыНеподходящиеДляФормированияЭД(
			ДокументыМассив,
			МассивНепроведенныхДокументов,
			НСтр("ru='Документ %1 не проведен.';uk='Документ %1 не проведено.'"));
	КонецЕсли;
		
	Если ДокументыБезУказанияКонтрагента.Количество() Тогда
		ШаблонСообщения = НСтр("ru='Обработка %1.
                                     |Операция не выполнена!
                                     |Невозможно определить ""Настройку ЭДО"".
                                     |Не заполнен реквизит ""Контрагент"" в Соглашении.'
                                     |;uk='Обробка %1.
                                     |Операція не виконана!
                                     |Неможливо визначити ""Настройку ЕДО"".
                                     |Не заповнений реквізит ""Контрагент"" в Угоді.'");
									 
		УдалитьДокументыНеподходящиеДляФормированияЭД(
			ДокументыМассив,
			ДокументыБезУказанияКонтрагента,
			ШаблонСообщения);
	КонецЕсли;
		
КонецПроцедуры

// Получает данные о физическом (юридическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - Ссылка на элемент справочника, по которому надо получить данные.
//  БанковскийСчет - Банковский счет, если счет не основной.
//
Функция ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, Знач БанковскийСчет = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеЮрФизЛица = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ЮрФизЛицо, ТекущаяДата(),, БанковскийСчет);
	ДанныеЮрФизЛица.Вставить("Ссылка", ЮрФизЛицо);
	
	Если ДанныеЮрФизЛица.ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ЮрЛицо 
		И ДанныеЮрФизЛица.ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		
		ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ДанныеЮрФизЛица.ПолноеНаименование);
		
		ДанныеЮрФизЛица.Вставить("Фамилия", ФИО.Фамилия);
		ДанныеЮрФизЛица.Вставить("Имя", ФИО.Имя);
		ДанныеЮрФизЛица.Вставить("Отчество", ФИО.Отчество);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДанныеЮрФизЛица;
	
КонецФункции

// Возвращает текстовое описание организации.
//
// Параметры:
//  СведенияОКонтрагенте - Структура, сведения об организации, по которой надо составить описание.
//  Список - Строка, список запрашиваемых параметров организации.
//  СПрефиксом - Булево, признак вывода префикса параметра организации.
//
Функция ОписаниеОрганизации(СведенияОКонтрагенте, Список = "", СПрефиксом = Истина) Экспорт
	
	Возврат ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОКонтрагенте, Список, СПрефиксом);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с правами

// Проверяет наличие прав обрабатывать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОбработкиЭД() Экспорт
	
	Возврат (Пользователи.ЭтоПолноправныйПользователь(, , Ложь) ИЛИ Пользователи.РолиДоступны("ВыполнениеОбменаЭД"));
	
КонецФункции

// Проверяет наличие прав читать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоЧтенияЭД() Экспорт
	
	Возврат (Пользователи.ЭтоПолноправныйПользователь(, , Ложь) ИЛИ Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ЧтениеЭД"));
	
КонецФункции

// Проверяет наличие прав на открытие журнала регистрации.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОткрытияЖурналаРегистрации() Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(, , Ложь)
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Находит ссылку на справочник по переданному реквизиту.
//
// Параметры:
//  ИмяСправочника - Строка, имя справочника, объект которого надо найти,
//  ИмяРеквизита - Строка, имя реквизита, по которому будет проведен поиск,
//  ЗначРеквизита - произвольное значение, значение реквизита, по которому будет проведен поиск,
//  Владелец - Ссылка на владельца для поиска в иерархическом справочнике.
//
Функция НайтиСсылкуНаОбъектПоРеквизиту(ИмяСправочника, ИмяРеквизита, ЗначРеквизита, Владелец = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	ОбъектМетаданных = Метаданные.Справочники[ИмяСправочника];
	Если НЕ ОбщегоНазначения.ЭтоСтандартныйРеквизит(ОбъектМетаданных.СтандартныеРеквизиты, ИмяРеквизита) // нестандартный реквизит
		И НЕ ОбъектМетаданных.Реквизиты.Найти(ИмяРеквизита)<> Неопределено Тогда // другой реквизит
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИскСправочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК ИскСправочник
	|ГДЕ
	|	ИскСправочник."+ИмяРеквизита+" = &ЗначРеквизита";
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		Запрос.Текст = Запрос.Текст + " И ИскСправочник.Владелец = &Владелец";
		Запрос.УстановитьПараметр("Владелец", 	Владелец);
	КонецЕсли;
	Запрос.УстановитьПараметр("ЗначРеквизита", ЗначРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСсылкуНаНоменклатуруПоИдентификаторуНоменклатурыПоставщика(Идентификатор)
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СпрНоменклатура.Номенклатура КАК Ссылка
	               |ИЗ
	               |	Справочник.НоменклатураПоставщиков КАК СпрНоменклатура
	               |ГДЕ
	               |	СпрНоменклатура.Идентификатор = &Идентификатор";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДоговорКонтрагентаПоРеквизитам(РеквизитыДоговора)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДоговорыКонтрагентов.Ссылка КАК Договор
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Номер = &НомерДоговора
	|	И ДоговорыКонтрагентов.Дата = &ДатаДоговора
	|	И ДоговорыКонтрагентов.Контрагент = &Владелец";
	Запрос.УстановитьПараметр("НомерДоговора", РеквизитыДоговора.НомерДоговора);
	Запрос.УстановитьПараметр("ДатаДоговора", РеквизитыДоговора.ДатаДоговора);
	Запрос.УстановитьПараметр("Владелец", РеквизитыДоговора.Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Договор;
	
КонецФункции

Процедура УдалитьДокументыНеподходящиеДляФормированияЭД(МассивДокументов, МассивДокументовДляУдаления, ШаблонСообщения)
	
	Для Каждого Документ Из МассивДокументовДляУдаления Цикл
		Найденный = МассивДокументов.Найти(Документ);
		Если Найденный <> Неопределено Тогда
			МассивДокументов.Удалить(Найденный);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(Документ)), 
				Документ);
		КонецЕсли;
		
	КонецЦикла
	
КонецПроцедуры

Функция НайтиСсылкуНаНоменклатуруПоНоменклатуреПоставщика(НоменклатураПоставщика)
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпрНоменклатура.Номенклатура Как Ссылка
	|ИЗ
	|	Справочник.НоменклатураПоставщиков КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.Ссылка = &НоменклатураПоставщика";
	
	Запрос.УстановитьПараметр("НоменклатураПоставщика", НоменклатураПоставщика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
