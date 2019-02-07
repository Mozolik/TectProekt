﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура СброситьКэш(Знач Правило = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Правило) = Тип("СправочникСсылка.СтатьиБюджетов")
		ИЛИ ТипЗнч(Правило) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.Ссылка
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоПоказателямБюджетов КАК ПравилаПолученияФактаПоПоказателямБюджетов
		|ГДЕ
		|	ПравилаПолученияФактаПоПоказателямБюджетов.ПоказательБюджетов = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПравилаПолученияФактаПоСтатьямБюджетов.Ссылка
		|ИЗ
		|	Справочник.ПравилаПолученияФактаПоСтатьямБюджетов КАК ПравилаПолученияФактаПоСтатьямБюджетов
		|ГДЕ
		|	ПравилаПолученияФактаПоСтатьямБюджетов.СтатьяБюджетов = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Правило);
		
		РезультатЗапроса = Запрос.Выполнить();
		МассивПравил = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку(0);
		
	Иначе
		
		МассивПравил = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Правило);
		
	КонецЕсли;
	
	Для Каждого Правило из МассивПравил Цикл
		
		Набор = РегистрыСведений.КэшПримененияПравилПолученияФакта.СоздатьНаборЗаписей();
		Если ЗначениеЗаполнено(Правило) Тогда
			Набор.Отбор.Правило.Установить(Правило);
			Набор.Записать();
		Иначе
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли