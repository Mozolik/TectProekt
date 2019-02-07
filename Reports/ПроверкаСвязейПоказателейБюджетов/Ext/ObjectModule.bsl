﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Перем КоличествоДокументов;
	
	СтандартнаяОбработка = Ложь;
	
	ВнешниеНаборы = НаборыДанных();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	Показатель = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Показатель").Значение; 
	УказанаВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Использование;
	Если Показатель = "Количество" ИЛИ УказанаВалюта Тогда
		ОтключитьИспользованиеУВыбранногоПоля(НастройкиОтчета.Выбор.Элементы, "Валюта");
		ОтключитьИспользованиеУГруппировки(НастройкиОтчета.Структура, "Валюта");
	КонецЕсли;
	
	//++ НЕ УТКА
	#Область ЗапускФоновогоОтраженияДокументовВБюджетировании
		Период = БюджетированиеСервер.ЗначениеНастройкиСКД(КомпоновщикНастроек, "Период");
		НачалоПериода = Период.ДатаНачала;
		КонецПериода = Период.ДатаОкончания;
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		
		ДопСвойства.Удалить("КоличествоДокументовКОтражениюВБюджетировании");
		Если РегистрыСведений.ЗаданияКОтражениюВБюджетировании.ТребуетсяОтражениеВБюджетированииДляОтчетаЗаПериод(
																	НачалоПериода, КонецПериода, КоличествоДокументов) Тогда
			
			ФактическиеДанныеБюджетированияСервер.ОтразитьДокументыФоновымЗаданием(НачалоПериода, КонецПериода);
			ДопСвойства.Вставить("КоличествоДокументовКОтражениюВБюджетировании", КоличествоДокументов);
			ДопСвойства.Вставить("НачалоПериода", НачалоПериода);
			ДопСвойства.Вставить("КонецПериода", КонецПериода);
			
		КонецЕсли;
	#КонецОбласти
	//-- НЕ УТКА
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	//++ НЕ УТКА
	ФактическиеДанныеБюджетированияСервер.ВывестиАктуальностьОтраженияФактическихДанных(ДокументРезультат, ДопСвойства);
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанныхОтчета

Функция НаборыДанных()
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрыПолученияФакта = ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета);
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("ОстаткиНаНачало", ОстаткиНаНачало(НастройкиОтчета, ПараметрыПолученияФакта));
	НаборыДанных.Вставить("Обороты",         Обороты(НастройкиОтчета, ПараметрыПолученияФакта));
	НаборыДанных.Вставить("ОстаткиНаКонец",  ОстаткиНаКонец(НастройкиОтчета, ПараметрыПолученияФакта));
	
	Возврат НаборыДанных;
	
КонецФункции

Функция Обороты(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ФактПоСтатьямБюджетов = БюджетированиеСервер.ФактПоСтатьямВлияющимНаПоказателиБюджетов(
		НастройкиОтчета, 
		ПараметрыПолученияФакта);
	
	Если Не ПараметрыПолученияФакта.ВозвращатьСуммуВВалюте 
		 И ПараметрыПолученияФакта.Показатели.Свойство("Сумма") Тогда
		ФактПоСтатьямБюджетов.Колонки.СуммаПриход.Имя = "СуммаВалПриход";
		ФактПоСтатьямБюджетов.Колонки.СуммаРасход.Имя = "СуммаВалРасход";
	КонецЕсли;
	
	Возврат ФактПоСтатьямБюджетов;
	
КонецФункции

Функция ОстаткиНаНачало(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ПараметрыПолученияФакта.ОстаткиТолькоНаНачалоПериода = Истина;
	
	ФактПоПоказателямБюджетов = БюджетированиеСервер.ФактПоПоказателямБюджетов(
		НастройкиОтчета, 
		ПараметрыПолученияФакта);
		
	Если Не ПараметрыПолученияФакта.ВозвращатьСуммуВВалюте 
		 И ПараметрыПолученияФакта.Показатели.Свойство("Сумма") Тогда
		ФактПоПоказателямБюджетов.Колонки.Сумма.Имя = "СуммаВВалюте";
	КонецЕсли;
	
	Возврат ФактПоПоказателямБюджетов;
	
КонецФункции

Функция ОстаткиНаКонец(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ПараметрыПолученияФакта.ОстаткиТолькоНаНачалоПериода = Ложь;
	
	ФактПоПоказателямБюджетов = БюджетированиеСервер.ФактПоПоказателямБюджетов(
		НастройкиОтчета, 
		ПараметрыПолученияФакта);
		
	Если Не ПараметрыПолученияФакта.ВозвращатьСуммуВВалюте 
		 И ПараметрыПолученияФакта.Показатели.Свойство("Сумма") Тогда
		ФактПоПоказателямБюджетов.Колонки.Сумма.Имя = "СуммаВВалюте";
	КонецЕсли;

	Возврат ФактПоПоказателямБюджетов;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета)
	
	Параметры = БюджетированиеСервер.ПараметрыПолученияФакта();
	
	Валюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта");
	Если Валюта.Использование Тогда
		Параметры.ВалютаОтчета = Валюта.Значение;
	Иначе
		Параметры.ВалютаОтчета = Константы.ВалютаУправленческогоУчета.Получить();
	КонецЕсли;
	
	Показатель = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Показатель").Значение;
	Параметры.ВозвращатьСуммуВВалюте = НЕ Валюта.Использование И Показатель = "Сумма";
	Параметры.Показатели = Новый Структура(Показатель);
	
	Параметры.Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Параметры.ПоОрганизациям = Истина;
	Параметры.ПоПодразделениям = Истина;
	
	Возврат Параметры; 
	
КонецФункции

Процедура ОтключитьИспользованиеУВыбранногоПоля(ЭлементыВыбора, ИмяПоля)
	
	Для Каждого ЭлементВыбора Из ЭлементыВыбора Цикл
		
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
		Если ТипЗнч(ЭлементВыбора) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Если ЭлементВыбора.Поле = ПолеКомпоновки Тогда
				ЭлементВыбора.Использование = Ложь;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ЭлементВыбора) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			ОтключитьИспользованиеУВыбранногоПоля(ЭлементВыбора.Элементы, ИмяПоля);
		Иначе
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтключитьИспользованиеУГруппировки(Структура, ИмяГруппировки)
	
	Для Каждого ЭлементСтруктуры Из Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяГруппировки);
			Для Каждого ПолеГруппировки Из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
				Если ТипЗнч(ПолеГруппировки) = Тип("ПолеГруппировкиКомпоновкиДанных")
					И ПолеГруппировки.Поле = ПолеКомпоновки Тогда
					ПолеГруппировки.Использование = Ложь;
				КонецЕсли;
			КонецЦикла;
			ОтключитьИспользованиеУВыбранногоПоля(ЭлементСтруктуры.Выбор.Элементы, ИмяГруппировки);
			ОтключитьИспользованиеУГруппировки(ЭлементСтруктуры.Структура, ИмяГруппировки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПоказательБюджетов", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли