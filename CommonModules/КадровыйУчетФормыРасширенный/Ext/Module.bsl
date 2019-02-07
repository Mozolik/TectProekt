﻿////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетФормыРасширенный: методы, обслуживающие работу форм кадровых документов.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ФормаКадровогоДокументаПриСозданииНаСервере(Форма) Экспорт
	
	КадровыйУчетФормыБазовый.ФормаКадровогоДокументаПриСозданииНаСервере(Форма);
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ФиксированныеЗначения = Новый Массив;
		
		МетаданныеДокумента = Форма.Объект.Ссылка.Метаданные();
		
		Если МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено И ЗначениеЗаполнено(Форма.Объект.Организация) Тогда
			ФиксированныеЗначения.Добавить("Организация");
		КонецЕсли; 
		
		Если МетаданныеДокумента.Реквизиты.Найти("ПодразделениеПрежнее") <> Неопределено Тогда
			
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.ПодразделениеПрежнее");
			Если ЗначениеЗаполнено(Форма.Объект.ПодразделениеПрежнее) Тогда
				ФиксированныеЗначения.Добавить("Подразделение");
			КонецЕсли; 
			
		КонецЕсли; 
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(Форма, ЗначенияДляЗаполнения, ФиксированныеЗначения);
		
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		
		ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически = 
			Новый РеквизитФормы("ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически", Новый ОписаниеТипов("Булево"));
			
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически);
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		НастройкиШтатногоРасписания = УправлениеШтатнымРасписанием.НастройкиШтатногоРасписания();
		
		Форма.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически = НастройкиШтатногоРасписания.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически 
			И НастройкиШтатногоРасписания.ИспользоватьШтатноеРасписание;
																	
	КонецЕсли;
																	
КонецПроцедуры

Процедура УстановитьОтображениеКнопкиРедактироватьФОТ(Форма) Экспорт
	
	КомандаРедактироватьФОТ = Форма.Команды.Найти("РедактироватьФОТ");
	Если КомандаРедактироватьФОТ <> Неопределено Тогда
		Если Форма.ТолькоПросмотр Тогда
			КомандаРедактироватьФОТ.Заголовок = НСтр("ru='Показать';uk='Показати'");
			КомандаРедактироватьФОТ.Картинка = БиблиотекаКартинок.ПоказатьДанные;
		Иначе
			КомандаРедактироватьФОТ.Заголовок = НСтр("ru='Редактировать';uk='Редагувати'");
			КомандаРедактироватьФОТ.Картинка = БиблиотекаКартинок.Изменить;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура РазместитьКомандуПроверкиШтатномуРасписанию(Форма) Экспорт
	
	КомандаПроведенияВоВсехДействиях = Ложь;
	
	Если Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание") Тогда
		
		НастройкиШтатногоРасписания = УправлениеШтатнымРасписанием.НастройкиШтатногоРасписания();
		Если НастройкиШтатногоРасписания.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически Тогда
			
			КомандаПроведенияВоВсехДействиях = Ложь;
			КомандаПроверкиСоответствияШтатномуРасписаниюВоВсехДействиях = Истина;
			ЗаголовокКомандыКомандаПроверкиСоответствияШтатномуРасписанию = НСтр("ru='Проверить на соответствие штатному расписанию';uk='Перевірити на відповідність штатному розкладу'");
			
		Иначе
			
			КомандаПроведенияВоВсехДействиях = Истина;
			КомандаПроверкиСоответствияШтатномуРасписаниюВоВсехДействиях = Ложь;
			ЗаголовокКомандыКомандаПроверкиСоответствияШтатномуРасписанию = НСтр("ru='Проверить';uk='Перевірити'");
			
		КонецЕсли;
		
		КомандаПроверкиСоответствияШтатномуРасписанию = Форма.Команды.Найти("ПроверитьНаСоответствиеШтатномуРасписанию");
		Если КомандаПроверкиСоответствияШтатномуРасписанию <> Неопределено Тогда
			КомандаПроверкиСоответствияШтатномуРасписанию.Заголовок = ЗаголовокКомандыКомандаПроверкиСоответствияШтатномуРасписанию;
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаПроверитьНаСоответствиеШтатномуРасписанию",
			"ТолькоВоВсехДействиях",
			КомандаПроверкиСоответствияШтатномуРасписаниюВоВсехДействиях);
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"КомандаПровести",
		"ТолькоВоВсехДействиях",
		КомандаПроведенияВоВсехДействиях);
		
КонецПроцедуры

Функция ДанныеДляКадровогоПеревода(Сотрудники, ВремяРегистрации, ИсключаемыйРегистратор, ШаблонДляЗаполнения) Экспорт
	
	ДанныеПеревода = Новый Соответствие;
	
	Если ТипЗнч(Сотрудники) = Тип("Массив") Тогда
		СписокСотрудников = Сотрудники;
	Иначе
		СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	Отбор = Новый Массив;
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(Отбор, "Регистратор", "<>", ИсключаемыйРегистратор);
	
	ПоляОтбораПериодическихДанных = Новый Структура;
	ПоляОтбораПериодическихДанных.Вставить("КадроваяИсторияСотрудников", 	Отбор);
	ПоляОтбораПериодическихДанных.Вставить("ГрафикРаботыСотрудников", 		Отбор);
	ПоляОтбораПериодическихДанных.Вставить("РазрядыКатегорииСотрудников", 	Отбор);
	
	КадровыеДанные =
		"Подразделение,
		|Территория,
		|Должность,
		|ДолжностьПоШтатномуРасписанию,
		|КоличествоСтавок,
		|ГрафикРаботы,
		|Организация,
		|ГоловнаяОрганизация,
		|ВидЗанятости,
		|СпособОтраженияЗарплатыВБухучете,
		|СтатьяФинансирования,
		|РазрядКатегория,
		|КатегорияЕСВ,
		|ВидДоговора,
		|ПринятНаНовоеРабочееМесто";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, СписокСотрудников, КадровыеДанные, ВремяРегистрации, ПоляОтбораПериодическихДанных, Ложь);
	Для каждого СтрокаДанныхСотрудника Из ДанныеСотрудников Цикл
		
		СтруктураДанных = ЗарплатаКадрыРасширенныйВызовСервера.СтруктураПоМетаданным("Документ.КадровыйПеревод");
		СтруктураДанных.ДатаНачала = ВремяРегистрации;
		
		ЗаполнитьЗначенияСвойств(СтруктураДанных, СтрокаДанныхСотрудника);
		СтруктураДанных.Организация = СтрокаДанныхСотрудника.ГоловнаяОрганизация;
		СтруктураДанных.ОбособленноеПодразделение = СтрокаДанныхСотрудника.Организация;
		
		Если ШаблонДляЗаполнения <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураДанных, ШаблонДляЗаполнения, "ДатаОкончания");
		КонецЕсли; 
		
		ДанныеПеревода.Вставить(СтрокаДанныхСотрудника.Сотрудник, СтруктураДанных);
		
		СтрокаТаблицы = ТаблицаСотрудников.Добавить();
		СтрокаТаблицы.Сотрудник 					= СтрокаДанныхСотрудника.Сотрудник;
		СтрокаТаблицы.Период 						= ВремяРегистрации;
		
	КонецЦикла;
	
	ДанныеОбАвансах = РасчетЗарплатыРасширенный.АвансыСотрудников(ТаблицаСотрудников, ИсключаемыйРегистратор);
	Для каждого ДанныеОбАвансе Из ДанныеОбАвансах Цикл
		
		СтруктураДанных = ДанныеПеревода.Получить(ДанныеОбАвансе.Сотрудник);
		
		СтруктураДанных.Аванс				= ДанныеОбАвансе.Аванс;
		СтруктураДанных.СпособРасчетаАванса	= ДанныеОбАвансе.СпособРасчетаАванса
		
	КонецЦикла;
	
	// Плановые начисления
	ДанныеНачислений = ЗарплатаКадрыРасширенный.ДействующиеНачисленияСотрудников(ТаблицаСотрудников, ИсключаемыйРегистратор);
	Для каждого ДанныеНачисленийСотрудника Из ДанныеНачислений Цикл
		
		ИдентификаторСтрокиВидаРасчета = 1;
		
		СтруктураДанных = ДанныеПеревода.Получить(ДанныеНачисленийСотрудника.Ключ);
		ИменаРеквизитовНачислений = СтруктураДанных.ТабличныеЧасти.ОписаниеТабличныхЧастей["Начисления"];
		ИменаРеквизитовПоказателей = СтруктураДанных.ТабличныеЧасти.ОписаниеТабличныхЧастей["Показатели"];
		
		Если ДанныеНачисленийСотрудника.Значение.Свойство("Начисления") Тогда
			
			Для каждого ОписаниеНачисления Из ДанныеНачисленийСотрудника.Значение.Начисления Цикл
				
				СтруктураСтроки = Новый Структура(ИменаРеквизитовНачислений);
				ЗаполнитьЗначенияСвойств(СтруктураСтроки, ОписаниеНачисления);
				СтруктураСтроки.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
				
				СтруктураДанных.ТабличныеЧасти.Начисления.Добавить(СтруктураСтроки);
				
				Для каждого ОписаниеПоказателя Из ОписаниеНачисления.Показатели Цикл
					
					СтруктураСтрокиПоказателя = Новый Структура(ИменаРеквизитовПоказателей);
					ЗаполнитьЗначенияСвойств(СтруктураСтрокиПоказателя, ОписаниеПоказателя);
					СтруктураСтрокиПоказателя.ИдентификаторСтрокиВидаРасчета = СтруктураСтроки.ИдентификаторСтрокиВидаРасчета;
					
					СтруктураДанных.ТабличныеЧасти.Показатели.Добавить(СтруктураСтрокиПоказателя);
					
				КонецЦикла;
				
				ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ДанныеНачисленийСотрудника.Значение.Свойство("ДополнительныеПоказатели") Тогда
			
			Для каждого ОписаниеПоказателя Из ДанныеНачисленийСотрудника.Значение.ДополнительныеПоказатели Цикл
				
				СтруктураСтрокиПоказателя = Новый Структура(ИменаРеквизитовПоказателей);
				ЗаполнитьЗначенияСвойств(СтруктураСтрокиПоказателя, ОписаниеПоказателя);
				СтруктураСтрокиПоказателя.ИдентификаторСтрокиВидаРасчета = 0;
				
				СтруктураДанных.ТабличныеЧасти.Показатели.Добавить(СтруктураСтрокиПоказателя);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Ежегодные отпуска
	ОтпускаСотрудников = ОстаткиОтпусков.ЕжегодныеОтпускаСотрудников(ТаблицаСотрудников, ИсключаемыйРегистратор);
	Для каждого ДанныеОтпусковСотрудника Из ОтпускаСотрудников Цикл
		
		СтруктураДанных = ДанныеПеревода.Получить(ДанныеОтпусковСотрудника.Ключ);
		ИменаРеквизитовЕжегодныеОтпуска = СтруктураДанных.ТабличныеЧасти.ОписаниеТабличныхЧастей["ЕжегодныеОтпуска"];
		
		Для каждого ДанныеОтпуска Из ДанныеОтпусковСотрудника.Значение Цикл
			
			СтруктураСтрокиОтпуска = Новый Структура(ИменаРеквизитовЕжегодныеОтпуска);
			ЗаполнитьЗначенияСвойств(СтруктураСтрокиОтпуска, ДанныеОтпуска);
			
			СтруктураДанных.ТабличныеЧасти.ЕжегодныеОтпуска.Добавить(СтруктураСтрокиОтпуска);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ЗаполнитьДействующиеЛьготыСотрудников(ТаблицаСотрудников, ДанныеПеревода, ИсключаемыйРегистратор);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДанныеПеревода;
	
