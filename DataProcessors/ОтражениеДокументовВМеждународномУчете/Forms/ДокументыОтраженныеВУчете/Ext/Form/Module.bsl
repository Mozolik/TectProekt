﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СоответствиеТипыДокументовИсключений = Новый Соответствие;
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.АмортизацияОСМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.АмортизацияНМАМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.ИзменениеПараметровНМАМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.ИзменениеПараметровОСМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.ПеремещениеНМАМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.ПеремещениеОСМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.ПереводОсновныхСредствИнвестиционногоИмуществаМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.СписаниеНМАМеждународныйУчет"), Истина);
	СоответствиеТипыДокументовИсключений.Вставить(Тип("ДокументСсылка.СписаниеОСМеждународныйУчет"), Истина);
	
	ТипыДокументовИсключений = Новый ФиксированноеСоответствие(СоответствиеТипыДокументовИсключений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОтражениеДокументовВМеждународномУчете" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗарегистрироватьДляОтраженияВУчете(Команда)
	
	МассивДокументов = МассивДокументов(Элементы.Список.ВыделенныеСтроки);
	Если МассивДокументов.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикПоказатьВопросПриРегистрацииДляОтраженияВУчете", ЭтотОбъект, МассивДокументов);
		ТекстВопроса = НСтр("ru='Выбранные документы будут зарегистрированы для повторного отражения в международном учете. Продолжить?';uk='Вибрані документи будуть зареєстровані для повторного відображення в міжнародному обліку. Продовжити?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиМеждународногоУчета(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для выполнения команды необходимо выбрать документ';uk='Для виконання команди необхідно вибрати документ'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Регистратор", ТекущиеДанные.Документ);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрБухгалтерии.Международный.Форма.ПроводкиМеждународногоУчета", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция МассивДокументов(МассивВыделенныхСтрок)
	
	ЕстьОшибкаПереотраженияДокументовОСНМА = Ложь;
	
	МассивДокументов = Новый Массив;
	Для каждого Строка Из МассивВыделенныхСтрок Цикл
		Документ = Элементы.Список.ДанныеСтроки(Строка).Документ;
		Если ТипыДокументовИсключений.Получить(ТипЗнч(Документ)) = Неопределено Тогда
			МассивДокументов.Добавить(Документ);
		Иначе
			ЕстьОшибкаПереотраженияДокументовОСНМА = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьОшибкаПереотраженияДокументовОСНМА Тогда
		ПоказатьПредупреждение(,
			НСтр("ru='Документы учета внеоборотных активов отражаются в международном учете при проведении';uk='Документи обліку необоротних активів відображаються в міжнародному обліку при проведенні'"));
	КонецЕсли;
	
	Возврат МассивДокументов;
	
КонецФункции

&НаКлиенте
Процедура ОбработчикПоказатьВопросПриРегистрацииДляОтраженияВУчете(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗарегистрироватьДляОтраженияВУчетеСервер(ДополнительныеПараметры);
		ОповеститьОбИзмененииОтраженияДокументаВМеждународномУчете();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьДляОтраженияВУчетеСервер(МассивДокументов)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ДанныеРегистра.Период) КАК Период,
	|	ДанныеРегистра.Регистратор КАК Регистратор,
	|	ДанныеРегистра.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ПустаяСсылка) КАК ХозяйственнаяОперация
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Регистратор В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.Организация
	|ИТОГИ ПО
	|	Регистратор";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("МассивДокументов", МассивДокументов);
	
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьДокументыКОтражениюВМеждународномУчете(ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииОтраженияДокументаВМеждународномУчете()

	Оповестить("Запись_ОтражениеДокументовВМеждународномУчете");

КонецПроцедуры

#КонецОбласти
