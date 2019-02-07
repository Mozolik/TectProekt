﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет выгрузить файл для обмена с банком по платежному документу, который объединяет ведомости в банк.
//
// Параметры:
//		МассивПлатежныхДокументов - Массив ссылок платежных документов.
//		Форма - Форма из которой производится выгрузка файла.
//
Процедура ВыгрузитьВФайлПлатежныеДокументыПеречисленияЗарплаты(МассивДокументов, Форма) Экспорт
	
	ТекстСостояния = НСтр("ru='Выполняется сохранение файлов.
    |Пожалуйста, подождите.'
    |;uk='Виконується збереження файлів.
    |Будь ласка, зачекайте.'");
	Состояние(ТекстСостояния);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор);
	ПолучаемыеФайлы = ОбменСБанкамиПоЗарплатнымПроектамВызовСервера.ВыгрузитьФайлыДляОбменаСБанком(
		Новый Структура("МассивДокументов, УникальныйИдентификаторФормы", МассивДокументов, Форма.УникальныйИдентификатор), АдресХранилища);
	
	СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы);
	
	Если МассивДокументов.Количество() > 0 Тогда
		ОповеститьОбИзменении(ТипЗнч(МассивДокументов[0]));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Конструирует структуру данных для заполнения параметров загрузки подтверждений из файлов обмена с банками.
//
// Возвращаемое значение
//		ПомещаемыеФайлы -	Массив объектов типа ОписаниеПередаваемогоФайла,
//							каждый объект описывает получаемый файл.
//		ПомещенныеФайлы -	Массив объектов типа ОписаниеПереданногоФайла,
//							каждый объект описывает помещенный файл.
//		КаталогФайлов -		Каталог загрузки файлов.
//
//
Функция ПараметрыЗагрузкиФайловИзБанка() Экспорт
	
	Параметры = Новый Структура(
		"ПомещаемыеФайлы, 
		|ПомещенныеФайлы, 
		|КаталогФайлов, 
		|ОповещениеЗавершения, 
		|МножественныйВыбор,
		|СтруктураОшибок");
		
	Параметры.ПомещаемыеФайлы = Новый Массив; 
	Параметры.ПомещенныеФайлы = Новый Массив;
	Параметры.КаталогФайлов = ""; 
	Параметры.МножественныйВыбор = Истина;
	Параметры.СтруктураОшибок = Новый Структура;
		
	Возврат Параметры;
	
КонецФункции

// Конструирует структуру данных для заполнения параметров сохранения на диске файлов обмена с банками.
//
Функция ПараметрыСохраненияФайловДляБанка() Экспорт
	
	Параметры = Новый Структура(
		"ПолучаемыеФайлы,
		|КаталогФайлов, 
		|ИнициализированныйКаталогФайлов, 
		|ОповещениеЗавершения, 
		|СтруктураОшибок");
		
	Параметры.ПолучаемыеФайлы = Новый Массив;
	Параметры.КаталогФайлов = ""; 
	Параметры.СтруктураОшибок = Новый Структура;
		
	Возврат Параметры;
	
КонецФункции

// Загружает файлы выбранные с диска на сервер.
//
Процедура ЗагрузитьФайлыИзБанка(ПараметрыЗагрузки) Экспорт
	
	ТекстСообщения = НСтр("ru='Для загрузки файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.';uk='Для завантаження файлів рекомендується встановити розширення для веб-клієнта 1С:Підприємство.'");
	Обработчик = Новый ОписаниеОповещения("ЗагрузитьФайлыИзБанкаПродолжение", ЭтотОбъект, ПараметрыЗагрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

// Сохраняет получаемые файлы на диск и сообщает пользователю об операции.
//
// Параметры:
//		ПолучаемыеФайлы - массив описаний файлов, которые должны быть сохранены на диск.
//		КаталогФайлов - Путь, куда сохранены файлы.
//
// Возвращаемое значение:
//		СтруктураОшибок - структура с ошибками, возникшими при сохранении файлов.
//
Процедура СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы, ПараметрыСохранения = Неопределено) Экспорт
	
	МассивОшибок = Новый Массив;
	
	Если ПолучаемыеФайлы.Количество() = 0 Тогда
		ОписаниеОшибки = Новый Структура("Описание, ТекстОшибки");
		ОписаниеОшибки.ТекстОшибки = НСтр("ru='Сохранение файлов не выполнено.';uk='Збереження файлів не виконано.'");
		МассивОшибок.Добавить(Новый Структура("ОписаниеОшибки, ТекстСообщения", ОписаниеОшибки, ОписаниеОшибки.ТекстОшибки));
		Состояние(ОписаниеОшибки.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСохранения = Неопределено Тогда
		ПараметрыСохранения = ПараметрыСохраненияФайловДляБанка();
	КонецЕсли;
	ПараметрыСохранения.ПолучаемыеФайлы = ПолучаемыеФайлы;
	
	ТекстСообщения = НСтр("ru='Для сохранения файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.';uk='Для збереження файлів рекомендується встановити розширення для веб-клієнта 1С:Підприємство.'");
	Обработчик = Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПродолжение", ЭтотОбъект, ПараметрыСохранения);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

Процедура ОткрытьДокументПодтверждение(Форма) Экспорт
	
	Если Не ПустаяСтрока(Форма.ТипДокументаПодтвержденияИзБанка) Тогда
		Отбор = Новый Структура("Ссылка", Форма.ДокументПодтверждениеИзБанка);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ОткрытьФорму(Форма.ТипДокументаПодтвержденияИзБанка + ".ФормаСписка", ПараметрыФормы, Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьФайлДляОбменаСБанком(МассивДокументов, Форма) Экспорт
	
	ТекстСостояния = НСтр("ru='Выполняется сохранение файлов.
        |Пожалуйста, подождите.'
        |;uk='Виконується збереження файлів.
        |Будь ласка, зачекайте.'");
	Состояние(ТекстСостояния);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор);
	
	ПараметрыВыгрузки = Новый Структура("МассивДокументов, УникальныйИдентификаторФормы");
	ПараметрыВыгрузки.МассивДокументов = МассивДокументов;
	ПараметрыВыгрузки.УникальныйИдентификаторФормы = Форма.УникальныйИдентификатор;
	ПолучаемыеФайлы = ОбменСБанкамиПоЗарплатнымПроектамВызовСервера.ВыгрузитьФайлыДляОбменаСБанком(ПараметрыВыгрузки, АдресХранилища);
	
	СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы);
	
	Если МассивДокументов.Количество() > 0 Тогда
		ОповеститьОбИзменении(ТипЗнч(МассивДокументов[0]));
	КонецЕсли;
	
КонецПроцедуры

#Область СохранениеФайловНаДиске

Процедура СохранитьФайлыДляОбменаСБанкомПродолжение(Подключено, ПараметрыСохранения) Экспорт
	
	Если Не Подключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		Для Каждого ОписаниеФайла Из ПараметрыСохранения.ПолучаемыеФайлы Цикл
			ПолучитьФайл(ОписаниеФайла.Хранение, ОписаниеФайла.Имя, Истина);
		КонецЦикла;
		СохранитьФайлыДляОбменаСБанкомЗавершение(ПараметрыСохранения.ПолучаемыеФайлы, ПараметрыСохранения);
		Возврат;
	КонецЕсли;
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомЗавершение", ЭтотОбъект, ПараметрыСохранения);
	
	// Вариант для установленного расширения для работы с файлами.
	// Если каталог не передан, запрашиваем его перед записью.
	Если Не ЗначениеЗаполнено(ПараметрыСохранения.КаталогФайлов) Тогда
		ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораКаталога.Заголовок = НСтр("ru='Выберите папку для сохранения файлов обмена с банком';uk='Виберіть папку для збереження файлів обміну з банком'");
		НачатьПолучениеФайлов(ОписаниеЗавершения, ПараметрыСохранения.ПолучаемыеФайлы, ДиалогВыбораКаталога, Истина);
		Возврат;
	КонецЕсли;
	
	// Если передан каталог проверим его и запишем, не запрашивая.
	
	// Проверим существует ли каталог.
	ВыбранныйКаталог = Новый Файл;
	ВыбранныйКаталог.НачатьИнициализацию(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеИнициализации", ЭтотОбъект, ПараметрыСохранения), ПараметрыСохранения.КаталогФайлов);
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеИнициализации(ВыбранныйКаталог, ПараметрыСохранения) Экспорт
	
	ПараметрыСохранения.ИнициализированныйКаталогФайлов = ВыбранныйКаталог;
	
	ВыбранныйКаталог = ПараметрыСохранения.ИнициализированныйКаталогФайлов;
	ВыбранныйКаталог.НачатьПроверкуСуществования(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеПроверкиКаталогСуществует", ЭтотОбъект, ПараметрыСохранения));
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеПроверкиКаталогСуществует(Существует, ПараметрыСохранения) Экспорт
	
	Если Не Существует Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Выбранного каталога не существует.';uk='Вибраного каталогу не існує.'"));
		Возврат;
	КонецЕсли;
	
	// Проверим каталог ли это.
	ВыбранныйКаталог = ПараметрыСохранения.ИнициализированныйКаталогФайлов;
	ВыбранныйКаталог.НачатьПроверкуЭтоКаталог(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеПроверкиЭтоКаталог", ЭтотОбъект, ПараметрыСохранения));
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеПроверкиЭтоКаталог(ЭтоКаталог, ПараметрыСохранения) Экспорт
	
	Если Не ЭтоКаталог Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Выбранный путь не является каталогом.';uk='Обраний шлях не є каталогом.'"));
		Возврат;
	КонецЕсли;
	
	// Проверка завершена, запишем файлы в каталог.
	НачатьПолучениеФайлов(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомЗавершение", ЭтотОбъект, ПараметрыСохранения), ПараметрыСохранения.ПолучаемыеФайлы, ПараметрыСохранения.КаталогФайлов, Ложь);
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомЗавершение(ПолученныеФайлы, ПараметрыСохранения) Экспорт
	
	// Оповещаем вызывающую сторону, если нас об этом просили.
	Если ПараметрыСохранения.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ПараметрыСохранения.ОповещениеЗавершения, ПолученныеФайлы <> Неопределено);
	КонецЕсли;
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСохранения.ПолучаемыеФайлы.Количество() <> ПолученныеФайлы.Количество() Тогда
		Состояние(НСтр("ru='Файлы сохранены частично.';uk='Файли збережені частково.'"), , ПараметрыСохранения.КаталогФайлов);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru='Файлы успешно сохранены.';uk='Файли успішно збережено.'"), , ПараметрыСохранения.КаталогФайлов);

КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаФайловСДиска

// Помещает файлы подтверждения банка по зарплатным проектам.
//
Процедура ЗагрузитьФайлыИзБанкаПродолжение(Подключено, ПараметрыЗагрузки) Экспорт
	
	Если Не Подключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		ОповещениеФайла = Новый ОписаниеОповещения("ЗагрузитьФайлИзБанкаЗавершение", ЭтотОбъект, ПараметрыЗагрузки);
		НачатьПомещениеФайла(ОповещениеФайла);
		Возврат;
	КонецЕсли;
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ЗагрузитьФайлыИзБанкаЗавершение", ЭтотОбъект, ПараметрыЗагрузки);
	
	// Вариант для установленного расширения для работы с файлами.
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.МножественныйВыбор = ПараметрыЗагрузки.МножественныйВыбор;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru='Выберите файлы подтверждения, полученные из банка';uk='Виберіть файли підтвердження, отримані з банку'");
	ДиалогОткрытияФайла.Фильтр = НСтр("ru='Файлы подтверждения из банка(*.xml)|*.xml|Все файлы (*.*)|*.*';uk='Файли підтвердження з банку(*..xml)|*.xml|Всі файли (*.*)|*.*'");
	ДиалогОткрытияФайла.Каталог = ПараметрыЗагрузки.КаталогФайлов;
	
	НачатьПомещениеФайлов(ОповещениеЗавершения, , ДиалогОткрытияФайла, Истина);
	
КонецПроцедуры

Процедура ЗагрузитьФайлИзБанкаЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ПараметрыЗагрузки) Экспорт
	
	Если Результат Тогда
		ПараметрыЗагрузки.ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес));
	КонецЕсли;
	
	ЗагрузитьФайлыИзБанкаЗавершение(ПараметрыЗагрузки.ПомещенныеФайлы, ПараметрыЗагрузки);
	
КонецПроцедуры

Процедура ЗагрузитьФайлыИзБанкаЗавершение(ПомещенныеФайлы, ПараметрыЗагрузки) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПомещенныеФайлы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Загрузка файлов не выполнена.';uk='Завантаження файлів не виконана.'"));
	КонецЕсли;
	
	Если ПараметрыЗагрузки.СтруктураОшибок.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗагрузки.ОповещениеЗавершения <> Неопределено Тогда
		ПараметрыЗагрузки.ПомещенныеФайлы = ПомещенныеФайлы;
		ВыполнитьОбработкуОповещения(ПараметрыЗагрузки.ОповещениеЗавершения, ПараметрыЗагрузки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьПодтвержденияБанкаЗавершение(СозданныеДокументы) Экспорт
	
	ПриЗагрузкеБылиОшибки = Ложь;
	ДанныеОповещения = Новый Структура();
	Для каждого СозданныйДокумент Из СозданныеДокументы Цикл
		
		Если СозданныйДокумент = Неопределено Тогда
			ПриЗагрузкеБылиОшибки = Истина;
			Продолжить;
		КонецЕсли;
		ДанныеОповещения.Вставить(ОбменСБанкамиПоЗарплатнымПроектамКлиентСервер.ПривестиСтрокуКИдентификатору(СозданныйДокумент.Ключ), ТипЗнч(СозданныйДокумент.Ключ));
		ДанныеОповещения.Вставить(ОбменСБанкамиПоЗарплатнымПроектамКлиентСервер.ПривестиСтрокуКИдентификатору(СозданныйДокумент.Значение), ТипЗнч(СозданныйДокумент.Значение));
		Если ТипЗнч(СозданныйДокумент.Ключ) = Тип("ДокументСсылка.ПодтверждениеОткрытияЛицевыхСчетовСотрудников") Тогда
			ДанныеОповещения.Вставить("ЗагруженоПодтверждениеОткрытияЛицевыхСчетов", Неопределено);
		ИначеЕсли ТипЗнч(СозданныйДокумент.Ключ) = Тип("ДокументСсылка.ПодтверждениеЗачисленияЗарплаты") Тогда
			ДанныеОповещения.Вставить("ЗагруженоПодтверждениеЗачисленияЗарплаты", Неопределено);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЗначениеОповещения Из ДанныеОповещения Цикл
		Если ЗначениеОповещения.Значение = Неопределено Тогда
			Оповестить(ЗначениеОповещения.Ключ);
		Иначе
			ОповеститьОбИзменении(ЗначениеОповещения.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ПриЗагрузкеБылиОшибки Тогда
		Состояние(НСтр("ru='При загрузке файлов подтверждений банка были ошибки';uk='При завантаженні файлів підтверджень банку були помилки'"));
	Иначе
		Состояние(НСтр("ru='Все файлы успешно загружены';uk='Всі файли успішно завантажено'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти