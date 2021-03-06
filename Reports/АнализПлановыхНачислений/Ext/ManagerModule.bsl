﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализФОТПоНачислениям");
	НастройкиВарианта.Описание =
		НСтр("ru='Сопоставление планового фонда оплаты труда сотрудников
        |и фактической зарплаты сотрудников как и в отчете 
        |""Анализ ФОТ по сотрудникам"", но с точностью до отдельных начислений.'
        |;uk='Співставлення планового фонду оплати праці співробітників
        |і фактичної зарплати співробітників як і в звіті 
        |""Аналіз ФОП по співробітникам"", але з точністю до окремих нарахувань.'");
											
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализФОТПоСотрудникам");
	НастройкиВарианта.Описание =
		НСтр("ru='Сопоставление планового фонда оплаты труда сотрудников
        |и фактической зарплаты сотрудников. 
        |При наличии ежеквартальных или ежегодных плановых начислений (премий), 
        |формирование отчета рекомендуется выполнять не за месяц, а за квартал 
        |или год соответственно.'
        |;uk='Співставлення планового фонду оплати праці співробітників
        |і фактичної зарплати співробітників. 
        |При наявності щоквартальних або щорічних планових нарахувань (премій), 
        |формування звіту рекомендується виконувати не за місяць, а за квартал 
        |або рік відповідно.'");

	
КонецПроцедуры

#КонецОбласти

#КонецЕсли