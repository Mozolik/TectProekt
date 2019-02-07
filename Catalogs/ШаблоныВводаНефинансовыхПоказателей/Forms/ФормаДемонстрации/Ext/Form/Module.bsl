﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураШаблона = ПолучитьИзВременногоХранилища(Параметры.Шаблон);
	
	ПараметрыПериода = Новый Структура("НачалоПериода, ОкончаниеПериода", 
										НачалоГода(ТекущаяДата()), КонецГода(ТекущаяДата()));
	СтруктураОписанияВвода = Документы.УстановкаЗначенийНефинансовыхПоказателей.СтруктураОписанияПолейДокументаВвода(
											Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону, ,
											СтруктураШаблона, СтруктураШаблона.ЗначенияСложнойТаблицыПоУмолчанию, ПараметрыПериода);
	
	ОтразитьСтруктуруШаблона(СтруктураОписанияВвода);
	
	УправлениеФормой(СтруктураОписанияВвода);
	
	ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону;
	ТекстШаблона = Параметры.Наименование;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ТабличнаяЧастьПриИзменении(Элемент)
	
	Для Каждого СтрокаОбхода из ТабличнаяЧасть Цикл
		СтрокаОбхода.НомерСтрокиДокумента = ТабличнаяЧасть.Индекс(СтрокаОбхода) + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтразитьСтруктуруШаблона(СтруктураОписанияВвода)
	
	Если СтруктураОписанияВвода = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДобавленныеЭлементы = Новый Массив;
	ЭлементыКУдалению = Новый Массив;
	
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьРеквизитыШапкиДокумента(СтруктураОписанияВвода, 
																						Элементы, ДобавленныеЭлементы);
	
	ЗначенияПоказателей.Очистить();
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьПоказателиРедактируемыеВШапке(СтруктураОписанияВвода, 
																				Элементы, ДобавленныеЭлементы, ЗначенияПоказателей);
	
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьТабличнуюЧастьДокумента(СтруктураОписанияВвода,
																				Элементы, ЭтаФорма, ДобавленныеЭлементы, ЭлементыКУдалению);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой(СтруктураОписанияВвода)
	
	Если СтруктураОписанияВвода <> Неопределено Тогда
		Если СтруктураОписанияВвода.Период = "Период" Тогда
			Элементы.СтраницыЗаголовкаПериода.ТекущаяСтраница = Элементы.СтраницаПериод;
			Элементы.СтраницыНачалоПериода.ТекущаяСтраница = Элементы.СтраницаНачалоПериода;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериода;
		ИначеЕсли СтруктураОписанияВвода.Период = "ДействуетС" Тогда
			Элементы.СтраницыЗаголовкаПериода.ТекущаяСтраница = Элементы.СтраницаДействуетС;
			Элементы.СтраницыНачалоПериода.ТекущаяСтраница = Элементы.СтраницаНачалоПериода;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ДействуетПо;
		Иначе
			Элементы.СтраницыЗаголовкаПериода.ТекущаяСтраница = Элементы.СтраницаНет;
			Элементы.СтраницыНачалоПериода.ТекущаяСтраница = Элементы.НачалоПериодаНет;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериодаНет;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Показатели.ПодчиненныеЭлементы.Количество()
		И Элементы.ТабличнаяЧасть.Видимость Тогда
		
		Элементы.Показатели.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.Показатели.ОтображатьЗаголовок = Истина;
	
		Элементы.ЗначенияПоказателей.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ЗначенияПоказателей.ОтображатьЗаголовок = Истина;
		
	Иначе
		
		Элементы.Показатели.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.Показатели.ОтображатьЗаголовок = Ложь;
	
		Элементы.ЗначенияПоказателей.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ЗначенияПоказателей.ОтображатьЗаголовок = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

