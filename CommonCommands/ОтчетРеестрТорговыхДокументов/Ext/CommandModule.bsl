﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("КлючВарианта", "Основной");

	ОткрытьФорму("Отчет.РеестрТорговыхДокументов.Форма", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
