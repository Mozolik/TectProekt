﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("УчетнаяПолитика", ПараметрКоманды));

	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаОрганизаций.ФормаСписка",
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно,
					ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
