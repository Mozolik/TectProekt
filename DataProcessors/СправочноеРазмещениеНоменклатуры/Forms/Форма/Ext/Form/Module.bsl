﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияПоУмолчанию();
	
	Объект.ДокументПриемки = Параметры.ДокументПриемки;
	
	Если ЗначениеЗаполнено(Объект.ДокументПриемки) Тогда
	
		ЗаполнитьПоДокументуПриемкиСервер();
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Предусмотрено открытие формы только из документа приемки товаров на склад';uk='Передбачено відкриття форми тільки з документа приймання товарів на склад'");
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяЗакрытие И ЭтаФорма.Модифицированность Тогда
		Отказ = Истина;
		
		ПроверитьМодифицированность(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект));
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатМодифицированность, ДополнительныеПараметры) Экспорт
	
	Если РезультатМодифицированность = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть();
	ВыполняетсяЗакрытие = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОсновныеЯчейки

&НаКлиенте
Процедура ОсновныеЯчейкиПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ОсновныеЯчейки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Отбор = Новый ФиксированнаяСтруктура("Номенклатура, Склад",ТекущиеДанные.Номенклатура, ТекущиеДанные.Склад);
		Элементы.ДополнительныеЯчейки.ОтборСтрок = Отбор;
	Иначе
		Отбор = Новый ФиксированнаяСтруктура("Номенклатура, Склад",Неопределено, Неопределено);
		Элементы.ДополнительныеЯчейки.ОтборСтрок = Отбор;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеЯчейкиПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеЯчейкиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Отмена Тогда
		ТекущиеДанные = Элементы.ОсновныеЯчейки.ТекущиеДанные;
		ОбработатьНазначениеДополнительнойЯчейки(ТекущиеДанные.Номенклатура, ТекущиеДанные.Склад, ТекущиеДанные.Ячейка);
		Отбор = Новый ФиксированнаяСтруктура("Номенклатура, Склад",ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад);
		Элементы.ДополнительныеЯчейки.ОтборСтрок = Отбор;
		Элементы.ДополнительныеЯчейки.Обновить();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеЯчейкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	Если Элемент = ЭтаФорма.ТекущийЭлемент Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	Иначе
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеЯчейкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеЯчейкиЯчейкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ОсновныеЯчейки.ТекущиеДанные;
	ОбработатьНазначениеОсновнойЯчейки(ТекущиеДанные.Номенклатура, ТекущиеДанные.Склад, ТекущиеДанные.Ячейка, Ложь)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеЯчейки

&НаКлиенте
Процедура ДополнительныеЯчейкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	СтандартнаяОбработка = Ложь;
	Если Элементы.ДополнительныеЯчейки.ОтборСтрок = Неопределено
		Или Не ЗначениеЗаполнено(Элементы.ДополнительныеЯчейки.ОтборСтрок.Номенклатура) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.ДополнительныеЯчейки.ТекущиеДанные;
		ТекущиеДанные.Номенклатура = Элементы.ДополнительныеЯчейки.ОтборСтрок.Номенклатура;
		ТекущиеДанные.Склад        = Элементы.ДополнительныеЯчейки.ОтборСтрок.Склад;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиЯчейкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДополнительныеЯчейки.ТекущиеДанные;
	ОбработатьНазначениеДополнительнойЯчейки(ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад,ТекущиеДанные.Ячейка)
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	Если Элемент = ЭтаФорма.ТекущийЭлемент Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	Иначе
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЯчейкиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Отмена Тогда
		ТекущиеДанные = Элементы.ДополнительныеЯчейки.ТекущиеДанные;
		ОбработатьНазначениеОсновнойЯчейки(ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад,ТекущиеДанные.Ячейка, Истина);
		Элементы.ОсновныеЯчейки.Обновить();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СделатьЯчейкуОсновной(Команда)
	ТекущиеДанные = Элементы.ДополнительныеЯчейки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбработатьНазначениеОсновнойЯчейки(ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад, ТекущиеДанные.Ячейка, Истина);
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВРегистр(Команда)
	ЭтаФорма.Модифицированность = ЗаписатьВРегистрСервер();
КонецПроцедуры

&НаКлиенте
Процедура СделатьЯчейкуДополнительной(Команда)
	ТекущиеДанные = Элементы.ОсновныеЯчейки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбработатьНазначениеДополнительнойЯчейки(ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад, ТекущиеДанные.Ячейка);
		Отбор = Новый ФиксированнаяСтруктура("Номенклатура,Склад",ТекущиеДанные.Номенклатура,ТекущиеДанные.Склад);
		Элементы.ДополнительныеЯчейки.ОтборСтрок = Отбор;
		Элементы.ДополнительныеЯчейки.Обновить();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаданияНаОтборРазмещениеТоваров(Команда)
	
	ПроверитьМодифицированность(Новый ОписаниеОповещения("ПечатьЗаданияНаОтборРазмещениеТоваровЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаданияНаОтборРазмещениеТоваровЗавершение(РезультатМодифицированность, ДополнительныеПараметры) Экспорт
	
	Если РезультатМодифицированность = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(Объект.ДокументПриемки);
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ИмяФормы", "ЗаданиеНаРазмещение");
	ПараметрыПечати.Вставить("БезДопКолонки");		
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЗаданияНаОтборРазмещениеТоваров","ЗаданиеНаОтборРазмещениеТовара",Массив,ЭтаФорма,ПараметрыПечати);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеИИнициализация

&НаСервере
Процедура ЗаполнитьЗначенияПоУмолчанию()
	
	Объект.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Объект.Склад);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьПоДокументуПриемкиСервер()
	Объект.ОсновныеЯчейки.Очистить();
	Объект.ДополнительныеЯчейки.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.ДокументПриемки) Тогда
		Возврат;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект.ДокументПриемки);
	
	ОрдерностьПроверена     = Ложь;
	УказаниеЯчекекПроверено = Ложь;
	ПоказыватьКолонкуСклад  = Ложь;
	ЭтоВводОстатков			= Ложь;
	
	Если ТипОбъекта = Тип("ДокументСсылка.ОрдерНаПеремещениеТоваров") Тогда
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,ПомещениеПолучатель,Дата");
		Если НЕ ЗначениеЗаполнено(РеквизитыДокументаПриемки.ПомещениеПолучатель) Тогда
			ТекстСообщения = НСтр("ru='Для справочного размещения товаров в ячейках укажите в ордере помещение-получатель.';uk='Для довідкового розміщення товарів у комірках, вкажіть у ордері приміщення-одержувач.'");
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыДокументаПриемки);
		Объект.Помещение = РеквизитыДокументаПриемки.ПомещениеПолучатель;
		ОрдерностьПроверена = Истина;
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров") Тогда
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,Дата");
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыДокументаПриемки);
		СтруктураПараметров = Новый Структура("Склад",Объект.Склад);
		ПредставлениеСклада = СкладыСервер.ПолучитьПредставлениеСклада(Объект.Склад);
		
		Если СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Объект.Склад, Объект.Дата) Тогда
			
			ТекстСообщения = НСтр("ru='На складе ""%Склад%"" используется ордерная схема при отражении излишков, размещение нужно делать из ордера на отражение излишков товаров.';uk='На складі ""%Склад%"" використовується ордерна схема при відображенні надлишків, розміщення потрібно робити з ордера на відображення надлишків товарів.'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",ПредставлениеСклада);
			
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ОрдерностьПроверена = Истина;
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.СборкаТоваров")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПрочееОприходованиеТоваров")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") 
		//++ НЕ УТ
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ВозвратМатериаловИзПроизводства")
		//-- НЕ УТ
		Тогда
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,Дата");
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыДокументаПриемки);
		ОрдерностьПроверена = Ложь;
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "СкладПолучатель,Дата");
		Объект.Склад = РеквизитыДокументаПриемки.СкладПолучатель;
		Объект.Дата = РеквизитыДокументаПриемки.Дата;
		ОрдерностьПроверена = Ложь;
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		РеквизитыПоступления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,Дата");
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыПоступления);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПоступлениеТоваровУслугТовары.Склад
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ПО (ПоступлениеТоваровУслуг.Ссылка = ПоступлениеТоваровУслугТовары.Ссылка)
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка = &Ссылка
		|	И (НЕ ПоступлениеТоваровУслугТовары.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
		|			ИЛИ ПоступлениеТоваровУслуг.Дата < ПоступлениеТоваровУслугТовары.Склад.ДатаНачалаОрдернойСхемыПриПоступлении)
		|	И ПоступлениеТоваровУслугТовары.Склад.ИспользоватьАдресноеХранениеСправочно
		|	И (НЕ ПоступлениеТоваровУслугТовары.Склад.ИспользоватьАдресноеХранение
		|			ИЛИ ПоступлениеТоваровУслуг.Дата < ПоступлениеТоваровУслугТовары.Склад.ДатаНачалаАдресногоХраненияОстатков)";
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументПриемки);
		
		Если Запрос.Выполнить().Пустой() Тогда
			ТекстСообщения = НСтр("ru='Размещение из документа ""Поступление товаров и услуг"" можно делать, если в документе есть неордерные склады, на которых используется справочное деление на ячейки. В этом документе таких складов нет.';uk='Розміщення з документа ""Надходження товарів і послуг"" можна робити, якщо в документі є неордерні склади, на яких використовується довідкове поділ на комірки. У цьому документі таких складів немає.'");	
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ОрдерностьПроверена = Истина;
		УказаниеЯчекекПроверено = Истина;
		ПоказыватьКолонкуСклад = Истина;
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ВводОстатков") Тогда
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,Помещение,Дата,ТипОперации");
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыДокументаПриемки);
		ЭтоВводОстатков = Истина;		
		
		Если Не РеквизитыДокументаПриемки.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиСобственныхТоваров
				И Не РеквизитыДокументаПриемки.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиТоваровПолученныхНаКомиссию
				И Не РеквизитыДокументаПриемки.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВозвратнойТарыПринятойОтПоставщиков
				И Не РеквизитыДокументаПриемки.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ПереходНаИспользованиеСкладскихПомещений Тогда
			ТекстСообщения = НСтр("ru='Для документа ""%ВводОстатков%"" с типом операции ""%ТипОперации%"" размещение номенклатуры по ячейкам (справочно) недоступно.';uk='Для документа ""%ВводОстатков%"" з типом операції ""%ТипОперации%"" розміщення номенклатури по комірках (довідково) недоступно.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВводОстатков%", 	Метаданные.Документы.ВводОстатков.Синоним);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипОперации%", 	РеквизитыДокументаПриемки.ТипОперации);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
	Иначе
		
		РеквизитыДокументаПриемки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПриемки, "Склад,Помещение,Дата");
		ЗаполнитьЗначенияСвойств(Объект, РеквизитыДокументаПриемки);
		
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Склад, Помещение",Объект.Склад,Объект.Помещение);
	ПредставлениеСклада = СкладыСервер.ПолучитьПредставлениеСклада(Объект.Склад,Объект.Помещение);
	
	Если Не ОрдерностьПроверена
		И СкладыСервер.ИспользоватьОрдернуюСхемуПриПоступлении(Объект.Склад, Объект.Дата)
		И Не ЭтоВводОстатков
		И Не ТипОбъекта = Тип("ДокументСсылка.ПриходныйОрдерНаТовары") Тогда
			
			ТекстСообщения = НСтр("ru='На складе ""%Склад%"" используется ордерная схема при поступлении. Размещение по ячейкам нужно делать из приходного ордера.';uk='На складі ""%Склад%"" використовується ордерна схема при надходженні. Розміщення по комірках потрібно робити з прибуткового ордера.'");	
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",ПредставлениеСклада);
			
			ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Не УказаниеЯчекекПроверено Тогда
		
		Если Не СкладыСервер.ИспользоватьАдресноеХранениеСправочно(Объект.Склад, Объект.Помещение, Объект.Дата) Тогда
			ТекстСообщения = НСтр("ru='Для склада ""%Склад%"" не используется справочное деление на складские ячейки, поэтому невозможно указать ячейки для размещения.';uk='Для складу ""%Склад%"" не використовується довідковий поділ на складські комірки, тому неможливо зазначити комірки для розміщення.'");	
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",ПредставлениеСклада);
			ВызватьИсключение ТекстСообщения;
			
		КонецЕсли;
		
	КонецЕсли;
 
	Если ТипОбъекта = Тип("ДокументСсылка.СборкаТоваров")
		И Объект.ДокументПриемки.ТипОперации = Перечисления.ТипыОперацийЗаказаНаСборку.СборкаИзКомплектующих Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК НомерСтрокиДокумента,
		|	СборкаТоваров.Номенклатура КАК Номенклатура,
		|	&Склад КАК Склад,
		|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка КАК Ячейка,
		|	ЕСТЬNULL(РазмещениеНоменклатурыПоСкладскимЯчейкам.ОсновнаяЯчейка, ИСТИНА) КАК ОсновнаяЯчейка,
		|	СборкаТоваров.Характеристика КАК Характеристика
		|ИЗ
		|	Документ.СборкаТоваров КАК СборкаТоваров
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
		|		ПО СборкаТоваров.Номенклатура = РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура
		|			И (РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад = &Склад)
		|			И (РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение = &Помещение)
		|ГДЕ
		|	СборкаТоваров.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОсновнаяЯчейка УБЫВ";
		Запрос.УстановитьПараметр("Склад", Объект.Склад);
		Запрос.УстановитьПараметр("Помещение", Объект.Помещение);
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументПриемки);
	ИначеЕсли  ТипОбъекта = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")  Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументТовары.НомерСтроки КАК НомерСтрокиДокумента,
		|	ДокументТовары.Склад КАК Склад,
		|	ДокументТовары.Номенклатура КАК Номенклатура,
		|	ДокументТовары.Характеристика КАК Характеристика,
		|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка КАК Ячейка,
		|	ЕСТЬNULL(РазмещениеНоменклатурыПоСкладскимЯчейкам.ОсновнаяЯчейка, ИСТИНА) КАК ОсновнаяЯчейка
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ДокументТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
		|		ПО ДокументТовары.Номенклатура = РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура
		|			И (РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад = ДокументТовары.Склад)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ДокументПоступление
		|		ПО (ДокументПоступление.Ссылка = ДокументТовары.Ссылка)
		|ГДЕ
		|	ДокументТовары.Ссылка = &Ссылка
		|	И ДокументТовары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
		|	И ДокументТовары.Склад.ИспользоватьАдресноеХранениеСправочно
		|	И (НЕ ДокументТовары.Склад.ИспользоватьАдресноеХранение
		|			ИЛИ ДокументПоступление.Дата < ДокументТовары.Склад.ДатаНачалаАдресногоХраненияОстатков)
		|	И (НЕ ДокументТовары.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
		|			ИЛИ ДокументПоступление.Дата < ДокументТовары.Склад.ДатаНачалаОрдернойСхемыПриПоступлении)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументТовары.НомерСтроки,
		|	ОсновнаяЯчейка УБЫВ";
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументПриемки);
	Иначе	
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументТовары.НомерСтроки КАК НомерСтрокиДокумента,
		|	&Склад КАК Склад,
		|	ДокументТовары.Номенклатура КАК Номенклатура,
		|	ДокументТовары.Характеристика КАК Характеристика,
		|	РазмещениеНоменклатурыПоСкладскимЯчейкам.Ячейка КАК Ячейка,
		|	ЕСТЬNULL(РазмещениеНоменклатурыПоСкладскимЯчейкам.ОсновнаяЯчейка, ИСТИНА) КАК ОсновнаяЯчейка
		|ИЗ
		|	" + Объект.ДокументПриемки.Метаданные().ПолноеИмя() + ".Товары КАК ДокументТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеНоменклатурыПоСкладскимЯчейкам
		|		ПО ДокументТовары.Номенклатура = РазмещениеНоменклатурыПоСкладскимЯчейкам.Номенклатура
		|			И (РазмещениеНоменклатурыПоСкладскимЯчейкам.Склад = &Склад)
		|			И (РазмещениеНоменклатурыПоСкладскимЯчейкам.Помещение = &Помещение)
		|ГДЕ
		|	ДокументТовары.Ссылка = &Ссылка
		|	И ДокументТовары.Номенклатура.ТипНоменклатуры В
		|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументТовары.НомерСтроки,
		|	ОсновнаяЯчейка УБЫВ";
		
		Запрос.УстановитьПараметр("Склад", Объект.Склад);
		Запрос.УстановитьПараметр("Помещение", Объект.Помещение);
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументПриемки);
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбработанныйНомерСтроки = 0;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ОсновнаяЯчейка
			Или ОбработанныйНомерСтроки <> Выборка.НомерСтрокиДокумента Тогда
			// Если основная ячейка, или основная ячейка не назначена
			НоваяСтрока = Объект.ОсновныеЯчейки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если Не Выборка.ОсновнаяЯчейка Тогда
				НоваяСтрока.Ячейка = Справочники.СкладскиеЯчейки.ПустаяСсылка();
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Номенклатура", Выборка.Номенклатура);
				СтруктураПоиска.Вставить("Ячейка", Выборка.Ячейка);
				СтруктураПоиска.Вставить("Склад", Выборка.Склад);
			
				Если Объект.ДополнительныеЯчейки.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					ЗаполнитьЗначенияСвойств(Объект.ДополнительныеЯчейки.Добавить(), Выборка);
				КонецЕсли;
			КонецЕсли;
			ОбработанныйНомерСтроки = Выборка.НомерСтрокиДокумента;
		Иначе
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура", Выборка.Номенклатура);
			СтруктураПоиска.Вставить("Ячейка", Выборка.Ячейка);
			СтруктураПоиска.Вставить("Склад", Выборка.Склад);
			
			Если Объект.ДополнительныеЯчейки.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(Объект.ДополнительныеЯчейки.Добавить(), Выборка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "ЭтоГруппа") Тогда
		Элементы.Помещение.Видимость           = Ложь;
		Элементы.ОсновныеЯчейкиСклад.Видимость = Истина;
	Иначе
		Элементы.Помещение.Видимость           = СкладыСервер.ИспользоватьСкладскиеПомещения(Объект.Склад, Объект.Дата);
		Элементы.ОсновныеЯчейкиСклад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьВРегистрСервер()
	//Минимизируем количество наборов регистра, которые надо записывать
	//за счет того, что все ячейки по одной номенклатуре будем писать разом
	
	ТаблицаЯчеек = Объект.ОсновныеЯчейки.Выгрузить();
	ТаблицаЯчеек.Колонки.Добавить("ОсновнаяЯчейка", Новый ОписаниеТипов("Булево"));
	ТаблицаЯчеек.ЗаполнитьЗначения(Истина,"ОсновнаяЯчейка"); 
	
	Для каждого СтрТабл из Объект.ДополнительныеЯчейки Цикл
		
		НоваяСтрока = ТаблицаЯчеек.Добавить(); 
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрТабл);
		НоваяСтрока.ОсновнаяЯчейка = Ложь;
		
	КонецЦикла;
	
	ТаблицаЯчеек.Свернуть("Номенклатура,Склад,Ячейка, ОсновнаяЯчейка");
	ТаблицаЯчеек.Сортировать("Номенклатура");	
	
	ЕстьОшибки = Ложь;
	
	ТекНоменклатура = Неопределено;
	
	Набор = РегистрыСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам.СоздатьНаборЗаписей();
	
	Для Каждого СтрТабл из ТаблицаЯчеек Цикл
		
		Если ТекНоменклатура <> СтрТабл.Номенклатура Тогда
			
			Если ЗначениеЗаполнено(Набор.Отбор.Номенклатура.Значение) Тогда
				Попытка
					Набор.Записать(Истина);
				Исключение
					ЕстьОшибки = Истина;
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке().Описание);
				КонецПопытки;
			КонецЕсли;
			
			Набор = РегистрыСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам.СоздатьНаборЗаписей();
			Набор.Отбор.Склад.Установить(СтрТабл.Склад);
			Набор.Отбор.Помещение.Установить(Объект.Помещение);
			Набор.Отбор.Номенклатура.Установить(СтрТабл.Номенклатура);
			
			ТекНоменклатура = СтрТабл.Номенклатура;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрТабл.Ячейка) Тогда
			
			НоваяСтрока = Набор.Добавить();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрТабл);
			НоваяСтрока.Склад = СтрТабл.Склад;
			НоваяСтрока.Помещение = Объект.Помещение;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Набор.Отбор.Номенклатура.Значение) Тогда
		Попытка
			Набор.Записать(Истина);
		Исключение
			ЕстьОшибки = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке().Описание);
		КонецПопытки;
	КонецЕсли;
	
	Возврат ЕстьОшибки; 
