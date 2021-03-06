﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	СписокКодов = КонтролируемыеОперацииПовтИсп.ПолучитьСписокВыбораКодыНаименованияОпераций();
	Для каждого ЭлементСпискаКодов Из СписокКодов Цикл
		Элементы.КодНаименованияОперации.СписокВыбора.Добавить(ЭлементСпискаКодов.Значение, ЭлементСпискаКодов.Представление);
	КонецЦикла;

	СписокКодов = КонтролируемыеОперацииПовтИсп.ПолучитьСписокВыбораКодыСтороныОпераций();
	Для каждого ЭлементСпискаКодов Из СписокКодов Цикл
		Элементы.КодСтороныОперации.СписокВыбора.Добавить(ЭлементСпискаКодов.Значение, ЭлементСпискаКодов.Представление);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	ДоговорКонтрагентаПриИзмененииНаСервере(Запись.ДоговорКонтрагента, Запись.ДатаКонтракта, Запись.НомерКонтракта);
	
КонецПроцедуры

&НаКлиенте
Процедура КодНаименованияОперацииПриИзменении(Элемент)
	
	ПроверитьСоответствиеКодаСтороныОперации(Запись.КодНаименованияОперации, Запись.КодСтороныОперации);

КонецПроцедуры

&НаКлиенте
Процедура КодСтороныОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элементы.КодСтороныОперации.СписокВыбора.Очистить();
	Для каждого ДопустимыеЗначения Из СписокВозможныхЗначенийКодовСтороны(Запись.КодНаименованияОперации) Цикл
		Элементы.КодСтороныОперации.СписокВыбора.Добавить(ДопустимыеЗначения.Значение, ДопустимыеЗначения.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КодСтороныОперацииПриИзменении(Элемент)
	
	ПроверитьСоответствиеКодаСтороныОперации(Запись.КодНаименованияОперации, Запись.КодСтороныОперации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДоговорКонтрагентаПриИзмененииНаСервере(Договор, Дата, Номер)
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Дата, Номер");
	Дата  = РеквизитыДоговора.Дата;
	Номер = РеквизитыДоговора.Номер;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьСоответствиеКодаСтороныОперации(КодНаимОперации, КодСторОперации)
	
	СписокВозможныхЗначений = СписокВозможныхЗначенийКодовСтороны(КодНаимОперации);
	Если СписокВозможныхЗначений.НайтиПоЗначению(КодСторОперации) = Неопределено Тогда
		КодСторОперации = "";
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокВозможныхЗначенийКодовСтороны(КодНаимОперации)

	Возврат КонтролируемыеОперацииПовтИсп.ПолучитьСписокВыбораКодыСтороныОпераций(КодНаимОперации);	

КонецФункции
