﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтборПодразделение = Параметры.Подразделение;
	УправлениеМаршрутнымиЛистами = Параметры.УправлениеМаршрутнымиЛистами;
	Если Параметры.Свойство("СписокЭтапов") Тогда
		СписокЭтапов.Загрузить(Параметры.СписокЭтапов.Выгрузить());
	КонецЕсли;
	
	Если Параметры.Свойство("СписокРаспоряжений") Тогда
		ОтборРаспоряжения.ЗагрузитьЗначения(Параметры.СписокРаспоряжений);
	КонецЕсли;
	
	ЗаполнитьВыборПериода();
	НастроитьФормуПоМетодикеУправления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПериоды

&НаКлиенте
Процедура ПериодыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СформироватьМаршрутныеЛисты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСформироватьМаршрутныеЛисты(Команда)
	
	СформироватьМаршрутныеЛисты();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого Строка Из КлючевыеВидыРабочихЦентров Цикл
		Строка.КлючевойРедактирование = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого Строка Из КлючевыеВидыРабочихЦентров Цикл
		Строка.КлючевойРедактирование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ЗаполнитьКлючевыеВидыРабочихЦентров();
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКлючевыеРЦ;
	Элементы.Далее.Видимость = Ложь;
	Элементы.Назад.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПериоды;
	Элементы.Далее.Видимость = Истина;
	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Выделение строки содержащей подразделение
	#Область Подразделение
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Периоды.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Периоды.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.ТопленоеМолоко);
	#КонецОбласти

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыборПериода()
	
	Если ЗначениеЗаполнено(ОтборРаспоряжения) Тогда
		СписокРаспоряжений = ОтборРаспоряжения.ВыгрузитьЗначения();
	Иначе
		СписокРаспоряжений = Неопределено;
	КонецЕсли;
	
	ДанныеДляФормирования = ОперативныйУчетПроизводстваВызовСервера.ДанныеДляФормированияМаршрутныхЛистов(
									ОтборПодразделение,
									СписокРаспоряжений,
									СписокЭтапов, 
									УправлениеМаршрутнымиЛистами);
	
	ТекущийИнтервалПланирования = Неопределено;
	ИспользоватьГруппировкуПоПодразделениям = Ложь;
	Для каждого ДанныеЗаполнения Из ДанныеДляФормирования Цикл
		Если ДанныеЗаполнения.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
			ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.День;
		Иначе
			ИнтервалПланирования = ДанныеЗаполнения.ИнтервалПланирования;
		КонецЕсли; 
		Если ТекущийИнтервалПланирования = Неопределено Тогда
			ТекущийИнтервалПланирования = ИнтервалПланирования;
		ИначеЕсли ТекущийИнтервалПланирования <> ИнтервалПланирования Тогда
			ИспользоватьГруппировкуПоПодразделениям = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ТекущийГод = Год(ТекущаяДатаСеанса());
	ОтображатьГод = Ложь;
	
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("Подразделение");
	ТаблицаПериодов.Колонки.Добавить("ДатаИнтервала");
	ТаблицаПериодов.Колонки.Добавить("ИнтервалПланирования");
	ТаблицаПериодов.Колонки.Добавить("Количество");
	Для каждого ДанныеЗаполнения Из ДанныеДляФормирования Цикл
		ДанныеСтроки = ТаблицаПериодов.Добавить();
		ДанныеСтроки.Подразделение = ДанныеЗаполнения.Подразделение;
		ДанныеСтроки.Количество = 1;
		
		Если ДанныеЗаполнения.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
			ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.День;
		Иначе
			ИнтервалПланирования = ДанныеЗаполнения.ИнтервалПланирования;
		КонецЕсли; 
		ДанныеСтроки.ИнтервалПланирования = ИнтервалПланирования;
		
		Если ДанныеЗаполнения.НачалоРаботыКлючевогоРабочегоЦентра <> '000101010000' Тогда
			ДатаИнтервала = ДанныеЗаполнения.НачалоРаботыКлючевогоРабочегоЦентра;
		Иначе
			ДатаИнтервала = ДанныеЗаполнения.Начало;
		КонецЕсли; 
		
		Если ТекущийГод <> Год(ДатаИнтервала) Тогда
			ОтображатьГод = Истина;
		КонецЕсли; 
		
		ДанныеСтроки.ДатаИнтервала = ПланированиеПроизводстваКлиентСервер.ОкончаниеИнтервалаПланирования(
											ДатаИнтервала, 
											ИнтервалПланирования);
											
	КонецЦикла; 

	Если ОтображатьГод Тогда
		ФорматДаты = "ДФ='dd MMMM yyyy (ddd)'";
	Иначе
		ФорматДаты = "ДФ='dd MMMM (ddd)'";
	КонецЕсли; 
	
	Если ИспользоватьГруппировкуПоПодразделениям Тогда
		ТаблицаПериодов.Свернуть("Подразделение,ДатаИнтервала,ИнтервалПланирования", "Количество");
		ТаблицаПериодов.Сортировать("Подразделение,ДатаИнтервала");
		СписокПодразделений = ТаблицаПериодов.ВыгрузитьКолонку("Подразделение");
		СписокПодразделений = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(СписокПодразделений);
		
		КоллекцияПодразделения = Периоды.ПолучитьЭлементы();
		Для каждого Подразделение Из СписокПодразделений Цикл
			СтрокаПодразделение = КоллекцияПодразделения.Добавить();
			СтрокаПодразделение.Представление = Подразделение;
			СтрокаПодразделение.ТипСтроки = 1;
			
			Количество = 0;
			
			КоллекцияПериоды = СтрокаПодразделение.ПолучитьЭлементы();
			СтруктураПоиска = Новый Структура("Подразделение", Подразделение);
			СписокСтрок = ТаблицаПериодов.НайтиСтроки(СтруктураПоиска);
			Для каждого ДанныеСтроки Из СписокСтрок Цикл
				Количество = Количество + ДанныеСтроки.Количество;
				
				СтрокаПериод = КоллекцияПериоды.Добавить();
				СтрокаПериод.Подразделение = Подразделение;
				СтрокаПериод.Окончание = ДанныеСтроки.ДатаИнтервала;
				СтрокаПериод.Представление = Формат(ДанныеСтроки.ДатаИнтервала, ФорматДаты);
				СтрокаПериод.Количество = КоличествоДокументовСтрокой(Количество, СтрокаПериод.Представление);
			КонецЦикла; 
		КонецЦикла; 
	Иначе
		ТаблицаПериодов.Свернуть("ДатаИнтервала,ИнтервалПланирования", "Количество");
		ТаблицаПериодов.Сортировать("ДатаИнтервала");
		
		Количество = 0;
		КоллекцияПериоды = Периоды.ПолучитьЭлементы();
		Для каждого ДанныеСтроки Из ТаблицаПериодов Цикл
			Количество = Количество + ДанныеСтроки.Количество;
			
			СтрокаПериод = КоллекцияПериоды.Добавить();
			СтрокаПериод.Подразделение = ОтборПодразделение;
			СтрокаПериод.Окончание = ДанныеСтроки.ДатаИнтервала;
			СтрокаПериод.Представление = Формат(ДанныеСтроки.ДатаИнтервала, ФорматДаты);
			СтрокаПериод.Количество = КоличествоДокументовСтрокой(Количество, СтрокаПериод.Представление);
		КонецЦикла; 
	КонецЕсли; 
	
	Если Параметры.ВыбратьДату <> '000101010000' И НЕ ИспользоватьГруппировкуПоПодразделениям Тогда
		ТекущаяСтрока = Неопределено;
		КоллекцияПериоды = Периоды.ПолучитьЭлементы();
		Для каждого СтрокаПериод Из КоллекцияПериоды Цикл
			ТекущаяСтрока = СтрокаПериод;
			Если СтрокаПериод.Окончание >= Параметры.ВыбратьДату Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		Если ТекущаяСтрока <> Неопределено Тогда
			Элементы.Периоды.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция КоличествоДокументовСтрокой(Количество, ПредставлениеПериода)
	
	ПараметрыПредметаИсчисления = НСтр("ru='документ, документа, документов, м,,,,,0';uk='документ, документа, документів, м,,,,,0'");
	ДокументПрописью = ЧислоПрописью(Количество, "Л = ru_RU; НД=ложь; ДП = Истина", ПараметрыПредметаИсчисления);
	ДокументПрописью = СтрЗаменить(ДокументПрописью, " ", Символы.ПС);
	
	ПараметрыПредметаИсчисления = НСтр("ru='сформирован, сформировано, сформировано, м,,,,,0';uk='сформований, сформовано, сформовано, м,,,,,0'");
	СформированПрописью = ЧислоПрописью(Количество, "Л = ru_RU; НД=ложь; ДП = Истина", ПараметрыПредметаИсчисления);
	СформированПрописью = СтрЗаменить(СформированПрописью, " ", Символы.ПС);
	
	КоличествоСтрокой = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='По %1 будет %2 %3 %4.';uk='По %1 буде %2 %3 %4.'"),
									ПредставлениеПериода,
									СтрПолучитьСтроку(СформированПрописью, СтрЧислоСтрок(ДокументПрописью)),
									Количество,
									СтрПолучитьСтроку(ДокументПрописью, СтрЧислоСтрок(ДокументПрописью)));
	Возврат КоличествоСтрокой;
	
КонецФункции
 
&НаКлиенте
Процедура СформироватьМаршрутныеЛисты()

	ТекущиеДанные = Элементы.Периоды.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ТипСтроки = 1 Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Подразделение", ТекущиеДанные.Подразделение);
	Результат.Вставить("Окончание", ТекущиеДанные.Окончание);
	Результат.Вставить("УправлениеМаршрутнымиЛистами", УправлениеМаршрутнымиЛистами);
	
	КлючевыеВРЦ = Новый Массив;
	Для каждого Строка Из КлючевыеВидыРабочихЦентров Цикл
		Если Строка.КлючевойРедактирование Тогда
			КлючевыеВРЦ.Добавить(Строка.ВидРабочегоЦентра);
		КонецЕсли;
	КонецЦикла;
	Результат.Вставить("КлючевыеВидыРабочихЦентров", КлючевыеВРЦ);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоМетодикеУправления()
	
	Если УправлениеМаршрутнымиЛистамиРегистрацияОпераций(ЭтотОбъект) Тогда
		Элементы.Далее.Видимость = Истина;
	Иначе
		Элементы.Далее.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УправлениеМаршрутнымиЛистамиРегистрацияОпераций(Форма)
	
	РегистрацияОпераций = ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.РегистрацияОпераций");
	Возврат Форма.УправлениеМаршрутнымиЛистами = РегистрацияОпераций;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКлючевыеВидыРабочихЦентров()
	
	Окончание = ДатаОкончанияСозданияДокументов();
	
	Если НЕ Окончание = Неопределено Тогда
		КлючевыеВидыРабочихЦентровТаблица = ОперативныйУчетПроизводства.КлючевыеВидыРабочихЦентров(
												ОтборПодразделение, 
												'00010101',
												Окончание,
												Истина);
		КлючевыеВидыРабочихЦентровТаблица.Свернуть("ВидРабочегоЦентра", "Загрузка, ОбъемРабот, Доступно");
		Для каждого Строка Из КлючевыеВидыРабочихЦентровТаблица Цикл
			Если НЕ Строка.Доступно = 0 Тогда
				Строка.Загрузка = Окр((Строка.ОбъемРабот/Строка.Доступно)*100);
			КонецЕсли;
		КонецЦикла;
		
		// Запомним выделенные строки.
		ВыбранныеВРЦ = Новый Массив;
		Для каждого Строка Из КлючевыеВидыРабочихЦентров Цикл
			Если Строка.КлючевойРедактирование Тогда
				ВыбранныеВРЦ.Добавить(Строка.ВидРабочегоЦентра);
			КонецЕслИ;
		КонецЦикла;
		
		КлючевыеВидыРабочихЦентров.Загрузить(КлючевыеВидыРабочихЦентровТаблица);
		КлючевыеВидыРабочихЦентров.Сортировать("Загрузка Убыв");
		
		Если ЗначениеЗаполнено(КлючевыеВидыРабочихЦентров) Тогда
			СтруктураПоиска = Новый Структура("ВидРабочегоЦентра");
			Для каждого ВидРабочегоЦентра Из ВыбранныеВРЦ Цикл
				СтруктураПоиска.ВидРабочегоЦентра = ВидРабочегоЦентра;
				НайденныеСтроки = КлючевыеВидыРабочихЦентров.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() = 1 Тогда
					НайденныеСтроки[0].КлючевойРедактирование = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДатаОкончанияСозданияДокументов()
	
	ТекущаяСтрока = Элементы.Периоды.ТекущаяСтрока;
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		ТекущиеДанные = Периоды.НайтиПоИдентификатору(ТекущаяСтрока);
		Если НЕ ТекущиеДанные.ТипСтроки = 1 Тогда
			Результат = ТекущиеДанные.Окончание;
		Иначе
			Результат = Неопределено;
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
