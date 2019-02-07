﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Запрет редактирования реквизитов объектов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность редактирования реквизитов
// с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Запрет редактирования реквизитов объектов";
//                            В качестве значения - пустую строку.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	ОбменДаннымиУТУП.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.КаналыРекламныхВоздействий.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчетаКонтрагентов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчетаОрганизаций.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БонусныеПрограммыЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВариантыКомплектацииНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыКартЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыКонтактнойИнформации.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыПланов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыПодарочныхСертификатов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыСделокСКлиентами.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыЦен.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыЦенПоставщиков.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ГрафикиОплаты.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ГруппыРассылокИОповещений.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКонтрагентов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКредитовИДепозитов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.КартыЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Кассы.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.КассыККМ.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.НаборыУпаковок.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ОбластиХранения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Организации.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПодарочныеСертификаты.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПолитикиУчетаСерий.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.РабочиеУчастки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СегментыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СегментыПартнеров.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеГруппыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеПомещения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеЯчейки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Склады.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СтруктураПредприятия.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СценарииТоварногоПланирования.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УпаковкиЕдиницыИзмерения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УсловияПредоставленияСкидокНаценок.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УчетныеПолитикиОрганизаций.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ФорматыМагазинов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ЭквайринговыеТерминалы.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	
	//++ НЕ УТКА
	Объекты.Вставить(Метаданные.Справочники.ВидыРабочихЦентров.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.РабочиеЦентры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.МаршрутныеКарты.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	//-- НЕ УТКА
	//++ НЕ УТ
	Объекты.Вставить(Метаданные.Справочники.ЭтапыПроизводства.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Бригады.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПравилаРаспределенияРасходов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.МоделиБюджетирования.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПоказателиБюджетов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДенежныеДокументы.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыЛизинга.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СтатьиКалькуляции.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СтатьиБюджетов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ШтатноеРасписание.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыБюджетов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Сценарии.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.РесурсныеСпецификации.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.НефинансовыеПоказателиБюджетов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СпособыОтраженияЗарплатыВБухУчете.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	//-- НЕ УТ
КонецПроцедуры

#КонецОбласти
