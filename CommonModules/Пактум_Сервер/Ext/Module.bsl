﻿// Код частично предоставлен разработчиками сервиса Пактум.Контрагент
// Сервисное обслуживание сервиса Пактум.Контрагент осуществляется 
// линией консультаций разработчиков:
// • e-mail pactum.contragent@gmail.com
// • тел. + 380 (67) 430-04-50.


Функция ПолучитьНастройкиПодключения() Экспорт
	Настройки=ХранилищеОбщихНастроек.Загрузить("Обработка.Пактум_Контрагент");
	Если ТипЗнч(Настройки)=Тип("Структура") Тогда
		
	Иначе
		Настройки=Новый Структура;
		Настройки.Вставить("фИспользоватьПрокси", Ложь);
		Настройки.Вставить("АдресПрокси");
		Настройки.Вставить("ПортПрокси");
		Настройки.Вставить("фИспользоватьЛогинПарольПрокси", Ложь);
		Настройки.Вставить("ЛогинПрокси");
		Настройки.Вставить("ПарольПрокси");
        Настройки.Вставить("КоличествоПопыток", 18);
        Настройки.Вставить("ПаузаМеждуПопытками", 10);
	КонецЕсли;	
	
	Настройки.Вставить("Логин", "");
	Настройки.Вставить("Пароль", "");
	Настройки2=ХранилищеОбщихНастроек.Загрузить("Обработка.Пактум_Контрагент_Подключение");
	Если ТипЗнч(Настройки2)=Тип("Структура") Тогда
		Настройки.Вставить("Логин", Настройки2.Логин);
		Настройки.Вставить("Пароль", Настройки2.Пароль);
	Иначе
		Настройки.Вставить("Логин");
		Настройки.Вставить("Пароль");
	КонецЕсли;
	Возврат Настройки;
КонецФункции

Функция Авторизация_Пактум() Экспорт
	НастройкиПодключения=ПолучитьНастройкиПодключения();
	СтруАвторизация=Новый Структура;
	СтруАвторизация.Вставить("Результат", Ложь);
	
	Если СокрЛП(НастройкиПодключения.Логин)="" Тогда
		Индикатор1 = 0;
		Возврат СтруАвторизация;
	КонецЕсли;
	
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.Option(2,"utf-8");
	WinHttp.Open("POST","https://pactumsys.com/api/v1/cba2911c-01f9-4ca7-833a-46fb0cc079f2/accounts/authentication",0);
	WinHttp.SetRequestHeader("Accept-Language", "ru");
	WinHttp.SetRequestHeader("Accept-Charset","utf-8");
	WinHttp.setRequestHeader("Content-Language", "ru");
	WinHttp.setRequestHeader("Content-Charset", "utf-8");
	WinHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	ПараметрыПОСТ = "UserName=" + СокрЛП(НастройкиПодключения.Логин) + "&Password=" + СокрЛП(НастройкиПодключения.Логин);
	Если НастройкиПодключения.фИспользоватьПрокси Тогда
		WinHttp.SetProxy(2, СокрЛП(НастройкиПодключения.АдресПрокси)+":"+СокрЛП(НастройкиПодключения.ПортПрокси));
		Если НастройкиПодключения.фИспользоватьЛогинПарольПрокси Тогда
   			WinHttp.SetCredentials(СокрЛП(НастройкиПодключения.ЛогинПрокси), СокрЛП(НастройкиПодключения.ПарольПрокси), 1);
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		WinHttp.Send(ПараметрыПОСТ);
		СтруАвторизация.Вставить("Результат", Истина);
	Исключение
		Индикатор1 = 0;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Сервер недоступен. Проверьте подключение к Интернету.'
						|;uk='Сервер недоступний. Перевірте підключення до мережі Інтернет.'"));
		СтруАвторизация.Вставить("Результат", Ложь);
	КонецПопытки;

	Если СтруАвторизация.Результат Тогда
		СтруАвторизация.Вставить("Токен");
		Попытка
			ТекстОтвета = WinHttp.ResponseText();
		Исключение
			Индикатор1 = 0;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Сервер недоступен. Проверьте подключение к Интернету.'
							|;uk='Сервер недоступний. Перевірте підключення до мережі Інтернет.'"));
			СтруАвторизация.Вставить("Результат", Ложь);
		КонецПопытки;
		
		Если Найти(ТекстОтвета,"Пинкод указан не верно" )=0 тогда
			ЧтениеJSON = Новый ЧтениеJSON;	
			ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
			СтрТокен = ПрочитатьJSON (ЧтениеJSON);
			Если Не СтрТокен = Неопределено Тогда
				Если СтрТокен.Свойство("access_token") Тогда
					стрПактум_Токен = СтрТокен.access_token;
					СтруДанныеДепозит=Депозит_Пактум(стрПактум_Токен);
					СтруАвторизация.Вставить("Токен", стрПактум_Токен);
					СтруАвторизация.Вставить("Депозит", СтруДанныеДепозит.Депозит);
					СтруАвторизация.Вставить("ДатаСтарт", СтруДанныеДепозит.ДатаСтарт);
					СтруАвторизация.Вставить("ДатаКонец", СтруДанныеДепозит.ДатаКонец);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Пинкод указан не верно';uk= 'Пінкод вказаний не вірно'"));
			СтруАвторизация.Вставить("Результат", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруАвторизация;
КонецФункции

Функция ПроверкаКорректностиЕДРПОУ_Пактум(КодЕДРПОУ) Экспорт
	НастройкиПодключения=ПолучитьНастройкиПодключения();
	
	Стру = Авторизация_Пактум();
	Стру.Вставить("КорректностьЕДРПОУ_Значение", Ложь);
	Стру.Вставить("КорректностьЕДРПОУ_ТекстОшибки", "");
	
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.Option(2,"utf-8");
	WinHttp.Open("Get","https://pactumsys.com/api/v1/cba2911c-01f9-4ca7-833a-46fb0cc079f2/contractors/"+КодЕДРПОУ+"?source=1c;skipRegisters=2,3",0); 
	WinHttp.SetRequestHeader("Accept-Language", "ru");
	WinHttp.SetRequestHeader("Accept-Charset","utf-8");
	WinHttp.setRequestHeader("Content-Language", "ru");
	WinHttp.setRequestHeader("Content-Charset", "utf-8");
	WinHttp.setRequestHeader("Authorization", "Bearer "+Стру.Токен);
	WinHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	ПараметрыПОСТ = "";
	Если НастройкиПодключения.фИспользоватьПрокси Тогда
		WinHttp.SetProxy(2, СокрЛП(НастройкиПодключения.АдресПрокси)+":"+СокрЛП(НастройкиПодключения.ПортПрокси));
		Если НастройкиПодключения.фИспользоватьЛогинПарольПрокси Тогда
   			WinHttp.SetCredentials(СокрЛП(НастройкиПодключения.ЛогинПрокси), СокрЛП(НастройкиПодключения.ПарольПрокси), 1);
		КонецЕсли;
	КонецЕсли;
	
	фВсеОК=Истина;
	Попытка
		WinHttp.Send(ПараметрыПОСТ);
	Исключение
		фВсеОК=Ложь;
	КонецПопытки;
	
	ТекстОтвета="";
	Если фВсеОК Тогда
		Попытка
			ТекстОтвета = WinHttp.ResponseText();
		Исключение
			фВсеОК=Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Если Не фВсеОК Тогда
		Стру.Вставить("КорректностьЕДРПОУ_Значение", Ложь);
		Стру.Вставить("КорректностьЕДРПОУ_ТекстОшибки", НСтр("ru='Сервер недоступен. Проверьте подключение к Интернету.'
						|;uk='Сервер недоступний. Перевірте підключення до мережі Інтернет.'"));
		Возврат Стру;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку( ТекстОтвета);
	Контрагент = ПрочитатьJSON (ЧтениеJSON);
	
	Если Контрагент.Свойство("Status") Тогда
		Стру.Вставить("КорректностьЕДРПОУ_Значение", Истина);
	Иначе
		Стру.Вставить("КорректностьЕДРПОУ_Значение", Ложь);
		Стру.Вставить("КорректностьЕДРПОУ_ТекстОшибки", Контрагент.Message);
	КонецЕсли;
	
	Возврат Стру;
КонецФункции

Функция Пактум_Права() Экспорт
	Если РольДоступна("ПолныеПрава") Тогда
		Возврат Истина;
	КонецЕсли;
	Если Не РольДоступна("ПактумИспользование") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
            НСтр("ru='Недостаточно прав.';uk='Недостатньо прав.'")
        );
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция НастройкиПодключенияКСервисуПактумЗаданы() Экспорт
    
    Настройки = Пактум_Сервер.ПолучитьНастройкиПодключения();
    Если ПустаяСтрока(Настройки.Логин) Тогда
        Возврат Ложь;
    Иначе    
        Возврат Истина;
    КонецЕсли; 
    
КонецФункции

// Запускает фоновое задание по получению данных контрагента с сервиса, согласно указанному КодПоЕДРПОУ.
//
// Параметры:
//  КодПоЕДРПОУ - Строка - КодПоЕДРПОУ контрагента, согласно которому будет выполнен поиск данных
//  ЮрФизЛицо  - Перечисления.ЮрФизЛицо - 
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор запускаемого регламентного задания.
//
// Возвращаемое значение:
//   РезультатЗапуска   - структура, содержит следующие параметры:
//        ЗаданиеЗапущено      - Булево - Истина, если задание удалось выполнить сразу.
//        РеквизитыКонтрагента - Структура - данные контрагента, если они были получены сразу.
//        ИдентификаторЗадания - Строка - идентификатор запущенного фонового задания.
//        АдресХранилища       - Строка - адрес хранилища, в которое будет помещен результат выполнения.
Функция ФоновоеЗаданиеДанныеПартнераПоКодПоЕДРПОУЗапустить(КодПоЕДРПОУ, Пактум_Токен, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	РезультатЗапуска = Новый Структура("ЗаданиеЗапущено, РеквизитыКонтрагента", Ложь, Неопределено);
	РезультатЗапуска.Вставить("ИдентификаторЗадания","");
	РезультатЗапуска.Вставить("АдресХранилища","");
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		
		Если Задание <> Неопределено
			И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			Задание.Отменить();
		КонецЕсли;
    КонецЕсли;
    
    // авторизация в сервисе могла пройти ранее, в форме, в таком случае будет заполнен переданный из формы Пактум_Токен, 
    // если он не заполнен, проходим авторизацию здесь
    Если СокрЛП(Пактум_Токен) = "" Тогда
        Авторизация = Пактум_Сервер.Авторизация_Пактум();
        Если НЕ Авторизация.Результат Тогда 
            Сообщить(НСтр("ru='Авторизация Пактум.Контрагент не пройдена. Для настройки доступа обратитесь к администратору.';uk= 'Авторизація Пактум.Контрагент не пройдена. Для настройки доступу зверніться до адміністратора.'"));
            Возврат РезультатЗапуска;
        Иначе
            Пактум_Токен = Авторизация.Токен;    
        КонецЕсли;
    КонецЕсли; 
    
	ИнформацияОбОшибке = Неопределено;
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("КодПоЕДРПОУ", КодПоЕДРПОУ);
    ПараметрыФормирования.Вставить("Токен", Пактум_Токен);
	
	Попытка
		РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Пактум_ФоновыеЗадания.ДанныеКонтрагентаПоЕДРПОУФоновоеЗадание",
			ПараметрыФормирования,
			НСтр("ru='Работа с контрагентами: получение реквизитов по коду по ЕГРПОУ.';uk='Робота з контрагентами: отримання реквізитів по коду за ЄДРПОУ.'")
        );
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Возврат РезультатЗапуска;
	КонецПопытки;
	
	РезультатЗапуска.ИдентификаторЗадания  = РезультатФоновогоЗадания.ИдентификаторЗадания;
	РезультатЗапуска.АдресХранилища        = РезультатФоновогоЗадания.АдресХранилища;
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		РезультатЗапуска.РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресХранилища);
	Иначе
		РезультатЗапуска.ЗаданиеЗапущено      = Истина;
	КонецЕсли;
	
	Возврат РезультатЗапуска;
	
КонецФункции

// Проверяет, выполнено ли ранее запущенное фоновое задание по получению данных контрагента по ЕДРПОУ.
//
// Параметры:
//  ЗаданиеИдентификатор  - Строка - идентификатор фонового задания.
//  АдресХранилища        - Строка - адрес хранилища, в которое будет помещен результат выполнения.
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   РезультатВыполнения   - структура, содержит следующие параметры:
//        ЗаданиеВыполнено      - Булево - Истина, если задание выполнено.
//        РеквизитыКонтрагента  - Структура - полученные данные контрагента.
//
Функция ФоновоеЗаданиеВыполнено(ЗаданиеИдентификатор, АдресХранилища) Экспорт
	
	РезультатВыполнения = Новый Структура("ЗаданиеВыполнено, РеквизитыКонтрагента", Ложь, Неопределено);
	
	Попытка
		РезультатВыполнения.ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ЗаданиеИдентификатор);
	Исключение
	КонецПопытки;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		РезультатВыполнения.РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(АдресХранилища);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция Депозит_Пактум(Токен) Экспорт
	НастройкиПодключения=ПолучитьНастройкиПодключения();
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.Option(2,"utf-8");
	
	WinHttp.Open("POST","https://pactumsys.com/api/v1/cba2911c-01f9-4ca7-833a-46fb0cc079f2/accounts/profile",0);
	WinHttp.SetRequestHeader("Accept-Language", "ru");
	WinHttp.SetRequestHeader("Accept-Charset","utf-8");
	WinHttp.setRequestHeader("Content-Language", "ru");
	WinHttp.setRequestHeader("Authorization", "Bearer "+Токен);
	WinHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	ПараметрыПОСТ = "";
	Если НастройкиПодключения.фИспользоватьПрокси Тогда
		WinHttp.SetProxy(2, СокрЛП(НастройкиПодключения.АдресПрокси)+":"+СокрЛП(НастройкиПодключения.ПортПрокси));
		Если НастройкиПодключения.фИспользоватьЛогинПарольПрокси Тогда
   			WinHttp.SetCredentials(СокрЛП(НастройкиПодключения.ЛогинПрокси), СокрЛП(НастройкиПодключения.ПарольПрокси), 1);
		КонецЕсли;
	КонецЕсли;
	фВсеОК=Истина;
	Попытка
		WinHttp.Send(ПараметрыПОСТ);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Сервер недоступен. Проверьте подключение к Интернету.'
						|;uk='Сервер недоступний. Перевірте підключення до мережі Інтернет.'"));
		фВсеОК=Ложь;
	КонецПопытки;
	Попытка
		ТекстОтвета = WinHttp.ResponseText();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Сервер недоступен. Проверьте подключение к Интернету.'
						|;uk='Сервер недоступний. Перевірте підключення до мережі Інтернет.'"));
		фВсеОК=Ложь;
	КонецПопытки;
		
	СуммаДепозита=0;
	ДатаСтарт=0; ДатаКонец=0;
	Если фВсеОК Тогда
		Попытка
			ЧтениеJSON=Новый ЧтениеJSON;	
			ЧтениеJSON.УстановитьСтроку( ТекстОтвета);
			СтрТокен = ПрочитатьJSON (ЧтениеJSON);
			пСумма=0; ДатаСтарт=0; ДатаКонец=0;
			Мас=СтрТокен.Subscriptions;
			Для Каждого Эл Из Мас Цикл
				Если Не Эл.AllowToUse Тогда
					Продолжить;
				КонецЕсли;
				Попытка
					пСумма1=Эл.RequestsLimit;
					Если пСумма1=Неопределено Тогда
						пСумма1=0;
					КонецЕсли;
				Исключение
					пСумма1=0;
				КонецПопытки;
				Попытка
					пСумма2=Эл.TotalUsage;
					Если пСумма2=Неопределено Тогда
						пСумма2=0;
					КонецЕсли;
				Исключение
					пСумма2=0;
				КонецПопытки;
				пСумма=пСумма+пСумма1-пСумма2;
				
				Попытка
					Если Не Эл.StartDate=Неопределено Тогда
						ДатаСтарт=Эл.StartDate;
					КонецЕсли;
				Исключение
				КонецПопытки;
				
				Попытка
					Если Не Эл.EndDate=Неопределено Тогда
						ДатаКонец=Эл.EndDate;
					КонецЕсли;
				Исключение
				КонецПопытки;

			КонецЦикла;
			СуммаДепозита=пСумма;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Стру=Новый Структура;
	Стру.Вставить("Депозит", СуммаДепозита);
	Стру.Вставить("ДатаСтарт", ДатаСтарт);
	Стру.Вставить("ДатаКонец", ДатаКонец);
	Возврат Стру;
КонецФункции

Функция ВероятноЕДРПОУ(пСтрока) Экспорт
	Если СтрДлина(пСтрока)=8 Или СтрДлина(пСтрока)=10 Тогда
		Если ВсеЦифры(пСтрока) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция ВсеЦифры(пСтрока)
	Для А=1 По СтрДлина(пСтрока) Цикл
		пСимв=Сред(пСтрока, А, 1);
		Если Найти("1234567890", пСимв)=0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

Функция ПолучитьКонтрагента(КодЕДРПОУ, Код = "") Экспорт
	Стру=Новый Структура("Контрагент, спКонтрагенты, Кво", Неопределено, Новый СписокЗначений, 0);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка
	//|	,Контрагенты.Код
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.КодПоЕДРПОУ = &КодПоЕДРПОУ
	|";
	Запрос.УстановитьПараметр("КодПоЕДРПОУ", КодЕДРПОУ);
	//Запрос.УстановитьПараметр("Код", Код);
	
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		Возврат Стру;
	КонецЕсли;
	
	Выб = Рез.Выбрать();
	Пока Выб.Следующий() Цикл
		Если ЗначениеЗаполнено(Код) Тогда
			Стру.Вставить("Контрагент", Выб.Ссылка);
		КонецЕсли;
		Стру.спКонтрагенты.Добавить(Выб.Ссылка);
	КонецЦикла;
	Стру.Вставить("Кво", Выб.Количество());
	
	Возврат Стру;
КОнецФункции

Функция ПолучитьСсылкуИзНавигационной(НС) Экспорт
    
    ПерваяТочка = Найти(НС, "e1cib/data/");
    ВтораяТочка = Найти(НС, "?ref=");
    
    ПредставлениеТипа   = Сред(НС, ПерваяТочка + 11, ВтораяТочка - ПерваяТочка - 11);
    ШаблонЗначения = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ПредставлениеТипа + ".ПустаяСсылка"));
    ЗначениеСсылки = СтрЗаменить(ШаблонЗначения, "00000000000000000000000000000000", Сред(НС, ВтораяТочка + 5));
    Ссылка = ЗначениеИзСтрокиВнутр(ЗначениеСсылки);
	
	Возврат Ссылка;
КонецФункции
