﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыВнешнихПользователей; // Состав внешних пользователей группы внешних
                                              // пользователей до изменения для использования
                                              // в обработчике события ПриЗаписи.

Перем СтарыйСоставРолейГруппыВнешнихПользователей; // Состав ролей группы внешних пользователей
                                                   // до изменения для использования в обработчике
                                                   // события ПриЗаписи.

Перем СтароеЗначениеВсеОбъектыАвторизации; // Значение реквизита ВсеОбъектыАвторизации
                                           // до изменения для использования в обработчике
                                           // события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ПроверенныеРеквизитыОбъекта = ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта;
	Иначе
		ПроверенныеРеквизитыОбъекта = Новый Массив;
	КонецЕсли;
	
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель",
			НСтр("ru='Предопределенная группа ""Все внешние пользователи"" не может быть родителем.';uk='Напередвизначена група ""Всі зовнішні користувачі"" не може бути батьківським елементом.'"),
			"");
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся внешних пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.ВнешнийПользователь");
	
	// Проверка заполнения назначения группы
	Если Назначение.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Назначение",
			НСтр("ru='Не указан вид пользователей.';uk='Не зазначено вид користувачів.'"),
			"");
	КонецЕсли;
	ПроверенныеРеквизитыОбъекта.Добавить("Назначение");
	
	Для каждого ТекущаяСтрока Из Состав Цикл
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВнешнийПользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru='Внешний пользователь не выбран.';uk='Зовнішній користувач не обраний.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru='Внешний пользователь в строке %1 не выбран.';uk='Зовнішній користувач у рядку %1 не обраний.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("ВнешнийПользователь", ТекущаяСтрока.ВнешнийПользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru='Внешний пользователь повторяется.';uk='Зовнішній користувач повторюється.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru='Внешний пользователь в строке %1 повторяется.';uk='Зовнішній користувач у рядку %1 повторюється.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Роли");
		Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
			СтарыйСоставРолейГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
		Иначе
			СтарыйСоставРолейГруппыВнешнихПользователей = Роли.Выгрузить(Новый Массив);
		КонецЕсли;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		
		ЗаполнитьНазначениеВсемиТипамиВнешнихПользователей();
		ВсеОбъектыАвторизации  = Ложь;
		
		Если НЕ Родитель.Пустая() Тогда
			ВызватьИсключение
				НСтр("ru='Предопределенная группа ""Все внешние пользователи"" не может быть перемещена.';uk='Визначена група ""Всі зовнішні користувачі"" не може бути переміщена.'");
		КонецЕсли;
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение
				НСтр("ru='Добавление участников в предопределенную группу ""Все внешние пользователи"" запрещено.';uk='Додавання учасників у визначену групу ""Всі зовнішні користувачі"" заборонено.'");
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			ВызватьИсключение
				НСтр("ru='Невозможно добавить подгруппу к предопределенной группе ""Все внешние пользователи"".';uk='Неможливо додати підгрупу до напередвизначеної групи ""Всі зовнішні користувачі"".'");
			
		ИначеЕсли Родитель.ВсеОбъектыАвторизации Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Невозможно добавить подгруппу к группе ""%1"", 
                    |так как в число ее участников входят все пользователи.'
                    |;uk='Неможливо додати підгрупи до групи ""%1"", 
                    |тому що в число її учасників входять всі користувачі.'"), Родитель);
		КонецЕсли;
		
		Если ВсеОбъектыАвторизации И ЗначениеЗаполнено(Родитель) Тогда
			ВызватьИсключение
				НСтр("ru='Невозможно переместить группу, в число участников которой входят все пользователи.';uk='Неможливо перемістити групу, у число учасників якої входять всі користувачі.'");
		КонецЕсли;
		
		// Проверка уникальности группы всех объектов авторизации заданного типа.
		Если ВсеОбъектыАвторизации Тогда
			
			// Проверка что назначение не совпадает с группой все внешние пользователи.
			ГруппаВсеВнешниеПользователи = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
			НазначениеВсеВнешниеПользователи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ГруппаВсеВнешниеПользователи, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
			МассивНазначения = Назначение.ВыгрузитьКолонку("ТипПользователей");
			
			Если ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(НазначениеВсеВнешниеПользователи, МассивНазначения) Тогда
				ВызватьИсключение
					НСтр("ru='Невозможно создать группу, совпадающую по назначению с предопределенной группой ""Все внешние пользователи"".';uk='Неможливо створити групу, яка збігається за призначенням з попередньовизначеною групою ""Всі зовнішні користувачі"".'");
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("ТипыПользователей", Назначение.Выгрузить());
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТипыПользователей.ТипПользователей
			|ПОМЕСТИТЬ ТипыПользователей
			|ИЗ
			|	&ТипыПользователей КАК ТипыПользователей
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователей
			|ГДЕ
			|	ИСТИНА В
			|			(ВЫБРАТЬ ПЕРВЫЕ 1
			|				ИСТИНА
			|			ИЗ
			|				ТипыПользователей КАК ТипыПользователей
			|			ГДЕ
			|				ГруппыВнешнихПользователей.Ссылка <> &Ссылка
			|				И ГруппыВнешнихПользователей.Ссылка.ВсеОбъектыАвторизации
			|				И ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей) = ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователей.ТипПользователей))";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
			
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Уже существует группа ""%1"",
                               |в число участников которой входят все пользователи указанных видов.'
                               |;uk='Вже існує група ""%1"",
                               |в число учасників якої входять всі користувачі зазначених видів.'"),
					Выборка.СсылкаПредставление	);
				КонецЕсли;
				
		КонецЕсли;
		
		// Проверка совпадения типа объектов авторизации с родителем
		// (допустимо, если тип у родителя не задан).
		Если ЗначениеЗаполнено(Родитель) Тогда
			
			ТипПользователейРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Родитель, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
			ТипПользователей = Назначение.ВыгрузитьКолонку("ТипПользователей");
			
			Для Каждого ТипПользователя Из ТипПользователей Цикл
				Если ТипПользователейРодителя.Найти(ТипПользователя) = Неопределено Тогда
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Вид участников группы должен быть как у вышестоящей
                        |группы внешних пользователей ""%1"".'
                        |;uk='Вид учасників групи має бути як у поточній
                        |групи зовнішніх користувачів ""%1"".'"), Родитель);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// Если группе внешних пользователей устанавливается тип участников "Все пользователи заданного типа",
		// проверяем наличие подчиненных групп.
		Если ВсеОбъектыАвторизации
			И ЗначениеЗаполнено(Ссылка) Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
			|ГДЕ
			|	ГруппыВнешнихПользователей.Родитель = &Ссылка";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Невозможно изменить вид участников группы ""%1"",
                               |так как у нее имеются подгруппы.'
                               |;uk='Неможливо змінити вид учасників групи ""%1"",
                               |тому що у неї є підгрупи.'"),
					Наименование);
			КонецЕсли;
			
		КонецЕсли;
		
		// Проверка, что при изменении типа объектов авторизации
		// нет подчиненных элементов другого типа (очистка типа допустима).
		Если ЗначениеЗаполнено(Ссылка) Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("ТипыПользователей", Назначение);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТипыПользователей.ТипПользователей
			|ПОМЕСТИТЬ ТипыПользователей
			|ИЗ
			|	&ТипыПользователей КАК ТипыПользователей
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователейНазначение.Ссылка) КАК СсылкаПредставление
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователейНазначение
			|ГДЕ
			|	ИСТИНА В
			|			(ВЫБРАТЬ ПЕРВЫЕ 1
			|				ИСТИНА
			|			ИЗ
			|				ТипыПользователей КАК ТипыПользователей
			|			ГДЕ
			|				ГруппыВнешнихПользователейНазначение.Ссылка.Родитель = &Ссылка
			|				И ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователейНазначение.ТипПользователей) <> ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей))";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Невозможно изменить вид участников группы ""%1"",
                               |так как у нее имеется подгруппа ""%2"" с другим назначением участников.'
                               |;uk='Неможливо змінити вид учасників групи ""%1"",
                               |тому що у неї є підгрупа ""%2"" з іншим призначенням учасників.'"),
					Наименование,
					Выборка.СсылкаПредставление);
			КонецЕсли;
		КонецЕсли;
		
		СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Ссылка, "ВсеОбъектыАвторизации, Родитель");
		
		СтарыйРодитель                      = СтарыеЗначения.Родитель;
		СтароеЗначениеВсеОбъектыАвторизации = СтарыеЗначения.ВсеОбъектыАвторизации;
		
		Если ЗначениеЗаполнено(Ссылка)
		   И Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			
			РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Состав");
			Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
				СтарыйСоставГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
			Иначе
				СтарыйСоставГруппыВнешнихПользователей = Состав.Выгрузить(Новый Массив);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		ИзменилсяСоставРолейГруппыВнешнихПользователей = Ложь;
		
	Иначе
		ИзменилсяСоставРолейГруппыВнешнихПользователей =
			ПользователиСлужебный.РазличияЗначенийКолонки(
				"Роль",
				Роли.Выгрузить(),
				СтарыйСоставРолейГруппыВнешнихПользователей).Количество() <> 0;
	КонецЕсли;
	
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	Если Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		
		Если ВсеОбъектыАвторизации
		 ИЛИ СтароеЗначениеВсеОбъектыАвторизации = Истина Тогда
			
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Ссылка, , УчастникиИзменений, ИзмененныеГруппы);
		Иначе
			ИзмененияСостава = ПользователиСлужебный.РазличияЗначенийКолонки(
				"ВнешнийПользователь",
				Состав.Выгрузить(),
				СтарыйСоставГруппыВнешнихПользователей);
			
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Ссылка, ИзмененияСостава, УчастникиИзменений, ИзмененныеГруппы);
			
			Если СтарыйРодитель <> Родитель Тогда
				
				Если ЗначениеЗаполнено(Родитель) Тогда
					ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
						Родитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтарыйРодитель) Тогда
					ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
						СтарыйРодитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
			Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;
	
	Если ИзменилсяСоставРолейГруппыВнешнихПользователей Тогда
		ПользователиСлужебный.ОбновитьРолиВнешнихПользователей(Ссылка);
	КонецЕсли;
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппВнешнихПользователей(
		УчастникиИзменений, ИзмененныеГруппы);
	
	ИнтеграцияСтандартныхПодсистем.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНазначениеВсемиТипамиВнешнихПользователей()
	
	Назначение.Очистить();
	
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВнешнийПользователь.Тип.Типы() Цикл
		
		ОписаниеТипаСсылки = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип));
		Значение = ОписаниеТипаСсылки.ПривестиЗначение(Неопределено);
		
		НоваяСтрока = Назначение.Добавить();
		НоваяСтрока.ТипПользователей = Значение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли