﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.ЗаголовокФормы;
	
	// Установка минимальной ширины формы.
	МинимальнаяШирина = СтрДлина(Заголовок);
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(,, Ложь);
	
	ОшибкаНаКлиенте = Параметры.ОшибкаНаКлиенте;
	ОшибкаНаСервере = Параметры.ОшибкаНаСервере;
	
	Если ЗначениеЗаполнено(ОшибкаНаКлиенте)
	   И ЗначениеЗаполнено(ОшибкаНаСервере) Тогда
		
		ОписаниеОшибки =
			  НСтр("ru='НА СЕРВЕРЕ:';uk='НА СЕРВЕРІ:'")
			+ Символы.ПС + Символы.ПС + ОшибкаНаСервере.ОписаниеОшибки
			+ Символы.ПС + Символы.ПС
			+ НСтр("ru='НА КОМПЬЮТЕРЕ:';uk='НА КОМП''ЮТЕРІ:'")
			+ Символы.ПС + Символы.ПС + ОшибкаНаКлиенте.ОписаниеОшибки;
	Иначе
		ОписаниеОшибки = ОшибкаНаКлиенте.ОписаниеОшибки;
	КонецЕсли;
	
	ОписаниеОшибки = СокрЛП(ОписаниеОшибки);
	Элементы.ОписаниеОшибки.Заголовок = ОписаниеОшибки;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПриложения, "8.3.6.0") > 0 Тогда
			КоэффициентСжатия = 0.78;
		Иначе
			КоэффициентСжатия = 0.71;
		КонецЕсли;
	Иначе
		КоэффициентСжатия = 0.75;
	КонецЕсли;
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(ОписаниеОшибки) Цикл
		ТекущаяСтрока = СтрПолучитьСтроку(ОписаниеОшибки, НомерСтроки);
		ДлинаТекущейСтроки = Цел(СтрДлина(ТекущаяСтрока)*КоэффициентСжатия);
		Если ДлинаТекущейСтроки > МинимальнаяШирина Тогда
			МинимальнаяШирина = ДлинаТекущейСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Ширина = ?(МинимальнаяШирина <= 75, МинимальнаяШирина, 75);
	
	ПоказатьИнструкцию                = Параметры.ПоказатьИнструкцию;
	ПоказатьПереходКНастройкеПрограмм = Параметры.ПоказатьПереходКНастройкеПрограмм;
	ПоказатьУстановкуРасширения       = Параметры.ПоказатьУстановкуРасширения;
	
	ОпределитьВозможности(ПоказатьИнструкцию, ПоказатьПереходКНастройкеПрограмм, ПоказатьУстановкуРасширения,
		ОшибкаНаКлиенте, ЭтоПолноправныйПользователь);
	
	ОпределитьВозможности(ПоказатьИнструкцию, ПоказатьПереходКНастройкеПрограмм, ПоказатьУстановкуРасширения,
		ОшибкаНаСервере, ЭтоПолноправныйПользователь);
	
	Если Не ПоказатьИнструкцию Тогда
		Элементы.ГруппаИнструкция.Видимость = Ложь;
	КонецЕсли;
	
	ПоказатьУстановкуРасширения = ПоказатьУстановкуРасширения И Не Параметры.РасширениеПодключено;
	
	Если Не ПоказатьУстановкуРасширения Тогда
		Элементы.ФормаУстановитьРасширение.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПоказатьПереходКНастройкеПрограмм Тогда
		Элементы.ФормаПерейтиКНастройкеПрограмм.Видимость = Ложь;
	КонецЕсли;
	
	Если ПоказатьИнструкцию Или ПоказатьУстановкуРасширения И ПоказатьПереходКНастройкеПрограмм Тогда
		Если Ширина < 55 Тогда
			Ширина = 55;
		КонецЕсли;
	КонецЕсли;
	
	СброситьРазмерыИПоложениеОкна();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройкеПрограмм(Команда)
	
	Закрыть();
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Программы");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьРасширение(Истина);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВБуферОбмена(Команда)
	
	Строка = Элементы.ОписаниеОшибки.Заголовок;
	ПоказатьВводСтроки(Новый ОписаниеОповещения("СкопироватьВБуферОбменаЗавершение", ЭтотОбъект),
		Строка, НСтр("ru='Текст ошибки для копирования';uk='Текст помилки для копіювання'"),, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкопироватьВБуферОбменаЗавершение(Результат, Неопределен) Экспорт
	
	Результат = "";
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.Вопрос", "", ИмяПользователя);
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможности(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь)
	
	ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь);
	
	Если Не Ошибка.Свойство("Ошибки") Или ТипЗнч(Ошибка.Ошибки) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТекущаяОшибка Из Ошибка.Ошибки Цикл
		ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, ТекущаяОшибка, ЭтоПолноправныйПользователь);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь)
	
	Если Ошибка.Свойство("НастройкаПрограмм") И Ошибка.НастройкаПрограмм = Истина Тогда
		НастройкаПрограмм = ЭтоПолноправныйПользователь
			Или Не Ошибка.Свойство("КАдминистратору")
			Или Ошибка.КАдминистратору <> Истина;
	КонецЕсли;
	
	Если Ошибка.Свойство("Инструкция") И Ошибка.Инструкция = Истина Тогда
		Инструкция = Истина;
	КонецЕсли;
	
	Если Ошибка.Свойство("Расширение") И Ошибка.Расширение = Истина Тогда
		Расширение = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
