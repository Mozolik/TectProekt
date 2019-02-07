﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборНоменклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	
	Если НЕ ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		ТекстСообщения = НСтр("ru='Поле ""Номенклатура"" не заполнено.';uk='Поле ""Номенклатура"" не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных.НаборыДанных.ОстаткиСерии.Запрос = ТекстЗапросаОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаОтчета()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	ВидыНоменклатурыПолитикиУчетаСерий.Склад КАК Склад
	|ПОМЕСТИТЬ НоменклатураПоКоторойНеВедутсяОстатки
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ВидыНоменклатурыПолитикиУчетаСерий
	|		ПО (ВидыНоменклатурыПолитикиУчетаСерий.Ссылка = Номенклатура.ВидНоменклатуры)
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|	И ВидыНоменклатурыПолитикиУчетаСерий.ПолитикаУчетаСерий.ТипПолитики В (ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий), ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.АвторасчетПоFEFOОстатковСерий))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыНаСкладахОстаткиИОбороты.Регистратор,
	|	ТоварыНаСкладахОстаткиИОбороты.Характеристика,
	|	ТоварыНаСкладахОстаткиИОбороты.Номенклатура,
	|	ТоварыНаСкладахОстаткиИОбороты.Серия,
	|	ТоварыНаСкладахОстаткиИОбороты.Склад КАК Получатель,
	|	ТоварыНаСкладахОстаткиИОбороты.Помещение КАК Помещение,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииПриход / ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ КАК Приход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииРасход / ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ КАК Расход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладахОстаткиИОбороты.ВНаличииКонечныйОстаток / ТоварыНаСкладахОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ КАК Остаток,
	|	&ТипПолучателяСклад КАК ТипПолучателя,
	|	ИСТИНА КАК ОстаткиДоступны
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(
	|			,
	|			,
	|			Авто,
	|			,
	|			Номенклатура = &Номенклатура
	|				И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				И (Характеристика = &Характеристика
	|					ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|				И (Серия = &Серия
	|					ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Серия = НЕОПРЕДЕЛЕНО)) КАК ТоварыНаСкладахОстаткиИОбороты
	|
	//++ НЕ УТ
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МатериалыИРаботыВПроизводствеОстаткиИОбороты.Регистратор,
	|	МатериалыИРаботыВПроизводствеОстаткиИОбороты.Характеристика,
	|	МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура,
	|	МатериалыИРаботыВПроизводствеОстаткиИОбороты.Серия,
	|	МатериалыИРаботыВПроизводствеОстаткиИОбороты.Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка),
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоПриход / МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоРасход / МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыИРаботыВПроизводствеОстаткиИОбороты.КоличествоКонечныйОстаток / МатериалыИРаботыВПроизводствеОстаткиИОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ,
	|	&ТипПолучателяПодразделение,
	|	ИСТИНА
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.ОстаткиИОбороты(
	|			,
	|			,
	|			Авто,
	|			,
	|			Номенклатура = &Номенклатура
	|				И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				И (Характеристика = &Характеристика
	|					ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|				И (Серия = &Серия
	|					ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Серия = НЕОПРЕДЕЛЕНО)) КАК МатериалыИРаботыВПроизводствеОстаткиИОбороты
	//-- НЕ УТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвиженияСерийТоваровОбороты.Документ,
	|	ДвиженияСерийТоваровОбороты.Характеристика,
	|	ДвиженияСерийТоваровОбороты.Номенклатура,
	|	ДвиженияСерийТоваровОбороты.Серия,
	|	ДвиженияСерийТоваровОбороты.Получатель,
	|	ДвиженияСерийТоваровОбороты.ПомещениеПолучателя,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваровОбороты.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваровОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваровОбороты.КоличествоОборот / ДвиженияСерийТоваровОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ,
	|	0,
	|	0,
	|	ВЫБОР
	|		КОГДА ДвиженияСерийТоваровОбороты.Получатель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваровОбороты.Получатель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ,
	|	ЛОЖЬ
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			ЭтоСкладскоеДвижение
	|				И Номенклатура = &Номенклатура
	|				И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				И (Характеристика = &Характеристика
	|					ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|				И (Серия = &Серия
	|					ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Серия = НЕОПРЕДЕЛЕНО)
	|				И ((Номенклатура, Получатель) В
	|						(ВЫБРАТЬ
	|							НоменклатураПоКоторойНеВедутсяОстатки.Ссылка,
	|							НоменклатураПоКоторойНеВедутсяОстатки.Склад
	|						ИЗ
	|							НоменклатураПоКоторойНеВедутсяОстатки)
	|					ИЛИ Получатель ССЫЛКА Справочник.Партнеры
	|						И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКлиенту), ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаВРозницу)))) КАК ДвиженияСерийТоваровОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвиженияСерийТоваровОбороты.Документ,
	|	ДвиженияСерийТоваровОбороты.Характеристика,
	|	ДвиженияСерийТоваровОбороты.Номенклатура,
	|	ДвиженияСерийТоваровОбороты.Серия,
	|	ДвиженияСерийТоваровОбороты.Отправитель,
	|	ДвиженияСерийТоваровОбороты.ПомещениеОтправителя,
	|	0,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваровОбороты.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваровОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваровОбороты.КоличествоОборот / ДвиженияСерийТоваровОбороты.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ,
	|	0,
	|	ВЫБОР
	|		КОГДА ДвиженияСерийТоваровОбороты.Отправитель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваровОбороты.Отправитель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ,
	|	ЛОЖЬ
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			ЭтоСкладскоеДвижение
	|				И Номенклатура = &Номенклатура
	|				И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				И (Характеристика = &Характеристика
	|					ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|				И (Серия = &Серия
	|					ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|					ИЛИ &Серия = НЕОПРЕДЕЛЕНО)
	|				И ((Номенклатура, Отправитель) В
	|						(ВЫБРАТЬ
	|							НоменклатураПоКоторойНеВедутсяОстатки.Ссылка,
	|							НоменклатураПоКоторойНеВедутсяОстатки.Склад
	|						ИЗ
	|							НоменклатураПоКоторойНеВедутсяОстатки)
	|					ИЛИ Отправитель ССЫЛКА Справочник.Партнеры
	|						И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента)))) КАК ДвиженияСерийТоваровОбороты";

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
