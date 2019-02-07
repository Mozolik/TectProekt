﻿
&НаКлиенте
Процедура БольшеНеПоказывать(Команда)
	
	Сохранить();
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ВладелецФормы.Активизировать();
	КонецЕсли;
		
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПозже(Команда)
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ВладелецФормы.Активизировать();
	КонецЕсли;	
		
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяСохраняемогоПараметра = Параметры.ИмяСохраняемогоПараметра;
	ЗначениеНеПоказывать     = Параметры.ЗначениеНеПоказывать;
	
	Если Параметры.РежимОткрытия = "Принудительно" Тогда
		Элементы.БольшеНеПоказывать.Видимость = Ложь;
		Элементы.ПоказатьПозже.Заголовок = НСтр("ru='Закрыть';uk='Закрити'");
	КонецЕсли;
			
	ПолеОписанияИзменений = Отчеты[Лев(ИмяСохраняемогоПараметра, Найти(ИмяСохраняемогоПараметра, "_") - 1)].ПолучитьМакет(Сред(ИмяСохраняемогоПараметра, Найти(ИмяСохраняемогоПараметра, "_") + 1)).ПолучитьТекст();
		
КонецПроцедуры

&НаСервере
Процедура Сохранить()
	
	ХранилищеНастроекДанныхФорм.Сохранить("Отчет.РегламентированныйОтчетБухОтчетность.Форма.УведомлениеОбИзменениях", ИмяСохраняемогоПараметра, ЗначениеНеПоказывать);
	
КонецПроцедуры