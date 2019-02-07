﻿////////////////////////////////////////////////////////////////////////////////
// СотрудникиВнутренний: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийФормыСотрудника

Процедура СотрудникиПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СотрудникиФормыРасширенный.СотрудникиПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СотрудникиПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СотрудникиФормыРасширенный.СотрудникиПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

Процедура СотрудникиПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыРасширенный.СотрудникиПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

Процедура СотрудникиОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	СотрудникиФормыРасширенный.СотрудникиОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормыФизическогоЛица

Процедура ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СотрудникиФормыРасширенный.ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

Процедура ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыРасширенный.ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
	
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиМодулейОбъектаИМенеджера

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	СотрудникиФормыРасширенный.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	СотрудникиФормыРасширенный.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ДобавитьКомандыПечатиСправочникуСотрудники(КомандыПечати) Экспорт
	
	СотрудникиФормыРасширенный.ДобавитьКомандыПечатиСправочникуСотрудники(КомандыПечати);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиМодулейОбъектаИМенеджера

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СотрудникиФормыРасширенный.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Процедура ОбновитьРежимыРаботыФормы() Экспорт
	
	СотрудникиФормыРасширенный.ОбновитьРежимыРаботыФормы();
	
КонецПроцедуры

Процедура ПроверитьНеобходимостьНастройкиРежимовРаботыФормыСотрудника(Источник, Отказ) Экспорт
	
	СотрудникиФормыРасширенный.ПроверитьНеобходимостьНастройкиРежимовРаботыФормыСотрудника(Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция ЗаголовокКнопкиОткрытияСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений, ВыводитьПодробнуюИнформацию = Ложь) Экспорт
	
	Возврат СотрудникиФормыРасширенный.ЗаголовокКнопкиОткрытияСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений, ВыводитьПодробнуюИнформацию = Ложь);
	
КонецФункции

Функция ПоясняющаяНадписьКМестуРаботыСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений) Экспорт
	
	Возврат СотрудникиФормыРасширенный.ПоясняющаяНадписьКМестуРаботыСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений);
	
КонецФункции

Процедура УстановитьВидимостьЭлементовФормыМестаРаботы(Форма, НомерСотрудника, ДанныеСотрудника) Экспорт
	
	СотрудникиФормыРасширенный.УстановитьВидимостьЭлементовФормыМестаРаботы(Форма, НомерСотрудника, ДанныеСотрудника);
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция СтандартныеОтборыСотрудников() Экспорт
	
	Возврат СотрудникиФормыРасширенный.СтандартныеОтборыСотрудников();
	
КонецФункции

Функция ДругиеРабочиеМеста(ФизическоеЛицоСсылка, СотрудникИсключение) Экспорт
	
	Возврат СотрудникиФормыРасширенный.ДругиеРабочиеМеста(ФизическоеЛицоСсылка, СотрудникИсключение);
	
КонецФункции

Процедура ЗаполнитьПервоначальныеЗначения(Форма) Экспорт
	
	СотрудникиФормыРасширенный.ЗаполнитьПервоначальныеЗначения(Форма);
	
КонецПроцедуры

Процедура СотрудникиОбновитьЭлементыФормы(Форма) Экспорт
	
	СотрудникиФормыРасширенный.СотрудникиОбновитьЭлементыФормы(Форма);
	
КонецПроцедуры

Процедура ФизическиеЛицаОбновитьЭлементыФормы(Форма) Экспорт
	
	СотрудникиФормыРасширенный.ФизическиеЛицаОбновитьЭлементыФормы(Форма);
	
КонецПроцедуры

Функция БанковскийСчетИнформацияОПричинахНедоступности() Экспорт
	Возврат СотрудникиФормыРасширенный.БанковскийСчетИнформацияОПричинахНедоступности();
КонецФункции

Процедура ЛичныеДанныеФизическихЛицОбработкаПроверкиЗаполненияВФорме(Форма, ФизическоеЛицоСсылка, Отказ) Экспорт
	
	СотрудникиФормыРасширенный.ЛичныеДанныеФизическихЛицОбработкаПроверкиЗаполненияВФорме(Форма, ФизическоеЛицоСсылка, Отказ);
	
КонецПроцедуры
	
Процедура ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация) Экспорт
	
	СотрудникиФормыРасширенный.ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация);
	
КонецПроцедуры
	
Процедура ПрочитатьДанныеСвязанныеССотрудником(Форма) Экспорт
	
	СотрудникиФормыРасширенный.ПрочитатьДанныеСвязанныеССотрудником(Форма);
	
КонецПроцедуры

Процедура ПрочитатьДанныеСвязанныеСФизлицом(Форма, ДоступенПросмотрДанныхФизическихЛиц, Организация, ИзФормыСотрудника) Экспорт
	
	СотрудникиФормыБазовый.ПрочитатьДанныеСвязанныеСФизлицом(Форма, ДоступенПросмотрДанныхФизическихЛиц, Организация, ИзФормыСотрудника);
	
КонецПроцедуры

Функция КлючиСтруктурыТекущихКадровыхДанныхСотрудника() Экспорт
	
	Возврат СотрудникиФормыРасширенный.КлючиСтруктурыТекущихКадровыхДанныхСотрудника();
	
КонецФункции

Функция КлючиСтруктурыТекущихТарифныхСтавокСотрудника() Экспорт
	
	Возврат СотрудникиФормыРасширенный.КлючиСтруктурыТекущихТарифныхСтавокСотрудника();
	
КонецФункции

Процедура УстановитьОтображениеСпособовРасчетаАванса(Форма) Экспорт
	
	СотрудникиФормыРасширенный.УстановитьОтображениеСпособовРасчетаАванса(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДополнительнымиФормами

Процедура СохранитьДанныеДополнительнойФормы(Форма, ИмяФормы, Отказ) Экспорт
	
	СотрудникиФормыРасширенный.СохранитьДанныеДополнительнойФормы(Форма, ИмяФормы, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ПостроительМеню

Функция ОписаниеМенюВводаНаОсновании(ПараметрыПостроения) Экспорт
	
	Возврат СотрудникиФормыРасширенный.ОписаниеМенюВводаНаОсновании(ПараметрыПостроения);
	
КонецФункции

#КонецОбласти

#КонецОбласти
