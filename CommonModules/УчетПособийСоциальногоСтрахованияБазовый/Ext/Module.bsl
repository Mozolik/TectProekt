﻿#Область СлужебныйПрограммныйИнтерфейс


// Возвращает массив ссылок из ПВР Начисления, соответствующих облагаемым взносами компенсациям, возмещаемым из бюджета ФСС 
// (в частности, оплата 4-х дополнительных выходных дней для ухода за детьми инвалидами).
//
// Параметры:
//	нет
// 
// Возвращаемое значение:
//	Массив
// 
Функция НачисленияОблагаемыхВзносамиПособий() Экспорт

	Возврат Новый Массив()
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТДанныеОЗаработкеДляЗаполнения(МенеджерВременныхТаблиц, ПараметрыЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗаполнения.Сотрудник, "ФизическоеЛицо"));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(ПараметрыЗаполнения.Организация));
	Запрос.УстановитьПараметр("ОграничиватьРазмерЗаработка", ПараметрыЗаполнения.ОграничиватьРазмерЗаработка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ФизическоеЛицо КАК ФизическоеЛицо,
		|	&ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ПОМЕСТИТЬ ВТФизЛицаОрганизаций";
		
	Запрос.Выполнить();
	
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ГОД(СведенияОДоходах.Период) КАК РасчетныйГод,
		|	СУММА(СведенияОДоходах.БазаФСС - СведенияОДоходах.СуммаПревысившаяПределФСС) КАК Заработок
		|ПОМЕСТИТЬ ВТДанныеОЗаработкеБезОграничения
		|ИЗ
		|	ВТРасширенныеСведенияОДоходах КАК СведенияОДоходах
		|ГДЕ
		|	&ОтборПоОрганизации
		|
		|СГРУППИРОВАТЬ ПО
		|	ГОД(СведенияОДоходах.Период)
		|
		|ИМЕЮЩИЕ
		|	СУММА(СведенияОДоходах.БазаФСС - СведенияОДоходах.СуммаПревысившаяПределФСС) <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеОЗаработке.РасчетныйГод,
		|	СУММА(ВЫБОР
		|			КОГДА ДанныеОЗаработке.Заработок >= ПредельнаяВеличинаБазыСтраховыхВзносов.РазмерФСС
		|					И &ОграничиватьРазмерЗаработка
		|				ТОГДА ПредельнаяВеличинаБазыСтраховыхВзносов.РазмерФСС
		|			ИНАЧЕ ДанныеОЗаработке.Заработок
		|		КОНЕЦ) КАК Заработок
		|ПОМЕСТИТЬ ВТДанныеОЗаработкеДляЗаполнения
		|ИЗ
		|	(ВЫБРАТЬ
		|		МАКСИМУМ(ПредельнаяВеличинаБазыСтраховыхВзносов.Период) КАК Период,
		|		ДанныеОЗаработке.РасчетныйГод КАК РасчетныйГод,
		|		ДанныеОЗаработке.Заработок КАК Заработок
		|	ИЗ
		|		ВТДанныеОЗаработкеБезОграничения КАК ДанныеОЗаработке
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов КАК ПредельнаяВеличинаБазыСтраховыхВзносов
		|			ПО (ДанныеОЗаработке.РасчетныйГод >= ГОД(ПредельнаяВеличинаБазыСтраховыхВзносов.Период))
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеОЗаработке.РасчетныйГод,
		|		ДанныеОЗаработке.Заработок) КАК ДанныеОЗаработке
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов КАК ПредельнаяВеличинаБазыСтраховыхВзносов
		|		ПО ДанныеОЗаработке.Период = ПредельнаяВеличинаБазыСтраховыхВзносов.Период
		|ГДЕ
		|	ДанныеОЗаработке.РасчетныйГод В(&РасчетныеГоды)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеОЗаработке.РасчетныйГод";
	
	Если ПараметрыЗаполнения.ПоВсемОП Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОтборПоОрганизации","Истина");
	Иначе		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОтборПоОрганизации","СведенияОДоходах.Организация = &Организация");
		Запрос.УстановитьПараметр("Организация", ПараметрыЗаполнения.Организация);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.РасчетныеГоды = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеОЗаработке.РасчетныйГод В(&РасчетныеГоды)", "ИСТИНА");	
	Иначе
		Запрос.УстановитьПараметр("РасчетныеГоды", ПараметрыЗаполнения.РасчетныеГоды);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса; 
	
	Запрос.Выполнить();
	
КонецПроцедуры

#Область ПолучениеДанныхДляРасчетаСреднегоЗаработкаПоДокументу

// Создает временную таблицу с реквизитами документов необходимыми для формирования
// структуры параметров расчета среднего заработка ФСС
//
// Параметры:
//  МенеджерВременныхТаблиц	 - менеджер временных таблиц, куда будет помещена временная таблица ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС 
//  МассивСсылок			 - массив ссылок, по которым необходимо получить данные, допустимые типы элементов - "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
//
Процедура СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);

	Запрос.Текст =   
	"ВЫБРАТЬ
	|	БольничныйЛист.Ссылка,
	|	БольничныйЛист.Сотрудник,
	|	БольничныйЛист.ДатаНачалаСобытия КАК ДатаНачалаСобытия,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ТравмаНаПроизводстве)
	|				ИЛИ БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.Профзаболевание)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПрименятьПредельнуюВеличину,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ПоБеременностиИРодам)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьДниБолезниУходаЗаДетьми,
	|	БольничныйЛист.ПериодРасчетаСреднегоЗаработкаПервыйГод,
	|	БольничныйЛист.ПериодРасчетаСреднегоЗаработкаВторойГод,
	|	БольничныйЛист.РайонныйКоэффициентРФНаНачалоСобытия КАК РайонныйКоэффициентРФ
	|ПОМЕСТИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|ГДЕ
	|	БольничныйЛист.Ссылка В(&МассивСсылок)";	
	
	Запрос.Выполнить();
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ");
	ОписаниеФильтра.СоответствиеИзмеренийРегистраИзмерениямФильтра.Вставить("Период", "ДатаНачалаСобытия");

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"МинимальнаяОплатаТрудаРФ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		,
		"ВТМинимальнаяОплатаТруда");
		
	Запрос.Текст =   
	"ВЫБРАТЬ
	|	ДанныеДокументаРасчетаСреднего.Ссылка,
	|	ДанныеДокументаРасчетаСреднего.Сотрудник,
	|	ДанныеДокументаРасчетаСреднего.ДатаНачалаСобытия,
	|	ДанныеДокументаРасчетаСреднего.ПрименятьПредельнуюВеличину,
	|	ДанныеДокументаРасчетаСреднего.ИспользоватьДниБолезниУходаЗаДетьми,
	|	ДанныеДокументаРасчетаСреднего.ПериодРасчетаСреднегоЗаработкаПервыйГод,
	|	ДанныеДокументаРасчетаСреднего.ПериодРасчетаСреднегоЗаработкаВторойГод,
	|	ДанныеДокументаРасчетаСреднего.РайонныйКоэффициентРФ,
	|	МинимальнаяОплатаТруда.Размер КАК МинимальныйРазмерОплатыТрудаРФ
	|ПОМЕСТИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС
	|ИЗ
	|	ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ КАК ДанныеДокументаРасчетаСреднего
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТМинимальнаяОплатаТруда КАК МинимальнаяОплатаТруда
	|		ПО ДанныеДокументаРасчетаСреднего.ДатаНачалаСобытия = МинимальнаяОплатаТруда.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТМинимальнаяОплатаТруда";	
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Функция - Таблицы данных среднего заработка ФСС
//
// Параметры:
//  ИмяДокумента - Строка, имя документа для которого надо получить данные для расчета среднего заработка
//  МассивСсылок - массив, "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
// 
// Возвращаемое значение:
//  ДанныеДляРасчета - структура, содержит поля с таблицами данных для расчета среднего заработка по МассивСсылок 
//					ДанныеОНачислениях, Таблица значений	
//					ДанныеОВремени, Таблица значений	
//					ДанныеСтрахователей, Таблица значений	
//
Функция ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СреднийЗаработокФСС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетаСреднегоЗаработкаФСС.Постановление2011) КАК ПорядокРасчета,
	|	СреднийЗаработокФСС.ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
	|	СреднийЗаработокФСС.Период,
	|	СреднийЗаработокФСС.Сумма
	|ИЗ
	|	Документ.#ИмяДокумента#.СреднийЗаработокФСС КАК СреднийЗаработокФСС
	|ГДЕ
	|	СреднийЗаработокФСС.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтработанноеВремяДляСреднегоФСС.Ссылка,
	|	ОтработанноеВремяДляСреднегоФСС.ФизическоеЛицо,
	|	ОтработанноеВремяДляСреднегоФСС.Период,
	|	ОтработанноеВремяДляСреднегоФСС.ДнейБолезниУходаЗаДетьми
	|ИЗ
	|	Документ.#ИмяДокумента#.ОтработанноеВремяДляСреднегоФСС КАК ОтработанноеВремяДляСреднегоФСС
	|ГДЕ
	|	ОтработанноеВремяДляСреднегоФСС.Ссылка В(&МассивСсылок)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяДокумента#", ИмяДокумента);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДанныеОНачислениях 	= Результат[0].Выгрузить();
	ДанныеВремени 		= Результат[1].Выгрузить();
	ДанныеСтрахователей	= УчетПособийСоциальногоСтрахования.ПустаяТаблицаДанныеСтрахователейСреднийЗаработокФСС();
	
	ДанныеДляРасчета 	= Новый Структура("ДанныеОНачислениях,ДанныеОВремени,ДанныеСтрахователей", ДанныеОНачислениях, ДанныеВремени, ДанныеСтрахователей);
	
	Возврат ДанныеДляРасчета;
	
КонецФункции 

Функция ОписаниеТипаСтраховательСреднийЗаработокФСС() Экспорт
	Возврат Новый ОписаниеТипов("СправочникСсылка.Организации");
КонецФункции 

#КонецОбласти 

#КонецОбласти

