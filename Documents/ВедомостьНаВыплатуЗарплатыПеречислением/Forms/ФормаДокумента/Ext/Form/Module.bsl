﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ВзаиморасчетыССотрудникамиФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	ЗарплатаКадрыРасширенный.ПроверитьЗаполнениеТабличныхЧастейВедомостей(Объект, Отказ);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи); 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	СпособВыплатыПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОснованийНажатие(Элемент, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьПредставлениеОснованийНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОкруглениеПриИзменении(Элемент)
	ОкруглениеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроцентВыплатыПриИзменении(Элемент)
	ПроцентВыплатыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПорядокЗаполненияНалоговПриИзменении(Элемент)
	ПроцентВыплатыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура БухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ВнешниеХозяйственныеОперации

&НаКлиенте
Процедура ПеречислениеНДФЛВыполненоПриИзменении(Элемент)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьПеречислениеНДФЛВыполненоПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьСоставВыбор(ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ВзаиморасчетыССотрудникамиКлиент.ВедомостьПодобрать(ЭтаФорма);
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьСоставПередУдалением(ЭтаФорма, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СоставБанковскийСчетПриИзменении(Элемент)
	СоставПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставБанковскийСчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);	
	
	ПараметрВыбораВладельцаСчета = Новый ПараметрВыбора("Отбор.Владелец", ТекущаяСтрока.ФизическоеЛицо);
	
	Элемент.ПараметрыВыбора = 
		Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрВыбораВладельцаСчета)); 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Заполнить(Команда)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗаполнить(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьПодобрать(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗарплату(Команда)
	РедактироватьЗарплатуСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛ(Команда)
	РедактироватьНДФЛСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНДФЛ(Команда)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьОбновитьНДФЛ(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьОплатаПоказать(ЭтаФорма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВзносы(Команда)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьОбновитьВзносы(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВзносы(Команда)
	РедактироватьВзносыТаблицы();	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область ВызовыСервера

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьОрганизацияПриИзмененииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура СпособВыплатыПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьСпособВыплатыПриИзмененииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОкруглениеПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПараметрыРасчетаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПроцентВыплатыПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПараметрыРасчетаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиФормы.ВедомостьСоставОбработкаВыбораНаСервере(ЭтаФорма, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаСервере
Процедура СоставПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьСоставПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьСоставПослеУдаленияНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПодписантПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

#КонецОбласти

#Область ОбратныеВызовы

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьЗаполнитьПервоначальныеЗначения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПриПолученииДанныхНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПриПолученииДанныхСтрокиСостава(ЭтаФорма, СтрокаСостава)
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьУстановитьДоступностьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьОбработатьСообщенияПользователю(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей() Экспорт
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Бухгалтер");
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьУстановитьПредставлениеОплаты(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьЗаполнитьНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников() Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормы.ВедомостьАдресСпискаПодобранныхСотрудников(ЭтаФорма)
КонецФункции

&НаКлиенте
Процедура РедактироватьЗарплатуСтроки(ДанныеСтроки) Экспорт
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьРедактироватьЗарплатуСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьРедактироватьЗарплатуСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьРедактироватьНДФЛСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьРедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормы.ВедомостьАдресВХранилищеЗарплатыПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьАдресВХранилищеНДФЛПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Процедура ОбновитьНДФЛНаСервере(ИдентификаторыСтрок) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьОбновитьНДФЛНаСервере(ЭтаФорма, ИдентификаторыСтрок)
КонецПроцедуры

&НаСервере
Процедура ОбновитьВзносыНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьОбновитьВзносыНаСервере(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВзносыТаблицы() Экспорт
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьРедактироватьВзносыТаблицы(ЭтаФорма);	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеВзносы() Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьАдресВХранилищеВзносы(ЭтаФорма)
КонецФункции	

&НаСервере
Процедура РедактироватьВзносыТаблицыЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьРедактироватьВзносыТаблицыЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

#КонецОбласти

#КонецОбласти
