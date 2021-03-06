﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.ДекорацияПериодПоискаАссоциацийОписание.Заголовок = ОписаниеНастройки(
		Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
		Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
	
		Элементы.НастроитьРасписание.Видимость = Ложь;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	Элементы.ДекорацияПериодПоискаАссоциацийОписание.Заголовок = ОписаниеНастройки(
		Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
		Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовПриИзменении(Элемент)
	
	Элементы.ДекорацияПериодПоискаАссоциацийОписание.Заголовок = ОписаниеНастройки(
		Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
		Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	Идентификатор = ПолучитьИдентификаторРегламетногоЗадания();
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписаниеРегламентногоЗадания(Идентификатор));
	Диалог.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, Новый Структура("Идентификатор", Идентификатор)));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Идентификатор = ДополнительныеПараметры.Идентификатор;
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Расписание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторРегламетногоЗадания()
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ОбновлениеНоменклатурыПродаваемойСовместно);
	Возврат РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеНастройки(Период, КоличествоПериодов, Подпериод = Неопределено)
	
	ПредставлениеНастройки = "";
	
	Если НЕ ЗначениеЗаполнено(КоличествоПериодов) ИЛИ НЕ ЗначениеЗаполнено(Период) Тогда
		
		Возврат ПредставлениеНастройки;
		
	КонецЕсли;
	
	ПредставлениеНастройки = НСтр("ru='По данным за период:';uk='За даними за період:'") + " ";
	
	ПараметрыПредметаИсчисления = "";
	
	Если Период = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий день, предыдущих дня, предыдущих дней, м,,,,, 0';uk='попередній день, попереднього дня, попередніх днів, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущая неделя, предыдущие недели, предыдущих недель, ж,,,,, 0';uk='попередній тиждень, попередні тижні, попередніх тижнів, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущая декада, предыдущие декады, предыдущих декад, ж,,,,, 0';uk='попередня декада, попередні декади, попередніх декад, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий месяц, предыдущих месяца, предыдущих месяцев, м,,,,, 0';uk='попередній місяць, попереднього місяця, попередніх місяців, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий квартал, предыдущих квартала, предыдущих кварталов, м,,,,, 0';uk='попередній квартал, попереднього квартала, попередніх кварталів, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущее полугодие, предыдущих полугодия, предыдущих полугодий, с,,,,, 0';uk='попереднє півріччя, попереднього півріччя, попередніх піврічь, з,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru='предыдущий год, предыдущих года, предыдущих лет, м,,,,, 0';uk='попередній рік, попереднього року, попередніх років, м,,,,, 0'");
		
	Иначе
		
		ПараметрыПредметаИсчисления = "";
		
	КонецЕсли;
	
	ПредставлениеНастройки = ПредставлениеНастройки + НРег(ЧислоПрописью(КоличествоПериодов,, ПараметрыПредметаИсчисления));
	
	Возврат ПредставлениеНастройки;
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Знач Расписание)
	
	ПараметрыЗадания = Новый Структура("Расписание", Расписание);
	РегламентныеЗаданияСервер.ИзменитьЗадание(Идентификатор, ПараметрыЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРасписаниеРегламентногоЗадания(Идентификатор)
	
	Задание = РегламентныеЗаданияСервер.Задание(Идентификатор);
	Возврат Задание.Расписание;
	
КонецФункции

#КонецОбласти

#КонецОбласти
