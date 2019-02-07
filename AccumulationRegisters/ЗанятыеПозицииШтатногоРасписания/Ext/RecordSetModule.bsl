﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Пропустить = Ложь;
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ПропуститьОбновлениеУсловныхДвижений", Пропустить) И Пропустить Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТекущийНабор.Период КАК Период,
	|	ТекущийНабор.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
	|	ТекущийНабор.КоличествоСтавок КАК КоличествоСтавок,
	|	ТекущийНабор.Сотрудник КАК Сотрудник,
	|	ТекущийНабор.УсловноеДвижение КАК УсловноеДвижение,
	|	ТекущийНабор.ДатаОтменыУсловногоДвижения КАК ДатаОтменыУсловногоДвижения,
	|	ТекущийНабор.ВидДвижения КАК ВидДвижения
	|ПОМЕСТИТЬ ВТТекущийНабор
	|ИЗ
	|	&ТекущийНабор КАК ТекущийНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПредыдущийНабор.Сотрудник КАК Сотрудник,
	|	ПредыдущийНабор.Период КАК Период,
	|	ПредыдущийНабор.ДатаОтменыУсловногоДвижения КАК ДатаОтменыУсловногоДвижения,
	|	ПредыдущийНабор.УсловноеДвижение КАК УсловноеДвижение
	|ПОМЕСТИТЬ ВТНаборРегистратора
	|ИЗ
	|	РегистрНакопления.ЗанятыеПозицииШтатногоРасписания КАК ПредыдущийНабор
	|ГДЕ
	|	ПредыдущийНабор.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПредыдущийНабор.Сотрудник КАК Сотрудник,
	|	ПредыдущийНабор.Период КАК Период,
	|	ПредыдущийНабор.ДатаОтменыУсловногоДвижения КАК ДатаОтменыУсловногоДвижения,
	|	ИСТИНА КАК УдаляемаяЗапись
	|ПОМЕСТИТЬ ВТИзмененныеПозиции
	|ИЗ
	|	ВТНаборРегистратора КАК ПредыдущийНабор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТекущийНабор.Сотрудник,
	|	ТекущийНабор.Период,
	|	ТекущийНабор.ДатаОтменыУсловногоДвижения,
	|	ЛОЖЬ
	|ИЗ
	|	ВТТекущийНабор КАК ТекущийНабор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНаборРегистратора КАК ПредыдущийНабор
	|		ПО ТекущийНабор.Период = ПредыдущийНабор.Период
	|			И ТекущийНабор.Сотрудник = ПредыдущийНабор.Сотрудник
	|			И ТекущийНабор.УсловноеДвижение = ПредыдущийНабор.УсловноеДвижение
	|			И ТекущийНабор.ДатаОтменыУсловногоДвижения = ПредыдущийНабор.ДатаОтменыУсловногоДвижения
	|ГДЕ
	|	ПредыдущийНабор.Сотрудник ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДругиеНаборы.Регистратор КАК Регистратор,
	|	ДругиеНаборы.НомерСтроки,
	|	ДругиеНаборы.УсловноеКоличествоСтавок,
	|	ВЫБОР
	|		КОГДА ИзмененныеПозиции.УдаляемаяЗапись
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОчисткаРесурса
	|ИЗ
	|	ВТИзмененныеПозиции КАК ИзмененныеПозиции
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗанятыеПозицииШтатногоРасписания КАК ДругиеНаборы
	|		ПО (ДругиеНаборы.Период > ИзмененныеПозиции.Период)
	|			И (ДругиеНаборы.ДатаОтменыУсловногоДвижения < ИзмененныеПозиции.Период)
	|			И (ДругиеНаборы.Сотрудник = ИзмененныеПозиции.Сотрудник)
	|ГДЕ
	|	ДругиеНаборы.Регистратор <> &Регистратор
	|	И ДругиеНаборы.УсловноеДвижение
	|ИТОГИ ПО
	|	Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущийНабор.Период КАК Период,
	|	ТекущийНабор.Сотрудник КАК Сотрудник
	|ИЗ
	|	ВТТекущийНабор КАК ТекущийНабор
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗанятыеПозицииШтатногоРасписания КАК ДругиеНаборы
	|		ПО (ДругиеНаборы.Период > ТекущийНабор.ДатаОтменыУсловногоДвижения)
	|			И (ДругиеНаборы.Период < ТекущийНабор.Период)
	|			И (ДругиеНаборы.Сотрудник = ТекущийНабор.Сотрудник)
	|ГДЕ
	|	ДругиеНаборы.Регистратор <> &Регистратор
	|	И НЕ ДругиеНаборы.УсловноеДвижение
	|	И ТекущийНабор.УсловноеДвижение");
	Запрос.УстановитьПараметр("ТекущийНабор", ЭтотОбъект);
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	// Перепишем движения других регистраторов.
	Выборка = Результаты[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыНакопления.ЗанятыеПозицииШтатногоРасписания.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		НаборЗаписей.Прочитать();
		ВыборкаНомеровСтрок = Выборка.Выбрать();
		Пока ВыборкаНомеровСтрок.Следующий() Цикл
			Если ВыборкаНомеровСтрок.ОчисткаРесурса Тогда
				НаборЗаписей[ВыборкаНомеровСтрок.НомерСтроки - 1].КоличествоСтавок = 0;
			Иначе
				НаборЗаписей[ВыборкаНомеровСтрок.НомерСтроки - 1].КоличествоСтавок = ВыборкаНомеровСтрок.УсловноеКоличествоСтавок;
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьОбновлениеУсловныхДвижений", Истина);
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		НаборЗаписей.Записать();
	КонецЦикла;
	
	// Обнулим ресурс в текущем объекте.
	Выборка = Результаты[4].Выбрать();
	Пока Выборка.Следующий() Цикл
		Для Каждого Строка Из ЭтотОбъект Цикл
			Если Строка.Сотрудник = Выборка.Сотрудник И Строка.Период = Выборка.Период И Строка.УсловноеДвижение Тогда
				Строка.КоличествоСтавок = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли