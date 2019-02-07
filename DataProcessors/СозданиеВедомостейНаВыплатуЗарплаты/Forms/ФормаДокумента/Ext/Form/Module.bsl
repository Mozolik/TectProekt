﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресВоВременномХранилище", АдресВоВременномХранилище) Тогда
		
		СтрокаXML = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
		Ведомость = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
		
		Обработка = РеквизитФормыВЗначение("Объект");
		ЗаполнитьЗначенияСвойств(Обработка, Ведомость);
		Обработка.Зарплата.Загрузить(Ведомость.Зарплата.Выгрузить());
		Обработка.НДФЛ.Загрузить(Ведомость.НДФЛ.Выгрузить());
		Обработка.ВзносыФОТ.Загрузить(Ведомость.ВзносыФОТ.Выгрузить());
		ЗначениеВРеквизитФормы(Обработка, "Объект");
		
		МестоВыплаты = Ведомость.МестоВыплаты().Значение;
		Заголовок = Ведомость.Метаданные().Синоним +" "+ МестоВыплаты
		
	КонецЕсли;

	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура КассирПриИзменении(Элемент)
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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьНаСервере();
	Закрыть()
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере()
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()	
	
	Если Модифицированность Тогда
		
		СтрокаXML = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
		Ведомость = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
			
		Обработка = РеквизитФормыВЗначение("Объект");
		ЗаполнитьЗначенияСвойств(Ведомость, Обработка);
		
		СтрокаXML = ОбщегоНазначения.ЗначениеВСтрокуXML(Ведомость);
		ПоместитьВоВременноеХранилище(СтрокаXML, АдресВоВременномХранилище);
		
		Модифицированность = Ложь;
		
	КонецЕсли
	
КонецПроцедуры	

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПодписантПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей() Экспорт
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Кассир", "Объект.Бухгалтер");
КонецПроцедуры

#КонецОбласти
