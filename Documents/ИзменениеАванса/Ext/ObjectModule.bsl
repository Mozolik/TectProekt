﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииЗаполненияДокумента

// Заполняет табличную часть сотрудниками, работающими в выбранной организации и подразделении на дату начала изменения аванса
//
// Параметры:
//		РазмерАванса - Число(15,2) - размер аванса, устанавливаемый сотрудникам
//
Процедура ЗаполнитьСотрудников(РазмерАванса = 0) Экспорт
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Организация;
	ПараметрыПолученияСотрудников.Подразделение = Подразделение;
	ПараметрыПолученияСотрудников.НачалоПериода = МесяцИзменения;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = МесяцИзменения;
	
	Сотрудники = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников);
	
	ТаблицаСотрудников = Сотрудники.Скопировать( ,"Сотрудник");
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Ссылка, МесяцИзменения);
	ТаблицаСотрудников.ЗаполнитьЗначения(ВремяРегистрации - 1, "Период");
	
	ДанныеОбАвансе = РасчетЗарплатыРасширенный.АвансыСотрудников(ТаблицаСотрудников);

	АвансыСотрудников.Очистить();
	
	Для Каждого СтрокаСотрудника Из ТаблицаСотрудников Цикл
		
		СтрокиДанныхОбАвансе = ДанныеОбАвансе.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСотрудника.Сотрудник));
		Если СтрокиДанныхОбАвансе.Количество() > 0 Тогда
			
			СтрокаДанныхОбАвансе = СтрокиДанныхОбАвансе[0];
			
			НовыйСотрудник = АвансыСотрудников.Добавить();
			НовыйСотрудник.Сотрудник = СтрокаДанныхОбАвансе.Сотрудник;
			НовыйСотрудник.Аванс = РазмерАванса;
			
		КонецЕсли; 
		
	КонецЦикла
	
КонецПроцедуры

// Устанавливает всем сотрудникам в табличной части документа размер аванса
//
// Параметры:
//		РазмерАванса - Число(15,2) - размер аванса, устанавливаемый сотрудникам
//
Процедура УстановитьАванс(РазмерАванса) Экспорт
	
	Для Каждого АвансСотрудника Из АвансыСотрудников Цикл
		АвансСотрудника.Аванс = РазмерАванса;
	КонецЦикла;
	
КонецПроцедуры

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры
// Подсистема "Управление доступом".

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.ПлановыеАвансы);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= МесяцИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= МесяцИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		АвансыСотрудников.ВыгрузитьКолонки("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.АвансыСотрудников")
	);
	
	Если МесяцИзменения > ПериодОкончания
		И ЗначениеЗаполнено(ПериодОкончания) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Период окончания не может быть меньше периода начала изменения аванса';uk='Період закінчення не може бути менше періоду початку зміни авансу'"), ЭтотОбъект, "ПериодОкончания", ,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИзменениеАвансаАвансыСотрудников.Сотрудник,
	               |	ИзменениеАвансаАвансыСотрудников.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
	               |	ИзменениеАвансаАвансыСотрудников.Ссылка.СпособРасчетаАванса КАК СпособРасчетаАванса,
	               |	ИзменениеАвансаАвансыСотрудников.Аванс КАК Аванс,
	               |	ИзменениеАвансаАвансыСотрудников.Ссылка.МесяцИзменения КАК ДатаСобытия,
	               |	ВЫБОР
	               |		КОГДА ИзменениеАвансаАвансыСотрудников.Ссылка.ПериодОкончания > ДАТАВРЕМЯ(1, 1, 1)
	               |			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеАвансаАвансыСотрудников.Ссылка.ПериодОкончания, МЕСЯЦ, 1)
	               |		ИНАЧЕ ИзменениеАвансаАвансыСотрудников.Ссылка.ПериодОкончания
	               |	КОНЕЦ КАК ДействуетДо
	               |ИЗ
	               |	Документ.ИзменениеАванса.АвансыСотрудников КАК ИзменениеАвансаАвансыСотрудников
	               |ГДЕ
	               |	ИзменениеАвансаАвансыСотрудников.Ссылка.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	АвансыСотрудников.Ссылка.МесяцИзменения КАК ДатаСобытия,
	               |	АвансыСотрудников.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	Документ.ИзменениеАванса.АвансыСотрудников КАК АвансыСотрудников
	               |ГДЕ
	               |	АвансыСотрудников.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();			   
				   
	ДанныеДляПроведения = Новый Структура; 
	
	ПлановыеАвансы = РезультатыЗапроса[0].Выгрузить();
	ДанныеДляПроведения.Вставить("ПлановыеАвансы", ПлановыеАвансы);
	
	СотрудникиДаты = РезультатыЗапроса[1].Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Возврат ДанныеДляПроведения;
КонецФункции

#КонецОбласти

#КонецЕсли
