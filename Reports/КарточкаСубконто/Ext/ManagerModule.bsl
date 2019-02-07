﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Истина);
							
КонецФункции
	
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	ТекстСубконто = "";
	Для Каждого ВидСубконто Из ПараметрыОтчета.СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Карточка субконто %1 %2';uk='Картка субконто %1 %2'"),
		ТекстСубконто,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из ПараметрыОтчета.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВидовСубконто.Количество() > 0 Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто", МассивВидовСубконто);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Отбор, "ПериодГруппировки",,ВидСравненияКомпоновкиДанных.Заполнено);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Структура[0].Отбор, "Регистратор",,ВидСравненияКомпоновкиДанных.Заполнено);
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[1].Структура[0].Отбор, "Регистратор",,ВидСравненияКомпоновкиДанных.Заполнено);

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[0].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[1].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);

	Если ПараметрыОтчета.Периодичность = 0 Тогда
		КомпоновщикНастроек.Настройки.Структура[0].Использование = Ложь;
		КомпоновщикНастроек.Настройки.Структура[1].Использование = Истина;
	Иначе
		КомпоновщикНастроек.Настройки.Структура[0].Использование = Истина;
		КомпоновщикНастроек.Настройки.Структура[1].Использование = Ложь;
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПС", Символы.ПС);
		
	ЛинияСплошная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("ПериодГруппировкиЗаголовок"); 
	МассивМакетов.Добавить("ОбщиеИтогиЗаголовок");
	МассивМакетов.Добавить("ОбщиеИтогиПодвал");
	МассивМакетов.Добавить("ПроводкиЗаголовок");	
		
	Для Каждого ЭлементМакет Из МассивМакетов Цикл
		Схема.Макеты[ЭлементМакет].Макет = БухгалтерскиеОтчетыВызовСервера.ПолучитьКопиюОписанияМакета(Схема.Макеты[ЭлементМакет + "Образец"].Макет);
		ОписаниеМакета = Схема.Макеты[ЭлементМакет].Макет;
		
		МассивСтрокДляУдаления = Новый Массив;
		Индекс = 0;
		Для Каждого ЭлементМассива Из ПараметрыОтчета.НаборПоказателей Цикл
			Если Не ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда 
				МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;	
		
		Для Каждого Строка Из МассивСтрокДляУдаления Цикл
			ОписаниеМакета.Удалить(Строка);
		КонецЦикла;
		
		Если Не ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
			Параметры = Схема.Макеты[ЭлементМакет].Параметры;
			
			ПараметрыДляУдаления = Новый Массив;
			Для Каждого Параметр Из Параметры Цикл
				Если СтрНайти(Параметр.Имя, "валют") > 0 Тогда
					ПараметрыДляУдаления.Добавить(Параметр);
				КонецЕсли;
			КонецЦикла;
			Для Каждого Параметр Из ПараметрыДляУдаления Цикл
				Параметры.Удалить(Параметр);
			КонецЦикла;
		КонецЕсли;
				
		КоличествоСтрок = ОписаниеМакета.Количество();
		
		// Обвести область
		Если КоличествоСтрок > 0 Тогда
			Для Индекс = 0 По 12 Цикл
				ПоследняяСтрока = ?(ЭлементМакет = "ОбщиеИтогиПодвал" И Индекс < 4, 0, КоличествоСтрок - 1);
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[0].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Сверху", ЛинияСплошная);
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[ПоследняяСтрока].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Снизу", ЛинияСплошная);	
			КонецЦикла;
		КонецЕсли;
		
		Для Индекс = 1 По КоличествоСтрок - 1 Цикл
			ОписаниеМакета[Индекс].Ячейки[0].Элементы.Очистить();	
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[1].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[2].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[3].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			Если ЭлементМакет = "ПроводкиЗаголовок" Тогда
				ОписаниеМакета[Индекс].Ячейки[5].Элементы.Очистить();
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				ОписаниеМакета[Индекс].Ячейки[8].Элементы.Очистить();
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не ПараметрыОтчета.ПоказательБУ Тогда
		ГруппаОтборов = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.Использование = Истина;
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		Для Каждого ЭлементМассива Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ЭлементМассива <> "БУ" И ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, ЭлементМассива + "Дт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, ЭлементМассива + "Кт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);	
	
КонецПроцедуры
					
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Если показатель один, то удалим столбик "Показатель"
	Если КоличествоПоказателей = 1 Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Для Каждого СтрокаМакета Из Макет.Макет Цикл
				СтрокаМакета.Ячейки.Удалить(СтрокаМакета.Ячейки[4]);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	МакетПроводки = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Проводки", Истина);
	
	Если МакетПроводки.Количество() = 1 Тогда
		МакетПроводки = МакетПроводки[0];
		ИмяМакетПроводок = МакетПроводки.Имя;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 2;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + 2;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции
#КонецЕсли