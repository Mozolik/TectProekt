﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подсистемы "Международный финансовый учет".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает параметры регистра для отражения в международном учете.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра, для которого возвращаются параметры отражения.
//
// Возвращаемое значение:
//	Структура - Структура возвращаемых параметров.
//
Функция ПараметрыРегистра(ИмяРегистра) Экспорт

	ПараметрыОтражения = Новый Структура();
	ПараметрыОтражения.Вставить("Показатели", МеждународныйУчетСерверПовтИсп.Показатели(ИмяРегистра));
	ПараметрыОтражения.Вставить("ПоказателиВВалюте", МеждународныйУчетСерверПовтИсп.ПоказателиВВалюте(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиУточненияСчета", МеждународныйУчетСерверПовтИсп.ИсточникиУточненияСчета(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиПодразделений", МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений(ИмяРегистра));
	ПараметрыОтражения.Вставить("ИсточникиСубконто", МеждународныйУчетСерверПовтИсп.ИсточникиСубконто(ИмяРегистра));
	
	Возврат ПараметрыОтражения;

КонецФункции

// Определяет источники уточнения счета, доступные в регистре и их свойства.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - название источника уточнения счета. 
//				   Значение - структура свойств источника уточнения счета.
//
Функция ИсточникиУточненияСчета(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваИсточника = СвойстваИсточникаУточненияСчета();
	ИсточникиУточненияСчета = РегистрыНакопления[ИмяРегистра].ИсточникиУточненияСчета(СвойстваИсточника);
	
	Возврат ИсточникиУточненияСчета;

КонецФункции

// Определяет источники подразделений регистра и их свойства.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//				   Значение - структура свойств источника. 
//
Функция ИсточникиПодразделений(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИсточникиПодразделений = РегистрыНакопления[ИмяРегистра].ИсточникиПодразделений();
	
	Возврат ИсточникиПодразделений;

КонецФункции

// Определяет источники заполнения субконто.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Массив - массив атрибутов регистра.
//
Функция ИсточникиСубконто(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИсточникиСубконто = РегистрыНакопления[ИмяРегистра].ИсточникиСубконто();
	
	Возврат ИсточникиСубконто;

КонецФункции

// Определяет показатели регистра.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	СвойстваПоказателей = СвойстваПоказателей();
	Показатели = РегистрыНакопления[ИмяРегистра].Показатели(СвойстваПоказателей);
	
	Возврат Показатели;

КонецФункции

// Определяет показатели в валюте регистра.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//				   Значение - структура свойств показателя.
//
Функция ПоказателиВВалюте(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	СвойстваПоказателей = СвойстваПоказателейВВалюте();
	ПоказателиВВалюте = РегистрыНакопления[ИмяРегистра].ПоказателиВВалюте(СвойстваПоказателей);
	
	Возврат ПоказателиВВалюте;

КонецФункции

//++ НЕ УТКА

// Получает свойства счета международного учета
//
// Параметры:
//  Счет - ПланСчетовСсылка.Междунродный - Счет международного плана счетов.
//
// Возвращаемое значение:
//  Структура - свойства счета
//				Ключ - имя свойства счета.
//				Значение - значение свойства.
//
Функция ПолучитьСвойстваСчета(Знач Счет) Экспорт

	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Ссылка"                          , ПланыСчетов.Международный.ПустаяСсылка());
	ДанныеСчета.Вставить("Наименование"                    , "");
	ДанныеСчета.Вставить("НаименованиеМеждународное"       , "");
	ДанныеСчета.Вставить("Описание"                        , "");
	ДанныеСчета.Вставить("Рекласс"                         , Ложь);
	ДанныеСчета.Вставить("ИсключитьИзРасчетаКурсовыхРазниц", Ложь);
	ДанныеСчета.Вставить("Код"                             , "");
	ДанныеСчета.Вставить("Родитель"                        , ПланыСчетов.Международный.ПустаяСсылка());
	ДанныеСчета.Вставить("Вид"                             , Неопределено);
	ДанныеСчета.Вставить("Забалансовый"                    , Ложь);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках" , Ложь);
	ДанныеСчета.Вставить("Валютный"                        , Ложь);
	ДанныеСчета.Вставить("КоличествоСубконто"              , 0);
	
	МаксКоличествоСубконто	= Метаданные.ПланыСчетов.Международный.МаксКоличествоСубконто;
	
	Для ИндексСубконто = 1 По МаксКоличествоСубконто Цикл
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", Ложь);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат ДанныеСчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПС.Ссылка,
	|	ПС.Родитель,
	|	ПС.Код,
	|	ПС.Наименование,
	|	ПС.Вид,
	|	ПС.Забалансовый,
	|	ПС.ЗапретитьИспользоватьВПроводках,
	|	ПС.Валютный
	|ИЗ
	|	ПланСчетов.Международный КАК ПС
	|ГДЕ
	|	ПС.Ссылка = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МеждународныйВидыСубконто.НомерСтроки КАК НомерСтроки,
	|	МеждународныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	МеждународныйВидыСубконто.ВидСубконто.Наименование КАК Наименование,
	|	МеждународныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения,
	|	МеждународныйВидыСубконто.ТолькоОбороты КАК ТолькоОбороты
	|ИЗ
	|	ПланСчетов.Международный.ВидыСубконто КАК МеждународныйВидыСубконто
	|ГДЕ
	|	МеждународныйВидыСубконто.Ссылка = &Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	МеждународныйВидыСубконто.НомерСтроки";
	
	МассивРезультатов	= Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеСчета, Выборка);
	КонецЕсли;
		
	ВыборкаВидыСубконто	= МассивРезультатов[1].Выбрать();
		
	ДанныеСчета.КоличествоСубконто	= ВыборкаВидыСубконто.Количество();
		
	ИндексСубконто	= 0;
		
	Пока ВыборкаВидыСубконто.Следующий() Цикл
		
		ИндексСубконто	= ИндексСубконто + 1;
		
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   ВыборкаВидыСубконто.ВидСубконто);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  ВыборкаВидыСубконто.Наименование);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   ВыборкаВидыСубконто.ТипЗначения);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", ВыборкаВидыСубконто.ТолькоОбороты);
		
	КонецЦикла;
	
	Возврат ДанныеСчета;
	
КонецФункции

// Возвращает массив документов, отражаемых в международном учете.
// Если задано имя регистра, то массив документов определяется в модуле менеджера этого регистра.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра. 
//
// Возвращаемое значение:
//	Массив - массив документов к отражению в международном учете.
//
Функция ДокументыКОтражениюВМеждународномУчете(ИмяРегистра = Неопределено) Экспорт

	Если ИмяРегистра = Неопределено Тогда
		ДокументыКОтражению = Новый Массив;
		Регистраторы = Метаданные.РегистрыСведений.ОтражениеДокументовВМеждународномУчете.СтандартныеРеквизиты.Регистратор.Тип.Типы();
		Для Каждого Регистратор ИЗ Регистраторы Цикл
			МетаОбъект = Метаданные.НайтиПоТипу(Регистратор);
			ДокументыКОтражению.Добавить(МетаОбъект.Имя);
		КонецЦикла;
	Иначе
		ДокументыКОтражению = РегистрыНакопления[ИмяРегистра].ДокументыКОтражениюВМеждународномУчете();
	КонецЕсли;
	
	Возврат ДокументыКОтражению;

КонецФункции

// Возвращает типы атрибута регистра.
//
// Параметры:
//	ИмяРегистра - Строка - имя регистра.
//	ИмяАтрибута - Строка - имя атрибута.
//
// Возвращаемое значение:
//	Массив - массив типов атрибута регистра.
//
Функция ТипыАтрибутаРегистра(ИмяРегистра, ИмяАтрибута) Экспорт

	МассивТипов = Новый Массив;
	Измерение = Метаданные.РегистрыНакопления[ИмяРегистра].Измерения.Найти(ИмяАтрибута);
	Если Измерение <> Неопределено Тогда
		МассивТипов = Измерение.Тип.Типы();
	КонецЕсли;
	
	Реквизит = Метаданные.РегистрыНакопления[ИмяРегистра].Реквизиты.Найти(ИмяАтрибута);
	Если Реквизит <> Неопределено Тогда
		МассивТипов = Реквизит.Тип.Типы();
	КонецЕсли;
	
	Возврат МассивТипов;
	
КонецФункции

// Возвращает статус на основе приоритетов статусов.
// 
// Параметры:
//	ТекущийСтатус - ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - текущий статус.
//	НовыйСтатус - ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - текущий статус.
//
//	ПеречислениеСсылка.СтатусыОтраженияВМеждународномУчете - устанавливаемый статус.
//
Функция Статус(ТекущийСтатус, НовыйСтатус) Экспорт

	ПриоритетТекущегоСтатуса = ПриоритетСтатуса(ТекущийСтатус);
	ПриоритетНовогоСтатуса = ПриоритетСтатуса(НовыйСтатус);
	Возврат ?(ПриоритетТекущегоСтатуса = Неопределено ИЛИ ПриоритетНовогоСтатуса < ПриоритетТекущегоСтатуса, НовыйСтатус, ТекущийСтатус);

КонецФункции

// Получает текущую дату запрета формирования проводок международного учета
//
// Параметры:
//  Организация  - <СправочникСсылка.Организации, Массив> - организация (или массив организаций) 
//                 для которой требуется получить дату запрета формирования проводок
//                 если не указана, то будет получена общая дата запрета для всех организаций
//
// Возвращаемое значение:
//   <Дата>   - дата запрета формирования проводок по международному учету
//
Функция ДатаЗапретаФормированияПроводок(Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(ДатыЗапрета.ДатаЗапрета, ДЕНЬ) КАК ДатаЗапрета
	|ИЗ
	|	РегистрСведений.ДатыЗапретаФормированияПроводокМеждународныйУчет КАК ДатыЗапрета
	|ГДЕ
	|	ДатыЗапрета.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И ДатыЗапрета.ДатаЗапрета <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КОНЕЦПЕРИОДА(ДатыЗапрета.ДатаЗапрета, ДЕНЬ) КАК ДатаЗапрета
	|ИЗ
	|	РегистрСведений.ДатыЗапретаФормированияПроводокМеждународныйУчет КАК ДатыЗапрета
	|ГДЕ
	|	ДатыЗапрета.Организация В(&Организации)
	|	И ДатыЗапрета.ДатаЗапрета <> ДАТАВРЕМЯ(1, 1, 1)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатыЗапрета.ДатаЗапрета");
	
	Запрос.УстановитьПараметр("Организации", Организация);
	ДатыЗапрета = Запрос.ВыполнитьПакет();
	
	ПоОрганизации = ДатыЗапрета[1].Выбрать();
	Если ПоОрганизации.Следующий() Тогда
		Возврат ПоОрганизации.ДатаЗапрета;
	КонецЕсли;
	
	ДляВсех = ДатыЗапрета[0].Выбрать();
	Если ДляВсех.Следующий() Тогда
		Возврат ДляВсех.ДатаЗапрета;
	КонецЕсли;
	
	Возврат '00010101';

КонецФункции // ДатаЗапретаФормированияПроводок()
//-- НЕ УТКА
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СвойстваИсточникаУточненияСчета()

	// Расшифровка свойств источника:
	// ИмяПоля - имя атрибута регистра накопления, из которого планируется получать источник уточнения счета.
	
	Возврат "ИмяПоля";

КонецФункции

Функция СвойстваПоказателей()

	СвойстваПоказателей = Новый Структура("СвойстваПоказателей, СвойстваРесурсов");
	
	// Расшифровка свойств показателей:
	// Ресурсы - массив ресурсов регистра, связанных с показателем.
	СвойстваПоказателей.СвойстваПоказателей = "Ресурсы";
	
	// Расшифровка свойств ресурсов:
	// Имя - имя ресурса регистра.
	// ИсточникВалюты - источник валюты для ресурса регистра.
	СвойстваПоказателей.СвойстваРесурсов = "Имя, ИсточникВалюты";
	
	Возврат СвойстваПоказателей;

КонецФункции

Функция СвойстваПоказателейВВалюте()

	// Расшифровка свойств показателей:
	// ИсточникВалюты - источник валюты для показателя регистра.
	
	Возврат "ИсточникВалюты";

КонецФункции

//++ НЕ УТКА
Функция ПриоритетСтатуса(Статус)

	Возврат ПриоритетыСтатусов().Получить(Статус);

КонецФункции

Функция ПриоритетыСтатусов()

	ПриоритетыСтатусов = Новый Соответствие;
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОжидаетсяОтражениеВРеглУчете, 1);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчетеВручную, 2);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете, 3);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете, 4);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчетеВручную, 5);
	ПриоритетыСтатусов.Вставить(Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете, 6);
	
	Возврат ПриоритетыСтатусов;

КонецФункции
//-- НЕ УТКА
#КонецОбласти
