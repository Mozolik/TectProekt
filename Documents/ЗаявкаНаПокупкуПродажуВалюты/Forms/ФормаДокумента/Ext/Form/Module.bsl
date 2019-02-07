﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовОбщееСервер();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПокупкаПродажаВалюты", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетВалютныйПриИзменении(Элемент)
	УправлениеЭлементамиФормы();
КонецПроцедуры

&НаКлиенте
Процедура СчетГривневыйПриИзменении(Элемент)
	УправлениеЭлементамиФормы();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСчетВалютныйНажатие(Элемент)
	Предупреждение(НСтр("ru='Указание счета необязательно, но необходимо для отражения планового поступления в платежном календаре';uk='Зазначення рахункуне є необов''язковим, але необхідне для відображення планового надходження у платіжному календарі'"));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСчетГривневыйНажатие(Элемент)
	ДекорацияСчетВалютныйНажатие(Элемент); // Должны вести себя одинаково
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ВалютаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВалютнаяПриИзменении(Элемент)
	
	 РассчитатьГривневоеПокрытие();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаГривневаяПриИзменении(Элемент)
	
	РассчитатьСуммуКомиссионных();

КонецПроцедуры

&НаКлиенте
Процедура КурсПриИзменении(Элемент)
	
	РассчитатьГривневоеПокрытие();
	
КонецПроцедуры

&НаКлиенте
Процедура КомиссионныеПриИзменении(Элемент)
	
	РассчитатьСуммуКомиссионных();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаКомиссионныеПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	БанкПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Если ЗаявкаИспользоваласьПриПланированииПосупленияДС() Тогда
		
		КодОтвета = Вопрос(
			НСтр("ru='На основании документа введены документы движения денежных средств.
                  |Изменение исходного документа может потребовать перепроведение подчиненных документов. 
                  |Продолжить изменение?'
                  |;uk='На підставі документа введені документи руху грошових коштів.
                  |Зміна вихідного документа може потребувати перепроведення підпорядкованих документів. 
                  |Продовжити редагування?'"),
			РежимДиалогаВопрос.ОКОтмена,
			,
			КодВозвратаДиалога.Отмена
		);
		
		Если КодОтвета <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;		
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементовОбщееСервер(Ложь);

КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		Если Объект.СчетВозврата.ВалютаДенежныхСредств <> ВалютаРегламентированногоУчета Тогда
			Объект.СчетВозврата = Неопределено;	
		КонецЕсли;
		Если Объект.СчетБанка.ВалютаДенежныхСредств <> ВалютаРегламентированногоУчета Тогда
			Объект.СчетБанка = Неопределено;	
		КонецЕсли;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПродажаВалюты Тогда
		Если Объект.СчетВозврата.ВалютаДенежныхСредств <> Объект.Валюта Тогда
			Объект.СчетВозврата = Неопределено;	
		КонецЕсли;
		Если Объект.СчетБанка.ВалютаДенежныхСредств <> Объект.Валюта Тогда
			Объект.СчетБанка = Неопределено;	
		КонецЕсли;
	КонецЕсли;

	РассчитатьСуммуДокумента();

	УстановитьСвязиВыбораСчетов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ВалютаПриИзмененииСервер()
	
	УстановитьСвязиВыбораСчетов();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьГривневоеПокрытие()
	
	Объект.СуммаГривневая = Объект.Курс * Объект.СуммаВалютная;
	РассчитатьСуммуКомиссионных();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуКомиссионных()
	
	Объект.СуммаКомиссионные = (Объект.СуммаГривневая * Объект.Комиссионные / 100);
	РассчитатьСуммуДокумента()
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуДокумента()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		Объект.СуммаДокумента = Объект.СуммаГривневая + Объект.СуммаКомиссионные;
	Иначе	
		Объект.СуммаДокумента = Объект.СуммаГривневая - Объект.СуммаКомиссионные;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура БанкПриИзмененииСервер()
	
	ВалютаОперации = Неопределено;
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		ВалютаОперации = ВалютаРегламентированногоУчета;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПродажаВалюты
		    И ЗначениеЗаполнено(Объект.Валюта) Тогда
		ВалютаОперации = Объект.Валюта;
		
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СчетБанка) Тогда
		Объект.СчетБанка = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(
			Объект.Банк,
			ВалютаОперации
		);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
	ЭтоПокупкаВалюты = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты;
	ЭтоПродажаВалюты = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПродажаВалюты;
	
	Элементы.ДекорацияСчетВалютный.Видимость  = ИспользоватьЗаявкиНаРасходованиеДенежныхСредств И ЭтоПокупкаВалюты И Не ЗначениеЗаполнено(Объект.СчетВалютный);
	Элементы.ДекорацияСчетГривневый.Видимость = ИспользоватьЗаявкиНаРасходованиеДенежныхСредств И ЭтоПродажаВалюты И Не ЗначениеЗаполнено(Объект.СчетГривневый);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		Элементы.Валюта.Заголовок = НСтр("ru='Покупаемая валюта';uk='Валюта, що купується'");
		Элементы.Курс.Заголовок = НСтр("ru='Максимальный курс';uk='Максимальний курс'");
	Иначе
		Элементы.Валюта.Заголовок = НСтр("ru='Продаваемая валюта';uk='Валюта, яка продається'");
		Элементы.Курс.Заголовок = НСтр("ru='Минимальный курс';uk='Мінімальний курс'");
	КонецЕсли;

	Элементы.Основание.Видимость = (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты);
	
	ЭтаФорма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиВыбораСчетов()
	
	СвязьСчетВозвратаВладелец = Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Организация");
	СвязьСчетБанкаВладелец = Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Банк");
	
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПокупкаВалюты") Тогда
		СвязьСчетВозвратаВалюта = Новый СвязьПараметраВыбора("Отбор.ВалютаДенежныхСредств", "ВалютаРегламентированногоУчета");
		СвязьСчетБанкаВалюта = Новый СвязьПараметраВыбора("Отбор.ВалютаДенежныхСредств", "ВалютаРегламентированногоУчета");
	Иначе
		СвязьСчетВозвратаВалюта = Новый СвязьПараметраВыбора("Отбор.ВалютаДенежныхСредств", "Объект.Валюта");
		СвязьСчетБанкаВалюта = Новый СвязьПараметраВыбора("Отбор.ВалютаДенежныхСредств", "Объект.Валюта");
	КонецЕсли;
	
	МассивСчетВозврата = Новый Массив();
	МассивСчетВозврата.Добавить(СвязьСчетВозвратаВладелец);
	МассивСчетВозврата.Добавить(СвязьСчетВозвратаВалюта);
	СвязиСчетВозврата = Новый ФиксированныйМассив(МассивСчетВозврата);
	Элементы.СчетВозврата.СвязиПараметровВыбора = СвязиСчетВозврата;
	
	МассивСчетБанка = Новый Массив();
	МассивСчетБанка.Добавить(СвязьСчетБанкаВладелец);
	МассивСчетБанка.Добавить(СвязьСчетБанкаВалюта);
	СвязиСчетБанка = Новый ФиксированныйМассив(МассивСчетБанка);
	Элементы.СчетБанка.СвязиПараметровВыбора = СвязиСчетБанка;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	УстановитьСвязиВыбораСчетов();
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовОбщееСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовОбщееСервер(ТолькоПросмотрЭлементов = Неопределено)
	
	Если ТолькоПросмотрЭлементов = Неопределено Тогда
		ТолькоПросмотрЭлементов = Объект.Проведен;
	КонецЕсли;
		
	МассивЭлементов = Новый Массив();
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("ХозяйственнаяОперация");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("СчетВалютный");
	МассивЭлементов.Добавить("СчетГривневый");
	МассивЭлементов.Добавить("СчетВозврата");
	
	МассивЭлементов.Добавить("Банк");
	МассивЭлементов.Добавить("СчетБанка");
	МассивЭлементов.Добавить("Сотрудник");
	МассивЭлементов.Добавить("Основание");
	                          
	МассивЭлементов.Добавить("Валюта");
	МассивЭлементов.Добавить("СуммаВалютная");
	МассивЭлементов.Добавить("Курс");
	МассивЭлементов.Добавить("СуммаГривневая");
	МассивЭлементов.Добавить("СуммаКомиссионные");
	МассивЭлементов.Добавить("Комиссионные");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ТолькоПросмотрЭлементов);
	
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ДекорацияСчетВалютный");
	МассивЭлементов.Добавить("ДекорацияСчетГривневый");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Не ТолькоПросмотрЭлементов);
	
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", ТолькоПросмотрЭлементов);
	
КонецПроцедуры

&НаСервере
Функция ЗаявкаИспользоваласьПриПланированииПосупленияДС()
	
	Возврат Документы.ЗаявкаНаПокупкуПродажуВалюты.ЗаявкаИспользоваласьПриПланированииПосупленияДС(Объект.Ссылка);
	
КонецФункции

#КонецОбласти

#КонецОбласти