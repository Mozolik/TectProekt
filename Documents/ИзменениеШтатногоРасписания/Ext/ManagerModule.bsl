﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленийШтатногоРасписания,ЧтениеНачисленийШтатногоРасписания", , Ложь) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.ИзменениеШтатногоРасписания";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОВнесенииИзмененийШтатноеРасписание";
		КомандаПечати.Представление = НСтр("ru='Приказ о внесении изменений';uk='Наказ про внесення змін'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьИсториюИзмененияШтатногоРасписания";
		
	КонецЕсли; 
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОВнесенииИзмененийШтатноеРасписание") Тогда
		
		ПечатныеФормы = ПечатнаяФормаПриказа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПФ_MXL_ПриказОВнесенииИзмененийШтатноеРасписание", 
			НСтр("ru='Приказ о внесении изменений';uk='Наказ про внесення змін'"), 
			ПечатныеФормы, ,
			"Документ.ИзменениеШтатногоРасписания.ПФ_MXL_ПриказОВнесенииИзмененийШтатноеРасписание",
			,
			Истина); // ЭтоМногоязычнаяПечатнаяФорма
				
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПриказа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	ТДокумент = Новый ТабличныйДокумент;
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИзменениеШтатногоРасписания.ПФ_MXL_ПриказОВнесенииИзмененийШтатноеРасписание", КодЯзыкаПечать);
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПодразделениеВвод = Макет.ПолучитьОбласть("ПодразделениеВвод");
	ОбластьПодразделениеВводДолжностей = Макет.ПолучитьОбласть("ПодразделениеВводДолжностей");
	ОбластьПодразделениеВывод = Макет.ПолучитьОбласть("ПодразделениеВывод");
	ОбластьПодразделениеВыводДолжностей = Макет.ПолучитьОбласть("ПодразделениеВыводДолжностей");
	ОбластьПодразделениеИзменение = Макет.ПолучитьОбласть("ПодразделениеИзменение");
	ОбластьДолжность = Макет.ПолучитьОбласть("Должность");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ФОИспользоватьВилкуСтавокВШтатномРасписании = ПолучитьФункциональнуюОпцию("ИспользоватьВилкуСтавокВШтатномРасписании");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказов(МассивОбъектов);
	Пока ДанныеДляПечати.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Если ТДокумент.ВысотаТаблицы > 0 Тогда
			ТДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		
		НачалоФормы = ТДокумент.ВысотаТаблицы + 1;
		НомерПункта = 1;
		
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ДанныеДляПечати);
		
		Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
			ОбластьШапка.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ОбластьШапка.Параметры.НомерДок, Истина, Истина);
		КонецЕсли;
		
		ОбластьШапка.Параметры.ДатаДок = Формат(ОбластьШапка.Параметры.ДатаДок, "ДЛФ=DD; Л=" + КодЯзыкаПечать);
	
		ОбластьШапка.Параметры.ДатаВступленияВСилу = Формат(ОбластьШапка.Параметры.ДатаВступленияВСилу, "ДЛФ=D");
		
		ТДокумент.Вывести(ОбластьШапка);
		
		Пока ДанныеДляПечати.СледующийПоЗначениюПоля("ПорядокПодразделения") Цикл
			
			Пока ДанныеДляПечати.СледующийПоЗначениюПоля("Порядок") Цикл
				
				Если ДанныеДляПечати.Порядок = 1 Тогда
					МакетОбласти = ОбластьПодразделениеВвод;
				ИначеЕсли ДанныеДляПечати.Порядок = 2 Тогда
					МакетОбласти = ОбластьПодразделениеВводДолжностей;
				ИначеЕсли ДанныеДляПечати.Порядок = 3 Тогда
					МакетОбласти = ОбластьПодразделениеВывод;
				ИначеЕсли ДанныеДляПечати.Порядок = 4 Тогда
					МакетОбласти = ОбластьПодразделениеВыводДолжностей;
				Иначе
					МакетОбласти = ОбластьПодразделениеИзменение;
				КонецЕсли; 
				
				ЗаполнитьЗначенияСвойств(МакетОбласти.Параметры, ДанныеДляПечати);
				МакетОбласти.Параметры.НомерПункта = НомерПункта;
				
				Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(МакетОбласти.Параметры.Подразделение) Тогда
					МакетОбласти.Параметры.Подразделение = МакетОбласти.Параметры.Подразделение.ПолноеНаименование();
				КонецЕсли; 
				ТДокумент.Вывести(МакетОбласти);
				
				НомерПункта = НомерПункта + 1;
				
				Пока ДанныеДляПечати.СледующийПоЗначениюПоля("ПорядокДолжности") Цикл
					
					ЗаполнитьЗначенияСвойств(ОбластьДолжность.Параметры, ДанныеДляПечати);
					Если ФОИспользоватьВилкуСтавокВШтатномРасписании Тогда
						Если ДанныеДляПечати.ФОТМин = ДанныеДляПечати.ФОТМакс Тогда
							ОбластьДолжность.Параметры.ФОТ = Формат(ДанныеДляПечати.ФОТМин, "ЧДЦ=2");
						ИначеЕсли ДанныеДляПечати.ФОТМин = 0 Тогда
							ОбластьДолжность.Параметры.ФОТ = Формат(ДанныеДляПечати.ФОТМакс, "ЧДЦ=2");
						ИначеЕсли ДанныеДляПечати.ФОТМакс = 0 Тогда
							ОбластьДолжность.Параметры.ФОТ = Формат(ДанныеДляПечати.ФОТМин, "ЧДЦ=2");
						Иначе
							ОбластьДолжность.Параметры.ФОТ = Формат(ДанныеДляПечати.ФОТМин, "ЧДЦ=2") + " - " + Формат(ДанныеДляПечати.ФОТМакс, "ЧДЦ=2");
						КонецЕсли;
						
					Иначе
						ОбластьДолжность.Параметры.ФОТ = Формат(ДанныеДляПечати.ФОТ, "ЧДЦ=2");
					КонецЕсли;
					
					ОбластьДолжность.Параметры.Должность = ДанныеДляПечати.Позиция;
					
					ТДокумент.Вывести(ОбластьДолжность);
					
				КонецЦикла; 
			
			КонецЦикла; 
		
		КонецЦикла; 
				
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, ДанныеДляПечати);
		ОбластьПодвал.Параметры.НомерПункта = НомерПункта;
		
		Если ЗначениеЗаполнено(ОбластьПодвал.Параметры.ФИОИсполнителя) Тогда
			РезультатСклонения = "";
			Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ОбластьПодвал.Параметры.ФИОИсполнителя), 4, РезультатСклонения, ДанныеДляПечати.ПолИсполнителя) Тогда
				ОбластьПодвал.Параметры.ФИОИсполнителя = РезультатСклонения
			КонецЕсли;
		Иначе
			ОбластьПодвал.Параметры.ФИОИсполнителя = "____________________";
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(ОбластьПодвал.Параметры.ДолжностьИсполнителя) Тогда
			ОбластьПодвал.Параметры.ДолжностьИсполнителя = "____________________";
		КонецЕсли; 
		
		ТДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТДокумент, НачалоФормы, ОбъектыПечати, ДанныеДляПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТДокумент;
	
