﻿////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентРасширенный: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийФормыСотрудника

Процедура СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	СотрудникиКлиентБазовый.СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ДокументПриемНаРаботуПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка 
		ИЛИ ИмяСобытия = "ДокументДоговорРаботыУслугиПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка 
		ИЛИ ИмяСобытия = "ДокументДоговорАвторскогоЗаказаПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка
		ИЛИ ИмяСобытия = "ДокументНачальнаяШтатнаяРасстановкаПослеЗаписи" Тогда
		
		Форма.ПрочитатьДанныеСвязанныеСФизлицом();
		
	ИначеЕсли ИмяСобытия = "РедактированиеПроцентаСевернойНадбавки" 
		И Форма.ФизическоеЛицоСсылка = Источник Тогда
		
		Форма.ТекущийПроцентСевернойНадбавки = Параметр.ПроцентСевернойНадбавки;
		
	Иначе
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
			Модуль.ОбработкаОповещенияИзмененийДанныхСотрудников(Форма, ИмяСобытия, Параметр, Источник);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	СотрудникиКлиентБазовый.СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормыФизическогоЛица

Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	
КонецПроцедуры

Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

Процедура ФизическиеЛицаОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Форма.ФизическоеЛицо.Фотография = ВыбранноеЗначение;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ВыбранноеЗначение);
	Форма.АдресФотографии = ДанныеФайла.НавигационнаяСсылкаТекущейВерсии;
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормСотрудникаИФизическогоЛица
// Содержащих уникальные значения.

Процедура ФизическиеЛицаКодПоДРФОПриИзменении(Форма, Элемент) Экспорт	
	
	СотрудникиКлиентБазовый.ФизическиеЛицаКодПоДРФОПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "КодПоДРФО");
	
КонецПроцедуры


Процедура ФизическиеЛицаАдресФотографииНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", Форма.ФизическоеЛицо.Ссылка);
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбора", ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицВидДокументаПриИзменении(Форма);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ПроверитьУникальностьФизическогоЛица(Форма, ПроверяемыеИдентификатор) Экспорт
	
	Если ПроверяемыеИдентификатор = "КодПоДРФО"
		И НЕ ЗначениеЗаполнено(Форма.ФизическоеЛицо.КодПоДРФО) Тогда
		Возврат;
	КонецЕсли; 
	
	
	Если ПроверяемыеИдентификатор = "Документ"
		И (НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ВидДокумента)
		ИЛИ НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.Номер)) Тогда
		Возврат;
	КонецЕсли; 
	
	РезультатыПроверки = СотрудникиВызовСервераРасширенный.РезультатыПроверкиУникальностиФизическогоЛица(
							Форма.ФизическоеЛицоСсылка,
							?(ПроверяемыеИдентификатор = "КодПоДРФО", Форма.ФизическоеЛицо.КодПоДРФО, ""),
							?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.ВидДокумента, ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка")),
							?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.Серия, ""),
							?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.Номер, ""));
							
	Если Форма.Параметры.Свойство("Ключ") Тогда
		ВедущийОбъект = Форма.Параметры.Ключ;
	Иначе
		ВедущийОбъект = Форма.ВладелецФормы.Параметры.Ключ;
	КонецЕсли;
	
	ВызовИзФормыСотрудника = ТипЗнч(ВедущийОбъект) = Тип("СправочникСсылка.Сотрудники");
							
	Если НЕ РезультатыПроверки.ФизическоеЛицоУникально Тогда
		
		ДанныеФизическихЛицДоступны = РезультатыПроверки.ДанныеФизическихЛицДоступны;
		
		Если ДанныеФизическихЛицДоступны И ВедущийОбъект.Пустая() Тогда
			
			ПараметрыОткрытия = Новый Структура("ЗаголовокФормы,ТекстИнформационнойНадписи,ДанныеФизическихЛиц");
			
			Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() = 1 Тогда
				
				ПараметрыОткрытия.ЗаголовокФормы = НСтр("ru='Найден человек с похожими данными';uk='Знайдено людина зі схожими даними'");
				
				Если ВызовИзФормыСотрудника Тогда
					
					ПараметрыОткрытия.ТекстИнформационнойНадписи = 
						НСтр("ru='Если принимаете на работу того же человека (например, при повторном приеме на работу) нажмите ""Да, это тот, кто мне нужен"".
                            |Если это другой человек, нажмите ""Отмена"" и обратитесь к администратору информационной системы для устранения проблемы.'
                            |;uk='Якщо приймаєте на роботу ту ж людину (наприклад, при повторному прийомі на роботу) натисніть ""Так, це той, хто мені потрібен"".
                            |Якщо це інша людина, натисніть ""Скасувати"" і зверніться до адміністратора інформаційної системи для усунення проблеми.'");
							
				Иначе
					
					ПараметрыОткрытия.ТекстИнформационнойНадписи = 
						НСтр("ru='Если вводите данные того же человека нажмите ""Да, это тот, кто мне нужен"".
                            |Если это другой человек, нажмите ""Отмена"" и обратитесь к администратору информационной системы для устранения проблемы.'
                            |;uk='Якщо вводите дані тої ж людини натисніть ""Так, це той, хто мені потрібен"".
                            |Якщо це інша людина, натисніть ""Скасувати"" і зверніться до адміністратора інформаційної системи для усунення проблеми.'");
							
				КонецЕсли;
				
			Иначе
				
				ПараметрыОткрытия.ЗаголовокФормы = НСтр("ru='Найдены люди с похожими данными.';uk='Знайдені люди з подібними даними.'");
				
				Если ВызовИзФормыСотрудника Тогда
					
					ПараметрыОткрытия.ТекстИнформационнойНадписи = 
						НСтр("ru='Если принимаете на работу одного из приведенных в списке людей (например, при повторном приеме на работу), выберите его и нажмите ""Отмеченный человек тот, кто мне нужен"".
                            |Если это другой человек, нажмите ""Отмена"" и обратитесь к администратору информационной системы для устранения проблемы.'
                            |;uk='Якщо приймаєте на роботу одну з наведених в списку людину (наприклад, при повторному прийомі на роботу), виділіть його та натисніть ""Зазначена людина той, хто мені потрібен"".
                            |Якщо це інша людина, натисніть ""Скасувати"" і зверніться до адміністратора інформаційної системи для усунення проблеми.'");
							
				Иначе
					
					ПараметрыОткрытия.ТекстИнформационнойНадписи = 
						НСтр("ru='Если вводите данные  одного из приведенных в списке людей, выберите его и нажмите ""Отмеченный человек тот, кто мне нужен "".
                            |Если это другой человек, ""Отмена"" и обратитесь к администратору информационной системы для устранения проблемы.'
                            |;uk='Якщо вводите дані одного з наведених в списку людей, виберіть його і натисніть ""Зазначена людина той, хто мені потрібен "".
                            |Якщо це інша людина, ""Скасувати"" та зверніться до адміністратора інформаційної системи для усунення проблеми.'");
							
				КонецЕсли;
				
			КонецЕсли;
			
			ОписаниеПредметовПроверки = "";
			
			Если РезультатыПроверки.СообщенияПроверки.Количество() = 1 Тогда
				
				ОписаниеПредметовПроверки = РезультатыПроверки.СообщенияПроверки[0].ТекстСообщенияОбОшибке;
				
				Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() > 1 Тогда
					
					ОписаниеПредметовПроверки = СтрЗаменить(ОписаниеПредметовПроверки,
						НСтр("ru='Найдена запись о человеке, имеющем такой же';uk='Знайдено запис про людину, що має такий же'"),
						НСтр("ru='Найдены записи о людях, имеющих такой же';uk='Знайдені записи про людей, що мають такий же'"));
					
				КонецЕсли;
				
			Иначе
				
				Для каждого СообщениеПроверки Из РезультатыПроверки.СообщенияПроверки Цикл
					
					Если СообщениеПроверки.ИмяПоля = "КодПоДРФО" Тогда	
						
						ОписаниеПредметовПроверки = ?(ПустаяСтрока(ОписаниеПредметовПроверки), "", ОписаниеПредметовПроверки + ", ") 
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Код по ДРФО (ИНН) (%1)';uk='Код за ДРФО (ІПН) (%1)'"),
								Форма.ФизическоеЛицо.КодПоДРФО);
						
						
					Иначе
						
						ОписаниеПредметовПроверки = ?(ПустаяСтрока(ОписаниеПредметовПроверки), "", ОписаниеПредметовПроверки + ", ")
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='документом, удостоверяющим личность';uk='документом, що засвідчує особу'"),
								Форма.ДокументыФизическихЛиц.ВидДокумента,
								?(ПустаяСтрока(Форма.ДокументыФизическихЛиц.Серия), "", Форма.ДокументыФизическихЛиц.Серия),
								Форма.ДокументыФизическихЛиц.Номер);
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() = 1 Тогда
					
					ОписаниеПредметовПроверки = НСтр("ru='Найдена запись о человеке, имеющем такие же';uk='Знайдено запис про людину, що має такі ж'")
						+ " " + ОписаниеПредметовПроверки;
					
				Иначе
						
					ОписаниеПредметовПроверки = НСтр("ru='Найдены записи о людях, имеющих такие же';uk='Знайдені записи про людей, які мають такі ж'")
						+ " " + ОписаниеПредметовПроверки;
						
				КонецЕсли;
				
			КонецЕсли;
			
			ПараметрыОткрытия.ТекстИнформационнойНадписи = ОписаниеПредметовПроверки + "."
				+ Символы.ПС + ПараметрыОткрытия.ТекстИнформационнойНадписи;
			
			ПараметрыОткрытия.ДанныеФизическихЛиц = РезультатыПроверки.ДанныеФизическихЛиц;
			ПараметрыОткрытия.Вставить("СкрытьКомандуДругойЧеловек", Истина);
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Форма", Форма);
			ДополнительныеПараметры.Вставить("ВызовИзФормыСотрудника", ВызовИзФормыСотрудника);
			
			Оповещение = Новый ОписаниеОповещения("ПроверитьУникальностьФизическогоЛицаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФизическиеЛицаСПохожимиДанными", ПараметрыОткрытия, , , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
		Иначе
			
			ТекстПредупреждения = РезультатыПроверки.СообщенияПроверки[0].ТекстСообщенияОбОшибке;
			
			Если НЕ ВедущийОбъект.Пустая() 
				И РезультатыПроверки.ДоступнаРольСохранениеДанныхЗадвоенныхФизическихЛиц Тогда
				ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + Символы.ПС
					+ НСтр("ru='Не рекомендуется записывать дублирующиеся личные данные.
                        |Тем не менее, можно записать текущие личные данные, после чего принять меры для устранения проблемы.'
                        |;uk='Не рекомендується записувати повторювані особисті дані.
                        |Тим не менш, можна записати поточні особисті дані, після чого вжити заходів для усунення проблеми.'");
			Иначе
				ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + Символы.ПС
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Записать %1 с этими личными данными невозможно.
                            |Внесите изменения или обратитесь к администратору информационной системы для устранения проблемы.'
                            |;uk='Записати %1 з цими особистими даними неможливо.
                            |Внесіть зміни або зверніться до адміністратора інформаційної системи для усунення проблеми.'"),
						Форма.ФизическоеЛицо.ФИО);
			КонецЕсли;
			
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьУникальностьФизическогоЛицаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВыбора <> Неопределено Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		ВызовИзФормыСотрудника = ДополнительныеПараметры.ВызовИзФормыСотрудника;
		
		Если ВызовИзФормыСотрудника Тогда
			
			СотрудникиКлиент.УстановитьФизическоеЛицоВФормеСотрудника(Форма, РезультатВыбора);
			
		Иначе
			
			Форма.Модифицированность = Ложь;
			Форма.Закрыть();
			
			ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", Новый Структура("Ключ", РезультатВыбора));
			
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ОбработатьСобытиеДополнительногоПоляФормыНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.ОбработатьСобытиеДополнительногоПоляФормыСотрудникаНажатие(Форма, Элемент, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
