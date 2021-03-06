﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		ВосстановитьНастройки();
	КонецЕсли;
	
	СкладПриИзмененииСервер();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокАктов", "СписокАктовДата");

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Создание_СкладскиеАкты"
		Или ИмяСобытия = "Запись_СписаниеНедостачТоваров"
		Или ИмяСобытия = "Запись_ПорчаТоваров"
		Или ИмяСобытия = "Запись_ПересортицаТоваров"
		Или ИмяСобытия = "Запись_ОприходованиеИзлишковТоваров"
		Или ИмяСобытия = "Запись_ИнвентаризационнаяОпись"
		Или ИмяСобытия = "Запись_ОрдерНаОтражениеИзлишковТоваровТогда"
		Или ИмяСобытия = "ОрдерНаОтражениеНедостачТоваров"
		Или ИмяСобытия = "ОрдерНаОтражениеПорчиТоваров" Тогда
		
		ОбновитьВсеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
    СкладПриИзмененииСервер();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокАктов

&НаКлиенте
Процедура СписокАктовПриИзменении(Элемент)
	ОбновлениеДекарацииСостояниеСервер();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОприходованиеИзлишковТоваров(Команда)
	ЗначенияЗаполенияАкта = Новый Структура;
	ЗначенияЗаполенияАкта.Вставить("Склад", Склад);
	
	ПараметрыФормыАкта = Новый Структура;
	ПараметрыФормыАкта.Вставить("ЗначенияЗаполнения",ЗначенияЗаполенияАкта);
	
	ОткрытьФорму("Документ.ОприходованиеИзлишковТоваров.ФормаОбъекта",ПараметрыФормыАкта);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПересортицуТоваров(Команда)
	ЗначенияЗаполенияАкта = Новый Структура;
	ЗначенияЗаполенияАкта.Вставить("Склад", Склад);
	
	ПараметрыФормыАкта = Новый Структура;
	ПараметрыФормыАкта.Вставить("ЗначенияЗаполнения",ЗначенияЗаполенияАкта);
	
	ОткрытьФорму("Документ.ПересортицаТоваров.ФормаОбъекта",ПараметрыФормыАкта);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПорчуТоваров(Команда)
	ЗначенияЗаполенияАкта = Новый Структура;
	ЗначенияЗаполенияАкта.Вставить("Склад", Склад);
	
	ПараметрыФормыАкта = Новый Структура;
	ПараметрыФормыАкта.Вставить("ЗначенияЗаполнения",ЗначенияЗаполенияАкта);
	
	ОткрытьФорму("Документ.ПорчаТоваров.ФормаОбъекта",ПараметрыФормыАкта);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеНедостачТоваров(Команда)
	ЗначенияЗаполенияАкта = Новый Структура;
	ЗначенияЗаполенияАкта.Вставить("Склад", Склад);
	
	ПараметрыФормыАкта = Новый Структура;
	ПараметрыФормыАкта.Вставить("ЗначенияЗаполнения",ЗначенияЗаполенияАкта);
	
	ОткрытьФорму("Документ.СписаниеНедостачТоваров.ФормаОбъекта",ПараметрыФормыАкта);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	ОбновитьВсеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовИзменить(Команда)
	
	ТекущиеДанные = Элементы.СписокАктов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовСкопировать(Команда)
	
	ТекущиеДанные = Элементы.СписокАктов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Документ = ТекущиеДанные.Ссылка;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", Документ);
		
		ИмяДокумента = ИмяДокумента(Документ);
		ОткрытьФорму("Документ." + ИмяДокумента + ".Форма.ФормаДокумента", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокАктов, Заголовок);
	ОбновлениеДекарацииСостояниеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокАктов, Заголовок);
	ОбновлениеДекарацииСостояниеСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписокАктов);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПриИзмененииСервер()
				
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокАктов,
			"Склад",
			Склад,
			ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(Склад));
			
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач =
		СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);

			
	Элементы.ДекорацияСостояние.Видимость 					= ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач;
	Элементы.СписокАктовСИспользованиемПомощника.Видимость 	= ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач;
	
	ОбновлениеДекарацииСостояниеСервер();
	
КонецПроцедуры
	
&НаСервере
Процедура ОбновлениеДекарацииСостояниеСервер()
	
	Если Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад) Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос.УстановитьПараметр("Склад",Склад);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Серия,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Назначение
		|ИЗ
		|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, Склад = &Склад) КАК ТоварыКОформлениюИзлишковНедостачОстатки
		|ГДЕ
		|	НЕ ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток = 0";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Серия,
		|	ТоварыКОформлениюИзлишковНедостачОстатки.Назначение
		|ИЗ
		|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки КАК ТоварыКОформлениюИзлишковНедостачОстатки
		|ГДЕ
		|	НЕ ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток = 0";
	КонецЕсли;
	
	ТоварыКоличество = Запрос.Выполнить().Выбрать().Количество();
	Если ТоварыКоличество > 0 Тогда
		МассивСтрок.Добавить(НСтр("ru='Есть товары, по которым необходимо оформить складские акты (';uk='Є товари, за якими необхідно оформити складські акти ('"));
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока( "" + ТоварыКоличество + " " +
			ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
				ТоварыКоличество, 
				НСтр("ru='товар';uk='товар'"), НСтр("ru='товара';uk='товара'"), НСтр("ru='товаров';uk='товарів'"), "м"),,,,"Отчет"));
		МассивСтрок.Добавить(")." + Символы.ПС);
	КонецЕсли;
		
	Если ЕстьНеоформленныеПересчетыПоСкладу(Склад) Тогда
		МассивСтрок.Добавить(НСтр("ru='Есть';uk='Є'")+ " ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='пересчеты товаров';uk='перерахунки товарів'"),,,,"СписокПересчетов"));
		МассивСтрок.Добавить(", по которым еще не завершено внесение результатов (они не проведены в статусе ""Выполнено"").");
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		Элементы.ДекорацияСостояние.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
		Элементы.ДекорацияСостояние.Видимость = Истина;
	Иначе
		Элементы.ДекорацияСостояние.Заголовок = "";
		Элементы.ДекорацияСостояние.Видимость = Ложь;			
	КонецЕсли;
				
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СписаниеНедостачТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОприходованиеИзлишковТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПересортицаТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПорчаТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.СписокАктов.ТекущаяСтрока = Ссылка;
		
		ПоказатьЗначение(,Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьПометкуУдаления(Список, ТипСписка)
	
	ТекущиеДанные = Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ВыделенныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Список);
		
		Если ВыделенныеСтроки.Количество() = 1 Тогда
			
			Документ = ТекущиеДанные.Ссылка;
			ЕстьСтрокиПомеченныеНаУдаление = ТекущиеДанные.ПометкаУдаления;
			
			МассивСсылок = Новый Массив;
			МассивСсылок.Добавить(Документ);
			
			ТекстВопроса = ?(ТекущиеДанные.ПометкаУдаления,
				НСтр("ru='Снять с ""%Документ%"" пометку на удаление?';uk='Зняти з ""%Документ%"" позначку для вилучення?'"),
				НСтр("ru='Пометить ""%Документ%"" на удаление?';uk='Позначити ""%Документ%"" для вилучення?'"));
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Документ%", Документ);
			
		Иначе
			
			Результат = ОбщегоНазначенияУТВызовСервера.СсылкиОбъектовПомеченныхНаУдаление(ВыделенныеСтроки, "Ссылка");
			
			МассивСсылок = Результат.МассивСсылок;
			ЕстьСтрокиПомеченныеНаУдаление = Результат.ЕстьСтрокиПомеченныеНаУдаление;
			
			ТекстВопроса = ?(Результат.ЕстьСтрокиПомеченныеНаУдаление,
				НСтр("ru='Снять с выделенных элементов пометку на удаление?';uk='Зняти з виділених елементів позначку на вилучення?'"),
				НСтр("ru='Пометить выделенные элементы на удаление?';uk='Відмітити виділені елементи для вилучення?'"));
			
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура("Список, ВыделенныеСтроки, ТипСписка, УстановкаПометкиУдаления",
			Список, МассивСсылок, ТипСписка, Не ЕстьСтрокиПомеченныеНаУдаление);
		
		Оповещение = Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Список = ДополнительныеПараметры.Список;
		ТипСписка = ДополнительныеПараметры.ТипСписка;
		МассивСсылок = ДополнительныеПараметры.ВыделенныеСтроки;
		ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
		
		ОбщегоНазначенияУТВызовСервера.УстановитьПометкуУдаленияЗавершениеСервер(МассивСсылок, ПометитьНаУдаление);
		
		Если МассивСсылок.Количество() > 1 Тогда
			Документ = ТипСписка;
			ТекстОповещения = ?(Не ПометитьНаУдаление, 
				НСтр("ru='Пометка удаления снята (%КоличествоДокументов%)';uk='Позначка вилучення знята (%КоличествоДокументов%)'"),
				НСтр("ru='Пометка удаления установлена (%КоличествоДокументов%)';uk='Позначка вилучення встановлена (%КоличествоДокументов%)'"));
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", МассивСсылок.Количество());
		Иначе
			Документ = МассивСсылок[0];
			ТекстОповещения = ?(Не ПометитьНаУдаление,
				НСтр("ru='Пометка удаления снята';uk='Позначка вилучення знята'"),
				НСтр("ru='Пометка удаления установлена';uk='Позначка вилучення встановлена'"));
		КонецЕсли;
		
		Список.Обновить();
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ),
			БиблиотекаКартинок.Информация32);
		
		ОбновлениеДекарацииСостояниеСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	Перем ЗначениеНастроек;

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.СкладскиеАкты", "НастройкиОбработки");
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		ЗначениеНастроек.Свойство("Склад", Склад);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	Перем Настройки;

	Настройки = Новый Структура;
	Настройки.Вставить("Склад", Склад);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.СкладскиеАкты", "НастройкиОбработки", Настройки);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнвентаризационнуюОпись(Команда)
	ЗначенияЗаполенияАкта = Новый Структура;
	ЗначенияЗаполенияАкта.Вставить("Склад", Склад);
	
	ПараметрыФормыАкта = Новый Структура;
	ПараметрыФормыАкта.Вставить("ЗначенияЗаполнения",ЗначенияЗаполенияАкта);
	
	ОткрытьФорму("Документ.ИнвентаризационнаяОпись.ФормаОбъекта",ПараметрыФормыАкта);
КонецПроцедуры

&НаКлиенте
Процедура СИспользованиемПомощника(Команда)
	
	ПараметрыФормы = Новый Структура("Склад", Склад);
	ОткрытьФорму("Обработка.ПомощникОформленияСкладскихАктов.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "Отчет" Тогда
		
		Если ЗначениеЗаполнено(Склад) Тогда
			ПараметрыФормы = Новый Структура(
				"Отбор, ФиксированныеНастройки, ПользовательскиеНастройки, КлючВарианта, КлючНазначенияИспользования, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов, Склад",
				Новый Структура("Склад", Склад),
				Неопределено,
				Новый ПользовательскиеНастройкиКомпоновкиДанных,
				"ОформлениеИзлишковНедостачКонтекст",
				"ОформлениеИзлишковНедостачКонтекст",
				Истина,
				Ложь,
				Склад);
		Иначе
			ПараметрыФормы = Новый Структура(
				"Отбор, ФиксированныеНастройки, ПользовательскиеНастройки, КлючВарианта, КлючНазначенияИспользования, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов",
				Новый Структура(),
				Неопределено,
				Новый ПользовательскиеНастройкиКомпоновкиДанных,
				"ОформлениеИзлишковНедостачТоваров",
				"ОформлениеИзлишковНедостачТоваров",
				Истина,
				Истина);
				
		КонецЕсли;		
		
		ОткрытьФорму("Отчет.ОформлениеИзлишковНедостачТоваров.Форма", ПараметрыФормы, ЭтаФорма, );
		
	ИначеЕсли НавигационнаяСсылка = "СписокПересчетов" Тогда
		
		СтруктураБыстрогоОтбора = Новый Структура;
		СтруктураБыстрогоОтбора.Вставить("Склад", Склад);
		
		ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора, Статус", СтруктураБыстрогоОтбора, "ТолькоНевыполненные");
		
		ОткрытьФорму("Документ.ПересчетТоваров.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьНеоформленныеПересчетыПоСкладу(Склад)
	
	Возврат ?(ЗначениеЗаполнено(Склад),Документы.ПересчетТоваров.ПолучитьСписокНеоформленныхПересчетовПоСкладу(Склад).Количество() > 0,Ложь);
	
КонецФункции

&НаСервере
Процедура ОбновитьВсеНаСервере()
	Элементы.СписокАктов.Обновить();
	ОбновлениеДекарацииСостояниеСервер();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяДокумента(Документ)
	
	Возврат Документ.Метаданные().Имя;
	
КонецФункции

#КонецОбласти

#КонецОбласти
