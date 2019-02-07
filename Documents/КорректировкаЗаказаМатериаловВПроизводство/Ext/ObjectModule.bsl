﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверкиКоличества = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверкиКоличества.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыПроверкиКоличества.УсловиеОтбораСтрокДляОкругления = "МатериалыИУслуги.ЗаказатьНаСклад = ИСТИНА";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества);
	
	ПараметрыПроверкиХарактеристик = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверкиХарактеристик.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверкиХарактеристик);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПроизводство),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыОкругления.УсловиеОтбораСтрокДляОкругления = "МатериалыИУслуги.ЗаказатьНаСклад = ИСТИНА";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	ЗаполнитьНовыйКодСтроки();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.КорректировкаЗаказаМатериаловВПроизводство.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаказыСервер.ОтразитьГрафикОтгрузкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказовРаботами(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьЗаказыМатериаловВПроизводство(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьЗаказыМатериаловСУчетомКорректировок(ДополнительныеСвойства, Движения, Отказ);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	// Всегда выполняется контроль.
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	Массив.Добавить(Движения.ЗаказыМатериаловСУчетомКорректировок);
	Массив.Добавить(Движения.ЗаказыМатериаловВПроизводство);

	// Контроль выполняется при перепроведении, отмене проведения или если используются серии, чтобы проверить возможность резервирования серий
	Если Не ДополнительныеСвойства.ЭтоНовый
		Или ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыСклад", Новый Структура()) Тогда
		Массив.Добавить(Движения.ТоварыКОтгрузке);
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.СвободныеОстатки);
		Массив.Добавить(Движения.ГрафикОтгрузкиТоваров);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ЗаполнитьНовыйКодСтроки() Экспорт

	СтруктураПоиска = Новый Структура("КодСтроки", 0);
	СтрокиСПустымКодом = МатериалыИУслуги.НайтиСтроки(СтруктураПоиска);
	Если СтрокиСПустымКодом.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("Документ.КорректировкаЗаказаМатериаловВПроизводство");
	ЭлементБлокировки.УстановитьЗначение("Распоряжение", Распоряжение);
	
	ЭлементБлокировки = Блокировка.Добавить("Документ.ЗаказНаПроизводство");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", Распоряжение);
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.КодСтроки), 0) КАК КодСтроки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки КАК КодСтроки
	|	ИЗ
	|		Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|	ГДЕ
	|		ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = &Распоряжение
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировкаЗаказаМатериаловВПроизводство.МаксимальныйКодСтроки
	|	ИЗ
	|		Документ.КорректировкаЗаказаМатериаловВПроизводство КАК КорректировкаЗаказаМатериаловВПроизводство
	|	ГДЕ
	|		КорректировкаЗаказаМатериаловВПроизводство.Распоряжение = &Распоряжение) КАК ВложенныйЗапрос";
	
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	МаксимальныйКодСтроки = Выборка.КодСтроки;
	
	Для каждого ДанныеСтроки Из СтрокиСПустымКодом Цикл
		МаксимальныйКодСтроки = МаксимальныйКодСтроки + 1;
		ДанныеСтроки.КодСтроки = МаксимальныйКодСтроки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
