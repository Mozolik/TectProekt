﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя());
	
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СоглашенияСписок.Параметры.УстановитьЗначениеПараметра("Партнер",Партнер);
	СоглашенияСписок.Параметры.УстановитьЗначениеПараметра("ТекущаяДата",НачалоДня(ТекущаяДата()));
	
	ИспользоватьТиповыеСоглашенияСКлиентами         = ПолучитьФункциональнуюОпцию("ИспользоватьТиповыеСоглашенияСКлиентами");
	ИспользоватьИндивидуальныеСоглашенияСКлиентами  = ПолучитьФункциональнуюОпцию("ИспользоватьИндивидуальныеСоглашенияСКлиентами");
	ТолькоТиповые = ИспользоватьТиповыеСоглашенияСКлиентами И НЕ ИспользоватьИндивидуальныеСоглашенияСКлиентами;
	ТолькоИндивидуальные = НЕ ИспользоватьТиповыеСоглашенияСКлиентами И ИспользоватьИндивидуальныеСоглашенияСКлиентами;
	
	СоглашенияСписок.Параметры.УстановитьЗначениеПараметра("ТолькоТиповые",ТолькоТиповые);
	СоглашенияСписок.Параметры.УстановитьЗначениеПараметра("ТолькоИндивидуальные",ТолькоИндивидуальные);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоглашенияСписок

&НаКлиенте
Процедура СоглашенияСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПечать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПечать()

	ТекущиеДанные = Элементы.СоглашенияСписок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СамообслуживаниеКлиент.ПечатьСоглашениеСКлиентом(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СоглашенияСписок);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
