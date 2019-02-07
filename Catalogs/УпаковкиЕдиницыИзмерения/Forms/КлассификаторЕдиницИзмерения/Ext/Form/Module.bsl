﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Дерево = Справочники.УпаковкиЕдиницыИзмерения.ПолучитьДанныеКлассификатора();
	
	Дерево.Колонки.Добавить("Выбран",     Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Существует", Новый ОписаниеТипов("Булево"));
	
	Соответствие = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка КАК Ссылка,
	|	ЕдиницыИзмерения.Код КАК Код
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Код <> """"
	|	И (ЕдиницыИзмерения.ТипИзмеряемойВеличины В (&Отбор)
	|			ИЛИ НЕ &ОтборЗаполнен)";
	Отбор = Неопределено;
	Параметры.Свойство("Отбор", Отбор);
	Запрос.УстановитьПараметр("Отбор", Отбор);
	Запрос.УстановитьПараметр("ОтборЗаполнен", ЗначениеЗаполнено(Отбор));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(СокрЛП(Выборка.Код), Выборка.Ссылка);
	КонецЦикла;
	
	ОбработатьДерево(Дерево, Отбор, Соответствие);
	
	СоответствиеЕдиниц = Новый ФиксированноеСоответствие(Соответствие);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКлассификатора");

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоКлассификатора

&НаКлиенте
Процедура ОбходДереваВверх(ТекущиеДанные)

	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда // Верхний уровень
		
		ДочерниеСтроки = Родитель.ПолучитьЭлементы();
		КоличествоВыбранных = 0;
		ОбщееКоличество = 0;
		Для каждого Элемент Из ДочерниеСтроки Цикл
			Если Элемент.Выбран = 2 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 0.5;
			ИначеЕсли Элемент.Выбран = 1 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 1;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + 1;
		КонецЦикла;
		
		Если ОбщееКоличество = КоличествоВыбранных Тогда
			Родитель.Выбран = 1;
		ИначеЕсли КоличествоВыбранных = 0 Тогда
			Родитель.Выбран = 0;
		Иначе
			Родитель.Выбран = 2;
		КонецЕсли;
		
		ОбходДереваВверх(Родитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходДереваВниз(ТекущиеДанные)
	
	ДочерниеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Элемент Из ДочерниеСтроки Цикл
		Элемент.Выбран = ТекущиеДанные.Выбран;
		ОбходДереваВниз(Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранПриИзменении(ТекущиеДанные)
	
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	ОбходДереваВверх(ТекущиеДанные);
	ОбходДереваВниз(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКлассификатораВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоКлассификатора.ТекущиеДанные;
	ВыбранПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОбработатьРезультатыПодбораНаСервере();
	Закрыть();
	
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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодЧисловой.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеНациональное.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеМеждународное.Имя);


	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.Существует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.DarkSlateBlue);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ОбработатьРезультатыПодбораНаСервере()
	
	МассивВыбранныхСтрок = Новый Массив;
	МассивКодов = Новый Массив;
	
	Дерево = РеквизитФормыВЗначение("ДеревоКлассификатора");
	
	НачатьТранзакцию();
	Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
		Если СтрокаУровень1.Выбран Тогда
			Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
				Если СтрокаУровень2.Выбран Тогда
					Для каждого СтрокаУровень3 Из СтрокаУровень2.Строки Цикл
						Если СтрокаУровень3.Выбран Тогда
						
							ЕдиницаСсылка = СоответствиеЕдиниц.Получить(СокрЛП(СтрокаУровень3.КодЧисловой));
							Если ЕдиницаСсылка <> Неопределено Тогда
								СправочникОбъект = ЕдиницаСсылка.ПолучитьОбъект();
								Если Не СправочникОбъект.Владелец = Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения Тогда
									Продолжить;
								КонецЕсли;
							Иначе
								СправочникОбъект = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
								СправочникОбъект.Владелец = Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения;
							КонецЕсли;
							
							Если ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеНациональное) Тогда
								Наименование = СтрокаУровень3.УсловноеОбозначениеНациональное;
							ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеМеждународное) Тогда
								Наименование = СтрокаУровень3.УсловноеОбозначениеМеждународное;
							Иначе
								Наименование = СтрокаУровень3.Наименование;
							КонецЕсли;
							
							СправочникОбъект.Наименование            = СтрЗаменить(Наименование,Символы.ПС,"/");
							СправочникОбъект.МеждународноеСокращение = СтрЗаменить(СтрокаУровень3.УсловноеОбозначениеМеждународное,Символы.ПС,"/");
							СправочникОбъект.НаименованиеПолное      = СтрЗаменить(СтрокаУровень3.Наименование,Символы.ПС,"/");
							СправочникОбъект.Код                     = СокрЛП(СтрокаУровень3.КодЧисловой);
							СправочникОбъект.Числитель               = СтрокаУровень3.Числитель;
							СправочникОбъект.Знаменатель             = СтрокаУровень3.Знаменатель;
							
							Если ЗначениеЗаполнено(СтрокаУровень3.ТипИзмеряемойВеличины) Тогда
								СправочникОбъект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин[СтрокаУровень3.ТипИзмеряемойВеличины];
							КонецЕсли;
							
							СправочникОбъект.Записать();
							
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДерево(Дерево, Отбор, Соответствие)
	
	МассивКУдалению = Новый Массив;
	ОбработатьУровень(Дерево.Строки, Отбор, МассивКУдалению, Соответствие, 1);
	УдалитьСтрокиИзКоллекцииСтрок(Дерево.Строки, МассивКУдалению);
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьУровень(Строки, Отбор, МассивКУдалению, Соответствие, Уровень)
	
	Для каждого Строка Из Строки Цикл
		Если Уровень = 3 Тогда
			
			ТипТекущейСтроки = Перечисления.ТипыИзмеряемыхВеличин.ПустаяСсылка();
			Если ЗначениеЗаполнено(Строка.ТипИзмеряемойВеличины) Тогда 
				ТипТекущейСтроки = Перечисления.ТипыИзмеряемыхВеличин[Строка.ТипИзмеряемойВеличины];
			КонецЕсли;

			Если ТипЗнч(Отбор) = Тип("Массив") И ЗначениеЗаполнено(Отбор) И Отбор.Найти(ТипТекущейСтроки) = Неопределено Тогда
				МассивКУдалению.Добавить(Строка);
			Иначе
				Если Соответствие.Получить(Строка.КодЧисловой) <> Неопределено Тогда
					Строка.Существует = Истина;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			МассивКУдалениюСледующегоУровня = Новый Массив;
			ОбработатьУровень(Строка.Строки, Отбор, МассивКУдалениюСледующегоУровня, Соответствие, Уровень + 1);
			УдалитьСтрокиИзКоллекцииСтрок(Строка.Строки, МассивКУдалениюСледующегоУровня);
			Если Строка.Строки.Количество() = 0 Тогда
				МассивКУдалению.Добавить(Строка);	
			КонецЕсли;                
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиИзКоллекцииСтрок(Строки, МассивКУдалению)
	Для Каждого СтрокаКУдалению Из МассивКУдалению Цикл
		Строки.Удалить(СтрокаКУдалению);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
