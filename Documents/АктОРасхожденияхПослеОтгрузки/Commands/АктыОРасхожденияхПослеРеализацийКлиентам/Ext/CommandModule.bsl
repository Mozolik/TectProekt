﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("ТипОснованияАктаОРасхождении",
	                                 ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг"));
	ОткрытьФорму("Документ.АктОРасхожденияхПослеОтгрузки.ФормаСписка",
	            ПараметрыФормы, 
	            ПараметрыВыполненияКоманды.Источник,
	            "РеализацияТоваровУслуг",
	            ПараметрыВыполненияКоманды.Окно, 
	            ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры
