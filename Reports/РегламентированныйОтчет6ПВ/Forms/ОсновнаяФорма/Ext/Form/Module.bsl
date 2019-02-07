﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура управляет показом в форме периода построения отчета.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)

	Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2012
		И НЕ Форма.мПериодичность = Форма.ПеречислениеПериодичностьМесяц Тогда
	    СтрПериодОтчета = ПредставлениеПериода( НачалоГода(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина; Л="+Локализация.КодЯзыкаИнтерфейса());
	Иначе	
		СтрПериодОтчета = ПредставлениеПериода( НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина; Л="+Локализация.КодЯзыкаИнтерфейса());
	КонецЕсли;
		
	Форма.НадписьПериодСоставленияОтчета = СтрПериодОтчета;

	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);

	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);

КонецПроцедуры // ПоказатьПериод()

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
&НаКлиенте
Процедура ИзменитьПериод(Шаг)

	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьГод Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	ИначеЕсли ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг)); 
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	//ОбработкаПериодичностьОтчета(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);

КонецПроцедуры // ИзменитьПериод()

////&НаКлиентеНаСервереБезКонтекста
////Процедура ОбработкаПериодичностьОтчета(Форма)
////	
////	Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2008 Тогда
////		Если Форма.ПолеВыбораПериодичность <> Форма.ПеречислениеПериодичностьКвартал Тогда
////			// Если текущая периодичность отчета не Квартал, тогда установим Квартал.
////			Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал;
////			// Инициализируем переменную мПериодичность в Квартал.
////			Форма.мПериодичность = Форма.ПолеВыбораПериодичность;
////			// Обновим данные по датам начала и конца отчета.
////			Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(Форма.мДатаКонцаПериодаОтчета);
////			Форма.мДатаНачалаПериодаОтчета = НачалоКвартала(Форма.мДатаКонцаПериодаОтчета);
////		КонецЕсли;
////		Форма.Элементы.ПолеВыбораПериодичность.Доступность = Ложь;
////	Иначе
////		Форма.Элементы.ПолеВыбораПериодичность.Доступность = Истина;
////	КонецЕсли;
////		
////КонецПроцедуры

&НаКлиенте
Функция ПолучитьФормуДляПериода(НаДату)
	
	Для Каждого Строка Из мТаблицаФормОтчета Цикл
		Если (Строка.ДатаНачалоДействия > КонецДня(НаДату)) ИЛИ
			((Строка.ДатаКонецДействия > '00010101000000') И (Строка.ДатаКонецДействия < НачалоДня(НаДату))) Тогда

			Продолжить;
		КонецЕсли;

		мВыбраннаяФорма = Строка.ФормаОтчета;
		
		Возврат мВыбраннаяФорма;
	КонецЦикла;

	// Если не удалось найти форму, соответствующую выбранному периоду,
	// то по умолчанию выдаем текущую (действующую) форму.
	Если мВыбраннаяФорма = Неопределено Тогда
		мВыбраннаяФорма = мТаблицаФормОтчета[0].ФормаОтчета;
	КонецЕсли;
	
	Возврат мВыбраннаяФорма;
	
КонецФункции // ПолучитьФормуДляПериода()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере                                
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	Если Найти(ИсточникОтчета, "Внешний") > 0 Тогда 
		ИсточникОтчета = СтрЗаменить(ИсточникОтчета, "Внешний", "");
		ОтчетОбъект = ВнешниеОтчеты.Создать(ИсточникОтчета);
	Иначе
		ОтчетОбъект = Отчеты[ИсточникОтчета];
	КонецЕсли;
	
	
	
	ЗначениеВДанныеФормы(ОтчетОбъект.ТаблицаФормОтчета(), мТаблицаФормОтчета);
	
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год);
    		
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;

	ОргПоУмолчанию       = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	ПеречислениеПериодичностьГод 	 = Перечисления.Периодичность.Год;

	Если НЕ ЗначениеЗаполнено(мПериодичность) ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		мПериодичность = ПеречислениеПериодичностьГод;
	КонецЕсли;

	// Устнавливаем границы периода построения отчета как Месяц
	Если мПериодичность = ПеречислениеПериодичностьМесяц Тогда
	
		Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
			
			мДатаКонцаПериодаОтчета  = КонецМесяца(ТекущаяДатаСеанса());
			мДатаНачалаПериодаОтчета = НачалоМесяца(ТекущаяДатаСеанса());
			
		КонецЕсли;
		
	ИначеЕсли  мПериодичность = ПеречислениеПериодичностьКвартал Тогда
	
		Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
			
			мДатаКонцаПериодаОтчета  = КонецКвартала(ТекущаяДатаСеанса());
			мДатаНачалаПериодаОтчета = КонецКвартала(ТекущаяДатаСеанса());
			
		КонецЕсли;
		
	ИначеЕсли  мПериодичность = ПеречислениеПериодичностьГод Тогда
	
		Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
			
			мДатаКонцаПериодаОтчета  = КонецГода(ТекущаяДатаСеанса());
			мДатаНачалаПериодаОтчета = НачалоГода(ТекущаяДатаСеанса());
			
		КонецЕсли;
	
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
	//ОбработкаПериодичностьОтчета(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);


	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры // ПередЗакрытием()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьМесяц Тогда
		Если Год(КонецМесяца(мДатаКонцаПериодаОтчета)) < 2012 Тогда
			ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал;	
		КонецЕсли;
	КонецЕсли;
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуОтчетаЗавершение", ЭтаФорма);
	РегламентированнаяОтчетностьКлиент.ПроверитьВозможностьОткрытияДочернейФормыРегламентиованногоОтчета(ЭтаФорма, ОписаниеОповещения)
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Не Результат = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='Форма отчета изменилась, копирование невозможно!';uk='Форма звіту змінилася, копіювання неможливо!'"));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
				
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1';uk='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());

		Сообщение.Сообщить();
				
		Возврат;
		
	КонецЕсли;
	
	// устанавливаем дату представления отчета как рабочая дата
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);

КонецПроцедуры // ВыбратьФорму()

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры
