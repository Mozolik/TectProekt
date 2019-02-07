﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеПараметров = Параметры.ПараметрыОборудования;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	ПоставляетсяДистрибутивом = ДрайверОборудования.ПоставляетсяДистрибутивом;
	ВерсияДрайвераВМакете     = ДрайверОборудования.ВерсияДрайвера;
	СчитывательМагнитныхКарт  = ДрайверОборудования.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	
	Если СчитывательМагнитныхКарт Тогда
		
		времПараметрыДорожек = Неопределено;
		
		Если НЕ ЗначениеПараметров.Свойство("ПараметрыДорожек", времПараметрыДорожек) Тогда
			времПараметрыДорожек = Новый Массив();
			Для Индекс = 1 По 3 Цикл
				НоваяСтрока = Новый Структура();
				НоваяСтрока.Вставить("НомерДорожки", Индекс);
				НоваяСтрока.Вставить("Префикс"     , 0);
				НоваяСтрока.Вставить("Суффикс"     , ?(Индекс = 2, 13, 0));
				НоваяСтрока.Вставить("Использовать", ?(Индекс = 2, Истина, Ложь));
				времПараметрыДорожек.Добавить(НоваяСтрока);
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого СтрокаДорожки Из времПараметрыДорожек Цикл
			НоваяСтрока = ПараметрыДорожек.Добавить();
			НоваяСтрока.НомерДорожки = СтрокаДорожки.НомерДорожки;
			НоваяСтрока.Префикс      = СтрокаДорожки.Префикс;
			НоваяСтрока.Суффикс      = СтрокаДорожки.Суффикс;
			НоваяСтрока.Использовать = СтрокаДорожки.Использовать;
		КонецЦикла;
		
	КонецЕсли;
	
	Заголовок = НСтр("ru='Оборудование:';uk='Устаткування:'") + Символы.НПП  + Строка(Идентификатор);

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	ТекущееРабочееМесто = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.ТестУстройства.Видимость         = ТекущееРабочееМесто;
	Элементы.УстановитьДрайвер.Видимость      = ТекущееРабочееМесто;
	Элементы.ДополнительныеДействия.Видимость = ТекущееРабочееМесто;
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформациюОДрайвере(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	ВремНастройки = ПолучитьНастройки();
	
	Если СчитывательМагнитныхКарт Тогда
		
		НастроеноДорожек = 0;
		ДорожкаСПустымСуффиксом = Ложь;
		времПараметрыДорожек = Новый Массив();
		ПрефиксДрайвера = 0;
		СуффиксДрайвера = 0;

		Для Индекс = 1 По 3 Цикл
			Если ПараметрыДорожек[3 - Индекс].Использовать Тогда
				ДорожкаСПустымСуффиксом =
				    ДорожкаСПустымСуффиксом ИЛИ (ПараметрыДорожек[3 - Индекс].Суффикс = 0);
				НастроеноДорожек = НастроеноДорожек + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ДорожкаСПустымСуффиксом Тогда
			
			Для Индекс = 1 По 3 Цикл
				НоваяСтрока = Новый Структура();
				НоваяСтрока.Вставить("НомерДорожки", ПараметрыДорожек[Индекс - 1].НомерДорожки);
				НоваяСтрока.Вставить("Использовать", ПараметрыДорожек[Индекс - 1].Использовать);
				НоваяСтрока.Вставить("Префикс"     , ПараметрыДорожек[Индекс - 1].Префикс);
				НоваяСтрока.Вставить("Суффикс"     , ПараметрыДорожек[Индекс - 1].Суффикс);
				времПараметрыДорожек.Добавить(НоваяСтрока);
			КонецЦикла;
			
			Для Индекс = 1 По 3 Цикл
				Если времПараметрыДорожек[Индекс - 1].Использовать Тогда
					ПрефиксДрайвера = времПараметрыДорожек[Индекс - 1].Префикс;
					ВремНастройки.ПараметрыОборудования.Вставить("P_Prefix", ПрефиксДрайвера);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Для Индекс = 1 По 3 Цикл
				Если времПараметрыДорожек[3 - Индекс].Использовать Тогда
					СуффиксДрайвера = времПараметрыДорожек[3 - Индекс].Суффикс;
					ВремНастройки.ПараметрыОборудования.Вставить("P_Suffix", СуффиксДрайвера);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ВремНастройки.ПараметрыОборудования.Вставить("ПараметрыДорожек", времПараметрыДорожек);
			
		КонецЕсли;
		
		Если НастроеноДорожек > 0 И Не ДорожкаСПустымСуффиксом Тогда
			Закрыть(ВремНастройки);  
		ИначеЕсли НастроеноДорожек = 0 Тогда
			ТекстСообщения = НСтр("ru='Необходимо указать использование хотя бы одной дорожки для считывателя';uk='Необхідно вказати використання хоча б однієї доріжки для зчитувача'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		ИначеЕсли ДорожкаСПустымСуффиксом Тогда
			ТекстСообщения = НСтр("ru='Для каждой используемой дорожки должен быть указан суффикс, отличный от 0';uk='Для кожної використовуваної доріжки повинен бути вказаний суфікс, відмінний від 0'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	Иначе
		Закрыть(ВремНастройки);  
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьЗапускПриложенияЗавершение(Результат, Параметры) Экспорт
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Начата установка основной поставки драйвера.';uk='Розпочато встановлення основної поставки драйвера.'")); 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Оповещения = Новый ОписаниеОповещения("НачатьЗапускПриложенияЗавершение", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещения, АдресЗагрузкиДрайвера, , Ложь);
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	Если ИнтеграционнаяБиблиотека Тогда
		Текст = НСтр("ru='Для установки драйвера необходимо подключение к Интернету.
            |Продолжить выполнение операции?'
            |;uk='Для встановлення драйвера необхідно підключення до Інтернету.
            |Продовжити виконання операції?'");
		Оповещение = Новый ОписаниеОповещения("УстановкаДрайвераЗавершение",  ЭтотОбъект);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	Иначе
		
		ОчиститьСообщения();
		ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
		ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
		МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере(Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере(Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.';uk='При встановленні драйвера з дистрибутива сталася помилка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	КоманднаяПанель.Доступность = Истина;
	Элементы.ДрайверИВерсия.ТолькоПросмотр = Ложь;
	Элементы.Страницы.ТолькоПросмотр = Ложь;

	ДополнительноеОписание = "";
	ВыходныеПараметры = РезультатВыполнения.ВыходныеПараметры;
	
	Если ТипЗнч(ВыходныеПараметры) = Тип("Массив") Тогда
		
		Если ВыходныеПараметры.Количество() >= 2 Тогда
			ДополнительноеОписание = ВыходныеПараметры[1];
		КонецЕсли;
		
		Если ВыходныеПараметры.Количество() >= 3 И НЕ ПустаяСтрока(ВыходныеПараметры[2])  Тогда
			ДемонстрационныйРежим = ВыходныеПараметры[2];
			Элементы.ГруппаДемонстрационныйРежим.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
		
	ТекстСообщения = ?(РезультатВыполнения.Результат,  НСтр("ru='Тест успешно выполнен. %ДополнительноеОписание%';uk='Тест успішно виконаний. %ДополнительноеОписание%'"),
	                               НСтр("ru='Тест не пройден. %ДополнительноеОписание%';uk='Тест не пройдено. %ДополнительноеОписание%'"));
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;
	ДемонстрационныйРежим = "";
	
	Элементы.ГруппаДемонстрационныйРежим.Видимость = Ложь;
	КоманднаяПанель.Доступность = Ложь;
	Элементы.ДрайверИВерсия.ТолькоПросмотр = Истина;
	Элементы.Страницы.ТолькоПросмотр = Истина;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	ПараметрыУстройства = ПолучитьНастройки().ПараметрыОборудования;
	
	Оповещение = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, "CheckHealth", ВходныеПараметры, Идентификатор, ПараметрыУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительноеДействиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТекстСообщения = ?(РезультатВыполнения.Результат,  НСтр("ru='Операция выполнена успешно.';uk='Операція виконана успішно.'"),
	                               НСтр("ru='Ошибка выполнения операции.';uk='Помилка виконання операції.'") + Символы.НПП + РезультатВыполнения.ВыходныеПараметры[1]);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	ОчиститьНастраиваемыйИнтерфейс();
	ОбновитьИнформациюОДрайвере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительноеДействие(Команда)
	
	ОчиститьСообщения();
	
	ВыходныеПараметры = Неопределено;
	ВходныеПараметры  = Новый Массив();
	ВходныеПараметры.Добавить(Сред(Команда.Имя, 3)); 
	Оповещение = Новый ОписаниеОповещения("ДополнительноеДействиеЗавершение", ЭтотОбъект);
	
	МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, "DoAdditionalAction", ВходныеПараметры, Идентификатор, ПолучитьНастройки());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОчиститьНастраиваемыйИнтерфейс()
	
	Пока Элементы.Страницы.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Элементы.Удалить(Элементы.Страницы.ПодчиненныеЭлементы.Получить(0));
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьНастройки()
	            
	ПараметрыДрайвера = ПолучитьРеквизиты();
	
	НовыеЗначениеПараметров = Новый Структура;
	Для Каждого Параметр Из ПараметрыДрайвера Цикл
		Если Лев(Параметр.Имя, 2) = "P_" Тогда
			НовыеЗначениеПараметров.Вставить(Параметр.Имя, ЭтотОбъект[Параметр.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьНастраиваемыйИнтерфейс(ОписаниеИнтерфейса, ДополнительныеДействия, ПервыйЗапуск)
	
	Суффикс = Ложь;
	Префикс = Ложь;
	БазоваяГруппа = Неопределено;
	Элемент = Неопределено;
	ИндексГруппы = 0;
	КоличествоСтраниц = 0;
	ТекущаяСтраница = Элементы.Добавить("ОсновнаяСтраница", Тип("ГруппаФормы"), Элементы.Страницы);
	
	ЧтениеXML = Новый ЧтениеXML; 
	ЧтениеXML.УстановитьСтроку(ОписаниеИнтерфейса);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.Имя = "Settings" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
		Пока ЧтениеXML.Прочитать() Цикл  
			
			Если ЧтениеXML.Имя = "Parameter" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ТолькоЧтение = ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "TRUE", Истина, Ложь) 
										Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "ИСТИНА", Истина, Ложь);
				ОригинальноеИмя   =  ЧтениеXML.ЗначениеАтрибута("Name");
				ПараметрИмя       = ?(ТолькоЧтение, "R_", "P_") + ОригинальноеИмя;
				ПараметрЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
				ПараметрТип       = ВРег(ЧтениеXML.ЗначениеАтрибута("TypeValue"));
				ПараметрТип       = ?(НЕ ПустаяСтрока(ПараметрТип), ПараметрТип, "STRING");
				ПараметрЗначение  = ЧтениеXML.ЗначениеАтрибута("DefaultValue");
				ПараметрОписание  = ЧтениеXML.ЗначениеАтрибута("Description");
				
				Если СчитывательМагнитныхКарт Тогда
					Суффикс = ВРег(ОригинальноеИмя) = "SUFFIX" Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("Suffix")) = "TRUE", Истина, Ложь);
					Префикс = ВРег(ОригинальноеИмя) = "PREFIX" Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("Prefix")) = "TRUE", Истина, Ложь);
				КонецЕсли;
				
				ПараметрСуществует = Ложь;
				ПараметрыДрайвера = ПолучитьРеквизиты();
				Для Каждого ПараметрДрайвера Из ПараметрыДрайвера Цикл
					Если ПараметрДрайвера.Имя = ПараметрИмя Тогда
						ПараметрСуществует = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ПараметрСуществует Тогда
					
					Если ПараметрТип = "NUMBER" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Число"), , ПараметрЗаголовок, Истина);
					ИначеЕсли ПараметрТип = "BOOLEAN" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Булево"), , ПараметрЗаголовок, Истина);
					Иначе
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Строка"), , ПараметрЗаголовок, Истина);
					КонецЕсли;
				
					// Добавляем новый реквизит в форму.
					ДобавляемыеРеквизиты = Новый Массив;
					ДобавляемыеРеквизиты.Добавить(Реквизит);
					ИзменитьРеквизиты(ДобавляемыеРеквизиты);
				
				КонецЕсли;
				
				Если Суффикс Тогда 
					Элемент = Элементы.ПараметрыДорожекСуффикс
				ИначеЕсли Префикс Тогда
					Элемент = Элементы.ПараметрыДорожекПрефикс;
				ИначеЕсли Элементы.Найти(ПараметрИмя) = Неопределено Тогда
					// Если не было создано не одной группы.
					Если БазоваяГруппа = Неопределено Тогда
						БазоваяГруппа = Элементы.Добавить("БазоваяГруппа" + КоличествоСтраниц, Тип("ГруппаФормы"), ТекущаяСтраница);
						БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
						БазоваяГруппа.Отображение = Элементы.ДрайверИВерсия.Отображение;
						БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
						БазоваяГруппа.Заголовок = НСтр("ru='Параметры';uk='Параметри'");
					КонецЕсли;
					// Добавляем новое поле ввода на форму.
					Элемент = Элементы.Добавить(ПараметрИмя, Тип("ПолеФормы"), БазоваяГруппа);
					Если ПараметрТип = "BOOLEAN" Тогда 
						Элемент.Вид = ВидПоляФормы.ПолеФлажка
					Иначе
						Элемент.Вид = ВидПоляФормы.ПолеВвода;
						Элемент.РастягиватьПоГоризонтали = Истина;
					КонецЕсли;
					Элемент.ПутьКДанным = ПараметрИмя;
					Элемент.Подсказка = ПараметрОписание;
					Элемент.ТолькоПросмотр = ТолькоЧтение; 
				КонецЕсли;
				
				ХранимоеЗначение = Неопределено;
				Если ЗначениеПараметров.Свойство(ПараметрИмя, ХранимоеЗначение) Тогда
					ПараметрЗначение = ХранимоеЗначение
				Иначе
					Если НЕ ПустаяСтрока(ПараметрЗначение) Тогда
						Если ПараметрТип = "BOOLEAN" Тогда
							ПараметрЗначение = ?(ВРег(ПараметрЗначение) = "TRUE", Истина, Ложь) Или  ?(ВРег(ПараметрЗначение) = "ИСТИНА", Истина, Ложь);
						ИначеЕсли ПараметрТип = "STRING" Тогда
							ПараметрЗначение = Строка(ПараметрЗначение);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				ЭтотОбъект[ПараметрИмя] = ПараметрЗначение;
				МастерПараметр         = ЧтениеXML.ЗначениеАтрибута("MasterParameterName");
				МастерПараметрЗначение = ЧтениеXML.ЗначениеАтрибута("MasterParameterValue");
				МастерПараметрОперация = ЧтениеXML.ЗначениеАтрибута("MasterParameterOperation");
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "ChoiceList" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				
				Если НЕ (Элемент = Неопределено) И НЕ (Элемент.Вид = ВидПоляФормы.ПолеФлажка) Тогда   
					Элемент.РежимВыбораИзСписка  = Истина; 
					Элемент.РедактированиеТекста = Ложь; 
				КонецЕсли;
				
				Пока ЧтениеXML.Прочитать() И НЕ (ЧтениеXML.Имя = "ChoiceList") Цикл   
					
					Если ЧтениеXML.Имя = "Item" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
						ЗначениеАтрибута = ЧтениеXML.ЗначениеАтрибута("Value"); 
						Если ЧтениеXML.Прочитать() Тогда
							ПредставлениеАтрибута = ЧтениеXML.Значение;
						КонецЕсли;
						Если ПустаяСтрока(ЗначениеАтрибута) Тогда
							ЗначениеАтрибута = ПредставлениеАтрибута;
						КонецЕсли;
						
						Если ПараметрТип = "NUMBER" Или Суффикс Или Префикс Тогда 
							Элемент.СписокВыбора.Добавить(Число(ЗначениеАтрибута), ПредставлениеАтрибута)
						Иначе	
							Элемент.СписокВыбора.Добавить(ЗначениеАтрибута, ПредставлениеАтрибута)
						КонецЕсли;
						
					КонецЕсли;
				КонецЦикла; 
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "Page" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ЗаголовокСтраницы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокСтраницы = ?(ПустаяСтрока(ЗаголовокСтраницы), НСтр("ru='Параметры';uk='Параметри'"), ЗаголовокСтраницы);
				
				КоличествоСтраниц = КоличествоСтраниц + 1;
				Если КоличествоСтраниц > 1 Тогда
					Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
					ТекущаяСтраница = Элементы.Добавить("Страница" + КоличествоСтраниц, Тип("ГруппаФормы"), Элементы.Страницы);
					БазоваяГруппа = Неопределено;
				КонецЕсли;
				ТекущаяСтраница.Заголовок = ЗаголовокСтраницы;
				
			КонецЕсли;
				
			Если ЧтениеXML.Имя = "Group" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ЗаголовокГруппы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокГруппы = ?(ПустаяСтрока(ЗаголовокГруппы), НСтр("ru='Параметры';uk='Параметри'"), ЗаголовокГруппы);
				
				БазоваяГруппа = Элементы.Добавить("Группа" + ИндексГруппы, Тип("ГруппаФормы"), ТекущаяСтраница);
				БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				БазоваяГруппа.Отображение = Элементы.ДрайверИВерсия.Отображение;
				БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
				БазоваяГруппа.Заголовок = ЗаголовокГруппы;
				ИндексГруппы = ИндексГруппы + 1;
				
			КонецЕсли;
			
		КонецЦикла;  
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть(); 
	
	Если ПервыйЗапуск И НЕ ПустаяСтрока(ДополнительныеДействия) Тогда
		
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(ДополнительныеДействия);
		ЧтениеXML.ПерейтиКСодержимому();
		
		Если ЧтениеXML.Имя = "Actions" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
			
			Пока ЧтениеXML.Прочитать() Цикл  
				Если ЧтениеXML.Имя = "Action" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					
					ДействиеИмя       = "M_"  + ЧтениеXML.ЗначениеАтрибута("Name");
					ДействиеЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
					
					Команда = ЭтотОбъект.Команды.Добавить("A_" + ЧтениеXML.ЗначениеАтрибута("Name"));
					Команда.Заголовок = ДействиеЗаголовок;
					Команда.Действие = "ДополнительноеДействие";
					
					ПунктМеню = ЭтотОбъект.Элементы.Добавить(ДействиеИмя, Тип("КнопкаФормы"), ЭтотОбъект.Элементы.ДополнительныеДействия);
					ПунктМеню.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
					ПунктМеню.Заголовок = ДействиеЗаголовок;
					ПунктМеню.ИмяКоманды = "A_" + ЧтениеXML.ЗначениеАтрибута("Name");
					 
				КонецЕсли;
			КонецЦикла;  
			
		КонецЕсли;
		
		ЧтениеXML.Закрыть(); 
		
	КонецЕсли;
	
	Элементы.ПрефиксыИСуффиксыДорожек.Видимость = СчитывательМагнитныхКарт;
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры                   

&НаКлиенте
Процедура НачатьВыполнениеДополнительнойКомандыЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ПервыйЗапуск = ?(Параметры.Свойство("ПервыйЗапуск"), Параметры.ПервыйЗапуск, Истина);
	ВыходныеПараметры = РезультатВыполнения.ВыходныеПараметры;
		
	Если РезультатВыполнения.Результат Тогда
		ДрайверУстановлен         = ВыходныеПараметры[0];
		ВерсияДрайвера            = ВыходныеПараметры[1];
		НаименованиеДрайвера      = ВыходныеПараметры[2];
		ОписаниеДрайвера          = ВыходныеПараметры[3];
		ТипОборудования           = ВыходныеПараметры[4];
		РевизияИнтерфейса         = ВыходныеПараметры[5];
		ИнтеграционнаяБиблиотека  = ВыходныеПараметры[6];
		ОсновнойДрайверУстановлен = ВыходныеПараметры[7];
		АдресЗагрузкиДрайвера     = ВыходныеПараметры[8];
		ПараметрыДрайвера         = ВыходныеПараметры[9];
		ДополнительныеДействия    = ВыходныеПараметры[10];
		
		Если (ИнтеграционнаяБиблиотека И ОсновнойДрайверУстановлен) Или (НЕ ИнтеграционнаяБиблиотека) Тогда
			Если НЕ ПустаяСтрока(ПараметрыДрайвера) Тогда
				ОбновитьНастраиваемыйИнтерфейс(ПараметрыДрайвера, ДополнительныеДействия, ПервыйЗапуск);
			КонецЕсли;
		КонецЕсли;
		
		Если ИнтеграционнаяБиблиотека И НЕ ОсновнойДрайверУстановлен Тогда
			ДрайверУстановлен = НСтр("ru='Установлена интеграционная библиотека';uk='Встановлена інтеграційна бібліотека'");
			ВерсияДрайвера = НСтр("ru='Не определена';uk='Не визначена'");
			Элементы.УстановитьДрайвер.Заголовок = НСтр("ru='Установить основную поставку драйвера';uk='Встановити основну поставку драйвера'");
		КонецЕсли;
		Элементы.ДрайверИВерсия.Доступность = Истина;
	Иначе
		ДрайверСообщение  = ВыходныеПараметры[1];
		ДрайверУстановлен = ВыходныеПараметры[2];
		ВерсияДрайвера  = НСтр("ru='Не определена';uk='Не визначена'");
		Если НЕ ПустаяСтрока(ДрайверСообщение) И ДрайверУстановлен = НСтр("ru='Установлен';uk='Встановлений'") Тогда
			Элементы.УстройствоПодключено.Видимость = Истина;
			Элементы.УстройствоПодключено.Заголовок = ДрайверСообщение;
			Элементы.ЗаписатьИЗакрыть.Видимость = Ложь;
			Элементы.ДрайверИВерсия.Видимость   = Ложь;
			Элементы.ПрефиксыИСуффиксыДорожек.Видимость = Ложь;
			Элементы.Функции.Видимость = Ложь;
			Элементы.Закрыть.Видимость = Истина;
		КонецЕсли
	КонецЕсли;
	
	Элементы.Драйвер.ЦветТекста = ?(ВерсияДрайвера = НСтр("ru='Не определена';uk='Не визначена'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = Элементы.Драйвер.ЦветТекста ;
	Элементы.НаименованиеДрайвера.ЦветТекста = ?(НаименованиеДрайвера = НСтр("ru='Не определено';uk='Не визначено'"), ЦветОшибки, ЦветТекста);
	Элементы.ОписаниеДрайвера.ЦветТекста     = ?(ОписаниеДрайвера     = НСтр("ru='Не определено';uk='Не визначено'"), ЦветОшибки, ЦветТекста);
	Элементы.ОписаниеДрайвера.Видимость = НЕ ПустаяСтрока(ОписаниеДрайвера);
	
	Элементы.УстановитьДрайвер.Доступность = Не (ДрайверУстановлен = НСтр("ru='Установлен';uk='Встановлений'"));
	Элементы.ТестУстройства.Доступность = (НЕ ДрайверУстановлен = НСтр("ru='Не установлен';uk='Не встановлений'")) 
	                                      И (НЕ ИнтеграционнаяБиблиотека Или (ИнтеграционнаяБиблиотека И ОсновнойДрайверУстановлен));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере(ПервыйЗапуск)

	ВходныеПараметры  = Неопределено;
	ПараметрыУстройства = Неопределено;
	ПараметрыКоманды = Новый Структура("ПервыйЗапуск", ПервыйЗапуск);
	Оповещение = Новый ОписаниеОповещения("НачатьВыполнениеДополнительнойКомандыЗавершение", ЭтотОбъект, ПараметрыКоманды);
	МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, "ПолучитьОписаниеДрайвера", ВходныеПараметры, Идентификатор, ПараметрыУстройства);
	  
КонецПроцедуры

#КонецОбласти