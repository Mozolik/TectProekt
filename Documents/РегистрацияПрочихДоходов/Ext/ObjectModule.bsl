﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "НачисленияУдержанияВзносы.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВсегоВыплачено = НачисленияУдержанияВзносы.Итог("КВыплате");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.РегистрацияПрочихДоходов.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	МесяцНачисления = НачалоМесяца(ПериодРегистрации);
	
	// НДФЛ
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, Организация, ПланируемаяДатаВыплаты, ДанныеДляПроведения.ДанныеДляНДФЛДоходы, Ложь, Ложь);
	УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, Организация, ПланируемаяДатаВыплаты, ДанныеДляПроведения.НДФЛ, Ложь, Ложь);
	
    Если НЕ ВидПрочегоДохода.УдержатьНДФЛИзЗарплаты Тогда
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.Начисления, , ДанныеДляПроведения.НДФЛНачисления);
		УчетНДФЛРасширенный.СформироватьПеречислениеНДФЛПоТаблицеЗначений(Движения, Отказ, Организация, Дата, ДанныеДляПроведения.НДФЛ, Истина, Истина);
	Иначе	
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.Начисления);
		// - регистрация НДФЛ в учете начислений и удержаний
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛПоСотрудникам);
		УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛ(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.НДФЛПоСотрудникам, ДанныеДляПроведения.МенеджерВременныхТаблиц, Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
	КонецЕсли;	
	
	// - Регистрация начислений и удержаний.
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоКонтрагентамАкционерам(
				Движения, Отказ, Организация, МесяцНачисления,
				ДанныеДляПроведения.Начисления,
				Неопределено,
				ДанныеДляПроведения.НДФЛ,
				Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидПрочегоДохода.УдержатьНДФЛИзЗарплаты Тогда
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
		ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= Дата;
		ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= Дата;
		
		КадровыйУчет.ПроверитьРаботающихФизическихЛицПолный(
			НачисленияУдержанияВзносы.ВыгрузитьКолонку("ФизическоеЛицо"),
			ПараметрыПолученияСотрудниковОрганизаций,
			Отказ,
			Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект")
		);
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.РегистрацияПрочихДоходов.СоздатьВТДанныеДокумента(Запрос.МенеджерВременныхТаблиц, Ссылка);
	Документы.РегистрацияПрочихДоходов.СоздатьВТНачисленияДокумента(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, Организация, ПериодРегистрации);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокумента.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НачисленияДокумента.ФизическоеЛицо,
		|	НачисленияДокумента.СтатьяФинансирования,
		|	НачисленияДокумента.СтатьяРасходов
		|ПОМЕСТИТЬ ВТБухучетФизическихЛиц
		|ИЗ
		|	ВТНачисленияДокумента КАК НачисленияДокумента";
		
	Запрос.Выполнить();
	
	ДанныеДляПроведения.Вставить("ДанныеДляНДФЛДоходы", Документы.РегистрацияПрочихДоходов.ДанныеДляПроведениеНДФЛ(Запрос.МенеджерВременныхТаблиц));
	
	ДанныеДляПроведения.Вставить("НДФЛ");
	ДанныеДляПроведения.Вставить("НДФЛПоСотрудникам");
	РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.ФизическоеЛицо,
		|	ДанныеДокумента.Подразделение,
		|	ДанныеДокумента.Сумма,
		|	ДанныеДокумента.Начисление КАК Начисление,
		|	ДанныеДокумента.ДокументОснование,
		|	ДанныеДокумента.СтатьяФинансирования,
		|	ДанныеДокумента.СтатьяРасходов,
		|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете
		|ИЗ
		|	ВТНачисленияДокумента КАК ДанныеДокумента";

	ДанныеДляПроведения.Вставить("Начисления", Запрос.Выполнить().Выгрузить());

	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.ФизическоеЛицо,
		|	ДанныеДокумента.Подразделение,
		|	ДанныеДокумента.НДФЛ КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛДоходыКонтрагентов) КАК НачислениеУдержание,
		|	ДанныеДокумента.Ссылка КАК ДокументОснование,
		|	БухучетФизическихЛиц.СтатьяФинансирования,
		|	БухучетФизическихЛиц.СтатьяРасходов
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБухучетФизическихЛиц КАК БухучетФизическихЛиц
		|		ПО ДанныеДокумента.ФизическоеЛицо = БухучетФизическихЛиц.ФизическоеЛицо";
	
	
	ДанныеДляПроведения.Вставить("НДФЛНачисления", Запрос.Выполнить().Выгрузить());	
	ДанныеДляПроведения.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура РассчитатьНДФЛИВзносыДокумента(СписокФизическихЛиц = Неопределено) Экспорт
	
	НачатьТранзакцию();
	
	Записать(РежимЗаписиДокумента.Запись);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.РегистрацияПрочихДоходов.СоздатьВТДанныеДокумента(Запрос.МенеджерВременныхТаблиц, Ссылка, СписокФизическихЛиц);
	Документы.РегистрацияПрочихДоходов.СоздатьВТНачисленияДокумента(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, Организация, ПериодРегистрации);
	
	// НДФЛ
	ДанныеДляНДФЛ = Документы.РегистрацияПрочихДоходов.ДанныеДляПроведениеНДФЛ(Запрос.МенеджерВременныхТаблиц);
	
	
	// Регистрация доходов для НДФЛ в привилегированном режиме
	УстановитьПривилегированныйРежим(Истина);
	
	Отказ = Ложь;
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(
		Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляНДФЛ, Истина, Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокумента.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента";
	
	Запрос.Выполнить();
	
	РезультатРасчетаНДФЛ = УчетНДФЛ.РезультатРасчетаНДФЛ(Запрос.МенеджерВременныхТаблиц, Неопределено,
		Организация, ПериодРегистрации, Ложь);
	
	
	ОтменитьТранзакцию();
	
	// Перенос в документ результатов расчета НДФЛ
	ФизическиеЛицаПоКоторымОчищалисьДанные = Новый Соответствие;
	МаксимальныйИдентификатор = УчетНДФЛФормы.МаксимальныйИдентификаторСтрокиНДФЛ(НДФЛ);
	Для каждого СтрокаРезультатаРасчетаНДФЛ Из РезультатРасчетаНДФЛ Цикл
		
		Если ФизическиеЛицаПоКоторымОчищалисьДанные.Получить(СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо) = Неопределено Тогда
			УчетНДФЛКлиентСерверРасширенный.УдалитьДанныеНДФЛФизическоголица(ЭтотОбъект, СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо);
			ФизическиеЛицаПоКоторымОчищалисьДанные.Вставить(СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо, Истина);
		КонецЕсли; 
		
		МаксимальныйИдентификатор = МаксимальныйИдентификатор + 1;
		
		НоваяСтрокаНДФЛ = НДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаНДФЛ, СтрокаРезультатаРасчетаНДФЛ);
		НоваяСтрокаНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификатор;
		
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли