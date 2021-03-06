﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ТребуетсяОтражениеВБюджетированииДляОтчетаЗаПериод(НачалоПериода, КонецПериода, 
												КоличествоНеактуальныхДокументов, ВсегдаАктуализировать = Ложь) Экспорт
	
	Если Не ВсегдаАктуализировать Тогда
		Если Не Константы.АктуализироватьФактБюджетированияПриФормированииОтчетов.Получить() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПравилаПолученияФактаПоСтатьямБюджетов.Ссылка
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоСтатьямБюджетов КАК ПравилаПолученияФактаПоСтатьямБюджетов
		|ГДЕ
		|	ПравилаПолученияФактаПоСтатьямБюджетов.ПромежуточноеКэшированиеРезультатовРаботыПравил
		|	И НЕ ПравилаПолученияФактаПоСтатьямБюджетов.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ФактическиеДанныеБюджетированияСервер.ПоместитьДокументыДляОтраженияВоВременнуюТаблицу(НачалоПериода, КонецПериода, МенеджерВременныхТаблиц);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВсеДокументыКОтражению.Документ) КАК Количество
	|ИЗ
	|	ДокументыКОтражению КАК ВсеДокументыКОтражению";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		КоличествоНеактуальныхДокументов = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		КоличествоНеактуальныхДокументов = Выборка.Количество;
	КонецЕсли;
	
	Возврат КоличествоНеактуальныхДокументов > 0;
	
КонецФункции

#КонецОбласти

#КонецЕсли