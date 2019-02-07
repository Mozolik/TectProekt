﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ТипДокументаРабочегоМеста", Новый ОписаниеТипов("ДокументСсылка.ВнутреннееПотреблениеТоваров"));
	СтруктураПараметров.Вставить("РабочееМестоЕдинственнойНакладной", Истина);
	СтруктураПараметров.Вставить("КлючНазначенияФормы", "ВнутреннееПотреблениеТоваров");
	
	ОткрытьФорму(
		"РегистрСведений.ДанныеВнутреннихДокументов.Форма.ФормаСписка",
		СтруктураПараметров,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
