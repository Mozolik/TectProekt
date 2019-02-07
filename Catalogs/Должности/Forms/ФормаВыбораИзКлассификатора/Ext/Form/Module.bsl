﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПоискСуществующейДолжности(Знач ПараметрыФормы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Должности.Ссылка
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	Должности.КодКП = &КодКП
	|	И Должности.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("КодКП", ПараметрыФормы.ЗначенияЗаполнения.КодКП);
	Запрос.УстановитьПараметр("Наименование", ПараметрыФормы.ЗначенияЗаполнения.Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(ТекущаяОбласть)
	
	КодКП        = СокрЛП(ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЛево,
		ТекущаяОбласть.Низ, ОбластьКодПраво).Текст);
	Наименование = СокрЛП(ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеЛево,
		ТекущаяОбласть.Низ, ОбластьНаименованиеПраво).Текст);
	КодЗКППТР    = СокрЛП(ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЗКППТРЛево, ТекущаяОбласть.Низ, ОбластьКодЗКППТРПраво).Текст);
	НаименованиеПоКП = СтрПолучитьСтроку(Наименование, 1);
	ЗначенияЗаполнения = Новый Структура("КодКП, Наименование, КодЗКППТР, НаименованиеПоКП",
		КодКП, СтрПолучитьСтроку(Наименование, 1), КодЗКППТР, НаименованиеПоКП);
		
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ТекущаяДолжность = ПоискСуществующейДолжности(ПараметрыФормы);
	Если ТекущаяДолжность <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура("Ключ", ТекущаяДолжность);
		
		Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В справочнике ""Должности"" уже существует элемент с наименованием ""%1""! Открыт существующий';uk='У довіднику ""Посади"" вже існує елемент з найменуванням ""%1""! Відкритий існуючий'"), Наименование));
		
		ОткрытьФорму("Справочник.Должности.Форма.ФормаЭлемента",
		ПараметрыФормы, ЭтаФорма);
	Иначе	
		Если ЭтаФорма.ОткрытИзФормыСписка Тогда
			ОткрытьФорму("Справочник.Должности.Форма.ФормаЭлемента",
			ПараметрыФормы, ЭтаФорма);
		Иначе
			Закрыть();
			Оповестить("ЗакрытиеФормы",ПараметрыФормы);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокументВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ИскатьСтрокуВТаблице(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не задана строка поиска';uk='Не заданий рядок пошуку'"));
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		Возврат;
	КонецЕсли;
	
	НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, Элементы.ТабДокумент.ТекущаяОбласть,
		,,,, Истина);
	Если НайденнаяОбласть = Неопределено Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, , , , , , Истина);
		Если НайденнаяОбласть = Неопределено Тогда
			ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(
				НСтр("ru='Строка не найдена';uk='Рядок не знайдено'"));
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТабДокумент.ТекущаяОбласть = НайденнаяОбласть;
	ТекущийЭлемент = Элементы.СтрокаПоиска;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("СтрокаПоиска") Тогда
		СтрокаПоиска = ЭтаФорма.Параметры.СтрокаПоиска;
	КонецЕсли;
	Если ЭтаФорма.Параметры.Свойство("ОткрытИзФормыСписка") Тогда
		ОткрытИзФормыСписка = ЭтаФорма.Параметры.ОткрытИзФормыСписка;
	КонецЕсли;


	Макет = Справочники.Должности.ПолучитьМакет("КлассификаторПрофессий");
	
	Макет.КодЯзыкаМакета = "ru";

	ТабДокумент.Вывести(Макет);
	ТабДокумент.ФиксацияСверху      = 3;
	
	ОбластьКодЛево          	= Макет.Области.Код.Лево;
	ОбластьКодПраво         	= Макет.Области.Код.Право;
	ОбластьНаименованиеЛево  	= Макет.Области.Наименование.Лево;
	ОбластьНаименованиеПраво 	= Макет.Области.Наименование.Право;
	ОбластьКодЗКППТРЛево        = Макет.Области.КодЗКППТР.Лево;
	ОбластьКодЗКППТРКодПраво    = Макет.Области.КодЗКППТР.Право;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ИскатьСтрокуВТаблице(Неопределено);

КонецПроцедуры

