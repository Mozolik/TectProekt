﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


	Документы.ПриходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);

	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыемкаДенежныхСредствИзКассыККМ) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ВыемкаДенежныхСредствИзКассыККМ.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ВыемкаДенежныхСредствИзКассыККМ);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта
	|ИЗ
	|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Валюта", Реквизиты.Валюта);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Запрос.Параметры.Валюта,
																			,
																			Запрос.Параметры.Период);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",  Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныхСредств(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВКассахККМ";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.КассаККМ               КАК КассаККМ,
	|	ДанныеДокумента.СуммаДокумента         КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК СуммаУпр,
	|	0                                      КАК КПоступлениюВКассуОрганизации
	|	
	|ИЗ
	|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента <> 0
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.КассаККМ               КАК КассаККМ,
	|	0 КАК Сумма,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаУпр,
	|	ДанныеДокумента.СуммаДокумента         КАК КПоступлениюВКассуОрганизации
	|	
	|ИЗ
	|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныхСредств(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныхСредств";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	Значение(Перечисление.ХозяйственныеОперации.ВыемкаДенежныхСредствИзКассыККМ) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|   ДанныеДокумента.КассаККМ.Подразделение КАК Подразделение,
	|
	|	ДанныеДокумента.КассаККМ КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|
	|	НЕОПРЕДЕЛЕНО КАК КорДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваВПути) КАК КорТипДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК КорВалюта,
	|
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаВВалюте,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаВКорВалюте,
	|
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникКорГФУДенежныхСредств
	|ИЗ
	|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
