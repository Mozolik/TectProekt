﻿
////////////////////////////////////////////////////////////////////////////////
// Переопределяемые процедуры и функции планирования производства
//
////////////////////////////////////////////////////////////////////////////////

//++ НЕ УТКА

#Область ПрограммныйИнтерфейс

#Область РасчетГрафикаПроизводства

// Выполняет расчет графика производства
//
// Параметры:
//  СтруктураПараметров	- Структура, содержит свойства:
//							ЭтапыСписок	- ТаблицаЗначений - содержит список этапов для которых требуется выполнить расчет графика выпуска
//							МатериалыСписок	- ТаблицаЗначений - содержит список потребляемых материалов
//  ПараметрыОтладки	- Структура, используется для отладки. Содержит свойства:
//							ДокументОтладки	- ТабличныйДокумент - документ в который выводится отладочная информация
//							НайтиРешения - указывает, что требуется найти решения
//
// Возвращаемое значение:
//   ТаблицаЗначений - график выпуска продукции
//
Функция РассчитатьГрафикВыпускаПродукции(СтруктураПараметров, ПараметрыОтладки = Неопределено) Экспорт
	
	ПланированиеПроизводства.СкорректироватьВремяВыполненияЭтапов(СтруктураПараметров);
	
	Пока Истина Цикл
		
		ПоследовательностьЭтапов = ПланированиеПроизводства.ПоследовательностьЭтапов(СтруктураПараметров);
		ПланированиеПроизводства.ВыполнитьПланирование(СтруктураПараметров, ПоследовательностьЭтапов);
		
		Если СтруктураПараметров.Ошибки.Количество() = 0 Тогда
			
			ГрафикВыпускаПродукции = СтруктураПараметров.ГрафикВыпускаПродукции;
			
		Иначе
												
			ГрафикВыпускаПродукции = Неопределено;
												
		КонецЕсли;
		
		Если ГрафикВыпускаПродукции = Неопределено
			И СтруктураПараметров.РазмещениеВыпуска = Перечисления.СпособыПривязкиОперацийПроизводства.КОкончанию
			И СтруктураПараметров.ИзменятьРазмещениеВыпуска Тогда
			
			Если СтруктураПараметров.Свойство("Ошибки") Тогда
				
				СтруктураПараметров.Удалить("Ошибки");
				
			КонецЕсли;
			
			СтруктураПараметров.РазмещениеВыпуска = Перечисления.СпособыПривязкиОперацийПроизводства.КНачалу;
			Продолжить;
			
		Иначе
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ГрафикВыпускаПродукции;
	
КонецФункции

#КонецОбласти

#КонецОбласти

//-- НЕ УТКА