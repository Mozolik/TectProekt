﻿
#Область ПрограммныйИнтерфейс

//Формирует массив полных имен метаданных объектов, для которых определены наборы данных,
//используемые в шаблонах сообщений
//
// Возвращаемое значение:
//   Массив   - сформированный массив
//
Функция МассивОбъектовСДаннымиШаблоновСообщений() Экспорт
	
	МассивОбъектовСДаннымиШаблоновСообщений = Новый Массив;
	
	//Справочники
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМаркетинговыеМероприятия") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.МаркетинговыеМероприятия");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.Контрагенты");
	КонецЕсли;
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.КонтактныеЛицаПартнеров");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.ДоговорыКонтрагентов");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.Партнеры");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.СоглашенияСКлиентами");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Справочник.СоглашенияСПоставщиками");
	
	//Документы
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.АктВыполненныхРабот");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеОтгрузкиПоРеализациям") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеОтгрузкиПоВозвратам") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.АктОРасхожденияхПослеОтгрузки");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеПриемкиПоВозвратам") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеПриемкиПоПоступлениям") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.АктОРасхожденияхПослеПриемки");
	КонецЕсли;
	
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ВзаимозачетЗадолженности");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ВозвратТоваровОтКлиента");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ВозвратТоваровПоставщику");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ЗаказКлиента");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ЗаказПоставщику");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКоммерческиеПредложенияКлиентам") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.КоммерческоеПредложениеКлиенту");
	КонецЕсли;
	
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.КорректировкаРеализации");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ОтчетКомиссионера");
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ОтчетКомиссионераОСписании");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ОтчетКомитенту");
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ОтчетКомитентуОСписании");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациями");
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	КонецЕсли;
	
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ПоступлениеТоваровУслуг");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.ПриходныйКассовыйОрдер");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.РасходныйКассовыйОрдер");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.РеализацияТоваровУслуг");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.РеализацияУслугПрочихАктивов");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.СверкаВзаиморасчетов");
	МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
		МассивОбъектовСДаннымиШаблоновСообщений.Добавить("Документ.СчетНаОплатуКлиенту");
	КонецЕсли;
	
	Возврат МассивОбъектовСДаннымиШаблоновСообщений;
	
КонецФункции

//Формирует массив полных имен метаданных объектов, для которых определены печатные формы,
//используемые в шаблонах сообщений
//
// Возвращаемое значение:
//   Массив   - сформированный массив
//
Функция МассивОбъектовСПечатнымиФормами() Экспорт

	МассивОбъектовСПечатнымиФормами = Новый Массив;
	
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.АктВыполненныхРабот");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.ВозвратТоваровОтКлиента");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.ВозвратТоваровПоставщику");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ЗаказКлиента");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ЗаказПоставщику");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКоммерческиеПредложенияКлиентам") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.КоммерческоеПредложениеКлиенту");
	КонецЕсли;
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.КорректировкаРеализации");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ОтчетКомиссионера");
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ОтчетКомиссионераОСписании");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ОтчетКомитенту");
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ОтчетКомитентуОСписании");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациями");
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	КонецЕсли;
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.ПоступлениеТоваровУслуг");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.ПриходныйКассовыйОрдер");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.РасходныйКассовыйОрдер");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.РеализацияТоваровУслуг");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.РеализацияУслугПрочихАктивов");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.СверкаВзаиморасчетов");
	МассивОбъектовСПечатнымиФормами.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.СчетНаОплатуКлиенту");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеОтгрузкиПоРеализациям") Тогда
		МассивОбъектовСПечатнымиФормами.Добавить("Документ.АктОРасхожденияхПослеОтгрузки");
	КонецЕсли;
	
	Возврат МассивОбъектовСПечатнымиФормами;

КонецФункции

