﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВнешнийОбъект") Тогда
		Если ТипЗнч(Параметры.ВнешнийОбъект) = Тип("Структура") Тогда
			ВнешнийОбъект = Параметры.ВнешнийОбъект.presentation;
			ВнешнийОбъектID = Параметры.ВнешнийОбъект.id;
			ВнешнийОбъектТип = Параметры.ВнешнийОбъект.type;
			Если Найти(ВнешнийОбъектТип,"Document") <> 0 
			 Или ВнешнийОбъектТип = "DMFile" 
			 Или ВнешнийОбъектТип = "DMCorrespondent" Тогда
				ЭтаФорма.Заголовок = НСтр("ru='Процессы и задачи';uk='Процеси й задачі'");
			ИначеЕсли Найти(ВнешнийОбъектТип,"BusinessProcess") <> 0 Тогда 
				ЭтаФорма.Заголовок = НСтр("ru='Задачи процесса %Объект%';uk='Задачі процесу %Объект%'");
				ЭтаФорма.Заголовок = СтрЗаменить(ЭтаФорма.Заголовок, "%Объект%", Параметры.ВнешнийОбъект.presentation);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СсылкаНаВнешнийОбъект = Параметры.СсылкаНаВнешнийОбъект;
	Если ЗначениеЗаполнено(СсылкаНаВнешнийОбъект) Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Задачи по ""%Объект%""';uk='Задачі по ""%Объект%""'");
		ЭтаФорма.Заголовок = СтрЗаменить(ЭтаФорма.Заголовок, "%Объект%", Параметры.ВнешнийОбъект.name);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВнешнийОбъектID) ИЛИ ЗначениеЗаполнено(СсылкаНаВнешнийОбъект) Тогда
		ЗагрузитьДеревоБизнесПроцессовИЗадач();
	КонецЕсли;
	
	// результаты выполнения задач
	Если Не ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
		Элементы.ДеревоБизнесПроцессовИЗадачВыполнено.Видимость = Истина;
		Элементы.ДеревоБизнесПроцессовИЗадачКартинка.Видимость = Ложь;
	КонецЕсли;
	
	//условное оформление
	УстановитьУсловноеОформлениеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		РаскрытыеЭлементы = Новый СписокЗначений;
		ПолучитьМассивРаскрытыхЭлементов(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач.ПолучитьЭлементы(), РаскрытыеЭлементы);
		РаскрытыеЭлементы.Добавить(Параметр.ID);
		ЗагрузитьДеревоБизнесПроцессовИЗадач();
		УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач, РаскрытыеЭлементы);
		УстановитьТекущийЭлементВДереве(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач, Параметр.ID);
						
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоБизнеспроцессовИЗадач

