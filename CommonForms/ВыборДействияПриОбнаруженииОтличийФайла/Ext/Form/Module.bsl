﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		Параметры,
		"ДатаИзмененияВРабочемКаталоге,
		|ДатаИзмененияВХранилищеФайлов,
		|ПолноеИмяФайлаВРабочемКаталоге,
		|РазмерВРабочемКаталоге,
		|РазмерВХранилищеФайлов,
		|Сообщение,
		|Заголовок");
	
	Если Параметры.ДействиеНадФайлом = "ПомещениеВХранилищеФайлов" Тогда
		
		Элементы.ФормаОткрытьСуществующий.Видимость = Ложь;
		Элементы.ФормаВзятьИзХранилища.Видимость    = Ложь;
		Элементы.ФормаПоместить.КнопкаПоУмолчанию   = Истина;
		
	ИначеЕсли Параметры.ДействиеНадФайлом = "ОткрытиеВРабочемКаталоге" Тогда
		
		Элементы.ФормаПоместить.Видимость  = Ложь;
		Элементы.ФормаНеПомещать.Видимость = Ложь;
		Элементы.ФормаОткрытьСуществующий.КнопкаПоУмолчанию = Истина;
	Иначе
		ВызватьИсключение НСтр("ru='Неизвестное действие над файлом';uk='Невідома дія над файлом'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСуществующий(Команда)
	
	Закрыть("ОткрытьСуществующий");
	
КонецПроцедуры

&НаКлиенте
Процедура Поместить(Команда)
	
	Закрыть("ПОМЕСТИТЬ");
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьИзХранилища(Команда)
	
	Закрыть("ВзятьИзХранилищаИОткрыть");
	
КонецПроцедуры

&НаКлиенте
Процедура НеПомещать(Команда)
	
	Закрыть("НеПомещать");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталог(Команда)
	
	ФайловыеФункцииСлужебныйКлиент.ОткрытьПроводникСФайлом(ПолноеИмяФайлаВРабочемКаталоге);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть("Отменить");
	
КонецПроцедуры

#КонецОбласти
