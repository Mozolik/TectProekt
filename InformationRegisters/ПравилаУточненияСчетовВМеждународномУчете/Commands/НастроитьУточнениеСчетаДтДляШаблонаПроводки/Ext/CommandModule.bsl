﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ШаблонПроводки", ПараметрКоманды);
	ПараметрыФормы.Вставить("ВидДвижения", ПредопределенноеЗначение("Перечисление.ВидыДвиженийБухгалтерии.Дебет"));
	
	ОткрытьФорму("РегистрСведений.ПравилаУточненияСчетовВМеждународномУчете.Форма.НастройкаУточненияСчетаДляШаблонаПроводки",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