&НаКлиенте
Процедура ДеревоБизнесПроцессовИЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьКарточкуВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоБизнесПроцессовИЗадачПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	Модифицированность = Ложь;
	ОткрытьКарточкуВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	Модифицированность = Ложь;
    ПринятьЗадачиКИсполнению();
	
	Если Элементы.ДеревоБизнесПроцессовИЗадач.ТекущиеДанные <> Неопределено Тогда
		Параметр = новый Структура("id", Элементы.ДеревоБизнесПроцессовИЗадач.ТекущиеДанные.ОбъектID);
		ОбновитьСписокЗадачНаКлиенте(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеДерева()
	
	Если ЭтаФорма.УсловноеОформление.Элементы.Количество() = 3 Тогда
		ЭлементДляУдаления = ЭтаФорма.УсловноеОформление.Элементы[2];
		ЭтаФорма.УсловноеОформление.Элементы.Удалить(ЭлементДляУдаления);
	КонецЕсли;
	
	ЭлементУсловногоОформления = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоБизнесПроцессовИЗадач.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоБизнесПроцессовИЗадач.Выполнено");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоБизнесПроцессовИЗадач.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = ТекущаяДатаСеанса();
	ЭлементОтбораДанных.Использование = Истина;
	
	НовыйЭлемент = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовыйЭлемент.Поле = Новый ПолеКомпоновкиДанных("ДеревоБизнесПроцессовИЗадачСрокИсполнения");
		
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоЗадачИзОтветаВебСервиса(СтрокиДереваЗадач, СтрокиОтвета)
		
	Для Каждого ОднаСтрокаОтвета Из СтрокиОтвета Цикл
		Важность = 1;
		Если ОднаСтрокаОтвета.importance.objectId.id = "Низкая" Тогда
			Важность = 0;
		ИначеЕсли ОднаСтрокаОтвета.importance.objectId.id = "Обычная" Тогда
			Важность = 1;
		ИначеЕсли ОднаСтрокаОтвета.importance.objectId.id = "Высокая" Тогда 
			Важность = 2;
		КонецЕсли;
		Если Найти(ОднаСтрокаОтвета.objectId.type, "BusinessProcess") > 0
			И Найти(ОднаСтрокаОтвета.objectId.type, "Task") = 0 Тогда
			Если НЕ (ЗначениеЗаполнено(ВнешнийОбъектID) И ВнешнийОбъектID = ОднаСтрокаОтвета.objectId.id) Тогда
				НоваяСтрока = СтрокиДереваЗадач.Добавить();
				НоваяСтрока.Важность = Важность;
				НоваяСтрока.Выполнено = ЗначениеЗаполнено(ОднаСтрокаОтвета.endDate);
				НоваяСтрока.Наименование = ОднаСтрокаОтвета.name;
				НоваяСтрока.ДатаНачала = ОднаСтрокаОтвета.beginDate;
				НоваяСтрока.Автор = ОднаСтрокаОтвета.author.name;
				НоваяСтрока.Тип = 0;
				НоваяСтрока.ОбъектТип = ОднаСтрокаОтвета.objectId.type;
				НоваяСтрока.ОбъектID  = ОднаСтрокаОтвета.objectId.id;
				// результаты выполнения задач
				Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
					НоваяСтрока.Картинка = ИнтеграцияС1СДокументооборот.ИндексКартинкиПометкиЗавершения(ОднаСтрокаОтвета.completionMark);
				КонецЕсли;
				ПостроитьДеревоЗадачИзОтветаВебСервиса(НоваяСтрока.Строки, ОднаСтрокаОтвета.tasks);
			Иначе
				ПостроитьДеревоЗадачИзОтветаВебСервиса(СтрокиДереваЗадач, ОднаСтрокаОтвета.tasks);
			КонецЕсли;
		ИначеЕсли Найти(ОднаСтрокаОтвета.objectId.type, "Task") > 0 Тогда
			Если ЭтоСлужебнаяЗадача(ОднаСтрокаОтвета) Тогда
				ПостроитьДеревоЗадачИзОтветаВебСервиса(СтрокиДереваЗадач, ОднаСтрокаОтвета.businessProcesses);
			Иначе	
				НоваяСтрока = СтрокиДереваЗадач.Добавить();
				НоваяСтрока.Важность = Важность;
				НоваяСтрока.Выполнено = ОднаСтрокаОтвета.executed;
				НоваяСтрока.Наименование = ОднаСтрокаОтвета.name;
				НоваяСтрока.СрокИсполнения = ОднаСтрокаОтвета.dueDate;
				НоваяСтрока.ДатаНачала = ОднаСтрокаОтвета.beginDate;
				Если ОднаСтрокаОтвета.performer.Установлено("user") Тогда
					НоваяСтрока.Исполнитель = ОднаСтрокаОтвета.performer.user.name;
				ИначеЕсли ОднаСтрокаОтвета.performer.Установлено("role") Тогда
					НоваяСтрока.Исполнитель = ОднаСтрокаОтвета.performer.role.name;
					Если ОднаСтрокаОтвета.performer.Установлено("mainAddressingObject") Тогда
						НоваяСтрока.Исполнитель = НоваяСтрока.Исполнитель + ", " + ОднаСтрокаОтвета.performer.mainAddressingObject.name;
					КонецЕсли;
					Если ОднаСтрокаОтвета.Performer.Установлено("secondaryAddressingObject") Тогда
						НоваяСтрока.Исполнитель = НоваяСтрока.Исполнитель + ", " + ОднаСтрокаОтвета.performer.secondaryAddressingObject.name;
					КонецЕсли;
				КонецЕсли;
				НоваяСтрока.Тип = 1;
				НоваяСтрока.ОбъектТип = ОднаСтрокаОтвета.objectId.type;
				НоваяСтрока.ОбъектID = ОднаСтрокаОтвета.objectId.id;
				НоваяСтрока.ВладелецТип = ОднаСтрокаОтвета.parentBusinessProcess.objectId.type;
				НоваяСтрока.ВладелецID = ОднаСтрокаОтвета.parentBusinessProcess.objectId.id;
				НоваяСтрока.ТочкаМаршрута = ОднаСтрокаОтвета.businessProcessStep;
				НоваяСтрока.ПринятаКИсполнению = ОднаСтрокаОтвета.accepted;
				// результаты выполнения задач
				Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3") Тогда
					НоваяСтрока.Картинка = ИнтеграцияС1СДокументооборот.ИндексКартинкиПометкиЗавершения(ОднаСтрокаОтвета.executionMark);
				КонецЕсли;
				ПостроитьДеревоЗадачИзОтветаВебСервиса(НоваяСтрока.Строки, ОднаСтрокаОтвета.businessProcesses);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.ДеревоБизнесПроцессовИЗадач.ТекущиеДанные = Неопределено Тогда
		возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		Элементы.ДеревоБизнесПроцессовИЗадач.ТекущиеДанные.ОбъектТип, 
		Элементы.ДеревоБизнесПроцессовИЗадач.ТекущиеДанные.ОбъектID, 
		Элементы.ДеревоБизнесПроцессовИЗадач);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДеревоБизнесПроцессовИЗадач()
	
	// задачи
	Если НЕ ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтаФорма);
		Элементы.ДеревоБизнесПроцессовИЗадач.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetTasksTreeRequest");
	Запрос.query = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetTasksTreeQuery");
	
	Если Найти(ВнешнийОбъектТип,"BusinessProcess")<>0 Тогда
		Процесс = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObject");
		Процесс.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ВнешнийОбъектID, ВнешнийОбъектТип);
		Процесс.name = "";
		Запрос.query.businessProcess.Добавить(Процесс);
		
	ИначеЕсли Найти(ВнешнийОбъектТип, "Document") <> 0 
		Или ВнешнийОбъектТип = "DMFile"
		Или ВнешнийОбъектТип = "DMCorrespondent" Тогда
		// получение задач по предмету
		Если НЕ ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.7.3") Тогда
			Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтаФорма);
			Возврат;
		КонецЕсли;
		Предмет = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси,"DMObject");
		Предмет.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ВнешнийОбъектID, ВнешнийОбъектТип);
		Предмет.name = "";
		Запрос.query.target.Добавить(Предмет);
		
	КонецЕсли;
	
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	ДеревоЗадач = РеквизитФормыВЗначение("ДеревоБизнесПроцессовИЗадач", Тип("ДеревоЗначений"));
	ДеревоЗадач.Строки.Очистить();
	ПостроитьДеревоЗадачИзОтветаВебСервиса(ДеревоЗадач.Строки, Ответ.businessProcesses);
	ЗначениеВРеквизитФормы(ДеревоЗадач, "ДеревоБизнесПроцессовИЗадач");
    УстановитьУсловноеОформлениеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадачНаКлиенте(Параметр = Неопределено)
	
	РаскрытыеЭлементы = Новый СписокЗначений;
	ПолучитьМассивРаскрытыхЭлементов(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач.ПолучитьЭлементы(), РаскрытыеЭлементы);
	Если ЗначениеЗаполнено(Параметр) Тогда
		РаскрытыеЭлементы.Добавить(Параметр.ID);
	КонецЕсли;
	ЗагрузитьДеревоБизнесПроцессовИЗадач();
	УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач, РаскрытыеЭлементы); 
	Если ЗначениеЗаполнено(Параметр) Тогда
		УстановитьТекущийЭлементВДереве(Элементы.ДеревоБизнесПроцессовИЗадач, ДеревоБизнесПроцессовИЗадач, Параметр.ID);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПринятьЗадачиКИсполнению()
	
	МассивСтрок = Элементы.ДеревоБизнесПроцессовИЗадач.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадач = новый Массив;
		Для каждого Элемент из МассивСтрок Цикл
			СтрокаДанных = ДеревоБизнесПроцессовИЗадач.НайтиПоИдентификатору(Элемент);
			Если ЗначениеЗаполнено(СтрокаДанных.ОбъектID) И СтрокаДанных.ОбъектТип = "DMBusinessProcessTask" Тогда
				МассивЗадач.Добавить(СтрокаДанных.ОбъектID);
			КонецЕсли;
		КонецЦикла;
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		ИнтеграцияС1СДокументооборот.ПринятьЗадачуКИсполнению(Прокси, МассивЗадач);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьМассивРаскрытыхЭлементов(ДеревоЭлемент, МассивСтрокОдногоУровня, СписокРаскрытыхЭлементов)
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		ИдЭлемента = СтрокаОдногоУровня.ПолучитьИдентификатор();
		Если ДеревоЭлемент.Развернут(ИдЭлемента) <> Неопределено 
			И ДеревоЭлемент.Развернут(ИдЭлемента) Тогда
			СписокРаскрытыхЭлементов.Добавить(СтрокаОдногоУровня.ОбъектID);
		КонецЕсли;
		ПолучитьМассивРаскрытыхЭлементов(ДеревоЭлемент, СтрокаОдногоУровня.ПолучитьЭлементы(), СписокРаскрытыхЭлементов);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазвернутостьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, СписокЭлементовДляРазвертывания)
	
	Если СписокЭлементовДляРазвертывания <> Неопределено Тогда
		Для Каждого ЭлементСписка Из СписокЭлементовДляРазвертывания Цикл
			Индекс = -1;
			НайтиЭлементВДереве(ДеревоБизнесПроцессовИЗадач.ПолучитьЭлементы(), ЭлементСписка.Значение, Индекс);
			Если Индекс > -1 Тогда
				Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьЭлементы().Количество() > 0 Тогда
					ДеревоЭлемент.Развернуть(ДеревоБизнесПроцессовИЗадач.НайтиПоИдентификатору(Индекс).ПолучитьИдентификатор(), Ложь);
				Иначе
					Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя() <> Неопределено Тогда
						ДеревоЭлемент.Развернуть(ДеревоБизнесПроцессовИЗадач.НайтиПоИдентификатору(Индекс).ПолучитьРодителя().ПолучитьИдентификатор(), Ложь);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиЭлементВДереве(КоллекцияЭлементовОдногоУровня, ИскомыйЭлемент, Индекс) 
	
	Если КоллекцияЭлементовОдногоУровня.Количество() > 0 Тогда
		Для Каждого ЭлементДерева Из КоллекцияЭлементовОдногоУровня Цикл
			Если ЭлементДерева.ОбъектID = ИскомыйЭлемент Тогда
				Индекс = ЭлементДерева.ПолучитьИдентификатор();
			Иначе
				НайтиЭлементВДереве(ЭлементДерева.ПолучитьЭлементы(), ИскомыйЭлемент, Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийЭлементВДереве(ДеревоЭлемент, ДеревоРеквизит, ТекущийЭлемент) 
	
	Если ТекущийЭлемент <> Неопределено Тогда
		Индекс = -1;
		НайтиЭлементВДереве(ДеревоРеквизит.ПолучитьЭлементы(), ТекущийЭлемент, Индекс);
		Если Индекс > -1 Тогда
			ДеревоЭлемент.ТекущаяСтрока = Индекс;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭтоСлужебнаяЗадача(Задача)
	
	Служебная = Ложь;
	
	Если Задача.parentBusinessProcess.objectId.type = "DMComplexBusinessProcess" Тогда 
		Если Задача.businessProcessStep = "Выполнить все действия процесса" Тогда
			Служебная = Истина;
		КонецЕсли;
	ИначеЕсли Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessInternalDocumentProcessing" 
			ИЛИ Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessIncomingDocumentProcessing"
			ИЛИ Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessOutgoingDocumentProcessing" Тогда
		Служебная = Истина;
	КонецЕсли;
	
	Возврат Служебная;
	
КонецФункции

#КонецОбласти
