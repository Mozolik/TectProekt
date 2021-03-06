﻿
#Область ПрограммныйИнтерфейс

#Область ЗаказыНаПередачуВПроизводство

//++ НЕ УТ
Функция СоздатьЗаказыНаПередачуВПроизводство(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура();
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрыФормы.Вставить("Заказ", ОписаниеКоманды.ОбъектыОснований);
	Иначе
		ПараметрыФормы.Вставить("Заказ", ОписаниеКоманды.ОбъектыОснований[0]);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ФормированиеЗаказовНаПередачуВПроизводствоНаОсновании.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецФункции
//-- НЕ УТ

#КонецОбласти

#Область ЗаказыПоставщикам

Функция СозданиеЗаказовПоставщикамНаОсновании(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ВводНаОснованииУТВызовСервера.ПроверитьВозможностьВводаНаОсновании(ОписаниеКоманды.ОбъектыОснований[0]);
	ПараметрыФормы = Новый Структура("ДокументОснование", ОписаниеКоманды.ОбъектыОснований[0]);
	ОткрытьФорму(
		"Документ.ЗаказПоставщику.Форма.СозданиеЗаказовПоставщикамНаОсновании", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецФункции

#КонецОбласти

#Область СообщениеПоШаблону

Функция СоздатьПисьмоПоШаблону(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПредназначенДляЭлектронныхПисем", Истина);
	ПараметрыФормы.Вставить("Основание", ОписаниеКоманды.ОбъектыОснований[0]);
	ОткрытьФорму("Обработка.СообщениеПоШаблону.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);

КонецФункции

Функция СоздатьСообщениеSMSПоШаблону(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПредназначенДляЭлектронныхПисем", Ложь);
	ПараметрыФормы.Вставить("Основание", ОписаниеКоманды.ОбъектыОснований[0]);
	ОткрытьФорму("Обработка.СообщениеПоШаблону.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецФункции

#КонецОбласти 

#Область СчетНаОплату
	
Функция СоздатьСчетНаОплату(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура("ДокументОснование", ОписаниеКоманды.ОбъектыОснований[0]);
	
	ОткрытьФорму(
		"Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецФункции

Функция СоздатьСчетНаОплатуРеализацияАкт(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);

	ПараметрыОткрытияФормы = ВводНаОснованииУТВызовСервера.СчетНаОплатуРеализацияАктПолучитьПараметрыОткрытияФормы(ОписаниеКоманды.ОбъектыОснований[0]);
	
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='%Документ% оформлена по нескольким заказам. Необходимо ввести счет на оплату на основании заказов.';uk='%Документ% оформлена за кількома замовленнями. Необхідно ввести рахунок на оплату на підставі замовлень.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ОписаниеКоманды.ОбъектыОснований[0]);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ОткрытьФорму(
		ПараметрыОткрытияФормы.ИмяФормы,
		ПараметрыОткрытияФормы.ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецФункции
		
Функция СоздатьСчетНаОплатуПоДоговору(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Если НЕ ВводНаОснованииУТВызовСервера.СчетНаОплатуПоДоговоруПроверитьВозможностьСозданияСчетовНаОплату(ПараметрКоманды) Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не требуется вводить счет на оплату на основании договора %1. Расчеты ведутся по заказам / накладным.';uk='Не потрібно вводити рахунок на оплату на підставі договору %1. Розрахунки ведуться за замовленнями / накладними.'"),
			ПараметрКоманды);
		ВызватьИсключение Текст;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ДокументОснование", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	

КонецФункции

Функция СоздатьСчетНаОплатуПредоплатаПоДоговору(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Если Не ВводНаОснованииУТВызовСервера.СчетНаОплатуПоДоговоруПроверитьВозможностьСозданияСчетовНаОплату(ПараметрКоманды) Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не требуется вводить счет на оплату на основании договора %1. Расчеты ведутся по заказам / накладным.';uk='Не потрібно вводити рахунок на оплату на підставі договору %1. Розрахунки ведуться за замовленнями / накладними.'"),
			ПараметрКоманды);
		ВызватьИсключение Текст;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.СчетНаОплатуКлиенту.Форма.ФормаДокумента",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецФункции

//++ НЕ УТКА

Функция СоздатьСчетНаОплатуЗаказДавальца(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ДокументОснование", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецФункции

Функция СоздатьСчетНаОплатуОтчетДавальцу(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ПараметрыОткрытияФормы = ВводНаОснованииУТВызовСервера.СчетНаОплатуОтчетДавальцуПолучитьПараметрыОткрытияФормы(ПараметрКоманды);
	
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='%Документ% оформлен по нескольким заказам. Необходимо ввести счет на оплату на основании заказов.';uk='%Документ% оформлена за кількома замовленнями. Необхідно ввести рахунок на оплату на підставі замовлень.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПараметрКоманды);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ОткрытьФорму(
		ПараметрыОткрытияФормы.ИмяФормы,
		ПараметрыОткрытияФормы.ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецФункции

//-- НЕ УТКА

#КонецОбласти

#Область ДокументыНаОснованииЗаказа

Функция АктВыполненныхРаботСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.АктВыполненныхРаботПараметрыОткрытияФормы(ОписаниеКоманды.ОбъектыОснований);
	Если ПараметрыОткрытия <> Неопределено Тогда
	
		ОткрытьФорму(
			"Документ.АктВыполненныхРабот.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	КонецЕсли;

КонецФункции

Функция ВнутреннееПотреблениеТоваровСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.ВнутреннееПотреблениеТоваровПараметрыОткрытияФормы(ПараметрКоманды);
	Если ПараметрыОткрытия.РезультатыПроверки.ЕстьОшибки Тогда
		
		НакладныеКлиент.СообщитьОбОшибкахЗаполненияВнутреннейНакладной(ПараметрыОткрытия.РезультатыПроверки.ТекстОшибки);
		
	Иначе
		
		ОткрытьФорму(
			"Документ.ВнутреннееПотреблениеТоваров.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	КонецЕсли;
	
КонецФункции

Функция ПоступлениеТоваровУслугСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.ПоступлениеТоваровУслугПараметрыОткрытияФормы(ПараметрКоманды);
	Если ПараметрыОткрытия = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента",
		ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции

Функция СборкаТоваровСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);

	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.СборкаТоваровПараметрыОткрытияФормы(ПараметрКоманды);
	Если ПараметрыОткрытия.РезультатыПроверки.ЕстьОшибки Тогда
		
		НакладныеКлиент.СообщитьОбОшибкахЗаполненияВнутреннейНакладной(ПараметрыОткрытия.РезультатыПроверки.ТекстОшибки);
		
	Иначе
		
		ОткрытьФорму(
			"Документ.СборкаТоваров.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	КонецЕсли;
	
КонецФункции

Функция РеализацияТоваровУслугСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"ОбщийМодуль.ВводНаОснованииУТКлиент.РеализацияТоваровУслугСоздатьНаОснованииЗаказа");
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.РеализацияТоваровУслугПараметрыОткрытияФормы(ОписаниеКоманды.ОбъектыОснований);
	
	Если НЕ ПараметрыОткрытия = Неопределено Тогда
	
		ОткрытьФорму(
			"Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	КонецЕсли;
		
КонецФункции

Функция ПеремещениеТоваровСоздатьНаОснованииЗаказа(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);

	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ПараметрыОткрытия = ВводНаОснованииУТВызовСервера.ПеремещениеТоваровПараметрыОткрытияФормы(ПараметрКоманды);
	Если ПараметрыОткрытия.РезультатыПроверки.ЕстьОшибки Тогда
		
		НакладныеКлиент.СообщитьОбОшибкахЗаполненияВнутреннейНакладной(ПараметрыОткрытия.РезультатыПроверки.ТекстОшибки);
		
	Иначе
		
		ОткрытьФорму(
			"Документ.ПеремещениеТоваров.Форма.ФормаДокумента",
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Документооборот

Функция ИнтеграцияС1СДокументооборотСоздатьПисьмо(ОписаниеКоманды) Экспорт

	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИнтеграцияС1СДокументооборотСоздатьПисьмоПроверитьПодключениеЗавершение",
		ЭтотОбъект,
		ПараметрКоманды);
		
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(ОписаниеОповещения);
	
КонецФункции 

&НаКлиенте
Процедура ИнтеграцияС1СДокументооборотСоздатьПисьмоПроверитьПодключениеЗавершение(Результат, ОбъектИС) Экспорт
	
	Если Результат = Истина Тогда // авторизация успешна
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ИнтеграцияС1СДокументооборотСоздатьПисьмоПоискСвязанногоОбъектаЗавершение", ЭтотОбъект, ОбъектИС);
		ИнтеграцияС1СДокументооборотКлиент.НачатьПоискСвязанногоОбъектаДО(ОбъектИС, ОписаниеОповещения);
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru='Не настроено подключение к Документообороту или сервис
            |Документооборота недоступен. Обратитесь к администратору.'
            |;uk='Не настроєно підключення до Документообігу або сервіс
            |Документообігу недоступний. Зверніться до адміністратора.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтеграцияС1СДокументооборотСоздатьПисьмоПоискСвязанногоОбъектаЗавершение(Результат, ОбъектИС) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Предмет", Результат);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", Параметры);
	
КонецПроцедуры

Функция ИнтеграцияС1СДокументооборотСоздатьБизнесПроцесс(ОписаниеКоманды) Экспорт

	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИнтеграцияС1СДокументооборотСоздатьБизнесПроцессПроверитьПодключениеЗавершение",
		ЭтотОбъект,
		ПараметрКоманды);
		
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(ОписаниеОповещения);
	
КонецФункции 

&НаКлиенте
Процедура ИнтеграцияС1СДокументооборотСоздатьБизнесПроцессПроверитьПодключениеЗавершение(Результат, ОбъектИС) Экспорт
	
	Если Результат = Истина Тогда // авторизация успешна
		
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцесс(ОбъектИС);
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru='Не настроено подключение к Документообороту или сервис
            |Документооборота недоступен. Обратитесь к администратору.'
            |;uk='Не настроєно підключення до Документообігу або сервіс
            |Документообігу недоступний. Зверніться до адміністратора.'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СогласованиеПродажи

Функция СоздатьНовоеСогласованиеЗаказаКлиента(ОписаниеКоманды) Экспорт

	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		Основание = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		Основание = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ОткрытьФорму("БизнесПроцесс.СогласованиеПродажи.ФормаОбъекта",
	Новый Структура("Основание", Основание),
	,
	,);

КонецФункции 

#КонецОбласти 

#Область СогласованиеЗакупки

Функция СоздатьНовоеСогласованиеЗаказаПоставщику(ОписаниеКоманды) Экспорт

	ОткрытьФорму("БизнесПроцесс.СогласованиеЗакупки.ФормаОбъекта",
	Новый Структура("Основание",ОписаниеКоманды.ОбъектыОснований),
	,
	,);

КонецФункции 

#КонецОбласти 


Функция СозданиеСвязанныхОбъектов(ОписаниеКоманды) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	ПараметрыВыполненияКоманды.Источник = ОписаниеКоманды.Форма;
	
	ДополнительныеОтчетыИОбработкиКлиент.ОткрытьФормуКомандДополнительныхОтчетовИОбработок(
		ОписаниеКоманды.ОбъектыОснований,
		ПараметрыВыполненияКоманды,
		ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиСозданиеСвязанныхОбъектов());

КонецФункции 

Функция ОпределитьСправочноеРазмещениеПоЯчейкам(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДокументПриемки",ПараметрКоманды);
	ОткрытьФорму("Обработка.СправочноеРазмещениеНоменклатуры.Форма.Форма",Параметры,ПараметрыВыполненияКоманды.Источник,ПараметрКоманды);

КонецФункции

Функция ПередачаВЭксплуатациюНаОсновании(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Основание = Новый Структура;
	Основание.Вставить("ДокументОснование", ПараметрКоманды);
	Основание.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию"));
	
	ПараметрыФормы = Новый Структура("Основание", Основание);
	
	ОткрытьФорму(
		"Документ.ВнутреннееПотреблениеТоваров.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции

Функция СписаниеНаРасходыАктивыНаОсновании(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Основание = Новый Структура;
	Основание.Вставить("ДокументОснование", ПараметрКоманды);
	Основание.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию"));
	
	ПараметрыФормы = Новый Структура("Основание", Основание);
	
	ОткрытьФорму(
		"Документ.ВнутреннееПотреблениеТоваров.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции

//++ НЕ УТКА
Функция СоздатьНаОснованииМаршрутныхЛистов(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ТекстПредупреждения = Неопределено;
	ПараметрыОформления = ВводНаОснованииУТВызовСервера.ВыпускПродукцииПараметрыОформленияВыпуска(ПараметрКоманды, ТекстПредупреждения);
	Если ПараметрыОформления = Неопределено Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеРаспоряжений = Новый Массив;
	Для каждого Ссылка Из ПараметрКоманды Цикл
		СтруктураРаспоряжения = Новый Структура("Распоряжение", Ссылка);
		ДанныеРаспоряжений.Добавить(СтруктураРаспоряжения);
	КонецЦикла;
	
	// Откроем форму
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("РеквизитыШапки",     ПараметрыОформления);
	ПараметрыОснования.Вставить("ДанныеРаспоряжений", ДанныеРаспоряжений);
	
	ОткрытьФорму("Документ.ВыпускПродукции.ФормаОбъекта", Новый Структура("Основание", ПараметрыОснования));

КонецФункции
//-- НЕ УТКА

//++ НЕ УТКА
Функция СоздатьНаОснованииСпецификации(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ЗначенияЗаполнения = Новый Структура("МассивОбъектов, ТипОснования", ПараметрКоманды, Тип("СправочникСсылка.РесурсныеСпецификации"));
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.ПлановаяКалькуляция.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции
//-- НЕ УТКА

Функция СоздатьНаОснованииРасходныйОрдерНаТовары(ОписаниеКоманды) Экспорт
	
	ОчиститьСообщения();
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	МассивРаспоряжений = ПараметрКоманды;
		
	ОткрытьФорму("Обработка.УправлениеОтгрузкой.Форма.ФормаНастроекСозданияОрдеров",Новый Структура("МассивРаспоряжений",МассивРаспоряжений),,,,,);	
	
КонецФункции

Функция АктНаПередачуПрав(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента";
	
	ПараметрыОснования = Новый Структура;
	
	ПараметрыОснования.Вставить("ДокументОснование",   ПараметрКоманды);
	ПараметрыОснования.Вставить("ЗаполнятьПоОстаткам", Истина);
	ПараметрыОснования.Вставить("ВариантОформленияПродажи",
	ПредопределенноеЗначение("Перечисление.ВариантыОформленияПродажи.АктНаПередачуПрав"));
	
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", ПараметрыОснования));

КонецФункции

Функция СоздатьЗаказНаВнутреннееПотребление(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидСоздаваемыхДокументов", "ЗаказНаВнутреннееПотребление");
	ПараметрыФормы.Вставить("ДокументОснование", ПараметрКоманды);
	ОткрытьФорму("Обработка.ПомощникФормированияСкладскихДокументовПоВыводуИзАссортимента.Форма.Форма",
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно);

КонецФункции 

Функция СоздатьЗаказНаПеремещение(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидСоздаваемыхДокументов", "ЗаказНаПеремещение");
	ПараметрыФормы.Вставить("ДокументОснование", ПараметрКоманды);
	ОткрытьФорму("Обработка.ПомощникФормированияСкладскихДокументовПоВыводуИзАссортимента.Форма.Форма",
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно);
КонецФункции

Функция УстановитьПараметрыОбеспеченияПотребностей(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("Документ", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор, Источник", СтруктураОтбора, "ИзменениеАссортимента");
	ОткрытьФорму("Обработка.ПараметрыОбеспеченияПотребностей.Форма", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
		
КонецФункции
	
Функция ПомощникОформленияСкладскихАктов(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ПересчетТоваров") Тогда
		РезультатПроверки = ВводНаОснованииУТВызовСервера.ПроверитьСтатусПересчетаНаСервере(ПараметрКоманды);
		Если Не РезультатПроверки.МожноОткрытьПомощник Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.СообщениеПользователю);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму("Обработка.ПомощникОформленияСкладскихАктов.Форма", 
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
		
КонецФункции

//++ НЕ УТКА
Функция ОтгрузкаПоМаршрутнымЛистам(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ПараметрыФормы = Новый Структура("СписокМаршрутныхЛистов", ПараметрКоманды);
	ОткрытьФорму("Обработка.ВводКорректировкиЗаказаМатериалов.Форма.КорректировкаЗаказаМатериалов", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно, 
					ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции
//-- НЕ УТКА

//++ НЕ УТКА
Функция КорректировкаЗаказаМатериалов(ОписаниеКоманды) Экспорт
	
	Перем ТекстПредупреждения;
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;

	Если НЕ ВводНаОснованииУТВызовСервера.ВводКорректировкиДоступен(ПараметрКоманды, ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СписокЗаказов", ПараметрКоманды);
	ОткрытьФорму("Обработка.ВводКорректировкиЗаказаМатериалов.Форма", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецФункции
//-- НЕ УТКА

//++ НЕ УТКА
Функция СозданиеВыработкиСотрудников(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	Иначе
		ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований[0];
	КонецЕсли;
	
	МассивРаспоряжений = Новый Массив;
	МассивРаспоряжений.Добавить(ПараметрКоманды);
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.МаршрутныйЛистПроизводства") Тогда
		
		Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(ПараметрКоманды, "Статус, УправлениеМаршрутнымиЛистами, Проведен");
		
		ЕстьОшибкиСтатус =  Не (
			Реквизиты.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполняется")
			Или Реквизиты.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен")
			Или (
				(Реквизиты.УправлениеМаршрутнымиЛистами = ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование")
				ИЛИ Реквизиты.УправлениеМаршрутнымиЛистами = ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.РегистрацияОпераций"))
				И Реквизиты.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.КВыполнению")
				)
			);
		
		ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Производство");
		
	Иначе
		
		Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(ПараметрКоманды, "Статус, Проведен");
		
		ЕстьОшибкиСтатус =  Не (Реквизиты.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовНаРемонт.Выполняется")
			Или Реквизиты.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаказовНаРемонт.Закрыт"));
		
		ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Ремонт");
		
	КонецЕсли;
	
	ЕстьОшибкиПроведен = Не Реквизиты.Проведен;
	
	Если ЕстьОшибкиПроведен Тогда
		
		ТекстОшибки = НСтр("ru='Документ %Документ% не проведен. Ввод на основании непроведенного документа запрещен.';uk='Документ %Документ% не проведено. Введення на підставі непроведенного документа заборонене.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПараметрКоманды);
		
		ВызватьИсключение ТекстОшибки;
		
	ИначеЕсли ЕстьОшибкиСтатус Тогда
		
		ТекстОшибки = НСтр("ru='Документ %Документ% находится в статусе ""%Статус%"". Ввод на основании запрещен.';uk='Документ %Документ% знаходиться в статусі ""%Статус%"". Введення на підставі заборонене.'");
		
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПараметрКоманды);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%",   Реквизиты.Статус);
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.ОформитьВыработкуСотрудниковПоРаспоряжениям(МассивРаспоряжений, ВидНаряда);
	
КонецФункции
//-- НЕ УТКА

//++ НЕ УТ
Функция СписанияЗатратНаВыпускНаОснованииВыпусковПродукции(ОписаниеКоманды) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрКоманды = ОписаниеКоманды.ОбъектыОснований;
	
	ТекстОшибки = ВводНаОснованииУТВызовСервера.СписаниеЗатратНаВыпускПроверитьОбъектыОснований(ПараметрКоманды);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПоказатьПредупреждение(,ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	ФормаНового = ПолучитьФорму("Документ.СписаниеЗатратНаВыпуск.ФормаОбъекта",
		,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	ОбъектФормы = ФормаНового.Объект;
	Результат = ВводНаОснованииУТВызовСервера.СписаниеЗатратНаВыпускПараметрыВводаНаОсновании(ПараметрКоманды, ОбъектФормы);
	
	Если Результат.Свойство("ОткрытьФормуНового") Тогда
		
		КопироватьДанныеФормы(ОбъектФормы, ФормаНового.Объект);
		ФормаНового.ОбновитьПриОткрытии = Истина;
		ФормаНового.Открыть();
	
	ИначеЕсли Результат.СписокДокументов.Количество() = 0 Тогда
		
		ОткрытьФорму("Документ.СписаниеЗатратНаВыпуск.ФормаОбъекта",
			Новый Структура("Основание", Результат),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	ИначеЕсли Результат.СписокДокументов.Количество() > 0 Тогда
		
		ОткрытьФорму("Документ.СписаниеЗатратНаВыпуск.Форма.ПодтверждениеНовыхДокументов",
			Новый Структура("СписокДокументов", Результат.СписокДокументов),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	Иначе
		
		ПоказатьПредупреждение(,НСтр("ru='Команда не может быть выполнена для указанного объекта.';uk='Команда не може бути виконана для зазначеного об''єкта.'"));
		
	КонецЕсли;
	
КонецФункции

//-- НЕ УТ

#Область КорректировкаНазначения

Функция ОткрытьМастерСнятияРезерва(ОписаниеКоманды) Экспорт
	
	ПараметрыФормыЗаполнения = Новый Структура();
	ПараметрыФормыЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.СнятьРезерв"));
	ПараметрыФормыЗаполнения.Вставить("Мастер", Истина);
	ПараметрыФормыЗаполнения.Вставить("Заказ", ОписаниеКоманды.ОбъектыОснований[0]);
	
	ОткрытьФорму("Обработка.ЗаполнениеКорректировкиНазначения.Форма.ФормаОбъекта", ПараметрыФормыЗаполнения, ОписаниеКоманды.Форма);
	
КонецФункции

Функция ОткрытьМастерРезервирования(ОписаниеКоманды) Экспорт
	
	ПараметрыФормыЗаполнения = Новый Структура();
	ПараметрыФормыЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.Резервировать"));
	ПараметрыФормыЗаполнения.Вставить("Мастер", Истина);
	ПараметрыФормыЗаполнения.Вставить("Заказ", ОписаниеКоманды.ОбъектыОснований[0]);
	
	ОткрытьФорму("Обработка.ЗаполнениеКорректировкиНазначения.Форма.ФормаОбъекта", ПараметрыФормыЗаполнения, ОписаниеКоманды.Форма);
	
КонецФункции

#КонецОбласти

Функция СоздатьРасходныйКассовыйОрдер(ОписаниеКоманды) Экспорт
	
	ФинансыКлиент.СоздатьДокументОплатыНаОснованииЗаявокНаРасходДС(
		ОписаниеКоманды.Форма.Элементы.Список,
		"РасходныйКассовыйОрдер");
	
КонецФункции

Функция СоздатьСписаниеБезналичныхДС(ОписаниеКоманды) Экспорт
	
	ФинансыКлиент.СоздатьДокументОплатыНаОснованииЗаявокНаРасходДС(
		ОписаниеКоманды.Форма.Элементы.Список,
		"СписаниеБезналичныхДенежныхСредств");
	
КонецФункции

Функция ПоручениеЭкспедитору(ОписаниеКоманды) Экспорт
	
	ОткрытьФорму("Документ.ПоручениеЭкспедитору.Форма.ФормаДокумента",
		Новый Структура("Основание", ОписаниеКоманды.ОбъектыОснований));	
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
