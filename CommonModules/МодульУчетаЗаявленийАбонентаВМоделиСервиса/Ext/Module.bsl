﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействие с модулем учета заявлений абонента".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция Добавить(ДанныеЗаявления) Экспорт
	
	МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();	
	
	// Подготовка типов для создания объектов
	ЗаявлениеТип = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "Request");
	АбонентТип = ЗаявлениеТип.Свойства.Получить("Subscriber").Тип;
	ОрганизацияТип = ЗаявлениеТип.Свойства.Получить("Organization").Тип;
	ВладелецЭЦПСвойство = ЗаявлениеТип.Свойства.Получить("DigitalSignatureOwner");
	ВладелецЭЦПТип = ВладелецЭЦПСвойство.Тип;
	ДокументТип =  ВладелецЭЦПСвойство.Тип.Свойства.Получить("IdentityDocument").Тип;
	ПолучателиСвойство = ЗаявлениеТип.Свойства.Получить("Recipients");
	ПолучателиТип = ПолучателиСвойство.Тип;
	ПолучательТип = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "Recipient");
	ПолучательФНСТип = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "RecipientFNS");
	АдресТип = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "Address");
	
	
	// Заполнение XDTO-объекта
	// Request
	Заявление = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ЗаявлениеТип);
	
	// -> Subscriber
	Абонент = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(АбонентТип);
	
	Если ДанныеЗаявления.Свойство("Subscriber") Тогда
		Если ДанныеЗаявления.Subscriber.Свойство("Type") Тогда
			Абонент.Type = ДанныеЗаявления.Subscriber.Type;
		КонецЕсли;
		Если ДанныеЗаявления.Subscriber.Свойство("ApplicationID") Тогда
			Абонент.ApplicationID = ДанныеЗаявления.Subscriber.ApplicationID;
		КонецЕсли;
	КонецЕсли;
	
	// -> Organization
	Организация = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ОрганизацияТип);
	
	Если ДанныеЗаявления.Свойство("Organization") Тогда
		Если ДанныеЗаявления.Organization.Свойство("EmailAuth") Тогда
			Организация.EmailAuth = ДанныеЗаявления.Organization.EmailAuth;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Организация, ДанныеЗаявления.Organization,, "LegalAddress,ActualAddress");
		Если ДанныеЗаявления.Organization.Свойство("LegalAddress") И ЗначениеЗаполнено(ДанныеЗаявления.Organization.LegalAddress) Тогда
			ЮридическийАдрес = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(АдресТип);
			ЗаполнитьЗначенияСвойств(ЮридическийАдрес, ДанныеЗаявления.Organization.LegalAddress);
			Организация.LegalAddress = ЮридическийАдрес;
		КонецЕсли;
		
		Если ДанныеЗаявления.Organization.Свойство("ActualAddress") И ЗначениеЗаполнено(ДанныеЗаявления.Organization.ActualAddress) Тогда
			ФактическийАдрес = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(АдресТип);
			ЗаполнитьЗначенияСвойств(ФактическийАдрес, ДанныеЗаявления.Organization.ActualAddress);
			Организация.ActualAddress = ФактическийАдрес;	
		КонецЕсли;
	КонецЕсли;

	// -> DigitalSignatureOwner
	ВладелецЭЦП = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ВладелецЭЦПТип);
		
	// -> DigitalSignatureOwner -> IdentityDocument
	Если ДанныеЗаявления.Свойство("DigitalSignatureOwner") Тогда
		ЗаполнитьЗначенияСвойств(ВладелецЭЦП, ДанныеЗаявления.DigitalSignatureOwner,, "IdentityDocument");
		Если ДанныеЗаявления.DigitalSignatureOwner.Свойство("IdentityDocument") Тогда
			Документ = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ДокументТип);
			ЗаполнитьЗначенияСвойств(Документ, ДанныеЗаявления.DigitalSignatureOwner.IdentityDocument);
			
			ВладелецЭЦП.IdentityDocument = Документ;
		КонецЕсли;
	КонецЕсли;
	
	// -> Recipients
	Получатели = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ПолучателиТип);
	
	Для Каждого СтрокаТаблицы Из ДанныеЗаявления.Recipients Цикл
		Если СтрокаТаблицы.Свойство("KPP") Тогда
			Получатель = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ПолучательФНСТип);
		Иначе
			Получатель = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(ПолучательТип);
		КонецЕсли;
		
		Получатель.Type = СтрокаТаблицы.Type;
		Получатель.Code = ?(СтрокаТаблицы.Свойство("Code"), СтрокаТаблицы.Code, "");

		Если СтрокаТаблицы.Свойство("KPP") Тогда
			Получатель.KPP = СтрокаТаблицы.KPP;
		КонецЕсли;
				
		Получатели.Item.Добавить(Получатель);
	КонецЦикла;
	
	Заявление.Organization = Организация;
	Заявление.DigitalSignatureOwner = ВладелецЭЦП;	
	Заявление.Recipients = Получатели;
	Заявление.Subscriber = Абонент;
	
	ChangedAttributes = МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Создать(МодульУчетаЗаявленийПрокси.ФабрикаXDTO.Тип(ПространствоИмен(), "ChangedAttributes"));
	Если ДанныеЗаявления.Свойство("ChangedAttributes") Тогда
		Для Каждого ИзмененныйРеквизит Из ДанныеЗаявления.ChangedAttributes Цикл
			ChangedAttributes.Item.Добавить(XMLСтрока(ИзмененныйРеквизит));
		КонецЦикла;
	КонецЕсли;
	
	Заявление.ChangedAttributes = ChangedAttributes;
	
	Если ДанныеЗаявления.Свойство("RequestID") Тогда
		Заявление.RequestID = ДанныеЗаявления.RequestID;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("Type") Тогда
		Заявление.Type = ДанныеЗаявления.Type;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("CreateDate") Тогда
		Заявление.CreateDate = ДанныеЗаявления.CreateDate;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("CodeProduct1C") Тогда
		Заявление.CodeProduct1C = ДанныеЗаявления.CodeProduct1C;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("Version") Тогда
		Заявление.Version = ДанныеЗаявления.Version;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("KeyID") Тогда
		Заявление.KeyID = ДанныеЗаявления.KeyID;
	КонецЕсли;
	
	Если ДанныеЗаявления.Свойство("AbonentID") Тогда
		Заявление.AbonentID = ДанныеЗаявления.AbonentID;
	КонецЕсли;
	
	Возврат МодульУчетаЗаявленийПрокси.Add(Заявление);
	