КонецФункции

&НаКлиенте
Процедура ОбработатьНазначениеОсновнойЯчейки(Номенклатура, Склад,Ячейка, ДобавлятьВДополнительные)
	
	Если ЗначениеЗаполнено(Ячейка) Тогда
		
		ДопЯчейки = Объект.ДополнительныеЯчейки.НайтиСтроки(Новый Структура("Номенклатура,Склад, Ячейка",Номенклатура, Склад, Ячейка));
		
		Для Каждого СтрМас из ДопЯчейки Цикл
			Объект.ДополнительныеЯчейки.Удалить(СтрМас);
		КонецЦикла;
		
		ОснЯчейки =  Объект.ОсновныеЯчейки.НайтиСтроки(Новый Структура("Номенклатура, Склад",Номенклатура, Склад));
		
		Для Каждого СтрМас из ОснЯчейки Цикл
			Если ДобавлятьВДополнительные
				И ЗначениеЗаполнено(СтрМас.Ячейка) Тогда
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Номенклатура", СтрМас.Номенклатура);
				СтруктураПоиска.Вставить("Склад", СтрМас.Склад);
				СтруктураПоиска.Вставить("Ячейка", СтрМас.Ячейка);
				
				Если Объект.ДополнительныеЯчейки.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					ЗаполнитьЗначенияСвойств(Объект.ДополнительныеЯчейки.Добавить(), СтрМас);
				КонецЕсли;
			КонецЕсли;
			СтрМас.Ячейка = Ячейка;	
		КонецЦикла;
		Отбор = Новый ФиксированнаяСтруктура("Номенклатура, Склад",Номенклатура, Склад);
		Элементы.ДополнительныеЯчейки.ОтборСтрок = Отбор;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНазначениеДополнительнойЯчейки(Номенклатура,Склад, Ячейка)
	
	Если ЗначениеЗаполнено(Ячейка) Тогда
		
		ДопЯчейки = Объект.ДополнительныеЯчейки.НайтиСтроки(Новый Структура("Номенклатура,Склад, Ячейка",Номенклатура, Склад, Ячейка));
		
		Если ДопЯчейки.Количество() > 1 Тогда
			
			ПерваяСтрока = Истина;
			
			Для Каждого СтрМас из ДопЯчейки Цикл
				Если ПерваяСтрока Тогда
					ПерваяСтрока = Ложь;
				Иначе
					Объект.ДополнительныеЯчейки.Удалить(СтрМас);
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ДопЯчейки.Количество() = 0 Тогда
			
			НоваяСтрока = Объект.ДополнительныеЯчейки.Добавить();
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.Ячейка		 = Ячейка;
			НоваяСтрока.Склад		 = Склад;
			
		КонецЕсли;
		
		ОснЯчейки =  Объект.ОсновныеЯчейки.НайтиСтроки(Новый Структура("Номенклатура,Склад, Ячейка",Номенклатура, Склад, Ячейка));
		
		Для Каждого СтрМас из ОснЯчейки Цикл
			СтрМас.Ячейка = Неопределено;	
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьМодифицированность(ОповещениеПослеПроверки)
	Если ЭтаФорма.Модифицированность Тогда
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");
		
		ДополнительныеПараметры = Новый Структура("ОповещениеПослеПроверки", ОповещениеПослеПроверки);
		ПоказатьВопрос(Новый ОписаниеОповещения("ПроверитьМодифицированностьЗавершение", ЭтотОбъект, ДополнительныеПараметры), 
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНетОтмена,
			,
			КодВозвратаДиалога.Да);
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеПослеПроверки, ЭтаФорма.Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьМодифицированностьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтаФорма.Модифицированность = ЗаписатьВРегистрСервер();
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПроверки, ЭтаФорма.Модифицированность);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПроверки, Истина);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПроверки, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;