﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура(
		"Отбор",
		Новый Структура("Узел", ПараметрКоманды));
	ОткрытьФорму(
		"РегистрСведений.ПодчиненияУзловОбъектовЭксплуатации.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
