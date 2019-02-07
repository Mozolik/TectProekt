﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КодФормы = "Справочник_Номенклатура_ФормаСписка";
	                  
	ПодборТоваровСервер.ПриСозданииНаСервере(ЭтаФорма);
	
	ДоступенВводБезКонтроля = Справочники.Номенклатура.ДоступенВводБезКонтроля();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ЕстьПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура);
	
	Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	
	ЕстьПравоСоздания = ПравоДоступа("Добавление", Метаданные.Справочники.Номенклатура);
	
	Элементы.КоманднаяПанельФильтры.Видимость = ЕстьПравоСоздания;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюСоздатьГруппу.Видимость = ЕстьПравоСоздания;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюИзменить.Видимость = ЕстьПравоСоздания;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюСкопировать.Видимость = ЕстьПравоСоздания;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюУстановитьПометкуУдаления.Видимость = ЕстьПравоСоздания;
	
	Если ЗначениеЗаполнено(Параметры.НоменклатураФильтраПоСвойствам) Тогда
		ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтаФорма, Параметры.НоменклатураФильтраПоСвойствам);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	ПанельКомандПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.ПодменюПечатьСписокРасширенный,
		Элементы.ПодменюПечатьСписокСтандартный);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, ПанельКомандПечати);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, ПанельКомандПечати);
	// Конец ИнтеграцияС1СДокументооборотом
	
	Если ПраваПользователяПовтИсп.ЭтоПартнер() Тогда
		Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
		Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаПоискПоШтрихкоду.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.КоманднаяПанельСписокРасширенныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.СписокРасширенныйПоискНоменклатураКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.КоманднаяПанельСписокСтандартныйПоискНоменклатураФормаИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.СписокСтандартныйПоискНоменклатураКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	Элементы.ИерархияНоменклатурыКонтекстноеМенюИзменитьВыделенные.Видимость = ЕстьПравоРедактирования;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
	СохранитьНастройкиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		Если ЗначениеЗаполнено(СтрокаПоискаНоменклатура) Тогда
			ВыполнитьПоискНоменклатуры();
		КонецЕсли;
		Если ЗначениеЗаполнено(Источник) Тогда
			Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)].ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиСобытийСтрокПоиска

&НаКлиенте
Процедура СтрокаПоискаНоменклатураПриИзменении(Элемент)
	
	ВыполнитьПоискНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаНоменклатураОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаПоискаНоменклатура = "";
	
	СнятьОтборПоСтрокеПоискаНоменклатурыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФлаговТочногоСоответствия

&НаКлиенте
Процедура НайтиНоменклатуруПоТочномуСоответствиюПриИзменении(Элемент)
	
	ВыполнитьПоискНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура СегментНоменклатурыПриИзменении(Элемент)
	
	СегментНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрыПриИзменении(Элемент)
	
	ИспользоватьФильтрыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураИсходногоКачестваПриИзменении(Элемент)
	
	НоменклатураИсходногоКачестваПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование И Не Группа Тогда
		
		Отказ = Истина;
		
		СтруктураПараметров = Новый Структура("Родитель, ВидНоменклатуры,  АдресТаблицыПараметров, АдресТаблицыСопоставления");
		
		Если ИспользоватьФильтры Тогда
			
			Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
				Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоСвойствам") Тогда
				
				Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
					
					СтруктураАдресовТаблиц = АдресТаблицПараметровДереваОтборовНаСервере();
					
					СтруктураПараметров.АдресТаблицыПараметров = СтруктураАдресовТаблиц.АдресТаблицыПараметров;
					СтруктураПараметров.АдресТаблицыСопоставления = СтруктураАдресовТаблиц.АдресТаблицыСопоставления;
					
					СтруктураПараметров.ВидНоменклатуры = ВидНоменклатуры;
					
				КонецЕсли;
			ИначеЕсли ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") Тогда
				Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
					СтруктураПараметров.ВидНоменклатуры = ВидНоменклатуры;
				КонецЕсли;
			Иначе
				
				СтруктураПараметров.Родитель = ?(Элементы.ИерархияНоменклатуры.ТекущиеДанные = Неопределено, ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),
				Элементы.ИерархияНоменклатуры.ТекущиеДанные.Ссылка);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
	ИначеЕсли Группа Тогда
		
		ТекущиеДанные = Элементы.ИерархияНоменклатуры.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			Отказ = Истина;
			
			СтруктураПараметров = Новый Структура("Группа", ТекущиеДанные.Ссылка);
			ОткрытьФорму("Справочник.Номенклатура.ФормаГруппы",  СтруктураПараметров, ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтборов

&НаКлиенте
Процедура ДеревоОтборовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПодборТоваровКлиент.ДеревоОтборовВыбор(ЭтаФорма, Новый ОписаниеОповещения("ДеревоОтборовПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ДеревоОтборовОтборПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтборовОтборПриИзменении(Элемент)
	
	ПодборТоваровКлиент.ДеревоОтборовОтборПриИзменении(ЭтаФорма, Новый ОписаниеОповещения("ДеревоОтборовПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыНоменклатуры

&НаКлиенте
Процедура ВидыНоменклатурыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
	 	СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатурыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		СтандартнаяОбработка = Ложь;
		ВидыНоменклатурыПеретаскиваниеНаСервере(ПараметрыПеретаскивания.Значение, СтандартнаяОбработка, Строка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВидыНоменклатурыПеретаскиваниеНаСервере(МассивНоменклатур, СтандартнаяОбработка, ВидНоменклатуры)
	
	ОбновитьСписок = Ложь;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ЭтоГруппа") Тогда
		СтандартнаяОбработка = Ложь;
	Иначе
		Для Каждого Номенклатура Из МассивНоменклатур Цикл
			Попытка
				НоменклатураОбъект = Номенклатура.ПолучитьОбъект();	
				Если НоменклатураОбъект.ВидНоменклатуры <> ВидНоменклатуры Тогда
					НоменклатураОбъект.ВидНоменклатуры = ВидНоменклатуры;
					НоменклатураОбъект.Записать();
					ОбновитьСписок = Истина;
				КонецЕсли;
			Исключение	
			КонецПопытки;
		КонецЦикла;	
	КонецЕсли;
	
	Если ОбновитьСписок Тогда
		Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)].Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияНоменклатуры

&НаКлиенте
Процедура ИерархияНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ПодборТоваровКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ПодборТоваровКлиент.ОбработчикАктивизацииСтрокиИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКачества

&НаКлиенте
Процедура СписокКачестваПометкаПриИзменении(Элемент)
	
	СписокКачестваПометкаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенныеРасширенныйПоиск(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокРасширенныйПоискНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеСтандартныйПоиск(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокСтандартныйПоискНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенныеГруппы(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.ИерархияНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура Поиск(Команда)
	
	ТекущееСообщениеПользователю = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСАналогичнымиСвойствами(Команда)
	
	НоменклатураСАналогичнымиСвойствамиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыДругогоКачества(Команда)
	
	ТоварыДругогоКачестваНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьОтборыПоСвойствам(Команда)
	
	СброситьОтборыПоСвойствамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПоиск(Команда)
	
	ПодборТоваровКлиент.НастроитьПоиск(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	СписокКоманды = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);
		
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, СписокКоманды);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Процедура ОтфильтроватьПоАналогичнымСвойствам(НоменклатураФильтраПоСвойствам) Экспорт
	ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтаФорма, НоменклатураФильтраПоСвойствам);
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтрокаПоискаНоменклатура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоискНоменклатурыНеУдачный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ПолеСОшибкойФон);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборовПредставлениеОтбора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтборов.ФиксированноеЗначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Истина, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборовПредставление.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтборов.Отбор");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИерархияНоменклатуры.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтборов.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыНоменклатуры.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКачества.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьФильтры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.FormBackColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидНоменклатуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьФильтры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

// МеханизмВнешнегоОборудования
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	ПараметрыОбработки = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();
	ПараметрыОбработки.Штрихкоды                        = ДанныеШтрихкода;
	ПараметрыОбработки.ИзменятьКоличество               = Истина;
	ПараметрыОбработки.БлокироватьДанныеФормы           = Ложь;
	ПараметрыОбработки.ДействияСНеизвестнымиШтрихкодами = "ТолькоЗарегистрировать";
	
	Номенклатура = НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения);
	Если Номенклатура <> Неопределено Тогда
		
		Элементы[ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма)].ТекущаяСтрока = Номенклатура;
		ПоказатьЗначение(,Номенклатура);
		                                         
	Иначе
		ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(ПараметрыОбработки, КэшированныеЗначения, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры
// Конец МеханизмВнешнегоОборудования

&НаСервереБезКонтекста
Функция НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения)
	
	Возврат ШтрихкодированиеНоменклатурыСервер.НоменклатураПоШтрихкоду(ПараметрыОбработки, КэшированныеЗначения); 
	
КонецФункции

#КонецОбласти

#Область Поиск

&НаКлиенте
Процедура ВыполнитьПоискНоменклатуры()
	
	ПодборТоваровКлиент.ВыполнениеРасширенногоПоискаВозможно(ЭтаФорма, 
		Новый ОписаниеОповещения("ВыполнитьПоискНоменклатурыЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ВыполнитьПоискНоменклатурыНаСервере();
	
	ПодборТоваровКлиент.ПослеВыполненияПоискаНоменклатуры(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНоменклатурыНаСервере()
	
	ПодборТоваровСервер.ВыполнитьПоискНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СнятьОтборПоСтрокеПоискаНоменклатурыНаСервере()
	
	ПодборТоваровКлиентСервер.СнятьОтборПоСтрокеПоискаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийНаСервере

&НаСервере
Процедура ИспользоватьФильтрыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииИспользованияФильтров(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВидНоменклатурыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВидаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СегментНоменклатурыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииСегментаНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураСАналогичнымиСвойствамиНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииОтображенияНоменклатураСАналогичнымиСвойствами(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДеревоОтборовОтборПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ДеревоОтборовОтборПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураИсходногоКачестваПриИзмененииНаСервере()
	
	ПодборТоваровСервер.НоменклатураИсходногоКачестваПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СписокКачестваПометкаПриИзмененииНаСервере()
	
	ПодборТоваровСервер.СписокКачестваПометкаПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ГорячиеКлавиши

&НаКлиенте
Процедура УстановитьТекущийЭлементСтрокаПоиска(Команда)
	
	ПодборТоваровКлиент.УстановитьТекущийЭлементСтрокаПоиска(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОжидания

&НаКлиенте
Процедура СписокПриАктивизацииСтрокиОбработчикОжидания()
	
	ПодборТоваровКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеВариантомНавигации

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтроки(Элемент)
	ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаВидыНоменклатуры(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		ВидНоменклатурыПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВариантНавигацииНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	ВидНоменклатурыДоПерехода = ВидНоменклатуры;
	НадписьВариантНавигацииНавигационнойСсылкиНаСервере(НавигационнаяСсылка, СтандартнаяОбработка);
	Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") Тогда
		Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатурыДоПерехода;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НадписьВариантНавигацииНавигационнойСсылкиНаСервере(НавигационнаяСсылка, СтандартнаяОбработка)
	ПодборТоваровСервер.НадписьВариантНавигацииНавигационнойСсылки(ЭтаФорма, НавигационнаяСсылка, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантНавигации(Команда)
	ПодборТоваровКлиент.ИзменитьВариантНавигации(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантНавигацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
		Или ВариантНавигации = Результат.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ВариантНавигации = Результат.Значение;
	ВариантНавигацииПриИзмененииНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура ВариантНавигацииПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВариантаНавигации(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция АдресТаблицПараметровДереваОтборовНаСервере()
	
	Структура = Новый Структура("АдресТаблицыПараметров, АдресТаблицыСопоставления");
	
	Структура.АдресТаблицыПараметров = ПодборТоваровСервер.АдресТаблицыПараметровДереваОтборов(ЭтаФорма);
	Структура.АдресТаблицыСопоставления = ПодборТоваровСервер.АдресТаблицыСопоставленияДереваОтборов(ЭтаФорма);

	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиФормыНаСервере()
	
	ПодборТоваровСервер.СохранитьНастройкиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыДругогоКачестваНаСервере()
	
	ПодборТоваровСервер.УстановитьОтборПоНоменклатуреДругогоКачества(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СброситьОтборыПоСвойствамНаСервере()
	
	ПодборТоваровСервер.СброситьОтборыПоСвойствам(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	СписокДляПечати = ?(Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура,
		Элементы.СписокРасширенныйПоискНоменклатура,
		Элементы.СписокСтандартныйПоискНоменклатура);
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, СписокДляПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокСтандартныйПоискНоменклатураВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Справочник.Номенклатура.ФормаСписка.Элемент.СписокСтандартныйПоискНоменклатура.Выбор");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенныйПоискНоменклатураВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Справочник.Номенклатура.ФормаСписка.Элемент.СписокРасширенныйПоискНоменклатура.Выбор");
	
КонецПроцедуры

#КонецОбласти
