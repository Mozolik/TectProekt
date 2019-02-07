﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		Список.ТекстЗапроса = ТекстЗапросаСписокЗаявокСУчетомВедомостей();
	КонецЕсли;
	//-- НЕ УТ
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Элементы.СоздатьОплатуЛизингодателю.Видимость = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Элементы.СписокСоздатьВыдачуЗаймовСотруднику.Видимость = Ложь;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") И Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаймыСотрудникам") Тогда
		Элементы.СписокСоздатьВыдачуЗаймовСотруднику.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ЗаявительОтбор.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств));
			
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	// КомандыЭДО
	ОбменСКонтрагентами.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюЭДО);
	// Конец КомандыЭДО
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Заявитель = Настройки.Получить("Заявитель");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Заявитель",
		Заявитель,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Заявитель));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаявительОтборПриИзменении(Элемент)
	
	ЗаявительОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ЕстьФайлы" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаСписка = Элементы.Список.ТекущиеДанные;
		ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы",
			Новый Структура("ВладелецФайла", СтрокаСписка.Ссылка),
			ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствКлиенту()
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствПодотчетнику()
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатаВДругуюОрганизацию(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратВДругуюОрганизацию(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеВБюджет(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеВБюджет"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочаяВыдачаДенежныхСредств(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВнутреннююПередачуДенежныхСредств(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеТаможне(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеТаможне"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатаЗаработнойПлаты(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуПоКредитам(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуПоДепозитам(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеНаДепозиты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуПоЗаймамКонтрагенту(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаЗаймов"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуПоЗаймамСотруднику(Команда)
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаЗаймаСотруднику"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатуЛизингодателю(Команда)
	
	СоздатьЗаявкуНаРасходованиеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаЛизингодателю"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРасходныйКассовыйОрдер(Команда)
	
	ФинансыКлиент.СоздатьДокументОплатыНаОснованииЗаявокНаРасходДС(
		Элементы.Список,
		"РасходныйКассовыйОрдер");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеБезналичныхДС(Команда)
	
	ФинансыКлиент.СоздатьДокументОплатыНаОснованииЗаявокНаРасходДС(
		Элементы.Список,
		"СписаниеБезналичныхДенежныхСредств");
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ЗаявительОтборПриИзмененииНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Заявитель",
		Заявитель,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Заявитель));
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Неопределено, Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьЗаявкуНаРасходованиеДенежныхСредств(ХозяйственнаяОперация)
	
	Основание = Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты") Тогда
		Основание.Вставить("ХозяйственнаяОперацияПоЗарплате", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту"));
		Основание.Вставить("ФормаОплатыЗаявки", ПредопределенноеЗначение("Перечисление.ФормыОплаты.Безналичная"));
	КонецЕсли;
	
	СтруктураПараметры = Новый Структура("Основание", Основание);
	
	ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.Заявитель.Видимость = Не ЗначениеЗаполнено(Заявитель);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласована(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""Не согласована"". Продолжить?';uk='У виділених у списку заявок буде встановлено статус ""Не погоджена"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласована");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласована';uk='Не погоджена'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласована(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""Согласована"". Продолжить?';uk='У виділених у списку заявках буде встановлено статус ""Погоджена"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусСогласованаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласованаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Согласована");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), "Согласована");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОплате(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""К оплате"". Продолжить?';uk='У виділених у списку заявок буде встановлено статус ""До оплати"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОплатеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОплатеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОплате");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='К оплате';uk='До оплати'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклонена(Команда)
	
	ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""Отклонена"". Продолжить?';uk='У виділених у списку заявок буде встановлено статус ""Скасована"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтклоненаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклоненаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Отклонена");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), "Отклонена");

КонецПроцедуры

//++ НЕ УТ
&НаСервере
Функция ТекстЗапросаСписокЗаявокСУчетомВедомостей()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Заявка.Ссылка,
	|	Заявка.ПометкаУдаления,
	|	Заявка.Номер,
	|	Заявка.Дата,
	|	Заявка.Проведен,
	|	Заявка.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты)
	|			ТОГДА Заявка.ХозяйственнаяОперацияПоЗарплате
	|		ИНАЧЕ Заявка.ХозяйственнаяОперация
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	Заявка.СуммаДокумента,
	|	Заявка.Валюта,
	|	Заявка.БанковскийСчет,
	|	Заявка.Касса,
	|	Заявка.ЖелательнаяДатаПлатежа КАК ДатаПлатежа,
	|	ВЫБОР
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику)
	|			ТОГДА Заявка.ПодотчетноеЛицо
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию)
	|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию)
	|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств)
	|			ТОГДА Заявка.ОрганизацияПолучатель
	|		ИНАЧЕ Заявка.Контрагент
	|	КОНЕЦ КАК Получатель,
	|	Заявка.Контрагент,
	|	Заявка.Подразделение,
	|	Заявка.КтоЗаявил КАК Заявитель,
	|	Заявка.Представление,
	|	Заявка.Приоритет,
	|	Заявка.СверхЛимита,
	|	ВЫБОР
	|		КОГДА Заявка.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заявка.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КартинкаПриоритета,
	|	ВЫБОР
	|		КОГДА Заявка.Проведен
	|				И Заявка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена)
	|			ТОГДА ВЫБОР
	|					КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты)
	|							И (Заявка.ХозяйственнаяОперацияПоЗарплате = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета)
	|								ИЛИ Заявка.ХозяйственнаяОперацияПоЗарплате = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу))
	|						ТОГДА ВЫБОР
	|								КОГДА ЕСТЬNULL(ВедомостиОстатки.СуммаОстаток, 0) >= 0
	|									ТОГДА ИСТИНА
	|								ИНАЧЕ ЛОЖЬ
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) >= 0
	|								ТОГДА ИСТИНА
	|							ИНАЧЕ ЛОЖЬ
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗаявкаОплачена,
	|	ВЫБОР
	|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы ЕСТЬ NULL 
	|			ТОГДА 1
	|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ЕстьФайлы,
	|	Заявка.Статус
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Заявка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.Остатки КАК ДенежныеСредства
	|		ПО (ДенежныеСредства.ЗаявкаНаРасходованиеДенежныхСредств = Заявка.Ссылка)
	|			И (Заявка.ХозяйственнаяОперацияПоЗарплате <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета))
	|			И (Заявка.ХозяйственнаяОперацияПоЗарплате <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеПрисоединенныхФайлов КАК НаличиеПрисоединенныхФайлов
	|		ПО Заявка.Ссылка = НаличиеПрисоединенныхФайлов.ОбъектСФайлами
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Ведомости.Ссылка КАК Ссылка,
	|			СУММА(ЕСТЬNULL(ДенежныеСредстваПоВедомостям.СуммаОстаток, 0)) КАК СуммаОстаток
	|		ИЗ
	|			Документ.ЗаявкаНаРасходованиеДенежныхСредств.ВедомостиНаВыплатуЗарплаты КАК Ведомости
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.Остатки КАК ДенежныеСредстваПоВедомостям
	|				ПО Ведомости.Ведомость = ДенежныеСредстваПоВедомостям.ЗаявкаНаРасходованиеДенежныхСредств
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Ведомости.Ссылка) КАК ВедомостиОстатки
	|		ПО Заявка.Ссылка = ВедомостиОстатки.Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ
#КонецОбласти

#КонецОбласти
