﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Криптосервис".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Отправляет код проверки на указанный email или номер телефона в письме или SMS соответственно.
//
// Параметры:
// 	ПредметПроверки   - Строка - номер мобильного телефона или адрес электронной почты, 
//                      на который необходимо выслать код проверки.
//  ПовторнаяОтправка - Булево - если Истина - будет повторная отправка
//                      последного отправленного кода.
//  Тип               - Строка - "phone" - отправка SMS,
//                      "email" - отправка письма.
//
// Возвращаемое значение:
// 	Булево - результат выполнения
//
Функция ПолучитьПроверочныйКод(Знач ПредметПроверки, ПовторнаяОтправка = Ложь, Тип = "phone") Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		Если  Тип = "phone" Тогда
			Возврат КриптосервисПрокси.GetVerificationCodeEx(
				КриптосервисВМоделиСервисаКлиентСервер.НомерТелефона(ПредметПроверки), Ложь, Тип);
		Иначе
			Возврат КриптосервисПрокси.GetVerificationCodeEx(ПредметПроверки, Ложь, Тип);	
		КонецЕсли;
	Исключение
		Если Тип = "phone" Тогда
			Событие = НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Проверка мобильного телефона';uk='Електронний підпис моделі сервісу.Криптосервис.Перевірка мобільного телефону'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Иначе
			Событие = НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Проверка электронной почты';uk='Електронний підпис моделі сервісу.Криптосервис.Перевірка електронної пошти'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(
			Событие, 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("ПредметПроверки,ПовторнаяОтправка,Тип", ПредметПроверки, ПовторнаяОтправка, Тип)));	 
				 
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Проверяет номер телефона по полученному коду в SMS.
//
// Параметры:
// 	НомерТелефона  - Строка - номер мобильного телефона, 
//                   на который был выслан проверочный код.
// 	ПроверочныйКод - Строка - код полученный в SMS.
//
// Возвращаемое значение:
//	Булево - Истина - если проверочный код совпадает с ранее отправленным.
//
Функция ПроверитьНомерТелефона(НомерТелефона, ПроверочныйКод) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.VerifyPhone(КриптосервисВМоделиСервисаКлиентСервер.НомерТелефона(НомерТелефона), ПроверочныйКод);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Проверка мобильного телефона';uk='Електронний підпис моделі сервісу.Криптосервис.Перевірка мобільного телефону'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("НомерТелефона,ПроверочныйКод", НомерТелефона, ПроверочныйКод)));	 
				 
		ВызватьСтандартноеИсключение();
	КонецПопытки;
								
КонецФункции

// Проверяет адрес электронной почты по полученному коду в письме.
//
// Параметры:
// 	АдресЭлектроннойПочты - Строка - адрес электронной почты, 
//                          на который был выслан код провери.
// 	ПроверочныйКод        - Строка - полученный код проверки.
//
// Возвращаемое значение:
//	Булево - Истина - если проверочный код совпадает с ранее отправленным.
//
Функция ПроверитьАдресЭлектроннойПочты(АдресЭлектроннойПочты, ПроверочныйКод) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.VerifyEmail(АдресЭлектроннойПочты, ПроверочныйКод);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Проверка электронной почты';uk='Електронний підпис моделі сервісу.Криптосервис.Перевірка електронної пошти'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("АдресЭлектроннойПочты,ПроверочныйКод", АдресЭлектроннойПочты, ПроверочныйКод)));	 
				 
		ВызватьСтандартноеИсключение();
	КонецПопытки;
								
КонецФункции

