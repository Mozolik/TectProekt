﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Ложь);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Ведомость амортизации ОС';uk='Відомість амортизації ОЗ'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ИДКонфигурации = РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации();
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачПериода",         НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачПериодаОстатков", Новый Граница(НачалоДня(ПараметрыОтчета.НачалоПериода), ВидГраницы.Исключая));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачПериодаОстатков", Дата(1,1,1,0,0,1));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонПериодаОстатков", Новый Граница(КонецДня(ПараметрыОтчета.КонецПериода)));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Подразделение) Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "Подразделение", ПараметрыОтчета.Подразделение,,, Истина);
	КонецЕсли;
	
	Структура = КомпоновщикНастроек.Настройки;
	
	Для каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок = НСтр("ru='Показатели';uk='Показники'");
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатель" + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ГруппаДанныеНаНачало = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаНачало.Заголовок = НСтр("ru='На начало периода';uk='На початок періоду'");
		ГруппаДанныеНаНачало.Использование = Истина;
	ГруппаДанныеНаНачалоСтоимость = ГруппаДанныеНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаНачалоСтоимость.Заголовок = НСтр("ru='Стоимость';uk='Вартість'");
		ГруппаДанныеНаНачалоСтоимость.Использование = Истина;
		ГруппаДанныеНаНачалоСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаДанныеНаНачалоАмортизация = ГруппаДанныеНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаНачалоАмортизация.Заголовок = НСтр("ru='Амортизация';uk='Амортизація'");
		ГруппаДанныеНаНачалоАмортизация.Использование = Истина;
		ГруппаДанныеНаНачалоАмортизация.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаДанныеНаНачалоОстаточнаяСтоимость = ГруппаДанныеНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаНачалоОстаточнаяСтоимость.Заголовок = НСтр("ru='Остаточная стоимость';uk='Залишкова вартість'");
		ГруппаДанныеНаНачалоОстаточнаяСтоимость.Использование = Истина;
		ГруппаДанныеНаНачалоОстаточнаяСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОбороты = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаОбороты.Заголовок = НСтр("ru='За период';uk='За період'");
		ГруппаОбороты.Использование = Истина;
	ГруппаУвеличениеСтоимости = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаУвеличениеСтоимости.Заголовок = НСтр("ru='Увеличение стоимости';uk='Збільшення вартості'");
		ГруппаУвеличениеСтоимости.Использование = Истина;
		ГруппаУвеличениеСтоимости.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаНачислениеАмортизации = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаНачислениеАмортизации.Заголовок = НСтр("ru='Начисление амортизации';uk='Нарахування амортизації'");
		ГруппаНачислениеАмортизации.Использование = Истина;
		ГруппаНачислениеАмортизации.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаУменьшениеСтоимости = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаУменьшениеСтоимости.Заголовок = НСтр("ru='Уменьшение стоимости';uk='Зменшення вартості'");
		ГруппаУменьшениеСтоимости.Использование = Истина;
		ГруппаУменьшениеСтоимости.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСписаниеАмортизации = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаСписаниеАмортизации.Заголовок = НСтр("ru='Списание амортизации';uk='Списання амортизації'");
		ГруппаСписаниеАмортизации.Использование = Истина;
		ГруппаСписаниеАмортизации.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаДанныеНаКонец = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаКонец.Заголовок = НСтр("ru='На конец периода';uk='На кінець періоду'");
		ГруппаДанныеНаКонец.Использование = Истина;
	ГруппаДанныеНаКонецСтоимость = ГруппаДанныеНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаКонецСтоимость.Заголовок = НСтр("ru='Стоимость';uk='Вартість'");
		ГруппаДанныеНаКонецСтоимость.Использование = Истина;
		ГруппаДанныеНаКонецСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаДанныеНаКонецАмортизация = ГруппаДанныеНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаКонецАмортизация.Заголовок = НСтр("ru='Амортизация';uk='Амортизація'");
		ГруппаДанныеНаКонецАмортизация.Использование = Истина;
		ГруппаДанныеНаКонецАмортизация.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаДанныеНаКонецОстаточнаяСтоимость = ГруппаДанныеНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДанныеНаКонецОстаточнаяСтоимость.Заголовок = НСтр("ru='Остаточная стоимость';uk='Залишкова вартість'");
		ГруппаДанныеНаКонецОстаточнаяСтоимость.Использование = Истина;
		ГруппаДанныеНаКонецОстаточнаяСтоимость.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	Для каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			Если ИмяПоказателя = "БУ" Тогда
				СуффиксПоказателя = "";
				СуффиксАмортизация = "";
			Иначе
				СуффиксПоказателя = ИмяПоказателя;
				СуффиксАмортизация = ИмяПоказателя;
			КонецЕсли;
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаНачалоСтоимость, "НаНачалоПериода.Стоимость" + СуффиксПоказателя + "ОстатокНачПериода");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаНачалоАмортизация, "НаНачалоПериода.Амортизация" + СуффиксАмортизация + "ОстатокНачПериода");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаНачалоОстаточнаяСтоимость, "НаНачалоПериода.ОстаточнаяСтоимость" + СуффиксПоказателя + "НачПериода");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаУвеличениеСтоимости, "ЗаПериод.Стоимость" + СуффиксПоказателя + "Увеличение");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаУменьшениеСтоимости, "ЗаПериод.Стоимость" + СуффиксПоказателя + "Уменьшение");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаНачислениеАмортизации, "ЗаПериод.Амортизация" + СуффиксАмортизация + "Начисление");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСписаниеАмортизации, "ЗаПериод.Амортизация" + СуффиксАмортизация + "Списание");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаКонецСтоимость, "НаКонецПериода.Стоимость" + СуффиксПоказателя + "ОстатокКонПериода");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаКонецАмортизация, "НаКонецПериода.Амортизация" + СуффиксАмортизация + "ОстатокКонПериода");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеНаКонецОстаточнаяСтоимость,  "НаКонецПериода.ОстаточнаяСтоимость" + СуффиксПоказателя + "КонПериода");
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки, "ОсновноеСредство");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки, "ОсновноеСредство.ИнвентарныйНомер");
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КоличествоГруппировок = 1;
	Для Каждого СтрокаГруппировки Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 10 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
			СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
			
			КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
			Ячейка = СтрокаМакета.Ячейки[КоличествоКолонок - 11];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЕсли;
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	Для каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли
