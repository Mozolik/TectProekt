﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СсылкаНаОбъект = Параметры.СсылкаНаОбъект;
	ТекущиеПараметры = УправлениеДоступомСлужебныйПовтИсп.Параметры();
	ВозможныеПрава = ТекущиеПараметры.ВозможныеПраваДляНастройкиПравОбъектов;
	
	Если ВозможныеПрава.ПоТипамСсылок[ТипЗнч(СсылкаНаОбъект)] = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Права доступа не настраиваются
                       |для объектов типа ""%1"".'
                       |;uk='Права доступу не настроюються
                       |для об''єктів типу ""%1"".'"),
			Строка(ТипЗнч(СсылкаНаОбъект)));
	КонецЕсли;
	
	// Проверка разрешения на открытие формы.
	ПроверитьРазрешениеНаУправлениеПравами();
	
	ИспользоватьВнешнихПользователей =
		ВнешниеПользователи.ИспользоватьВнешнихПользователей()
		И ПравоДоступа("Просмотр", Метаданные.Справочники.ВнешниеПользователи);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокТиповПользователей.Добавить(Тип("СправочникСсылка.Пользователи"),
		Метаданные.Справочники.Пользователи.Синоним);
	
	СписокТиповПользователей.Добавить(Тип("СправочникСсылка.ВнешниеПользователи"),
		Метаданные.Справочники.ВнешниеПользователи.Синоним);
	
	РодительЗаполнен =
		Параметры.СсылкаНаОбъект.Метаданные().Иерархический
		И ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.СсылкаНаОбъект, "Родитель"));
	
	Элементы.НаследоватьПраваРодителей.Видимость = РодительЗаполнен;
	
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	ЗаполнитьПрава();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаследоватьПраваРодителейПриИзменении(Элемент)
	
	НаследоватьПраваРодителейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НаследоватьПраваРодителейПриИзмененииНаСервере()
	
	Если НаследоватьПраваРодителей Тогда
		ДобавитьНаследуемыеПрава();
		ЗаполнитьНомераКартинокПользователей();
	Иначе
		// Очистка настроек, наследуемых от родителей по иерархии.
		Индекс = ГруппыПрав.Количество()-1;
		Пока Индекс >= 0 Цикл
			Если ГруппыПрав.Получить(Индекс).НастройкаРодителя Тогда
				ГруппыПрав.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыПрав

&НаКлиенте
Процедура ГруппыПравПриИзменении(Элемент)
	
	ГруппыПрав.Сортировать("НастройкаРодителя Убыв");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ГруппыПравПользователь" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
	Если НЕ Отказ Тогда
		ТекущееПраво  = Сред(Поле.Имя, СтрДлина("ГруппыПрав") + 1);
		ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
		
		Если ТекущееПраво = "НаследованиеРазрешено" Тогда
			ТекущиеДанные[ТекущееПраво] = НЕ ТекущиеДанные[ТекущееПраво];
			Модифицированность = Истина;
			
		ИначеЕсли ВозможныеПрава.Свойство(ТекущееПраво) Тогда
			СтароеЗначение = ТекущиеДанные[ТекущееПраво];
			
			Если ТекущиеДанные[ТекущееПраво] = Истина Тогда
				ТекущиеДанные[ТекущееПраво] = Ложь;
				
			ИначеЕсли ТекущиеДанные[ТекущееПраво] = Ложь Тогда
				ТекущиеДанные[ТекущееПраво] = Неопределено;
			Иначе
				ТекущиеДанные[ТекущееПраво] = Истина;
			КонецЕсли;
			Модифицированность = Истина;
			
			ОбновитьЗависимыеПрава(ТекущиеДанные, ТекущееПраво, СтароеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
	
	ДоступностьКоманд = ?(ТекущиеДанные = Неопределено, Ложь, НЕ ТекущиеДанные.НастройкаРодителя);
	Элементы.ГруппыПравКонтекстноеМенюУдалить.Доступность = ДоступностьКоманд;
	Элементы.ФормаУдалить.Доступность                     = ДоступностьКоманд;
	Элементы.ФормаПереместитьВверх.Доступность            = ДоступностьКоманд;
	Элементы.ФормаПереместитьВниз.Доступность             = ДоступностьКоманд;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриАктивизацииПоля(Элемент)
	
	ДоступностьКоманд = ВозможныеПрава.Свойство(Сред(Элемент.ТекущийЭлемент.Имя, СтрДлина("ГруппыПрав") + 1));
	Элементы.ГруппыПравКонтекстноеМенюСнятьУстановкуПрава.Доступность       = ДоступностьКоманд;
	Элементы.ГруппыПравКонтекстноеМенюУстановитьРазрешениеПрава.Доступность = ДоступностьКоманд;
	Элементы.ГруппыПравКонтекстноеМенюУстановитьЗапретПрава.Доступность     = ДоступностьКоманд;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПередНачаломИзменения(Элемент, Отказ)
	
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПередУдалением(Элемент, Отказ)
	
	ПроверкаВозможностиИзмененияПрав(Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		// Установка начальных значений.
		Элементы.ГруппыПрав.ТекущиеДанные.ВладелецНастройки     = Параметры.СсылкаНаОбъект;
		Элементы.ГруппыПрав.ТекущиеДанные.НаследованиеРазрешено = Истина;
		Элементы.ГруппыПрав.ТекущиеДанные.НастройкаРодителя     = Ложь;
		
		Для каждого ДобавленныйРеквизит Из ДобавленныеРеквизиты Цикл
			Элементы.ГруппыПрав.ТекущиеДанные[ДобавленныйРеквизит.Ключ] = ДобавленныйРеквизит.Значение;
		КонецЦикла;
	КонецЕсли;
	
	Если Элементы.ГруппыПрав.ТекущиеДанные.Пользователь = Неопределено Тогда
		Элементы.ГруппыПрав.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.ГруппыПрав.ТекущиеДанные.Пользователь) Тогда
		ЗаполнитьНомераКартинокПользователей(Элементы.ГруппыПрав.ТекущаяСтрока);
	Иначе
		Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Элементы.ГруппыПрав.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНачало(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	
	Если НЕ Модифицированность Тогда
		ПрочитатьПрава();
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПеречитатьЗавершение", ЭтотОбъект),
			НСтр("ru='Данные изменены. Прочитать без сохранения?';uk='Дані змінені. Прочитати без збереження?'"),
			РежимДиалогаВопрос.ДаНет,
			5,
			КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьУстановкуПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗапретПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешениеПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеТекущегоПрава(НовоеЗначение)
	
	Отказ = Ложь;
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
	Если Не Отказ Тогда
		ТекущееПраво  = Сред(Элементы.ГруппыПрав.ТекущийЭлемент.Имя, СтрДлина("ГруппыПрав") + 1);
		ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
		
		Если ВозможныеПрава.Свойство(ТекущееПраво)
		   И ТекущиеДанные <> Неопределено Тогда
			
			СтароеЗначение = ТекущиеДанные[ТекущееПраво];
			ТекущиеДанные[ТекущееПраво] = НовоеЗначение;
			
			Модифицированность = Истина;
			
			ОбновитьЗависимыеПрава(ТекущиеДанные, ТекущееПраво, СтароеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПрав.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПрав.НастройкаРодителя");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат = Неопределено, Неопределен = Неопределено) Экспорт
	
	ЗаписатьНачало(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНачало(Закрыть = Ложь)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПодтвердитьОтказОтУправленияПравами = Неопределено;
	ЗаписатьПрава(ПодтвердитьОтказОтУправленияПравами);
	
	Если ПодтвердитьОтказОтУправленияПравами = Истина Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ЗаписатьИЗакрыть", НСтр("ru='Записать и закрыть';uk='Записати і закрити'"));
		Кнопки.Добавить("Отмена", НСтр("ru='Отмена';uk='Відмінити'"));
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ЗаписатьПослеПодтверждения", ЭтотОбъект),
			НСтр("ru='После записи настройка прав станет недоступной.';uk='Після запису настройка прав стане недоступною.'"),
			Кнопки,, "Отмена");
	Иначе
		Если Закрыть Тогда
			Закрыть();
		Иначе
			ОчиститьСообщения();
		КонецЕсли;
		ЗаписатьЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьПослеПодтверждения(Ответ, Неопределен) Экспорт
	
	Если Ответ = "ЗаписатьИЗакрыть" Тогда
		ПодтвердитьОтказОтУправленияПравами = Ложь;
		ЗаписатьПрава(ПодтвердитьОтказОтУправленияПравами);
		Закрыть();
	КонецЕсли;
	
	ЗаписатьЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗавершение()
	
	Оповестить("Запись_НастройкиПравОбъектов", , Параметры.СсылкаНаОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьЗавершение(Ответ, Неопределен) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПрочитатьПрава();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

&НаКлиенте
Процедура ОбновитьЗависимыеПрава(Знач Данные, Знач Право, Знач СтароеЗначение, Знач ГлубинаРекурсии = 0)
	
	Если Данные[Право] = СтароеЗначение Тогда
		Возврат;
	КонецЕсли;
	
	Если ГлубинаРекурсии > 100 Тогда
		Возврат;
	Иначе
		ГлубинаРекурсии = ГлубинаРекурсии + 1;
	КонецЕсли;
	
	ЗависимыеПрава = Неопределено;
	
	Если Данные[Право] = Истина Тогда
		
		// Увеличены разрешения (с Неопределено или Ложь на Истина).
		// Требуется повысить разрешения на ведущие права.
		ПрямыеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
		ЗначениеЗависимогоПрава = Истина;
		
	ИначеЕсли Данные[Право] = Ложь Тогда
		
		// Увеличены запрещения (с Истина или Неопределено на Ложь).
		// Требуется повысить запрещения на зависимые права.
		ОбратныеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
		ЗначениеЗависимогоПрава = Ложь;
	Иначе
		Если СтароеЗначение = Ложь Тогда
			// Уменьшены запрещения (с Ложь на Неопределено).
			// Требуется уменьшить запрещения на ведущие права.
			ПрямыеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
			ЗначениеЗависимогоПрава = Неопределено;
		Иначе
			// Уменьшены разрешения (с Истина на Неопределено).
			// Требуется уменьшить разрешения на зависимые права.
			ОбратныеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
			ЗначениеЗависимогоПрава = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗависимыеПрава <> Неопределено Тогда
		Для каждого ЗависимоеПраво Из ЗависимыеПрава Цикл
			Если ТипЗнч(ЗависимоеПраво) = Тип("Массив") Тогда
				УстановитьЗависимоеПраво = Истина;
				Для каждого ОдноИзЗависимыхПрав Из ЗависимоеПраво Цикл
					Если Данные[ОдноИзЗависимыхПрав] = ЗначениеЗависимогоПрава Тогда
						УстановитьЗависимоеПраво = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если УстановитьЗависимоеПраво Тогда
					Если НЕ (ЗначениеЗависимогоПрава = Неопределено И Данные[ЗависимоеПраво[0]] <> СтароеЗначение) Тогда
						ТекущееСтароеЗначение = Данные[ЗависимоеПраво[0]];
						Данные[ЗависимоеПраво[0]] = ЗначениеЗависимогоПрава;
						ОбновитьЗависимыеПрава(Данные, ЗависимоеПраво[0], ТекущееСтароеЗначение);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если НЕ (ЗначениеЗависимогоПрава = Неопределено И Данные[ЗависимоеПраво] <> СтароеЗначение) Тогда
					ТекущееСтароеЗначение = Данные[ЗависимоеПраво];
					Данные[ЗависимоеПраво] = ЗначениеЗависимогоПрава;
					ОбновитьЗависимыеПрава(Данные, ЗависимоеПраво, ТекущееСтароеЗначение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизит(НовыеРеквизиты, Реквизит, НачальноеЗначение)
	
	НовыеРеквизиты.Добавить(Реквизит);
	ДобавленныеРеквизиты.Вставить(Реквизит.Имя, НачальноеЗначение);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЭлемент(Имя, Тип, Родитель)
	
	Элемент = Элементы.Добавить(Имя, Тип, Родитель);
	Элемент.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизитыИлиЭлементыФормы(НовыеРеквизиты = Неопределено)
	
	ТекущиеПараметры = УправлениеДоступомСлужебныйПовтИсп.Параметры();
	ПоТипамСсылок = ТекущиеПараметры.ВозможныеПраваДляНастройкиПравОбъектов.ПоТипамСсылок;
	ОписанияВозможныхПрав = ПоТипамСсылок.Получить(ТипЗнч(Параметры.СсылкаНаОбъект));
	
	ОписаниеТиповПсевдоФлажка = Новый ОписаниеТипов("Булево, Число",
		Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный));
	
	// Добавление возможных прав, настраиваемых по владельцу (таблице значений доступа).
	Для каждого ОписаниеПрава Из ОписанияВозможныхПрав Цикл
		
		Если НовыеРеквизиты <> Неопределено Тогда
			
			ДобавитьРеквизит(НовыеРеквизиты, Новый РеквизитФормы(ОписаниеПрава.Имя, ОписаниеТиповПсевдоФлажка,
				"ГруппыПрав", ОписаниеПрава.Заголовок), ОписаниеПрава.НачальноеЗначение);
			
			ВозможныеПрава.Вставить(ОписаниеПрава.Имя);
			
			// Добавление прямых и обратных зависимостей прав.
			ПрямыеЗависимостиПрав.Вставить(ОписаниеПрава.Имя, ОписаниеПрава.ТребуемыеПрава);
			Для каждого ЗависимоеПраво Из ОписаниеПрава.ТребуемыеПрава Цикл
				Если ТипЗнч(ЗависимоеПраво) = Тип("Массив") Тогда
					ЗависимыеПрава = ЗависимоеПраво;
				Иначе
					ЗависимыеПрава = Новый Массив;
					ЗависимыеПрава.Добавить(ЗависимоеПраво);
				КонецЕсли;
				Для каждого ЗависимоеПраво Из ЗависимыеПрава Цикл
					Если ОбратныеЗависимостиПрав.Свойство(ЗависимоеПраво) Тогда
						ЗависимыеПрава = ОбратныеЗависимостиПрав[ЗависимоеПраво];
					Иначе
						ЗависимыеПрава = Новый Массив;
						ОбратныеЗависимостиПрав.Вставить(ЗависимоеПраво, ЗависимыеПрава);
					КонецЕсли;
					Если ЗависимыеПрава.Найти(ОписаниеПрава.Имя) = Неопределено Тогда
						ЗависимыеПрава.Добавить(ОписаниеПрава.Имя);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		Иначе
			Элемент = ДобавитьЭлемент("ГруппыПрав" + ОписаниеПрава.Имя, Тип("ПолеФормы"), Элементы.ГруппыПрав);
			Элемент.ТолькоПросмотр                = Истина;
			Элемент.Формат                        = "ЧЦ=1; ЧН=; БЛ=Нет; БИ=Да";
			Элемент.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
			Элемент.ГоризонтальноеПоложение       = ГоризонтальноеПоложениеЭлемента.Центр;
			Элемент.ПутьКДанным                   = "ГруппыПрав." + ОписаниеПрава.Имя;
			
			Элемент.Подсказка = ОписаниеПрава.Подсказка;
			// Расчет оптимальной ширины элемента.
			ШиринаЭлемента = 0;
			Для НомерСтроки = 1 По СтрЧислоСтрок(ОписаниеПрава.Заголовок) Цикл
				ШиринаЭлемента = Макс(ШиринаЭлемента, СтрДлина(СтрПолучитьСтроку(ОписаниеПрава.Заголовок, НомерСтроки)));
			КонецЦикла;
			Если СтрЧислоСтрок(ОписаниеПрава.Заголовок) = 1 Тогда
				ШиринаЭлемента = ШиринаЭлемента + 1;
			КонецЕсли;
			Элемент.Ширина = ШиринаЭлемента;
		КонецЕсли;
		
		Если Элементы.ГруппыПрав.ВысотаШапки < СтрЧислоСтрок(ОписаниеПрава.Заголовок) Тогда
			Элементы.ГруппыПрав.ВысотаШапки = СтрЧислоСтрок(ОписаниеПрава.Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	Если НовыеРеквизиты = Неопределено И Параметры.СсылкаНаОбъект.Метаданные().Иерархический Тогда
		Элемент = ДобавитьЭлемент("ГруппыПравНаследованиеРазрешено", Тип("ПолеФормы"), Элементы.ГруппыПрав);
		Элемент.ТолькоПросмотр                = Истина;
		Элемент.Формат                        = "ЧЦ=1; ЧН=; БЛ=Нет; БИ=Да";
		Элемент.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
		Элемент.ГоризонтальноеПоложение       = ГоризонтальноеПоложениеЭлемента.Центр;
		Элемент.ПутьКДанным                   = "ГруппыПрав.НаследованиеРазрешено";
		
		Элемент.Заголовок = НСтр("ru='Для
                                       |подпапок'
                                       |;uk='Для
                                       |підпапок'");
		Элемент.Подсказка = НСтр("ru='Права не только для текущей папки,
                                       |но и для ее нижестоящих папок'
                                       |;uk='Права не тільки для поточної папки,
                                       |але і для її нижчестоящих папок'");
		
		Элемент = ДобавитьЭлемент("ГруппыПравВладелецНастройки", Тип("ПолеФормы"), Элементы.ГруппыПрав);
		Элемент.ТолькоПросмотр = Истина;
		Элемент.ПутьКДанным    = "ГруппыПрав.ВладелецНастройки";
		Элемент.Заголовок = НСтр("ru='Наследуется от';uk='Успадковується від'");
		Элемент.Подсказка = НСтр("ru='Папка, от которой наследуются настройка прав';uk='Папка, від якої успадковуються настройки прав'");
		Элемент.Видимость = РодительЗаполнен;
		
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		ЭлементУсловногоОформления.Использование = Истина;
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Text", "");
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(
			Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ГруппыПрав.НастройкаРодителя");
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ложь;
		
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ГруппыПравВладелецНастройки");
		
		Если Элементы.ГруппыПрав.ВысотаШапки = 1 Тогда
			Элементы.ГруппыПрав.ВысотаШапки = 2;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрава()
	
	ПрямыеЗависимостиПрав   = Новый Структура;
	ОбратныеЗависимостиПрав = Новый Структура;
	ВозможныеПрава          = Новый Структура;
	
	ДобавленныеРеквизиты = Новый Структура;
	НовыеРеквизиты = Новый Массив;
	ДобавитьРеквизитыИлиЭлементыФормы(НовыеРеквизиты);
	
	// Добавление реквизитов формы.
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	// Добавление элементов формы
	ДобавитьРеквизитыИлиЭлементыФормы();
	
	ПрочитатьПрава();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПрава()
	
	ГруппыПрав.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	НаследоватьПраваРодителей = НастройкиПрав.Наследовать;
	
	Для каждого Настройка Из НастройкиПрав.Настройки Цикл
		Если НаследоватьПраваРодителей ИЛИ НЕ Настройка.НастройкаРодителя Тогда
			ЗаполнитьЗначенияСвойств(ГруппыПрав.Добавить(), Настройка);
		КонецЕсли;
	КонецЦикла;
	ЗаполнитьНомераКартинокПользователей();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаследуемыеПрава()
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	Индекс = 0;
	Для каждого Настройка Из НастройкиПрав.Настройки Цикл
		Если Настройка.НастройкаРодителя Тогда
			ЗаполнитьЗначенияСвойств(ГруппыПрав.Вставить(Индекс), Настройка);
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьНомераКартинокПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполнения(Отказ)
	
	ОчиститьСообщения();
	
	НомерСтроки = ГруппыПрав.Количество()-1;
	
	Пока НЕ Отказ И НомерСтроки >= 0 Цикл
		ТекущаяСтрока = ГруппыПрав.Получить(НомерСтроки);
		
		// Проверка заполнения флажков прав.
		НетЗаполненногоПрава = Истина;
		ИмяПервогоПрава = "";
		Для каждого ВозможноеПраво Из ВозможныеПрава Цикл
			Если НЕ ЗначениеЗаполнено(ИмяПервогоПрава) Тогда
				ИмяПервогоПрава = ВозможноеПраво.Ключ;
			КонецЕсли;
			Если ТипЗнч(ТекущаяСтрока[ВозможноеПраво.Ключ]) = Тип("Булево") Тогда
				НетЗаполненногоПрава = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НетЗаполненногоПрава Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнено ни одно право доступа.';uk='Не заповнене жодне право доступу.'"),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "]." + ИмяПервогоПрава,
				,
				Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка заполнения пользователей/групп пользователей,
		// значений доступа и их дублей.
		
		// Проверка заполнения
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока["Пользователь"]) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнен пользователь или группа.';uk='Не заповнений користувач або група.'"),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "].Пользователь",
				,
				Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка дублей.
		Отбор = Новый Структура;
		Отбор.Вставить("ВладелецНастройки", ТекущаяСтрока["ВладелецНастройки"]);
		Отбор.Вставить("Пользователь",      ТекущаяСтрока["Пользователь"]);
		
		Если ГруппыПрав.НайтиСтроки(Отбор).Количество() > 1 Тогда
			Если ТипЗнч(Отбор.Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
				ТекстСообщения = НСтр("ru='Настройка для пользователя ""%1"" уже есть.';uk='Настройка для користувача ""%1"" вже є.'");
			Иначе
				ТекстСообщения = НСтр("ru='Настройка для группы пользователей ""%1"" уже есть.';uk='Настройка для групи користувачів ""%1"" вже є.'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Отбор.Пользователь),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "].Пользователь",
				,
				Отказ);
			Возврат;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПрава(ПодтвердитьОтказОтУправленияПравами)
	
	ПроверитьРазрешениеНаУправлениеПравами();
	
	НачатьТранзакцию();
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСведений.НастройкиПравОбъектов.Записать(Параметры.СсылкаНаОбъект, ГруппыПрав, НаследоватьПраваРодителей);
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ПодтвердитьОтказОтУправленияПравами = Ложь
		 ИЛИ УправлениеДоступом.ЕстьПраво("УправлениеПравами", Параметры.СсылкаНаОбъект) Тогда
			
			ЗафиксироватьТранзакцию();
			Модифицированность = Ложь;
		Иначе
			ОтменитьТранзакцию();
			ПодтвердитьОтказОтУправленияПравами = Истина;
		КонецЕсли;
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаВозможностиИзмененияПрав(Отказ, ПроверкаУдаления = Ложь)
	
	ТекущийВладелецНастройки = Элементы.ГруппыПрав.ТекущиеДанные["ВладелецНастройки"];
	
	Если ЗначениеЗаполнено(ТекущийВладелецНастройки)
	   И ТекущийВладелецНастройки <> Параметры.СсылкаНаОбъект Тогда
		
		Отказ = Истина;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Эти права унаследованы, их можно изменить в форме настройки прав
                       |вышестоящей папки ""%1"".'
                       |;uk='Ці права успадковані, їх можна змінити у формі настройки прав
                       |вищестоящої папки ""%1"".'"),
			ТекущийВладелецНастройки);
		
		Если ПроверкаУдаления Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Для удаления всех унаследованных прав следует
                           |снять флажок ""%1"".'
                           |;uk='Для вилучення всіх успадкованих прав слід
                           |зняти прапорець ""%1"".'"),
				Элементы.НаследоватьПраваРодителей.Заголовок);
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораПользователя(Текст)
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(Текст);
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВыборТипаПользователиИлиВнешниеПользователи(ОбработкаПродолжения)
	
	ВыборИПодборВнешнихПользователей = Ложь;
	
	Если ИспользоватьВнешнихПользователей Тогда
		
		СписокТиповПользователей.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения(
				"ПоказатьВыборТипаПользователиИлиВнешниеПользователиЗавершение",
				ЭтотОбъект,
				ОбработкаПродолжения),
			НСтр("ru='Выбор типа данных';uk='Вибір типу даних'"),
			СписокТиповПользователей[0]);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ВыборИПодборВнешнихПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборТипаПользователиИлиВнешниеПользователиЗавершение(ВыбранныйЭлемент, ОбработкаПродолжения) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ВыборИПодборВнешнихПользователей =
			ВыбранныйЭлемент.Значение = Тип("СправочникСсылка.ВнешниеПользователи");
		
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ВыборИПодборВнешнихПользователей);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователей()
	
	ТекущийПользователь = ?(Элементы.ГруппыПрав.ТекущиеДанные = Неопределено,
		Неопределено, Элементы.ГруппыПрав.ТекущиеДанные.Пользователь);
	
	Если ЗначениеЗаполнено(ТекущийПользователь)
	   И (    ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.Пользователи")
	      ИЛИ ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ГруппыПользователей") ) Тогда
		
		ВыборИПодборВнешнихПользователей = Ложь;
		
	ИначеЕсли ИспользоватьВнешнихПользователей
	        И ЗначениеЗаполнено(ТекущийПользователь)
	        И (    ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ВнешниеПользователи")
	           ИЛИ ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") ) Тогда
	
		ВыборИПодборВнешнихПользователей = Истина;
	Иначе
		ПоказатьВыборТипаПользователиИлиВнешниеПользователи(
			Новый ОписаниеОповещения("ВыбратьПользователейЗавершение", ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	ВыбратьПользователейЗавершение(ВыборИПодборВнешнихПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователейЗавершение(ВыборИПодборВнешнихПользователей, Неопределен = Неопределено) Экспорт
	
	Если ВыборИПодборВнешнихПользователей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(
		Элементы.ГруппыПрав.ТекущиеДанные = Неопределено,
		Неопределено,
		Элементы.ГруппыПрав.ТекущиеДанные.Пользователь));
	
	Если ВыборИПодборВнешнихПользователей Тогда
		ПараметрыФормы.Вставить("ВыборГруппВнешнихПользователей", Истина);
	Иначе
		ПараметрыФормы.Вставить("ВыборГруппПользователей", Истина);
	КонецЕсли;
	
	Если ВыборИПодборВнешнихПользователей Тогда
		
		ОткрытьФорму(
			"Справочник.ВнешниеПользователи.ФормаВыбора",
			ПараметрыФормы,
			Элементы.ГруппыПравПользователь);
	Иначе
		ОткрытьФорму(
			"Справочник.Пользователи.ФормаВыбора",
			ПараметрыФормы,
			Элементы.ГруппыПравПользователь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНомераКартинокПользователей(ИдентификаторСтроки = Неопределено)
	
	Пользователи.ЗаполнитьНомераКартинокПользователей(ГруппыПрав, "Пользователь", "НомерКартинки", ИдентификаторСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьРазрешениеНаУправлениеПравами()
	
	Если УправлениеДоступом.ЕстьПраво("УправлениеПравами", Параметры.СсылкаНаОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru='Настройка прав недоступна.';uk='Настройка прав недоступна.'");
	
КонецПроцедуры

#КонецОбласти
