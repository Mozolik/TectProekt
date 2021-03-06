﻿
#Область ПрограммныйИнтерфейс

// Формирует текст запроса для получения указанного реквизита объекта расчетов
//
// Параметры
//	РеквизИсточника - Строка - Имя реквизита источника содержащего объект расчетов
//                             состоящее из имени таблицы и через точку имени реквизита.
//                             Например: ДанныеРегистра.Заказ
//	РеквизитОбъектаРасчетов - Строка - Имя реквизита объекта расчетов
//	ПолноеИмяМетаданныхРеквизита - Строка - Полный путь к метаданным реквизита как в дереве метаданных.
//                                          Например: "Документы.ПоступлениеБезналичныхДенежныхСредств.ТабличныеЧасти.РасшифровкаПлатежа.Реквизиты.Заказ"
//                                                или "РегистрыНакопления.ДвиженияКонтрагентДоходыРасходы.Измерения.ОбъектРасчетов"
//
// Возвращаемое значение
//	Строка - Текст запроса
//
Функция ТекстЗапросаРеквизитаОбъектаРасчетов(
			РеквизИсточника = "Т.ОбъектРасчетов",
			РеквизитОбъектаРасчетов = "Договор",
			ПолноеИмяМетаданныхРеквизита = "РегистрыНакопления.ДвиженияКонтрагентДоходыРасходы.Измерения.ОбъектРасчетов") Экспорт
	
	ТекстПоля = "ВЫБОР" + Символы.ПС;
	ШаблонУсловия = "	КОГДА ТИПЗНАЧЕНИЯ(%1) = ТИП(%2)
					|		ТОГДА ВЫРАЗИТЬ(%1 КАК %2).%3";
	ШаблонДоговора = "	КОГДА ТИПЗНАЧЕНИЯ(%1) = ТИП(%2)
					 |		ТОГДА %1";
	УсловияВыбора = Новый Массив;
	ТипыДоговоров = Метаданные.Справочники.КлючиАналитикиУчетаПоПартнерам.Реквизиты.Договор.Тип.Типы();
	ТипыДоговоров.Добавить(Тип("СправочникСсылка.ПодарочныеСертификаты"));
	
	ТипыОбъектовРасчета = ОбщегоНазначенияУТ.МетаданныеПоИмени(ПолноеИмяМетаданныхРеквизита).Тип.Типы();
	Для Каждого ТипОбъектаРасчета Из ТипыОбъектовРасчета Цикл
		
		ПолноеИмяТипа = Метаданные.НайтиПоТипу(ТипОбъектаРасчета).ПолноеИмя();
		Если ВРег(РеквизитОбъектаРасчетов) = "ДОГОВОР" И ТипыДоговоров.Найти(ТипОбъектаРасчета) <> Неопределено Тогда
			ТекстУсловия = СтрШаблон(ШаблонДоговора, РеквизИсточника, ПолноеИмяТипа);
		Иначе
			ТекстУсловия = СтрШаблон(ШаблонУсловия, РеквизИсточника, ПолноеИмяТипа, РеквизитОбъектаРасчетов);
		КонецЕсли;
		УсловияВыбора.Добавить(ТекстУсловия);
		
	КонецЦикла;
	ТекстУсловия = СтрСоединить(УсловияВыбора, Символы.ПС);
	Возврат ТекстПоля + ТекстУсловия + Символы.ПС + "КОНЕЦ";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
