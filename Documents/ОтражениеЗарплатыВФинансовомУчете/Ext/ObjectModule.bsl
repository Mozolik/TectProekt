﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИнициализироватьДокумент(ДанныеЗаполнения);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Организация, КонецМесяца(ПериодРегистрации));
	
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПроводкиПоРаботникам = ПараметрыУчетнойПолитики.ПроводкиПоРаботникам
	КонецЕсли;
	
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Тогда
			Строка.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЗаймыВыданные;
			Строка.АналитикаАктивовПассивов = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("ПериодРегистрации");
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Месяц"" не заполнено';uk='Поле ""Місяць"" не заповнено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"ПериодРегистрацииСтрокой",
			,
			Отказ);
		
	КонецЕсли;
	
	Если НачисленнаяЗарплатаИВзносы.Количество() = 0 И НачисленныйНДФЛ.Количество() = 0
		И УдержаннаяЗарплата.Количество() = 0 И НачисленныеПроцентыПоЗаймам.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru='Списки документа не содержат ни одной строки';uk='Списки документа не містять жодного рядка'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносы Цикл
		Если Не ЗначениеЗаполнено(Строка.Сумма) И Не ЗначениеЗаполнено(Строка.ВзносыВсего) Тогда
			
			ТекстСообщения = НСтр("ru='Не заполнена сумма начисления и взносов в строке %1 списка ""Начисления и взносы""';uk='Не заповнена сума нарахування та внесків в рядку %1 списку ""Нарахування та внески""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "Сумма"),
				,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленнаяЗарплатаИВзносы.СпособОтраженияЗарплатыВБухучете");
	
	СтруктураОтбора = Новый Структура("СпособОтраженияЗарплатыВБухучете", Справочники.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка());
	НайденныеСтроки = НачисленнаяЗарплатаИВзносы.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого Строка Из НайденныеСтроки Цикл
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы Тогда
			Продолжить;
		КонецЕсли;
		
		Если (Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС) И
			Не ЗначениеЗаполнено(Строка.ВзносыВсего) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru='Не заполнена колонка ""Способ отражения"" в строке %1 списка ""Начисления и взносы""';uk='Не заповнена колонка ""Спосіб відображення"" в рядку %1 списку ""Нарахування та внески""'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "СпособОтраженияЗарплатыВБухучете"),
			,
			Отказ);
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ПодразделениеПредприятия");
	
	СтруктураОтбора = Новый Структура("ВидОперации", Перечисления.ВидыОперацийПоЗарплате.НДФЛДоходыКонтрагентов);
	НайденныеСтроки = НачисленныйНДФЛ.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого Строка Из НайденныеСтроки Цикл
		
		Если ЗначениеЗаполнено(Строка.ПодразделениеПредприятия) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru='Не заполнена колонка ""Подразделение"" в строке %1 списка ""НДФЛ""';uk='Не заповнена колонка ""Підрозділ"" в рядку %1 списку ""ПДФО""'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленныйНДФЛ", Строка.НомерСтроки, "ПодразделениеПредприятия"),
			,
			Отказ);
	КонецЦикла;
	
	ПроверитьНаличиеБазыРаспределения(Отказ);
	
	Если Сводно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ФизическоеЛицо");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("УдержаннаяЗарплата"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("НачисленныеПроцентыПоЗаймам"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ИспользоватьПрочиеАктивыПассивы = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов");
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок
			И Не ЗначениеЗаполнено(Строка.СтатьяДоходов) Тогда
			
			ТекстСообщения = НСтр("ru='Не заполнена колонка ""Статья доходов"" в строке %1 списка ""Удержания""';uk='Не заповнена колонка ""Стаття доходів"" в рядку %1 списку ""Утримання""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяДоходов"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок Тогда
			Продолжить;
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Строка.СтатьяАктивовПассивов) И ИспользоватьПрочиеАктивыПассивы Тогда
			
			ТекстСообщения = НСтр("ru='Не заполнена колонка ""Статья пассивов"" в строке %1 списка ""Удержания""';uk='Не заповнена колонка ""Стаття пасивів"" в рядку %1 списку ""Утримання""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяАктивовПассивов"),
				,
				Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяАктивовПассивов");
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяДоходов");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ОтражениеЗарплатыВФинансовомУчете.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по прочим доходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по партиям прочих расходов.
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	
	//Движения по трудозатратам незавершенного производства
	ОтражениеЗарплатыВФинансовомУчетеУП.ОтразитьТрудозатратыНезавершенногоПроизводства(ДополнительныеСвойства, Движения, Отказ);

	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	//Движения по отражению зарплаты в финансовом учете
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияОтражениеЗарплатыВФинансовомУчете(ДополнительныеСвойства, Движения, Отказ);
	
	//Движения по отражению зарплаты в учете прочих пассивов
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по денежным средствам.
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПроверитьНаличиеБазыРаспределения(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленнаяЗарплата.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	НачисленнаяЗарплата.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	&НачисленнаяЗарплата КАК НачисленнаяЗарплата
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодразделениеПредприятия,
	|	ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТрудозатратыНезавершенногоПроизводства.Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ТрудозатратыНезавершенногоПроизводства.Сотрудник
	|	КОНЕЦ КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТБазаРаспределения
	|ИЗ
	|	РегистрНакопления.ТрудозатратыНезавершенногоПроизводства КАК ТрудозатратыНезавершенногоПроизводства
	|ГДЕ
	|	ТрудозатратыНезавершенногоПроизводства.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ТрудозатратыНезавершенногоПроизводства.Подразделение В
	|			(ВЫБРАТЬ
	|				Т.ПодразделениеПредприятия
	|			ИЗ
	|				ВТДанныеДокумента КАК Т)
	|	И ТрудозатратыНезавершенногоПроизводства.Организация = &Организация
	|	И ТрудозатратыНезавершенногоПроизводства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Выработка.Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ТЧСотрудники.Сотрудник
	|	КОНЕЦ
	|ИЗ
	|	Документ.ВыработкаСотрудников.Сотрудники КАК ТЧСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыработкаСотрудников КАК Выработка
	|		ПО ТЧСотрудники.Ссылка = Выработка.Ссылка
	|ГДЕ
	|	Выработка.Подразделение В
	|			(ВЫБРАТЬ
	|				Т.ПодразделениеПредприятия
	|			ИЗ
	|				ВТДанныеДокумента КАК Т)
	|	И Выработка.Проведен
	|	И Выработка.Организация = &Организация
	|	И Выработка.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДанныеДокумента.НомерСтроки КАК НомерСтроки,
	|	ВТДанныеДокумента.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	ВТДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.НачисленоСдельноДоход) КАК ВидОперации
	|ИЗ
	|	ВТДанныеДокумента КАК ВТДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБазаРаспределения КАК ВТБазаРаспределения
	|		ПО ВТДанныеДокумента.ПодразделениеПредприятия = ВТБазаРаспределения.Подразделение
	|			И ВТДанныеДокумента.ФизическоеЛицо = ВТБазаРаспределения.ФизическоеЛицо
	|ГДЕ
	|	ВТБазаРаспределения.ФизическоеЛицо ЕСТЬ NULL 
	|	И ВТДанныеДокумента.ПодразделениеПредприятия <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)";
	
	СтруктураОтбора = Новый Структура("ВидОперации", Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход);
	
	Если Сводно Тогда
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносы.Выгрузить(СтруктураОтбора, "ПодразделениеПредприятия, НомерСтроки"));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо", "ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизическоеЛицо");
	Иначе
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносыПоФизлицам.Выгрузить(СтруктураОтбора, "ПодразделениеПредприятия, ФизическоеЛицо, НомерСтроки"));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода",       НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ОкончаниеПериода",    КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("Сводно",              Сводно);
	Запрос.УстановитьПараметр("Ссылка",              Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	СтруктураОтбора = Новый Структура("ПодразделениеПредприятия, ВидОперации");	
	
	ТекстСообщенияСводно = НСтр("ru='В подразделении %1 не регистрировалась выработка сотрудников (строка %2 списка ""Начисленная зарплата и взносы"")';uk='У підрозділі %1 не реєструвався виробіток працівників (рядок %2 списку ""Нарахована зарплата та внески"")'");
	ТекстСообщенияДетально = НСтр("ru='Выработка сотрудника %1 в подразделении %2 не регистрировалась (строка %3 списка ""Начисленная зарплата и взносы"")';uk='Виробіток працівника %1 у підрозділі %2 не реєструвався (рядок %3 списку ""Нарахована зарплата та внески"")'");
	
	Пока Выборка.Следующий() Цикл
		
		Если Сводно Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщенияСводно, Выборка.ПодразделениеПредприятия, Выборка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Выборка.НомерСтроки, "ПодразделениеПредприятия"),
				,
				Отказ);
			
		Иначе
			
			ЗаполнитьЗначенияСвойств(СтруктураОтбора, Выборка);
			
			НайденныеСтроки = НачисленнаяЗарплатаИВзносы.НайтиСтроки(СтруктураОтбора);
			
			Для Каждого Строка Из НайденныеСтроки Цикл
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщенияДетально, Выборка.ФизическоеЛицо, Строка.ПодразделениеПредприятия, Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "ПодразделениеПредприятия"),
					,
					Отказ);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли