﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтаФорма);
	ИдентификаторГлавногоХранилища = Параметры.ИдентификаторГлавногоХранилища;
	ИдентификаторСтрокиЭлементаОтчета = Параметры.ИдентификаторСтрокиЭлементаОтчета;
	
	Если Не ЗначениеЗаполнено(СтатьяБюджетов) Тогда
		Заголовок = НСтр("ru='<Статьи бюджетирования, по которым есть обороты>';uk='<Статті бюджетування, за якими є обороти>'");
	ИначеЕсли ТипЗнч(СтатьяБюджетов) = Тип("СправочникСсылка.ПоказателиБюджетов") Тогда
		Заголовок = Заголовок + НСтр("ru='Показатель бюджетов';uk='Показник бюджетів'") + " """ + СтатьяБюджетов + """";
		Элементы.КартинкаСтатьяБюджетов.Видимость = Ложь;
		Элементы.КартинкаПоказательБюджетов.Видимость = Истина;
	Иначе
		Заголовок = Строка(Параметры.ВидЭлемента) + ": " + СтатьяБюджетов;
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкаЯчеек") Тогда
		//авторасчет доступен только в сложной таблице
		Элементы.СпособЗаполнения.СписокВыбора.Удалить(1);
		
		ДеревоЭлементов = ДанныеФормыВЗначение(Параметры.ЭлементыОтчета, Тип("ДеревоЗначений"));
		АдресЭлементовОтчета = ПоместитьВоВременноеХранилище(ДеревоЭлементов, УникальныйИдентификатор);
		АдресТаблицыЭлементов = Неопределено;
	Иначе
		АдресТаблицыЭлементов = Параметры.АдресТаблицыЭлементов;
		АдресЭлементовОтчета = Параметры.АдресЭлементовОтчета;
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкаЯчеек")
		И Не Параметры.Свойство("ПроизвольныйПоказатель") Тогда
		Элементы.ВыводимыеПоказатели.СписокВыбора.Добавить(Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма);
	КонецЕсли;
	
	ОперандыФормулы.Очистить();
	Для Каждого СтрокаОперанда из ДанныеОбъекта.ОперандыФормулы Цикл
		НоваяСтрока = ОперандыФормулы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОперанда);
	КонецЦикла;

	УправлениеФормой(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Формула) Тогда
		ТекущийОбъект.ЕстьНастройки = Истина;
	КонецЕсли;
	
	Если Формула = НСтр("ru='<настроить авторасчет>';uk='<настроїти авторозрахунок>'") ИЛИ
		Формула = НСтр("ru='<настроить автозаполнение>';uk='<настроїти автозаповнення>'") Тогда
		Формула = "";
	КонецЕсли;
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
	
	Если ЗначениеЗаполнено(ЭтаФорма.АдресЭлементаВХранилище) Тогда
		СтруктураЭлемента = ПолучитьИзВременногоХранилища(ЭтаФорма.АдресЭлементаВХранилище);
		СтруктураЭлемента.ОперандыФормулы.Очистить();
		Для Каждого СтрокаОперанда из ОперандыФормулы Цикл
			Если Не ЗначениеЗаполнено(СтрокаОперанда.АдресСтруктурыЭлемента) Тогда
				СтрокаОперанда.АдресСтруктурыЭлемента = 
					БюджетнаяОтчетностьКлиентСервер.ПоместитьЭлементВХранилище(СтрокаОперанда.Операнд, ИдентификаторГлавногоХранилища);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтруктураЭлемента.ОперандыФормулы.Добавить(), СтрокаОперанда);
		КонецЦикла;
		ПоместитьВоВременноеХранилище(СтруктураЭлемента, ЭтаФорма.АдресЭлементаВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Формула = НСтр("ru='<настроить автозаполнение>';uk='<настроїти автозаповнення>'")
		ИЛИ Формула = НСтр("ru='<настроить авторасчет>';uk='<настроїти авторозрахунок>'") Тогда
		Формула = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидЭлемента", 						ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель"));
	ПараметрыФормы.Вставить("АдресЭлементаВХранилище", 			ПолучитьАдресВременногоОбъектаДляРедактированияФормулы());
	ПараметрыФормы.Вставить("АдресРедактируемогоЭлемента", 		АдресЭлементаВХранилище);
	ПараметрыФормы.Вставить("ИдентификаторГлавногоХранилища", 	ИдентификаторГлавногоХранилища);
	ПараметрыФормы.Вставить("ИспользоватьДляВводаПлана", 		ИспользоватьДляВводаПлана);
	ПараметрыФормы.Вставить("СпособЗаполнения", 				СпособЗаполнения);
	ПараметрыФормы.Вставить("АдресТаблицыЭлементов", 			АдресТаблицыЭлементов);
	ПараметрыФормы.Вставить("АдресЭлементовОтчета", 			АдресЭлементовОтчета);
	ПараметрыФормы.Вставить("ВариантРасположенияГраницыФактическихДанных", ВариантРасположенияГраницыФактическихДанных);
	ПараметрыФормы.Вставить("ИдентификаторСтрокиЭлементаОтчета",ИдентификаторСтрокиЭлементаОтчета);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьПолеПослеИзмененияЭлемента", ЭтаФорма, ПараметрыФормы);
	
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.ФормаОбъекта",
								ПараметрыФормы, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаКлиенте
Процедура СпособЗаполненияПриИзменении(Элемент)
	
	Формула = "";
	ОперандыФормулы.Очистить();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.СпособЗаполнения = 0 Тогда
		Форма.Элементы.Формула.Гиперссылка = Ложь;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = "";
		КонецЕсли;
	ИначеЕсли Форма.СпособЗаполнения = 1 Тогда
		Форма.Элементы.Формула.Гиперссылка = Истина;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = НСтр("ru='<настроить авторасчет>';uk='<настроїти авторозрахунок>'");
		КонецЕсли;
	Иначе
		Форма.Элементы.Формула.Гиперссылка = Истина;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = НСтр("ru='<настроить автозаполнение>';uk='<настроїти автозаповнення>'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресВременногоОбъектаДляРедактированияФормулы()
	
	БуферныйОбъект = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
	БуферныйОбъект.НаименованиеДляПечати = Объект.НаименованиеДляПечати;
	БуферныйОбъект.ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель;
	ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(БуферныйОбъект, "Формула", Формула);
	БуферныйОбъект.ОперандыФормулы = ОперандыФормулы.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(БуферныйОбъект, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеФормулыИзВременногоХранилища(Адрес)
	
	БуферныйОбъект = ПолучитьИзВременногоХранилища(Адрес);
	Формула = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(БуферныйОбъект, "Формула");
	ОперандыФормулы.Загрузить(БуферныйОбъект.ОперандыФормулы);
	
	Если ПустаяСтрока(Формула) Тогда
		Формула = НСтр("ru='<настроить автозаполнение>';uk='<настроїти автозаповнення>'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПолеПослеИзмененияЭлемента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПрочитатьДанныеФормулыИзВременногоХранилища(ДополнительныеПараметры.АдресЭлементаВХранилище);
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти