﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
		
	Элементы.ГруппаОтражениеВРеглУчета.Видимость = НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	//++ НЕ УТ
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям();
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСчетаРеглУчетаПоОрганизациям(Команда)
	
	//++ НЕ УТ
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВопросЗаписиОбъекта", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Для продолжения необходимо записать объект. Записать?';uk='Для продовження необхідно записати об''єкт. Записати?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать';uk='Записати'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
	КонецЕсли;
	ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям();
	//-- НЕ УТ
	
	Возврат; // Чтобы в УТ был не пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	//++ НЕ УТ
	ПоказыватьСчета = НЕ (Объект.ВидТМЦ = Перечисления.ВидыТМЦВЭксплуатации.МалоценныйБыстроизнашивающийсяПредмет
							 ИЛИ Объект.ВидТМЦ = Перечисления.ВидыТМЦВЭксплуатации.ПустаяСсылка());
	Элементы.ГруппаСчетаУчетаПоУмолчанию.Видимость = ПоказыватьСчета;
	//-- НЕ УТ
	
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

//++ НЕ УТ

&НаКлиенте
Процедура ОбработкаВопросЗаписиОбъекта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
		ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КатегорияЭксплуатации", Объект.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиСчетовРеглУчетаПоОрганизациям", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ПорядокОтраженияТМЦВЭксплуатации.Форма.ФормаНастройки", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастройкиСчетовРеглУчетаПоОрганизациям(Результат, ДополнительныеПараметры) Экспорт
	
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям()
	
		
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	ПоказыватьСчета = НЕ (Объект.ВидТМЦ = ПредопределенноеЗначение("Перечисление.ВидыТМЦВЭксплуатации.МалоценныйБыстроизнашивающийсяПредмет")
							ИЛИ Объект.ВидТМЦ = ПредопределенноеЗначение("Перечисление.ВидыТМЦВЭксплуатации.ПустаяСсылка"));
	Элементы.ГруппаСчетаУчетаПоУмолчанию.Видимость = ПоказыватьСчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидТМЦПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы();
	УстановитьСчетаУчетаТМЦВЭксплуатации();	
КонецПроцедуры

&НаСервере
Процедура УстановитьСчетаУчетаТМЦВЭксплуатации()
	
	Если Объект.ВидТМЦ = Перечисления.ВидыТМЦВЭксплуатации.МалоценныйНеоборотныйАктив Тогда
		Объект.СчетУчета 		= ПланыСчетов.Хозрасчетный.МалоценныеНеоборотныеМатериальныеАктивыКоличественно;
		Объект.СчетАмортизации	= ПланыСчетов.Хозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовКоличественно;
	ИначеЕсли Объект.ВидТМЦ = Перечисления.ВидыТМЦВЭксплуатации.БиблиотечныеФонды Тогда
		Объект.СчетУчета 		= ПланыСчетов.Хозрасчетный.БиблиотечныеФондыКоличественно; 
		Объект.СчетАмортизации	= ПланыСчетов.Хозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовКоличественно;
	Иначе
		Объект.СчетУчета 		= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		Объект.СчетАмортизации	= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	КонецЕсли; 
	
КонецПроцедуры


//-- НЕ УТ

#КонецОбласти