﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.ДеревоРесурсныхСпецификаций.Команда.ДеревоСпецификации");
	
	ПараметрыОткрытия = Новый Структура("Спецификация, СформироватьПриОткрытии, Заголовок, РежимОтображения",
		ПараметрКоманды, Истина, НСтр("ru='Дерево спецификации';uk='Дерево специфікації'"), "Спецификация");
	
	ОткрытьФорму("Обработка.ДеревоРесурсныхСпецификаций.Форма", ПараметрыОткрытия, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
