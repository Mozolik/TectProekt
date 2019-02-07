﻿
#Область СлужебныеПроцедурыИФункции

Функция ДатаПлатежа(ПланироватьСДаты, День) Экспорт
	
	Возврат ПланироватьСДаты + 86400 * (День - 1);
	
КонецФункции

Функция СтрокаБанковскогоСчета(ДеревоПлатежей, Строка) Экспорт
	
	Если Строка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Строка) = Тип("Число") Тогда
		ТекущаяСтрока = ДеревоПлатежей.НайтиПоИдентификатору(Строка);
	Иначе
		ТекущаяСтрока = Строка;
	КонецЕсли;
	
	РодительСтроки = ТекущаяСтрока;
	Пока ФинансоваяОтчетностьКлиентСервер.РодительСтроки(РодительСтроки) <> Неопределено Цикл
		РодительСтроки = ФинансоваяОтчетностьКлиентСервер.РодительСтроки(РодительСтроки);
	КонецЦикла;
	
	Возврат РодительСтроки;
	
КонецФункции

Процедура ПроверитьДобавитьСтрокуИтогов(ДеревоПоступлений, ИндексСтроки, Поступления, ЕстьДанные) Экспорт
	
	Если Поступления Тогда
		ИмяСтроки = НСтр("ru='Итого поступления:';uk='Разом надходження:'");
		ВидСтроки = 3;
	Иначе
 		ИмяСтроки = "Итого списания:";
 		ИмяСтроки = НСтр("ru='Итого списания:';uk='Разом списання:'");
		ВидСтроки = 2;
	КонецЕсли;
	
	РодительСтроки = СтрокаБанковскогоСчета(ДеревоПоступлений, ИндексСтроки);
	ЭлементыСтроки = ФинансоваяОтчетностьКлиентСервер.ПодчиненныеСтроки(РодительСтроки);
	
	ИндексВставки = Неопределено;
	
	Для Каждого ЭлементСтроки из ЭлементыСтроки Цикл
		
		Если ЭлементСтроки.ВидСтроки = ВидСтроки Тогда
			Если Не ЕстьДанные Тогда
				ЭлементыСтроки.Удалить(ЭлементСтроки);
			КонецЕсли;
			Возврат;
		ИначеЕсли ЭлементСтроки.ВидСтроки < ВидСтроки Тогда
			ИндексВставки = ЭлементыСтроки.Индекс(ЭлементСтроки);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьДанные Тогда
		Возврат;
	КонецЕсли;
	
	Если ИндексВставки = Неопределено Тогда
		НоваяСтрока = ЭлементыСтроки.Добавить();
	Иначе
		НоваяСтрока = ЭлементыСтроки.Вставить(ИндексВставки);
	КонецЕсли;
	
	НоваяСтрока.Группировка = ИмяСтроки;
	НоваяСтрока.ЗначениеГруппировки = ИмяСтроки;
	НоваяСтрока.ВидСтроки = ВидСтроки;
	НоваяСтрока.ИндексПорядка = -ВидСтроки;
	
КонецПроцедуры

Процедура ОчиститьЗначенияСтроки(ТекущаяСтрока, ИмяЭлементаПеретаскивания) Экспорт
	
	ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Представление"] = "";
	ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Значение"] = Неопределено;
	ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Сумма"] = 0;
	
КонецПроцедуры

Процедура СкопироватьЗначенияСтроки(ТекущаяСтрока, НоваяСтрока, ИмяЭлементаПеретаскивания) Экспорт
	
	НоваяСтрока[ИмяЭлементаПеретаскивания + "Представление"] = ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Представление"];
	НоваяСтрока[ИмяЭлементаПеретаскивания + "Значение"] = ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Значение"];
	НоваяСтрока[ИмяЭлементаПеретаскивания + "Сумма"] = ТекущаяСтрока[ИмяЭлементаПеретаскивания + "Сумма"];
	
	ОчиститьЗначенияСтроки(ТекущаяСтрока, ИмяЭлементаПеретаскивания);
	
КонецПроцедуры

Процедура ПроверитьВозможностьВыводаВОднуСтроку(НоваяСтрока, ДнейПланирования) Экспорт
	
	ЭлементыСтроки = ФинансоваяОтчетностьКлиентСервер.ПодчиненныеСтроки(НоваяСтрока);
	Если ЭлементыСтроки.Количество() = 1 Тогда
		Для Сч = 1 по ДнейПланирования Цикл
			СкопироватьЗначенияСтроки(ЭлементыСтроки[0], НоваяСтрока, "День" + Сч);
		КонецЦикла;
		НоваяСтрока.ДоступноДляИзмененияГруппировки = ЭлементыСтроки[0].ДоступноДляИзмененияГруппировки;
		ЭлементыСтроки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПересчитатьПодчиненныеСтроки(ДеревоПлатежей, ИДРодителя, ДнейПланирования, ОтображениеОтрицательныхСумм, ОтображениеСумм) Экспорт
	
	Если ТипЗнч(ИДРодителя) = Тип("Число") Тогда
		СтрокаДерева = ДеревоПлатежей.НайтиПоИдентификатору(ИДРодителя);
	Иначе
		СтрокаДерева = ИДРодителя;
	КонецЕсли;
	
	ЭлементыСтроки = ФинансоваяОтчетностьКлиентСервер.ПодчиненныеСтроки(СтрокаДерева);
	
	СоответствиеИтогов = Новый Соответствие;
	СтрокаИтогов = Неопределено;
	
	Для Каждого ПодчиненнаяСтрока из ЭлементыСтроки Цикл
		Если ПодчиненнаяСтрока.ВидСтроки = 2 Тогда
			СтрокаИтогов = ПодчиненнаяСтрока;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	НачальныйОстаток = СтрокаДерева.ОстатокОборот;
	Для Сч = 1 По ДнейПланирования Цикл
		СуммаСписаний = 0;
		ИтогоОборот = ПересчитатьИтогиПоДню(ЭлементыСтроки, Сч, СоответствиеИтогов, СуммаСписаний);
		Если СтрокаИтогов <> Неопределено Тогда
			ДобавитьЗначениеВИтог(ИдентификаторСтроки(СтрокаИтогов), СуммаСписаний, СоответствиеИтогов);
			СтрокаИтогов["День" + Сч + "Представление"] = СуммаСписаний;
			СтрокаИтогов["День" + Сч + "Сумма"] = СуммаСписаний;
		КонецЕсли;
		НачальныйОстаток = НачальныйОстаток + ИтогоОборот;
		СтрокаДерева["День" + Сч + "Представление"] = НачальныйОстаток;
		СтрокаДерева["День" + Сч + "Сумма"] = НачальныйОстаток;
	КонецЦикла;
	
	Для Каждого КлючИЗначение из СоответствиеИтогов Цикл
		
		Если ТипЗнч(КлючИЗначение.Ключ) = Тип("Число") Тогда
			СтрокаДерева = ДеревоПлатежей.НайтиПоИдентификатору(КлючИЗначение.Ключ);
		Иначе
			СтрокаДерева = КлючИЗначение.Ключ;
		КонецЕсли;
		
		СтрокаДерева.ОстатокОборот = КлючИЗначение.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СтрокаФорматаПоНастройкам(ОтображениеОтрицательныхСумм, ОтображениеСумм) Экспорт
	
	МассивФормата = Новый Массив;
	Если ОтображениеОтрицательныхСумм = ПредопределенноеЗначение("Перечисление.ОтображениеОтрицательныхСуммВПлатежномКалендаре.ВСкобках") Тогда
		МассивФормата.Добавить("ЧО=0");
	ИначеЕсли ОтображениеОтрицательныхСумм = ПредопределенноеЗначение("Перечисление.ОтображениеОтрицательныхСуммВПлатежномКалендаре.СМинусом") Тогда
		МассивФормата.Добавить("ЧО=1");
	КонецЕсли;
	
	Если ОтображениеСумм = ПредопределенноеЗначение("Перечисление.ОтображениеСуммВПлатежномКалендаре.ВТысячах") Тогда
		МассивФормата.Добавить("ЧДЦ=; ЧС=3");
	ИначеЕсли ОтображениеСумм = ПредопределенноеЗначение("Перечисление.ОтображениеСуммВПлатежномКалендаре.ОкруглятьДоЦелых") Тогда
		МассивФормата.Добавить("ЧДЦ=");
	ИначеЕсли ОтображениеСумм = ПредопределенноеЗначение("Перечисление.ОтображениеСуммВПлатежномКалендаре.ТочноеЗначение") Тогда
		МассивФормата.Добавить("ЧДЦ=2");
	КонецЕсли;
	
	СтрокаФормата = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивФормата, "; ");
	
	Возврат СтрокаФормата;
	
КонецФункции

Функция ФорматированнаяСумма(СуммаОтображения, ОтображениеОтрицательныхСумм, ОтображениеСумм) Экспорт
	
	Если ОтображениеОтрицательныхСумм = ПредопределенноеЗначение("Перечисление.ОтображениеОтрицательныхСуммВПлатежномКалендаре.НеВыделять") Тогда
		Если СуммаОтображения < 0 Тогда
			СуммаОтображения = -СуммаОтображения;
		КонецЕсли;
	КонецЕсли;
	
	СтрокаФормата = СтрокаФорматаПоНастройкам(ОтображениеОтрицательныхСумм, ОтображениеСумм);
	ПредставлениеСуммы = Формат(СуммаОтображения, СтрокаФормата);
	
	Возврат ПредставлениеСуммы;
	
КонецФункции

Функция ПредставлениеДокумента(Документ, РеквизитыДокумента, ОтображениеОтрицательныхСумм, ОтображениеСумм) Экспорт
	
	СуммаОтображения = РеквизитыДокумента.СуммаДокумента;
	ПредставлениеСуммы = ФорматированнаяСумма(СуммаОтображения, ОтображениеОтрицательныхСумм, ОтображениеСумм);
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		Представление = ПредставлениеСуммы + " до " + Формат(РеквизитыДокумента.ЖелательнаяДатаПлатежа, "ДФ=dd.MM") + Символы.ПС;
		Представление = Представление + СокрЛП(СокрЛП(Строка(РеквизитыДокумента.КонтрагентНаименование) + " ") + РеквизитыДокумента.НазначениеПлатежа);
	ИначеЕсли ТипЗнч(Документ) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Представление = ПредставлениеСуммы + " " + СокрЛП(РеквизитыДокумента.КонтрагентНаименование) + Символы.ПС;
		Представление = Представление + РеквизитыДокумента.Представление;
	Иначе
		Представление = ПредставлениеСуммы + " " + СокрЛП(РеквизитыДокумента.КонтрагентНаименование) + Символы.ПС;
		Если РеквизитыДокумента.Номер <> Неопределено Тогда
			Представление = Представление + Символы.ПС + ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента);
		КонецЕсли;
	КонецЕсли;
	
	Представление = СокрЛП(Представление);
	Возврат Представление;
	
КонецФункции

#Область ВспомогательныеПроцедурыИФункции

Процедура ДобавитьЗначениеВИтог(ИндексСтроки, Значение, СоответствиеИтогов)
	
	НакопленныйИтог = СоответствиеИтогов[ИндексСтроки];
	Если Не ЗначениеЗаполнено(НакопленныйИтог) Тогда
		НакопленныйИтог = 0;
	КонецЕсли;
	НакопленныйИтог = НакопленныйИтог + Значение;
	СоответствиеИтогов.Вставить(ИндексСтроки, НакопленныйИтог);
	
КонецПроцедуры

Функция ПересчитатьИтогиПоДню(ЭлементыСтроки, НомерДня, СоответствиеИтогов, СуммаСписаний = 0)
	
	ИтогоОборот = 0;
	
	Для Каждого ПодчиненнаяСтрока из ЭлементыСтроки Цикл
		
		Если ПодчиненнаяСтрока.ВидСтроки = 2 Тогда
			Продолжить;
		КонецЕсли;
		
		КонечныеСтроки = ФинансоваяОтчетностьКлиентСервер.ПодчиненныеСтроки(ПодчиненнаяСтрока);
		
		Если КонечныеСтроки.Количество() Тогда
			
			ОборотПоПодчиненным = ПересчитатьИтогиПоДню(КонечныеСтроки, НомерДня, СоответствиеИтогов);
			ПодчиненнаяСтрока["День" + НомерДня + "Сумма"] = ОборотПоПодчиненным;
			ПодчиненнаяСтрока["День" + НомерДня + "Представление"] = ОборотПоПодчиненным;
			
		КонецЕсли;
		
		ДобавитьЗначениеВИтог(ИдентификаторСтроки(ПодчиненнаяСтрока), ПодчиненнаяСтрока["День" + НомерДня + "Сумма"], СоответствиеИтогов);
		ИтогоОборот = ИтогоОборот + ПодчиненнаяСтрока["День" + НомерДня + "Сумма"];
		Если Не ПодчиненнаяСтрока.ВидСтроки = 3 Тогда
			СуммаСписаний = СуммаСписаний + ПодчиненнаяСтрока["День" + НомерДня + "Сумма"];
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИтогоОборот;
	
КонецФункции

Функция ИдентификаторСтроки(СтрокаДерева)
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
		Возврат СтрокаДерева.ПолучитьИдентификатор();
	Иначе
		Возврат СтрокаДерева;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

