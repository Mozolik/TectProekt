﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если Параметры.ДополнительныеПараметры.Свойство("Сотрудник") И Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			Объект.Сотрудник = Параметры.ДополнительныеПараметры.Сотрудник;
		КонецЕсли;
		
		// Создание нового документа
		ЗначенияДляЗаполнения = Новый Структура("Ответственный", "Объект.Ответственный");
		
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		КонецЕсли;
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если Параметры.Свойство("Основание") Тогда
			ДокументОбъект = РеквизитФормыВЗначение("Объект");
			ДокументОбъект.Заполнить(Параметры.Основание);
			ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
		КонецЕсли;
		
		//ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	ПриПолученииДанныхНаСервере();
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ДанныеОЗаработке, "РасчетныйМесяц", "РасчетныйМесяцСтрокой");
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
		
	КорректировкаДанныхОСтаже = НЕ Объект.КорректировкаДанныхОСтаже;
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ДанныеОЗаработке, "РасчетныйМесяц", "РасчетныйМесяцСтрокой");
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Проведен", ЭтаФорма.Объект.Проведен);
	ПараметрыОповещения.Вставить("ПомеченНаУдаление", ЭтаФорма.Объект.ПометкаУдаления);
	ПараметрыОповещения.Вставить("Результат", ЭтаФорма.Объект.Ссылка);
	ПараметрыОповещения.Вставить("Ответственный", ЭтаФорма.Объект.Ответственный);
	ПараметрыОповещения.Вставить("ДатаДокумента", ЭтаФорма.Объект.Дата);
	ПараметрыОповещения.Вставить("НомерДокумента", ЭтаФорма.Объект.Номер);
	ПараметрыОповещения.Вставить("Сотрудник", ЭтаФорма.Объект.Сотрудник);
	Оповестить("ПослеЗаписиОбъектаСвязанногоСПереводомКДругомуРаботодателю", ПараметрыОповещения, ВладелецФормы);
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ДанныеОЗаработке, "РасчетныйМесяц", "РасчетныйМесяцСтрокой");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КорректировкаДанныхОСтажеПриИзменении(Элемент)
	Если Объект.ДанныеОЗаработке.Количество() > 0 Тогда
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, НСтр("ru='Табличная часть будет очищена, продолжить?';uk='Таблична частина буде очищена, продовжити?'"), Режим, 0);
	Иначе
		Объект.КорректировкаДанныхОСтаже = НЕ КорректировкаДанныхОСтаже;
        РезультатВопросаОчисткаФормы();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.КорректировкаДанныхОСтаже = НЕ КорректировкаДанныхОСтаже;
        РезультатВопросаОчисткаФормы();
	Иначе
		КорректировкаДанныхОСтаже = НЕ Объект.КорректировкаДанныхОСтаже;
    КонецЕсли;		
КонецПроцедуры	

&НаСервере
Процедура РезультатВопросаОчисткаФормы()
	
	Объект.Страхователь = Справочники.Работодатели.ПустаяСсылка();
	Объект.ДанныеОЗаработке.Очистить();
	УправлениеФормой();

КонецПроцедуры	

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
		Элементы.Страхователь.Видимость = НЕ Объект.КорректировкаДанныхОСтаже;
		Элементы.ДанныеОЗаработкеСтрахователь.Видимость = Объект.КорректировкаДанныхОСтаже;
		Элементы.ДанныеОЗаработкеЗаработок.Видимость = НЕ Объект.КорректировкаДанныхОСтаже;
		Элементы.ДанныеОЗаработкеДнейБолезниУходаЗаДетьми.Видимость = НЕ Объект.КорректировкаДанныхОСтаже;

		
КонецПроцедуры	

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиДанныеОЗаработке

&НаКлиенте
Процедура ДанныеОЗаработкеРасчетныйМесяцСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, Элементы.ДанныеОЗаработке.ТекущиеДанные, "РасчетныйМесяц", "РасчетныйМесяцСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеРасчетныйМесяцСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.ДанныеОЗаработке.ТекущиеДанные, "РасчетныйМесяц", "РасчетныйМесяцСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеРасчетныйМесяцСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.ДанныеОЗаработке.ТекущиеДанные, "РасчетныйМесяц", "РасчетныйМесяцСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеРасчетныйМесяцСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеРасчетныйМесяцСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеДнейСтажаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц = Дата("00010101") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо сначала заполнить поле Расчетный месяц';uk='Необхідно спочатку заповнити поле Розрахунковий місяць'"));
		СтандартнаяОбработка = ЛОЖЬ;
	ИначеЕсли Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа > День(КонецМесяца(Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Количество дней стажа не может превышать количество календарных дней в месяце';uk='Кількість днів стажу не може перевищувати кількість календарних днів у місяці'"));
		Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа = День(КонецМесяца(Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеДнейСтажаПриИзменении(Элемент)
	Если Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц = Дата("00010101") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо сначала заполнить поле Расчетный месяц';uk='Необхідно спочатку заповнити поле Розрахунковий місяць'"));
		Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа = 0;
	ИначеЕсли Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа > День(КонецМесяца(Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Количество дней стажа не может превышать количество календарных дней в месяце';uk='Кількість днів стажу не може перевищувати кількість календарних днів у місяці'"));
		Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа = День(КонецМесяца(Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ПериодРаботыС > Объект.ПериодРаботыПо Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Период начала работы не может быть больше периода окончания';uk='Період початку роботи не може бути більше періоду закінчення'"));
		Отказ = Истина;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОЗаработкеПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа > День(КонецМесяца(Элементы.ДанныеОЗаработке.ТекущиеДанные.РасчетныйМесяц)) Тогда
		Элементы.ДанныеОЗаработке.ТекущиеДанные.ДнейСтажа = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

