﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("ТипОснованияАктаОРасхождении",
	                                 ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг"));
	ОткрытьФорму("Документ.АктОРасхожденияхПослеПриемки.ФормаСписка",
	            ПараметрыФормы, 
	            ПараметрыВыполненияКоманды.Источник,
	            "ПоступлениеТоваровУслуг",
	            ПараметрыВыполненияКоманды.Окно, 
	            ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры
