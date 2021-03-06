﻿
#Область ПрограммныйИнтерфейс

// Возвращает список доступных типов оборудования.
//
Функция ПолучитьДоступныеТипыОборудования() Экспорт
	
	СписокОборудования = Новый Массив;
	
	// Сканеры штрихкода
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
	// Конец Сканеры штрихкода
	
	// Считыватели магнитных карт
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт);
	// Конец Считыватели магнитных карт.
	
	// Фискальные регистраторы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор);
	// Конец Фискальные регистраторы.
	
	// Принтеры чеков
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков);
	// Конец принтеры чеков.
	
	// Дисплеи покупателя
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя);
	// Конец Дисплеи покупателя

	// Терминалы сбора данных
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ТерминалСбораДанных);
	// Конец Терминалы сбора данных.

	// Эквайринговые терминалы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал);
    // Конец Эквайринговые терминалы.
	
	// Электронные весы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы);
	// Конец Электронные весы
	
	// Весы с печатью этикеток
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
	// Конец Весы с печатью этикеток.
	
	// ККМ offline
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline") Тогда
		СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККМOffline);
	КонецЕсли;
	// Конец ККМ offline
	
	// Принтер этикеток
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток);
	// Конец Принтер этикеток
	
	
	Возврат СписокОборудования;
	
КонецФункции

// Возвращает флаг возможности добавления новых драйверов в справочник драйверов.
//
Функция ВозможностьДобавленияНовыхДрайверов() Экспорт
	
	МожноДобавлятьНовыеДрайвера = Истина;
	Возврат МожноДобавлятьНовыеДрайвера;
	
КонецФункции

// Возвращает признак возможности обращения к разделенным данным из текущего сеанса.
// В случае вызова в неразделенной конфигурации возвращает Истина.
//
// Возвращаемое значение:
// Булево.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.РазделениеВключено() 
		И НЕ ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей()
		ИЛИ НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
КонецФункции

// Обновить поставляемые драйверы в составе конфигурации.
//                                   
Процедура ОбновитьПоставляемыеДрайвера() Экспорт
	
	// Сканеры штрихкода
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода, "AddIn.ScancodeScanner", "ДрайверСканкодСканерШтрихкода", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода, "AddIn.Scaner45", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода, "AddIn.Scanner", "Драйвер1ССканерШтрихкода", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкодаNative, "AddIn.InputDevice", "Драйвер1СУстройстваВводаNative", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонСканерыШтрихкода, "AddIn.ProtonScanner", "ДрайверГексагонСканерШтрихкода", Ложь);
	// Конец Сканеры штрихкода
	
	// Считыватели магнитных карт
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт, "AddIn.Scanner", "Драйвер1ССканерШтрихкода", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКартNative, "AddIn.InputDevice", "Драйвер1СУстройстваВводаNative", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСчитывателиМагнитныхКарт, "AddIn.Scaner45", , Истина);
	// Конец Считыватели магнитных карт.
	
	// Фискальные регистраторы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СФискальныйРегистраторЭмулятор, "AddIn.EmulatorFP1C", "Драйвер1СФискальныйРегистратор", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАртСофтФискальныйРегистратор, "ArtSoft.FiscalPrinter", "ДрайверАртСофтФискальныйРегистратор", Истина);
	// Конец Фискальные регистраторы.
	
	// Принтеры чеков
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СПринтерЧеков, "AddIn.ReceiptPrinterNative", "Драйвер1СПринтерЧеков", Ложь);
	// Конец Принтеры чеков.
	
	// Дисплеи покупателя
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолДисплеиПокупателя, "AddIn.Line45", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСДисплеиПокупателя, "AddIn.VFCD220E", "ДрайверККСДисплеиПокупателя", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодДисплеиПокупателя, "AddIn.1CDSPPromag", "ДрайверСканкодДисплеиПокупателя", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМДисплеиПокупателя, "AddIn.LineDisplay", "ДрайверШтрихМДисплеиПокупателя", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКристаллСервисДисплеиПокупателяVikiVision, "AddIn.VikiVision", "ДрайверКристаллСервисДисплеиПокупателяVikiVision", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СДисплейПокупателя, "AddIn.CustomerDisplay1C", "Драйвер1СДисплейПокупателя", Ложь);
	// Конец Дисплеи покупателя
	
	// Терминалы сбора данных
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных, "AddIn.PDX45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонТерминалыСбораДанных, "AddIn.ProtonTSD", "ДрайверГексагонТСД", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных, "AddIn.CipherLab", "ДрайверСканкодТСДCipherLab", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных, "AddIn.iPOSoft_DT", "ДрайверСканситиТСДCipherLab", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКлеверенсТерминалыСбораДанных, "AddIn.Cleverence.TO_TSD", "ДрайверКлеверенсТСД", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных, "AddIn.Terminals", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанныхMobileLogistics, "AddIn.PDX1C_Int", "ДрайверАТОЛТСДMobileLogistics", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанныхNative, "AddIn.CipherLab8", "ДрайверСканкодТерминалыСбораДанныхNative", Ложь);
	// Конец Терминалы сбора данных.
	
	// Эквайринговые терминалы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикПриватбанкЭквайринговыеТерминалы, "AddIn.a_ingenicopb1c82", "ДрайверПриватбанкЭквайринговыеТерминалы", Ложь);
	// Конец Эквайринговые терминалы.
	                           
	// Электронные весы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы, "AddIn.Scale45", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМЭлектронныеВесы, "AddIn.Scale45", "ДрайверШтрихМЭлектронныеВесы", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикCASЭлектронныеВесы, "AddIn.CasCentreSimpleScale", "ДрайверCASЭлектронныеВесы", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы8X, "AddIn.ATOL_Scale_1CInt", "ДрайверАТОЛЭлектронныеВесы8X", Ложь);
	// Конец Электронные весы
	
	// Весы с печатью этикеток
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикACOMВесыСПечатьюЭтикеток);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМВесыСПечатьюЭтикеток, "AddIn.DrvLP", "ДрайверШтрихМВесыCПечатьюЭтикеток", Истина);    
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикScaleCASВесыСПечатьюЭтикеток, "CL5000J.WrapperFor1C82|AddIn.CL5000JFor1C82", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикCASВесыСПечатьюЭтикеток, "AddIn.CasCentrePrintingScale", "ДрайверCASВесыСПечатьюЭтикеток", Ложь); 
	// Конец Весы с печатью этикеток.
	
	
	// Принтеры этикеток
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонПринтераЭтикеток, "AddIn.HexagonLabelPrinterDriver", "ДрайверГексагонПринтераЭтикеток", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиПринтераЭтикеток, "AddIn.ScanCityTSC1C", "ДрайверСканситиПринтераЭтикеток", Ложь);
	// Конец Принтеры этикеток.
	

КонецПроцедуры

// Обновление поля "ДрайверОборудования" в справочнике подключаемого оборудования.
//
Процедура ОбновитьДрайверыВСправочникеПодключаемогоОборудования() Экспорт
	      
	НеобходимоОбновлениеДрайвера = Ложь;
	ОбновлениеДрайвераВыполнено  = Ложь;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |ПодключаемоеОборудование.Ссылка,
						  |ПодключаемоеОборудование.УдалитьОбработчикДрайвера
						  |ИЗ
						  |Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование");
	
	Выборка = Запрос.Выполнить().Выбрать();
				   
	Пока Выборка.Следующий() Цикл
		
		Драйвер = Неопределено;
		
		Если Выборка.УдалитьОбработчикДрайвера = Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода
			Или Выборка.УдалитьОбработчикДрайвера = Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт Тогда
				НеобходимоОбновлениеДрайвера = Истина;
		КонецЕсли;
		
		ВремИмяЭлемента = МенеджерОборудованияВызовСервера.ПолучитьПараметрыДрайвераПоОбработчику(Строка(Выборка.УдалитьОбработчикДрайвера));
		
		Если ВремИмяЭлемента.Свойство("Имя") Тогда 
			ВремИмяДрайвера = СтрЗаменить(ВремИмяЭлемента.Имя, "Обработчик", "Драйвер");
			Попытка
				Драйвер = МенеджерОборудованияВызовСервера.ПредопределенныйЭлемент("Справочник.ДрайверыОборудования." + ВремИмяДрайвера);
			Исключение
				Продолжить;
			КонецПопытки;
		КонецЕсли;
		
		Если Драйвер <> Неопределено Тогда
			ПодключаемоеОборудование = Выборка.Ссылка.ПолучитьОбъект();
			// Необходимо обновление драйвера "1С:Сканер штрихкода".
			Если НеобходимоОбновлениеДрайвера И Не ОбновлениеДрайвераВыполнено Тогда
				ПодключаемоеОборудование.ТребуетсяУстановка = Истина;
				ОбновлениеДрайвераВыполнено = Истина;
			КонецЕсли;
			ПодключаемоеОборудование.ДрайверОборудования = Драйвер;
			ПодключаемоеОборудование.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обновление библиотеки в целевой конфигурации.
//                                   
Процедура ОбновлениеБиблиотеки() Экспорт
	
	ОбновитьПоставляемыеДрайвера();
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПриложения

// Устанавливает размер шрифта заголовков групп формы для их корректного отображения в интерфейсе 8.2.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма для изменения шрифта заголовков групп;
//
Процедура УстановитьОтображениеЗаголовковГрупп(Форма) Экспорт
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ЖирныйШрифт = Новый Шрифт(,, Истина);
		Для Каждого Элемент Из Форма.Элементы Цикл 
			Если Тип(Элемент) = Тип("ГруппаФормы")
				И Элемент.Вид = ВидГруппыФормы.ОбычнаяГруппа
				И Элемент.ОтображатьЗаголовок 
				И (Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение
				Или Элемент.Отображение = ОтображениеОбычнойГруппы.Нет) Тогда 
					Элемент.ШрифтЗаголовка = ЖирныйШрифт;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОборудованиеOffline

// Функция возвращает префикс весового товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток.
Функция ПолучитьПрефиксВесовогоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Префикс = Неопределено;
	Возврат Префикс;
	
КонецФункции

// Функция возвращает префикс штучного товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток.
Функция ПолучитьПрефиксШтучногоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Префикс = Неопределено;
	Возврат Префикс;
	
КонецФункции

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриСозданииНаСервере".
//
Процедура ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт
	
	// Доступ к узлу есть только для соответствующего оборудования
	Если Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline
		ИЛИ Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Истина;
		ПараметрыВыбораПравилаОбмена = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьПараметрыВыбораПравилаОбмена(Объект);
		Если ЗначениеЗаполнено(ПараметрыВыбораПравилаОбмена) Тогда
			ЭтаФорма.Элементы.ПравилоОбмена.ПараметрыВыбора = ПараметрыВыбораПравилаОбмена;
		КонецЕсли;
	Иначе
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере".
//
Процедура ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере".
//
Процедура ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере".
//
Процедура ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтаФорма, Отказ, ПроверяемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти

#Область Прочее

// Функция создает узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него
// Применяется перед записью элемента справочника Подключаемое оборудование
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект) Экспорт
	
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	
КонецФункции

// Функция возвращает параметры выбора для поля ввода ПравилоОбмена.
//
Функция ПолучитьПараметрыВыбораПравилаОбмена(ПодключаемоеОборудованиеОбъект) Экспорт
	
	Если ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
	ИначеЕсли ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМOffline);
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(НовыйПараметр);
	Возврат Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецФункции

#КонецОбласти