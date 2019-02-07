﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидАналитики = Параметры.ВидАналитики;
	АдресСхемыКомпоновкиДанных = Параметры.АдресСхемыКомпоновкиДанных;
	ТекущееВыражение = Параметры.ТекущееВыражение;
	
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ТипЗначения",               "ТипЗначения");
	Реквизиты.Вставить("ДополнительноеСвойство",    "ДополнительноеСвойство");
	Реквизиты.Вставить("ЭтоДополнительноеСведение", "ДополнительноеСвойство.ЭтоДополнительноеСведение");
	ЗначенияРеквизитовВидаАналитики = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидАналитики, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначенияРеквизитовВидаАналитики);
	
	ВидимостьКоманды = ЗначениеЗаполнено(ДополнительноеСвойство);
	Элементы.ФормаДобавитьДополнительноеСвойство.Видимость = ВидимостьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюДобавитьДополнительноеСвойство.Видимость = ВидимостьКоманды;
	Если ВидимостьКоманды Тогда
		Если ЭтоДополнительноеСведение Тогда
			ЗаголовокКоманды = НСтр("ru='Добавить дополнительное сведение';uk='Додати додаткову відомість'");
		Иначе
			ЗаголовокКоманды = НСтр("ru='Добавить дополнительный реквизит';uk='Додати додатковий реквізит'");
		КонецЕсли;
		Элементы.ФормаДобавитьДополнительноеСвойство.Заголовок = ЗаголовокКоманды;
		Элементы.ДеревоВыбораКонтекстноеМенюДобавитьДополнительноеСвойство.Заголовок = ЗаголовокКоманды;
	КонецЕсли;
	
	ОписаниеТиповДопСвойств = Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Тип;
	ВидАналитикиМожноОпределитьЧерезДопСвойство = Ложь;
	Если ТипЗначения.Типы().Количество() = 1 И ОписаниеТиповДопСвойств.СодержитТип(ТипЗначения.Типы()[0]) Тогда
		ВидАналитикиМожноОпределитьЧерезДопСвойство = Истина;
	КонецЕсли;
	
	ВидимостьКоманды = Не ЗначениеЗаполнено(ДополнительноеСвойство) И ВидАналитикиМожноОпределитьЧерезДопСвойство;
	
	Элементы.ФормаСоздатьДополнительныйРеквизит.Видимость = ВидимостьКоманды;
	Элементы.ФормаСоздатьДополнительноеСведение.Видимость = ВидимостьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюСоздатьДополнительноеСведение.Видимость = ВидимостьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюСоздатьДополнительныйРеквизит.Видимость = ВидимостьКоманды;
	
	ФинансоваяОтчетностьСервер.ЗаполнитьДоступныеПоляПоСхемеКомпоновкиДанных(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыбор(Элементы.ДеревоВыбора.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительноеСвойство(Команда)
	
	ТекущиеДанные = Элементы.ДеревоВыбора.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущееВыражение = ТекущиеДанные.Значение;
	
	ДобавитьДополнительноеСвойствоСервер(ДополнительноеСвойство, ТекущиеДанные.ТипЗначения)
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДополнительноеСведение(Команда)
	
	ТекущиеДанные = Элементы.ДеревоВыбора.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущееВыражение = ТекущиеДанные.Значение;
	
	СоздатьДополнительноеСвойствоКлиент(ТекущиеДанные.ТипЗначения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДополнительныйРеквизит(Команда)
	
	ТекущиеДанные = Элементы.ДеревоВыбора.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущееВыражение = ТекущиеДанные.Значение;
	
	СоздатьДополнительноеСвойствоКлиент(ТекущиеДанные.ТипЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоВыбораПриАктивизацииСтроки(Элемент)
	
	ДоступностьКоманды = Ложь;
	
	ТекущиеДанные = Элементы.ДеревоВыбора.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущееВыражение = ТекущиеДанные.Значение;
		Родитель = ТекущиеДанные.ПолучитьРодителя();
		ДоступностьКоманды = Не ТекущиеДанные.ЭтоГруппа И (Родитель = Неопределено Или Родитель.ЭтоГруппа);
	КонецЕсли;
	
	Элементы.ФормаСоздатьДополнительныйРеквизит.Доступность = ДоступностьКоманды;
	Элементы.ФормаСоздатьДополнительноеСведение.Доступность = ДоступностьКоманды;
	Элементы.ФормаДобавитьДополнительноеСвойство.Доступность = ДоступностьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюСоздатьДополнительноеСведение.Доступность = ДоступностьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюДобавитьДополнительноеСвойство.Доступность = ДоступностьКоманды;
	Элементы.ДеревоВыбораКонтекстноеМенюСоздатьДополнительныйРеквизит.Доступность = ДоступностьКоманды; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыбор(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиенте
Процедура ОбработатьВыбор(ВыбраннаяСтрока)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоВыбора.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Не СтрокаДерева.Искомый Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(СтрокаДерева.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДополнительноеСвойствоКлиент(ТипЗначенияПоляИсточника, ДополнительноеСведение = Ложь)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДополнительноеСведение", ДополнительноеСведение);
	ДополнительныеПараметры.Вставить("ТипЗначенияПоляИсточника", ТипЗначенияПоляИсточника);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВводеНаименованияДополнительногоСвойства", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВводСтроки(ОписаниеОповещения, ,  НСтр("ru='Введите наименование';uk='Введіть найменування'"), 150);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВводеНаименованияДополнительногоСвойства(Наименование, ДополнительныеПараметры) Экспорт
	
	Если ПустаяСтрока(Наименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Введите наименование реквизита';uk='Введіть найменування реквізиту'"));
		Возврат;
	КонецЕсли;
	
	СоздатьДополнительноеСвойствоСервер(Наименование, 
		ДополнительныеПараметры.ТипЗначенияПоляИсточника,
		ДополнительныеПараметры.ДополнительноеСведение);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДополнительноеСвойствоСервер(Наименование, ТипЗначенияПоляИсточника, ЭтоДополнительноеСведение)
	
	Для каждого Тип Из ТипЗначенияПоляИсточника.Типы() Цикл
		
		Ссылка = Новый (Тип);
		НаборСвойств = ПроверитьВозможностьДобавленияДополнительногоСвойства(Ссылка, ЭтоДополнительноеСведение);
		Если НаборСвойств = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			НовоеДополнительноеСвойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
			НовоеДополнительноеСвойство.НаборСвойств = НаборСвойств;
			НовоеДополнительноеСвойство.Заголовок = Наименование;
			НовоеДополнительноеСвойство.Наименование = Наименование;
			НовоеДополнительноеСвойство.ТипЗначения = ТипЗначения;
			НовоеДополнительноеСвойство.ЭтоДополнительноеСведение = ЭтоДополнительноеСведение;
			НовоеДополнительноеСвойство.Записать();
			
			ДобавитьДополнительноеСвойствоДляОбъекта(НаборСвойств, НовоеДополнительноеСвойство.Ссылка, ЭтоДополнительноеСведение); 
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	ФинансоваяОтчетностьСервер.ЗаполнитьДоступныеПоляПоСхемеКомпоновкиДанных(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция НаборСвойствОбъекта(Ссылка)
	
	НаборыСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Ссылка);
	
	Если НаборыСвойств.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат НаборыСвойств[0].Набор;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ДобавитьДополнительноеСвойствоСервер(ВыбранноеДополнительноеСвойство, ОписаниеТипов)
	
	ЭтоДополнительноеСведение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ВыбранноеДополнительноеСвойство, "ЭтоДополнительноеСведение");
	
	Для каждого Тип Из ОписаниеТипов.Типы() Цикл
		Ссылка = Новый (Тип);
		НаборСвойств = ПроверитьВозможностьДобавленияДополнительногоСвойства(Ссылка, ЭтоДополнительноеСведение);
		Если НаборСвойств = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьДополнительноеСвойствоДляОбъекта(НаборСвойств, ВыбранноеДополнительноеСвойство, ЭтоДополнительноеСведение);
	КонецЦикла;
	
	ФинансоваяОтчетностьСервер.ЗаполнитьДоступныеПоляПоСхемеКомпоновкиДанных(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДополнительноеСвойствоДляОбъекта(НаборСвойств, ВыбранноеДополнительноеСвойство, ЭтоДополнительноеСведение)
	
	НаборСвойствОбъект = НаборСвойств.ПолучитьОбъект();
	Если ЭтоДополнительноеСведение Тогда
		ДополнительныеСвойства = НаборСвойствОбъект.ДополнительныеСведения;
	Иначе
		ДополнительныеСвойства = НаборСвойствОбъект.ДополнительныеРеквизиты;
	КонецЕсли;
	
	НовоеСвойство = ДополнительныеСвойства.Добавить();
	НовоеСвойство.Свойство = ВыбранноеДополнительноеСвойство;
	
	НаборСвойствОбъект.Записать();
	
	НаименованиеСвойства = Строка(ВыбранноеДополнительноеСвойство);
	Если Найти(НаименованиеСвойства, " ") <> 0 Тогда
		НаименованиеСвойства = "[" + НаименованиеСвойства + "]";
	КонецЕсли;
	
	ТекущееВыражение = ТекущееВыражение + "." + НаименованиеСвойства;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВозможностьДобавленияДополнительногоСвойства(Ссылка, ЭтоДополнительноеСведение)
	
	МожноДобавитьДополнительноеСвойство = Истина;
	Если ЭтоДополнительноеСведение Тогда
		Если Не УправлениеСвойствами.ИспользоватьДопСведения(Ссылка) Тогда
			МожноДобавитьДополнительноеСвойство = Ложь;
			ШаблонСообщения = НСтр("ru='Для объекта ""%1"" не предусмотрено использование дополнительных сведений.';uk='Для об''єкта ""%1"" не передбачено використання додаткових відомостей.'");
		КонецЕсли;
	Иначе
		Если Не УправлениеСвойствами.ИспользоватьДопРеквизиты(Ссылка) Тогда
			МожноДобавитьДополнительноеСвойство = Ложь;
			ШаблонСообщения = НСтр("ru='Для объекта ""%1"" не предусмотрено использование дополнительных реквизитов.';uk='Для об''єкта ""%1"" не передбачено використання додаткових реквізитів.'");
		КонецЕсли;
	КонецЕсли;
		
	Если Не МожноДобавитьДополнительноеСвойство Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, Ссылка.Метаданные().Представление()));
		Возврат Неопределено;
	КонецЕсли;
	
	НаборСвойствОбъекта = НаборСвойствОбъекта(Ссылка);
	
	Возврат НаборСвойствОбъекта;
	
КонецФункции

#КонецОбласти