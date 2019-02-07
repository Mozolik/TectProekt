﻿&НаКлиенте
Перем КэшированныеЗначения;  //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущееКоличество; //кеш количества в текущей строке для расчета количества серий

&НаКлиенте
Перем НужноЗадаватьВопросПередЗакрытием;


#Область ОбработчикиСобытийФормы
              
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();

	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Если ТолькоПросмотр Тогда
		Элементы.ЗавершитьВводСерий.Видимость = Ложь;
	КонецЕсли; 
	
	Склад       = Параметры.Склад;
	Помещение   = Параметры.Помещение;
	Регистратор = Параметры.Регистратор;
	АдресВоВременномХранилище = Параметры.АдресВоВременномХранилище;
	ПараметрыУказанияСерий = Параметры.ПараметрыУказанияСерий;
	
	СтруктураИзХранилища = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	
	ПоляПоиска = "Номенклатура, Характеристика";
	
	Объект.ТоварыКешДокумента.Загрузить(СтруктураИзХранилища.ТаблицаТоваров);
	Объект.СерииКешДокумента.Загрузить(СтруктураИзХранилища.ТаблицаСерий);
	
	// Закешируем значения для последующего использования значений из шапки (если такие есть)
	ЗначенияПолейДляОпределенияРаспоряжения = Новый ФиксированнаяСтруктура(Параметры.ЗначенияПолейДляОпределенияРаспоряжения);
	Если ЗначенияПолейДляОпределенияРаспоряжения.Количество() > 0 Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПараметрыУказанияСерий.ПолноеИмяОбъекта);
		Распоряжение = МенеджерОбъекта.РаспоряжениеНаВыполнениеСкладскойОперации(Параметры.ЗначенияПолейДляОпределенияРаспоряжения);
	Иначе
		Распоряжение = Неопределено;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура(ПоляПоиска);

	ЗаполнитьЗначенияСвойств(СтруктураПоиска,Параметры);
	
	НомерТекущейСтрокиТоваров = Объект.ТоварыКешДокумента.НайтиСтроки(СтруктураПоиска)[0].НомерСтроки;
	
	Инициализировать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьКнопокВпередНазад();
	НужноЗадаватьВопросПередЗакрытием = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Модифицированность
		И НужноЗадаватьВопросПередЗакрытием Тогда

		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Список серий был изменен.
                |Сохранить изменения?'
                |;uk='Список серій був змінений.
                |Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
				
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_СерииНоменклатуры" Тогда
		ТекущиеДанные = Элементы.Серии.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные.Серия = Источник;
		ЗаполнитьЗначенияСвойств(ТекущиеДанные,Параметр);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	Если НомерТекущейСтрокиТоваров < 1 
	 Или НомерТекущейСтрокиТоваров > Объект.ТоварыКешДокумента.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	УпаковкаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОчистка(Элемент, СтандартнаяОбработка)
	
	УпаковкаПриИзменении(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСерии

&НаКлиенте
Процедура СерииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле = Элементы.СерииСерия Тогда
		ИзменитьСериюКлиент();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СерииКоличествоУпаковокПриИзменении(Элемент)

	КоэффициентУпаковки = КоэффициентУпаковки(Упаковка, Номенклатура);
	
	ТекущиеДанные = Элементы.Серии.ТекущиеДанные;
	ТекущиеДанные.Количество = ТекущиеДанные.КоличествоУпаковок * КоэффициентУпаковки;
	
КонецПроцедуры

&НаКлиенте
Процедура СерииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если Копирование Тогда
		ТекущееКоличество = 0;
	Иначе
		ТекущееКоличество =  ТекущиеДанные.КоличествоУпаковок;
	КонецЕсли;
	
	Если НоваяСтрока
		И Не НастройкиИспользованияСерий.ИспользоватьКоличествоСерии Тогда
		
		ТекущиеДанные.КоличествоУпаковок = 1;
		ТекущиеДанные.Количество         = 1;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СерииПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Не ОтменаРедактирования Тогда
		Дельта = ТекущееКоличество - Элементы.Серии.ТекущиеДанные.КоличествоУпаковок;
		КоличествоСерий = КоличествоСерий - Дельта;
		Элементы.Серии.ТекущиеДанные.СвободныйОстаток = Элементы.Серии.ТекущиеДанные.СвободныйОстаток + Дельта;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СерииПередУдалением(Элемент, Отказ)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ТекущееКоличество =  ТекущиеДанные.Количество;
КонецПроцедуры

&НаКлиенте
Процедура СерииПослеУдаления(Элемент)
	КоличествоСерий = КоличествоСерий - ТекущееКоличество;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВводСерий(Команда)
	ОчиститьСообщения();
    СохранитьВводСерийСервер();
	Если Не Модифицированность Тогда
		Закрыть(АдресВоВременномХранилище);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		НужноЗадаватьВопросПередЗакрытием = Ложь;
		ЗавершитьВводСерий(Неопределено);// Сохранение результатов модификации.
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		НужноЗадаватьВопросПередЗакрытием = Ложь;
		Закрыть(Неопределено);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СледующаяСтрока(Команда)
	ИзменитьТекущуюСтроку(1);
	УстановитьДоступностьКнопокВпередНазад();
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущаяСтрока(Команда)
	ИзменитьТекущуюСтроку(-1);
	УстановитьДоступностьКнопокВпередНазад();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДополнительныеРеквизиты(Команда)
	ТекущиеДанные = Элементы.Серии.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Серия) Тогда
		ТекстСообщения = НСтр("ru='В выбранной строке не заполнена серия из-за ошибки в данных об остатках. Обратитесь к администратору.';uk='У вибраному рядку не заповнена серія через помилку в даних про залишки. Зверніться до адміністратора.'");
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполненияСерии = Новый Структура;
	ЗначенияЗаполненияСерии.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ЗначенияЗаполненияСерии.Вставить("Номер", ТекущиеДанные.Номер);
	ЗначенияЗаполненияСерии.Вставить("ГоденДо", ТекущиеДанные.ГоденДо);
	
	ПараметрыФормыСерии = Новый Структура;
	ПараметрыФормыСерии.Вставить("ЗначенияЗаполнения",ЗначенияЗаполненияСерии);
	ПараметрыФормыСерии.Вставить("Ключ",ТекущиеДанные.Серия);
	
	ОткрытьФорму("Справочник.СерииНоменклатуры.Форма.ФормаЭлемента",ПараметрыФормыСерии, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоFEFO(Команда)
	Если Количество = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='В документе не указано количество товара. Заполнение по FEFO не возможно.';uk='У документі не вказана кількість товару. Заповнення по FEFO не можливо.'"));
		Возврат;
	КонецЕсли;	
	ЗаполнитьПоFEFOСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КоличествоСерий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоличествоСерий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Количество");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтличающейсяСтрокиДокумента);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КоличествоСерий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоличествоСерий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Количество");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Seagreen);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СерииСвободныйОстаток.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Серии.СвободныйОстаток");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ЗаполнитьПоFEFOСервер()
	
	КоличествоКРаспределению = Количество;
	
	КоэффициентУпаковки = КоэффициентУпаковки(Упаковка, Номенклатура);
	
	Для Каждого СтрТабл из Объект.Серии Цикл
		Если КоличествоКРаспределению <= 0 Тогда
			СтрТабл.СвободныйОстаток   = СтрТабл.СвободныйОстаток + СтрТабл.КоличествоУпаковок;
			СтрТабл.КоличествоУпаковок = 0;
			СтрТабл.Количество = 0;
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке =  Мин(СтрТабл.СвободныйОстаток + СтрТабл.КоличествоУпаковок, КоличествоКРаспределению);
		Если КоличествоПоСтроке < 0 Тогда
			СтрТабл.СвободныйОстаток   = СтрТабл.СвободныйОстаток + СтрТабл.КоличествоУпаковок;
			СтрТабл.КоличествоУпаковок = 0;
		Иначе
			СтрТабл.СвободныйОстаток   = СтрТабл.СвободныйОстаток + СтрТабл.КоличествоУпаковок - КоличествоПоСтроке;
			СтрТабл.КоличествоУпаковок = КоличествоПоСтроке;
			КоличествоКРаспределению = КоличествоКРаспределению - КоличествоПоСтроке; 
		КонецЕсли;
		
		СтрТабл.Количество = СтрТабл.КоличествоУпаковок * КоэффициентУпаковки;

	КонецЦикла;
	
	КоличествоСерий = Объект.Серии.Итог("КоличествоУпаковок");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВводСерийВКеше()
	
	ЕстьПризнакУказанияСерий = ПараметрыУказанияСерий.ПоляСвязи.Найти("УказыватьСерии") <> Неопределено;
	
	ТаблицаСерий = Объект.Серии.Выгрузить();
	
	ТаблицаСерий.Свернуть("Серия,Номер,ГоденДо", "Количество,КоличествоУпаковок");
	
	Индекс = ТаблицаСерий.Количество();
	
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		СтрТабл = ТаблицаСерий[Индекс];
		Если СтрТабл.КоличествоУпаковок = 0 Тогда
			ТаблицаСерий.Удалить(СтрТабл);
		КонецЕсли;
	КонецЦикла;
	
	СтрокаТоваров = Объект.ТоварыКешДокумента[НомерТекущейСтрокиТоваров-1];
	
	ТекстПоляПоиска = "";
	
	Для Каждого СтрМас из ПараметрыУказанияСерий.ПоляСвязи Цикл
		ТекстПоляПоиска = ТекстПоляПоиска + ", " + СтрМас;
	КонецЦикла;
		
	СтруктураПоиска = Новый Структура("Номенклатура,Характеристика" + ТекстПоляПоиска);
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска,СтрокаТоваров);
	
	СтрокаТоваров.Упаковка = Упаковка;
	
	НайденныеСтрокиСерий = Объект.СерииКешДокумента.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрТабл из НайденныеСтрокиСерий Цикл
		Объект.СерииКешДокумента.Удалить(СтрТабл);
	КонецЦикла;
	
	Для Каждого СтрТабл Из ТаблицаСерий Цикл
		НоваяСтрока = Объект.СерииКешДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТоваров);
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрТабл);
		Если ЕстьПризнакУказанияСерий Тогда
			НоваяСтрока.УказыватьСерии = Истина;
		КонецЕсли;
		НоваяСтрока.Упаковка = Упаковка;
	КонецЦикла;
	
	Если ЕстьПризнакУказанияСерий Тогда
		Если ТаблицаСерий.Количество() > 0 Тогда
			СтрокаТоваров.УказыватьСерии = Истина;
		Иначе
			СтрокаТоваров.УказыватьСерии = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВводСерийСервер()
	
	СохранитьВводСерийВКеше();
	
	СтруктураВозврата = Новый Структура;
	ТаблицаСерий = Объект.СерииКешДокумента.Выгрузить();
	
	КолонкиГруппировок =
	"Номенклатура,
	|Характеристика,
	|НоменклатураОприходование,
	|ХарактеристикаОприходование,
	|Упаковка,
	|Коэффициент,
	|Склад,
	|ВариантОформления,
	|Серия,
	|НеОтгружать";
	
	КолонкиСуммирования =
	"Количество,
	|КоличествоУпаковок";
	
	Если ПараметрыУказанияСерий.ПоляСвязи.Количество() > 0 Тогда
		
		Для каждого ПолеСвязи из ПараметрыУказанияСерий.ПоляСвязи Цикл
			
			Если ПолеСвязи <> "Склад"
				И ПолеСвязи <> "НеОтгружать"
				И ПолеСвязи <> "ВариантОформления" Тогда
				
				КолонкиГруппировок = КолонкиГруппировок + ", " + ПолеСвязи;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
		
	ТаблицаСерий.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
	
	Для Каждого ТекСтр Из ТаблицаСерий Цикл
		Если ТекСтр.Коэффициент <> 0 И ТекСтр.Коэффициент <> 1 Тогда
			ТекСтр.Количество = ТекСтр.Количество * ТекСтр.Коэффициент;
			ТекСтр.КоличествоУпаковок = ТекСтр.КоличествоУпаковок * ТекСтр.Коэффициент;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата.Вставить("ТаблицаСерий", ТаблицаСерий);
	Если ПараметрыУказанияСерий.ИмяТЧТовары = ПараметрыУказанияСерий.ИмяТЧСерии Тогда
		СтруктураВозврата.Вставить("ТаблицаТоваров", Объект.ТоварыКешДокумента.Выгрузить());
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресВоВременномХранилище);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопокВпередНазад()
	Если  НомерТекущейСтрокиТоваров > 1 Тогда
		Элементы.ГруппаКнопкаНазад.ТекущаяСтраница = Элементы.СтраницаКнопкаНазад;
	Иначе
		Элементы.ГруппаКнопкаНазад.ТекущаяСтраница = Элементы.СтраницаКнопкаНазадПустая;
	КонецЕсли;
	
	Если НомерТекущейСтрокиТоваров < Объект.ТоварыКешДокумента.Количество() Тогда
		Элементы.ГруппаКнопкаВперед.ТекущаяСтраница = Элементы.СтраницаКнопкаВперед;
	Иначе
		Элементы.ГруппаКнопкаВперед.ТекущаяСтраница = Элементы.СтраницаКнопкаВпередПустая;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура Инициализировать(ПересчитыватьУпаковки = Ложь)
	
	Если НомерТекущейСтрокиТоваров < 1 
	 Или НомерТекущейСтрокиТоваров > Объект.ТоварыКешДокумента.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТоваров = Объект.ТоварыКешДокумента[НомерТекущейСтрокиТоваров-1];
	Если ЗначениеЗаполнено(СтрокаТоваров.Упаковка) Тогда
		ТипИзмеряемойВеличиныНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТоваров.Номенклатура, "ЕдиницаИзмерения.ТипИзмеряемойВеличины"); 
		Если ТипИзмеряемойВеличиныНоменклатуры <> Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук 
			Или ТипИзмеряемойВеличиныНоменклатуры = Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТоваров.Упаковка, "ТипИзмеряемойВеличины") = Перечисления.ТипыИзмеряемыхВеличин.Упаковка Тогда
			Упаковка = СтрокаТоваров.Упаковка;
		Иначе
			Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	КонецЕсли;
	
	СкладыВТЧ = ПараметрыУказанияСерий.ПоляСвязи.Найти("Склад") <> Неопределено;
	ЕстьУпаковки = ПараметрыУказанияСерий.ПоляСвязи.Найти("Упаковка") <> Неопределено;
	ЕстьПризнакУказанияСерий = ПараметрыУказанияСерий.ПоляСвязи.Найти("УказыватьСерии") <> Неопределено;
	ЕстьВариантОформления = ПараметрыУказанияСерий.ПоляСвязи.Найти("ВариантОформления") <> Неопределено;
	ЕстьНеотгружаемые = ПараметрыУказанияСерий.ПоляСвязи.Найти("НеОтгружать") <> Неопределено;
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТоваров.Номенклатура, 
	                        											Новый Структура("ВидНоменклатуры, ЕдиницаИзмеренияПредставление",
																		"ВидНоменклатуры",
																		"ЕдиницаИзмерения.Наименование"));
	Если ЗначениеЗаполнено(Упаковка) Тогда;
		РеквизитыУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(Упаковка, Номенклатура, "Наименование"); 
		РеквизитыНоменклатуры.Вставить("ЕдиницаИзмеренияПредставление", РеквизитыУпаковки.Наименование);
	Иначе
		РеквизитыУпаковки = Новый Структура("Коэффициент, Наименование", 1, РеквизитыНоменклатуры.ЕдиницаИзмеренияПредставление);
	КонецЕсли;
	
	Количество = СтрокаТоваров.Количество / РеквизитыУпаковки.Коэффициент;
	НомераСтрокПредставление = СтрокаТоваров.НомераСтрокДокумента;
	
	Если Не СкладыВТЧ Тогда
		ТекущийСклад = Склад;
	Иначе
		ТекущийСклад = СтрокаТоваров.Склад;
	КонецЕсли;
								
	НастройкиИспользованияСерий = Новый ФиксированнаяСтруктура(
		ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(РеквизитыНоменклатуры.ВидНоменклатуры,ТекущийСклад));
		
	ВидНоменклатуры = НастройкиИспользованияСерий.ВладелецСерий;
		
	Если Не НастройкиИспользованияСерий.ИспользоватьСерии Тогда
		ТекстИсключения = НСтр("ru='Для вида номенклатуры ""%ВидНоменклатуры%"" серии не используются';uk='Для виду номенклатури ""%ВидНоменклатуры%"" серії не використовуються'");
		
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ВидНоменклатуры%",НастройкиИспользованияСерий.ВидНоменклатуры);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаголовокКоличествоВДокументе = НСтр("ru='Необходимо для отгрузки, %ЕдиницаИзмерения%';uk='Необхідно для відвантаження, %ЕдиницаИзмерения%'");
	ЗаголовокКоличествоСерий      = НСтр("ru='Подобрано из серий, %ЕдиницаИзмерения%';uk='Підібрано із серій, %ЕдиницаИзмерения%'");
	ЗаголовокКолонкиКоличество = "";
	Если Не Параметры.Свойство("ЗаголовокКолонкиКоличество", ЗаголовокКолонкиКоличество) Тогда
		ЗаголовокКолонкиКоличество    = НСтр("ru='К отгрузке';uk='До відвантаження'"); 
	КонецЕсли;
	ЗаголовокКолонкиКоличество    = ЗаголовокКолонкиКоличество + ", " + РеквизитыНоменклатуры.ЕдиницаИзмеренияПредставление;
	
	ТоварПредставление = НСтр("ru='%ПредставлениеТовара%';uk='%ПредставлениеТовара%'");
	
	ЗаголовокКоличествоВДокументе = СтрЗаменить(ЗаголовокКоличествоВДокументе,"%ЕдиницаИзмерения%",РеквизитыНоменклатуры.ЕдиницаИзмеренияПредставление);
	ЗаголовокКоличествоСерий      = СтрЗаменить(ЗаголовокКоличествоСерий,"%ЕдиницаИзмерения%",РеквизитыНоменклатуры.ЕдиницаИзмеренияПредставление);
	
	Если ПараметрыУказанияСерий.ЭтоОрдер Тогда
		ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзОстатка";
	Иначе
		Если ЗначениеЗаполнено(Распоряжение)
			И ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки) <> Неопределено
			И НастройкиИспользованияСерий.УчитыватьОстаткиСерий
			И НастройкиИспользованияСерий.УказыватьПриПланированииОтгрузки Тогда
			ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа";
		Иначе
			ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка";
		КонецЕсли;
	КонецЕсли;
	
	Если ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзОстатка"
		Или ВариантПолучениеДанныхИзРегистров = "ЗаказНакладнаяСерииИзОстатка" Тогда
		
		ЗаголовокСвободногоОстатка = НСтр("ru='Свободный остаток, %ЕдиницаИзмерения%';uk='Вільний залишок, %ЕдиницаИзмерения%'");
		Если ТипЗнч(Склад) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			Заголовок = НСтр("ru='Подбор серий по остаткам в производстве';uk='Підбір серій по залишкам у виробництві'");
		Иначе
			Заголовок = НСтр("ru='Подбор серий по остаткам на складе';uk='Підбір серій за залишками на складі'");
		КонецЕсли;
		
	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа" 	Тогда
		
		ЗаголовокСвободногоОстатка = НСтр("ru='Остаток по заказу, %ЕдиницаИзмерения%';uk='Залишок по замовленню, %ЕдиницаИзмерения%'");
		Заголовок                  = НСтр("ru='Подбор серий по заказу';uk='Підбір серій по замовленнях'");

	ИначеЕсли ВариантПолучениеДанныхИзРегистров = "ОрдерСерииИзНакладной" Тогда
		
		ЗаголовокСвободногоОстатка = НСтр("ru='Остаток по распоряжению, %ЕдиницаИзмерения%';uk='Залишок за розпорядженням, %ЕдиницаИзмерения%'");
		Заголовок                  = НСтр("ru='Подбор серий по распоряжению на отгрузку';uk='Підбір серій за розпорядженням на відвантаження'");
		
	ИначеЕсли ТипЗнч(Склад) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		Заголовок = НСтр("ru='Подбор серий по остаткам в производстве';uk='Підбір серій по залишкам у виробництві'");
	КонецЕсли;
	
	ЗаголовокСвободногоОстатка = СтрЗаменить(ЗаголовокСвободногоОстатка,"%ЕдиницаИзмерения%",РеквизитыНоменклатуры.ЕдиницаИзмеренияПредставление);
	
	Номенклатура = СтрокаТоваров.Номенклатура;
	ТоварПредставление = СтрЗаменить(ТоварПредставление,"%ПредставлениеТовара%",НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТоваров.Номенклатура, СтрокаТоваров.Характеристика));
	
	Элементы.СерииКоличествоУпаковок.Заголовок = ЗаголовокКолонкиКоличество;
	Элементы.СерииСвободныйОстаток.Заголовок   = ЗаголовокСвободногоОстатка;
	Элементы.Количество.Заголовок              = ЗаголовокКоличествоВДокументе;
	Элементы.КоличествоСерий.Заголовок         = ЗаголовокКоличествоСерий;
	
	Элементы.СерииНомер.Видимость              = НастройкиИспользованияСерий.ИспользоватьНомерСерии;
	Элементы.СерииГоденДо.Видимость            = НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии;
	Элементы.СерииКоличествоУпаковок.Видимость = НастройкиИспользованияСерий.ИспользоватьКоличествоСерии;
	
	Если НастройкиИспользованияСерий.ИспользоватьСрокГодностиСерии Тогда
		Элементы.СерииГоденДо.Формат = НастройкиИспользованияСерий.ФорматнаяСтрокаСрокаГодности;
		Если НастройкиИспользованияСерий.ТочностьУказанияСрокаГодностиСерии = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоДней Тогда
			Элементы.СерииГоденДо.Заголовок = НСтр("ru='Годен до (дата)';uk='Придатний до (дата)'");
		Иначе
			Элементы.СерииГоденДо.Заголовок = НСтр("ru='Годен до (дата, час)';uk='Придатний до (дата, година)'");
		КонецЕсли;
	КонецЕсли;
	
	//Формирование таблицы ТаблицаСерий	

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаСерий.Серия,";
	Если ЕстьПризнакУказанияСерий Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|  	ТаблицаСерий.УказыватьСерии, 
			|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
			|			ТОГДА ТаблицаСерий.Количество
			|			ИНАЧЕ 0
			|	КОНЕЦ КАК Количество, ";
		Если ЕстьУпаковки Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
			|			ТОГДА ТаблицаСерий.КоличествоУпаковок
			|			ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоУпаковок ";
		Иначе
		ТекстЗапроса = ТекстЗапроса + "
			|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
			|			ТОГДА ТаблицаСерий.Количество
			|			ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоУпаковок ";
		КонецЕсли;
	ИначеЕсли ЕстьУпаковки Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	ТаблицаСерий.Количество,
		|	ТаблицаСерий.КоличествоУпаковок ";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	ТаблицаСерий.Количество,
		|	ТаблицаСерий.Количество КАК КоличествоУпаковок ";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|ПОМЕСТИТЬ ТаблицаСерий
	|ИЗ
	|	&ТаблицаСерий КАК ТаблицаСерий
	|ГДЕ
	|  	ТаблицаСерий.Номенклатура = &Номенклатура
	|  	И ТаблицаСерий.Характеристика = &Характеристика
	|	И (&БезНазначения ИЛИ ТаблицаСерий.Назначение = &НазначениеТЧ)";
	Если СкладыВТЧ Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.Склад = &Склад";
	КонецЕсли;
	Если ЕстьВариантОформления Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.ВариантОформления = &ВариантОформления";
	КонецЕсли;
	
	Если ЕстьНеотгружаемые Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.НеОтгружать = &НеОтгружать";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ТаблицаСерий.Серия,";
	Если ЕстьПризнакУказанияСерий Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	ТаблицаСерий.УказыватьСерии, 
		|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
		|			ТОГДА ТаблицаСерий.Количество
		|			ИНАЧЕ 0
		|	КОНЕЦ КАК Количество, ";
		Если ЕстьУпаковки Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
			|			ТОГДА ТаблицаСерий.КоличествоУпаковок
			|			ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоУпаковок ";
		Иначе
		ТекстЗапроса = ТекстЗапроса + "
			|	ВЫБОР КОГДА ТаблицаСерий.УказыватьСерии = &УказыватьСерии
			|			ТОГДА ТаблицаСерий.Количество
			|			ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоУпаковок ";
		КонецЕсли;
	ИначеЕсли ЕстьУпаковки Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	ТаблицаСерий.Количество,
		|	ТаблицаСерий.КоличествоУпаковок ";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	ТаблицаСерий.Количество,
		|	ТаблицаСерий.Количество КАК КоличествоУпаковок ";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|ПОМЕСТИТЬ ТаблицаСерийПоляСвязи
	|ИЗ
	|	&ТаблицаСерий КАК ТаблицаСерий
	|ГДЕ
	|  	ТаблицаСерий.Номенклатура = &Номенклатура
	|  	И ТаблицаСерий.Характеристика = &Характеристика
	|	И (&БезНазначения ИЛИ ТаблицаСерий.Назначение = &НазначениеТЧ)";
	Если СкладыВТЧ Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.Склад = &Склад";
	КонецЕсли;
	Если ЕстьВариантОформления Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.ВариантОформления = &ВариантОформления";
	КонецЕсли;
	
	Если ЕстьНеотгружаемые Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|  	И ТаблицаСерий.НеОтгружать = &НеОтгружать";
	КонецЕсли;
	
	ДобавляемыеПараметры = Новый Массив;
	
	Если ПараметрыУказанияСерий.ПоляСвязи.Количество() > 0 Тогда
		
		Для каждого ПолеСвязи из ПараметрыУказанияСерий.ПоляСвязи Цикл
			
			Если ПолеСвязи <> "Склад"
				И ПолеСвязи <> "НеОтгружать"
				И ПолеСвязи <> "УказыватьСерии"
				И ПолеСвязи <> "Назначение" Тогда
				
				ТекстЗапроса = ТекстЗапроса + "
				|  	И ТаблицаСерий." + ПолеСвязи + " = &" + ПолеСвязи;
				
				ДобавляемыеПараметры.Добавить(ПолеСвязи);
				
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	//Формирование таблицы ДанныеРегистров	
	
	ТекстЗапроса = ТекстЗапроса + Обработки.ПодборСерийВДокументы.ТекстЗапросаФормированияТаблицыДанныеРегистров(ВариантПолучениеДанныхИзРегистров, Склад);
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	//Объединение таблиц ТаблицаСерий и ДанныеРегистров	
	
	ТекстЗапроса = ТекстЗапроса + "
	|ВЫБРАТЬ
	|	ТаблицаСерийСОстатками.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ТаблицаСерийСОстатками.Серия КАК Справочник.СерииНоменклатуры).Номер КАК Номер,
	|	ВЫРАЗИТЬ(ТаблицаСерийСОстатками.Серия КАК Справочник.СерииНоменклатуры).ГоденДо КАК ГоденДо,
	|	СУММА(ТаблицаСерийСОстатками.СвободныйОстаток/&КоэффициентУпаковки) КАК СвободныйОстаток,
	|	СУММА(ТаблицаСерийСОстатками.Количество) КАК Количество,
	|	СУММА(ВЫБОР
	|			КОГДА &ПересчитыватьУпаковки
	|				ТОГДА ТаблицаСерийСОстатками.Количество / &КоэффициентУпаковки
	|			ИНАЧЕ ТаблицаСерийСОстатками.КоличествоУпаковок
	|		КОНЕЦ) КАК КоличествоУпаковок
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеРегистров.Серия КАК Серия,
	|		ДанныеРегистров.СвободныйОстаток КАК СвободныйОстаток,
	|		0 КАК Количество,
	|		0 КАК КоличествоУпаковок
	|	ИЗ
	|		ДанныеРегистров КАК ДанныеРегистров
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаСерий.Серия,
	|		-ТаблицаСерий.Количество,
	|		0,
	|		0
	|	ИЗ
	|		ТаблицаСерий КАК ТаблицаСерий
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаСерий.Серия,
	|		0,
	|		ТаблицаСерий.Количество,
	|		ТаблицаСерий.КоличествоУпаковок
	|	ИЗ
	|		ТаблицаСерийПоляСвязи КАК ТаблицаСерий) КАК ТаблицаСерийСОстатками
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСерийСОстатками.Серия,
	|	ВЫРАЗИТЬ(ТаблицаСерийСОстатками.Серия КАК Справочник.СерииНоменклатуры).Номер,
	|	ВЫРАЗИТЬ(ТаблицаСерийСОстатками.Серия КАК Справочник.СерииНоменклатуры).ГоденДо
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаСерийСОстатками.СвободныйОстаток) > 0
	|		ИЛИ СУММА(ТаблицаСерийСОстатками.Количество) > 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГоденДо,
	|	Номер";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;

	Запрос.УстановитьПараметр("ТаблицаСерий",Объект.СерииКешДокумента.Выгрузить());
	Запрос.УстановитьПараметр("Номенклатура",СтрокаТоваров.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",СтрокаТоваров.Характеристика);
	
	Если СтрокаТоваров.Свойство("Назначение")
		Или СтрокаТоваров.Свойство("НазначениеОтправителя") Тогда
		БезНазначения = Ложь;
		Если ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки) <> Неопределено
			И ПараметрыУказанияСерий.ЭтоЗаказ
			И СтрокаТоваров.ВариантОбеспечения <> Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно Тогда
			Назначение = Справочники.Назначения.ПустаяСсылка();
		ИначеЕсли ПараметрыУказанияСерий.ИмяПоляСкладОтправитель <> Неопределено
			И ПараметрыУказанияСерий.ИмяПоляСкладПолучатель <> Неопределено Тогда //это перемещение товаров или передача в производство
			Назначение = СтрокаТоваров.НазначениеОтправителя;
		Иначе
			Назначение = СтрокаТоваров.Назначение;
		КонецЕсли;
		Если ЗначениеЗаполнено(Назначение) Тогда 
			Если ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
				ДвиженияПоСкладскимРегистрам = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Назначение,"ДвиженияПоСкладскимРегистрам");
				Если ДвиженияПоСкладскимРегистрам Тогда
					НазначениеОстатков = Назначение;
				Иначе
					НазначениеОстатков = Справочники.Назначения.ПустаяСсылка();
				КонецЕсли;
			Иначе
				НазначениеОстатков = Назначение;
			КонецЕсли;
		Иначе
			НазначениеОстатков = Справочники.Назначения.ПустаяСсылка();
		КонецЕсли;
	Иначе
		НазначениеОстатков = Справочники.Назначения.ПустаяСсылка();
		БезНазначения = Истина;
	КонецЕсли;
	Запрос.УстановитьПараметр("Назначение", НазначениеОстатков);
	Запрос.УстановитьПараметр("НазначениеТЧ", СтрокаТоваров.Назначение);
	Запрос.УстановитьПараметр("БезНазначения", БезНазначения);
			
	Запрос.УстановитьПараметр("ВсеСерии",Ложь);
	Если Не СкладыВТЧ Тогда
		Запрос.УстановитьПараметр("Склад",Склад);
	Иначе
		Запрос.УстановитьПараметр("Склад",СтрокаТоваров.Склад);
	КонецЕсли;
	
	Если ВариантПолучениеДанныхИзРегистров = "НакладнаяСерииИзЗаказа"
		И ЗначенияПолейДляОпределенияРаспоряжения.Количество() > 0 Тогда
		ЗначенияПолейПоСтроке = Новый Структура;
		Для Каждого СтрМас из ПараметрыУказанияСерий.ИменаПолейДляОпределенияРаспоряжения Цикл
			ПоложениеРазделителя = СтрНайти(СтрМас, "_");		
			Если ПоложениеРазделителя = 0 Тогда
				ЗначенияПолейПоСтроке.Вставить(СтрМас, ЗначенияПолейДляОпределенияРаспоряжения[СтрМас]);
			Иначе
				ИмяПоля = Прав(СтрМас, СтрДлина(СтрМас)- ПоложениеРазделителя);
				ЗначенияПолейПоСтроке.Вставить(СтрМас, СтрокаТоваров[ИмяПоля]);
			КонецЕсли;
		КонецЦикла;
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПараметрыУказанияСерий.ПолноеИмяОбъекта);
		РаспоряжениеСтроки = МенеджерОбъекта.РаспоряжениеНаВыполнениеСкладскойОперации(ЗначенияПолейПоСтроке);
	 	Запрос.УстановитьПараметр("Распоряжение", РаспоряжениеСтроки);
	КонецЕсли;
	
	Если ЕстьВариантОформления Тогда
		Запрос.УстановитьПараметр("ВариантОформления", СтрокаТоваров.ВариантОформления);
	КонецЕсли;
	
	Если ЕстьНеотгружаемые Тогда
		Запрос.УстановитьПараметр("НеОтгружать", СтрокаТоваров.НеОтгружать);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Помещение",Помещение);
	Запрос.УстановитьПараметр("Регистратор",Регистратор);
	
	Для каждого ДобавляемыйПараметр из ДобавляемыеПараметры Цикл
		
		Запрос.УстановитьПараметр(ДобавляемыйПараметр, СтрокаТоваров[ДобавляемыйПараметр]);
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КоэффициентУпаковки", РеквизитыУпаковки.Коэффициент);
	Запрос.УстановитьПараметр("ПересчитыватьУпаковки", ПересчитыватьУпаковки);
	
	Объект.Серии.Загрузить(Запрос.Выполнить().Выгрузить());
	
	КоличествоСерий = Объект.Серии.Итог("КоличествоУпаковок");
	
	Если Объект.Серии.Количество() = 0 Тогда
		Элементы.ГруппаСтраницыСерии.ТекущаяСтраница = Элементы.СтраницаНетОстатков;
		Элементы.РаспределитьОстаток.Видимость = Ложь;
		Элементы.СтраницыПоFEFO.ТекущаяСтраница = Элементы.СтраницаПоFEFOПустая;
		Элементы.Упаковка.Видимость = Ложь;
	Иначе
		
		Элементы.Упаковка.Видимость = Истина;
		Если НастройкиИспользованияСерий.УчетСерийПоFEFO 
			И Перечисления.СкладскиеОперации.ЕстьОтгрузка(ПараметрыУказанияСерий.СкладскиеОперации) Тогда
			Элементы.СтраницыПоFEFO.ТекущаяСтраница = Элементы.СтраницаПоFEFO;
		Иначе
			Элементы.СтраницыПоFEFO.ТекущаяСтраница = Элементы.СтраницаПоFEFOПустая;
		КонецЕсли;
		Элементы.РаспределитьОстаток.Видимость = НастройкиИспользованияСерий.ИспользоватьКоличествоСерии;
		
		Элементы.ГруппаСтраницыСерии.ТекущаяСтраница = Элементы.СтраницаСерии;
		
		// Доп. реквизиты
		УправлениеСвойствамиУТ.ДобавитьКолонкиДополнительныхРеквизитов(
			Обработки.ПодборСерийВДокументы.ВладелецСвойствСерий(ВидНоменклатуры),
			ЭтаФорма,
			"Объект.Серии",
			"Серии",
			"СерииСвободныйОстаток",
			Истина);
			
		УправлениеСвойствамиУТ.ЗаполнитьКолонкиДополнительныхРеквизитов(
			ЭтаФорма,
			"Объект.Серии",
			"Серия");
			
	КонецЕсли;
		
	КоличествоСерий = Объект.Серии.Итог("КоличествоУпаковок");
	
	ПредставлениеОбъемаРаботы = НСтр("ru='Товар %НомерТекущейСтроки% из %ВсегоТоваров%:';uk='Товар %НомерТекущейСтроки% з %ВсегоТоваров%:'");
	ПредставлениеОбъемаРаботы = СтрЗаменить(ПредставлениеОбъемаРаботы,"%НомерТекущейСтроки%",Строка(НомерТекущейСтрокиТоваров));
	ПредставлениеОбъемаРаботы = СтрЗаменить(ПредставлениеОбъемаРаботы,"%ВсегоТоваров%",Объект.ТоварыКешДокумента.Количество());
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьТекущуюСтроку(Направление)
	
	СохранитьВводСерийВКеше();
	НомерТекущейСтрокиТоваров = НомерТекущейСтрокиТоваров + Направление;
	
	Упаковка = Неопределено;
	Инициализировать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСериюКлиент()
	
	ТекущиеДанные = Элементы.Серии.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполненияСерии = Новый Структура;
	ЗначенияЗаполненияСерии.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ЗначенияЗаполненияСерии.Вставить("Номер", ТекущиеДанные.Номер);
	ЗначенияЗаполненияСерии.Вставить("ГоденДо", ТекущиеДанные.ГоденДо);
	
	ПараметрыФормыСерии = Новый Структура;
	ПараметрыФормыСерии.Вставить("ЗначенияЗаполнения",ЗначенияЗаполненияСерии);
	ПараметрыФормыСерии.Вставить("Ключ",ТекущиеДанные.Серия);
	
	ОткрытьФорму("Справочник.СерииНоменклатуры.Форма.ФормаЭлемента",ПараметрыФормыСерии, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьОстаток(Команда)
	КоличествоКРаспределению = Количество - КоличествоСерий;
	
	Если Количество = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='В документе не указано количество товара. Распределение по сериям невозможно.';uk='У документі не вказана кількість товару. Розподіл по серіях неможливий.'"));
		Возврат;
	ИначеЕсли КоличествоКРаспределению <= 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='Все количество товара, указанное в документе, распределено по сериям.';uk='Вся кількість товару, вказана в документі, розподілена за серіями.'"));
		Возврат;
	КонецЕсли;	
	
	КоэффициентУпаковки = КоэффициентУпаковки(Упаковка, Номенклатура);
	
	Для Каждого ИдентификаторСтроки Из Элементы.Серии.ВыделенныеСтроки Цикл
		
		Если КоличествоКРаспределению <= 0 Тогда
			Прервать;
		КонецЕсли;
	
		СтрокаСерии = Объект.Серии.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		КоличествоНаСтроку = Макс(Мин(КоличествоКРаспределению, СтрокаСерии.СвободныйОстаток), 0);
		КоличествоКРаспределению = КоличествоКРаспределению - КоличествоНаСтроку;
		КоличествоСерий = КоличествоСерий + КоличествоНаСтроку;
		
		СтрокаСерии.КоличествоУпаковок = СтрокаСерии.КоличествоУпаковок + КоличествоНаСтроку;
		СтрокаСерии.СвободныйОстаток = СтрокаСерии.СвободныйОстаток - КоличествоНаСтроку;
		СтрокаСерии.Количество = СтрокаСерии.КоличествоУпаковок * КоэффициентУпаковки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентУпаковки(Упаковка, Номенклатура)
	Возврат Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
КонецФункции

&НаСервере
Процедура УпаковкаПриИзмененииСервер()
	
	СохранитьВводСерийВКеше();
	Инициализировать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
