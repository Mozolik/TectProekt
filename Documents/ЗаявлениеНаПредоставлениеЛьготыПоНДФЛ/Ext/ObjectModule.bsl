﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДФЛ.СформироватьПрименениеЛьгот(Движения, Отказ, ДанныеДляПроведения());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ИзменитьЛьготыНаДетей И НЕ ИзменитьЛичнуюЛьготу Тогда
		ТекстСообщения = НСтр("ru='Должна быть указана личная льгота или льгота на детей.';uk='Повинна бути вказана особиста пільга чи пільга на дітей.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
	ЛьготыНаДетейДействуетДоПР = ПроверяемыеРеквизиты.Найти("ЛьготыНаДетей.ДействуетДо");
	Если ЛьготыНаДетейДействуетДоПР <> Неопределено Тогда
		Для Каждого ЛьготаНаДетей Из ЛьготыНаДетей Цикл
			Если Не ЗначениеЗаполнено(ЛьготаНаДетей.ДействуетДо) Тогда
				ТекстСообщения = НСтр("ru='Не указана дата окончания действия льготы в строке №%1.';uk='Не вказана дата закінчення дії пільги в рядку №%1.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ЛьготаНаДетей.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ЛьготыНаДетей[" + Формат(ЛьготаНаДетей.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДействуетДо", , Отказ);
				
			ИначеЕсли ЗначениеЗаполнено(ЛьготаНаДетей.ДействуетДо) И ЛьготаНаДетей.ДействуетДо < Месяц Тогда
				ТекстСообщения = НСтр("ru='Дата окончания действия льготы в строке №%1 меньше, чем месяц с которого применяются льготы.';uk='Дата закінчення дії пільги в рядку №%1 менше, ніж місяць з якого застосовуються пільги.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ЛьготаНаДетей.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ЛьготыНаДетей[" + Формат(ЛьготаНаДетей.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДействуетДо", , Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
		ПроверяемыеРеквизиты.Удалить(ЛьготыНаДетейДействуетДоПР);
	КонецЕсли;
	
	// Проверка на дубли движений
	МассивЛьгот = Новый Массив;
	Для Каждого СтрокаЛьгота Из ЛьготыНаДетей Цикл
		МассивЛьгот.Добавить(СтрокаЛьгота.Льгота);
	КонецЦикла;
	
	Для Каждого СтрокаЛьгота Из ЛичныеЛьготы Цикл
		МассивЛьгот.Добавить(СтрокаЛьгота.Льгота);
	КонецЦикла;
	
	Запрос = Документы.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ.КонфликтующиеРегистраторы(Ссылка, Месяц, Сотрудник, МассивЛьгот);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = НСтр("ru='Не удалось провести заявление. Чтобы изменить льготы отредактируйте заявление %1.';uk='Не вдалося провести заяву. Щоб змінити пільги відредагуйте заяву %1.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Регистратор);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Выборка.Регистратор, , , Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеОЛьготах = Новый Структура(
		"МесяцРегистрации,ФизическоеЛицо,ГоловнаяОрганизация,
		|ИзменитьЛьготыНаДетей,ЛьготыНаДетей,
		|ИзменитьЛичнуюЛьготу,ЛичныеЛьготы");
	
	ЗаполнитьЗначенияСвойств(ДанныеОЛьготах, СведенияОПримененииЛьгот());
	
	
	Если ДанныеОЛьготах.ИзменитьЛьготыНаДетей Тогда
		ДанныеОЛьготах.Вставить("ЛьготыНаДетей", СведенияОЛьготахНаДетей(ДанныеОЛьготах));
	КонецЕсли;
	
	Если ДанныеОЛьготах.ИзменитьЛичнуюЛьготу Тогда
		ДанныеОЛьготах.Вставить("ЛичныеЛьготы", СведенияОЛичныхЛьготах(ДанныеОЛьготах));
	КонецЕсли;

	
	Возврат ДанныеОЛьготах;
	
КонецФункции

Функция СведенияОПримененииЛьгот()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Месяц КАК МесяцРегистрации,
	|	Док.Сотрудник КАК ФизическоеЛицо,
	|	Док.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Док.ИзменитьЛичнуюЛьготу,
	|	Док.ИзменитьЛьготыНаДетей
	|ИЗ
	|	Документ.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ КАК Док
	|ГДЕ
	|	Док.Ссылка = &Документ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СведенияОЛьготахНаДетей(ДанныеОЛьготах)
	
	ТаблицаЛьготыНаДетей = Новый ТаблицаЗначений;
	ТаблицаЛьготыНаДетей.Колонки.Добавить("ФизическоеЛицо");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("МесяцРегистрации");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("Льгота");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("ДатаДействия");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("КоличествоДетей");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("ДействуетДо");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("КоличествоДетейПоОкончании");
	ТаблицаЛьготыНаДетей.Колонки.Добавить("Основание");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокЛьготыНаДетей.Льгота КАК Льгота,
	|	ДокЛьготыНаДетей.ДействуетДо КАК ДействуетДо,
	|	КОЛИЧЕСТВО(1) КАК КоличествоДетей
	|ИЗ
	|	Документ.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ.ЛьготыНаДетей КАК ДокЛьготыНаДетей
	|ГДЕ
	|	ДокЛьготыНаДетей.Ссылка = &Документ
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокЛьготыНаДетей.Льгота,
	|	ДокЛьготыНаДетей.ДействуетДо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Льгота,
	|	ДействуетДо";
	ЛьготыНаДетейВыборка =  Запрос.Выполнить().Выбрать();
	
	Пока ЛьготыНаДетейВыборка.СледующийПоЗначениюПоля("Льгота") Цикл
		ТЗ = Новый ТаблицаЗначений;
		ТЗ.Колонки.Добавить("ДатаДействия");
		ТЗ.Колонки.Добавить("КоличествоДетей");
		ТЗ.Колонки.Добавить("ДействуетДо");
		ТЗ.Колонки.Добавить("КоличествоДетейПоОкончании");
		ПредыдущаяДатаДействия = ДанныеОЛьготах.МесяцРегистрации;
		Пока ЛьготыНаДетейВыборка.Следующий() Цикл
			Если ПредыдущаяДатаДействия <> ДанныеОЛьготах.МесяцРегистрации Тогда
				ПредыдущаяСтрокаЛьготы = Неопределено;
				Для Каждого СтрокаЛьготы Из ТЗ Цикл
					СтрокаЛьготы.КоличествоДетей = СтрокаЛьготы.КоличествоДетей + ЛьготыНаДетейВыборка.КоличествоДетей;
					Если ПредыдущаяСтрокаЛьготы <> Неопределено Тогда
						ПредыдущаяСтрокаЛьготы.КоличествоДетейПоОкончании = СтрокаЛьготы.КоличествоДетей;
					КонецЕсли;
					ПредыдущаяСтрокаЛьготы = СтрокаЛьготы;
				КонецЦикла;
				ПредыдущаяСтрокаЛьготы.КоличествоДетейПоОкончании = ЛьготыНаДетейВыборка.КоличествоДетей;
			КонецЕсли;
			
			СтрокаЛьготы = ТЗ.Найти(ПредыдущаяДатаДействия, "ДатаДействия");
			Если СтрокаЛьготы = Неопределено Тогда
				СтрокаЛьготы = ТЗ.Добавить();
				СтрокаЛьготы.ДатаДействия			= ПредыдущаяДатаДействия;
			КонецЕсли;
			
			СтрокаЛьготы.КоличествоДетей			= ЛьготыНаДетейВыборка.КоличествоДетей;
			СтрокаЛьготы.ДействуетДо				= НачалоМесяца(ЛьготыНаДетейВыборка.ДействуетДо);
			СтрокаЛьготы.КоличествоДетейПоОкончании	= 0;
			
			ПредыдущаяДатаДействия = КонецМесяца(ЛьготыНаДетейВыборка.ДействуетДо) + 1;
		КонецЦикла;
		ТЗ.Свернуть("ДатаДействия, ДействуетДо", "КоличествоДетей, КоличествоДетейПоОкончании");
		
		Для Каждого СтрокаЛьготы Из ТЗ Цикл
			ЗаписьОЛьготеНаДетей = ТаблицаЛьготыНаДетей.Добавить();
			
			ЗаписьОЛьготеНаДетей.ФизическоеЛицо				= ДанныеОЛьготах.ФизическоеЛицо;
			ЗаписьОЛьготеНаДетей.МесяцРегистрации			= ДанныеОЛьготах.МесяцРегистрации;
			ЗаписьОЛьготеНаДетей.Льгота						= ЛьготыНаДетейВыборка.Льгота;
			ЗаписьОЛьготеНаДетей.ДатаДействия				= СтрокаЛьготы.ДатаДействия;
			ЗаписьОЛьготеНаДетей.КоличествоДетей			= СтрокаЛьготы.КоличествоДетей;
			ЗаписьОЛьготеНаДетей.ДействуетДо				= СтрокаЛьготы.ДействуетДо;
			ЗаписьОЛьготеНаДетей.КоличествоДетейПоОкончании	= СтрокаЛьготы.КоличествоДетейПоОкончании;
			
			ЗаписьОЛьготеНаДетей.Основание = 
				ЗаявлениеИДокументыПодтверждающиеПраваНаЛьготы(ЛьготыНаДетейВыборка.Льгота,
					СтрокаЛьготы.ДатаДействия,
					СтрокаЛьготы.ДействуетДо);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаЛьготыНаДетей;
	
КонецФункции

Функция СведенияОЛичныхЛьготах(ДанныеОЛьготах)
	
	ТаблицаЛичныеЛьготы = Новый ТаблицаЗначений;
	ТаблицаЛичныеЛьготы.Колонки.Добавить("ФизическоеЛицо");
	ТаблицаЛичныеЛьготы.Колонки.Добавить("Льгота");
	ТаблицаЛичныеЛьготы.Колонки.Добавить("Актуальность");
	ТаблицаЛичныеЛьготы.Колонки.Добавить("Основание");
	ТаблицаЛичныеЛьготы.Колонки.Добавить("Период");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокЛичныеЛьготы.Льгота КАК Льгота
	|ИЗ
	|	Документ.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ.ЛичныеЛьготы КАК ДокЛичныеЛьготы
	|ГДЕ
	|	ДокЛичныеЛьготы.Ссылка = &Документ
	|
	|
	|УПОРЯДОЧИТЬ ПО
	|	Льгота";
	ЛичныеЛьготыВыборка =  Запрос.Выполнить().Выбрать();
	
	Пока ЛичныеЛьготыВыборка.Следующий() Цикл
		
			ЗаписьОЛичнойЛьготе = ТаблицаЛичныеЛьготы.Добавить();
			
			ЗаписьОЛичнойЛьготе.ФизическоеЛицо				= ДанныеОЛьготах.ФизическоеЛицо;
			ЗаписьОЛичнойЛьготе.Льгота						= ЛичныеЛьготыВыборка.Льгота;
			ЗаписьОЛичнойЛьготе.Период						= Месяц;
			ЗаписьОЛичнойЛьготе.Актуальность				= Истина;
			
			ЗаписьОЛичнойЛьготе.Основание = 
				ЗаявлениеИДокументыПодтверждающиеПраваНаЛичныеЛьготы(ЛичныеЛьготыВыборка.Льгота);
	КонецЦикла;
	
	Возврат ТаблицаЛичныеЛьготы;
	
КонецФункции

// Формирует строку с реквизитами заявления и перечнем документов-оснований 
// (через ", ") соответствующих указанному в параметрах периоду действия
//
// Параметры:
//  Льгота  - СправочникСсылка.ВидыЛьготПоНДФЛ - Льгота.
//  НачалоПериода  - Дата - Дата начала периода
//  ОкончаниеПериода  - Дата - Дата окончания периода 
//                 
//
// Возвращаемое значение:
//   Строка   - Значение формируемое из полей "ДокументПодтверждающийПравоНаЛьготу"
//				в виде "Заявление № ... от 15.01.15 + данные о документах"
//
Функция ЗаявлениеИДокументыПодтверждающиеПраваНаЛьготы(Льгота, НачалоПериода, ОкончаниеПериода)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей.ДокументПодтверждающийПравоНаЛьготу
		|ИЗ
		|	Документ.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ.ЛьготыНаДетей КАК ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей
		|ГДЕ
		|	ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей.Ссылка = &Ссылка
		|	И ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей.Льгота = &Льгота
		|	И ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей.ДействуетДо >= &НачалоПериода
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛьготыНаДетей.ДействуетДо";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Льгота", Льгота);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	
	ТЗРезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	МассивДокументовПодтверждающихПраваНаЛьготы = ТЗРезультатыЗапроса.ВыгрузитьКолонку(ТЗРезультатыЗапроса.Колонки[0]);
	ДокументыПодтверждающиеПраваНаЛьготы = СтрСоединить(МассивДокументовПодтверждающихПраваНаЛьготы, ", ");
	ВозвращаемоеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Заявление от %1 №%2. %3.';uk='Заява від %1 №%2. %3.'"),
			Формат(Дата, "ДЛФ=D"), 
			Символы.НПП + Номер, 
			ДокументыПодтверждающиеПраваНаЛьготы);
	
	Возврат ВозвращаемоеЗначение;

КонецФункции

// Формирует строку с реквизитами заявления и перечнем документов-оснований 
// (через ", ") соответствующих указанному в параметрах периоду действия
//
// Параметры:
//  Льгота  - СправочникСсылка.ВидыЛьготПоНДФЛ - Льгота.
//                 
//
// Возвращаемое значение:
//   Строка   - Значение формируемое из полей "ДокументПодтверждающийПравоНаЛьготу"
//				в виде "Заявление № ... от 15.01.15 + данные о документах"
//
Функция ЗаявлениеИДокументыПодтверждающиеПраваНаЛичныеЛьготы(Льгота)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛичныеЛьготы.ДокументПодтверждающийПравоНаЛьготу
		|ИЗ
		|	Документ.ЗаявлениеНаПредоставлениеЛьготыПоНДФЛ.ЛичныеЛьготы КАК ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛичныеЛьготы
		|ГДЕ
		|	ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛичныеЛьготы.Ссылка = &Ссылка
		|	И ЗаявлениеНаПредоставлениеЛьготыПоНДФЛЛичныеЛьготы.Льгота = &Льгота
		|";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Льгота", Льгота);
	
	ТЗРезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	МассивДокументовПодтверждающихПраваНаЛьготы = ТЗРезультатыЗапроса.ВыгрузитьКолонку(ТЗРезультатыЗапроса.Колонки[0]);
	ДокументыПодтверждающиеПраваНаЛьготы = СтрСоединить(МассивДокументовПодтверждающихПраваНаЛьготы, ", ");
	ВозвращаемоеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Заявление от %1 №%2. %3.';uk='Заява від %1 №%2. %3.'"),
			Формат(Дата, "ДЛФ=D"), 
			Символы.НПП + Номер, 
			ДокументыПодтверждающиеПраваНаЛьготы);
	
	Возврат ВозвращаемоеЗначение;

КонецФункции

#КонецОбласти

#КонецЕсли