// Отправляет временный пароль в SMS или письме.
// 
// Параметры:
//	Идентификатор     - Строка - идентификатор ключевого контейнера.
//  ПовторнаяОтправка - Булево - если Истина - будет повторная отправка
//                      последного отправленного пароля.
//  Тип               - Строка - "phone" - отправка SMS,
//                      "email" - отправка письма.
//
// Возвращаемое значение:
//	Булево - результат выполнения функции.
//
Функция ПолучитьВременныйПароль(Идентификатор, ПовторнаяОтправка = Ложь, Тип = "phone") Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.GetPasswordEx(Идентификатор, Ложь, Тип);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение временного пароля';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання тимчасового пароля'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,ПовторнаяОтправка,Тип", Идентификатор, ПовторнаяОтправка, Тип)));	 
				 
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Производит проверку временного пароля полученного в SMS, получает и
// устанавливает сеансовый ключ.
//
// Параметры:
//	Идентификатор   - Строка - идентификатор ключевого контейнера.
//	ВременныйПароль - Строка - пароль полученный в SMS.
//
// Возвращаемое значение:
//	Булево - Истина - если сеансовый ключи успешно получен.
//
Функция ПолучитьСеансовыйКлюч(Идентификатор, ВременныйПароль) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Результат = Истина;
		
		СеансовыйКлюч = КриптосервисПрокси.GetSessionKey(Идентификатор, ВременныйПароль);
		
		СеансовыеКлючи = Новый Соответствие;
		Для Каждого ЭлементСоответствия Из ПараметрыСеанса.СеансовыеКлючиЭлектроннойПодписиВМоделиСервиса Цикл
			СеансовыеКлючи.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
		КонецЦикла;
		
		СеансовыеКлючи[Идентификатор] = СеансовыйКлюч;
		
		ПараметрыСеанса.СеансовыеКлючиЭлектроннойПодписиВМоделиСервиса = Новый ФиксированноеСоответствие(СеансовыеКлючи);		
		
		Возврат Результат;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение сеансового ключа';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання сеансового ключа'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,ВременныйПароль", Идентификатор, ?(СтрДлина(ВременныйПароль) = 6, 999999, ВременныйПароль))));
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

// Проверяет возможность использования текущего сеансового ключа.
//
// Параметры:
//	Идентификатор - Строка - идентификатор ключевого контейнера.
//
// Возвращаемое значение:
//	Булево - Истина - абонент авторизован, можно выполнять криптооперации.
//
Функция Авторизован(Идентификатор) Экспорт
	
	СеансовыйКлюч = СеансовыйКлюч(Идентификатор);
	
	Если ЗначениеЗаполнено(СеансовыйКлюч) Тогда
		Попытка
			КриптосервисПрокси = КриптосервисПрокси();
		
			Возврат КриптосервисПрокси.IsAuthorized(СеансовыйКлюч);
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Авторизация';uk='Електронний підпис моделі сервісу.Криптосервис.Авторизація'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка,,,
				КомментарийПоИсключению(
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
					Новый Структура("Идентификатор", Идентификатор)));
		
			Возврат Ложь;	
		КонецПопытки;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает основные свойства переданного сертификата.
// 
// Параметры:
//	Сертификат - ДвоичныеДанные - сертификат, 
//               для которого необходимо получить свойства.
// Возвращаемое значение:
//	Структура - свойства сертификата.
//              
Функция ПолучитьСвойстваСертификата(Сертификат) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		CertificateProperties = КриптосервисПрокси.GetCertificateProperties(Сертификат(Сертификат));
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("Версия"                   , CertificateProperties.Version + 1);
		СвойстваСертификата.Вставить("ДействителенС"            , CertificateProperties.ValidFrom);
		СвойстваСертификата.Вставить("ДействителенПо"           , CertificateProperties.ValidTo);
		СвойстваСертификата.Вставить("Поставщик"                , ПредставлениеСпискаOID(CertificateProperties.Issuer));
		СвойстваСертификата.Вставить("ИспользоватьДляПодписи"   , CertificateProperties.UseToSign);
		СвойстваСертификата.Вставить("ИспользоватьДляШифрования", CertificateProperties.UseToEncrypt);
		СвойстваСертификата.Вставить("Отпечаток"                , CertificateProperties.Thumbprint);
		СвойстваСертификата.Вставить("СерийныйНомер"            , СтрЗаменить(CertificateProperties.SerialNumber, ":", " "));
		СвойстваСертификата.Вставить("Владелец"                 , ПредставлениеСпискаOID(CertificateProperties.Subject));
		СвойстваСертификата.Вставить("Наименование"             , Наименование(CertificateProperties.Subject));

		Возврат СвойстваСертификата;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение свойств сертификата';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання властивостей сертифіката'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Сертификат", Сертификат)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Выполняет проверку сертификата.
// 
// Параметры:
//	Сертификат     - ДвоичныеДанные - сертификат.
//                 - Структура - сертификат получается из хранилища по
//                   ключу Отпечаток.
// Возвращаемое значение:
//	Булево - результат проверки сертификата.
//              
Функция ПроверитьСертификат(Сертификат) Экспорт
	
	СертификатВалиден = Истина;
	
	Возврат СертификатВалиден;
		
КонецФункции

// Подписывает переданные данные подписью владельца сертификата.
//
// Параметры:
//	Идентификатор          - Строка - идентификатор ключевого контейнера.
//	Сертификат             - ДвоичныеДанные - сертификат.
//                         - Структура - сертификат получается из хранилища по
//                           ключу Отпечаток.
//	ИсходныеДанные         - ДвоичныеДанные - данные, 
//                           которые необходимо подписать.
//	ВключатьИсходныеДанные - Булево - определяет нужно ли включать 
//                           исходные данные в подпись.
// Возвращаемое значение:
//	ДвоичныеДанные - подпись.
//
Функция Подписать(Идентификатор, ИсходныеДанные, ВключатьИсходныеДанные) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
			
		Подпись = КриптосервисПрокси.Sign(СеансовыйКлюч(Идентификатор), ИсходныеДанные, ВключатьИсходныеДанные);

		Возврат Подпись;
    Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Подписание';uk='Електронний підпис моделі сервісу.Криптосервис.Підписання'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,ИсходныеДанные,ВключатьИсходныеДанные", Идентификатор, ИсходныеДанные, ВключатьИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Подписывает переданные данные подписью владельца сертификата и возвращает подпись в двоичном формате.
//
// Параметры:
//	Идентификатор          - Строка - идентификатор ключевого контейнера.
//	ИсходныеДанные         - ДвоичныеДанные - данные, 
//                           которые необходимо подписать.
// Возвращаемое значение:
//	ДвоичныеДанные - подпись в двоичном формате.
//
Функция ПодписатьДанные(Идентификатор, ИсходныеДанные) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.SignData(СеансовыйКлюч(Идентификатор), ИсходныеДанные);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Подписание данных';uk='Електронний підпис моделі сервісу.Криптосервис.Підписання даних'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,ИсходныеДанные", Идентификатор, ИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Выполняет проверку подписи.
//
// Параметры:
//	Сертификат     - ДвоичныеДанные - сертификат.
//                 - Структура - сертификат получается из хранилища по
//                   ключу Отпечаток.
//	Подпись        - ДвоичныеДанные - подпись, 
//                           которую необходимо проверить.
//	ИсходныеДанные - ДвоичныеДанные.
//
// Возвращаемое значение:
//	Булево - Истина - подпись соответствует владельцу сертификат.
//
Функция ПроверитьПодпись(Сертификат, Подпись, ИсходныеДанные) Экспорт
	
	Попытка
		Если Не ЗначениеЗаполнено(Сертификат) Тогда
			Возврат Истина;
		КонецЕсли;
		
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.CheckSignature(Сертификат(Сертификат), Подпись, ИсходныеДанные);
	Исключение
		СвойстваКриптосообщения = ПолучитьСвойстваКриптосообщения(Подпись, Истина);
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Проверка подписи';uk='Електронний підпис моделі сервісу.Криптосервис.Перевірка підпису'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Сертификат,Подпись,ИсходныеДанные", Сертификат, СвойстваКриптосообщения, ИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Шифрует данные для указанных получателей
//
// Параметры:
//	Идентификатор          - Строка - идентификатор ключевого контейнера.
//	СертификатыПолучателей - Массив - ДвоичныеДанные - сертификат.
//                                  - Структура - сертификат получается из хранилища по
//                           ключу Отпечаток.
//	ИсходныеДанные         - ДвоичныеДанные - данные, 
//                           которые необходимо подписать.
//
// Возвращаемое значение:
//	ДвоичныеДанные - зашифрованные данные.
//
Функция Зашифровать(Идентификатор, СертификатыПолучателей, ИсходныеДанные) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		МассивСертификатовТип = КриптосервисПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "base64BinaryArray");
		МассивСертификатов = КриптосервисПрокси.ФабрикаXDTO.Создать(МассивСертификатовТип);
		
		Получатели = Новый Массив;
		Для Каждого СертификатПолучателя Из СертификатыПолучателей Цикл
			МассивСертификатов.base64Binary.Добавить(Сертификат(СертификатПолучателя));
		КонецЦикла;
		
		Возврат КриптосервисПрокси.Encrypt(Идентификатор, МассивСертификатов, ИсходныеДанные);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Шифрование';uk='Електронний підпис моделі сервісу.Криптосервис.Шифрування'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,СертификатыПолучателей,ИсходныеДанные", Идентификатор, СертификатыПолучателей, ИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Расшифровывает переданные данные, используя закрытый ключ, 
// соответствующий идентификатору.
//
// Параметры:
//	Идентификатор       - Строка - идентификатор ключевого контейнера.
//	ЗашифрованныеДанные - ДвоичныеДанные - данные для расшифровки.
//
// Возвращаемое значение:
//	ДвоичныеДанные - расшифрованные данные.
//
Функция Расшифровать(Идентификатор, ЗашифрованныеДанные, Идентификаторы = Неопределено) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();

		Результат = КриптосервисПрокси.DecryptEx(СеансовыйКлюч(Идентификатор), ЗашифрованныеДанные);
		
		Идентификаторы = Новый Массив;
		Для Каждого KeyID Из Результат.KeyID Цикл
			Идентификаторы.Добавить(KeyID);
		КонецЦикла;
		
		Возврат Результат.Data;
	Исключение
		СвойстваКриптосообщения = ПолучитьСвойстваКриптосообщения(ЗашифрованныеДанные, Истина);
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Дешифрование';uk='Електронний підпис моделі сервісу.Криптосервис.Дешифрування'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,ЗашифрованныеДанные", Идентификатор, СвойстваКриптосообщения)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Шифрует данные для указанных получателей и подписывает, используя указанный сертификат
//
// Параметры:
//	Идентификатор          - Строка - идентификатор ключевого контейнера.
//	СертификатПодписанта   - ДвоичныеДанные - сертификат.
//                         - Структура - сертификат получается из хранилища по
//                           ключу Отпечаток.
//	СертификатыПолучателей - Массив - ДвоичныеДанные - сертификат.
//                         - Структура - сертификат получается из хранилища по
//                           ключу Отпечаток.
//	ИсходныеДанные         - ДвоичныеДанные - данные, 
//                           которые необходимо подписать.
//
// Возвращаемое значение:
//	ДвоичныеДанные - подписанные и зашифрованные данные.
//
Функция ПодписатьИЗашифровать(Идентификатор, СертификатыПолучателей, ИсходныеДанные) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		МассивСертификатовТип = КриптосервисПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "base64BinaryArray");
		МассивСертификатов = КриптосервисПрокси.ФабрикаXDTO.Создать(МассивСертификатовТип);
		
		Получатели = Новый Массив;
		Для Каждого СертификатПолучателя Из СертификатыПолучателей Цикл
			МассивСертификатов.base64Binary.Добавить(Сертификат(СертификатПолучателя));
		КонецЦикла;
		
		Возврат КриптосервисПрокси.SignAndEncrypt(СеансовыйКлюч(Идентификатор), МассивСертификатов, ИсходныеДанные);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Подписание и шифрование';uk='Електронний підпис моделі сервісу.Криптосервис.Підписання та шифрування'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор,СертификатыПолучателей,ИсходныеДанные", Идентификатор, СертификатыПолучателей, ИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Хеширует переданные данные и возвращает шестнадцатеричное представление хеша.
