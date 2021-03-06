﻿
#Область ОбработкаСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,, "РасшифровкаСоставаФОТ, ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, ТолькоПросмотр");
	
	Для каждого СтрокаРасшифровкаСоставаФОТ Из Параметры.РасшифровкаСоставаФОТ Цикл
		ЗаполнитьЗначенияСвойств(РасшифровкаСоставаФОТ.Добавить(), СтрокаРасшифровкаСоставаФОТ);
	КонецЦикла;
	
	РучнаяКорректировкаСтоимостьПоДаннымФОТ = Параметры.РучнаяКорректировкаСтоимостьПоДаннымФОТ;
	Если РучнаяКорректировкаСтоимостьПоДаннымФОТ Тогда
		СтоимостьПоДаннымФОТ = Параметры.СтоимостьПоДаннымФОТ;
	КонецЕсли;

	УстановитьВидимостьКнопкиОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ();
	Если РучнаяКорректировкаСтоимостьПоДаннымФОТ Тогда
		ОформитьСтоимостьПоДаннымФОТПриИзменении(ЭтаФорма);
	КонецЕсли;
	
	РезультатИтог = 0;
	Для Каждого СтрокаРасшифровки Из Параметры.РасшифровкаСоставаФОТ Цикл
		РезультатИтог = РезультатИтог + СтрокаРасшифровки.Результат;	
	КонецЦикла;	
	ЭтаФорма.Элементы.РасшифровкаСоставаФОТРезультат.ТекстПодвала = Формат(РезультатИтог,"ЧДЦ=2; ЧРД=,");

КонецПроцедуры

&НаКлиенте
Процедура СтоимостьПоДаннымФОТПриИзменении(Элемент)
	
	РучнаяКорректировкаСтоимостьПоДаннымФОТ = Истина;
	ЖирныйШрифт = Новый Шрифт(Элемент.Шрифт, , , Истина);
	Элемент.Шрифт = ЖирныйШрифт;
	УстановитьВидимостьКнопкиОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ();
	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработкаКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Если Модифицированность Тогда
		
		СтруктураПараметраОповещения = Новый Структура;
		СтруктураПараметраОповещения.Вставить("СтоимостьПоДаннымФОТ", СтоимостьПоДаннымФОТ);
		СтруктураПараметраОповещения.Вставить("РучнаяКорректировкаСтоимостьПоДаннымФОТ", РучнаяКорректировкаСтоимостьПоДаннымФОТ);
		
		Оповестить("ИзмененаСтоимостьПоДаннымФОТ", СтруктураПараметраОповещения, ВладелецФормы);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры	

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ(Команда)
	
	ЭтаФорма.РучнаяКорректировкаСтоимостьПоДаннымФОТ = Ложь;
	ОбычныйШрифт = Новый Шрифт(ЭтаФорма.Элементы.СтоимостьПоДаннымФОТ.Шрифт, , , Ложь);
	ЭтаФорма.Элементы.СтоимостьПоДаннымФОТ.Шрифт = ОбычныйШрифт;
	УстановитьВидимостьКнопкиОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ();
	ПоЧасам = ЭтаФорма.ВидУчетаВремениДляСредней = ПредопределенноеЗначение("Перечисление.ВидыУчетаВремениДляСредней.ПоРабочимЧасам");
	РассчитатьСтоимостьПоДаннымФОТ(ПоЧасам);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопкиОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ()
	
	ЭтаФорма.Элементы.КнопкаОтменитьРучнаяКорректировкаСтоимостьПоДаннымФОТ.Видимость = ЭтаФорма.РучнаяКорректировкаСтоимостьПоДаннымФОТ;

КонецПроцедуры

&НаКлиенте
Процедура ВидУчетаВремениДляСреднейПриИзменении(Элемент)
	
	ПоЧасам = ЭтаФорма.ВидУчетаВремениДляСредней = ПредопределенноеЗначение("Перечисление.ВидыУчетаВремениДляСредней.ПоРабочимЧасам");
	РассчитатьСтоимостьПоДаннымФОТ(ПоЧасам);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеФормы
&НаСервере
Процедура РассчитатьСтоимостьПоДаннымФОТ(ПоЧасам)      
	
	СтоимостьПоДаннымФОТ = ?(ПоЧасам = Истина, РасшифровкаСоставаФОТ.Итог("Результат")/НормаВЧасах, РасшифровкаСоставаФОТ.Итог("Результат")/НормаВДнях);
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОформитьСтоимостьПоДаннымФОТПриИзменении(Форма)
	
	ЖирныйШрифт = Новый Шрифт(Форма.Элементы.СтоимостьПоДаннымФОТ.Шрифт, , , Истина);
	Форма.Элементы.СтоимостьПоДаннымФОТ.Шрифт = ЖирныйШрифт;
	
КонецПроцедуры

#КонецОбласти