КонецФункции

Функция ПолучитьСтатус(Идентификатор) Экспорт
	
	МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
	
	Ответ = МодульУчетаЗаявленийПрокси.GetStatus(Идентификатор);
	
	Результат = Новый Структура;
	Если Ответ.Status = "Исполняется" Тогда
		Результат.Вставить("Статус", Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено);
	ИначеЕсли Ответ.Status = "Отклонено" Тогда
		Результат.Вставить("Статус", Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено);
		Результат.Вставить("Пояснение", Ответ.Details);
	ИначеЕсли Ответ.Status = "Исполнено" Тогда
		Результат.Вставить("Статус", Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено);
		Результат.Вставить("ИдентификаторКлючевогоКонтейнера", Ответ.KeyID);
	КонецЕсли;
		
	Возврат Результат;

КонецФункции

Функция ПолучитьДействующиеКлючи(ИНН, КПП, ОбластьДанных) Экспорт
	
	МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
	
	AbonentKeys = МодульУчетаЗаявленийПрокси.GetAbonentKeys(ИНН, КПП, ОбластьДанных);
	
	ТаблицаКлючей = Новый ТаблицаЗначений;
	ТаблицаКлючей.Колонки.Добавить("Организация");
	ТаблицаКлючей.Колонки.Добавить("ВладелецЭЦП");
	ТаблицаКлючей.Колонки.Добавить("ТелефонМобильный");
	ТаблицаКлючей.Колонки.Добавить("Направления");
	ТаблицаКлючей.Колонки.Добавить("ИдентификаторПриложения");
	ТаблицаКлючей.Колонки.Добавить("ДействителенС");
	ТаблицаКлючей.Колонки.Добавить("ДействителенДо");
	ТаблицаКлючей.Колонки.Добавить("ИдентификаторКлюча");
	ТаблицаКлючей.Колонки.Добавить("ИдентификаторДокументооборота");
	ТаблицаКлючей.Колонки.Добавить("ИдентификаторАбонента");
	ТаблицаКлючей.Колонки.Добавить("Наименование");
	
	
	Если AbonentKeys.Item.Количество() > 0 Тогда
		Для Каждого AbonentKey Из AbonentKeys.Item Цикл
			НоваяСтрока = ТаблицаКлючей.Добавить();
			НоваяСтрока.Организация                   = AbonentKey.Organization;
			НоваяСтрока.ВладелецЭЦП                   = AbonentKey.DigitalSignatureOwner;
			НоваяСтрока.ТелефонМобильный              = AbonentKey.MobilePhone;
			НоваяСтрока.Направления                   = AbonentKey.Recipients;
			НоваяСтрока.ИдентификаторПриложения       = AbonentKey.ApplicationID;
			НоваяСтрока.ДействителенС                 = AbonentKey.ValidFrom;
			НоваяСтрока.ДействителенДо                = AbonentKey.ValidTo;
			НоваяСтрока.ИдентификаторДокументооборота = AbonentKey.RequestID;
			НоваяСтрока.ИдентификаторКлюча            = AbonentKey.KeyID;
			НоваяСтрока.ИдентификаторАбонента         = AbonentKey.AbonentID;
			НоваяСтрока.Наименование                  = AbonentKey.Name;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаКлючей;
	
КонецФункции

Функция НачатьИзменениеНомераТелефона(Идентификатор, НовыйНомерТелефона, ИдентификаторЗаявления) Экспорт
	
	МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
	
	Возврат МодульУчетаЗаявленийПрокси.BeginPhoneChange(
				Идентификатор, 
				КриптосервисВМоделиСервисаКлиентСервер.НомерТелефона(НовыйНомерТелефона),
				ИдентификаторЗаявления);
	
КонецФункции

Функция ЗавершитьИзменениеНомераТелефона(ИдентификаторЗаявления, НовыйНомерТелефона, КодПодтверждения1, КодПодтверждения2, ПарольКПриложению) Экспорт
	
	Если ПарольУказанВерно(ПарольКПриложению) Тогда
		МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
		
		Возврат МодульУчетаЗаявленийПрокси.EndPhoneChange(
					ИдентификаторЗаявления,
					КриптосервисВМоделиСервисаКлиентСервер.НомерТелефона(НовыйНомерТелефона), 
					КодПодтверждения1, 
					КодПодтверждения2);
	Иначе
		ВызватьИсключение(НСтр("ru='Неверный пароль';uk='Невірний пароль'"));
	КонецЕсли;
	
КонецФункции

Функция НачатьИзменениеАдресаЭлектроннойПочты(Идентификатор, НовыйАдресЭлектроннойПочты, ИдентификаторЗаявления) Экспорт
	
	МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
	
	Возврат МодульУчетаЗаявленийПрокси.BeginEmailChange(
				Идентификатор, 
				НовыйАдресЭлектроннойПочты,
				ИдентификаторЗаявления);
	
КонецФункции

Функция ЗавершитьИзменениеАдресаЭлектроннойПочты(ИдентификаторЗаявления, НовыйАдресЭлектроннойПочты, КодПодтверждения1, КодПодтверждения2, ПарольКПриложению) Экспорт
	
	Если ПарольУказанВерно(ПарольКПриложению) Тогда
		МодульУчетаЗаявленийПрокси = МодульУчетаЗаявленийПрокси();
		
		Возврат МодульУчетаЗаявленийПрокси.EndEmailChange(
					ИдентификаторЗаявления,
					НовыйАдресЭлектроннойПочты, 
					КодПодтверждения1, 
					КодПодтверждения2);
	Иначе
		ВызватьИсключение(НСтр("ru='Неверный пароль';uk='Невірний пароль'"));
	КонецЕсли;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция МодульУчетаЗаявленийПрокси() 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = ОбщегоНазначения.WSПрокси(
			Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить() + "/ws/Requests?wsdl",
			ПространствоИмен(),
			"Requests",,
			Константы.ИмяПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить(),
			Константы.ПарольПользователяСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить(),
			60,
		);
		
	УстановитьПривилегированныйРежим(Ложь);
		
	Возврат Прокси;
		
КонецФункции

Функция ПространствоИмен()
	
	Возврат "http://www.1c.ru/cloud-based-digital-signature/1.0/request";
	
КонецФункции

Функция ПарольУказанВерно(Пароль)
	
	Совпадают = Ложь;
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	ЭлектроннаяПодписьВМоделиСервисаСлужебный.СохраняемоеЗначениеСтрокиПароля(Пароль, ТекущийПользователь.УникальныйИдентификатор, Совпадают);
	
	Возврат Совпадают;
	
КонецФункции
