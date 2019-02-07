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
	СоставНабораКонстантФормы        = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты     = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы                      = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ИспользоватьСоглашенияСКлиентами = НаборКонстант.ИспользоватьСоглашенияСКлиентами;
	РежимИсполненияЗаказов = Число(НаборКонстант.ИспользоватьРасширенныеВозможностиЗаказаКлиента)
	                       + Число(НаборКонстант.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента);
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьВерсионированиеОбъектов");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПодключаемоеОборудование(Команда)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПравилаОбменаСПодключаемымОборудованием(Команда)
	ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныМагнитныхКарт(Команда)
	ОткрытьФорму("Справочник.ШаблоныМагнитныхКарт.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиРМК(Команда)
	ОткрытьФорму("Справочник.НастройкиРМК.ФормаСписка",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущиеНастройкиРМК(Команда)
	
	ТекущиеНастройкиРМК = ТекущиеНастройкиРМК();
	Если ЗначениеЗаполнено(ТекущиеНастройкиРМК) Тогда
		ПоказатьЗначение(Неопределено, ТекущиеНастройкиРМК);
	Иначе
		ОткрытьФорму("Справочник.НастройкиРМК.ФормаОбъекта",,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиСоглашений(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеИспользованияСоглашений", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ПараметрыФормы = Новый Структура("ИспользованиеСоглашений", НаборКонстант.ИспользованиеСоглашенийСКлиентами);
	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиИспользованияСоглашений", ПараметрыФормы, ЭтаФорма, , , ,ОписаниеОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиЗаказовКлиентов(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеИспользованияЗаказов", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ПараметрыФормы = Новый Структура("РежимИсполненияЗаказов", РежимИсполненияЗаказов);
	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиИспользованияЗаказов", ПараметрыФормы, ЭтаФорма, , , ,ОписаниеОповещения, Режим);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьПодключаемоеОборудованиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменСПодключаемымОборудованиемOfflineПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Оповестить("ИзмененыДоступныеТипыПодключаемогоОборудования", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаказыКлиентовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКомиссиюПриПродажахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаВозвратТоваровОтКлиентовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРучныеСкидкиВПродажахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическиеСкидкиВПродажахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКартыЛояльностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоговорыСКлиентамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРозничныеПродажиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	СоздатьЭлементыСправочниковДляИспользованияРозничныхПродаж();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриЗакрытииКассовойСменыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриЗакрытииКассовойСменыОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейХраненияОтложенныхЧековПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоВидовЦенПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦен(Команда)
	
	ОткрытьФорму("Справочник.ВидыЦен.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦенПрайсЛист(Команда)
	
	ПоказатьЗначение(,ВидЦеныПрайсЛист());
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСоглашенияСКлиентамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
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
Процедура ИзменениеИспользованияЗаказов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимИсполненияЗаказов = Результат;
	
	СохранитьЗначениеРеквизита("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	#Если НЕ ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
	ОбновитьИнтерфейс = Истина;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеИспользованияСоглашений(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборКонстант.ИспользованиеСоглашенийСКлиентами = Результат;
	СохранитьЗначениеРеквизита("ИспользованиеСоглашенийСКлиентами");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	#Если НЕ ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
	ОбновитьИнтерфейс = Истина;
	#КонецЕсли
	
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

#КонецОбласти

#Область Сервер

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПодключаемоеОборудование" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьПодключаемоеОборудование;
		
		Элементы.ИспользоватьОбменСПодключаемымОборудованиемOffline.Доступность = ЗначениеКонстанты И Константы.ИспользоватьРозничныеПродажи.Получить();
		Элементы.ОткрытьПодключаемоеОборудование.Доступность 					= ЗначениеКонстанты;
		Элементы.ОткрытьШаблоныМагнитныхКарт.Доступность 						= ЗначениеКонстанты;
		Элементы.ОткрытьПравилаОбменаСПодключаемымОборудованием.Доступность 	= НаборКонстант.ИспользоватьОбменСПодключаемымОборудованиемOffline;
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменСПодключаемымОборудованиемOffline" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьПравилаОбменаСПодключаемымОборудованием.Доступность = НаборКонстант.ИспользоватьОбменСПодключаемымОборудованиемOffline;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДоговорыСКлиентами" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьДоговорыСКлиентами;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(Элементы.ИспользоватьДоговорыСКлиентами, ЗначениеКонстанты);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ИспользоватьСоглашенияСКлиентами" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСоглашенияСКлиентами;
		
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("ОткрытьНастройкиСоглашений");
		МассивЭлементов.Добавить("ИспользоватьКомиссиюПриПродажах");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(Элементы.ИспользоватьСоглашенияСКлиентами, ЗначениеКонстанты);
		
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыКлиентов" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыКлиентов;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, "ОткрытьНастройкиЗаказовКлиентов", "Доступность", ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьАвтоматическиеСкидкиВПродажах" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьАвтоматическиеСкидкиВПродажах;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, "ИспользоватьКартыЛояльности", "Доступность", ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоВидовЦен" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоВидовЦен;
		
		Элементы.ОткрытьВидыЦен.Видимость   	  = ЗначениеКонстанты;
		Элементы.ОткрытьВидЦенПрайсЛист.Видимость = Не ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьРозничныеПродажи" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьРозничныеПродажи;
		
		Элементы.ОперацияПриЗакрытииКассовойСмены.Доступность      = ЗначениеКонстанты;
		Элементы.КоличествоДнейХраненияОтложенныхЧеков.Доступность = ЗначениеКонстанты;
		Элементы.КоличествоДнейХраненияЗаархивированныхЧеков.Доступность = ЗначениеКонстанты 
			и НаборКонстант.ОперацияПриЗакрытииКассовойСмены = Перечисления.ОперацииПриЗакрытииКассовойСмены.АрхивацияЧековККМ;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ОперацияПриЗакрытииКассовойСмены" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ОперацияПриЗакрытииКассовойСмены;
		ИспользоватьРозничныеПродажи = НаборКонстант.ИспользоватьРозничныеПродажи;
		Элементы.КоличествоДнейХраненияЗаархивированныхЧеков.Доступность = ЗначениеКонстанты = Перечисления.ОперацииПриЗакрытииКассовойСмены.АрхивацияЧековККМ И ИспользоватьРозничныеПродажи;
	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ВключитьВерсионированиеУстановкиЦенНоменклатуры" Тогда
			НаборКонстант.ИспользоватьВерсионированиеОбъектов = Истина;
			КонстантаИмя = "ИспользоватьВерсионированиеОбъектов";
		ИначеЕсли РеквизитПутьКДанным = "ИспользоватьСоглашенияСКлиентами" Тогда
			НаборКонстант.ИспользованиеСоглашенийСКлиентами = ?(ИспользоватьСоглашенияСКлиентами,
				Перечисления.ИспользованиеСоглашенийСКлиентами.ТолькоТиповыеСоглашения,
				Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать);
			КонстантаИмя = "ИспользованиеСоглашенийСКлиентами";
		ИначеЕсли РеквизитПутьКДанным = "ИспользованиеСоглашенийСКлиентами" Тогда
			КонстантаИмя = "ИспользованиеСоглашенийСКлиентами";
		ИначеЕсли РеквизитПутьКДанным = "ИспользоватьРасширенныеВозможностиЗаказаКлиента" Тогда
			
			Если РежимИсполненияЗаказов = 1 Тогда
				Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента.Установить(Истина);
				Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Установить(Ложь);
				НаборКонстант.ИспользоватьРасширенныеВозможностиЗаказаКлиента = Истина;
				НаборКонстант.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = Ложь;
			ИначеЕсли РежимИсполненияЗаказов = 2 Тогда
				Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента.Установить(Истина);
				Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Установить(Истина);
				НаборКонстант.ИспользоватьРасширенныеВозможностиЗаказаКлиента = Истина;
				НаборКонстант.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = Истина;
			Иначе
				Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента.Установить(Ложь);
				Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Установить(Ложь);
				НаборКонстант.ИспользоватьРасширенныеВозможностиЗаказаКлиента = Ложь;
				НаборКонстант.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = Ложь;
			КонецЕсли;
			
			КонстантаИмя = "ИспользоватьРасширенныеВозможностиЗаказаКлиента";
			
		КонецЕсли;
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
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекущиеНастройкиРМК()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиРМК.Ссылка
	|ИЗ
	|	Справочник.НастройкиРМК КАК НастройкиРМК
	|ГДЕ
	|	НастройкиРМК.РабочееМесто = &РабочееМесто";

	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Если Выборка.Следующий() Тогда
	
		Возврат Выборка.Ссылка;
		
	Иначе
		
		Возврат Справочники.НастройкиРМК.ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

&НаСервереБезКонтекста
Функция ВидЦеныПрайсЛист()
	
	Возврат Ценообразование.ВидЦеныПрайсЛист();
	
КонецФункции

&НаСервере
Процедура СоздатьЭлементыСправочниковДляИспользованияРозничныхПродаж()
	
	Если НЕ НаборКонстант.ИспользоватьРозничныеПродажи Тогда
		Возврат;
	КонецЕсли;
		
	ТекОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
		
	Если Не ЗначениеЗаполнено(ТекОрганизация) Тогда
		Возврат;
	КонецЕсли;
		
	ТекАвтономнаяКассаККМ = Справочники.КассыККМ.АвтономнаяКассаККМПоУмолчанию();
	ТекФискальныйРегистратор = Справочники.КассыККМ.КассаККМФискальныйРегистраторПоУмолчанию();
		
	Если ЗначениеЗаполнено(ТекАвтономнаяКассаККМ) и ЗначениеЗаполнено(ТекФискальныйРегистратор) Тогда
		Возврат;
	КонецЕсли;
		
	ВидЦены = Ценообразование.ВидЦеныПрайсЛист();
	
	ТекОптовоРозничныйСклад = Справочники.Склады.РозничныйСкладПоУмолчанию();
	
	Если Не ЗначениеЗаполнено(ТекОптовоРозничныйСклад) Тогда
		ОптовоРозничныйСклад = Справочники.Склады.СоздатьЭлемент();
		ОптовоРозничныйСклад.Наименование = НСтр("ru='Розничный склад';uk='Роздрібний склад'");
		ОптовоРозничныйСклад.ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин;
		ОптовоРозничныйСклад.РозничныйВидЦены = ВидЦены;
		ОптовоРозничныйСклад.КонтролироватьОбеспечение = Истина;
		ОптовоРозничныйСклад.ДополнительныеСвойства.Вставить("ПропуститьОбновлениеФлагаКонтроляОперативныхОстатков");
		ОптовоРозничныйСклад.Записать();
	Иначе
		ОптовоРозничныйСклад = ТекОптовоРозничныйСклад;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ТекАвтономнаяКассаККМ) Тогда
		КассаККМ = Справочники.КассыККМ.СоздатьЭлемент();
		КассаККМ.Владелец = ТекОрганизация;
		КассаККМ.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ;
		КассаККМ.Склад = ОптовоРозничныйСклад.Ссылка;
		КассаККМ.Наименование = Строка(КассаККМ.ТипКассы) + "(" + КассаККМ.Склад + ")";
		КассаККМ.ВалютаДенежныхСредств = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
		КассаККМ.Записать();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекФискальныйРегистратор) Тогда
		КассаККМ = Справочники.КассыККМ.СоздатьЭлемент();
		КассаККМ.Владелец = ТекОрганизация;
		КассаККМ.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор;
		КассаККМ.Склад = ОптовоРозничныйСклад.Ссылка;
		КассаККМ.Наименование = Строка(КассаККМ.ТипКассы) + "(" + КассаККМ.Склад + ")";
		КассаККМ.ВалютаДенежныхСредств = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
		КассаККМ.Записать();
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКорректировкиРеализацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти
