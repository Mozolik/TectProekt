﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьОрганизацию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОплатаВедомостей.Регистратор КАК Ссылка,
	|	ОплатаВедомостей.Ведомость.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты КАК ОплатаВедомостей
	|ГДЕ
	|	ОплатаВедомостей.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НАЧАЛОПЕРИОДА(ОплатаВедомостей.Регистратор.Дата, ГОД),
	|	ОплатаВедомостей.Ведомость.Организация,
	|	ОплатаВедомостей.Регистратор.Номер";
	
	ВыборкаРегистраторов = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРегистраторов.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Значение = ВыборкаРегистраторов.Ссылка;
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.Организация = ВыборкаРегистраторов.Организация;
		КонецЦикла;	
		
		НаборЗаписей.Записать();
		
	КонецЦикла
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли