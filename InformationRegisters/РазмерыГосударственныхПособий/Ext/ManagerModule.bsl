﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//////////////////////////////////////////////////////////////////
/// Первоначальное заполнение и обновление информационной базы

// Процедура заполняет сведения о действующих размерах пособий
//
Процедура ЗаполнитьГосударственныеПособия() Экспорт
	
	НаборЗаписей = РегистрыСведений.РазмерыГосударственныхПособий.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	КлассификаторXML = РегистрыСведений.РазмерыГосударственныхПособий.ПолучитьМакет("ГосударственныеПособия").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	ТекущаяДата = Неопределено;
	ПредыдущаяЗапись = Неопределено;
	Для Каждого СтрокаКлассификатора ИЗ КлассификаторТаблица Цикл
		ДатаЗаписи = Дата(СтрокаКлассификатора.Date);
		Если ТекущаяДата <> ДатаЗаписи Тогда
			СтрокаНабора = НаборЗаписей.Добавить();
			Если ЗначениеЗаполнено(ТекущаяДата) Тогда
				ЗаполнитьЗначенияСвойств(СтрокаНабора, ПредыдущаяЗапись);
			КонецЕсли;
			СтрокаНабора.Период = ДатаЗаписи;
			ТекущаяДата = ДатаЗаписи;
			ПредыдущаяЗапись = СтрокаНабора; 
		КонецЕсли;
		СтрокаНабора[СтрокаКлассификатора.Benefit]	= Число(СтрокаКлассификатора.Rate);
	КонецЦикла;
	
	//
	//
	//
	

	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецЕсли