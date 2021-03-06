﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	Если КлючВарианта = "П2" Тогда
		
		
			
			
		
		Попытка
			
			СтандартнаяОбработка = Ложь;
			
			// Параметры документа
			ДокументРезультат.ТолькоПросмотр = Истина;
			ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЛичнаяКарточкаП2";
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
			ДокументРезультат.Очистить();
			ДокументРезультат.АвтоМасштаб = Истина;
			ДокументРезультат.НачатьАвтогруппировкуСтрок();
			
			НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
			НастройкиОтчета.Выбор.Элементы.Очистить();
			СоответствиеПользовательскихПолей = ЗарплатаКадрыОтчеты.СоответствиеПользовательскихПолей(НастройкиОтчета);
			ПроверитьЗначенияПараметров(НастройкиОтчета, Истина);
			
			ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
			Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартнаяДатаНачала") Тогда
				ДатаОтчета = ЗначениеПараметра.Значение.Дата;
			Иначе
				ДатаОтчета = ЗначениеПараметра.Значение;
			КонецЕсли;
			
			РаботникКадровойСлужбыРасшифровкаПодписи = "";
			ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РаботникКадровойСлужбы"));
			Если ЗначениеПараметра <> Неопределено
				И ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
				
				КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, ЗначениеПараметра.Значение, "ИОФамилия", ДатаОтчета);
				Если КадровыеДанные.Количество() > 0 Тогда
					РаботникКадровойСлужбыРасшифровкаПодписи = КадровыеДанные[0].ИОФамилия;
				КонецЕсли; 
				
			КонецЕсли; 
			
			Данные = Новый ДеревоЗначений;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			// Создадим и инициализируем процессор компоновки.
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(Данные);
			
			// Обозначим начало вывода
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			Группировки = ОтчетыКлиентСервер.ПолучитьПоляГруппировок(ЭтотОбъект.КомпоновщикНастроек);
			
			ВывестиМакетыСГруппировкамиП2(ДокументРезультат, Данные, Группировки, ДатаОтчета, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
			
			ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='В настройку отчета внесены критичные изменения. Отчет не будет сформирован.';uk='У настройку звіту внесені критичні зміни. Звіт не буде сформований.'") + " " + Инфо.Описание;
		КонецПопытки;
		
	ИначеЕсли КлючВарианта = "П6" Тогда
		Попытка
			
			СтандартнаяОбработка = Ложь;
			
			// Параметры документа
			ДокументРезультат.ТолькоПросмотр = Истина;
			ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТиповаяФормаП6";
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
			ДокументРезультат.Очистить();
			ДокументРезультат.АвтоМасштаб = Истина;
			ДокументРезультат.НачатьАвтогруппировкуСтрок();
			
			НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
			НастройкиОтчета.Выбор.Элементы.Очистить();
			СоответствиеПользовательскихПолей = ЗарплатаКадрыОтчеты.СоответствиеПользовательскихПолей(НастройкиОтчета);
			ПроверитьЗначенияПараметров(НастройкиОтчета, Истина);
			
			ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
			Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартнаяДатаНачала") Тогда
				ДатаОтчета = ЗначениеПараметра.Значение.Дата;
			Иначе
				ДатаОтчета = ЗначениеПараметра.Значение;
			КонецЕсли;
			
			Данные = Новый ДеревоЗначений;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			// Создадим и инициализируем процессор компоновки.
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(Данные);
			
			// Обозначим начало вывода
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			Группировки = ОтчетыКлиентСервер.ПолучитьПоляГруппировок(ЭтотОбъект.КомпоновщикНастроек);
			
			ВывестиМакетыСГруппировкамиП2(ДокументРезультат, Данные, Группировки, ДатаОтчета, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
			
			ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='В настройку отчета внесены критичные изменения. Отчет не будет сформирован.';uk='У настройку звіту внесені критичні зміни. Звіт не буде сформований.'") + " " + Инфо.Описание;
		КонецПопытки;
		
		
		
	Иначе	
		
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		ПроверитьЗначенияПараметров(НастройкиОтчета);
		
		СтандартнаяОбработка = ложь;
		
		ДокументРезультат.Очистить();
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
		
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "СхемаИнициализирована" Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = "СхемаИнициализирована";
		
	КонецЕсли;
	
КонецПроцедуры

// Личная карточка П-2

Процедура ВывестиМакетыСГруппировкамиП2(ДокументРезультат, Данные, Группировки, ДатаОтчета, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта)
	
	Если Группировки.Количество() > 0 Тогда
	
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
		
			ПолеДанных = Группировки[0].Значение;
			ВывестиГруппировкуП2(ДокументРезультат, СтрокаДанных, ПолеДанных, 0, СоответствиеПользовательскихПолей);
			ВывестиВложенныеГруппировкиСМакетамиП2(ДокументРезультат, СтрокаДанных, Группировки, 1, ДатаОтчета, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
		
		КонецЦикла;
		
	Иначе
		
		ДополнительныеСведения = КадровыйУчет.ДополнительныеСведенияУнифицированнойФормыТ2(Данные.Строки, ДатаОтчета, КлючВарианта);
		
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
			
			ВывестиМакетП2(ДокументРезультат, СтрокаДанных, 0, ДатаОтчета, ДополнительныеСведения, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
			
			Если СтрокаДанных <> Данные.Строки.Получить(Данные.Строки.Количество() - 1) Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиВложенныеГруппировкиСМакетамиП2(ДокументРезультат, Данные, Группировки, Уровень, ДатаОтчета, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта)
	
	Если Группировки.Количество() > Уровень Тогда 
		
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
		
			ПолеДанных = Группировки[Уровень].Значение;
			ВывестиГруппировкуП2(ДокументРезультат, СтрокаДанных, ПолеДанных, Уровень,  СоответствиеПользовательскихПолей);
			ВывестиВложенныеГруппировкиСМакетамиП2(ДокументРезультат, СтрокаДанных, Группировки, Уровень + 1, ДатаОтчета,  СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
		
		КонецЦикла;
		
	Иначе
		
		ДополнительныеСведения = КадровыйУчет.ДополнительныеСведенияУнифицированнойФормыТ2(Данные.Строки, ДатаОтчета, КлючВарианта);
		
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
			
			ВывестиМакетП2(ДокументРезультат, СтрокаДанных, Уровень, ДатаОтчета, ДополнительныеСведения,  СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиГруппировкуП2(ДокументРезультат, СтрокаДанных, Поле, Уровень, СоответствиеПользовательскихПолей)
	
	МакетГруппировки  = УправлениеПечатью.МакетПечатнойФормы("Отчет.ОтчетыПоСотрудникам.ПФ_MXL_UK_ЛичнаяКарточка");
	ОбластьГруппировки = МакетГруппировки.ПолучитьОбласть("Группировка");
	
	ДоступноеПоле = ОтчетыКлиентСервер.ПолучитьДоступноеПоле(КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок, Новый ПолеКомпоновкиДанных(Поле));
	
	ОбластьГруппировки.Параметры.НазваниеПараметра = ДоступноеПоле.Заголовок;
	ОбластьГруппировки.Параметры.Значение = СтрокаДанных[СтрЗаменить(Поле, ".", "")];
	
	ДокументРезультат.Вывести(ОбластьГруппировки, Уровень);
	
КонецПроцедуры 

Процедура ВывестиМакетП2(ДокументРезультат, СтрокаДанных, Уровень, ДатаОтчета, ДополнительныеСведения, СоответствиеПользовательскихПолей, РаботникКадровойСлужбыРасшифровкаПодписи, КлючВарианта) 
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ОтчетыПоСотрудникам.ПФ_MXL_UK_ЛичнаяКарточка");
	
	Шапка									= Макет.ПолучитьОбласть("Шапка");
	ОбластьОсновныеСведения					= Макет.ПолучитьОбласть("ОсновныеСведения");
	
	ЗаголовокОбразование					= Макет.ПолучитьОбласть("ЗаголовокОбразование");
	ШапкаОбразование						= Макет.ПолучитьОбласть("ШапкаОбразование");
	СтрокаОбразование						= Макет.ПолучитьОбласть("СтрокаОбразование");
	ШапкаОбразование1						= Макет.ПолучитьОбласть("ШапкаОбразование1");
	СтрокаОбразование1						= Макет.ПолучитьОбласть("СтрокаОбразование1");
	
	ЗаголовокПоследипломноеОбразование		= Макет.ПолучитьОбласть("ЗаголовокПоследипломноеОбразование");
	ШапкаПоследипломноеОбразование			= Макет.ПолучитьОбласть("ШапкаПоследипломноеОбразование");
	СтрокаПоследипломноеОбразование			= Макет.ПолучитьОбласть("СтрокаПоследипломноеОбразование");
	
	ВоинскийУчет							= Макет.ПолучитьОбласть("ВоинскийУчет");
	
	ШапкаПрофОбразование					= Макет.ПолучитьОбласть("ШапкаПрофОбразование");
	СтрокаПрофОбразование					= Макет.ПолучитьОбласть("СтрокаПрофОбразование");
	
	ШапкаПенсия								= Макет.ПолучитьОбласть("ШапкаПенсия");
	СтрокаПенсия							= Макет.ПолучитьОбласть("Пенсия");
	
	СтрокаСемейноеПоложение					= Макет.ПолучитьОбласть("СтрокаСемейноеПоложение");
	
	СтрокаСтажи								= Макет.ПолучитьОбласть("Стажи");
	
	ТрудоваяДеятельность			        = Макет.ПолучитьОбласть("ТрудоваяДеятельность");
	ТрудоваяДеятельностьДатаОкончания       = Макет.ПолучитьОбласть("ТрудоваяДеятельностьДатаОкончания");
	
	ШапкаСоставСемьи						= Макет.ПолучитьОбласть("ШапкаСоставСемьи");
	СтрокаСоставСемьи						= Макет.ПолучитьОбласть("СтрокаСоставСемьи");
	
	АдресаДокументы							= Макет.ПолучитьОбласть("АдресаДокументы");
	ПодвалДополнительныеСведения			= Макет.ПолучитьОбласть("ПодвалДополнительныеСведения");
	
	ШапкаОтпуска							= Макет.ПолучитьОбласть("ШапкаОтпуска");
	СтрокаОтпуска							= Макет.ПолучитьОбласть("СтрокаОтпуска");
	
	ШапкаПриемыПеремещения					= Макет.ПолучитьОбласть("ШапкаПриемыПеремещения");
	СтрокаПриемыПеремещения					= Макет.ПолучитьОбласть("СтрокаПриемыПеремещения");
	ПодвалПриемыПеремещения                 = Макет.ПолучитьОбласть("ПодвалПриемыПеремещения");
	ПриемыПеремещенияКоличествоСтрок		= 10;
	
	ПодвалДополнительныеСведения.Параметры.РаботникКадровойСлужбыРасшифровкаПодписи = РаботникКадровойСлужбыРасшифровкаПодписи;
	
	Шапка.Параметры.ДатаАктуальности   = ДатаОтчета;
	ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Шапка, СтрокаДанных, СоответствиеПользовательскихПолей);
	Шапка.Параметры.Заполнить(СтрокаДанных);
	
	Если СтрокаДанных.ЛичныеДанныеПол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской") Тогда
		Шапка.Параметры.ЛичныеДанныеПол = "чоловіча";
	ИначеЕсли СтрокаДанных.ЛичныеДанныеПол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский") Тогда
		Шапка.Параметры.ЛичныеДанныеПол = "жіноча";
	Иначе
	КонецЕсли;
	
	ОбластьОсновныеСведения.Параметры.Заполнить(СтрокаДанных);
	ОбластьОсновныеСведения.Параметры.Гражданство = СтрокаДанных.ЛичныеДанныеСтрана;
	
	Если ЗначениеЗаполнено(СтрокаДанных.ЛичныеДанныеСтрана) И СтрокаДанных.ЛичныеДанныеСтрана <> Справочники.СтраныМира.Украина Тогда
		ОбластьОсновныеСведения.Параметры.Гражданство = ОбластьОсновныеСведения.Параметры.Гражданство + " (" + СтрокаДанных.ЛичныеДанныеСтрана + ")";
	КонецЕсли; 

	ДокументРезультат.Вывести(Шапка, Уровень+1);
	ДокументРезультат.Вывести(ОбластьОсновныеСведения, Уровень+1);
	
	ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(ОбластьОсновныеСведения, СтрокаДанных, СоответствиеПользовательскихПолей);
	// Данные об образовании	
	ЗаголовокОбразование.Параметры.Заполнить(СтрокаДанных);
	ДокументРезультат.Вывести(ЗаголовокОбразование, Уровень+1);
	
	ОбластиДополнительныхСтрок = Новый Массив;
	
	ДокументРезультат.Вывести(ШапкаОбразование, Уровень+1);
	
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеОбразования");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			4, ОбластиДополнительныхСтрок, ШапкаОбразование, СтрокаОбразование);
			
	ДокументРезультат.Вывести(ШапкаОбразование1, Уровень+1);
	
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			4, ОбластиДополнительныхСтрок, ШапкаОбразование1, СтрокаОбразование1);
			
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеОбразованияПрочие");		
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	Если ДанныеЗаполненияПоСотруднику.Количество() > 0	Тогда
		Если ДанныеЗаполненияПоСотруднику[0].ВидОбразования = ПредопределенноеЗначение("Справочник.ВидыОбразованияФизическихЛиц.Аспирантура") Тогда
			ЗаголовокПоследипломноеОбразование.Параметры.Аспирантура = "х"	
		ИначеЕсли ДанныеЗаполненияПоСотруднику[0].ВидОбразования = ПредопределенноеЗначение("Справочник.ВидыОбразованияФизическихЛиц.ОрдинатураАдъюнктура") Тогда
			ЗаголовокПоследипломноеОбразование.Параметры.Адъюнктура = "х"	
		ИначеЕсли ДанныеЗаполненияПоСотруднику[0].ВидОбразования = ПредопределенноеЗначение("Справочник.ВидыОбразованияФизическихЛиц.Докторантура") Тогда
			ЗаголовокПоследипломноеОбразование.Параметры.Докторантура = "х"
		КонецЕсли;	
	КонецЕсли;	
	ДокументРезультат.Вывести(ЗаголовокПоследипломноеОбразование);
	ДокументРезультат.Вывести(ШапкаПоследипломноеОбразование, Уровень+1);
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			3, ОбластиДополнительныхСтрок, ШапкаПоследипломноеОбразование, СтрокаПоследипломноеОбразование);
			
	// Трудовая деятельность		
	ТрудоваяДеятельность.Параметры.Заполнить(СтрокаДанных);
	ДокументРезультат.Вывести(ТрудоваяДеятельность, Уровень+1);

	// Информация о стажах
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеЗаполненияСтажи");
	ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
	Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	КонецЕсли;

	Для Каждого СтрокаДанныхСтажа Из ДанныеЗаполненияПоСотруднику Цикл
		Если СтрокаДанныхСтажа.СтажВид.КатегорияСтажа = ПредопределенноеЗначение("Перечисление.КатегорииСтажа.Общий") Тогда
			СтрокаСтажи.Параметры.Дата = Формат(СтрокаДанных.ПараметрыДанныхПериод, "ДЛФ=DD");
			СтрокаСтажи.Параметры.ДнейСтажа = СтрокаДанныхСтажа.СтажДней;
			СтрокаСтажи.Параметры.МесяцевСтажа = СтрокаДанныхСтажа.СтажМесяцев;
			СтрокаСтажи.Параметры.ЛетСтажа = СтрокаДанныхСтажа.СтажЛет;
		ИначеЕсли СтрокаДанныхСтажа.СтажВид.КатегорияСтажа = ПредопределенноеЗначение("Перечисление.КатегорииСтажа.ВыслугаЛет") Тогда	
			СтрокаСтажи.Параметры.Дата = Формат(СтрокаДанных.ПараметрыДанныхПериод, "ДЛФ=DD");
			СтрокаСтажи.Параметры.ДнейВыслуга = СтрокаДанныхСтажа.СтажДней;
			СтрокаСтажи.Параметры.МесяцевВыслуга = СтрокаДанныхСтажа.СтажМесяцев;
			СтрокаСтажи.Параметры.ЛетВыслуга = СтрокаДанныхСтажа.СтажЛет;
		КонецЕсли;	
	КонецЦикла;
	ДокументРезультат.Вывести(СтрокаСтажи, Уровень+1);
			
	//Трудовая деятельность		
	ТрудоваяДеятельностьДатаОкончания.Параметры.Заполнить(СтрокаДанных);
	ДокументРезультат.Вывести(ТрудоваяДеятельностьДатаОкончания, Уровень+1);
	
	// Сведения о пенсионерах	
	ДокументРезультат.Вывести(ШапкаПенсия, Уровень+1);
	Если СтрокаДанных.Пенсионер = Истина Тогда
		СтрокаПенсия.Параметры.Пенсия = "є пенсіонером";
	Иначе
		СтрокаПенсия.Параметры.Пенсия = "не є пенсіонером";
	КонецЕсли;
	ДокументРезультат.Вывести(СтрокаПенсия, Уровень+1);

	// Семейное положение
	СтрокаСемейноеПоложение.Параметры.Заполнить(СтрокаДанных);
	ДокументРезультат.Вывести(СтрокаСемейноеПоложение, Уровень+1);
	
	// Состав семьи
	МассивЗаголовков = Новый Массив;
	МассивЗаголовков.Добавить(ШапкаСоставСемьи);
	ДокументРезультат.Вывести(ШапкаСоставСемьи, Уровень+1);
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеЗаполненияСоставСемьи");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			5, ОбластиДополнительныхСтрок, ШапкаСоставСемьи, СтрокаСоставСемьи);

	// Сведения об образовании
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеОбразования");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	// АДРЕСА
	СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(СтрокаДанных.ЛичныеДанныеКонтактнаяИнформацияАдресМестаПроживания);
	Если СтруктураАдреса.Свойство("Представление") Тогда
		АдресаДокументы.Параметры.АдресФактический = СтруктураАдреса.Представление;
	КонецЕсли;	
	
	СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(СтрокаДанных.ЛичныеДанныеКонтактнаяИнформацияАдресПоПрописке);  
	Если СтруктураАдреса.Свойство("Представление") Тогда
		АдресаДокументы.Параметры.АдресПоПрописке = СтруктураАдреса.Представление;
	КонецЕсли;
	
	ВидыДокументовПаспорта = ВидыДокументовФизическихЛицПаспортаПоКодам();
	
	// ПАСПОРТ
	Если ЗначениеЗаполнено(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументВид) Тогда
		
		Если Не ВидыДокументовПаспорта.Найти(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументВид) = Неопределено Тогда
		
			АдресаДокументы.Параметры.ДокументСерия = НСтр("ru='серия';uk='серія'") + " " + ?(ЗначениеЗаполнено(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументСерия),СтрокаДанных.ЛичныеДанныеУдостоверениеДокументСерия,"");
			АдресаДокументы.Параметры.ДокументНомер = ?(ЗначениеЗаполнено(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументНомер),СтрокаДанных.ЛичныеДанныеУдостоверениеДокументНомер,"");
			АдресаДокументы.Параметры.ДокументДатаВыдачи = Формат(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументДатаВыдачи, "ДЛФ=DD");
			АдресаДокументы.Параметры.ДокументКемВыдан = ?(ЗначениеЗаполнено(СокрЛП(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументКемВыдан)), СокрЛП(СтрокаДанных.ЛичныеДанныеУдостоверениеДокументКемВыдан),"") ;
			
		КонецЕсли;
		
	КонецЕсли;
	ДокументРезультат.Вывести(АдресаДокументы, Уровень + 1);
	
	// Воинский учет
	// згідно п.42 Постанови №921 від 07.12.16 р. для призовників:
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВоинскийУчет") Тогда
		Если СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетОтношениеКВоинскойОбязанности = ПредопределенноеЗначение("Перечисление.ОтношениеКВоинскойОбязанности.Призывник") Тогда
			ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетГруппаУчета = "Призовник";
			ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетСпецУчет = СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетСпецУчет;
			// згідно п.41 Постанови №921 від 07.12.16 р. для офіцерів запасу:
		ИначеЕсли Не (СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетСостав = NULL) Тогда
			Если СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетСостав.ОфицерскийСостав Тогда
				ВоинскийУчет.Параметры.Заполнить(СтрокаДанных);
				ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетГруппаУчета = "";
				ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетГодность = "";
			КонецЕсли	
		Иначе
			ВоинскийУчет.Параметры.Заполнить(СтрокаДанных);
		КонецЕсли;
		// згідно п.43 Постанови №921 від 07.12.16 р. для  виключених з військового обліку за віком:
		Если СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетОтметкаОСнятиеСУчета = ПредопределенноеЗначение("Перечисление.ОтношениеКВоинскомуУчету.СнятПоВозрасту") Тогда
			ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетОтметкаОСнятиеСУчета = "Виключений з військового обліку за віком";
		Иначе
			ВоинскийУчет.Параметры.ЛичныеДанныеВоинскийУчетВоинскийУчетОтметкаОСнятиеСУчета = "";
		КонецЕсли;
		
		Категория = ""; КатегорияИРеквизитыВоенногоБилета1 = ""; КатегорияИРеквизитыВоенногоБилета2 = "";			
		СтрокаКатегорияИРеквизитыВоенногоБилета = "";
		Если ЗначениеЗаполнено(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетКатегорияЗапаса) Тогда
			Категория = Строка(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетКатегорияЗапаса);
			СтрокаКатегорияИРеквизитыВоенногоБилета = Категория + ?(СокрЛП(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетРеквизитыВоенногоБилета)="","",", " + СокрЛП(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетРеквизитыВоенногоБилета));
		Иначе
			СтрокаКатегорияИРеквизитыВоенногоБилета = ?(СокрЛП(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетРеквизитыВоенногоБилета)="","",СокрЛП(СтрокаДанных.ЛичныеДанныеВоинскийУчетВоинскийУчетРеквизитыВоенногоБилета));
		КонецЕсли;	
		МассивДлинСтрок = Новый Массив;
		МассивДлинСтрок.Добавить(27);
		МассивДлинСтрок.Добавить(42);
		
		РезультирующаяСтрокаКатегорияИРеквизитыВоенногоБилета = ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(СтрокаКатегорияИРеквизитыВоенногоБилета, МассивДлинСтрок);
		Для Счетчик = 1 По ?(СтрЧислоСтрок(РезультирующаяСтрокаКатегорияИРеквизитыВоенногоБилета) <= 2, СтрЧислоСтрок(РезультирующаяСтрокаКатегорияИРеквизитыВоенногоБилета), 2)  Цикл
			ВоинскийУчет.Параметры["КатегорияИРеквизитыВоенногоБилета"+Счетчик] = СтрЗаменить(СтрПолучитьСтроку(РезультирующаяСтрокаКатегорияИРеквизитыВоенногоБилета, Счетчик),Символы.ПС, "");  
		КонецЦикла;

	КонецЕсли;
	ДокументРезультат.Вывести(ВоинскийУчет);
	
	// Профобразование 
	МассивЗаголовков = Новый Массив;
	МассивЗаголовков.Добавить(ШапкаПрофОбразование);
	ДокументРезультат.Вывести(ШапкаПрофОбразование, Уровень+1);

	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеПовышенияКвалификаций");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.ЛичныеДанныеФизическоеЛицо);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;

	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			5, ОбластиДополнительныхСтрок, ШапкаПрофОбразование, СтрокаПрофОбразование);
			
	ОбластиДополнительныхСтрок = Новый Массив;
	МассивПодвалов = Новый Массив;
	
	// Прием на работу и переводы на другую работу.
	МассивЗаголовков = Новый Массив;
	МассивЗаголовков.Добавить(ШапкаПриемыПеремещения);
	
	ДокументРезультат.Вывести(ШапкаПриемыПеремещения, Уровень+1);
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеЗаполненияКадровойИстории");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.РабочееМестоСотрудник);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
		ПриемыПеремещенияКоличествоСтрок, ОбластиДополнительныхСтрок, ШапкаПриемыПеремещения, СтрокаПриемыПеремещения,,МассивПодвалов);
	ДокументРезультат.Вывести(ПодвалПриемыПеремещения, Уровень + 1);
	
	// Отпуск
	МассивЗаголовков = Новый Массив;
	МассивЗаголовков.Добавить(ШапкаОтпуска);
	ДокументРезультат.Вывести(ШапкаОтпуска, Уровень+1);
	ДанныеЗаполнения = ДополнительныеСведения.Получить("ДанныеЗаполненияОтпуска");
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполненияПоСотруднику = Новый Массив;
	Иначе
		ДанныеЗаполненияПоСотруднику = ДанныеЗаполнения.Получить(СтрокаДанных.РабочееМестоСотрудник);
		Если ДанныеЗаполненияПоСотруднику = Неопределено Тогда
			ДанныеЗаполненияПоСотруднику = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	ЗарплатаКадры.СформироватьОбластьТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ДанныеЗаполненияПоСотруднику,
			10, ОбластиДополнительныхСтрок, ШапкаОтпуска, СтрокаОтпуска, МассивЗаголовков, МассивПодвалов);
			
	
	// Информация об увольнении
	ПодвалДополнительныеСведения.Параметры.Заполнить(СтрокаДанных);
	
	Если ЗначениеЗаполнено(СтрокаДанных.РабочееМестоПриказОбУвольненииДата) ИЛИ ЗначениеЗаполнено(СтрокаДанных.РабочееМестоДатаУвольнения) Тогда
		
		Если ЗначениеЗаполнено(СтрокаДанных.РабочееМестоПриказОбУвольненииДата) Тогда
			ПриказОбУвольненииДатаПредставление = Формат(СтрокаДанных.РабочееМестоПриказОбУвольненииДата, "ДЛФ=DD");
		Иначе
			ПриказОбУвольненииДатаПредставление = Формат(СтрокаДанных.РабочееМестоДатаУвольнения, "ДЛФ=DD");
		КонецЕсли;
		
	КонецЕсли;
	
	ДокументРезультат.Вывести(ПодвалДополнительныеСведения, Уровень + 1);
	
	ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	
	//ЗарплатаКадры.ВывестиОбластиТабличногоДокументаСОграниченнымНаборомСтрок(ДокументРезультат, ОбластиДополнительныхСтрок);
	
КонецПроцедуры

Функция ВидыДокументовФизическихЛицПаспортаПоКодам()
	
	ПаспортаПоКодам = Новый Массив;
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.Паспорт);
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.ДипломатическийПаспорт);
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.ВодительскоеУдостоверение);
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.Паспорт);
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.Загранпаспорт);
	ПаспортаПоКодам.Добавить(Справочники.ВидыДокументовФизическихЛиц.СвидетельствоОРождении);
	
	Возврат ПаспортаПоКодам;
	
КонецФункции

	
	
	
		
	
	
	
	
		
	


////////////////////////////////////////////////////////////////////////////////
// Универсальные процедуры и Функции.

Процедура ПроверитьЗначенияПараметров(НастройкиОтчета, ВыводитьПодписантов = Ложь)
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));

	Если ЗначениеПараметра <> Неопределено Тогда
		
		УстановитьДатуОтчета = Ложь;
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("Неопределено") Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли;
		
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("Дата")
			И ЗначениеПараметра.Значение = '00010101' Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли; 
		
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартнаяДатаНачала")
			И Дата(ЗначениеПараметра.Значение) = '00010101' Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли; 
		
		Если УстановитьДатуОтчета Тогда
			ЗначениеПараметра.Значение = ТекущаяДатаСеанса();
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ВыводитьПодписантов Тогда
		
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РаботникКадровойСлужбы"));
		Если НЕ ЗначениеПараметра.Использование Тогда
			ЗначениеПараметра.Значение = Неопределено;
		КонецЕсли; 
		ЗначениеПараметра.Использование = Истина;
		
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьРаботникаКадровойСлужбы"));
		Если НЕ ЗначениеПараметра.Использование Тогда
			ЗначениеПараметра.Значение = Неопределено;
		КонецЕсли; 
		ЗначениеПараметра.Использование = Истина;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли