﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДеревоЭлементов = ДанныеФормыВЗначение(Параметры.ЭлементыОтчета, Тип("ДеревоЗначений"));
	АдресЭлементовОтчета = ПоместитьВоВременноеХранилище(ДеревоЭлементов, УникальныйИдентификатор);
	Заголовок = Параметры.ВидЭлемента;
	ЭтоСтроки = Параметры.ЭтоСтроки;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтаФорма);
	ИсточникиЗначений.Загрузить(ДанныеОбъекта.ИсточникиЗначений);
	Справочники.ЭлементыФинансовыхОтчетов.ЗаполнитьПредставлениеДополнительныхПолей(Объект, Элементы.ВыборДополнительныхПолей);
	
	УправлениеФормой();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресЭлементаВХранилище);
	ДанныеОбъекта.ИсточникиЗначений = ИсточникиЗначений.Выгрузить();
	ПоместитьВоВременноеХранилище(ДанныеОбъекта, АдресЭлементаВХранилище);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидАналитикиПриИзменении(Элемент)
	
	Объект.НаименованиеДляПечати = Строка(ВидАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДополнительныхПолей(Команда)
	
	ПараметрыФормыПолей = БюджетнаяОтчетностьВызовСервера.ПараметрыНастройкиДополнительныхПолей(Объект, ВидАналитики, ЭтоСтроки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновлениеДополнительныхПолей", ЭтаФорма);
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.НастройкаДополнительныхПолей", 
					ПараметрыФормыПолей,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникиАналитикПоУмолчаниюПриИзменении(Элемент)
	
	Если ВыбранныеИсточникиЗначений Тогда
		ЗаполнитьИсточникиПоУмолчанию();
	Иначе
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьДополнительныеПоля(Результат)
	
	Объект.ДополнительныеПоля.Загрузить(ПолучитьИзВременногоХранилища(Результат));
	Справочники.ЭлементыФинансовыхОтчетов.ЗаполнитьПредставлениеДополнительныхПолей(Объект, Элементы.ВыборДополнительныхПолей);
	
КонецФункции

&НаКлиенте
Процедура ОбновлениеДополнительныхПолей(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДополнительныеПоля(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИсточники(Команда)
	
	ПараметрыВыбораИсточников = Новый Структура("АдресЭлементаВХранилище, АдресЭлементовОтчета, ИсточникиЗначений", 
										АдресЭлементаВХранилище, АдресЭлементовОтчета, ИсточникиЗначений);
	
	Оповещение = Новый ОписаниеОповещения("ВыборИсточниковЗначений", ЭтаФорма);
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.ИсточникиЗначений",ПараметрыВыбораИсточников
												,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ВыбратьИсточники.Доступность = ВыбранныеИсточникиЗначений;
	Если Элементы.ВыбратьИсточники.Доступность 
		И ИсточникиЗначений.Количество() Тогда
		Элементы.ВыбратьИсточники.Заголовок = НСтр("ru='Изменить источники (%1)';uk='Змінити джерела (%1)'");
		Элементы.ВыбратьИсточники.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
												Элементы.ВыбратьИсточники.Заголовок, ИсточникиЗначений.Количество());
	Иначе
		Элементы.ВыбратьИсточники.Заголовок = НСтр("ru='Не указаны';uk='Не вказано'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИсточниковЗначений(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИсточникиЗначений.Очистить();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(ИсточникиЗначений, Результат, "Источник");
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсточникиПоУмолчанию()
	Перем Кэш;
	
	РассчитанныеИсточникиЗначений = БюджетнаяОтчетностьРасчетКэшаСервер.ИсточникиЗначенийПоУмолчанию(АдресЭлементовОтчета, АдресЭлементаВХранилище, Кэш);
	ИсточникиЗначений.Загрузить(РассчитанныеИсточникиЗначений);
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