//Создает описание таблицы параметров шаблона сообщения
//
// Возвращаемое значение:
//   ТаблицаЗначений   - сформированная пустая таблица значений
//
Функция ТаблицаПараметров() Экспорт
	
	ПараметрыШаблона = Новый ТаблицаЗначений;
	
	ПараметрыШаблона.Колонки.Добавить("ИмяПараметра"                , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
	ПараметрыШаблона.Колонки.Добавить("ОписаниеТипа"                , Новый ОписаниеТипов("ОписаниеТипов"));
	ПараметрыШаблона.Колонки.Добавить("ЭтоПредопределенныйПараметр" , Новый ОписаниеТипов("Булево"));
	ПараметрыШаблона.Колонки.Добавить("ПредставлениеПараметра"      , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	
	Возврат ПараметрыШаблона;
	
КонецФункции

//Создает описание структуры параметров печатной формы
//
// Возвращаемое значение:
//   Структура   - сформированная пустая структура
//
Функция СтруктураПараметровДоступнойПечатнойФормы(Имя, Представление , МенеджерПечати = "", 
	                                              ПараметрыПечати = Неопределено,
	                                              ИмяПечатнойФормыСУчетомПараметров = Неопределено) Экспорт

	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Имя",Имя);
	СтруктураПараметров.Вставить("Представление", Представление);
	СтруктураПараметров.Вставить("МенеджерПечати", МенеджерПечати);
	СтруктураПараметров.Вставить("ПараметрыПечати", ПараметрыПечати);
	СтруктураПараметров.Вставить("ИмяПечатнойФормыСУчетомПараметров", ИмяПечатнойФормыСУчетомПараметров);
	
	Возврат  СтруктураПараметров;

КонецФункции

// Формирует соответствие параметров текста сообщения шаблона.
//
// Параметры:
//  ПредназначенДляЭлектронныхПисем  - Булево - признак, того что шаблон предназначен для электронных писем.
//  ПредназначенДляSMS  - Булево - признак, того что шаблон предназначен для SMS.
//  ТипТекстаПисьма  - Перечисления.СпособыРедактированияЭлектронныхПисем - тип текста сообщения,
//                                     если оно предназначено для отправки по email.
//  ТемаПисьма  - Строка - тема письма.
//  ТекстПисьмаHTML  - Строка - текст письма в формате HTML.
//  ТекстПисьмаПростой  - Строка - текст письма в формате "обычный текст".
//  ТекстСообщенияSMS  - Строка - текст сообщения SMS.
//
// Возвращаемое значение:
//   Cоответствие   - соответствие имеющихся в тексте сообщения параметров.
//
Функция ПараметрыТекстаСообщения(ПредназначенДляЭлектронныхПисем,
	                             ПредназначенДляSMS,
	                             ТипТекстаПисьма,
	                             ТемаПисьма,
	                             ТекстПисьмаHTML,
	                             ТекстПисьмаПростой,
	                             ТекстСообщенияSMS) Экспорт
	
	ТекстПисьма = ?(ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML,
	                                  ТекстПисьмаHTML,
	                                  ТекстПисьмаПростой);
	
	Если ПредназначенДляЭлектронныхПисем И ПредназначенДляSMS Тогда
		Возврат ШаблоныСообщенийКлиентСервер.ПолучитьПараметрыТекстаСообщения(ТекстПисьма + " " 
		                                                                     + ТемаПисьма + " "
		                                                                     + ТекстСообщенияSMS);
	ИначеЕсли ПредназначенДляSMS Тогда
		Возврат ШаблоныСообщенийКлиентСервер.ПолучитьПараметрыТекстаСообщения(ТекстСообщенияSMS);
	ИначеЕсли ПредназначенДляЭлектронныхПисем Тогда
		Возврат ШаблоныСообщенийКлиентСервер.ПолучитьПараметрыТекстаСообщения(ТекстПисьма + " " + ТемаПисьма);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Формирует пустую таблицу параметров сообщения.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - пустая таблица параметров сообщения.
//
Функция ПустаяТаблицаПараметровСообщения() Экспорт
	
	ТаблицаПараметровСообщения = Новый ТаблицаЗначений;
	ТаблицаПараметровСообщения.Колонки.Добавить("Ключ");
	ТаблицаПараметровСообщения.Колонки.Добавить("Значение");
	
	Возврат ТаблицаПараметровСообщения;
	
КонецФункции

// Добавляет строку в таблицу параметров сообщения
//
// Параметры:
//  ТаблицаПараметров  - ТаблицаЗначений - таблица, в которую добавляется строка.
//  Ключ  - Строка - имя параметра сообщения.
//  Значение  - Произвольный - значение параметра сообщения.
//
Процедура ДобавитьСтрокуТаблицуПараметров(ТаблицаПараметров, Ключ, Значение) Экспорт

	НоваяСтрока = ТаблицаПараметров.Добавить();
	НоваяСтрока.Ключ = Ключ;
	НоваяСтрока.Значение = Значение;

КонецПроцедуры

// Подставляет в шаблон значения параметров сообщения и формирует текст сообщения.
//
// Параметры:
//  ШаблонСтроки  - Строка - шаблон, в который будут подставляться значения, согласно таблице параметров.
//  ВставляемыеЗначения  - ТаблицаЗначений - таблица, содержащая ключи параметров и значения параметров.
//
// Возвращаемое значение:
//   Строка   - строка, в которую были подставлены значения параметров шаблона
//
Функция ВставитьПараметрыВСтрокуСогласноТаблицеПараметров(Знач ШаблонСтроки, ВставляемыеЗначения) Экспорт
	
	Результат = ШаблонСтроки;
	Для Каждого Параметр Из ВставляемыеЗначения Цикл
		Результат = СтрЗаменить(Результат, "[" + Параметр.Ключ + "]",
		                       ?(ТипЗнч(Параметр.Значение) = Тип("Дата"),
		                       Формат(Параметр.Значение, "ДЛФ=DD"), Параметр.Значение));
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Добавляет в массив доступных для шаблона печатных форм данные по выводу "Счета на оплату"
//
// Параметры:
//  МассивДоступныхПечатныхФорм  - Массив - массив доступных печатных форм
//
Процедура ДобавитьВМассивПечатныеФормыСчета(МассивДоступныхПечатныхФорм) Экспорт

	Если ПолучитьФункциональнуюОпцию("ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи") Тогда
	
		МассивДоступныхПечатныхФорм.Добавить(ШаблоныСообщенийСервер.СтруктураПараметровДоступнойПечатнойФормы(
	                                     "СчетНаОплату", НСтр("ru='Счет на оплату с факсимиле (выводить скидки)';uk='Рахунок на оплату з факсиміле (виводити знижки)'"),
	                                     "Обработка.ПечатьСчетовНаОплату", Новый Структура("ОтображатьФаксимиле", Истина)));
		МассивДоступныхПечатныхФорм.Добавить(ШаблоныСообщенийСервер.СтруктураПараметровДоступнойПечатнойФормы(
	                                     "СчетНаОплату", НСтр("ru='Счет на оплату с факсимиле (не выводить скидки)';uk='Рахунок на оплату з факсиміле (не виводити знижки)'"),
	                                     "Обработка.ПечатьСчетовНаОплату", Новый Структура("ОтображатьСкидки, ОтображатьФаксимиле", Ложь, Истина), 
		                                 "СчетНаОплатуБезСкидок"));
	Иначе
		МассивДоступныхПечатныхФорм.Добавить(ШаблоныСообщенийСервер.СтруктураПараметровДоступнойПечатнойФормы(
	                                     "СчетНаОплату", НСтр("ru='Счет на оплату с факсимиле';uk='Рахунок на оплату з факсиміле'"),
	                                     "Обработка.ПечатьСчетовНаОплату", Новый Структура("ОтображатьФаксимиле", Истина)));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСписокВыбораВводНаОсновании(СписокВыбора, ДополнитьПростымиТипами = Ложь, ДополнятьТипамиОповещений = Ложь) Экспорт

	СписокВыбора.Очистить();
	
	МассивОбъектовМетаданных = МассивОбъектовСДаннымиШаблоновСообщений();
	
	Для каждого ЭлементМассива Из МассивОбъектовМетаданных Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементМассива);
		Если ОбъектМетаданных = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не ПравоДоступа("Чтение",ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементМассива, ".");
		Синоним = ОбъектМетаданных.Синоним;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") И ОбъектМетаданных.Имя = "Партнеры" Тогда
			Синоним = НСтр("ru='Контрагенты';uk='Контрагенти'");
		КонецЕсли;
		СписокВыбора.Добавить(ЭлементМассива,ЛокализацияПовтИсп.ПолучитьЛокализованноеПредставлениеВидаМетаданных(МассивПодстрок[0]) + " """ + Синоним + """")
	    
	КонецЦикла;
	
	Если ДополнятьТипамиОповещений Тогда
		Для Каждого ЗначениеПеречисления ИЗ Перечисления.ТипыСобытийОповещений.ИзменениеСостоянияЗаказа.Метаданные().ЗначенияПеречисления Цикл
		
			Если НЕ Перечисления.ТипыСобытийОповещений.ДанныеДляОбработкиОчередиОповещений(Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя]).ДоступноДляИспользования Тогда
				Продолжить;
			КонецЕсли;
			
			СписокВыбора.Добавить("Перечисление.ТипыСобытийОповещений." + ЗначениеПеречисления.Имя,
			                      НСтр("ru='Оповещение клиента';uk='Оповіщення клієнта'") + " """ + ЗначениеПеречисления.Синоним +"""");
		
		КонецЦикла;
	КонецЕсли;
	
	СписокВыбора.СортироватьПоЗначению();
	
	Если ДополнитьПростымиТипами Тогда
		
		СписокВыбора.Вставить(0, "Дата", НСтр("ru='Дата';uk='Дата'"));
		СписокВыбора.Вставить(0, "Строка", НСтр("ru='Строка';uk='Рядок'"));
		
	КонецЕсли;

КонецПроцедуры

Функция ШаблонСообщенияПоУмолчанию(ПредназначенДляПисем, ПолноеИмяТипаПараметраВводаНаОсновании = "") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШаблоныСообщений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
	|ГДЕ
	|	НЕ ШаблоныСообщений.ПометкаУдаления
	|	И ШаблоныСообщений.ПредназначенДляЭлектронныхПисем = &ПредназначенДляЭлектронныхПисем
	|	И ШаблоныСообщений.ПредназначенДляSMS = &ПредназначенДляSMS
	|	И ШаблоныСообщений.ПолноеИмяТипаПараметраВводаНаОсновании = &ПолноеИмяТипаПараметраВводаНаОсновании";
	
	Запрос.УстановитьПараметр("ПредназначенДляЭлектронныхПисем", ПредназначенДляПисем);
	Запрос.УстановитьПараметр("ПредназначенДляSMS", НЕ ПредназначенДляПисем);
	Запрос.УстановитьПараметр("ПолноеИмяТипаПараметраВводаНаОсновании", ПолноеИмяТипаПараметраВводаНаОсновании);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ШаблоныСообщений.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ШаблоныСообщений.ПустаяСсылка();
	
КонецФункции

Функция ВнешняяСсылкаНаОбъект(Параметр) Экспорт
	
	Возврат Взаимодействия.АдресПубликацииИнформационнойБазыВИнтернете() + "#" +  ПолучитьНавигационнуюСсылку(Параметр);
	
КонецФункции

#КонецОбласти
