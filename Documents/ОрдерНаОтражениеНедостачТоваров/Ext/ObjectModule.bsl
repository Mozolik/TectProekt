﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
    
	Если СкладыСервер.ИспользоватьАдресноеХранение(Склад,Помещение,Дата) Тогда
		ПроверитьБлокировкуЯчеек(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаОтражениеНедостачТоваров));

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьОрдерныйСклад(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ОрдерНаОтражениеНедостачТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);	
	
	СкладыСервер.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	Если Не СкладыСервер.ИспользоватьАдресноеХранение(Склад,Помещение,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Ячейка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
	ИначеЕсли Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		ТекстСообщения = НСтр("ru='В настройках программы не включено использование упаковок номенклатуры, 
        |поэтому нельзя оформить документ по складу с адресным хранением остатков. Обратитесь к администратору'
        |;uk='У настройках програми не включено використання упаковок номенклатури, 
        |тому не можна оформити документ по складу з адресним зберіганням залишків. Зверніться до адміністратора'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ)
	КонецЕсли;
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Помещение");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаОтражениеНедостачТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, Дата, "ПриОтраженииИзлишковНедостач", Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьБлокировкуЯчеек(Отказ)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БлокировкиСкладскихЯчеек");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ячейка", "Ячейка");
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БлокировкиСкладскихЯчеек.Ячейка КАК Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки КАК ТипБлокировки
	|ИЗ
	|	РегистрСведений.БлокировкиСкладскихЯчеек КАК БлокировкиСкладскихЯчеек
	|ГДЕ
	|	БлокировкиСкладскихЯчеек.Ячейка В (&МассивЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	БлокировкиСкладскихЯчеек.Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ячейка";
	
	Запрос.УстановитьПараметр("МассивЯчеек", Товары.ВыгрузитьКолонку("Ячейка"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru='Ячейка %Ячейка% заблокирована: тип блокировки ""%ТипБлокировки%""';uk='Комірка %Ячейка% заблокована: тип блокування ""%ТипБлокировки%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ячейка%", Выборка.Ячейка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипБлокировки%", Выборка.ТипБлокировки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ПроверитьОрдерныйСклад(Отказ)
	
	Если НЕ СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад, Дата) Тогда
		
		Отказ = Истина;
		ТекстСообщения = НСтр("ru='На складе ""%Склад%"" на %Дата% не используется ордерная схема при отражении излишков, недостач и порчи.';uk='На складі ""%Склад%"" на %Дата% не використовується ордерна схема при відображенні надлишків, нестач і псування.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",Склад);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Дата%",Формат(Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли