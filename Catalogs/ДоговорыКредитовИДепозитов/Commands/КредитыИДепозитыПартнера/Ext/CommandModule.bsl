﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Партнер, Заголовок", ПараметрКоманды, НСтр("ru='Кредиты и депозиты партнера';uk='Кредити та депозити партнера'"));
	
	ОткрытьФорму("Справочник.ДоговорыКредитовИДепозитов.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
