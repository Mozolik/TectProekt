﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// Текст сообщения пустой, вывести его на передний план.
	Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаГотово;

	лкКаталогВременныхФайлов = КаталогВременныхФайлов();
	Если (Прав(лкКаталогВременныхФайлов, 1) <> ПолучитьРазделительПутиСервера())
			И (Прав(лкКаталогВременныхФайлов, 1) <> ПолучитьРазделительПутиСервера()) Тогда
		лкКаталогВременныхФайлов = лкКаталогВременныхФайлов + ПолучитьРазделительПутиСервера();
	КонецЕсли;
	ЭтаФорма.ИмяКаталогаЭкспорта = лкКаталогВременныхФайлов;

	ЭтаФорма.ПериодДень = ТекущаяДата();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицыФормы
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЭкспорт(Команда)

	Если ПроверитьЗаполнение() Тогда

		Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаПрогресс;
		ЭтаФорма.ОбновитьОтображениеДанных();

		ДатаСтрокой = Формат(ЭтаФорма.ПериодДень,"ДФ=yyyy-MM-dd");

		Результат = КомандаЭкспортНаСервере(ДатаСтрокой);

		Если ПустаяСтрока(Результат.ТекстОшибки) Тогда
			Если ПустаяСтрока(Результат.АдресВременногоХранилищаФайла) Тогда
				ТекстСообщения = НСтр("ru='Не удалось экспортировать события журнала регистрации в файл.
                    |Данные не удалось поместить во временное хранилище.'
                    |;uk='Не вдалося експортувати події журналу реєстрації у файл.
                    |Дані не вдалося помістити в тимчасове сховище.'");
				ЭтаФорма.РезультатЭкспорта = ТекстСообщения;
			Иначе
				// Попробовать записать файл.
				ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Результат.АдресВременногоХранилищаФайла);
				Если ТипЗнч(ДвоичныеДанныеФайла) = Тип("ДвоичныеДанные") Тогда
					лкИмяКаталогаЭкспорта = ЭтаФорма.ИмяКаталогаЭкспорта;
					Если (Прав(лкИмяКаталогаЭкспорта, 1) <> "\") И (Прав(лкИмяКаталогаЭкспорта, 1) <> "/") Тогда
						лкИмяКаталогаЭкспорта = лкИмяКаталогаЭкспорта + "\";
					КонецЕсли;
					Если ЭтаФорма.СжиматьФайл Тогда
						ИмяФайла = лкИмяКаталогаЭкспорта + ДатаСтрокой + ".zip";
					Иначе
						ИмяФайла = лкИмяКаталогаЭкспорта + ДатаСтрокой + ".xml";
					КонецЕсли;
					Попытка
						ДвоичныеДанныеФайла.Записать(ИмяФайла);
						ТекстСообщения = НСтр("ru='Журнал событий успешно экспортирован в файл с именем
                            |%ИмяФайла%'
                            |;uk='Журнал подій успішно експортувати у файл з ім''ям
                            |%ИмяФайла%'");
						ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяФайла%", ИмяФайла);
						ЭтаФорма.РезультатЭкспорта = ТекстСообщения;
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ТекстСообщения = НСтр("ru='Не удалось записать файл по причине:
                            |%ТекстОшибки%'
                            |;uk='Не вдалося записати файл з причини:
                            |%ТекстОшибки%'");
						ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстОшибки%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
						ЭтаФорма.РезультатЭкспорта = ТекстСообщения;
					КонецПопытки;
				Иначе
					ТекстСообщения = НСтр("ru='Не удалось экспортировать события журнала регистрации в файл.
                        |Во временное хранилище помещены данные неправильного типа %Тип%.'
                        |;uk='Не вдалося експортувати події журналу реєстрації у файл.
                        |У тимчасове сховище поміщені дані неправильного типу %Тип%.'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Тип%", ?(ДвоичныеДанныеФайла = Неопределено, "Неопределено", ТипЗнч(ДвоичныеДанныеФайла)));
					ЭтаФорма.РезультатЭкспорта = ТекстСообщения;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЭтаФорма.РезультатЭкспорта = Результат.ТекстОшибки;
		КонецЕсли;

		Элементы.СтраницыПрогресса.ТекущаяСтраница = Элементы.СтраницаГотово;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КомандаЭкспортНаСервере(ИмяФайла)

	Результат = Новый Структура("АдресВременногоХранилищаФайла, ТекстОшибки", "", "");

	// Если действие - длительное (журнал регистрации очень большой), то возможна ситуация,
	//  когда управление будет передано другому рабочему процессу,
	//  находящемуся на другом сервере и тогда временный каталог может стать недоступен.
	// В этом случае у пользователя выскочит ошибка и надо будет снова попробовать выгрузить данные.

	Попытка

		УстановитьПривилегированныйРежим(Истина);

			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
			СписокСобытий = Новый Массив;
				СписокСобытий.Добавить("БИП:Новости.Разное");
				СписокСобытий.Добавить("БИП:Новости.Клиент");
				СписокСобытий.Добавить("БИП:Новости.Отладка");
				СписокСобытий.Добавить("БИП:Новости.Все обновления новостей");
				СписокСобытий.Добавить("БИП:Новости.Сервис и регламент");
				СписокСобытий.Добавить("БИП:Новости.Обновление ИБ");
				СписокСобытий.Добавить("БИП:Новости.Загрузка новостей");
				СписокСобытий.Добавить("БИП:Новости.Загрузка классификаторов");
				СписокСобытий.Добавить("БИП:Новости.Хранилище настроек новостей");
				СписокСобытий.Добавить("БИП:Новости.Переопределяемый");
				СписокСобытий.Добавить("БИП:Новости.Изменение данных");

			ПараметрыОтбора = Новый Структура("ДатаНачала, ДатаОкончания, Событие",
				НачалоДня(ЭтаФорма.ПериодДень),
				КонецДня(ЭтаФорма.ПериодДень),
				СписокСобытий
			);

			ВыгрузитьЖурналРегистрации(
				ИмяВременногоФайла,
				ПараметрыОтбора
			);

			ФайлВременный = Новый Файл(ИмяВременногоФайла);
			Если ФайлВременный.Существует() Тогда
				НовоеИмяФайла = ФайлВременный.Путь + ИмяФайла + ".xml";
				ПереместитьФайл(ИмяВременногоФайла, НовоеИмяФайла);
				ФайлГотовый = Новый Файл(НовоеИмяФайла);
				Если ФайлГотовый.Существует() Тогда
					Если ЭтаФорма.СжиматьФайл Тогда
						ИмяФайлаАрхива = ФайлВременный.Путь + ИмяФайла + ".zip";
						Архив = Новый ЗаписьZipФайла(
							ИмяФайлаАрхива,
							, // Без пароля
							"Выгрузка журнала регистраций подсистемы Новости библиотеки БИП за " + ИмяФайла,
							МетодСжатияZIP.Сжатие,
							УровеньСжатияZIP.Максимальный
						);
						Архив.Добавить(ФайлГотовый.ПолноеИмя, РежимСохраненияПутейZIP.НеСохранятьПути, РежимОбработкиПодкаталоговZIP.НеОбрабатывать);
						Архив.Записать();
						Результат.Вставить("АдресВременногоХранилищаФайла", ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаАрхива)));
					Иначе
						Результат.Вставить("АдресВременногоХранилищаФайла", ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(НовоеИмяФайла)));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

		УстановитьПривилегированныйРежим(Ложь);

	Исключение

		ИнформацияОбОшибке = ИнформацияОбОшибке();

		ТекстСообщения = НСтр("ru='Не удалось экспортировать события журнала регистрации в файл по причине:
            |%ТекстОшибки%'
            |;uk='Не вдалося експортувати події журналу реєстрації у файл з причини:
            |%ТекстОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстОшибки%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Результат.Вставить("ТекстОшибки", ТекстСообщения);

		ОбработкаНовостей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Разное';uk='БІП:Новини.Різне'"), // ИмяСобытия
			НСтр("ru='Новости. Разное. Ошибка экспорта журнала регистрации';uk='Новини. Різне. Помилка експорту журналу реєстрації'"), // ИдентификаторШага
			УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			, // Данные
			ТекстСообщения // Комментарий
		);

	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти
