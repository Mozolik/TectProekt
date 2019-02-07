﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	УстановитьВидимостьСубконто();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСубконто()
	
	Если НЕ РольДоступна("НастройкаБухгалтерскогоУчетаЗарплатыРасширенная")
		И НЕ РольДоступна("ПолныеПрава")Тогда
		Элементы.ГруппаБухгалтерскийУчет.Доступность = Ложь;
	КонецЕсли;	
	
	Если Объект.Вид = Перечисления.ВидыГруппУчетаНачисленийИУдержаний.Начисления 
		или Объект.Вид = Перечисления.ВидыГруппУчетаНачисленийИУдержаний.ОсобыеНачисления Тогда
		Элементы.СубконтоУчета.Доступность = Истина;
		Если НЕ ЗначениеЗаполнено(Объект.СубконтоУчета) Тогда
			Объект.СубконтоУчета = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций;
		КонецЕсли;	
	Иначе
		Элементы.СубконтоУчета.Доступность = Ложь;
		Если ЗначениеЗаполнено(Объект.СубконтоУчета) Тогда
			Объект.СубконтоУчета = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	УстановитьВидимостьСубконто();
КонецПроцедуры
