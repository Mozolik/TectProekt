﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасхожденияСервер.УправлениеСтраницамиВыборДействия(ЭтотОбъект, Параметры);
	
	ИспользоватьЗаказыПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	КоличествоУпаковокРасхождения = Параметры.КоличествоУпаковокРасхождения;
	ГрупповоеИзменение = Параметры.ГрупповоеИзменение;
	
	Если Параметры.ВыбранноеДействие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы Тогда
		ЗаЧейСчет = ?(Параметры.ПоВинеСтороннейКомпании, "ПоВинеСтороннейКомпании", "ЗаНашСчет");
	КонецЕсли;
	
	Если Не ГрупповоеИзменение Тогда
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Излишки;
			ДействиеИзлишки = Параметры.ВыбранноеДействие;
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.Недостачи;
			ДействиеНедостачи = Параметры.ВыбранноеДействие;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ГрупповоеИзменение Тогда
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			Элементы.Недостачи.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать излишек';uk='Як відпрацювати надлишок'");
		Иначе
			Элементы.Излишки.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать недостачу';uk='Як відпрацювати нестачу'");
		КонецЕсли;
	Иначе
		Заголовок = НСтр("ru='Как отработать расхождения';uk='Як відпрацювати розбіжності'");
	КонецЕслИ;
	
	Элементы.КартинкаПояснения.Видимость = Параметры.ПоказыватьПояснение;
	Элементы.Пояснение.Видимость = Параметры.ПоказыватьПояснение;
	
	СформироватьЗаголовки(
		Параметры.ТипАкта,
		Параметры.КоличествоУпаковокРасхождения,
		Параметры.СпособОтраженияРасхождений,
		Параметры.ГрупповоеИзменение,
		Параметры.СтрокаПоЗаказу);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
		               НСтр("ru='Выполненные изменения будут утеряны. Все равно закрыть?';uk='Виконані зміни будуть втрачені. Все одно закрити?'"),
		               РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаНашСчетПриИзменении(Элемент)
	
	ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоВинеСтороннейКомпанииПриИзменении(Элемент)
	
	ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачуПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачуИОжидатьДопоставкуПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьДопоставкуБезОформленияПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("ДействиеИзлишки", Неопределено);
	ПараметрыЗакрытия.Вставить("ДействиеНедостачи", Неопределено);
	ПараметрыЗакрытия.Вставить("ПоВинеСтороннейКомпании", Истина);
	
	Если ГрупповоеИзменение Тогда
		
		ПараметрыЗакрытия.ДействиеИзлишки   = ДействиеИзлишки;
		ПараметрыЗакрытия.ДействиеНедостачи = ДействиеНедостачи;
		ПараметрыЗакрытия.ПоВинеСтороннейКомпании = ПоВинеСтороннейКомпании();
		
	ИначеЕсли КоличествоУпаковокРасхождения > 0 Тогда
		
		ПараметрыЗакрытия.ДействиеИзлишки = ДействиеИзлишки;

	ИначеЕсли КоличествоУпаковокРасхождения < 0 Тогда
		
		ПараметрыЗакрытия.ДействиеНедостачи = ДействиеНедостачи;
		ПараметрыЗакрытия.ПоВинеСтороннейКомпании = ПоВинеСтороннейКомпании();
		
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть(Неопределено);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьЗаголовки(ТипАкта, КоличествоУпаковокРасхождения, СпособОтраженияРасхождений, ГрупповоеИзменение, СтрокаПоЗаказу)
	
	Если ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru='Недостачи при поступлении согласованы с поставщиком';uk='Нестачі при надходженні погоджені з постачальником'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru='Недостачи при поступлении не согласованы с поставщиком';uk='Нестачі при надходженні не погоджені з постачальником'");
		
		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ИсправлениеПервичныхДокументов Тогда
			Если СтрокаПоЗаказу Или (ГрупповоеИзменение И ИспользоватьЗаказыПоставщикам) Тогда
				Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru='Поступление уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа';uk='Надходження зменшується на недопоставлений товар з подальшою відміною недопоставлених рядків замовлення'");
			Иначе
				Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru='Поступление уменьшается на недопоставленный товар';uk='Надходження зменшується на недопоставлений товар'");
			КонецЕсли;
			Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru='Поступление уменьшается на недопоставленный товар с последующим оформлением нового поступления недопоставленного товара';uk='Надходження зменшується на недопоставлений товар з подальшим оформленням нового надходження недопоставленого товару'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ОформлениеКорректировокПоступления Тогда
			Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru='На недопоставленный товар оформляется корректировка поступления с последующим оформлением нового поступления недопоставленного товара';uk='На недопоставлений товар оформлюється коригування надходження з подальшим оформленням нового надходження недопоставленого товару'");
			Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru='На недопоставленный товар оформляется корректировка поступления';uk='На недопоставлений товар оформлюється коригування надходження'");
		КонецЕсли;
		
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок = НСтр("ru='Недопоставленный товар принимается на склад, документы не переоформляются';uk='Недопоставлений товар приймається на склад, документи не переоформлюються'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru='Излишки при поступлении согласованы с поставщиком';uk='Надлишки при надходженні погоджені з постачальником'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru='Излишки при поступлении не согласованы с поставщиком';uk='Надлишки при надходженні не погоджені з постачальником'");

		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ИсправлениеПервичныхДокументов Тогда
			Элементы.ОформитьПерепоставленноеДекорация.Заголовок = НСтр("ru='Поступление увеличивается на перепоставленный товар';uk='Надходження збільшується на перепоставлений товар'");
			Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок = НСтр("ru='Поступление увеличивается на перепоставленный товар с последующим оформлением возврата перепоставленного товара';uk='Надходження збільшується на перепоставлений товар з подальшим оформленням повернення перепоставленого товару'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ОформлениеКорректировокПоступления Тогда
			Элементы.ОформитьПерепоставленноеДекорация.Заголовок = НСтр("ru='На перепоставленный товар оформляется корректировка поступления';uk='На перепоставлений товар оформлюється коригування надходження'");
			Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок = НСтр("ru='На перепоставленный товар оформляется корректировка поступления с последующим оформлением возврата перепоставленного товара';uk='На перепоставлений товар оформлюється коригування надходження з подальшим оформленням повернення перепоставленого товару'");
		КонецЕсли;
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок = НСтр("ru='Перепоставленный товар оприходуется, относится на прочие доходы, документы не переоформляются';uk='Перепоставлений товар оприбутковується, відноситься на інші доходи, документи не переоформлюються'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок  = НСтр("ru='Перепоставленный товар отгружается со склада, документы не переоформляются';uk='Перепоставлений товар відвантажується зі складу, документи не переоформлюються'");
		
	ИначеЕсли ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента Тогда
		
		// Недостачи
		Элементы.ДекорацияНедостачиСогласованы.Заголовок   = НСтр("ru='Недостачи при возврате согласованы с клиентом';uk='Нестачі при поверненні погоджені з клієнтом'");
		Элементы.ДекорацияНедостачиНеСогласованы.Заголовок = НСтр("ru='Недостачи при возврате не согласованы с клиентом';uk='Нестачі при поверненні не погоджені з клієнтом'");
		
		Элементы.ОформитьНедостачуДекорация.Заголовок                   = НСтр("ru='Возврат товаров от клиента уменьшается на недопоставленный товар';uk='Повернення товарів від клієнта зменшується на недопоставлений товар'");
		Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru='Возврат товаров от клиента уменьшается на недопоставленный товар с последующим оформлением нового возврата недопоставленного товара';uk='Повернення товарів від клієнта зменшується на недопоставлений товар з подальшим оформленням нового повернення недопоставленого товару'");
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок      = НСтр("ru='Недопоставленный товар принимается на склад, документы не переоформляются';uk='Недопоставлений товар приймається на склад, документи не переоформлюються'");
		
		// Излишки
		Элементы.ДекорацияИзлишкиСогласованы.Заголовок   = НСтр("ru='Излишки при возврате согласованы с поставщиком';uk='Надлишки при поверненні погоджені з постачальником'");
		Элементы.ДекорацияИзлишкиНеСогласованы.Заголовок = НСтр("ru='Излишки при возврате не согласованы с поставщиком';uk='Надлишки при поверненні не погоджені з постачальником'");
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок  = НСтр("ru='Излишки возврата оприходуются, относятся на прочие доходы, документы не переоформляются';uk='Надлишки повернення оприбутковуються, відносяться на інші доходи, документи не переоформлюються'");
		Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок       = НСтр("ru='Возврат товаров от клиента увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара';uk='Повернення товарів від клієнта збільшується на перепоставлений товар з подальшим оформленням надходження перепоставленого товару'");
		Элементы.ОформитьПерепоставленноеДекорация.Заголовок               = НСтр("ru='Возврат товаров от клиента увеличивается на перепоставленный товар';uk='Повернення товарів від клієнта збільшується на перепоставлений товар'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок   = НСтр("ru='Перепоставленный товар отгружается со склада, документы не переоформляются';uk='Перепоставлений товар відвантажується зі складу, документи не переоформлюються'");
		
	КонецЕсли;
	
	Элементы.ЗаНашСчетДекорация.Заголовок               = НСтр("ru='Недостающий товар будет оприходован на склад и списан на прочие расходы';uk='Відсутній товар буде оприбутковано на склад і списано на інші витрати'");
	Элементы.ПоВинеСтороннейКомпанииДекорация.Заголовок = НСтр("ru='Недостающий товар будет оприходован на склад и списан на прочие расходы. Ответственность за недостачи будет возложена на стороннюю компанию';uk='Відсутній товар буде оприбутковано на склад і списано на інші витрати. Відповідальність за нестачі буде покладено на сторонню компанію'");

	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоВинеСтороннейКомпании()

	Возврат ?(ДействиеНедостачи = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы"),
	                                                      ?(ЗаЧейСчет = "ПоВинеСтороннейКомпании", Истина, Ложь),
	                                                      Ложь);

КонецФункции

&НаКлиенте
Процедура ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении()
	
	ДействиеНедостачи = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы");
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеНедостачиПриИзменении()
	
	ЗаЧейСчет = "";
	
КонецПроцедуры

#КонецОбласти

