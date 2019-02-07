﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭлектронныйДокумент") Тогда
		ЭлектронныйДокумент = Параметры.ЭлектронныйДокумент;
		Если ТипЗнч(ЭлектронныйДокумент) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
			Элементы.ПредставлениеЭД.Заголовок = ОбменСКонтрагентамиСлужебный.ПолучитьПредставлениеЭД(ЭлектронныйДокумент);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("НеОткрыватьФормуПриОтсутствииНеСопоставленнойНоменклатуры") Тогда
		НеОткрыватьФормуПриОтсутствииНеСопоставленнойНоменклатуры = Параметры.НеОткрыватьФормуПриОтсутствииНеСопоставленнойНоменклатуры;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
		ТекстСообщения = НСтр("ru='Не выбран электронный документ';uk='Не вибрано електронний документ'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ЭлектронныйДокумент", , Отказ);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлектронныйДокумент) = Тип("Структура") Тогда
		// ЭлектронныйДокумент в случае сопоставления в однократной сделке - структура.
		ВладелецЭД = ЭлектронныйДокумент.ВладелецФайла;
		ВидЭД = ЭлектронныйДокумент.ВидЭД;
		СпособОбмена = ЭлектронныйДокумент.СпособОбменаЭД;
		
	Иначе
		
		РеквизитыЭД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокумент, "ВладелецФайла, ВидЭД");
		ВладелецЭД  = РеквизитыЭД.ВладелецФайла;
		ВидЭД       = РеквизитыЭД.ВидЭД;
		
	КонецЕсли;
	
	Контрагент = ЭлектронныйДокумент.Контрагент;
	
	ПрочитатьНоменклатуруКонтрагентаСервер();
	
	Если НеОткрыватьФормуПриОтсутствииНеСопоставленнойНоменклатуры
		И Список.Количество() = 0 Тогда
		// Форму открывать не требуется
		ЗакрытьНаКлиенте = Истина;
		
		Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров
			И ТипЗнч(ЭлектронныйДокумент) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
			
			СохранитьДанныеКаталога(ЭлектронныйДокумент);
		КонецЕсли;
		
	КонецЕсли;
	
	// Обработка колонки "Номенклатура".
	ИмяСправочникаНоменклатура = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Номенклатура");
	ТипНоменклатуры = Новый ОписаниеТипов("СправочникСсылка." + ИмяСправочникаНоменклатура);
	Элементы.НоваяНоменклатураКонтрагентаНоменклатура.ОграничениеТипа = ТипНоменклатуры;
	
	// Обработка колонки "Характеристика номенклатуры".
	ИспользуютсяХарактеристикиНоменклатуры = ОбменСКонтрагентамиПовтИсп.ДополнительнаяАналитикаСправочникХарактеристикиНоменклатуры();
	Элементы.НоваяНоменклатураКонтрагентаХарактеристикаНоменклатуры.Видимость = ИспользуютсяХарактеристикиНоменклатуры;
	Если ИспользуютсяХарактеристикиНоменклатуры Тогда
		
		ИмяСправочникаХарактеристикиНоменклатуры = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(
			"ХарактеристикиНоменклатуры");
		ТипХарактеристикаНоменклатуры = Новый ОписаниеТипов("СправочникСсылка." + ИмяСправочникаХарактеристикиНоменклатуры);
		Элементы.НоваяНоменклатураКонтрагентаХарактеристикаНоменклатуры.ОграничениеТипа = ТипХарактеристикаНоменклатуры;
	
	КонецЕсли;
	
	// Обработка колонки "Упаковка номенклатуры".
	ИспользуютсяУпаковкиНоменклатуры = ОбменСКонтрагентамиПовтИсп.ДополнительнаяАналитикаСправочникУпаковкиНоменклатуры();
	Элементы.НоваяНоменклатураКонтрагентаУпаковкаНоменклатуры.Видимость = ИспользуютсяУпаковкиНоменклатуры;
	Если ИспользуютсяУпаковкиНоменклатуры Тогда
		
		ИмяСправочникаУпаковкиНоменклатуры = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(
			"УпаковкиНоменклатуры");
		ТипУпаковкаНоменклатуры = Новый ОписаниеТипов("СправочникСсылка." + ИмяСправочникаУпаковкиНоменклатуры);
		Элементы.НоваяНоменклатураКонтрагентаУпаковкаНоменклатуры.ОграничениеТипа = ТипУпаковкаНоменклатуры;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗакрытьНаКлиенте Тогда
		
		Отказ = Истина;
		ВыполнитьДействияПриЗакрытииФормы();
		Если ЭтотОбъект.ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ЭтотОбъект.ОписаниеОповещенияОЗакрытии, Истина);
		КонецЕсли;
		
	Иначе
		
		ЗаполнитьПараметрыОповещения("ВыполнялосьСопоставление", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ОписаниеОповещенияОЗакрытии = Неопределено Тогда
		
		Если ПерезаполнитьПриЗакрытии Тогда
			ВыполнитьДействияПриЗакрытииФормы();
		Иначе
			Если Не ЗакрытьНаКлиенте Тогда
				ЗаполнитьПараметрыОповещения("ОтказЗаполнения", Истина);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеЭДНажатие(Элемент)
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ЭлектронныйДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура НоваяНоменклатураКонтрагентаНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураПараметров = Новый Структура("Контрагент", Контрагент);
	СтруктураПараметров.Вставить("Номенклатура", 
		Элементы.Список.ТекущиеДанные.Номенклатура);
	
	ОбменСКонтрагентамиКлиентПереопределяемый.ОткрытьФормуСопоставленияНоменклатуры(
		Элемент, СтруктураПараметров, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущийЭлемент.Имя = "НоваяНоменклатураКонтрагентаНаименованиеНоменклатурыКонтрагента" Тогда
		ОбменСКонтрагентамиКлиентПереопределяемый.ОткрытьЭлементНоменклатурыПоставщика(Элемент.ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрочитатьНоменклатуруКонтрагента(Команда)
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Несохраненные изменения будут утеряны.
            |Продолжить?'
            |;uk='Незбережені зміни будуть втрачені.
            |Продовжити?'");
			
		ОбработчикОповещения = Новый ОписаниеОповещения("ПрочитатьНоменклатуруОповещение", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, НСтр("ru='Заполнение списка номенклатуры';uk='Заповнення списку номенклатури'"));
		
	Иначе
		ПрочитатьНоменклатуруКонтрагентаСервер();
		Модифицированность = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНоменклатуруОповещение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат
	КонецЕсли;
	
	ПрочитатьНоменклатуруКонтрагентаСервер();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНоменклатуруКонтрагента(Команда)
	
	Отказ = Ложь;
	ЗаписатьНоменклатуруКонтрагентаСервер(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПерезаполнитьПриЗакрытии = Истина;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьДействияПриЗакрытииФормы()
	
	Если СпособОбмена = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.БыстрыйОбмен") Тогда
		Возврат;
	КонецЕсли;
	
	ПерезаполнитьЭД();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыОповещения(ИмяПараметра, ЗначениеПараметра)
	
	Если ЭтотОбъект.ОписаниеОповещенияОЗакрытии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗакрытии = ЭтотОбъект.ОписаниеОповещенияОЗакрытии;
	Если ЗначениеЗаполнено(ОповещениеОЗакрытии.ДополнительныеПараметры) Тогда
		
		ДопПараметры = ОповещениеОЗакрытии.ДополнительныеПараметры;
		Если ДопПараметры.Свойство(ИмяПараметра) Тогда
			ДопПараметры[ИмяПараметра] = ЗначениеПараметра;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьДанныеКаталога(СсылкаНаЭД)
	
	ЭтоОднократнаяСделка = Ложь;
	
	Если ТипЗнч(СсылкаНаЭД) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
		ДопИнформацияПоЭД = ПрисоединенныеФайлы.ПолучитьДанныеФайла(СсылкаНаЭД,
		                                                            СсылкаНаЭД.УникальныйИдентификатор(),
		                                                            Истина);
	ИначеЕсли ТипЗнч(СсылкаНаЭД) = Тип("Структура") Тогда // однократная сделка
		ДопИнформацияПоЭД = Новый Структура;
		
		ДопИнформацияПоЭД.Вставить("СсылкаНаДвоичныеДанныеФайла", СсылкаНаЭД.ДанныеФайлаРазбора);
		ДопИнформацияПоЭД.Вставить("Расширение", "xml");
		ЭтоОднократнаяСделка = Истина;
	КонецЕсли;
	
	Если ДопИнформацияПоЭД.Свойство("СсылкаНаДвоичныеДанныеФайла")
		И ЗначениеЗаполнено(ДопИнформацияПоЭД.СсылкаНаДвоичныеДанныеФайла) Тогда
		
		ДанныеЭД = ПолучитьИзВременногоХранилища(ДопИнформацияПоЭД.СсылкаНаДвоичныеДанныеФайла);
		
		Если ЗначениеЗаполнено(ДопИнформацияПоЭД.Расширение) Тогда
			ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла(ДопИнформацияПоЭД.Расширение);
		Иначе
			ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
		КонецЕсли;
		
		Если ИмяФайла = Неопределено Тогда
			ТекстОшибки = НСтр("ru='Не удалось просмотреть электронный документ. Проверьте настройку рабочего каталога';uk='Не вдалося переглянути електронний документ. Перевірте настройки робочого каталогу'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		Если Не ЭтоОднократнаяСделка Тогда
			ВыборкаЭДДопДанных = ОбменСКонтрагентамиСлужебный.ВыборкаДопДанныеЭД(СсылкаНаЭД);
			Если ВыборкаЭДДопДанных.Следующий() Тогда
				ДопДанныеЭД = ПрисоединенныеФайлы.ПолучитьДанныеФайла(
																ВыборкаЭДДопДанных.Ссылка,
																ВыборкаЭДДопДанных.Ссылка.УникальныйИдентификатор(),
																Истина);
				СсылкаНаДДДопДанныхЭД = "";
				Если ДопДанныеЭД.Свойство("СсылкаНаДвоичныеДанныеФайла", СсылкаНаДДДопДанныхЭД)
						И ЗначениеЗаполнено(СсылкаНаДДДопДанныхЭД) Тогда
					ДанныеДопФайла = ПолучитьИзВременногоХранилища(СсылкаНаДДДопДанныхЭД);
			
					Если ЗначениеЗаполнено(ДопДанныеЭД.Расширение) Тогда
						ИмяФайлаДопДанных = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла(ДопДанныеЭД.Расширение);
					Иначе
						ИмяФайлаДопДанных = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
					КонецЕсли;
			
					Если ИмяФайлаДопДанных = Неопределено Тогда
						ТекстОшибки = НСтр("ru='Не удалось получить доп. данные электронного документа.
                                                | Проверьте настройку рабочего каталога'
                                                |;uk='Не вдалося отримати дод. дані електронного документа.
                                                |Перевірте настройки робочого каталогу'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
						Возврат;
					КонецЕсли;
					ДанныеДопФайла.Записать(ИмяФайлаДопДанных);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ДанныеЭД.Записать(ИмяФайла);
		
		Если СтрНайти(ДопИнформацияПоЭД.Расширение, "zip") > 0 Тогда
			ЗИПЧтение = Новый ЧтениеZipФайла(ИмяФайла);
			ПапкаДляРаспаковки = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог(, СсылкаНаЭД.УникальныйИдентификатор());
			
			Если ПапкаДляРаспаковки = Неопределено Тогда
				ТекстОшибки = НСтр("ru='Не удалось просмотреть электронный документ. Проверьте настройку рабочего каталога';uk='Не вдалося переглянути електронний документ. Перевірте настройки робочого каталогу'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
				ЗИПЧтение.Закрыть();
				УдалитьФайлы(ИмяФайла);
				Возврат;
			КонецЕсли;
			
			Попытка
				ЗипЧтение.ИзвлечьВсе(ПапкаДляРаспаковки);
			Исключение
				ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				Если НЕ ЭлектронноеВзаимодействиеСлужебный.ВозможноИзвлечьФайлы(ЗипЧтение, ПапкаДляРаспаковки) Тогда
					ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ПолучитьСообщениеОбОшибке("006");
				КонецЕсли;
				Операция = НСтр("ru='Распаковка ЭД';uk='Розпакування ЕД'");
				ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(Операция,
																							ТекстОшибки,
																							ТекстСообщения);
				ЗИПЧтение.Закрыть();
				УдалитьФайлы(ИмяФайла);
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат;
			КонецПопытки;
			
			ФайлыАрхиваXML = НайтиФайлы(ПапкаДляРаспаковки, "*.xml");
			Для Каждого РаспакованныйФайл Из ФайлыАрхиваXML Цикл
				ИмяФайлаДанных = РаспакованныйФайл.ПолноеИмя;
			КонецЦикла;
			
			МассивФайловКартинок = НайтиФайлы(ПапкаДляРаспаковки, "*.zip", Истина);
			Если МассивФайловКартинок.Количество() > 0 Тогда
				ФайлКартинок = МассивФайловКартинок[0];
				ИмяФайлаКартинок = ФайлКартинок.ПолноеИмя;
			КонецЕсли;
			
		ИначеЕсли СтрНайти(ДопИнформацияПоЭД.Расширение, "xml") > 0 Тогда
			
			ИмяФайлаДанных = ИмяФайла;
			
		КонецЕсли;
		
		СтруктураРазбора = ОбменСКонтрагентамиВнутренний.СформироватьДеревоРазбора(
			ИмяФайлаДанных, Перечисления.НаправленияЭД.Входящий, ИмяФайлаДопДанных, ИмяФайлаКартинок);
		
		УдалитьФайлы(ИмяФайла);
		Если НЕ ИмяФайлаДопДанных = Неопределено Тогда
			УдалитьФайлы(ИмяФайлаДопДанных);
		КонецЕсли;

		Если ЗначениеЗаполнено(ПапкаДляРаспаковки) Тогда
			УдалитьФайлы(ПапкаДляРаспаковки);
		КонецЕсли;
		
		Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора") Тогда
			ОбменСКонтрагентамиПереопределяемый.СохранитьДанныеОбъектаВБД(
											СтруктураРазбора.СтрокаОбъекта,
											СтруктураРазбора.ДеревоРазбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьЭД()
	
	Если ЗначениеЗаполнено(ВладелецЭД) Тогда
		
		ОбменСКонтрагентамиКлиент.ПерезаполнитьДокумент(
			ВладелецЭД,
			,
			Истина,
			?(ТипЗнч(ЭлектронныйДокумент) = Тип("Структура"), Неопределено, ЭлектронныйДокумент));
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция БыстрыйОбменТаблицаИнформацияОТоваре(ЭД)
	
	Перем ТаблицаВозврата;
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанныеФайлаРазбора = ПолучитьИзВременногоХранилища(ЭД.ДанныеФайлаРазбора);
	ДвоичныеДанныеФайлаРазбора.Записать(ВремФайл);
	ОбменСКонтрагентамиВнутренний.ИнформацияОТовареИзФайлаXML(ВремФайл, ТаблицаВозврата, ЭД);
	УдалитьФайлы(ВремФайл);
	
	Возврат ТаблицаВозврата;
	
КонецФункции

&НаСервере
Процедура ПрочитатьНоменклатуруКонтрагентаСервер()
	
	Запрос = Новый Запрос;
	ОбменСКонтрагентамиПереопределяемый.ТекстЗапросаСопоставленияНоменклатуры(Запрос.Текст);
	
	Если НЕ ЗначениеЗаполнено(Запрос.Текст) Тогда
		ТекстСообщения = НСтр("ru='Не определено сопоставление номенклатуры и номенклатуры поставщиков.
        |Необходимо заполнить процедуру ОбменСКонтрагентамиПереопределяемый.ТекстЗапросаСопоставленияНоменклатуры.'
        |;uk='Не визначено зіставлення номенклатури та номенклатури постачальників.
        |Необхідно заповнити процедуру ОбменСКонтрагентамиПереопределяемый.ТекстЗапросаСопоставленияНоменклатуры.'");
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Если ТипЗнч(ЭлектронныйДокумент) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
		МассивЭД = Новый Массив;
		МассивЭД.Добавить(ЭлектронныйДокумент);
		ТаблицаИнформацияОТоваре = ОбменСКонтрагентамиВнутренний.ПолучитьИнформациюОТоваре(МассивЭД);
	Иначе
		ТаблицаИнформацияОТоваре = БыстрыйОбменТаблицаИнформацияОТоваре(ЭлектронныйДокумент);
	КонецЕсли;
	
	Если ТаблицаИнформацияОТоваре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблицаИнформацияОТоваре", ТаблицаИнформацияОТоваре);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	ТЗСопоставления = Запрос.Выполнить().Выгрузить();
	ТЗСопоставления.Свернуть("АртикулНоменклатурыКонтрагента, НаименованиеНоменклатурыКонтрагента, ЕдиницаНоменклатурыКонтрагента, Описание, Идентификатор");
	
	Список.Загрузить(ТЗСопоставления);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНоменклатуруКонтрагентаСервер(Отказ = Ложь)
	
	ОбменСКонтрагентамиПереопределяемый.ЗаписатьСопоставлениеНоменклатуры(
		Список,
		Контрагент,
		Отказ);
		
	Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		СохранитьДанныеКаталога(ЭлектронныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
