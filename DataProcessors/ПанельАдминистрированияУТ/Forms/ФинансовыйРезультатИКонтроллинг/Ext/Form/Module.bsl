﻿
&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСделкиСКлиентами");
	//++ НЕ УТКА
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьМеждународныйФинансовыйУчет");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет");
	//-- НЕ УТКА
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.РасчетСебестоимости);
	РассчитыватьПредварительнуюСебестоимостьИдентификатор = РегламентныеЗаданияСервер.УникальныйИдентификатор(РегламентноеЗадание);
	РассчитыватьПредварительнуюСебестоимостьИспользование = РегламентноеЗадание.Использование;
	РассчитыватьПредварительнуюСебестоимостьРасписание    = РегламентноеЗадание.Расписание;
	
	// Настройки видимости при запуске
	Элементы.ГруппаИспользоватьМониторингЦелевыхПоказателейПраво.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьРаздельныйУчетПоНалогообложениюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьГруппыФинансовогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьСебестоимостьТоваровПоВидамЗапасовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);

	РассчитыватьПредварительнуюСебестоимостьИспользование = НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием;
	Если РассчитыватьПредварительнуюСебестоимостьИспользование Тогда
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("Идентификатор", РассчитыватьПредварительнуюСебестоимостьИдентификатор);
		ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", "РассчитыватьПредварительнуюСебестоимостьРасписание");
		ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", "РассчитыватьПредварительнуюСебестоимостьИспользование");
		
		РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
	Иначе
		Изменения = Новый Структура("Использование", Ложь);
		РегламентныеЗаданияСохранить(РассчитыватьПредварительнуюСебестоимостьИдентификатор,
									Изменения,
									"РассчитыватьПредварительнуюСебестоимостьИспользование");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоГруппамФинансовогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоПодразделениямМенеджерамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоСделкамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихДоходовРасходовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихАктивовПассивовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьФинансовыйРезультатПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьУправленческийБалансПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьОтчетностьПоНДСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры


&НаКлиенте
Процедура ИспользоватьГруппыАналитическогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАмортизациюБухгалтерскогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМониторингЦелевыхПоказателейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаРасписанияРегламентногоЗаданияПредварительногоРасчетаСебестоимости(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", РассчитыватьПредварительнуюСебестоимостьИдентификатор);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", "РассчитыватьПредварительнуюСебестоимостьРасписание");
	
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РассчитыватьПредварительнуюСебестоимостьРасписание);
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПоставляемуюМодельПоказателей(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ВосстановитьПоставляемуюМодельПоказателейЗавершение", ЭтаФорма), 
		НСтр("ru='Настройки поставляемых категорий целей, целевых показателей, вариантов анализа и целевых значений будут сброшены.
        |Продолжить с потерей настроек поставляемой модели показателей?'
        |;uk='Настройки категорій цілей, цільових показників, варіантів аналізу та цільових значень, що поставляються, будуть скинуті.
        |Продовжити з втратою настройок  моделі показників, що поставляється?'"), РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте 
Процедура ВосстановитьПоставляемуюМодельПоказателейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		ЗаполнитьСтруктуруЦелейИВариантыАнализаНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
			НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор,
								 Изменения,
								 ПараметрыВыполнения.ИмяРеквизитаРасписание);
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(УникальныйИдентификатор, Изменения);
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов" Тогда
		ЗапасыСервер.ПроведениеДокументовПоРегиструСебестоимостьТоваров();
		Если НЕ КонстантаЗначение И Константы.ИспользоватьКомиссиюПриЗакупках.Получить() Тогда
			Константы.ИспользоватьКомиссиюПриЗакупках.Установить(Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПартионныйУчет" Тогда
		Если НЕ КонстантаЗначение Тогда
			Обработки.ПервоначальноеЗаполнениеРегистровПартионногоУчета.ОтменаПроведенияДокументовПоРегистрамПартий();
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьГруппыФинансовогоУчета" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ФормироватьВидыЗапасовПоГруппамФинансовогоУчета.Доступность =
			НаборКонстант.ИспользоватьГруппыФинансовогоУчета И НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ФормироватьФинансовыйРезультат.Доступность = НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФормироватьФинансовыйРезультат" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ФормироватьФинансовыйРезультат,
			НаборКонстант.ФормироватьФинансовыйРезультат);
	КонецЕсли;
	
	ИспользоватьМФУ = Ложь;
	ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет = Ложь;
	//++ НЕ УТКА
	ИспользоватьМФУ = НаборКонстант.ИспользоватьМеждународныйФинансовыйУчет;
	ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет = НаборКонстант.ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет;
	//-- НЕ УТКА
	Элементы.ГруппаКомментарийИспользованиеМФУ.Видимость = ИспользоватьМФУ;
	Элементы.ГруппаДетализацияФинансовогоРезультата.Доступность = НЕ ИспользоватьМФУ;
	Элементы.ГруппаКомментарийИспользованиеУпрБаланса.Видимость = ИспользоватьМФУ;
	Элементы.ГруппаФормироватьБаланс.Доступность = НЕ ИспользоватьМФУ;
	
	Элементы.ГруппаИспользоватьАмортизациюБухгалтерскогоУчета.Доступность =
		Не (ИспользоватьМФУ И ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет);
	Элементы.ГруппаКомментарийИспользоватьАмортизациюБухгалтерскогоУчета.Видимость =
		(ИспользоватьМФУ И ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет);
		
	Если РеквизитПутьКДанным = "НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов;
		
		Элементы.ФормироватьВидыЗапасовПоПодразделениямМенеджерам.Доступность 	= ЗначениеКонстанты;
		Элементы.ФормироватьВидыЗапасовПоПоставщикам.Доступность 				= ЗначениеКонстанты;
		Элементы.ФормироватьВидыЗапасовПоГруппамФинансовогоУчета.Доступность 	=
			ЗначениеКонстанты И НаборКонстант.ИспользоватьГруппыФинансовогоУчета;
		Элементы.ФормироватьВидыЗапасовПоСделкам.Доступность 					=
			ЗначениеКонстанты И Константы.ИспользоватьСделкиСКлиентами.Получить();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПартионныйУчет" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ГруппаИспользоватьРаздельныйУчетПоНалогообложению.Доступность = НаборКонстант.ИспользоватьПартионныйУчет;
		Элементы.ВключитьПартионныйУчет.Доступность = НаборКонстант.ИспользоватьПартионныйУчет;
		Элементы.ГруппаКоментарийИспользоватьРаздельныйУчетПоНалогообложению.Видимость = НЕ (НаборКонстант.ИспользоватьПартионныйУчет);
		
		Если ПартионныйУчетНельзяВыключать() Тогда
			Элементы.ГруппаНастройкаИспользоватьПартионныйУчет.Доступность = Ложь;
		Иначе
			Элементы.ГруппаКомментарийИспользоватьПартионныйУчет.Видимость = Ложь
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФормироватьВидыЗапасовПоПодразделениямМенеджерам" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ФормироватьВидыЗапасовПоПодразделениямМенеджерам.Доступность = НаборКонстант.ИспользоватьПодразделения и НаборКонстант.УчитыватьСебестоимостьТоваровПоВидамЗапасов;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "РассчитыватьПредварительнуюСебестоимостьРасписание"
		ИЛИ РеквизитПутьКДанным = "РассчитыватьПредварительнуюСебестоимостьИспользование"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.НастройкаРасписанияРегламентногоЗаданияПредварительногоРасчетаСебестоимости.Доступность = 
			РассчитыватьПредварительнуюСебестоимостьИспользование;
		Если РассчитыватьПредварительнуюСебестоимостьИспользование Тогда
			Элементы.ГруппаРассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемСтраницы.ТекущаяСтраница = 
				Элементы.РассчитыватьПредварительнуюСтоимостьИспользуется;
		Иначе
			Элементы.ГруппаРассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемСтраницы.ТекущаяСтраница = 
				Элементы.РассчитыватьПредварительнуюСтоимостьНеИспользуется;
		КонецЕсли;
		Если РассчитыватьПредварительнуюСебестоимостьИспользование Тогда
			РасписаниеПредставление = Строка(РассчитыватьПредварительнуюСебестоимостьРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = НСтр("ru='<Отключено>';uk='<Відключено>'");
		КонецЕсли;
		Элементы.ПояснениеРассчитыватьПредварительнуюСебестоимость.Заголовок = Представление;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = Ложь;
		//++ НЕ УТ
		ЗначениеКонстанты = Константы.АналитическийУчетПоГруппамПродукции.Получить();
		Элементы.ГруппаФинансовыйРезультатПраво.Доступность = НЕ ЗначениеКонстанты;
		//-- НЕ УТ
		Элементы.ГруппаКомментарийИспользоватьГруппыАналитическогоУчета.Видимость = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМониторингЦелевыхПоказателей" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ВосстановитьПоставляемуюМодельПоказателей.Доступность = НаборКонстант.ИспользоватьМониторингЦелевыхПоказателей;
		
	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПартионныйУчетПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПартионныйУчет(Команда)
	ОткрытьФорму("Обработка.ПервоначальноеЗаполнениеРегистровПартионногоУчета.Форма.ЗаполнениеРегистров");
КонецПроцедуры

&НаСервере
Функция ПартионныйУчетНельзяВыключать()
	
	Возврат ПартионныйУчетСервер.ПартионныйУчетНельзяВыключать();
	
КонецФункции

&НаСервереБезКонтекста 
Процедура ЗаполнитьСтруктуруЦелейИВариантыАнализаНаСервере()
	МониторингЦелевыхПоказателей.ЗаполнитьСтруктуруЦелейИВариантыАнализа();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
