﻿
#Область ПрограммныйИнтерфейс

//Рассчитывает итоговое показатели формы документа "Реализация товаров и услуг".
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//
Процедура РассчитатьИтоговыеПоказателиРеализации(Форма) Экспорт
	
	Форма.СуммаВсего = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаСНДС"),
		Форма.Объект.Товары.Итог("СуммаСНДСБезВозвратнойТары"));
	Форма.СуммаНДС = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаНДС"),
		Форма.Объект.Товары.Итог("СуммаНДСБезВозвратнойТары"));
	Форма.СуммаАвтоСкидки = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаАвтоматическойСкидки"),
		Форма.Объект.Товары.Итог("СуммаАвтоматическойСкидкиБезВозвратнойТары"));
	Форма.СуммаРучнойСкидки = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		Форма.Объект.Товары.Итог("СуммаРучнойСкидки"),
		Форма.Объект.Товары.Итог("СуммаРучнойСкидкиБезВозвратнойТары"));
	Форма.СуммаСкидки       = Форма.СуммаАвтоСкидки + Форма.СуммаРучнойСкидки;
	
	Форма.СуммаСверхЗаказа = Форма.Объект.Товары.Итог("СуммаСверхЗаказа");

	Если Форма.СуммаВсего > 0 Тогда
		
		Форма.ПроцентАвтоСкидки   = Форма.СуммаАвтоСкидки * 100 / (Форма.СуммаВсего + Форма.СуммаСкидки);
		Форма.ПроцентРучнойСкидки = Форма.СуммаРучнойСкидки * 100 / (Форма.СуммаВсего + Форма.СуммаСкидки);
		Форма.ПроцентСкидки       = Форма.ПроцентАвтоСкидки + Форма.ПроцентРучнойСкидки;
		
	ИначеЕсли Форма.СуммаСкидки > 0 Тогда
		
		Форма.ПроцентАвтоСкидки   = Форма.СуммаАвтоСкидки * 100 / Форма.СуммаСкидки;
		Форма.ПроцентРучнойСкидки = Форма.СуммаРучнойСкидки * 100 / Форма.СуммаСкидки;
		Форма.ПроцентСкидки       = 100;
		
	Иначе
		
		Форма.ПроцентАвтоСкидки   = 0;
		Форма.ПроцентРучнойСкидки = 0;
		Форма.ПроцентСкидки       = 0;
		
	КонецЕсли;
	
	Если Форма.НалогообложениеНДСПоУмолчанию = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС") 
		ИЛИ Форма.НалогообложениеНДСПоУмолчанию = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОсвобожденаОтНДС") Тогда
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДС;
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница   = Форма.Элементы.СтраницаБезНДС;
	Иначе
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДС;
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница   = Форма.Элементы.СтраницаСНДС;
	КонецЕсли;
	
КонецПроцедуры

//Обновляет информацию по ТН
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//	Параметры - Структура - дополнительные параметры.
//
Процедура ОбновитьИнформациюТранспортныхНакладных(Форма, Параметры) Экспорт
	
	Отступ = Новый ФорматированнаяСтрока("  ");
	
	Форма.КоличествоТранспортныхНакладных = Параметры.КоличествоТранспортныхНакладных;
	
	ОформитьТТН = Новый ФорматированнаяСтрока(НСтр("ru='Оформить ТТН';uk='Оформити ТТН'"),,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,"СоздатьТранспортнуюНакладную");
	
	Если Форма.КоличествоТранспортныхНакладных = 0 Тогда
		
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(ОформитьТТН);
		
	ИначеЕсли Форма.КоличествоТранспортныхНакладных = 1 Тогда
		
		Накладная = Новый ФорматированнаяСтрока(НСтр("ru='ТТН';uk='ТТН'") + " " + Параметры.СокращенноеНаименованиеТранспортнойНакладной,,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,ПолучитьНавигационнуюСсылку(Параметры.ТранспортнаяНакладная));
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(Накладная, Отступ, ОформитьТТН);
		
	Иначе
		
		ЗаголовокКоманды = НСтр("ru='ТТН (%КоличествоТранспортныхНакладных%)';uk='ТТН (%КоличествоТранспортныхНакладных%)'");
		ЗаголовокКоманды = СтрЗаменить(ЗаголовокКоманды, "%КоличествоТранспортныхНакладных%", Форма.КоличествоТранспортныхНакладных);
		ОткрытьСписокТТН = Новый ФорматированнаяСтрока(ЗаголовокКоманды,,ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветГиперссылки"),,"ОткрытьСписокТранспортныхНакладных");
		Форма.ТекстТТН = Новый ФорматированнаяСтрока(ОткрытьСписокТТН, Отступ,ОформитьТТН);
		
	КонецЕсли;
	
	ПродажиКлиентСервер.СформироватьТекстДокументыНаОсновании(Форма);
	
КонецПроцедуры

//Формирует текст документа основания
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа реализации.
//
Функция СформироватьТекстДокументыНаОсновании(Форма) Экспорт
	
	Отступ = Новый ФорматированнаяСтрока("    ");
	Форма.ТекстДокументыНаОсновании = Новый ФорматированнаяСтрока(Форма.ТекстНалоговыеДокументы, Отступ, Форма.ТекстТТН);
	
	Возврат Форма.ТекстДокументыНаОсновании

КонецФункции

#КонецОбласти




