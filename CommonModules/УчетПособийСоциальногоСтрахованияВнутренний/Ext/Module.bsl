﻿#Область СлужебныйПрограммныйИнтерфейс


// Возвращает массив ссылок из ПВР Начисления, соответствующих облагаемым взносами компенсациям, возмещаемым из бюджета ФСС 
// (в частности, оплата 4-х дополнительных выходных дней для ухода за детьми инвалидами).
//
// Параметры:
//	нет
// 
// Возвращаемое значение:
//	Массив
// 
Функция НачисленияОблагаемыхВзносамиПособий() Экспорт

	Возврат УчетПособийСоциальногоСтрахованияРасширенный.НачисленияОблагаемыхВзносамиПособий();

КонецФункции

Процедура ЗаполнитьВидПособияВПособияхСоциальногоСтрахования() Экспорт
	
	// В этой конфигурации никаких действий не выполняется
	
КонецПроцедуры

Процедура ЗаполнитьПризнакПособиеВыплачиваетсяФССВСуществующихБольничныхЛистах() Экспорт
	
	
	
КонецПроцедуры

#Область ПолучениеДанныхДляРасчетаСреднегоЗаработкаПоДокументу

// Создает временную таблицу с реквизитами документов необходимыми для формирования
// структуры параметров расчета среденго заработка ФСС
//
// Параметры:
//  МенеджерВременныхТаблиц	 - менеджер временных таблиц, куда будет помещена временная таблица ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС 
//  МассивСсылок			 - массив ссылок, по которым необходимо получить данные, допустимые типы элементов - "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
//
Процедура СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок) Экспорт
	
	УчетПособийСоциальногоСтрахованияРасширенный.СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок);
	
КонецПроцедуры

// Функция - Таблицы данных среднего заработка ФСС
//
// Параметры:
//  ИмяДокумента - Строка, имя документа для которого надо получить данные для расчета среднего заработка
//  МассивСсылок - массив, "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
// 
// Возвращаемое значение:
//  ДанныеДляРасчета - структура, содержит поля с таблицами данных для расчета среднего заработка по МассивСсылок 
//					ДанныеОНачислениях, Таблица значений	
//					ДанныеОВремени, Таблица значений	
//					ДанныеСтрахователей, Таблица значений	
//
Функция ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок) Экспорт
	
	Возврат УчетПособийСоциальногоСтрахованияРасширенный.ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок);
	
КонецФункции 

Функция ОписаниеТипаСтраховательСреднийЗаработокФСС() Экспорт
	Возврат УчетПособийСоциальногоСтрахованияРасширенный.ОписаниеТипаСтраховательСреднийЗаработокФСС();
КонецФункции 

#КонецОбласти

#КонецОбласти
