﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ТипДокументаРабочегоМеста", Новый ОписаниеТипов("ДокументСсылка.СборкаТоваров"));
	СтруктураПараметров.Вставить("РабочееМестоЕдинственнойНакладной", Истина);
	СтруктураПараметров.Вставить("КлючНазначенияФормы", "СборкаТоваров");
	
	ОткрытьФорму(
		"РегистрСведений.ДанныеВнутреннихДокументов.Форма.ФормаСписка",
		СтруктураПараметров,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