КонецФункции

Функция ДанныеДляПечатиПриказов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеШтатногоРасписания.Ссылка,
		|	ИзменениеШтатногоРасписания.Номер КАК НомерДок,
		|	ИзменениеШтатногоРасписания.Дата КАК Дата,
		|	ИзменениеШтатногоРасписания.Дата КАК ДатаДок,
		|	ИзменениеШтатногоРасписания.ДатаВступленияВСилу,
		|	ИзменениеШтатногоРасписания.Руководитель,
		|	ИзменениеШтатногоРасписания.ДолжностьРуководителя,
		|	ИзменениеШтатногоРасписания.РуководительКадровойСлужбы КАК РуководительКадровойСлужбы,
		|	ИзменениеШтатногоРасписания.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьРуководителяКадровойСлужбы,
		|	ИзменениеШтатногоРасписания.Организация,
		|	ВЫРАЗИТЬ(ИзменениеШтатногоРасписания.Организация.НаименованиеПолное КАК СТРОКА(1000)) КАК ОрганизацияНаименованиеПолное,
		|	ВЫРАЗИТЬ(ИзменениеШтатногоРасписания.Организация.НаименованиеСокращенное КАК СТРОКА(1000)) КАК ОрганизацияНаименованиеСокращенное
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ИзменениеШтатногоРасписания КАК ИзменениеШтатногоРасписания
		|ГДЕ
		|	ИзменениеШтатногоРасписания.Ссылка В(&МассивОбъектов)";
		
	Запрос.Выполнить();
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, "Руководитель,РуководительКадровойСлужбы", "ВТДанныеДокументов");
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеШтатногоРасписанияПозиции.Ссылка КАК Ссылка,
		|	ПодразделенияОрганизаций.Ссылка КАК Подразделение,
		|	ВЫБОР
		|		КОГДА ПодразделенияОрганизаций.ДатаСоздания = ИзменениеШтатногоРасписанияПозиции.Ссылка.ДатаВступленияВСилу
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Создание,
		|	ВЫБОР
		|		КОГДА ПодразделенияОрганизаций.ДатаРасформирования = ИзменениеШтатногоРасписанияПозиции.Ссылка.ДатаВступленияВСилу
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Расформировывание
		|ПОМЕСТИТЬ ВТПодразделения
		|ИЗ
		|	Документ.ИзменениеШтатногоРасписания.Позиции КАК ИзменениеШтатногоРасписанияПозиции
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|		ПО ИзменениеШтатногоРасписанияПозиции.Подразделение = ПодразделенияОрганизаций.Ссылка
		|ГДЕ
		|	ИзменениеШтатногоРасписанияПозиции.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеШтатногоРасписанияПозиции.Ссылка,
		|	ИзменениеШтатногоРасписанияПозиции.Позиция,
		|	ВЫБОР
		|		КОГДА ИзменениеШтатногоРасписанияПозиции.Позиция.ДатаУтверждения = ИзменениеШтатногоРасписанияПозиции.Ссылка.ДатаВступленияВСилу
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Ввод,
		|	ВЫБОР
		|		КОГДА ИзменениеШтатногоРасписанияПозиции.Позиция.ДатаЗакрытия = ИзменениеШтатногоРасписанияПозиции.Ссылка.ДатаВступленияВСилу
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Исключение,
		|	ИзменениеШтатногоРасписанияПозиции.КоличествоСтавок,
		|	ИзменениеШтатногоРасписанияПозиции.ФОТ,
		|	ИзменениеШтатногоРасписанияПозиции.ФОТМин,
		|	ИзменениеШтатногоРасписанияПозиции.ФОТМакс
		|ПОМЕСТИТЬ ВТПозиции
		|ИЗ
		|	Документ.ИзменениеШтатногоРасписания.Позиции КАК ИзменениеШтатногоРасписанияПозиции
		|ГДЕ
		|	ИзменениеШтатногоРасписанияПозиции.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПодразделенияУтверждаемые.Ссылка,
		|	ПодразделенияУтверждаемые.Подразделение,
		|	Позиции.Позиция,
		|	Позиции.ФОТ,
		|	Позиции.ФОТМин,
		|	Позиции.ФОТМакс,
		|	1 КАК Порядок,
		|	Позиции.КоличествоСтавок
		|ПОМЕСТИТЬ ВТИзменения
		|ИЗ
		|	ВТПодразделения КАК ПодразделенияУтверждаемые
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПозиции КАК Позиции
		|		ПО ПодразделенияУтверждаемые.Ссылка = Позиции.Ссылка
		|			И ПодразделенияУтверждаемые.Подразделение = Позиции.Позиция.Подразделение
		|			И ПодразделенияУтверждаемые.Создание = Позиции.Ввод
		|			И (ПодразделенияУтверждаемые.Создание)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияУтверждаемые.Ссылка,
		|	ПодразделенияУтверждаемые.Подразделение,
		|	Позиции.Позиция,
		|	Позиции.ФОТ,
		|	Позиции.ФОТМин,
		|	Позиции.ФОТМакс,
		|	2,
		|	Позиции.КоличествоСтавок
		|ИЗ
		|	ВТПодразделения КАК ПодразделенияУтверждаемые
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПозиции КАК Позиции
		|		ПО ПодразделенияУтверждаемые.Ссылка = Позиции.Ссылка
		|			И ПодразделенияУтверждаемые.Подразделение = Позиции.Позиция.Подразделение
		|			И (НЕ ПодразделенияУтверждаемые.Создание)
		|			И (НЕ ПодразделенияУтверждаемые.Расформировывание)
		|			И (Позиции.Ввод)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияРасформировываемые.Ссылка,
		|	ПодразделенияРасформировываемые.Подразделение,
		|	Позиции.Позиция,
		|	Позиции.ФОТ,
		|	Позиции.ФОТМин,
		|	Позиции.ФОТМакс,
		|	3,
		|	Позиции.КоличествоСтавок
		|ИЗ
		|	ВТПодразделения КАК ПодразделенияРасформировываемые
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПозиции КАК Позиции
		|		ПО ПодразделенияРасформировываемые.Ссылка = Позиции.Ссылка
		|			И ПодразделенияРасформировываемые.Подразделение = Позиции.Позиция.Подразделение
		|			И ПодразделенияРасформировываемые.Расформировывание = Позиции.Исключение
		|			И (ПодразделенияРасформировываемые.Расформировывание)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияУтверждаемые.Ссылка,
		|	ПодразделенияУтверждаемые.Подразделение,
		|	Позиции.Позиция,
		|	Позиции.ФОТ,
		|	Позиции.ФОТМин,
		|	Позиции.ФОТМакс,
		|	4,
		|	Позиции.КоличествоСтавок
		|ИЗ
		|	ВТПодразделения КАК ПодразделенияУтверждаемые
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПозиции КАК Позиции
		|		ПО ПодразделенияУтверждаемые.Ссылка = Позиции.Ссылка
		|			И ПодразделенияУтверждаемые.Подразделение = Позиции.Позиция.Подразделение
		|			И (НЕ ПодразделенияУтверждаемые.Создание)
		|			И (НЕ ПодразделенияУтверждаемые.Расформировывание)
		|			И (Позиции.Исключение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияУтверждаемые.Ссылка,
		|	ПодразделенияУтверждаемые.Подразделение,
		|	Позиции.Позиция,
		|	Позиции.ФОТ,
		|	Позиции.ФОТМин,
		|	Позиции.ФОТМакс,
		|	5,
		|	Позиции.КоличествоСтавок
		|ИЗ
		|	ВТПодразделения КАК ПодразделенияУтверждаемые
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПозиции КАК Позиции
		|		ПО ПодразделенияУтверждаемые.Ссылка = Позиции.Ссылка
		|			И ПодразделенияУтверждаемые.Подразделение = Позиции.Позиция.Подразделение
		|			И (НЕ ПодразделенияУтверждаемые.Создание)
		|			И (НЕ ПодразделенияУтверждаемые.Расформировывание)
		|			И (НЕ Позиции.Ввод)
		|			И (НЕ Позиции.Исключение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.НомерДок,
		|	ДанныеДокументов.ДатаДок,
		|	ДанныеДокументов.ДатаВступленияВСилу,
		|	ФИОРуководителя.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи,
		|	ДанныеДокументов.ДолжностьРуководителя,
		|	ФИОИсполнителя.ФИОПолные КАК ФИОИсполнителя,
		|	ВЫРАЗИТЬ(ДанныеДокументов.РуководительКадровойСлужбы КАК Справочник.ФизическиеЛица).Пол КАК ПолИсполнителя,
		|	ДанныеДокументов.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьИсполнителя,
		|	ДанныеДокументов.Организация,
		|	ДанныеДокументов.ОрганизацияНаименованиеПолное,
		|	ДанныеДокументов.ОрганизацияНаименованиеСокращенное,
		|	Изменения.Подразделение КАК Подразделение,
		|	ВЫРАЗИТЬ(Изменения.Подразделение КАК Справочник.ПодразделенияОрганизаций).РеквизитДопУпорядочиванияИерархического КАК ПорядокПодразделения,
		|	Изменения.Позиция КАК Позиция,
		|	ВЫРАЗИТЬ(Изменения.Позиция КАК Справочник.ШтатноеРасписание).Должность.РеквизитДопУпорядочивания КАК ПорядокДолжности,
		|	Изменения.ФОТ,
		|	Изменения.ФОТМин,
		|	Изменения.ФОТМакс,
		|	Изменения.Порядок КАК Порядок,
		|	ВЫРАЗИТЬ(Изменения.Позиция КАК Справочник.ШтатноеРасписание).Должность КАК Должность,
		|	Изменения.КоличествоСтавок
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОРуководителя
		|		ПО ДанныеДокументов.Ссылка = ФИОРуководителя.Ссылка
		|			И ДанныеДокументов.Руководитель = ФИОРуководителя.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОИсполнителя
		|		ПО ДанныеДокументов.Ссылка = ФИОИсполнителя.Ссылка
		|			И ДанныеДокументов.РуководительКадровойСлужбы = ФИОИсполнителя.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИзменения КАК Изменения
		|		ПО ДанныеДокументов.Ссылка = Изменения.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	ПорядокПодразделения,
		|	Порядок,
		|	ПорядокДолжности";
		
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецЕсли
