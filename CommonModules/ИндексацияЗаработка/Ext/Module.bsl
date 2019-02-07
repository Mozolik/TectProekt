﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьИндексируемыеПоУмолчаниюПоказатели(ИндексируемыеПоказатели, ПоказателиПредыдущейИндексации) Экспорт
	
	ПоказателиДляЗагрузки = Неопределено;
	
	Если ЕстьПоказателиПредыдущейИндексации(ПоказателиПредыдущейИндексации) Тогда
		ПоказателиДляЗагрузки = ПоказателиПредыдущейИндексации;
	Иначе
		ПоказателиДляЗагрузки = ПоказателиПоУмолчанию();
	КонецЕсли;
	
	УстановитьИндексируемыеПоказатели(ИндексируемыеПоказатели, ПоказателиДляЗагрузки); 
	
	УстановитьОкруглениеПоУмолчанию(ИндексируемыеПоказатели);
	
КонецПроцедуры

Процедура УстановитьОкруглениеПоУмолчанию(ИндексируемыеПоказатели) Экспорт
	
	Показатели = Новый Массив;
	Для каждого ИндексируемыйПоказатель Из ИндексируемыеПоказатели Цикл
		Показатели.Добавить(ИндексируемыйПоказатель.Показатель); 
	КонецЦикла;		
	
	ОкруглениеПоУмолчаниюДляПоказателей = ОкруглениеПоУмолчаниюДляПоказателей(Показатели);	
	Для каждого ИндексируемыйПоказатель Из ИндексируемыеПоказатели Цикл
		ИндексируемыйПоказатель.СпособОкругления = ОкруглениеПоУмолчаниюДляПоказателей[ИндексируемыйПоказатель.Показатель]; 
	КонецЦикла;		
	
КонецПроцедуры

Функция ОкруглениеПоУмолчаниюДляПоказателя(Показатель) Экспорт
	
	ОкруглениеПоУмолчаниюДляПоказателей = ОкруглениеПоУмолчаниюДляПоказателей(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель));
	
	Возврат ОкруглениеПоУмолчаниюДляПоказателей[Показатель];	
	
КонецФункции

Функция ОкруглениеПоУмолчаниюДляПоказателей(Показатели) Экспорт
	
	СведенияОПоказателях = ЗарплатаКадрыРасширенный.СведенияОПоказателяхРасчетаЗарплаты(Показатели);	
	
	ОкруглениеПоУмолчанию 				= ОкруглениеПриИндексацииПоУмолчанию();
	
	СоответствиеПоказателейИСпособовОкругления = Новый Соответствие;
	
	Для каждого Показатель Из Показатели Цикл
		
		ТочностьПоказателя = СведенияОПоказателях[Показатель].Точность;
		
		ОкруглениеДляПоказателя = Неопределено;	
		
		ОкруглениеДляПоказателя = ОкруглениеПоУмолчанию;
		
		СоответствиеПоказателейИСпособовОкругления.Вставить(Показатель, ОкруглениеДляПоказателя); 

	КонецЦикла;
	
	Возврат	СоответствиеПоказателейИСпособовОкругления;
	
КонецФункции

Функция ОписаниеОкругленияПоказателей(СпособыОкругленияПоказателей) Экспорт
	
	ОписаниеОкругленияПоказателей = Новый Соответствие;
	
	ОписаниеСпособовОкругления = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ОписаниеСпособовОкругления(СпособыОкругленияПоказателей.ВыгрузитьКолонку("СпособОкругления"));
	
	Для каждого Показатель Из СпособыОкругленияПоказателей Цикл
		
		ТочностьПоказателя = ЗарплатаКадрыРасширенныйПовтИсп.СведенияОПоказателеРасчетаЗарплаты(Показатель.Показатель).Точность;
		
		ОписаниеОкругленияПоказателя = Новый Структура("ТочностьОкругления,ПравилоОкругления");
		ОписаниеОкругленияПоказателя.Вставить("ПравилоОкругления", Неопределено);
		ОписаниеОкругленияПоказателя.Вставить("ТочностьОкругления", Pow(0.1, ТочностьПоказателя));
		
		Если ЗначениеЗаполнено(Показатель.СпособОкругления)  Тогда
			ОписаниеСпособаОкругления = ОписаниеСпособовОкругления.Получить(Показатель.СпособОкругления);
			Если ОписаниеСпособаОкругления <> Неопределено Тогда
				ОписаниеОкругленияПоказателя.Вставить("ТочностьОкругления", Макс(ОписаниеОкругленияПоказателя.ТочностьОкругления, ОписаниеСпособаОкругления.Точность));
				ОписаниеОкругленияПоказателя.Вставить("ПравилоОкругления", ОписаниеСпособаОкругления.ПравилоОкругления);
			КонецЕсли;
		КонецЕсли;
		
		ОписаниеОкругленияПоказателей.Вставить(Показатель.Показатель, ОписаниеОкругленияПоказателя);
		
	КонецЦикла;
	
	Возврат ОписаниеОкругленияПоказателей;
	
КонецФункции

Функция ИндексированноеЗначениеПоказателя(Значение, Коэффициент, ОписаниеОкругления) Экспорт
	ИндексированноеЗначениеПоказателя = Значение * Коэффициент;
	Возврат ЗарплатаКадрыКлиентСервер.Округлить(ИндексированноеЗначениеПоказателя, ОписаниеОкругления.ТочностьОкругления, ОписаниеОкругления.ПравилоОкругления);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьПоказателиПредыдущейИндексации(ПоказателиПредыдущейИндексации) 
	
	Возврат Не ПоказателиПредыдущейИндексации.Пустой();
	
КонецФункции

Процедура УстановитьИндексируемыеПоказатели(ИндексируемыеПоказатели, ПоказателиДляЗагрузки) 
	
	ИндексируемыеПоказатели.Загрузить(ПоказателиДляЗагрузки.Выгрузить())	
	
КонецПроцедуры

Функция ПоказателиПоУмолчанию()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоказателиРасчетаЗарплаты.Ссылка КАК Показатель
	|ИЗ
	|	Справочник.ПоказателиРасчетаЗарплаты КАК ПоказателиРасчетаЗарплаты
	|ГДЕ
	|	ПоказателиРасчетаЗарплаты.Идентификатор В(&ИдентификаторыПоказателейПоУмолчанию)
	|	И ПоказателиРасчетаЗарплаты.НазначениеПоказателя = ЗНАЧЕНИЕ(Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляСотрудника)
	|	И ПоказателиРасчетаЗарплаты.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейРасчетаЗарплаты.Денежный)
	|	И ПоказателиРасчетаЗарплаты.СпособПримененияЗначений = ЗНАЧЕНИЕ(Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное)";
	
	Запрос.УстановитьПараметр("ИдентификаторыПоказателейПоУмолчанию", ИдентификаторыПоказателейПоУмолчанию()); 
	
	Возврат Запрос.Выполнить();
		
КонецФункции

Функция ИдентификаторыПоказателейПоУмолчанию()
	
	ИдентификаторыПоказателейПоУмолчанию = Новый Массив;
	ИдентификаторыПоказателейПоУмолчанию.Добавить("Оклад");
	ИдентификаторыПоказателейПоУмолчанию.Добавить("ТарифнаяСтавкаДневная");
	ИдентификаторыПоказателейПоУмолчанию.Добавить("ТарифнаяСтавкаЧасовая");
	
	Возврат ИдентификаторыПоказателейПоУмолчанию;
	
КонецФункции

Функция ОкруглениеПриИндексацииПоУмолчанию()
	
		Возврат Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
	
КонецФункции
	
#КонецОбласти
