﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ВидРабочегоЦентра", ПараметрКоманды));
	ОткрытьФорму("Справочник.РабочиеЦентры.Форма.ФормаСписка", 
				ПараметрыФормы, 
				ПараметрыВыполненияКоманды.Источник, 
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
				
КонецПроцедуры
