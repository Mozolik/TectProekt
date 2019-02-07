﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	Значение = Параметры.Значение;
	ВидСравнения = ?(ЗначениеЗаполнено(Параметры.ОператорСравнения), Параметры.ОператорСравнения, "%LIKE%");
	Если Лев(Значение, 1) = "%" Тогда
		ВидСравнения = "%LIKE%";
		Значение = Сред(Значение, 2);
	КонецЕсли;
	Если Прав(Значение, 1) = "%" Тогда
		ВидСравнения = "%LIKE%";
		Значение = Лев(Значение, СтрДлина(Значение) - 1);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполнитьВыбор(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьВыбор(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьВыбор(НайтиСразу)
	
	Результат = Новый Структура("ОператорСравнения", "LIKE");
	Если ВидСравнения = "=" Тогда
		Результат.Вставить("Значение", Значение);
		Результат.Вставить("ОператорСравнения", "=");
	ИначеЕсли ВидСравнения = "%LIKE%" Тогда
		Результат.Вставить("Значение", "%" + Значение + "%");
	ИначеЕсли ВидСравнения = "%LIKE" Тогда
		Результат.Вставить("Значение", "%" + Значение);
	ИначеЕсли ВидСравнения = "LIKE%" Тогда
		Результат.Вставить("Значение", Значение + "%");
	КонецЕсли;
	Результат.Вставить("НайтиСразу", НайтиСразу);
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
