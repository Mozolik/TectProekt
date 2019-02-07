﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ПолноеИмя = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя();
	
	// Параметры ABC/XYZ классификации
	ИспользоватьКлассификациюПоВыручке = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке.Получить();
	ИспользоватьКлассификациюПоВаловойПрибыли = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли.Получить();
	ИспользоватьКлассификациюПоКоличествуПродаж = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж.Получить();
	
	// ABC классификация
	ПериодABCКлассификации = Константы.ПериодABCКлассификацииНоменклатуры.Получить();
	КоличествоПериодовABCКлассификации = Константы.КоличествоПериодовABCКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Получить();
	
	// XYZ классификация
	ПериодXYZКлассификации = Константы.ПериодXYZКлассификацииНоменклатуры.Получить();
	КоличествоПериодовXYZКлассификации = Константы.КоличествоПериодовXYZКлассификацииНоменклатуры.Получить();
	ПодпериодXYZКлассификации = Константы.ПодпериодXYZКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Получить();
	
	// Цвета оформления надписей
	ЦветПоясняющийТекст = ЦветаСтиля.ПоясняющийТекст;
	ЦветПоясняющийОшибкуТекст = ЦветаСтиля.ПоясняющийОшибкуТекст;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницыВозможности.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ОбновитьОтображениеФормы();
	ОбновитьОписания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПолныеЧастоИспользуемыеВозможностиНажатие(Элемент)
	
	ПолныеВозможности = НЕ ПолныеВозможности;
	ОбновитьОтображениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполняется ABC/XYZ классификация...';uk='Виконується ABC/XYZ класифікація...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьABCXYZКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполнена ABC/XYZ классификация!';uk='Виконана ABC/XYZ класифікація!'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьABCКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьABCКлассификациюПолныеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполняется ABC классификация...';uk='Виконується ABC класифікація...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьABCКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполнена ABC классификация!';uk='Виконана ABC класифікація!'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьXYZКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьXYZКлассификациюПолныеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполняется XYZ классификация...';uk='Виконується XYZ класифікація...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьXYZКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполнена XYZ классификация!';uk='Виконана XYZ класифікація!'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаABCXYZКлассификацияПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.НастройкаABCXYZКлассификацияПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ОткрытьФорму(ПолноеИмя + ".Форма.НастройкаПараметровКлассификацииНоменклатуры",,,,,, Новый ОписаниеОповещения("НастройкаABCXYZКлассификацияПолныеВозможностиЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаABCXYZКлассификацияПолныеВозможностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    КодВозврата = Результат;
    
    Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
        
        ИспользоватьКлассификациюПоВыручке = КодВозврата.ИспользоватьКлассификациюПоВыручке;
        ИспользоватьКлассификациюПоВаловойПрибыли = КодВозврата.ИспользоватьКлассификациюПоВаловойПрибыли;
        ИспользоватьКлассификациюПоКоличествуПродаж = КодВозврата.ИспользоватьКлассификациюПоКоличествуПродаж;
        ПериодABCКлассификации = КодВозврата.ПериодABCКлассификации;
        КоличествоПериодовABCКлассификации = КодВозврата.КоличествоПериодовABCКлассификации;
        ПериодXYZКлассификации = КодВозврата.ПериодXYZКлассификации;
        КоличествоПериодовXYZКлассификации = КодВозврата.КоличествоПериодовXYZКлассификации;
        ПодпериодXYZКлассификации = КодВозврата.ПодпериодXYZКлассификации;
        УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры = КодВозврата.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры;
        УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры = КодВозврата.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры;
        
        ОбновитьОтображениеФормы();
        ОбновитьОписания();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьABCКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ОчиститьABCКлассификациюПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьABCКлассификациюПолныеВозможностиЗавершение", ЭтотОбъект), НСтр("ru='Вся информация об ABC классификации номенклатуры будет очищена. Продолжить?';uk='Вся інформація про ABC класифікації номенклатури буде очищена. Продовжити?'"), РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьABCКлассификациюПолныеВозможностиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    КодВозврата = РезультатВопроса;
    
    Если КодВозврата = КодВозвратаДиалога.ОК Тогда
        
        ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполняется очистка ABC классификации...';uk='Виконується очищення ABC класифікації...'"), БиблиотекаКартинок.Информация32);
        
        ОчиститьABCКлассификациюНаСервере();
        
        ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполнена очистка ABC классификации!';uk='Виконане очищення ABC класифікації!'"), БиблиотекаКартинок.Информация32);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьXYZКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ОчиститьXYZКлассификациюПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьXYZКлассификациюПолныеВозможностиЗавершение", ЭтотОбъект), НСтр("ru='Вся информация об XYZ классификации номенклатуры будет очищена. Продолжить?';uk='Вся інформація про XYZ класифікації номенклатури буде очищена. Продовжити?'"), РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьXYZКлассификациюПолныеВозможностиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    КодВозврата = РезультатВопроса;
    
    Если КодВозврата = КодВозвратаДиалога.ОК Тогда
        
        ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполняется очистка XYZ классификации...';uk='Виконується очищення XYZ класифікації...'"), БиблиотекаКартинок.Информация32);
        
        ОчиститьXYZКлассификациюНаСервере();
        
        ПоказатьОповещениеПользователя(НСтр("ru='Классификация номенклатуры';uk='Класифікація номенклатури'"),, НСтр("ru='Выполнена очистка XYZ классификации!';uk='Виконане очищення XYZ класифікації!'"), БиблиотекаКартинок.Информация32);
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ОбновитьОписания()
	
	ABCОписаниеЧастоИспользуемыеВозможности =
		НСтр("ru='ABC классификация по данным за период:';uk='ABC класифікація за даними за період:'") + " " +
		ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации);
	XYZОписаниеЧастоИспользуемыеВозможности =
		НСтр("ru='XYZ классификация по данным за период:';uk='XYZ класифікація за даними за період:'") + " " +
		ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);
	ABCОписаниеПолныеВозможности =
		НСтр("ru='ABC классификация за все периоды по данным за период:';uk='ABC класифікація за всі періоди за даними за період:'") + " " +
		ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации);
	XYZОписаниеПолныеВозможности =
		НСтр("ru='XYZ классификация за все периоды по данным за период:';uk='XYZ класифікація за всі періоди за даними за період:'") + " " +
		ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);
	
	// Часто используемые возможности
	Если ИспользоватьКлассификациюПоВыручке
		ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
		ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж Тогда
	
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.Заголовок =
			ABCОписаниеЧастоИспользуемыеВозможности + " " + XYZОписаниеЧастоИспользуемыеВозможности;
			
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.ЦветТекста = ЦветПоясняющийТекст;
		
	Иначе
		
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.Заголовок =
			НСтр("ru='Перейдите к полным возможностям и в настройке установите параметры, по которым необходимо выполнять классификацию.';uk='Перейдіть до повних можливостей і в настройці встановіть параметри, за якими необхідно виконувати класифікацію.'");
			
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
		
	КонецЕсли;
	
	// Полные возможности
	Если ИспользоватьКлассификациюПоВыручке
		ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
		ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж Тогда
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.Заголовок = ABCОписаниеПолныеВозможности;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.Заголовок = XYZОписаниеПолныеВозможности;
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийТекст;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийТекст;
	
	Иначе
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru='Перейдите к настройке и установите параметры, по которым необходимо выполнять классификацию.';uk='Перейдіть до настройки та встановіть параметри, за якими необхідно виконувати класифікацію.'");
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru='Перейдите к настройке и установите параметры, по которым необходимо выполнять классификацию.';uk='Перейдіть до настройки та встановіть параметри, за якими необхідно виконувати класифікацію.'");
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
	
	КонецЕсли;
	
	Элементы.ДекорацияОчиститьABCКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru='Очистить ABC классификацию за все периоды.';uk='Очистити ABC класифікацію за всі періоди.'");
	Элементы.ДекорацияОчиститьXYZКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru='Очистить XYZ классификацию за все периоды.';uk='Очистити XYZ класифікацію за всі періоди.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеФормы()
	
	Если ПолныеВозможности Тогда
		
		// Переключение к полным возможностям
		Элементы.СтраницыВозможности.ТекущаяСтраница = Элементы.СтраницаПолныеВозможности;
		
		// Изменение заголовка формы и заголовка декорации
		Заголовок = НСтр("ru='Классификация номенклатуры - полные возможности';uk='Класифікація номенклатури - повні можливості'");
		Элементы.ДекорацияПолныеЧастоИспользуемыеВозможности.Заголовок = НСтр("ru='Часто используемые возможности';uk='Часто використовувані можливості'");
		
		// Доступность выполнения ABC классификации
		Элементы.ВыполнитьABCКлассификациюПолныеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																			ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																			ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
																			
		// Доступность выполнения XYZ классификации
		Элементы.ВыполнитьXYZКлассификациюПолныеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																			ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																			ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
		
	Иначе
		
		 // Переключение к часто используемым возможностям
		Элементы.СтраницыВозможности.ТекущаяСтраница = Элементы.СтраницаЧастоИспользуемыеВозможности;
		
		// Изменение заголовка формы и заголовка декорации
		Заголовок = НСтр("ru='Классификация номенклатуры - часто используемые возможности';uk='Класифікація номенклатури - часто використовувані можливості'");
		Элементы.ДекорацияПолныеЧастоИспользуемыеВозможности.Заголовок = НСтр("ru='Полные возможности';uk='Повні можливості'");
		
		// Доступность выполнения ABC/XYZ классификации
		Элементы.ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																						ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																						ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Период, КоличествоПериодов, Подпериод = Неопределено)
	
	ПредставлениеНастройки = "";
	
	Если НЕ ЗначениеЗаполнено(КоличествоПериодов) ИЛИ НЕ ЗначениеЗаполнено(Период) Тогда
		
		Возврат ПредставлениеНастройки;
		
	КонецЕсли;
	
	ПараметрыПредметаИсчисления = "";
	
	Если Период = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий день, предыдущих дня, предыдущих дней, м,,,,, 0';uk='попередній день, попереднього дня, попередніх днів, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущая неделя, предыдущие недели, предыдущих недель, ж,,,,, 0';uk='попередній тиждень, попередні тижні, попередніх тижнів, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущая декада, предыдущие декады, предыдущих декад, ж,,,,, 0';uk='попередня декада, попередні декади, попередніх декад, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий месяц, предыдущих месяца, предыдущих месяцев, м,,,,, 0';uk='попередній місяць, попереднього місяця, попередніх місяців, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий квартал, предыдущих квартала, предыдущих кварталов, м,,,,, 0';uk='попередній квартал, попереднього квартала, попередніх кварталів, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущее полугодие, предыдущих полугодия, предыдущих полугодий, с,,,,, 0';uk='попереднє півріччя, попереднього півріччя, попередніх піврічь, з,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий год, предыдущих года, предыдущих лет, м,,,,, 0';uk='попередній рік, попереднього року, попередніх років, м,,,,, 0'");
		
	Иначе
		
		ПараметрыПредметаИсчисления = "";
		
	КонецЕсли;
	
	ПредставлениеНастройки = НРег(ЧислоПрописью(КоличествоПериодов,, ПараметрыПредметаИсчисления));
	
	Если ЗначениеЗаполнено(Подпериод) Тогда
		
		Если Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по дням).';uk=' (по днях).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по неделям).';uk=' (по тижнях).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по декадам).';uk=' (по декадах).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по месяцам).';uk=' (по місяцях).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по кварталам).';uk=' (за кварталами).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по полугодиям).';uk=' (по півріччях).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + НСтр("ru=' (по годам).';uk=' (по роках).'");
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеНастройки = ПредставлениеНастройки + ".";
		
	КонецЕсли;
	
	Возврат ПредставлениеНастройки;
	
КонецФункции

&НаСервере
Процедура ВыполнитьABCXYZКлассификациюНаСервере()
	
	Справочники.Номенклатура.ВыполнитьABCКлассификацию();
	Справочники.Номенклатура.ВыполнитьXYZКлассификацию();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьABCКлассификациюНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыручкаИСебестоимостьПродаж.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ВыручкаИСебестоимостьПродаж
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(Выборка.Период, ПериодABCКлассификации, 0).ДатаОкончания + 1;
    МаксимальнаяДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДата(), ПериодABCКлассификации, -1).ДатаОкончания + 1;
	
	Пока ДатаКлассификации <= МаксимальнаяДатаКлассификации Цикл
		
		Справочники.Номенклатура.ВыполнитьABCКлассификацию(ДатаКлассификации);
		ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаКлассификации, ПериодABCКлассификации, 1) + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьXYZКлассификациюНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыручкаИСебестоимостьПродаж.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ВыручкаИСебестоимостьПродаж
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(Выборка.Период, ПериодXYZКлассификации, 0).ДатаОкончания + 1;
    МаксимальнаяДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДата(), ПериодXYZКлассификации, -1).ДатаОкончания + 1;
	
	Пока ДатаКлассификации <= МаксимальнаяДатаКлассификации Цикл
		
		Справочники.Номенклатура.ВыполнитьXYZКлассификацию(ДатаКлассификации);
		ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаКлассификации, ПериодXYZКлассификации, 1) + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьABCКлассификациюНаСервере()
	
	РегистрыСведений.ABCXYZКлассификацияНоменклатуры.ОчиститьABCКлассификацию();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьXYZКлассификациюНаСервере()
	
	РегистрыСведений.ABCXYZКлассификацияНоменклатуры.ОчиститьXYZКлассификацию();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
