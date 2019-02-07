﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает структура с данными карты лояльности
//
// Параметры
//  КартаЛояльности - СправочникСсылка.КартыЛояльности
//
// Возвращаемое значение
//  Структура - Данные карты лояльности
//
Функция ПолучитьДанныеКартыЛояльности(КартаЛояльности, ПроверятьДоступность = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураДанныхКарты = КартыЛояльностиСервер.ПолучитьСтруктуруДанныхКартыЛояльности();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КартыЛояльности.Ссылка                         КАК Ссылка,
	|	КартыЛояльности.Наименование                   КАК Наименование,
	|	КартыЛояльности.Владелец                       КАК ВидКарты,
	|	КартыЛояльности.Статус                         КАК Статус,
	|	КартыЛояльности.Владелец.ДатаНачалаДействия    КАК ДатаНачалаДействия,
	|	КартыЛояльности.Владелец.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	КартыЛояльности.Партнер                        КАК Партнер,
	|	Партнеры.ЮрФизЛицо          КАК ЮрФизЛицо,
	|	Партнеры.Представление      КАК ПартнерПредставление,
	|	Партнеры.НаименованиеПолное КАК ФИОПартнера,
	|	Партнеры.ДатаРождения       КАК ДатаРожденияПартнера,
	|	Партнеры.Пол                КАК ПолПартнера,
	|	КартыЛояльности.Контрагент                     КАК Контрагент,
	|	КартыЛояльности.Соглашение                     КАК Соглашение,
	|	КартыЛояльности.Штрихкод                       КАК Штрихкод,
	|	КартыЛояльности.МагнитныйКод                   КАК МагнитныйКод
	|ИЗ
	|	Справочник.КартыЛояльности КАК КартыЛояльности
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|		ПО Партнеры.Ссылка = КартыЛояльности.Партнер
	|ГДЕ
	|	КартыЛояльности.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", КартаЛояльности);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураДанныхКарты, Выборка);
	КонецЕсли;
	
	Если ПроверятьДоступность Тогда
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ПравоДоступа("Чтение", Метаданные.Справочники.Партнеры) Тогда
		
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Партнеры.Ссылка
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|ГДЕ
			|	Партнеры.Ссылка = &Партнер
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Контрагенты.Ссылка
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Ссылка = &Контрагент
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СоглашенияСКлиентами.Ссылка
			|ИЗ
			|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
			|ГДЕ
			|	СоглашенияСКлиентами.Ссылка = &Соглашение
			|");
			
			Запрос.УстановитьПараметр("Партнер",    СтруктураДанныхКарты.Партнер);
			Запрос.УстановитьПараметр("Контрагент", СтруктураДанныхКарты.Контрагент);
			Запрос.УстановитьПараметр("Соглашение", СтруктураДанныхКарты.Соглашение);
			
			Результат = Запрос.ВыполнитьПакет();
			
			Если ЗначениеЗаполнено(СтруктураДанныхКарты.Партнер) Тогда
				СтруктураДанныхКарты.ПартнерДоступен = Не Результат[0].Пустой();
			КонецЕсли;
			Если ЗначениеЗаполнено(СтруктураДанныхКарты.Контрагент) Тогда
				СтруктураДанныхКарты.КонтрагентДоступен = Не Результат[1].Пустой();
			КонецЕсли;
			Если ЗначениеЗаполнено(СтруктураДанныхКарты.Соглашение) Тогда
				СтруктураДанныхКарты.СоглашениеДоступно = Не Результат[2].Пустой();
			КонецЕсли;
		
		Иначе
			
			СтруктураДанныхКарты.ПартнерДоступен    = Ложь;
			СтруктураДанныхКарты.КонтрагентДоступен = Ложь;
			СтруктураДанныхКарты.СоглашениеДоступно = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураДанныхКарты;
	
КонецФункции

#Область ПоискКартЛояльности

// Функция выполняет поиск карт лояльности по данным, полученным из считывателя
// магнитных карт
//
// Параметры
//  Данные - Массив данных, полученный из считывателя магнитных карт.
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные карты лояльности
//  и НеЗарегистрированныеКартыЛояльности.
//
Функция НайтиКартыЛояльностиПоДаннымСоСчитывателяМагнитныхКарт(Данные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗарегистрированныеКартыЛояльности = Новый Массив;
	НеЗарегистрированныеКартыЛояльности = Новый Массив;
	
	РасшифрованныеДанные = Данные[1][3];
	Если РасшифрованныеДанные <> Неопределено Тогда
		Для Каждого Структура Из РасшифрованныеДанные Цикл
			
			ШаблонМагнитнойКарты = Структура.Шаблон;
			КодКарты             = Данные[0];
			Для Каждого ДанныеПоля Из Структура.ДанныеДорожек Цикл
				Если ДанныеПоля.Поле = Перечисления.ПоляШаблоновМагнитныхКарт.Код Тогда
					КодКарты = ДанныеПоля.ЗначениеПоля;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ШаблоныКодовКартЛояльности.Ссылка                                              КАК Ссылка,
			|	ШаблоныКодовКартЛояльности.Ссылка.Статус                                       КАК Статус,
			|	ШаблоныКодовКартЛояльности.Ссылка.Персонализирована                            КАК Персонализирована,
			|	ШаблоныКодовКартЛояльности.Ссылка.ТипКарты                                     КАК ТипКарты,
			|	ШаблоныКодовКартЛояльности.Ссылка.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании,
			|	ШаблоныКодовКартЛояльности.Ссылка.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
			|	ШаблоныКодовКартЛояльности.Ссылка.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия
			|ПОМЕСТИТЬ ВидыКарт
			|ИЗ
			|	Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
			|ГДЕ
			|	ШаблоныКодовКартЛояльности.НачалоДиапазонаМагнитногоКода  <= &КодКарты
			|	И ШаблоныКодовКартЛояльности.КонецДиапазонаМагнитногоКода >= &КодКарты
			|	И ШаблоныКодовКартЛояльности.ДлинаМагнитногоКода           = &ДлинаКода
			|	И ШаблоныКодовКартЛояльности.ШаблонМагнитнойКарты          = &ШаблонМагнитнойКарты
			|	И ШаблоныКодовКартЛояльности.Ссылка.Статус                 = ЗНАЧЕНИЕ(Перечисление.СтатусыВидовКартЛояльности.Действует)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КартыЛояльности.Ссылка       КАК Ссылка,
			|	КартыЛояльности.Наименование КАК Наименование,
			|	КартыЛояльности.Штрихкод     КАК Штрихкод,
			|	КартыЛояльности.МагнитныйКод КАК МагнитныйКод,
			|	КартыЛояльности.Партнер      КАК Партнер,
			|	КартыЛояльности.Контрагент   КАК Контрагент,
			|	КартыЛояльности.Соглашение   КАК Соглашение,
			|	КартыЛояльности.Статус       КАК Статус,
			|	
			|	КартыЛояльности.Владелец                                              КАК ВидКарты,
			|	КартыЛояльности.Владелец.Статус                                       КАК СтатусВидаКарты,
			|	КартыЛояльности.Владелец.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
			|	КартыЛояльности.Владелец.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
			|	КартыЛояльности.Владелец.Персонализирована                            КАК Персонализирована,
			|	КартыЛояльности.Владелец.ТипКарты                                     КАК ТипКарты,
			|	КартыЛояльности.Владелец.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании
			|ПОМЕСТИТЬ КартыЛояльности
			|ИЗ
			|	Справочник.КартыЛояльности КАК КартыЛояльности
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыКарт
			|		ПО ВидыКарт.Ссылка = КартыЛояльности.Владелец
			|		 И КартыЛояльности.МагнитныйКод = &КодКарты
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	1                            КАК Порядок,
			|	КартыЛояльности.Ссылка       КАК Ссылка,
			|	КартыЛояльности.Наименование КАК Наименование,
			|	КартыЛояльности.Штрихкод     КАК Штрихкод,
			|	КартыЛояльности.МагнитныйКод КАК МагнитныйКод,
			|	КартыЛояльности.Партнер      КАК Партнер,
			|	КартыЛояльности.Контрагент   КАК Контрагент,
			|	КартыЛояльности.Соглашение   КАК Соглашение,
			|	КартыЛояльности.Статус       КАК Статус,
			|	
			|	КартыЛояльности.ВидКарты                                     КАК ВидКарты,
			|	КартыЛояльности.СтатусВидаКарты                              КАК СтатусВидаКарты,
			|	КартыЛояльности.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
			|	КартыЛояльности.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
			|	КартыЛояльности.Персонализирована                            КАК Персонализирована,
			|	КартыЛояльности.ТипКарты                                     КАК ТипКарты,
			|	КартыЛояльности.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании
			|ИЗ
			|	КартыЛояльности
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	2                                                         КАК Порядок,
			|	ЗНАЧЕНИЕ(Справочник.КартыЛояльности.ПустаяСсылка)         КАК Ссылка,
			|	""""                                                      КАК Наименование,
			|	""""                                                      КАК Штрихкод,
			|	&КодКарты                                                 КАК МагнитныйКод,
			|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)                КАК Партнер,
			|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)             КАК Контрагент,
			|	ЗНАЧЕНИЕ(Справочник.СоглашенияСКлиентами.ПустаяСсылка)    КАК Соглашение,
			|	ЗНАЧЕНИЕ(Перечисление.СтатусыКартЛояльности.ПустаяСсылка) КАК Статус,
			|	
			|	ВидыКарт.Ссылка                                       КАК ВидКарты,
			|	ВидыКарт.Статус                                       КАК СтатусВидаКарты,
			|	ВидыКарт.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
			|	ВидыКарт.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
			|	ВидыКарт.Персонализирована                            КАК Персонализирована,
			|	ВидыКарт.ТипКарты                                     КАК ТипКарты,
			|	ВидыКарт.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании
			|ИЗ
			|	ВидыКарт КАК ВидыКарт
			|ГДЕ
			|	(НЕ ВидыКарт.Ссылка В
			|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|					Т.ВидКарты
			|				ИЗ
			|					КартыЛояльности КАК Т))
			|УПОРЯДОЧИТЬ ПО
			|	Порядок Возр
			|");
			
			Запрос.УстановитьПараметр("ШаблонМагнитнойКарты", ШаблонМагнитнойКарты);
			Запрос.УстановитьПараметр("КодКарты",             КодКарты);
			Запрос.УстановитьПараметр("ДлинаКода",            СтрДлина(КодКарты));
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
			
				Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
					НоваяСтрока = КартыЛояльностиСервер.ПолучитьСтруктуруДанныхКартыЛояльности();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
					ЗарегистрированныеКартыЛояльности.Добавить(НоваяСтрока);
				Иначе
					НоваяСтрока = КартыЛояльностиСервер.ПолучитьСтруктуруДанныхКартыЛояльности();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
					НеЗарегистрированныеКартыЛояльности.Добавить(НоваяСтрока);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура("ЗарегистрированныеКартыЛояльности, НеЗарегистрированныеКартыЛояльности");
	ВозвращаемоеЗначение.ЗарегистрированныеКартыЛояльности   = ЗарегистрированныеКартыЛояльности;
	ВозвращаемоеЗначение.НеЗарегистрированныеКартыЛояльности = НеЗарегистрированныеКартыЛояльности;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Функция выполняет поиск карт лояльности по штрихкоду
//
// Параметры
//  Штрихкод - Строка
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные карты лояльности
//  и НеЗарегистрированныеКартыЛояльности.
//
Функция НайтиКартыЛояльностиПоШтрихкоду(Штрихкод) Экспорт
	
	Возврат КартыЛояльностиСервер.НайтиКартыЛояльности(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
