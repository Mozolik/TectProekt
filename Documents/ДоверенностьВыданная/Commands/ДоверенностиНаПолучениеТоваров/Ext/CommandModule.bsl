﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ДоступностьРаспоряженийДС", Ложь);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru='Доверенности на получение товаров';uk='Довіреності на отримання товарів'"));
	ОткрытьФорму("Документ.ДоверенностьВыданная.Форма.ФормаСпискаДокументов", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
