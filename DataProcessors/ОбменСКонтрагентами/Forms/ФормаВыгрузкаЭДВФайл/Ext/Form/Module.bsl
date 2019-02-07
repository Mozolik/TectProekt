﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Загружаем каталог.
	СтруктураКаталога = "";
	Если Параметры.Свойство("СтруктураКаталога", СтруктураКаталога) Тогда
		
		НастройкиОбмена = Новый Структура;
		НастройкиОбмена.Вставить("ПрофильНастроекЭДО",
			Новый Структура("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.БыстрыйОбмен));
		НастройкиОбмена.Вставить("Организация", СтруктураКаталога.Организация);
		НастройкиОбмена.Вставить("ИдентификаторОрганизации", ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(
			СтруктураКаталога.Организация, "Организация"));
		
		СтруктураВозврата = Неопределено;
		Если Не ЗначениеЗаполнено(СтруктураВозврата) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПолноеИмяФайла = СтруктураВозврата.ПолноеИмяФайла;
		НоваяСтрока.НаименованиеФайла = СтруктураВозврата.Наименование;
		
		Если СтруктураВозврата.Свойство("МассивФайлов") И СтруктураВозврата.МассивФайлов.Количество() > 0 Тогда
			АрхивДополнительныхФайлов = ОбменСКонтрагентамиСлужебный.АрхивДополнительныхФайлов(СтруктураВозврата.МассивФайлов);
			СтруктураВозврата.Вставить("Картинки", АрхивДополнительныхФайлов);
		КонецЕсли;
		
		ИзменитьВидимостьДоступностьПриСозданииНаСервере();
		
	КонецЕсли;
	
	// Загружаем документы.
	МассивСсылокНаОбъект = Новый Массив;
	Если Параметры.Свойство("СтруктураЭД", МассивСсылокНаОбъект) Тогда
		Если МассивСсылокНаОбъект.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
		ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Ложь);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ОбменСКонтрагентами.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания, АдресХранилища);
		
		Если АдресХранилища  = "" Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ЗагрузитьПодготовленныеДанныеЭД();
		
	КонецЕсли;
	
	СтруктураЭД= Неопределено;
	Если Параметры.Свойство("ВыгрузитьВФайл", СтруктураЭД) И ЗначениеЗаполнено(СтруктураЭД) Тогда
		
		СтруктураВозврата = Неопределено;
		
		Если Не СтруктураВозврата = Неопределено Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			НоваяСтрока.ПолноеИмяФайла = СтруктураВозврата.ПолноеИмяФайла;
			НоваяСтрока.НаименованиеФайла = СтруктураВозврата.Наименование;
			
			ИзменитьВидимостьДоступностьПриСозданииНаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(ТаблицаДанных) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатВыполненияЗадания) Тогда
		
		ПодключитьОбработчикОжидания("Подключаемый_ЗапуститьОбработчикОжидания", 1, Истина);
		
	КонецЕсли;
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыгрузкиПриИзменении(Элемент)
	
	ИзменитьСпособВыгрузки();
	ИзменитьВидимостьДоступность();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("АдресХранилища", СтрокаДанных.АдресХранилища);
			СтруктураПараметров.Вставить("ФайлАрхива", Истина);
			СтруктураПараметров.Вставить("НаименованиеФайла", СтрокаДанных.НаименованиеФайла);
			СтруктураПараметров.Вставить("НаправлениеЭД", СтрокаДанных.НаправлениеЭД);
			СтруктураПараметров.Вставить("Контрагент", СтрокаДанных.Контрагент);
			СтруктураПараметров.Вставить("УникальныйИдентификатор", СтрокаДанных.УникальныйИдентификатор);
			СтруктураПараметров.Вставить("ВладелецЭД", СтрокаДанных.ВладелецЭД);
			
			МассивСтруктур.Добавить(СтруктураПараметров);
		КонецЦикла;
		ФормаПросмотраЭД = ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ФормаСпискаВыгружаемыхДокументов",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ВывестиЭДНаПросмотр(ТаблицаДанных[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	ОчиститьСообщения();
	
	ТекстСообщения = "";
	Отказ = ВыгрузитьЭД(ТекстСообщения);
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	ВыгрузкаВЭП = (СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту"));
	Элементы.СтраницаПисьмо.Доступность = ВыгрузкаВЭП ИЛИ (Элементы.Страницы.ТекущаяСтраница = Элементы.НетДоступа);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Текст = НСтр("ru='Выгрузка документов в файл';uk='Вивантаження документів у файл'");
	ТекстГиперссылки = НСтр("ru='Документы не найдены.';uk='Документи не знайдені.'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru='Открыть список электронных документов (%1)';uk='Відкрити список електронних документів (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = НСтр("ru='Электронный документ: %1';uk='Електронний документ: %1'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных[0].НаименованиеФайла);
	КонецЕсли;
	Элементы.ПредварительныйПросмотрДокумента.Заголовок = ТекстГиперссылки;
	Заголовок = Текст;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		СпособВыгрузки = "ЧерезКаталог";
		Элементы.Страницы.ТекущаяСтраница = Элементы.НетДоступа;
		Элементы.СпособВыгрузки.Доступность = Ложь;
	КонецЕсли;
	
	Если СпособВыгрузки <> Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
		СпособВыгрузки = Перечисления.СпособыОбменаЭД.ЧерезКаталог;
	ИначеЕсли Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		СпособВыгрузки = "ЧерезКаталог";
		Элементы.Страницы.ТекущаяСтраница = Элементы.НетДоступа;
		Элементы.СпособВыгрузки.Доступность = Ложь;
	Иначе
		ИзменитьСпособВыгрузки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресХранилища");
	СтруктураПараметров.Вставить("ФайлАрхива", Истина);
	СтруктураПараметров.Вставить("НаименованиеФайла");
	СтруктураПараметров.Вставить("НаправлениеЭД");
	СтруктураПараметров.Вставить("Контрагент");
	СтруктураПараметров.Вставить("УникальныйИдентификатор");
	СтруктураПараметров.Вставить("ВладелецЭД");

	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
	ФормаПросмотраЭД = ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ФормаЗагрузкиПросмотраЭД",
		Новый Структура("СтруктураЭД", СтруктураПараметров), ЭтотОбъект, СтруктураПараметров.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУчетнуюЗапись()
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки";
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Количество() = 1 Тогда
		Результат.Следующий();
		Возврат Результат.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();

КонецФункции

&НаКлиенте
Функция ВыгрузитьЭД(ТекстСообщения)
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(СпособВыгрузки) Тогда
		ТекстСообщения = НСтр("ru='Необходимо указать способ выгрузки.';uk='Необхідно зазначити спосіб вивантаження.'");
		Отказ = Истина;
	КонецЕсли;
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту")
		И НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru='Необходимо указать учетную запись.';uk='Необхідно вказати обліковий запис.'");
		Отказ = Истина;
	КонецЕсли;
	Если НЕ Отказ Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СпособВыгрузки",  СпособВыгрузки);
		СтруктураПараметров.Вставить("ПутьККаталогу");
		СтруктураПараметров.Вставить("УчетнаяЗапись",   УчетнаяЗапись);
		СтруктураПараметров.Вставить("АдресПолучателя", АдресПолучателя);
		
		МассивСтруктур = Новый Массив;
		
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураОбмена = Новый Структура;

			СтруктураОбмена.Вставить("НаименованиеФайла", СтрокаДанных.НаименованиеФайла);
			СтруктураОбмена.Вставить("НаправлениеЭД",     СтрокаДанных.НаправлениеЭД);
			СтруктураОбмена.Вставить("Контрагент",        СтрокаДанных.Контрагент);
			СтруктураОбмена.Вставить("УникальныйИдентификатор", СтрокаДанных.УникальныйИдентификатор);
			СтруктураОбмена.Вставить("ВладелецЭД",        СтрокаДанных.ВладелецЭД);
			СтруктураОбмена.Вставить("АдресХранилища",    СтрокаДанных.АдресХранилища);
			
			МассивСтруктур.Добавить(СтруктураОбмена);
		КонецЦикла;
		
		БыстрыйОбменВыгрузитьЭД(МассивСтруктур, СтруктураПараметров);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаСервере
Процедура ИзменитьСпособВыгрузки()
	
	Если СпособВыгрузки = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
		Если ЗначениеЗаполнено(Контрагент) И Не ЗначениеЗаполнено(АдресПолучателя) Тогда
			АдресПолучателя = ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Контрагент);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
			УчетнаяЗапись = ПолучитьУчетнуюЗапись();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйОбменВыгрузитьЭД(МассивСтруктурОбмена, СтруктураПараметров)
	
	Перем ПутьККаталогу;
	
	Если СтруктураПараметров.СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезКаталог") Тогда
		МассивФайлов = Новый Массив;
		Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
				СтруктураОбмена.НаименованиеФайла + ".zip", СтруктураОбмена.АдресХранилища);
			МассивФайлов.Добавить(ОписаниеФайла);
		КонецЦикла;
		Если МассивФайлов.Количество() Тогда
			ПустойОбработчик = Новый ОписаниеОповещения("ПустойОбработчик", ОбменСКонтрагентамиСлужебныйКлиент);
			НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
		КонецЕсли;
	Иначе
		ПараметрыФормы = Новый Структура;
		Если МассивСтруктурОбмена.Количество() > 1 Тогда
			ТемаПисьма = НСтр("ru='Пакеты электронных документов';uk='Пакети електронних документів'");
		Иначе
			ТемаПисьма = НСтр("ru='Пакет электронного документа:';uk='Пакет електронного документа:'") + " " + МассивСтруктурОбмена[0].НаименованиеФайла;
		КонецЕсли;
		ПараметрыФормы.Вставить("Тема", ТемаПисьма);
		ПараметрыФормы.Вставить("УчетнаяЗапись", СтруктураПараметров.УчетнаяЗапись);
		ПараметрыФормы.Вставить("Кому", СтруктураПараметров.АдресПолучателя);
		Вложения = Новый СписокЗначений;
		Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
			Вложения.Добавить(СтруктураОбмена.АдресХранилища, СтруктураОбмена.НаименованиеФайла + ".zip");
		КонецЦикла;
		ПараметрыФормы.Вставить("Вложения", Вложения);
		Форма = ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД()
	
	ТаблицаЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭД) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из ТаблицаЭД Цикл
		Строка.АдресХранилища = ПоместитьВоВременноеХранилище(Строка.ДвоичныеДанныеПакета, УникальныйИдентификатор);
	КонецЦикла;
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияДляЭД()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанныеЭД();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияДляЭД",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапуститьОбработчикОжидания()
	
	Если НЕ РезультатВыполненияЗадания.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияДляЭД", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания);
		
		ИдентификаторЗадания = РезультатВыполненияЗадания.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполненияЗадания.АдресХранилища;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
