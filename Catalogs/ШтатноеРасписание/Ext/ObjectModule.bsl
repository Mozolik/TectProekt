﻿#Если Не ТолстыйКлиентУправляемоеПриложение Или Сервер Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОстаткиОтпусков.ЗаполнитьОбщимиЕжегоднымиОтпусками(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли; 
	
	ПроверятьНачисления = Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленийШтатногоРасписания", , Ложь);
	ПроверитьЗаполнениеПозицииШтатногоРасписания(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПроверятьНачисления);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ИзменитьПроверяемыеРеквизитыШтатногоРасписания(ПроверяемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИсториюИзмененияШтатногоРасписания") Тогда
		ФОИспользоватьВилкуСтавокВШтатномРасписании = ПолучитьФункциональнуюОпцию("ИспользоватьВилкуСтавокВШтатномРасписании");
		УправлениеШтатнымРасписанием.СинхронизироватьРеквизитыПозиции(ЭтотОбъект, ФОИспользоватьВилкуСтавокВШтатномРасписании, Истина);
	КонецЕсли; 
	
	Если ПометкаУдаления И Утверждена И (Не Закрыта) Тогда 
		ТекстСообщения = НСтр("ru='Действующая позиция штатного расписания не может быть помечена на удаление.';uk='Діюча позиція штатного розкладу не може бути позначена на видалення.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Закрыта", "Закрыта", Отказ);
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтатноеРасписание.Ссылка
		|ИЗ
		|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Подразделение = &Подразделение
		|	И ШтатноеРасписание.ЭтоГруппа";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Родитель = Справочники.ШтатноеРасписание.ПолучитьСсылку();
		
		ГруппаРодитель = Справочники.ШтатноеРасписание.СоздатьГруппу();
		ГруппаРодитель.Владелец = Владелец;
		ГруппаРодитель.Подразделение = Подразделение;
		ГруппаРодитель.УстановитьСсылкуНового(Родитель);
		ГруппаРодитель.Записать();
		
	Иначе
		
		Если ЭтоНовый() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Родитель = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ШтатноеРасписаниеПриЗаписи(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеПозицииШтатногоРасписания(Объект, Отказ, ПроверяемыеРеквизиты, ПроверятьНачисления)
	
	Если НЕ Объект.Утверждена Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаУтверждения");
	КонецЕсли; 
	
	Если НЕ Объект.Закрыта Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаЗакрытия");
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьИсториюИзмененияШтатногоРасписания") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Наименование");
	Иначе
		
		Если ЗначениеЗаполнено(Объект.ДатаЗакрытия) И ЗначениеЗаполнено(Объект.ДатаУтверждения) И Объект.ДатаУтверждения > Объект.ДатаЗакрытия Тогда
			ТекстСообщения = НСтр("ru='Дата утверждения позиции не может быть больше даты закрытия позиции"".''';uk='Дата затвердження позиції не може бути більше дати закриття позиції"".''",);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , , Отказ);
		КонецЕсли;
		
		Если Не Объект.Закрыта Тогда
			ПроверитьПодразделениеИДолжность(Объект.Ссылка, Объект.ДатаУтверждения, Объект.Подразделение, Объект.Должность, Отказ);
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ПроверятьНачисления Тогда
		ПроверитьЗаполнениеНачислений(Объект.Ссылка, Объект.Начисления,  Объект.Показатели, Отказ);
	КонецЕсли;
	
	ОстаткиОтпусков.ОбработкаПроверкиЗаполненияТЧЕжегодныеОтпуска(Объект.ЕжегодныеОтпуска, ПроверяемыеРеквизиты, Отказ);
		
КонецПроцедуры

Процедура ПроверитьПодразделениеИДолжность(Ссылка, ДатаУтверждения, Подразделение, Должность, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Должность", Должность);
	Запрос.УстановитьПараметр("Дата", ДатаУтверждения);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Должности.Наименование КАК ДолжностьНаименование,
		|	ПодразделенияОрганизаций.Наименование КАК ПодразделениеНаименование,
		|	ВЫБОР
		|		КОГДА НЕ ПодразделенияОрганизаций.Расформировано ЕСТЬ NULL 
		|				И ПодразделенияОрганизаций.Расформировано
		|				И (ПодразделенияОрганизаций.ДатаРасформирования <= &Дата
		|					ИЛИ &Дата = ДАТАВРЕМЯ(1, 1, 1))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаПодразделение,
		|	ВЫБОР
		|		КОГДА НЕ Должности.ИсключенаИзШтатногоРасписания ЕСТЬ NULL 
		|				И Должности.ИсключенаИзШтатногоРасписания
		|				И (Должности.ДатаИсключения <= &Дата
		|					ИЛИ &Дата = ДАТАВРЕМЯ(1, 1, 1))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаДолжность
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
		|		ПО (Должности.Ссылка = &Должность)
		|			И (ПодразделенияОрганизаций.Ссылка = &Подразделение)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если Выборка.ОшибкаПодразделение Тогда
			ТекстСообщения = Нстр(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Подразделение %1 уже расформировано.'", Выборка.ПодразделениеНаименование));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Подразделение", , Отказ);
		КонецЕсли;
		
		Если Выборка.ОшибкаДолжность Тогда
			ТекстСообщения = Нстр(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Должность %1 уже исключена из штатного расписания.'", Выборка.ДолжностьНаименование));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Должность", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ПроверитьЗаполнениеНачислений(Ссылка, Начисления, Показатели, Отказ)
	
	ВыборкаПоНачислениям = СформироватьЗапросДляПроверкиЗаполненияНачислений(Начисления, Показатели).Выбрать();
		
	Пока ВыборкаПоНачислениям.СледующийПоЗначениюПоля("НомерСтроки") Цикл
		
		Если ВыборкаПоНачислениям.ДубльНачисление Тогда
			
			ТекстСообщения = НСтр("ru='Данное начисление уже было введено ранее';uk='Дане нарахування вже було введено раніше'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].Начисление", , Отказ);
			
		ИначеЕсли ВыборкаПоНачислениям.ДубльОсновноеНачисление Тогда 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Введено несколько взаимоисключающих начислений (%1)';uk='Введено кілька взаємовиключних нарахувань (%1)'"), ВыборкаПоНачислениям.НачислениеНаименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].Начисление", , Отказ);
			
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьВилкуСтавокВШтатномРасписании") Тогда
			
			Если ВыборкаПоНачислениям.ОшибкаМинЗначенияПоказателя Тогда
				
				ТекстСообщения = НСтр("ru='Ранее показателю %1 уже было назначено другое минимальное значение';uk='Раніше показнику %1 вже було призначено інше мінімальне значення'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаПоНачислениям.ОшибкаМинЗначенияПоказателяПоказатель);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].Начисление", , Отказ);
				
			КонецЕсли;
			
			Если ВыборкаПоНачислениям.ОшибкаМаксЗначенияПоказателя Тогда
				
				ТекстСообщения = НСтр("ru='Ранее показателю %1 уже было назначено другое максимальное значение';uk='Раніше показнику %1 вже було призначено інше максимальне значення'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаПоНачислениям.ОшибкаМаксЗначенияПоказателяПоказатель);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].Начисление", , Отказ);
				
			КонецЕсли;
			
		Иначе
			
			Если ВыборкаПоНачислениям.ОшибкаЗначенияПоказателя Тогда 
				
				ТекстСообщения = НСтр("ru='Ранее показателю %1 уже было назначено другое значение';uk='Раніше показнику %1 вже було призначено інше значення'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаПоНачислениям.ОшибкаЗначенияПоказателяПоказатель);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].Начисление", , Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
		СчПоказателей = 1;
		Пока ВыборкаПоНачислениям.Следующий() Цикл
			
			Если ВыборкаПоНачислениям.ОшибкаПоказателя Тогда
				ТекстСообщения = Нстр(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Минимальное значение показателя ""%1"" не может быть больше максимального'", ВыборкаПоНачислениям.ПоказательНаименование));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Начисления[" + Строка(ВыборкаПоНачислениям.НомерСтроки - 1) + "].МинимальноеЗначение" + СчПоказателей,, Отказ);	
			КонецЕсли;
			
			СчПоказателей = СчПоказателей + 1;
			
		КонецЦикла;
		
	КонецЦикла;	
		
КонецПроцедуры	

Функция СформироватьЗапросДляПроверкиЗаполненияНачислений(Начисления, Показатели)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Начисления", Начисления);
	Запрос.УстановитьПараметр("Показатели", Показатели);
	
	Запрос.Текст  = 
		"ВЫБРАТЬ
		|	Начисления.Начисление,
		|	Начисления.ИдентификаторСтрокиВидаРасчета,
		|	Начисления.НомерСтроки
		|ПОМЕСТИТЬ ВТТаблицаНачисления
		|ИЗ
		|	&Начисления КАК Начисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Показатели.Показатель,
		|	Показатели.НомерСтроки,
		|	Показатели.ИдентификаторСтрокиВидаРасчета,
		|	Показатели.Значение,
		|	Показатели.ЗначениеМин,
		|	Показатели.ЗначениеМакс
		|ПОМЕСТИТЬ ВТПоказатели
		|ИЗ
		|	&Показатели КАК Показатели
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаНачисления.Начисление,
		|	ТаблицаНачисления.ИдентификаторСтрокиВидаРасчета,
		|	ТаблицаНачисления.НомерСтроки,
		|	Начисления.ЗачетНормыВремени,
		|	Начисления.ОбозначениеВТабелеУчетаРабочегоВремени,
		|	Начисления.Наименование
		|ПОМЕСТИТЬ ВТДанныеНачислений
		|ИЗ
		|	ВТТаблицаНачисления КАК ТаблицаНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК Начисления
		|		ПО ТаблицаНачисления.Начисление = Начисления.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.НомерСтроки,
		|	МАКСИМУМ(НачисленияЗачетВремениДубль.НомерСтроки) КАК НомерСтроки1
		|ПОМЕСТИТЬ ВТНачисленияЗачетВремениДубль
		|ИЗ
		|	ВТДанныеНачислений КАК Начисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеНачислений КАК НачисленияЗачетВремениДубль
		|		ПО (Начисления.ЗачетНормыВремени)
		|			И (НачисленияЗачетВремениДубль.ЗачетНормыВремени)
		|			И Начисления.ОбозначениеВТабелеУчетаРабочегоВремени = НачисленияЗачетВремениДубль.ОбозначениеВТабелеУчетаРабочегоВремени
		|			И (Начисления.ОбозначениеВТабелеУчетаРабочегоВремени <> ЗНАЧЕНИЕ(Справочник.ВидыИспользованияРабочегоВремени.ПустаяСсылка))
		|			И Начисления.НомерСтроки > НачисленияЗачетВремениДубль.НомерСтроки
		|
		|СГРУППИРОВАТЬ ПО
		|	Начисления.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.НомерСтроки,
		|	МАКСИМУМ(НачисленияДубль.НомерСтроки) КАК НомерСтроки1
		|ПОМЕСТИТЬ ВТНачисленияДубль
		|ИЗ
		|	ВТДанныеНачислений КАК Начисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеНачислений КАК НачисленияДубль
		|		ПО Начисления.Начисление = НачисленияДубль.Начисление
		|			И Начисления.НомерСтроки > НачисленияДубль.НомерСтроки
		|
		|СГРУППИРОВАТЬ ПО
		|	Начисления.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаНачисления.НомерСтроки,
		|	ТаблицаНачисления.Начисление,
		|	Показатели.Показатель,
		|	Показатели.Значение,
		|	Показатели.ЗначениеМин,
		|	Показатели.ЗначениеМакс
		|ПОМЕСТИТЬ ВТНачисленияПоказатели
		|ИЗ
		|	ВТТаблицаНачисления КАК ТаблицаНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоказатели КАК Показатели
		|		ПО ТаблицаНачисления.ИдентификаторСтрокиВидаРасчета = Показатели.ИдентификаторСтрокиВидаРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НачисленияПоказатели.НомерСтроки,
		|	НачисленияПоказателиДубль.НомерСтроки КАК НомерСтроки1,
		|	НачисленияПоказатели.Показатель
		|ПОМЕСТИТЬ ВТОшибкиЗначенийПоказателей
		|ИЗ
		|	ВТНачисленияПоказатели КАК НачисленияПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисленияПоказатели КАК НачисленияПоказателиДубль
		|		ПО НачисленияПоказатели.Показатель = НачисленияПоказателиДубль.Показатель
		|			И НачисленияПоказатели.НомерСтроки > НачисленияПоказателиДубль.НомерСтроки
		|			И НачисленияПоказатели.Значение <> НачисленияПоказателиДубль.Значение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НачисленияПоказатели.НомерСтроки,
		|	НачисленияПоказателиДубль.НомерСтроки КАК НомерСтроки1,
		|	НачисленияПоказатели.Показатель
		|ПОМЕСТИТЬ ВТОшибкиМинЗначенийПоказателей
		|ИЗ
		|	ВТНачисленияПоказатели КАК НачисленияПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисленияПоказатели КАК НачисленияПоказателиДубль
		|		ПО НачисленияПоказатели.Показатель = НачисленияПоказателиДубль.Показатель
		|			И НачисленияПоказатели.НомерСтроки > НачисленияПоказателиДубль.НомерСтроки
		|			И НачисленияПоказатели.ЗначениеМин <> НачисленияПоказателиДубль.ЗначениеМин
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НачисленияПоказатели.НомерСтроки,
		|	НачисленияПоказателиДубль.НомерСтроки КАК НомерСтроки1,
		|	НачисленияПоказатели.Показатель
		|ПОМЕСТИТЬ ВТОшибкиМаксЗначенийПоказателей
		|ИЗ
		|	ВТНачисленияПоказатели КАК НачисленияПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисленияПоказатели КАК НачисленияПоказателиДубль
		|		ПО НачисленияПоказатели.Показатель = НачисленияПоказателиДубль.Показатель
		|			И НачисленияПоказатели.НомерСтроки > НачисленияПоказателиДубль.НомерСтроки
		|			И НачисленияПоказатели.ЗначениеМакс <> НачисленияПоказателиДубль.ЗначениеМакс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.Наименование КАК НачислениеНаименование,
		|	Начисления.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА НЕ НачисленияДубль.НомерСтроки ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДубльНачисление,
		|	ВЫБОР
		|		КОГДА НЕ НачисленияЗачетВремениДубль.НомерСтроки ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДубльОсновноеНачисление,
		|	ВЫБОР
		|		КОГДА НЕ Показатели.Показатель ЕСТЬ NULL 
		|				И ЕСТЬNULL(Показатели.ЗначениеМакс, 0) <> 0
		|				И ЕСТЬNULL(Показатели.ЗначениеМин, 0) <> 0
		|				И ЕСТЬNULL(Показатели.ЗначениеМин, 0) > ЕСТЬNULL(Показатели.ЗначениеМакс, 0)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаПоказателя,
		|	ДанныеПоказателей.Наименование КАК ПоказательНаименование,
		|	ВЫБОР
		|		КОГДА НЕ ОшибкиЗначенийПоказателей.НомерСтроки ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаЗначенияПоказателя,
		|	ОшибкиЗначенийПоказателей.Показатель КАК ОшибкаЗначенияПоказателяПоказатель,
		|	ВЫБОР
		|		КОГДА НЕ ОшибкиМинЗначенийПоказателей.НомерСтроки ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаМинЗначенияПоказателя,
		|	ОшибкиМинЗначенийПоказателей.Показатель КАК ОшибкаМинЗначенияПоказателяПоказатель,
		|	ВЫБОР
		|		КОГДА НЕ ОшибкиМаксЗначенийПоказателей.НомерСтроки ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаМаксЗначенияПоказателя,
		|	ОшибкиМаксЗначенийПоказателей.Показатель КАК ОшибкаМаксЗначенияПоказателяПоказатель
		|ИЗ
		|	ВТДанныеНачислений КАК Начисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказатели КАК Показатели
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПоказателиРасчетаЗарплаты КАК ДанныеПоказателей
		|			ПО Показатели.Показатель = ДанныеПоказателей.Ссылка
		|		ПО Начисления.ИдентификаторСтрокиВидаРасчета = Показатели.ИдентификаторСтрокиВидаРасчета
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияДубль КАК НачисленияДубль
		|		ПО Начисления.НомерСтроки = НачисленияДубль.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗачетВремениДубль КАК НачисленияЗачетВремениДубль
		|		ПО Начисления.НомерСтроки = НачисленияЗачетВремениДубль.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОшибкиЗначенийПоказателей КАК ОшибкиЗначенийПоказателей
		|		ПО Начисления.НомерСтроки = ОшибкиЗначенийПоказателей.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОшибкиМинЗначенийПоказателей КАК ОшибкиМинЗначенийПоказателей
		|		ПО Начисления.НомерСтроки = ОшибкиМинЗначенийПоказателей.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОшибкиМаксЗначенийПоказателей КАК ОшибкиМаксЗначенийПоказателей
		|		ПО Начисления.НомерСтроки = ОшибкиМаксЗначенийПоказателей.НомерСтроки
		|
		|УПОРЯДОЧИТЬ ПО
		|	Начисления.НомерСтроки,
		|	Показатели.НомерСтроки";
		
	Возврат Запрос.Выполнить();

КонецФункции	

#КонецОбласти

#КонецЕсли
