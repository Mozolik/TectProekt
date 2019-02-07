﻿#Если Не ТолстыйКлиентУправляемоеПриложение Или Сервер Тогда

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудники.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	КадровыйУчетРасширенный.СформироватьДвиженияПоТерриториям(Движения, ДанныеДляПроведения.ТерриторияТруда, Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории", Новый Структура("Организация", Организация)) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В организации ""%1"" не используются обособленные территории';uk='В організації ""%1"" не використовуються відокремлені території'"),
				Организация),
			Ссылка,
			"Организация",
			"Объект",
			Отказ);
		
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
		
	КонецЕсли; 
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения", "НачалоПериода");
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.НачалоПериода КАК Период,
		|	ПеремещениеМеждуТерриториямиСотрудники.Сотрудник,
		|	ПеремещениеМеждуТерриториямиСотрудники.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПеремещениеМеждуТерриториямиСотрудники.ФизическоеЛицо,
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.Территория КАК Территория,
		|	ВЫБОР
		|		КОГДА ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода, ДЕНЬ, 1)
		|		ИНАЧЕ ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.ПеремещениеМеждуТерриториями.Сотрудники КАК ПеремещениеМеждуТерриториямиСотрудники
		|ГДЕ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка = &Ссылка";
		
	Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДействуетДо", "ПустойПериодОкончания");
	КонецЕсли;
		
	Данные = Новый Структура("ТерриторияТруда", Запрос.Выполнить().Выгрузить());
	
	Возврат Данные;
	
КонецФункции

#КонецОбласти

#КонецЕсли
