﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма,Параметры);
	
	Если Параметры.Свойство("ИменаПредопределенныхПараметров") Тогда
		ИменаПараметровВДереве.ЗагрузитьЗначения(Параметры.ИменаПредопределенныхПараметров);
	КонецЕсли;
	
	ШаблоныСообщенийСервер.ЗаполнитьСписокВыбораВводНаОсновании(Элементы.ПолноеИмяТипа.СписокВыбора, Истина, Истина);
	Если Не ПустаяСтрока(ПолноеИмяТипа) Тогда
		Элементы.ПолноеИмяТипа.ТолькоПросмотр = Истина;
		ЭлементСписка = Элементы.ПолноеИмяТипа.СписокВыбора.НайтиПоЗначению(ПолноеИмяТипа);
		Если ЭлементСписка <> Неопределено Тогда
			СтроковоеПредставлениеТипа = ЭлементСписка.Представление;
		КонецЕсли;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолноеИмяТипа = ВыбранноеЗначение;
	СтроковоеПредставлениеТипа = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;
	Если Не ПустаяСтрока(ПолноеИмяТипа) Тогда
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмяТипа,".");
		МассивТипов = Новый Массив;
		Если МассивПодстрок.Количество() = 2 Тогда
			МассивТипов.Добавить(Тип(МассивПодстрок[0] + "Ссылка." + МассивПодстрок[1]));
			ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
			ЭтоПредопределенныйПараметр = Истина;
		Иначе
			Если ПолноеИмяТипа = НСтр("ru='Дата';uk='Дата'") Тогда
				ОписаниеТипа = Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
			Иначе
				ОписаниеТипа = Новый ОписаниеТипов("Строка");
			КонецЕсли;
			ЭтоПредопределенныйПараметр = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПараметраПриИзменении(Элемент)
	
	Если ПустаяСтрока(ИмяПараметра) Тогда
		ИмяПараметра = УдалитьРазделителиСлов(ПредставлениеПараметра);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВШаблон(Команда)
	
	ОчиститьСообщения();
	Отказ = Ложь;
	
	ПроверкаЗаполнения(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(СформироватьСтруктуруПараметровДляПередачиВладельцу());
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция УдалитьРазделителиСлов(ИсходнаяСтрока)
	
	СтрокаКПреобразованию = ИсходнаяСтрока;
	
	Для Инд = 0 По СтрДлина(СтрокаКПреобразованию) Цикл
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Сред(СтрокаКПреобразованию, Инд, 1))) Тогда
			Если Инд = 0 Тогда
				СтрокаКПреобразованию =  Прав(СтрокаКПреобразованию, СтрДлина(СтрокаКПреобразованию) - 1);
			Иначе
				ЛеваяЧасть  = Лев(СтрокаКПреобразованию, Инд - 1);
				ПраваяЧасть = Прав(СтрокаКПреобразованию, СтрДлина(СтрокаКПреобразованию) - Инд);
				Если СтрДлина(ПраваяЧасть) > 1 Тогда
					ПраваяЧасть = ВРег(Лев(ПраваяЧасть,1)) + Прав(ПраваяЧасть, СтрДлина(ПраваяЧасть) - 1);
				КонецЕсли;
					СтрокаКПреобразованию = ЛеваяЧасть + ПраваяЧасть;
			КонецЕсли;
			СтрокаКПреобразованию = УдалитьРазделителиСлов(СтрокаКПреобразованию);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаКПреобразованию;
	
КонецФункции

&НаКлиенте
Функция СформироватьСтруктуруПараметровДляПередачиВладельцу()

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ИмяПараметра",ИмяПараметра);
	СтруктураВозврата.Вставить("ПредставлениеПараметра",ПредставлениеПараметра);
	СтруктураВозврата.Вставить("ОписаниеТипа",ОписаниеТипа);
	СтруктураВозврата.Вставить("ЭтоПредопределенныйПараметр",ЭтоПредопределенныйПараметр);
	СтруктураВозврата.Вставить("ПолноеИмяТипа",ПолноеИмяТипа);
	
	Возврат СтруктураВозврата;

КонецФункции

&НаКлиенте
Процедура ПроверкаЗаполнения(Отказ)
	
	Если ПустаяСтрока(ПолноеИмяТипа) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru=' Не заполнен тип параметра';uk=' Не заповнений тип параметра'"),,"СтроковоеПредставлениеТипа",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено представление параметра';uk='Не заповнене представлення параметра'"),,"ПредставлениеПараметра",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяПараметра) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено имя параметра';uk='Не заповнено ім''я параметра'"),,"ИмяПараметра");
	Иначе
		Для Инд = 0 По СтрДлина(ИмяПараметра) Цикл
			Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Сред(ИмяПараметра, Инд, 1))) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Неверно указано имя параметра';uk='Невірно зазначене ім''я параметра'"),,"ИмяПараметра",,Отказ);
				Прервать;
				Возврат;
			КонецЕсли;
		КонецЦикла;
		Если ИменаПараметровВДереве.НайтиПоЗначению(ИмяПараметра) <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Параметр с таким именем уже есть в шаблоне';uk='Параметр з таким ім''ям вже є в шаблоні'"),,"ИмяПараметра",,Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
