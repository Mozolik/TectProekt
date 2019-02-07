﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Коллекция - Коллекция параметров для получения ключа
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаПоПартнерам - Найденный элемент справочника
//
Функция ЗначениеКлючаАналитики(ПараметрыАналитики) Экспорт

	МенеджерЗаписи = РегистрыСведений.АналитикаУчетаПоПартнерам.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыАналитики, "Организация, Партнер, Контрагент, Договор, НаправлениеДеятельности");
	МенеджерЗаписи.Прочитать();

	Если МенеджерЗаписи.Выбран() Тогда
		ЭлементКлючАналитики = МенеджерЗаписи.КлючАналитики;
	Иначе
		ЭлементКлючАналитики = СоздатьКлючАналитики(ПараметрыАналитики);
	КонецЕсли;

	Возврат ЭлементКлючАналитики;

КонецФункции

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Выборка или Структура  с полями "Организация, Партнер, Контрагент, Договор".
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаПоПартнерам - Найденный элемент справочника
//
Функция СоздатьКлючАналитики(ПараметрыАналитики) Экспорт

	МенеджерЗаписи = РегистрыСведений.АналитикаУчетаПоПартнерам.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыАналитики, "Организация, Партнер, Контрагент, Договор, НаправлениеДеятельности");

	// Создание нового ключа аналитики.
	СправочникОбъект = Справочники.КлючиАналитикиУчетаПоПартнерам.СоздатьЭлемент();
	СправочникОбъект.Наименование = ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи);
	ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыАналитики, "Организация, Партнер, Контрагент, Договор, НаправлениеДеятельности");
	СправочникОбъект.Записать();

	Результат = СправочникОбъект.Ссылка;

	МенеджерЗаписи.КлючАналитики = Результат;
	МенеджерЗаписи.Записать(Ложь);

	Возврат Результат;

КонецФункции

// Функция возвращает массив из ключей аналитики учета по партнерам, в которых организация соответствует.
// переданной в параметрах. Если передается пустая ссылка на справочник "Организации", 
// то формируется массив из ключей аналитик для всех доступных пользователю организаций
// Параметры:
//	Организация - СправочникСсылка.Организации.
//
// Возвращаемое значение:
//	Массив
//
Функция ПолучитьМассивКлючейАналитикиПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст ="
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Организация
		|ПОМЕСТИТЬ ВТОрганизации
		|ИЗ
		|	Справочник.Организации КАК ДанныеСправочника
		|ГДЕ
		|	ДанныеСправочника.Ссылка = &Организация
		|	ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АналитикаУчетаПоПартнерам.КлючАналитики КАК КлючАналитики
		|ИЗ
		|	ВТОрганизации КАК ВТОрганизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
		|		ПО ВТОрганизации.Организация = АналитикаУчетаПоПартнерам.Организация";

	Запрос.УстановитьПараметр("Организация", Организация);
	
	МассивКлючейАналитикиПоПартнерам = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КлючАналитики");
	
	Возврат МассивКлючейАналитикиПоПартнерам;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи)
	
	Наименование = "";
	
	МетаданныеИзмерения = Метаданные.РегистрыСведений.АналитикаУчетаПоПартнерам.Измерения;
	Для Каждого Измерение Из МетаданныеИзмерения Цикл
		
		// Получим представление значения, которое указано в измерении регистра сведений.
		ТекстЗначения = Строка(МенеджерЗаписи[Измерение.Имя]);
		Если Не ПустаяСтрока(ТекстЗначения) Тогда
			Наименование = Наименование + ТекстЗначения + "; ";
		КонецЕсли;
		
	КонецЦикла;
	
	Если Прав(Наименование, 2) = "; " Тогда
		Наименование = Лев(Наименование, СтрДлина(Наименование) - 2);
	КонецЕсли;
	
	Возврат Наименование;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли