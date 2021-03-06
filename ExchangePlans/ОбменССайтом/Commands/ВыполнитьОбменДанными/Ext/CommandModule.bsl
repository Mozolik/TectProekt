﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УзелОбмена = ПараметрКоманды;
	
	Состояние(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 начат обмен данными с сайтом';uk='%1 розпочатий обмін даними з сайтом'"),
			Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДЛФ=DT"))
		,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='по узлу обмена ""%1""...';uk='по вузлу обміну ""%1""...'"),
			УзелОбмена));
	
	ОбменВыполненСервер(УзелОбмена);
		
	ПоказатьОповещениеПользователя(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 ""%2""';uk='%1 ""%2""'"),
			Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДЛФ=DT"),
			УзелОбмена) 
		,,
		НСтр("ru='Обмен с сайтом завершен';uk='Обмін з сайтом завершений'"),
		БиблиотекаКартинок.Информация32);
		
	Оповестить("ЗавершенСеансОбменаССайтом");

КонецПроцедуры

&НаСервере
Функция ОбменВыполненСервер(УзелОбмена)

	Если ОбменССайтомПовтИсп.ПолучитьЭтотУзелПланаОбмена(УзелОбмена) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если УзелОбмена.ПометкаУдаления Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ОбменССайтомСобытия.ВыполнитьОбмен(УзелОбмена, НСтр("ru='Интерактивный обмен';uk='Інтерактивний обмін'"));
	
	Возврат Истина;
	
КонецФункции
