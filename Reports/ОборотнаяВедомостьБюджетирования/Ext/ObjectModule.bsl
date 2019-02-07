﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Если ЭтаФорма.КлючТекущегоВарианта = "Расшифровка" Тогда
		
		КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
		ФиксированныеНастройки = КомпоновщикНастроекФормы.ФиксированныеНастройки;
		
		ИсточникДобавления = ФиксированныеНастройки.Структура;
		МестоДобавления = КомпоновщикНастроекФормы.Настройки.Структура;
		
		Пока ИсточникДобавления.Количество() Цикл
			Группировка = ИсточникДобавления[0];
			НоваяГруппировка = ФинансоваяОтчетностьСервер.НоваяГруппировка(МестоДобавления, Группировка.Имя);
			МестоДобавления = НоваяГруппировка.Структура;
			ИсточникДобавления = Группировка.Структура;
		КонецЦикла;
		
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(КомпоновщикНастроекФормы.Настройки.Выбор, ФиксированныеНастройки.Выбор, Истина);
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Перем КоличествоДокументов;
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборы = НаборыДанных();
	
	БюджетированиеСервер.ДополнитьСхемуКомпоновкиДанныхАналитикойПоВиду(СхемаКомпоновкиДанных, "СтатьяБюджетов");
	
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
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	//++ НЕ УТКА
	ФактическиеДанныеБюджетированияСервер.ВывестиАктуальностьОтраженияФактическихДанных(ДокументРезультат, ДопСвойства);
	//-- НЕ УТКА
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанныхОтчета

Функция НаборыДанных()
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрыПолученияФакта = ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета);
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("ОборотыПлан", ОборотыПлан(НастройкиОтчета));
	ОборотыФакт = ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта);
	НаборыДанных.Вставить("ОборотыФакт", ОборотыФакт);
	НаборыДанных.Вставить("ОборотыТолькоФакт", ОборотыФакт.Скопировать(Новый Структура("Сценарий", Справочники.Сценарии.ФактическиеДанные)));
	
	Возврат НаборыДанных; 
	
КонецФункции

Функция ОборотыПлан(НастройкиОтчета) 
	
	СхемаКомпоновкиПлана = Отчеты.ОборотнаяВедомостьБюджетирования.ПолучитьМакет("ОборотыПлан");
	Настройки = СхемаКомпоновкиПлана.НастройкиПоУмолчанию;
	
	БюджетированиеСервер.ДополнитьСхемуКомпоновкиДанныхАналитикойПоВиду(СхемаКомпоновкиПлана, "СтатьяБюджетов");
	
	КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(Настройки.ПараметрыДанных, НастройкиОтчета.ПараметрыДанных);
	КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаКомпоновкиПлана, Настройки, НастройкиОтчета);
	
	Группировка = Настройки.Структура[0];
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор") Тогда
		ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, "Регистратор");
	КонецЕсли;
	
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		ПолеПериод = "Период" + ?(ЗначениеЗаполнено(Периодичность), ОбщегоНазначения.ИмяЗначенияПеречисления(Периодичность), "");
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, ПолеПериод) Тогда
			ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, ПолеПериод);
		КонецЕсли;
	КонецЦикла;
	
	НеобходимПересчетСуммыВВалютуОтчета = Ложь;
	ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Если ВалютаОтчета = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		ВыражениеСуммы = "СуммаРегл";
	ИначеЕсли ВалютаОтчета = Константы.ВалютаУправленческогоУчета.Получить() Тогда
		ВыражениеСуммы = "СуммаУпр";
	Иначе
		ВыражениеСуммы = "ВЫБОР КОГДА Валюта = &Валюта ТОГДА СуммаВВалюте ИНАЧЕ СуммаРегл / ЕСТЬNULL(Курс,1) КОНЕЦ";
		НеобходимПересчетСуммыВВалютуОтчета = Истина;
	КонецЕсли;
	
	Ресурсы = Новый Структура;
	Ресурсы.Вставить("СуммаПлан", ВыражениеСуммы);
	Ресурсы.Вставить("КоличествоПлан", "Количество");
	Для каждого Ресурс Из Ресурсы Цикл
		ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(СхемаКомпоновкиПлана, Ресурс.Ключ, Ресурс.Значение, "Сумма");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, Ресурс.Ключ);
	КонецЦикла;
	
	План = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаКомпоновкиПлана, Настройки);
	
	Возврат План;
	
КонецФункции

Функция ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ФактПоСтатьямБюджетов = БюджетированиеСервер.ФактПоСтатьямБюджетов(НастройкиОтчета, ПараметрыПолученияФакта);
	
	Если ЗначениеЗаполнено(ПараметрыПолученияФакта.Периодичность) Тогда
		ФактПоСтатьямБюджетов.Колонки["Период"].Имя = "Период" + ПараметрыПолученияФакта.Периодичность;
	КонецЕсли;
	
	НаборДанныхФакт = СхемаКомпоновкиДанных.НаборыДанных.ОборотыФакт;
	Для каждого ПолеНабораДанных Из НаборДанныхФакт.Поля Цикл
		Если ФактПоСтатьямБюджетов.Колонки.Найти(ПолеНабораДанных.Поле) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ФактПоСтатьямБюджетов.Колонки.Добавить(ПолеНабораДанных.Поле, ПолеНабораДанных.ТипЗначения);
	КонецЦикла;
	
	Возврат ФактПоСтатьямБюджетов;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета)
	
	Параметры = БюджетированиеСервер.ПараметрыПолученияФакта();
	
	Параметры.ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Параметры.Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Параметры.ПоОрганизациям = Истина;
	Параметры.ПоПодразделениям = Истина;
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор") Тогда
		Параметры.РазворачиватьПоРегистратору = Истина;
	КонецЕсли;
	
	Периодичности = Новый Массив;
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Период" + ?(ЗначениеЗаполнено(Периодичность), ОбщегоНазначения.ИмяЗначенияПеречисления(Периодичность), "")) Тогда
			Периодичности.Добавить(Периодичность);
		КонецЕсли;
	КонецЦикла;
	Параметры.Периодичность = Перечисления.Периодичность.МинимальнаяПериодичность(Периодичности);
	
	Возврат Параметры; 
	
КонецФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрВалютаПользовательские = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	ПараметрВалютаФиксированные = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Валюта");
	
	ЕстьВалюта = ПараметрВалютаПользовательские <> Неопределено И ЗначениеЗаполнено(ПараметрВалютаПользовательские.Значение);
	Если Не ЕстьВалюта Тогда
		ЕстьВалюта = ПараметрВалютаФиксированные <> Неопределено И ЗначениеЗаполнено(ПараметрВалютаФиксированные.Значение);
	КонецЕсли;
	
	Если Не ЕстьВалюта Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, "Валюта", Константы.ВалютаУправленческогоУчета.Получить());
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
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
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("СтатьяБюджетов", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли