﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураСчетов = Параметры.СтруктураСчетов;
	УправлениеЭлементамиФормы();
	
	Если СтруктураСчетов.Свойство("СчетУчетаНаСкладе") Тогда
		ДоступныеСчетаУчетаНоменклатуры();
	КонецЕсли;
	Если СтруктураСчетов.Свойство("СчетУчетаПередачиНаКомиссию") Тогда
		ДоступныеСчетаУчетаНоменклатуры();
	КонецЕсли;
	Если СтруктураСчетов.Свойство("СчетУчетаРасчетовСКлиентами") Тогда
		ДоступныеСчетаУчетаРасчетов();
	КонецЕсли;
	Если СтруктураСчетов.Свойство("СчетУчетаДоходов") Тогда
		ДоступныеСчетаУчетаПрочихДоходов();
	КонецЕсли;
	Если СтруктураСчетов.Свойство("СчетУчетаРасходов") Тогда
		ДоступныеСчетаУчетаРасходов();
	КонецЕсли;
	
	Если СтруктураСчетов.Свойство("СчетУчета") Тогда
		ДоступныеСчетаУчетаТМЦВЭксплуатации();
	КонецЕсли;
	
	Если СтруктураСчетов.Свойство("СчетУчетаПодарочныхСертификатов") Тогда
		ДоступныеСчетаУчетаСертификатов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ЗаполнитьЗначенияСвойств(СтруктураСчетов, ЭтаФорма);
	Закрыть(СтруктураСчетов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СчетУчетаНаСкладе");
	МассивВсехРеквизитов.Добавить("СчетУчетаПередачиНаКомиссию");
	МассивВсехРеквизитов.Добавить("СчетУчетаВыручкиОтПродаж");
	МассивВсехРеквизитов.Добавить("СчетУчетаВычетовИзДоходов");
	МассивВсехРеквизитов.Добавить("СчетУчетаСебестоимостиПродаж");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаАвансовВыданных");
	МассивВсехРеквизитов.Добавить("СчетУчетаАвансовПолученных");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовПоВознаграждению");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСКлиентами");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСКлиентамиТара");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСПоставщиками");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСПоставщикамиТара");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаДоходов");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаРасходов");
	
	МассивВсехРеквизитов.Добавить("СчетУчета");
	МассивВсехРеквизитов.Добавить("СчетАмортизации");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаПодарочныхСертификатов");
	
	МассивРеквизитовОперации = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураСчетов Цикл
		МассивРеквизитовОперации.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаНоменклатуры()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаНоменклатуры();
	
	// Счета учета товаров на складе.
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчетаНаСкладе)));
	Элементы.СчетУчетаНаСкладе.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета передачи на комиссию.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчетаПередачиНаКомиссию)));
	Элементы.СчетУчетаПередачиНаКомиссию.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета выручки от продаж.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчетаВыручкиОтПродаж)));
	Элементы.СчетУчетаВыручкиОтПродаж.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета вычетов из доходов.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчетаВычетовИзДоходов)));
	Элементы.СчетУчетаВычетовИзДоходов.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета себестоимости от продаж.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчетаСебестоимостиПродаж)));
	Элементы.СчетУчетаСебестоимостиПродаж.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаТМЦВЭксплуатации()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаТМЦВЭксплуатации();
	
	// Счета учета ТМЦ в эксплуатации
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчета)));
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаСертификатов()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	
	// Счета учета подарочных сертификатов
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоАвансаПолученным)));
	Элементы.СчетУчетаПодарочныхСертификатов.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаРасчетов()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	
	// Счета учета расчетов с поставщиками.
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовСПоставщиками)));
	Элементы.СчетУчетаРасчетовСПоставщиками.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элементы.СчетУчетаРасчетовСПоставщикамиТара.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета расчетов по авансам выданным.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоАвансаВыданным)));
	Элементы.СчетУчетаАвансовВыданных.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета расчетов с клиентами.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовСКлиентами)));
	Элементы.СчетУчетаРасчетовСКлиентами.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элементы.СчетУчетаРасчетовСКлиентамиТара.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета расчетов по авансам полученным.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоАвансаПолученным)));
	Элементы.СчетУчетаАвансовПолученных.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Счета учета расчетов по комиссионному вознаграждению.
	МассивПараметров.Очистить();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасчетовПоКомиссии)));
	Элементы.СчетУчетаРасчетовПоВознаграждению.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);

КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаПрочихДоходов()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаПрочихДоходов();
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаПрочихДоходов)));
	Элементы.СчетУчетаДоходов.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаРасходов()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасходов();
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасходов)));
	Элементы.СчетУчетаРасходов.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