КонецФункции

Процедура ЗаполнитьОтсутствияПоДругимМестамРаботы(Форма, НачалоПериода, ОкончаниеПериода) Экспорт
	
	Форма.ОтсутствияПоДругимМестамРаботы.Очистить();
	
	Если Форма.ДругиеСотрудникиФизическогоЛица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДругиеСотрудники = Новый Массив;
	Для каждого СотрудникФизическогоЛица Из Форма.ДругиеСотрудникиФизическогоЛица  Цикл
		ДругиеСотрудники.Добавить(СотрудникФизическогоЛица.Сотрудник);
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	КадровыйУчетРасширенный.СоздатьВТОтсутствияСотрудниковВПериоде(Запрос.МенеджерВременныхТаблиц, ДругиеСотрудники, НачалоПериода, ОкончаниеПериода);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтсутствияСотрудниковВПериоде.Ссылка,
		|	ОтсутствияСотрудниковВПериоде.Организация,
		|	ОтсутствияСотрудниковВПериоде.Сотрудник,
		|	ОтсутствияСотрудниковВПериоде.Должность,
		|	ОтсутствияСотрудниковВПериоде.ДатаНачала,
		|	ОтсутствияСотрудниковВПериоде.ДатаОкончания
		|ИЗ
		|	ВТОтсутствияСотрудниковВПериоде КАК ОтсутствияСотрудниковВПериоде";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Форма.ОтсутствияПоДругимМестамРаботы.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
