﻿
Процедура НачалоВыбораЗначенияСубконто(Форма, Элемент, СтандартнаяОбработка, СписокПараметров) Экспорт

	СтандартнаяОбработка = Истина;

КонецПроцедуры


Процедура ПоказатьПредупреждениеОбИзменениях(КлючНастроек, ВладелецФормы = Неопределено, 
			НастройкаПредупреждений = Неопределено) Экспорт

	// В БРУ и УП2 предупреждения не применяются, оставлено для совместимости с БП.	
	
КонецПроцедуры

// Функция возвращает Истина, если при изменении даты документа требуется перечитать 
// настройки из базы данных на сервере.
//
Функция ТребуетсяВызовСервераПриИзмененииДатыДокумента(НоваяДата, ПредыдущаяДата,
			ВалютаДокумента = Неопределено, ВалютаРегламентированногоУчета = Неопределено) Экспорт

	Результат = Ложь;
	
	Если НачалоДня(НоваяДата) = НачалоДня(ПредыдущаяДата) Тогда
		// Ничего не изменилось либо изменилось только время, от которого ничего не зависит
		Возврат Ложь;
	КонецЕсли;
	
	Если НачалоМесяца(НоваяДата) <> НачалоМесяца(ПредыдущаяДата) Тогда
		// Учетная политика задается с периодичностью до месяца,
		// поэтому в пределах месяца изменения даты не учитываем.
		Результат = Истина;
	КонецЕсли;
	
	Если НЕ Результат
		И ЗначениеЗаполнено(ВалютаДокумента) 
		И ЗначениеЗаполнено(ВалютаРегламентированногоУчета) Тогда
		
		Если ВалютаРегламентированногоУчета <> ВалютаДокумента Тогда
			// Для валютных документов необходимо получение курсов валют на новую дату
			Результат = Истина;
		КонецЕсли;

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА УСТАНОВКИ ОСНОВНОЙ ОРГАНИЗАЦИИ
//

// Изменяет значение отбора в динамическом списке.
// Поиск производится по представлению в элементах отборов верхнего уровня.
//
// Надо анализировать возвращаемое значение - и если вернется
//  Неопределено (т.е. отбор не установлен по причине того, что в списке
//  нет отбора по основной организации (он исправлен вручную и т.п.)), то не надо
//  присваивать Неопределено специальному полю "ОтборПоОрганизации" в форме списка.
//
// Параметры
//  Список         - ДинамическийСписок - список, в котором необходимо изменить значение отбора.
//  ИмяРеквизита   - Строка - имя поля-организации в динамическом списке.
//  ЗначениеОтбора - СправочникСсылка.Организации, СписокЗначений, Массив - значение отбора.
//                   Если значение не задано, то будет подставлена основная организация из
//                   настроек пользователя.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации - Если отбор установлен, то вернет значение отбора.
//
Функция ИзменитьОтборПоОсновнойОрганизации(Список, ИмяРеквизита = "Организация", Знач ЗначениеОтбора = Неопределено) Экспорт

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, ИмяРеквизита);
	
	Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Если ТипЗнч(ЗначениеОтбора) <> Тип("СправочникСсылка.Организации")
			И ТипЗнч(ЗначениеОтбора) <> Тип("Массив")
			И ТипЗнч(ЗначениеОтбора) <> Тип("СписокЗначений") Тогда
			ЗначениеОтбора = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеОтбора) = Тип("Массив")
		ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
	Иначе
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ИспользованиеОтбора = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, ИмяРеквизита, ЗначениеОтбора, ВидСравненияОтбора, , ИспользованиеОтбора, 
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
	Возврат ЗначениеОтбора;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Проверка наличия организаций

Функция ПроверитьНаличиеОрганизаций() Экспорт
	
	// Используется для совместимости с БП 3.0.
	РеквизитыОрганизацииЗаполнены = Истина;
	
	Возврат РеквизитыОрганизацииЗаполнены;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

Процедура ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Если Не ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Организация                       = Неопределено;
		ВключатьОбособленныеПодразделения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций,
	Организация, ВключатьОбособленныеПодразделения) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
			ВключатьОбособленныеПодразделения = Значение.ВключатьОбособленныеПодразделения;
		Иначе
			Организация = Неопределено;
			ВключатьОбособленныеПодразделения = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда				
				ПоказатьЗначение(, Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры для команд печати
Функция ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды) Экспорт 
	
	Если Тип(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 1 Тогда 
		Возврат Новый Структура("ЗаголовокФормы", ПараметрКоманды[0]);
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции
