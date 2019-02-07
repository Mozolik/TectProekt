﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
	Объект.ЭтапыГрафикаОплаты.Очистить();
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	ЗаполнитьЭтапыОплатыИзВременногоХранилищаСервер(Параметры.АдресВоВременномХранилище);
	РассчитатьИтоговыеПоказателиСоглашенияСПоставщиком(ЭтаФорма);
	ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	МассивПараметров = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Значение", Перечисления.ВариантыОплатыПоставщику.КредитПослеПоступления));
	КонецЕсли;
	Элементы.ЭтапыГрафикаОплатыВариантОплаты.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Если ЗначениеЗаполнено(Объект.Календарь) Тогда 
		РежимУчетаОтсрочки = 1;
	Иначе
		Элементы.Календарь.Доступность = Ложь;
	КонецЕсли;
	Элементы.ФормаОК.Видимость = Объект.Статус <> Перечисления.СтатусыПланов.Утвержден;
	Элементы.ГруппаСтатусУтвержден.Видимость = Объект.Статус = Перечисления.СтатусыПланов.Утвержден;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяЗакрытие Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Модифицированность И Не Готово Тогда
			
			СписокКнопок = Новый СписокЗначений();
			СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
			СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
			
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Все измененные данные будут потеряны. Закрыть форму?';uk='Всі змінені дані будуть втрачені. Закрити форму?'"), СписокКнопок);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ЗаполнитьЭтапыОплатыИзВременногоХранилищаСервер(АдресВоВременномХранилище)
	
	ЭтапыОплаты = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Для Каждого ТекСтрока Из ЭтапыОплаты Цикл
		НоваяСтрока = Объект.ЭтапыГрафикаОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиСоглашенияСПоставщиком(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиСоглашенияСПоставщиком(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыВариантОплатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = (ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика")
		Или ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту"));
	
	Если НЕ СтандартнаяОбработка 
		И ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссию") Тогда
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.КредитПослеПоступления"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимУчетаОтсрочкиПриИзменении(Элемент)
	
	Элементы.Календарь.Доступность = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	Элементы.Календарь.АвтоОтметкаНезаполненного = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	
	Если РежимУчетаОтсрочки = 1 Тогда
		ЗаполнитьПроизводственныйКалендарьНаСервере();
	Иначе
		Объект.Календарь = ПредопределенноеЗначение("Справочник.ПроизводственныеКалендари.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если ОплатаКорректна() Тогда
		
		Готово = Истина;
		СтруктураОбъекта = Новый Структура();
		СтруктураОбъекта.Вставить("Календарь", Объект.Календарь);
		СтруктураОбъекта.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилищеНаСервере());
		СтруктураОбъекта.Вставить("Статус", Объект.Статус);
		
		Закрыть(СтруктураОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыСдвиг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.СдвигЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.СдвигЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.НомерСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Seagreen);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаСервере
Функция ОплатаКорректна()

	Отказ = Ложь;
	КоличествоЭтапов = Объект.ЭтапыГрафикаОплаты.Количество();
	
	Для ТекИндекс = 0 По Объект.ЭтапыГрафикаОплаты.Количество()-1 Цикл
		
		ТекСтрока = Объект.ЭтапыГрафикаОплаты[ТекИндекс];
		
		АдресОшибки = НСтр("ru=' в строке %НомерСтроки% списка ""Этапы графика оплаты""';uk=' у рядку %НомерСтроки% списку ""Етапи графіку оплати""'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", ТекСтрока.НомерСтроки);
		
		Если Не ЗначениеЗаполнено(ТекСтрока.ВариантОплаты) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Вариант оплаты""';uk='Не заповнена колонка ""Варіант оплати""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.ЭтапыГрафикаОплаты", ТекСтрока.НомерСтроки, "ВариантОплаты"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекСтрока.ПроцентПлатежа) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Процент платежа""';uk='Не заповнена колонка ""Відсоток платежу""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки + АдресОшибки,
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
			"Объект.ЭтапыГрафикаОплаты",
			ТекСтрока.НомерСтроки,
			"ПроцентПлатежа"),
			,
			Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоЭтапов > 0 Тогда
		
		Если Объект.ЭтапыГрафикаОплаты.Итог("ПроцентПлатежа") <> 100 Тогда
			
			ТекстОшибки = НСтр("ru='Процент платежей по всем этапам должен быть равен 100%';uk='Відсоток платежів за всіма етапами повинен дорівнювати 100%'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				"Объект.ЭтапыГрафикаОплаты",
				,
				Отказ);
			
		КонецЕсли;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
			
			Для Каждого ЭтапГрафикаОплаты Из Объект.ЭтапыГрафикаОплаты Цикл
				
				Если ЭтапГрафикаОплаты.ВариантОплаты <> Перечисления.ВариантыОплатыПоставщику.КредитПослеПоступления Тогда
					
					ТекстОшибки = НСтр("ru='Вариант оплаты ""%ВариантОплаты%"" нельзя использовать
                        |при установленной хозяйственной операции ""Прием на комиссию""'
                        |;uk='Варіант оплати ""%ВариантОплаты%"" не можна використовувати
                        |при встановленій господарської операції ""Приймання на комісію""'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВариантОплаты%", ЭтапГрафикаОплаты.ВариантОплаты);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстОшибки,
						,
						"Объект." + ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", ЭтапГрафикаОплаты.НомерСтроки,"ВариантОплаты"),
						,
						Отказ);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		ПроверитьЭтапыГрафикаОплаты(Отказ);
		
	КонецЕсли;
	
	Если РежимУчетаОтсрочки = 1 и Не ЗначениеЗаполнено(Объект.Календарь) Тогда
		
		ТекстОшибки = НСтр("ru='Не указан календарь для усчета отсрочки по рабочим дням.';uk='Не зазначений календар для обліку відстрочки по робочих днях.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		ТекстОшибки,
		,
		"Объект.Календарь",
		,
		Отказ);
		
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ЭтапыГрафикаОплаты.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиСоглашенияСПоставщиком(Форма)
	
	ПроцентПлатежейОбщий = 0;
	ПредыдущееЗначениеСдвига = 0;
	Форма.НомерСтрокиПолнойОплаты = 0;
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаОплаты Цикл
		
		ПроцентПлатежейОбщий = ПроцентПлатежейОбщий + ТекСтрока.ПроцентПлатежа;
		ТекСтрока.ПроцентЗаполненНеВерно = (ПроцентПлатежейОбщий > 100);
		Если ПроцентПлатежейОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
		
		ТекСтрока.СдвигЗаполненНеВерно = (ПредыдущееЗначениеСдвига > ТекСтрока.Сдвиг);
		ПредыдущееЗначениеСдвига = ТекСтрока.Сдвиг;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЭтапыГрафикаОплаты(Отказ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГрафикиОплатыЭтапы.НомерСтроки КАК НомерСтроки,
	|	ГрафикиОплатыЭтапы.Сдвиг КАК ЗначениеСдвигаОплаты,
	|	ГрафикиОплатыЭтапы.ВариантОплаты КАК ЗначениеВариантаОплаты
	|ПОМЕСТИТЬ ВременнаяТабличнаяЧасть
	|ИЗ
	|	&ЭтапыГрафикаОплаты КАК ГрафикиОплатыЭтапы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	|	ТабличнаяЧасть.ЗначениеСдвигаОплаты КАК ЗначениеСдвигаОплаты,
	|	ТабличнаяЧасть.ЗначениеВариантаОплаты КАК ЗначениеВариантаОплаты,
	|	ВЫБОР КОГДА ТабличнаяЧасть.ЗначениеВариантаОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.ПустаяСсылка) 
	|		ТОГДА 0
	|		ИНАЧЕ ТабличнаяЧасть.ЗначениеВариантаОплаты.Порядок
	|	КОНЕЦ КАК ЗначениеПорядкаОплаты
	|ИЗ
	|	ВременнаяТабличнаяЧасть КАК ТабличнаяЧасть
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ЭтапыГрафикаОплаты", Объект.ЭтапыГрафикаОплаты.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПредыдущееЗначениеПорядкаОплаты = 0;
	ПредыдущееЗначениеСдвигаОплаты = 0;
	ПредыдущееЗначениеВариантаОплаты = Неопределено;
	Пока Выборка.Следующий() Цикл
		
		Если ПредыдущееЗначениеПорядкаОплаты > Выборка.ЗначениеПорядкаОплаты Тогда
			
			ТекстОшибки = НСтр("ru='Вариант оплаты ""%ТекущееЗначениеВариантаОплаты%"" в строке %ИндексТекущегоЭтапа%
            |не может идти после варианта оплаты ""%ПредыдущееЗначениеВариантаОплаты%"" в строке %ИндексПредыдущегоЭтапа%'
            |;uk='Варіант оплати ""%ТекущееЗначениеВариантаОплаты%"" в рядку %ИндексТекущегоЭтапа%
            |не може йти після варіанти оплати ""%ПредыдущееЗначениеВариантаОплаты%"" в рядку %ИндексПредыдущегоЭтапа%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ПредыдущееЗначениеВариантаОплаты%", ПредыдущееЗначениеВариантаОплаты);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ТекущееЗначениеВариантаОплаты%",    Выборка.ЗначениеВариантаОплаты);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексТекущегоЭтапа%",              Выборка.НомерСтроки);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексПредыдущегоЭтапа%",           Выборка.НомерСтроки-1);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				"Объект." + ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты",Выборка.НомерСтроки,"ВариантОплаты"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Выборка.ЗначениеВариантаОплаты = Перечисления.ВариантыОплатыПоставщику.КредитПослеПоступления И //Если текущий вариант оплаты кредитный
			Выборка.ЗначениеПорядкаОплаты <> ПредыдущееЗначениеПорядкаОплаты Тогда // Если предыдущий вариант оплаты был НЕ кредитный
			
			// Отсрочка платежа для кредитных этапов будет рассчитываться от другой даты, 
			// 		необходимо разрешить назначать отсрочки для следующих этапов начиная с 0 дней
			ПредыдущееЗначениеСдвигаОплаты = 0;
			
		КонецЕсли;
		
		ПредыдущееЗначениеПорядкаОплаты = Выборка.ЗначениеПорядкаОплаты;
		
		Если ПредыдущееЗначениеСдвигаОплаты > Выборка.ЗначениеСдвигаОплаты Тогда
			
			ТекстОшибки = НСтр("ru='Отсрочка в строке %ИндексТекущегоЭтапа% 
            | должна быть не меньше, чем в строке %ИндексПредыдущегоЭтапа%'
            |;uk='Відстрочка в рядку %ИндексТекущегоЭтапа% 
            |повинна бути не менше, ніж у рядку %ИндексПредыдущегоЭтапа%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексТекущегоЭтапа%",    Выборка.НомерСтроки);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексПредыдущегоЭтапа%", Выборка.НомерСтроки-1);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				"Объект." + ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", Выборка.НомерСтроки, "Сдвиг"),
				,
				Отказ);
			
		КонецЕсли;
		
		ПредыдущееЗначениеСдвигаОплаты = Выборка.ЗначениеСдвигаОплаты;
		ПредыдущееЗначениеВариантаОплаты = Выборка.ЗначениеВариантаОплаты;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПроизводственныйКалендарьНаСервере()
	
	КалендарныеГрафики.ЗаполнитьПроизводственныйКалендарьВФорме(ЭтаФорма, "Объект.Календарь");
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;