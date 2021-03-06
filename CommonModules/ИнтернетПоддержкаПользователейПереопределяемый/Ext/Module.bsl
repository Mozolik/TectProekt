﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейПереопределяемый
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для обработки событий Интернет-поддержки пользователей

// Обработка события сохранения в информационной базе логина и пароля для
// подключения к сервисам Интернет-поддержки.
//
// Параметры:
// ДанныеПользователя - Структура - структура с полями:
//	* Логин - Строка - логин пользователя;
//	* Пароль - Строка - пароль пользователя;
//
Процедура ПриАвторизацииПользователяВИнтернетПоддержке(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

// Обработка события удаления из информационной базы логина и пароля для подключения
// к сервисам Интернет-поддержки.
//
Процедура ПриВыходеПользователяИзИнтернетПоддержки() Экспорт
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации",
		"НастройкиОбновленияКонфигурации");

	Если Настройки <> Неопределено Тогда
		Настройки.Вставить("КодПользователяСервераОбновлений" , "");
		Настройки.Вставить("ПарольСервераОбновлений"          , "");
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ОбновлениеКонфигурации", 
			"НастройкиОбновленияКонфигурации",
			Настройки);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревшие переопределяемые методы

// Устарела. Будет удалена в следующей версии библиотеки, т.к. теперь процедура
// не распространяет свое действие на все подсистемы библиотеки.
// Вместо этой процедуры необходимо использовать процедуры:
//    МониторИнтернетПоддержкиПереопределяемый.ИспользоватьМониторИнтернетПоддержки();
// если в конфигурацию внедрены соответствующие подсистемы.
//
// Переопределяет возможность использования механизма Интернет-поддержки:
// монитор Интернет-поддержки, авторизация/регистрация в сервисе
// Интернет-поддержки, получение уникального идентификатора абонента
// электронного документооборота, вход в личный кабинет абонента электронного
// документооборота.
//
// Использование Интернет-поддержки запрещено при работе в модели сервиса.
// Процедура вызывается для дополнительной проверки разрешения при работе в
// локальном режиме.
//
// Для запрета использования функций Интернет-поддержки необходимо присвоить
// параметру Отказ значение Истина.
// 
// Параметры:
//	Отказ - Булево - Истина, использование интренет-поддержки запрещено;
//		Ложь - в противном случае;
//		Значение по умолчанию - Ложь;
//
// Пример:
//	Если <Выражение> Тогда
//		Отказ = Истина;
//	КонецЕсли;
//
Процедура ИспользоватьИнтернетПоддержку(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед авторизацией пользователя в Интернет-поддержке
// пользователей для определения данных текущего пользователя, если
// логин и пароль не указаны.
// Процедура используется ТОЛЬКО, если необходимо переопределить логин и пароль
// неавторизованного пользователя, например, на основе логина и пароля
// пользователя сервера обновлений или каким-либо другим способом.
//
// Параметры:
// ДанныеПользователя - Структура - выходной параметр - структура, заполняемая
//		данными о пользователе Интернет-поддержки:
//	* Логин - Строка - логин пользователя;
//	* Пароль - Строка - пароль пользователя;
//
// Пример:
// получение логина и пароля пользователя Интернет-поддержки
// из настроек пользователя сервера обновлений для конфигураций со встроенной
// библиотекой "Библиотека стандартных подсистем" (БСП):
//
//	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
//		"ОбновлениеКонфигурации", 
//		"НастройкиОбновленияКонфигурации"
//	);
//
//	Если Настройки = Неопределено Тогда
//		Возврат;
//	Иначе
//		ДанныеПользователя.Вставить("Логин" , Настройки.КодПользователяСервераОбновлений);
//		ДанныеПользователя.Вставить("Пароль", Настройки.ПарольСервераОбновлений);
//	КонецЕсли;
//
Процедура ПриОпределенииДанныхПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации");
	
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("КодПользователяСервераОбновлений") Тогда
		ДанныеПользователя.Вставить("Логин" , Настройки.КодПользователяСервераОбновлений);
		Если Настройки.Свойство("ПарольСервераОбновлений") Тогда
			ДанныеПользователя.Вставить("Пароль", Настройки.ПарольСервераОбновлений);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
