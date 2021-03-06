﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбновлениеИнформационнойБазы


// Обработчик обновления BAS УТ 3.2.2
// Процедура заполняет реквизиты ОграничиватьПоВесу и ОграничиватьПоОбъему 
Процедура ЗаполнитьВариантПереупаковкиВПустуюУпаковку() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Ссылка,
	|	УпаковкиНоменклатуры.Числитель/УпаковкиНоменклатуры.Знаменатель КАК Коэффициент
	|ПОМЕСТИТЬ УпаковкиДляОбработки
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыПереупаковки КАК ВариантыПереупаковки
	|		ПО (ВариантыПереупаковки.Источник = УпаковкиНоменклатуры.Ссылка)
	|			И (ВариантыПереупаковки.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка))
	|ГДЕ
	|	УпаковкиНоменклатуры.Знаменатель <> 0
	|	И УпаковкиНоменклатуры.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка) 
	|	И ВариантыПереупаковки.Источник ЕСТЬ NULL 
	|	И (УпаковкиНоменклатуры.Владелец.ЕдиницаИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Вес)
	|	ИЛИ УпаковкиНоменклатуры.Владелец.ЕдиницаИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Объем)
	|	ИЛИ УпаковкиНоменклатуры.Владелец.ЕдиницаИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Площадь)
	|	ИЛИ УпаковкиНоменклатуры.Владелец.ЕдиницаИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Длина))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УпаковкиДляОбработки.Ссылка КАК Ссылка,
	|	УпаковкиДляОбработки.Коэффициент,
	|	ВариантыПереупаковки.МаксимальнаяУпаковкаВВетви
	|ИЗ
	|	УпаковкиДляОбработки КАК УпаковкиДляОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыПереупаковки КАК ВариантыПереупаковки
	|		ПО УпаковкиДляОбработки.Ссылка = ВариантыПереупаковки.Упаковка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Набор = РегистрыСведений.ВариантыПереупаковки.СоздатьНаборЗаписей();
        
		Набор.Отбор.Упаковка.Установить(Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
		Набор.Отбор.Источник.Установить(Выборка.Ссылка);
		Набор.Отбор.МаксимальнаяУпаковкаВВетви.Установить(Выборка.МаксимальнаяУпаковкаВВетви);
        
		НоваяСтрока = Набор.Добавить();
		НоваяСтрока.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		НоваяСтрока.Источник = Выборка.Ссылка;
		НоваяСтрока.МаксимальнаяУпаковкаВВетви = Выборка.МаксимальнаяУпаковкаВВетви;
		НоваяСтрока.Количество = Выборка.Коэффициент;
        
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		
	КонецЦикла;
	
КонецПроцедуры



Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = "РегистрСведений.ВариантыПереупаковки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Ссылка КАК МаксимальнаяУпаковкаВВетви
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|ГДЕ
	|	УпаковкиНоменклатуры.Владелец <> &БазовыеЕдиницыИзмерения
	|	И Не УпаковкиНоменклатуры.ПометкаУдаления";
	Запрос.УстановитьПараметр("БазовыеЕдиницыИзмерения", Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения);
	
	Данные = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметрыОтметки);
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Процедура перезаполняет варианты переупаковки. 
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ВариантыПереупаковки";
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуИзмеренийНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяРегистра,
		Запрос.МенеджерВременныхТаблиц);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ВТДляОбработки.МаксимальнаяУпаковкаВВетви КАК Справочник.УпаковкиЕдиницыИзмерения) КАК Ссылка
	|ПОМЕСТИТЬ УпаковкиДляОбработки
	|ИЗ
	|	#ВТДляОбработки КАК ВТДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УпаковкиДляОбработки.Ссылка.Владелец КАК Владелец
	|ПОМЕСТИТЬ ВладельцыУпаковок
	|ИЗ
	|	УпаковкиДляОбработки КАК УпаковкиДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УпаковкиЕдиницыИзмерения.Ссылка КАК МаксимальнаяУпаковкаВВетви,
	|	ВладельцыУпаковок.Владелец КАК Владелец
	|ИЗ
	|	ВладельцыУпаковок КАК ВладельцыУпаковок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|		ПО ВладельцыУпаковок.Владелец = УпаковкиЕдиницыИзмерения.Владелец
	|ИТОГИ ПО
	|	Владелец";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	
	ВыборкаПоВладельцу = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоВладельцу.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			ТаблицаВариантовПереупаковки = Справочники.УпаковкиЕдиницыИзмерения.СформироватьТаблицуВариантовПереупаковкиНаСервере(ВыборкаПоВладельцу.Владелец);
			
			ТЗМаксимальныеУпаковкиВВетви = ТаблицаВариантовПереупаковки.Скопировать(,"МаксимальнаяУпаковкаВВетви");
			ТЗМаксимальныеУпаковкиВВетви.Свернуть("МаксимальнаяУпаковкаВВетви");
			МаксимальныеУпаковкиВВетви = ТЗМаксимальныеУпаковкиВВетви.ВыгрузитьКолонку("МаксимальнаяУпаковкаВВетви");
			
			Для Каждого МаксимальнаяУпаковкаВВетви Из МаксимальныеУпаковкиВВетви Цикл
				Отбор = Новый Структура("МаксимальнаяУпаковкаВВетви", МаксимальнаяУпаковкаВВетви);
				ВариантыПереупаковки = ТаблицаВариантовПереупаковки.Скопировать(Отбор);
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
				ЭлементБлокировки.УстановитьЗначение("МаксимальнаяУпаковкаВВетви", МаксимальнаяУпаковкаВВетви);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				Блокировка.Заблокировать();
				
				Набор = РегистрыСведений.ВариантыПереупаковки.СоздатьНаборЗаписей();
				Набор.Отбор.МаксимальнаяУпаковкаВВетви.Установить(МаксимальнаяУпаковкаВВетви);
				Набор.Прочитать();
				Набор.Загрузить(ВариантыПереупаковки);
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			КонецЦикла;
			
			Выборка = ВыборкаПоВладельцу.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если МаксимальныеУпаковкиВВетви.Найти(Выборка.МаксимальнаяУпаковкаВВетви) = Неопределено Тогда
					НаборЗаписей = РегистрыСведений.ВариантыПереупаковки.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.МаксимальнаяУпаковкаВВетви.Установить(Выборка.МаксимальнаяУпаковкаВВетви);
					НаборЗаписей.Очистить();
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
				КонецЕсли;
			КонецЦикла;
			
			//Очистить записи в регистре по максимальным упаковкам в ветви более неиспользуемым
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВариантыПереупаковки.МаксимальнаяУпаковкаВВетви КАК МаксимальнаяУпаковкаВВетви
			|ИЗ
			|	РегистрСведений.ВариантыПереупаковки КАК ВариантыПереупаковки
			|ГДЕ
			|	НЕ ВариантыПереупаковки.МаксимальнаяУпаковкаВВетви В (&МаксимальнаяУпаковкаВВетви)
			|	И ВариантыПереупаковки.МаксимальнаяУпаковкаВВетви.Владелец = &Владелец";
			Запрос.УстановитьПараметр("МаксимальнаяУпаковкаВВетви", МаксимальныеУпаковкиВВетви);
			Запрос.УстановитьПараметр("Владелец", ВыборкаПоВладельцу.Владелец);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.ВариантыПереупаковки.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.МаксимальнаяУпаковкаВВетви.Установить(Выборка.МаксимальнаяУпаковкаВВетви);
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось расcчитать переупаковку для упаковок по владельцу %Владелец% по причине: %Причина%';uk='Не вдалося розрахувати переупаковку для упаковок по власнику %Владелец% по причині: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Владелец%", ВыборкаПоВладельцу.Владелец);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									Метаданные.РегистрыСведений.ВариантыПереупаковки,
									ВыборкаПоВладельцу.Владелец,
									ТекстСообщения);
									
			Продолжить;
			
		КонецПопытки;
			
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);

КонецПроцедуры


#КонецОбласти

#КонецЕсли