﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Объект.КоличествоЭкземпляров = 1;
	ОсновнойШаблон = Константы.ШаблонЭтикеткиУпаковочногоЛиста.Получить();
	
	Если ЗначениеЗаполнено(ОсновнойШаблон) Тогда
		Объект.ШаблонЭтикетки = ОсновнойШаблон;
	Иначе	
		Объект.ШаблонЭтикетки = Справочники.ШаблоныЭтикетокИЦенников.ШаблонПоУмолчанию(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов);
	КонецЕсли;
	
	Объект.НазначениеШаблона = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов;
		
	Если ЭтоАдресВременногоХранилища(Параметры.АдресВХранилище) Тогда
		
		СтуктураПараметров = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		МестоРегистрации = СтуктураПараметров.МестоРегистрации;
		
		Объект.УпаковочныеЛисты.Загрузить(СтуктураПараметров.УпаковочныеЛисты);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СгенерироватьУпаковочныеЛисты(Команда)
	
	Перем КоличествоУпаковочныхЛистов;
	
	ТекстПодсказки = НСтр("ru='Введите количество упаковочных листов';uk='Введіть кількість пакувальних листів'");
	ПоказатьВводЗначения(Новый ОписаниеОповещения("СгенерироватьУпаковочныеЛистыЗавершение", ЭтотОбъект, Новый Структура("КоличествоУпаковочныхЛистов", КоличествоУпаковочныхЛистов)), КоличествоУпаковочныхЛистов, ТекстПодсказки, Тип("Число"));
	
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьУпаковочныеЛистыЗавершение(Значение, ДополнительныеПараметры) Экспорт
    
    КоличествоУпаковочныхЛистов = ?(Значение = Неопределено, ДополнительныеПараметры.КоличествоУпаковочныхЛистов, Значение);
    
    
    Если (Значение <> Неопределено) Тогда
        СгенерироватьУпаковочныеЛистыСервер(КоличествоУпаковочныхЛистов);
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУпаковочныеЛисты

&НаКлиенте
Процедура УпаковочныеЛистыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ТекущиеДанные.Штрихкод = ШтрихкодУпаковочногоЛиста(ТекущиеДанные.Ссылка);
	Иначе
		ТекущиеДанные.Штрихкод = "";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.УпаковочныйЛист.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЭтикетокИЦенников",
		"ЭтикеткаУпаковочныеЛисты",
		ПараметрКоманды,
		ЭтаФорма,
		ПолучитьПараметрыДляУпаковочныхЛистов());

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедуры

&НаСервере
Процедура СгенерироватьУпаковочныеЛистыСервер(КоличествоУпаковочныхЛистов)
	
	Для Счет = 1 По КоличествоУпаковочныхЛистов Цикл
		НоваяСтрока = Объект.УпаковочныеЛисты.Добавить();
		ДокСтруктура = Новый Структура("Вид",Перечисления.ВидыУпаковочныхЛистов.Исходящий);
		НоваяСтрока.Ссылка = Документы.УпаковочныйЛист.СоздатьПровестиНовый(ДокСтруктура);
		НоваяСтрока.Штрихкод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоваяСтрока.Ссылка, "Код");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыДляУпаковочныхЛистов()
	
	УпаковочныеЛисты = Объект.УпаковочныеЛисты.Выгрузить();
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище",       ПоместитьВоВременноеХранилище(УпаковочныеЛисты, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки",         Объект.ШаблонЭтикетки);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров",  Объект.КоличествоЭкземпляров);
	
	Возврат ПараметрыПечати;
	
КонецФункции

&НаСервереБезКонтекста
Функция ШтрихкодУпаковочногоЛиста(Ссылка)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Код");
	
КонецФункции	
	
#КонецОбласти
