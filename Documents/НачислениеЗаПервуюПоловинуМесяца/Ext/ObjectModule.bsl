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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	// Учет начисленной зарплаты
	// - регистрация начислений и удержаний в учете начислений и удержаний
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияАвансом(
	Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, НеОпределено);
	
	// - Регистрация отработанного времени в учете начислений и удержаний.
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьОтработанноеВремяАвансом(
	Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам);	
	
	// - Регистрация НДФЛ в учете начислений и удержаний.
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНДФЛАвансом(
	Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.НДФЛПоСотрудникам, ДанныеДляПроведения.МенеджерВременныхТаблиц);
	
	// - Регистрация НДФЛ для авансов
	УчетНДФЛ.СформироватьИсчисленныйНалогАвансомПоТаблицеЗначений(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.НДФЛПоСотрудникам); 
	
	// - страховые взносы
	УчетСтраховыхВзносов.СформироватьИсчисленныеВзносыАвансом(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.СтраховыеВзносы);
	
	
КонецПроцедуры

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	НачислениеЗаПервуюПоловинуМесяца.Организация,
			|	НачислениеЗаПервуюПоловинуМесяца.Подразделение,
			|	НачислениеЗаПервуюПоловинуМесяца.Начислено,
			|	НачислениеЗаПервуюПоловинуМесяца.Удержано,
			|	НачислениеЗаПервуюПоловинуМесяца.КраткийСоставДокумента,
			|	НачислениеЗаПервуюПоловинуМесяца.Ответственный,
			|	НачислениеЗаПервуюПоловинуМесяца.Комментарий
			|ИЗ
			|	Документ.НачислениеЗаПервуюПоловинуМесяца КАК НачислениеЗаПервуюПоловинуМесяца
			|ГДЕ
			|	НачислениеЗаПервуюПоловинуМесяца.Ссылка = &Ссылка");
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверитьПериодДействияНачислений(Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = ЭтотОбъект.Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Начисления", "Начисления"));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", "Удержания", "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Функция ДанныеДляПроведения()
	
	СписокФизическихЛиц = Неопределено;
	Если ДополнительныеСвойства.Свойство("ФизическиеЛица")
		И ДополнительныеСвойства.ФизическиеЛица.Количество() > 0 Тогда
		
		СписокФизическихЛиц = ДополнительныеСвойства.ФизическиеЛица
		
	КонецЕсли;
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, Ссылка, "Начисления,УдалитьПособия", "Ссылка.МесяцНачисления", , СписокФизическихЛиц);
	РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведения, Ссылка, , СписокФизическихЛиц);
	РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, Ссылка, "Начисления", СписокФизическихЛиц);
	
	РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, Ссылка, СписокФизическихЛиц);
	РасчетЗарплаты.ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, Ссылка, СписокФизическихЛиц);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
