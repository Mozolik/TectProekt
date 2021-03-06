﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ПараметрыДетализации);
	
	Если Не ЗначениеЗаполнено(ПодразделениеПредприятия) Или Не ЗначениеЗаполнено(ВидОперации) Тогда
		Заголовок = НСтр("ru='Сотрудники организации';uk='Співробітники організації'");
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Сотрудники организации (%1, %2)';uk='Співробітники організації (%1, %2)'"),
		СокрЛП(ПодразделениеПредприятия),
		СокрЛП(ВидОперации));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресВХранилище) Тогда
		ДетализацияНачислений = ПолучитьИзВременногоХранилища(АдресВХранилище);
		НачисленнаяЗарплатаИВзносыПоФизлицам.Загрузить(ДетализацияНачислений.НачисленнаяЗарплатаИВзносыПоФизлицам);
	КонецЕсли;
	
	ЗаполнитьДополнительныеРеквизиты();
	
	УстановитьОтображениеВзносов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносыПоФизлицам Цикл
		
		ТекстСообщения = НСтр("ru='Не заполнено поле %1 в строке %2';uk='Не заповнено поле %1 в рядку %2'");
		
		Если Не ЗначениеЗаполнено(Строка.ПодразделениеПредприятия) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru='Подразделение-получатель';uk='Підрозділ-одержувач'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ПодразделениеПредприятия"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ВидОперации) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru='Вид операции';uk='Вид операції'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ВидОперации"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.СпособОтраженияЗарплатыВБухучете)
			И СпособОтраженияТребуется(Строка.ВидОперации, Строка.ВзносыВсего) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru='Способ отражения';uk='Спосіб відображення'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "СпособОтраженияЗарплатыВБухучете"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ФизическоеЛицо) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru='Сотрудник';uk='Співробітник'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ФизическоеЛицо"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.Сумма) И Не ЗначениеЗаполнено(Строка.ВзносыВсего) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнена сумма начисления и взносов в строке %1';uk='Не заповнена сума нарахування та внесків в рядку %1'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "Сумма"),,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПередЗакрытием", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисленнаяЗарплатаИВзносы

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПоФизлицамПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
		
		Если Не Копирование Тогда
			ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЭтаФорма);
			ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.НачисленоДоход");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПриИзменении(Элемент)
	
	ЗаполнитьДополнительныеРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыВидОперацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьВзносыПодробно(Команда)
	
	ПоказатьВзносыПодробно = Не ПоказатьВзносыПодробно;
	Элементы.ПоказатьВзносыПодробно.Пометка = ПоказатьВзносыПодробно;
	УстановитьОтображениеВзносов();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность Тогда
		
		ЗавершитьРедактирование();
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделение(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для выполнения команды требуется выделить строки табличной части.';uk='Для виконання команди потрібно виділити рядки табличної частини.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;

	
	ОткрытьФорму(
		"Справочник.СтруктураПредприятия.Форма.ФормаВыбора", 
		,
		ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьПодразделениеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	ВыбранноеЗначение = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Для Каждого Строка Из ВыделенныеСтроки Цикл
			
			СтрокаТаблицы = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
			Если СтрокаТаблицы <> Неопределено Тогда
				СтрокаТаблицы.ПодразделениеПредприятия = ВыбранноеЗначение;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидОперации(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для выполнения команды требуется выделить строки табличной части.';uk='Для виконання команди потрібно виділити рядки табличної частини.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;

	
	ОткрытьФорму(
		"Перечисление.ВидыОперацийПоЗарплате.Форма.ФормаВыбора",
		Новый Структура("ГруппаОпераций", "Начисления"),
		,,,
		ЭтаФорма, Новый ОписаниеОповещения("ЗаполнитьВидОперацииЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидОперацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	ВыбранноеЗначение = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Для Каждого Строка Из ВыделенныеСтроки Цикл
			
			СтрокаТаблицы = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
			Если СтрокаТаблицы <> Неопределено Тогда
				
				СтрокаТаблицы.ВидОперации = ВыбранноеЗначение;
				
				Если Не СпособОтраженияТребуется(СтрокаТаблицы.ВидОперации, СтрокаТаблицы.ВзносыВсего) Тогда
					СтрокаТаблицы.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпособОтражения(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для выполнения команды требуется выделить строки табличной части.';uk='Для виконання команди потрібно виділити рядки табличної частини.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;
	
	ОткрытьФорму(
		"Справочник.СпособыОтраженияЗарплатыВБухУчете.Форма.ФормаВыбора", 
		,
		ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСпособОтраженияЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпособОтраженияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
		
		Если СпособОтраженияТребуется(ДанныеСтроки.ВидОперации, ДанныеСтроки.ВзносыВсего) Тогда
			ДанныеСтроки.СпособОтраженияЗарплатыВБухучете = Результат
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОтражениеЗарплатыВФинансовомУчетеУП.УсловноеОформлениеОперацийПоЗарплате(
		УсловноеОформление, "НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации", Элементы.НачисленнаяЗарплатаИВзносыВидОперации);
	
	// способ отражения не требуется для сдельной зарплаты и некоторых резервов
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыСпособОтражения.Имя);
	
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход);
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не требуется>';uk='<не потрібно>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// способ отражения не требуется для расходов по страхованию, если взносы не заполнены
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыСпособОтражения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС);
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВзносыВсего");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не требуется>';uk='<не потрібно>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизиты()
	
	НомерСтроки = 1;
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносыПоФизлицам Цикл
		
		Строка.Номер = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	МаксимальныйНомерСтроки = НомерСтроки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеВзносов()
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Результат = Новый Структура("СтруктураОтбора, АдресВХранилище");
	Результат.СтруктураОтбора = Новый Структура("ПодразделениеПредприятия, ВидОперации, СпособОтраженияЗарплатыВБухучете",
		ПодразделениеПредприятия, ВидОперации, СпособОтраженияЗарплатыВБухучете);
	
	РезультатРедактированияНаСервере(Результат);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервере
Процедура РезультатРедактированияНаСервере(СтруктураВыбора)
	
	ДетализацияНачислений = Новый Структура("НачисленнаяЗарплатаИВзносыПоФизлицам",
		НачисленнаяЗарплатаИВзносыПоФизлицам.Выгрузить());
	
	СтруктураВыбора.АдресВХранилище = ПоместитьВоВременноеХранилище(ДетализацияНачислений);
	
КонецПроцедуры

&НаКлиенте
Функция КолонкиДляСуммирования()
	
	Возврат "ПФРСтраховая, ПФРНакопительная, ПФРПоСуммарномуТарифу, ПФРДоПредельнойВеличины, ПФРСПревышения,
		|ФСС, ФФОМС, ТФОМС, ПФРНаДоплатуЛетчикам, ПФРНаДоплатуШахтерам, ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
		|ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах, ФССНесчастныеСлучаи";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СпособОтраженияТребуется(ВидОперации, ВзносыВсего)
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.НачисленоСдельноДоход") Или
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если (ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС") Или
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС")) И
		Не ЗначениеЗаполнено(ВзносыВсего) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
