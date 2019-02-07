﻿
#Область ПрограммныйИнтерфейс

// Формирует дерево значений с колонками Наименование, Оператор, Сдвиг
//
// Возвращаемое значение:
// ДеревоЗначений
//
Функция ПолучитьПустоеДеревоОператоров() Экспорт
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

// Добавляет в дерево операторов группу операторов с переданным наименованием
//
// Параметры:
// Дерево - ДеревоЗначений - дерево операторов с колонками Наименование, Оператор, Сдвиг
// Наименование - Строка - наименование группы дерева операторов
//
// Возвращаемое значение:
// СтрокаДереваЗначений
//
Функция ДобавитьГруппуОператоров(Дерево, Наименование) Экспорт
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

// Добавляет в дерево операторов группу операторов с переданным наименованием
//
// Параметры:
// Дерево        - ДеревоЗначений - дерево операторов с колонками Наименование, Оператор, Сдвиг
// Родитель      - СтрокаДереваЗначений - Группа операторов, в которую необходимо добавить оператор
// Наименование  - Строка - наименование группы дерева операторов
// Оператор      - Строка - Представление оператора на встроенном языке
// Сдвиг         - Число - необходим для определения позиции курсора
//
// Возвращаемое значение:
// СтрокаДереваЗначений
//
Функция ДобавитьОператор(Дерево, Родитель = Неопределено, Наименование, Оператор = Неопределено, Сдвиг = 0) Экспорт
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Формирует дерево со стандартными операторами "+", "-", "*", "/"
//
// Возвращаемое значение:
// ДеревоЗначений
//
Функция ПолучитьСтандартноеДеревоОператоров() Экспорт
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, "Операторы");
	ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	Возврат Дерево;
	
КонецФункции

// Заполняет дерево операторов для конструктора формул.
//
// Параметры:
//  Параметры  - Структрура - содержит виды операторов, которые необходимо добавить в дерево.
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор формы, в которой выполняется действия, 
//                 необходим для корректного помещения во временное хранилище.
//
Функция ПостроитьДеревоОператоров(Параметры, УникальныйИдентификатор) Экспорт
	
	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОператоров();
	
	Если Параметры.Свойство("СтандартныеОператоры") И Параметры.СтандартныеОператоры Тогда
		ДобавитьГруппуСтандартныхОператоров(Дерево);
	КонецЕсли;
	
	Если Параметры.Свойство("ЛогическиеОператоры") И Параметры.ЛогическиеОператоры Тогда
		ДобавитьГруппуЛогическихОператоров(Дерево);
	КонецЕсли;
	
	Если Параметры.Свойство("Функции") И Параметры.Функции Тогда
		ДобавитьГруппуФункции(Дерево);
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	
КонецФункции

Процедура ДобавитьГруппуСтандартныхОператоров(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Операторы';uk='Оператори'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");

КонецПроцедуры

Процедура ДобавитьГруппуЛогическихОператоров(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Логические операторы и константы';uk='Логічні оператори і константи'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='И';uk='И'"),      " " + НСтр("ru='И';uk='И'")      + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИЛИ';uk='АБО'"),    " " + НСтр("ru='ИЛИ';uk='АБО'")    + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='НЕ';uk='НЕ'"),     " " + НСтр("ru='НЕ';uk='НЕ'")     + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИСТИНА';uk='ІСТИНА'"), " " + НСтр("ru='ИСТИНА';uk='ІСТИНА'") + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ЛОЖЬ';uk='ХИБНІСТЬ'"),   " " + НСтр("ru='ЛОЖЬ';uk='ХИБНІСТЬ'")   + " ");

КонецПроцедуры

Процедура ДобавитьГруппуФункции(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Функции';uk='Функції'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Максимум';uk='Максимум'"),    НСтр("ru='Макс(,)';uk='Макс(,)'"), 2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Минимум';uk='Мінімум'"),     НСтр("ru='Мин(,)';uk='Мин(,)'"),  2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Округление';uk='Округлення'"),  НСтр("ru='Окр(,)';uk='Окр(,)'"),  2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Целая часть';uk='Ціла частина'"), НСтр("ru='Цел()';uk='Цел()'"),   1);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Условие';uk='Умова'"),     "?(,,)",              3);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Предопределенное значение';uk='Напередвизначене значення'"), НСтр("ru='ПредопределенноеЗначение()';uk='ПредопределенноеЗначение()'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Значение заполнено';uk='Значення заповнено'"), НСтр("ru='ЗначениеЗаполнено()';uk='ЗначениеЗаполнено()'"));

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
