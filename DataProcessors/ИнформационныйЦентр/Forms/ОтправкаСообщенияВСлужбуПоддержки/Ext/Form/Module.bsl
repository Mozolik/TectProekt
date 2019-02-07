﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	ОбластьДанных = ТехнологияСервисаИнтеграцияСБСП.ЗначениеРазделителяСеанса();
	
	СоздаватьОбращение = Параметры.СоздаватьОбращение;
	ИдентификаторОбращения = Параметры.ИдентификаторОбращения;
	
	ЗаполнитьШаблономСодержание();
	
	МаксимальныйРазмерФайлов = ИнформационныйЦентрСервер.МаксимальныйРазмерВложенийДляОтправкиСообщенияВПоддержкуСервиса();
	
	АдресДляОтвета = ИнформационныйЦентрСервер.ОпределитьАдресЭлектроннойПочтыПользователя();
	Если ПустаяСтрока(АдресДляОтвета) Тогда 
		Элементы.АдресОтвета.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьКурсорВШаблонеТекста();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура УдалитьФайл(Элемент)
	
	ИмяКнопки = Элемент.Имя;
	УдалитьФайлСервер(ИмяКнопки);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	Если Элементы.АдресОтвета.Видимость Тогда 
		Если ПустаяСтрока(АдресДляОтвета) Тогда 
			ВызватьИсключение НСтр("ru='Необходимо ввести адрес электронной почты для ответа';uk='Потрібно ввести адресу електронної пошти для відповіді'");
		КонецЕсли;
		Результат = РазобратьСтрокуСПочтовымиАдресами(АдресДляОтвета);
		Если Результат.Количество() = 0 Тогда 
			Оповещение = Новый ОписаниеОповещения("ОтправлениеСообщенияВСлужбуПоддержки", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, НСтр("ru='Адрес электронной почты возможно введен неверно. Отправить сообщение?';uk='Адресу електронної пошти можливо введено невірно. Надіслати повідомлення?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОтправитьСообщениеСервер();
	ПоказатьОповещениеПользователя(НСтр("ru='Сообщение в службу поддержки отправлено.';uk='Повідомлення до служби підтримки відправлено.'"));
	Оповестить("ОтправкаСообщенияВСлужбуПоддержки");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайл(Команда)
	
#Если ВебКлиент Тогда
	ОписаниеОповещения = Новый ОписаниеОповещения("ПрикрепитьФайлОповещение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
#Иначе
	ДобавитьВнешниеФайлы(Истина);
#КонецЕсли
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УдалитьФайлСервер(ИмяКнопкиУдаления)
	
	Фильтр = Новый Структура("ИмяКнопкиУдаления", ИмяКнопкиУдаления);
	НайденныеСтроки = ВыбираемыеФайлы.НайтиСтроки(Фильтр);
	Если НайденныеСтроки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки.Получить(0);
	ИндексИмени = ПолучитьИндексЭлементаФормы(ИмяКнопкиУдаления);
	УдалитьВсеПодчиненныеЭлементы(ИндексИмени);
	УдалитьИзВременногоХранилища(НайденнаяСтрока.АдресХранилища);
	
	Индекс = ВыбираемыеФайлы.Индекс(НайденнаяСтрока);
	ВыбираемыеФайлы.Удалить(Индекс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлениеСообщенияВСлужбуПоддержки(Результат) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОтправитьСообщениеСервер();
	ПоказатьОповещениеПользователя(НСтр("ru='Сообщение в службу поддержки отправлено.';uk='Повідомлення до служби підтримки відправлено.'"));
	Оповестить("ОтправкаСообщенияВСлужбуПоддержки");
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблономСодержание()
	
	Текст = ИнформационныйЦентрСервер.ШаблонТекстаВТехПоддержку();
	СтрокаПозицияКурсора = НСтр("ru='ПозицияКурсора';uk='ПозицияКурсора'");
	ПозицияКурсора = СтрНайти(Текст, СтрокаПозицияКурсора)- 9;
	Текст = СтрЗаменить(Текст, СтрокаПозицияКурсора, "");
	Содержание.УстановитьHTML(Текст, Новый Структура);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВсеПодчиненныеЭлементы(ИндексЭлемента)
	
	НайденнаяЭлемент = Элементы.Найти("ГруппаФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
	НайденнаяЭлемент = Элементы.Найти("ТекстИмениФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
	НайденнаяЭлемент = Элементы.Найти("КнопкаУдаленияФайла" + Строка(ИндексЭлемента));
	Если НайденнаяЭлемент <> Неопределено Тогда 
		Элементы.Удалить(НайденнаяЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИндексЭлементаФормы(ИмяЭлемента)
	
	НачалоПозиции = СтрДлина("КнопкаУдаленияФайла") + 1;
	Возврат Число(Сред(ИмяЭлемента, НачалоПозиции));
	
КонецФункции

&НаКлиенте
Процедура ПрикрепитьФайлОповещение(Подключено, Контекст) Экспорт
	
	ДобавитьВнешниеФайлы(Подключено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВнешниеФайлы(РасширениеПодключено)
	
	Если РасширениеПодключено Тогда 
		ПоместитьФайлыСРасширением();
	Иначе
		ПоместитьФайлыБезРасширения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлыСРасширением()
	
	// Вызов диалога выбора файлов.
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите файл';uk='Виберіть файл'");
	Диалог.МножественныйВыбор = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоместитьФайлСРасширениемОповещение", ЭтотОбъект);
	НачатьПомещениеФайлов(ОписаниеОповещения,, Диалог, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлСРасширениемОповещение(ВыбранныеФайлы, ОбработчикЗавершения) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПолноеИмяФайла = ВыбранныеФайлы.Получить(0).Имя;
	АдресХранилища = ВыбранныеФайлы.Получить(0).Хранение;
	
	// Проверка на корректность общего размера файлов.
	Файл = Новый Файл;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	ДополнительныеПараметры.Вставить("АдресХранилища", АдресХранилища);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьИнициализациюОповещение", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьИнициализацию(ОписаниеОповещения, ПолноеИмяФайла);
	
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьИнициализациюОповещение(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоместитьФайлСРасширениемОповещениеРазмерОповещение", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПолучениеРазмера(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлСРасширениемОповещениеРазмерОповещение(Размер, ДополнительныеПараметры) Экспорт
	
	Если Размер = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ОбщийРазмерФайловОптимален(Размер) Тогда 
		
		ТекстПредупреждения = НСтр("ru='Не удалось добавить файл. Размер выбранных файлов превышает предел в %1 Мб';uk='Не вдалося додати файл. Розмір вибраних файлів перевищує межу у %1 Мб'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, МаксимальныйРазмерФайлов);
		ОчиститьСообщения();
		ПоказатьСообщениеПользователю(ТекстПредупреждения);
		
	КонецЕсли;
	
	Состояние(НСтр("ru='Файл добавляется к сообщению.';uk='Файл додається до повідомлення.'"));

	// Добавить файлы в таблицу.
	ИмяИРасширениеФайла = ПолучитьИмяИРасширениеФайла(ДополнительныеПараметры.ПолноеИмяФайла);
	ПоместитьФайлыБезРасширенияНаСервере(ДополнительныеПараметры.АдресХранилища, ИмяИРасширениеФайла);
	
	Состояние();
	
	СоздатьЭлементыФормыДляВложенногоФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьФайлыБезРасширения()
	
	ПослеПомещенияФайла = Новый ОписаниеОповещения(
		"ПослеПомещенияФайлов", ЭтотОбъект);
	
	НачатьПомещениеФайла(
		ПослеПомещенияФайла,
		,
		,
		Истина,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлов(Результат, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		ИмяИРасширениеФайла = ПолучитьИмяИРасширениеФайла(ВыбранноеИмяФайла);
		ПоместитьФайлыБезРасширенияНаСервере(АдресХранилища, ИмяИРасширениеФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяИРасширениеФайла(Знач ВыбранноеИмяФайла)
	
	Результат = ТехнологияСервисаИнтеграцияСБСП.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);
	
	ИмяИРасширениеФайла = Новый Структура;
	ИмяИРасширениеФайла.Вставить("Имя", Результат.ИмяБезРасширения);
	ИмяИРасширениеФайла.Вставить("Расширение", Результат.Расширение);
	
	Возврат ИмяИРасширениеФайла;
	
КонецФункции

&НаСервере
Процедура ПоместитьФайлыБезРасширенияНаСервере(АдресХранилища, ИмяИРасширениеФайла)
	
	НовыйФайл = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// Проверка на корректность общего размера файлов.
	РазмерФайла = НовыйФайл.Размер();
	Если Не ОбщийРазмерФайловОптимален(РазмерФайла) Тогда 
		ТекстПредупреждения = НСтр("ru='Размер выбранных файлов превышает предел в %1 Мб';uk='Розмір вибраних файлів перевищує межу у %1 Мб'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, МаксимальныйРазмерФайлов);
		ПоказатьСообщениеПользователю(ТекстПредупреждения);
		УдалитьИзВременногоХранилища(АдресХранилища);
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = ВыбираемыеФайлы.Добавить();
	СтрокаТаблицы.ИмяФайла = ИмяИРасширениеФайла.Имя;
	СтрокаТаблицы.Расширение = ИмяИРасширениеФайла.Расширение;
	СтрокаТаблицы.Размер = РазмерФайла;
	СтрокаТаблицы.АдресХранилища = АдресХранилища;
	
	СоздатьЭлементыФормыДляВложенногоФайла();
	
КонецПроцедуры

&НаСервере
Функция ОбщийРазмерФайловОптимален(РазмерФайла)
	
	Размер = РазмерФайла / 1024;
	
	// Подсчет общего размера приложенных к письму файлов (с установленной пометкой).
	Для Итерация = 0 по ВыбираемыеФайлы.Количество() - 1 Цикл
		Размер = Размер + (ВыбираемыеФайлы.Получить(Итерация).Размер / 1024);
	КонецЦикла;
	
	РазмерВМегабайтах = Размер / 1024;
	
	Если РазмерВМегабайтах > МаксимальныйРазмерФайлов Тогда 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОтправитьСообщениеСервер()
	
	ТекстHTML = "";
	ВложенияHTML = Новый Структура;
	Содержание.ПолучитьHTML(ТекстHTML, ВложенияHTML);
	ТекстСообщения = Содержание.ПолучитьТекст();
	
	Если ПустаяСтрока(ТекстСообщения) Тогда 
		ВызватьИсключение НСтр("ru='Текст сообщения не может быть пустым.';uk='Текст повідомлення не може бути порожнім.'");
	КонецЕсли;
	
	Если ПустаяСтрока(Тема) Тогда 
		ТемаСообщения = ОпределитьТему();
	Иначе
		ТемаСообщения = Тема;
	КонецЕсли;
	
	Попытка
		
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
		
		СписокФайловXDTO = СформироватьСписокФайловXDTO(WSПрокси.ФабрикаXDTO);
		
		WSПрокси.addComments(Строка(ИдентификаторПользователя), Строка(ИдентификаторОбращения), ТемаСообщения, ТекстHTML, СоздаватьОбращение,  СписокФайловXDTO, ОбластьДанных, АдресДляОтвета);
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,
		                         ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		ВызватьИсключение ТекстВывода;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьТему()
	
	Если Не ПустаяСтрока(Тема) Тогда 
		Возврат Тема;
	КонецЕсли;
	
	ТекстСообщения = Содержание.ПолучитьТекст();
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "Здравствуйте!", "");
	ТекстСообщения = Лев(ТекстСообщения, 500);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, Символы.ПС, " ");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "  ", " ");
	
	Возврат СокрЛП(ТекстСообщения);
	
КонецФункции

&НаСервере
Функция СформироватьСписокФайловXDTO(Фабрика)
	
	ТипСпискаФайлов = Фабрика.Тип("http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1", "ListFile");
	СписокФайлов = Фабрика.Создать(ТипСпискаФайлов);
	
	Для Каждого ТекущийФайл Из ВыбираемыеФайлы Цикл 
		
		ТипФайла = Фабрика.Тип("http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1", "File");
		ФайлОбъект = Фабрика.Создать(ТипФайла);
		ФайлОбъект.Name = ТекущийФайл.ИмяФайла;
		ФайлОбъект.Data = ПолучитьИзВременногоХранилища(ТекущийФайл.АдресХранилища);
		ФайлОбъект.Extension = ТекущийФайл.Расширение;
		ФайлОбъект.Size = ТекущийФайл.Размер;
		
		СписокФайлов.Files.Добавить(ФайлОбъект);
		
	КонецЦикла;
	
	Возврат СписокФайлов;
	
КонецФункции

&НаКлиенте
Процедура УстановитьКурсорВШаблонеТекста()
	
	ПодключитьОбработчикОжидания("ОбработчикУстановитьКурсорВШаблонеТекста", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикУстановитьКурсорВШаблонеТекста()
	
	ТекущийЭлемент = Элементы.Содержание;
	Закладка = Содержание.ПолучитьЗакладкуПоПозиции(ПозицияКурсора);
	Элементы.Содержание.УстановитьГраницыВыделения(Закладка, Закладка);
	
КонецПроцедуры

&НаСервере
Функция СоздатьЭлементыФормыДляВложенногоФайла()
	
	Для Каждого ВыбираемыйФайл Из ВыбираемыеФайлы Цикл
		
		Если Не ПустаяСтрока(ВыбираемыйФайл.ИмяКнопкиУдаления) Тогда 
			Продолжить;
		КонецЕсли;
		
		ПредставлениеФайла = ВыбираемыйФайл.ИмяФайла + ВыбираемыйФайл.Расширение + " (" + Окр(ВыбираемыйФайл.Размер / 1024, 2) + НСтр("ru=' Кб';uk=' Кб'") +")";
		
		Индекс = ВыбираемыйФайл.ПолучитьИдентификатор();
		
		ГруппаФайла = Элементы.Добавить("ГруппаФайла" + Строка(Индекс), Тип("ГруппаФормы"), Элементы.ГруппаПрикрепленныхФайлов);
		ГруппаФайла.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаФайла.ОтображатьЗаголовок = Ложь;
		ГруппаФайла.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаФайла.Отображение = ОтображениеОбычнойГруппы.Нет;
		
		ТекстИмениФайла = Элементы.Добавить("ТекстИмениФайла" + Строка(Индекс), Тип("ДекорацияФормы"), ГруппаФайла);
		ТекстИмениФайла.Вид = ВидДекорацииФормы.Надпись;
		ТекстИмениФайла.Заголовок = ПредставлениеФайла;
		
		КнопкаУдаленияФайла = Элементы.Добавить("КнопкаУдаленияФайла" + Строка(Индекс), Тип("ДекорацияФормы"), ГруппаФайла);
		КнопкаУдаленияФайла.Вид = ВидДекорацииФормы.Картинка;
		КнопкаУдаленияФайла.Картинка = БиблиотекаКартинок.УдалитьНепосредственно;
		КнопкаУдаленияФайла.Подсказка = НСтр("ru='Удалить файл';uk='Вилучити файл'");
		КнопкаУдаленияФайла.Ширина = 2;
		КнопкаУдаленияФайла.Высота = 1;
		КнопкаУдаленияФайла.РазмерКартинки = РазмерКартинки.Растянуть;
		КнопкаУдаленияФайла.Гиперссылка = Истина;
		КнопкаУдаленияФайла.УстановитьДействие("Нажатие", "УдалитьФайл");
		
		ВыбираемыйФайл.ИмяКнопкиУдаления = КнопкаУдаленияФайла.Имя;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПоказатьСообщениеПользователю(Текст)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
	
КонецФункции

&НаСервере
Функция РазобратьСтрокуСПочтовымиАдресами(АдресДляОтвета)
	
	Возврат ТехнологияСервисаИнтеграцияСБСП.РазобратьСтрокуСПочтовымиАдресами(АдресДляОтвета, Ложь);
	
КонецФункции