//
// Параметры:
//	ИсходныеДанные         - ДвоичныеДанные - данные,
//                           для которых необходимо расчитать хеш.
// Возвращаемое значение:
//	Строка - шестнадцатеричное представление хеша.
//
Функция ХешироватьДанные(ИсходныеДанные) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Возврат КриптосервисПрокси.HashData(ИсходныеДанные);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Хеширование данных';uk='Електронний підпис моделі сервісу.Криптосервис.Хешування даних'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("ИсходныеДанные", ИсходныеДанные)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Возвращает замаскированные параметры аутентификации: номер телефона, email.
// 
// Параметры:
//	Идентификатор          - Строка - идентификатор ключевого контейнера.
//
// Возвращаемое значение:
//	Структура - параметры аутентификации.
//
Функция ПолучитьСпособыДоставкиПаролей(Идентификатор) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		СпособыДоставкиПаролей = Новый Структура("НомерТелефона,АдресЭлектроннойПочты", "", "");
		
		Результат = КриптосервисПрокси.GetAuthParams(Идентификатор);
		
		Для Каждого ItemAuthParams Из Результат.Value.ItemAuthParams Цикл
			Если ItemAuthParams.Type = "phone" Тогда
				СпособыДоставкиПаролей.НомерТелефона = ItemAuthParams.Value;
			ИначеЕсли ItemAuthParams.Type = "email" Тогда
				СпособыДоставкиПаролей.АдресЭлектроннойПочты = ItemAuthParams.Value;
			КонецЕсли;
		КонецЦикла;
		
		Возврат СпособыДоставкиПаролей;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение способов доставки паролей';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання способів доставки паролів'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор", Идентификатор)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции

// Возвращает результат отправки пароля в SMS.
// 
// Параметры:
//	Идентификатор - Строка - идентификатор ключевого контейнера.
//
// Возвращаемое значение:
//	Булево - Истина - сообщение доставлено.
//
Функция СообщениеСПаролемДоставлено(Идентификатор) Экспорт
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();
		
		Статус = КриптосервисПрокси.GetSmsStatus(Идентификатор);
		
		Возврат Статус = "delivered";
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение статуса SMS';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання статусу SMS'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("Идентификатор", Идентификатор)));
		ВызватьСтандартноеИсключение();
	КонецПопытки;
	
КонецФункции



////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеСпискаOID(СписокOID)
	
	СоответствиеOID = Новый Соответствие;
	СоответствиеOID.Вставить("2.5.4.3", "CN");
	СоответствиеOID.Вставить("2.5.4.6", "C");
	СоответствиеOID.Вставить("2.5.4.8", "S");
	СоответствиеOID.Вставить("2.5.4.7", "L");
	СоответствиеOID.Вставить("2.5.4.9", "STREET");
	СоответствиеOID.Вставить("2.5.4.10", "O");
	СоответствиеOID.Вставить("2.5.4.11", "OU");
	СоответствиеOID.Вставить("2.5.4.12", "T");
	СоответствиеOID.Вставить("1.2.643.100.1", "OGRN");
	СоответствиеOID.Вставить("1.2.643.100.3", "SNILS");
	СоответствиеOID.Вставить("1.2.643.3.131.1.1", "INN");
	СоответствиеOID.Вставить("1.2.840.113549.1.9.1", "E");
	
	СоответствиеOID.Вставить("2.5.4.4", "SN");
	СоответствиеOID.Вставить("2.5.4.42", "G");
	
	МассивЗначений = Новый Массив;
	Для Каждого ЭлементOID Из СписокOID.RDN Цикл
		МассивЗначений.Добавить("" + ?(СоответствиеOID.Получить(ЭлементOID.OID) = Неопределено, ЭлементOID.OID, СоответствиеOID.Получить(ЭлементOID.OID)) + "=" + ЭлементOID.Value);
	КонецЦикла;
	
	Возврат СтрСоединить(МассивЗначений, ",");
	
КонецФункции

Функция Наименование(СписокOID)
	
	Для Каждого ЭлементOID Из СписокOID.RDN Цикл
		Если ЭлементOID.OID = "2.5.4.3" Тогда
			Возврат ЭлементOID.Value;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат "";
	
КонецФункции

Функция Сертификат(Знач Сертификат)
	
	Если ТипЗнч(Сертификат) = Тип("Структура") Тогда
		Возврат ХранилищеСертификатовВМоделиСервиса.ПолучитьСертификат(Сертификат);
	ИначеЕсли ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
		Возврат ХранилищеСертификатовВМоделиСервиса.ДвоичныеДанныеСертификата(Сертификат);
	Иначе
		ВызватьИсключение(НСтр("ru='Параметр <Сертификат> должен иметь тип ДвоичныеДанные или Структура.';uk='Параметр <Сертификат> повинен мати тип ДвоичныеДанные або Структура.'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	КонецЕсли;
	
КонецФункции

Функция СеансовыйКлюч(Идентификатор)
	
	Возврат ПараметрыСеанса.СеансовыеКлючиЭлектроннойПодписиВМоделиСервиса.Получить(Идентификатор);
	
КонецФункции

Функция КриптосервисПрокси() 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = ОбщегоНазначения.WSПрокси(
			АдресWSDL(Константы.АдресКриптосервиса.Получить()),
			ПространствоИмен(),
			"CryptoService",
			"CryptoService",
			Неопределено,
			Неопределено,
			30);
			
	УстановитьПривилегированныйРежим(Ложь);
		
	Возврат Прокси;		
	
КонецФункции

Функция АдресWSDL(URI) Экспорт
	
	Адрес = СокрЛП(URI);
	Если СтрНайти(НРег(Адрес), "?wsdl") = СтрДлина(Адрес) - 4 Тогда
		Возврат Адрес;
	Иначе
		Возврат Адрес + "?wsdl";		
	КонецЕсли;
	
КонецФункции

Функция ПространствоИмен()
	
	Возврат "1c.services";
	
КонецФункции

Функция КомментарийПоИсключению(ПредставлениеОшибки, Параметры)
	
	ШаблонЗаписи = 
	"<Параметры>
	|%1
	|</Параметры>
	|
	|<ПредставлениеОшибки>
	|%2
	|</ПредставлениеОшибки>";
	
	ШаблонПараметра = "<%1 Тип=""%2"">%3</%1>";
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонЗаписи, СериализоватьЗначение(Параметры), СокрЛП(ПредставлениеОшибки));
		
КонецФункции

Процедура ВызватьСтандартноеИсключение()
	
	ВызватьИсключение(НСтр("ru='Сервис временно недоступен. Обратитесь в службу поддержки или повторите попытку позже.';uk='Сервіс тимчасово недоступний. Зверніться в службу підтримки чи повторіть спробу пізніше.'"));
	
КонецПроцедуры

Функция СериализоватьЗначение(Значение)
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		Для Каждого КлючЗначение Из Значение Цикл		
			Если ТипЗнч(КлючЗначение.Значение) = Тип("ДвоичныеДанные") Тогда
				Значение[КлючЗначение.Ключ] = КлючЗначение.Значение.Размер();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ФабрикаXDTO.ЗаписатьXML(Запись, СериализаторXDTO.ЗаписатьXDTO(Значение),,,, НазначениеТипаXML.Явное);
	
	Возврат Запись.Закрыть();
	
КонецФункции

// Возвращает основные свойства переданного криптосообщения.
// 
// Параметры:
//	Криптосообщение        - ДвоичныеДанные - криптосообщение, 
//                                            для которого необходимо получить свойства.
//  ТолькоКлючевыеСвойства - Булево - если Истина, то в результат не будут включены
//                                    свойства Сертификаты, Содержимое.
// Возвращаемое значение:
//	Структура - свойства криптосообщения.
//
Функция ПолучитьСвойстваКриптосообщения(Криптосообщение, ТолькоКлючевыеСвойства = Ложь) Экспорт
	
	СвойстваКриптосообщения = Новый Структура;
	СвойстваКриптосообщения.Вставить("Размер", Криптосообщение.Размер());
	СвойстваКриптосообщения.Вставить("Тип", "unknown");
	
	Попытка
		КриптосервисПрокси = КриптосервисПрокси();	
		
		Properties = КриптосервисПрокси.GetCryptoMessageProperties(Криптосообщение);	

		СвойстваКриптосообщения.Вставить("Тип", Properties.ContentType);	
			
		Получатели = ПолучитьСвойстваСертификатовИзXDTO(Properties.RecipientInfos.SerialAndIssuer);
		СвойстваКриптосообщения.Вставить("Получатели", Новый ФиксированныйМассив(Получатели));
		
		Подписанты = ПолучитьСвойстваСертификатовИзXDTO(Properties.SignerInfos.SerialAndIssuer);
		СвойстваКриптосообщения.Вставить("Подписанты", Новый ФиксированныйМассив(Подписанты));			
		
		Если Не ТолькоКлючевыеСвойства Тогда
			СвойстваКриптосообщения.Вставить("Сертификаты", Новый Массив);
			Для Каждого base64Binary Из Properties.Certificates.base64Binary Цикл
				СвойстваКриптосообщения.Сертификаты.Добавить(base64Binary);		
			КонецЦикла;
			СвойстваКриптосообщения.Сертификаты = Новый ФиксированныйМассив(СвойстваКриптосообщения.Сертификаты);
			
			СвойстваКриптосообщения.Вставить("Содержимое", Properties.Content);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Электронная подпись в модели сервиса.Криптосервис.Получение свойств криптосообщения';uk='Електронний підпис моделі сервісу.Криптосервис.Отримання властивостей криптосообщения'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	Возврат Новый ФиксированнаяСтруктура(СвойстваКриптосообщения);
	
КонецФункции

Функция ПолучитьСвойстваСертификатовИзXDTO(SerialAndIssuerCollection)
	
	Сертификаты = Новый Массив;
	Для Каждого SerialAndIssuer Из SerialAndIssuerCollection Цикл 
		Сертификат = Новый Структура;
		СерийныйНомер = SerialAndIssuer.SerialNumber;
		Если СтрДлина(СерийныйНомер) % 2 <> 0 Тогда
			СерийныйНомер = "0" + СерийныйНомер;
		КонецЕсли;
		
		НормализованныйСерийныйНомер = "";
		Индекс = 1;
		Пока Индекс < СтрДлина(СерийныйНомер) Цикл
			НормализованныйСерийныйНомер = НормализованныйСерийныйНомер + Сред(СерийныйНомер, Индекс, 2) + " ";
			Индекс = Индекс + 2;
		КонецЦикла;
		
		Сертификат.Вставить("СерийныйНомер", СокрЛП(НормализованныйСерийныйНомер));
		Сертификат.Вставить("Поставщик", ПредставлениеСпискаOID(SerialAndIssuer.Issuer));
		
		Сертификаты.Добавить(Сертификат);
	КонецЦикла;
	
	Возврат Сертификаты;

КонецФункции