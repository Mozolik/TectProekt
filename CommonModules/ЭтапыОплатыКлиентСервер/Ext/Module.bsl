﻿
////////////////////////////////////////////////////////////////////////////////
// Модуль "ЭтапыОплатыКлиентСервер" содержит процедуры и функции для 
// формирования представления этапов оплаты,
// работы с таблицей этапов оплаты, не требующие вызова сервера
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПредставлениеЭтаповОплаты

// Возвращает представление условий оплаты по документу,
// включающие в себя форму оплаты, этапы оплаты, график оплаты
//
// Параметры:
// 		Форма - УправляемаяФорма - форма из которой вызвана функция
//
// Возвращаемое значение:
// 		Строка - представление условий оплаты
//
Функция НадписьЭтапыОплаты(Форма, ЭтоЗаказ = Ложь) Экспорт
	
	Перем ГрафикОплаты, ЭтапыГрафикаОплаты, ПорядокРасчетов;
	
	Объект = Форма.Объект;
	
	Валюта                    = Объект.Валюта;
	ФормаОплаты               = Объект.ФормаОплаты;
	КоличествоЭтаповОплаты    = 0;
	ИспользоватьГрафикиОплаты = Ложь;
	
	Объект.Свойство("ГрафикОплаты", ГрафикОплаты);
	ЕстьЭтапыОплаты = Объект.Свойство("ЭтапыГрафикаОплаты", ЭтапыГрафикаОплаты);
	
	Объект.Свойство("ПорядокРасчетов", ПорядокРасчетов);
	ЕстьПорядокРасчетов = Объект.Свойство("ПорядокРасчетов", ПорядокРасчетов);
	
	Если ЕстьЭтапыОплаты Тогда
		КоличествоЭтаповОплаты    = ЭтапыГрафикаОплаты.Количество();
		ИспользоватьГрафикиОплаты = Форма.ИспользоватьГрафикиОплаты;
	Иначе
		КоличествоЭтаповОплаты    = ?(ЗначениеЗаполнено(Объект.ДатаПлатежа), 1, 0);
	КонецЕсли;
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ГрафикИсполненияВДоговоре", Ложь);
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Оформление = ПараметрыОФормленияНадписиЭтапыОплаты();
	
	МассивСтрок = Новый Массив;
	
	Если ЭтоЗаказ И ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоНакладным") Тогда
		
		МассивСтрок.Добавить(НСтр("ru='По накладным';uk='За накладними'"));
		
	ИначеЕсли РеквизитыФормы.ГрафикИсполненияВДоговоре И ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов") Тогда
		
		МассивСтрок.Добавить(НСтр("ru='По графику договора';uk='За графіком договору'"));
		
	Иначе
		
		МассивСтрок.Добавить(ПредставлениеФормыОплаты(ФормаОплаты));
		
		Если КоличествоЭтаповОплаты = 0 Тогда
			
			ТекстОшибки = ?(ЕстьЭтапыОплаты, НСтр("ru='этапы не указаны';uk='етапи не зазначені'"), НСтр("ru='не указана дата платежа';uk='не зазначена дата платежу'"));
			
			МассивСтрок.Добавить(", ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки, , Оформление.ЦветПредупреждение));
			
		ИначеЕсли Не ЕстьЭтапыОплаты Тогда
			
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Формат(Объект.ДатаПлатежа, Оформление.ФорматДаты));
			
		ИначеЕсли КоличествоЭтаповОплаты <= 2 Тогда
			
			МассивСтрок.Добавить(" ");
			Для Сч=1 По КоличествоЭтаповОплаты Цикл
				СтрокаОплаты = ЭтапыГрафикаОплаты[Сч-1];
				Если ЗначениеЗаполнено(СтрокаОплаты.ДатаПлатежа) Тогда
					МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
						Формат(СтрокаОплаты.ДатаПлатежа, Оформление.ФорматДаты), , Оформление.ЦветВыделение));
					МассивСтрок.Добавить(" (" + Формат(СтрокаОплаты.ПроцентПлатежа, Оформление.ФорматДоли) + "%)");
					МассивСтрок.Добавить(", ");
				КонецЕсли;
			КонецЦикла;
			МассивСтрок.Удалить(МассивСтрок.Количество()-1);
			
		ИначеЕсли ИспользоватьГрафикиОплаты И ЗначениеЗаполнено(ГрафикОплаты) Тогда
			
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(НСтр("ru='по графику';uk='за графіком'") + " """ + Строка(ГрафикОплаты) + """");
			
		Иначе
			
			ТекстЭтапа = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
				КоличествоЭтаповОплаты,
				НСтр("ru='этапы';uk='етапи'"), НСтр("ru='этапа';uk='етапу'"), НСтр("ru='этапов';uk='етапів'"), НСтр("ru='м';uk='м'"));
				
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(НСтр("ru='в';uk='в'") +" " + Формат(КоличествоЭтаповОплаты, "ЧН=0") +" " + ТекстЭтапа);
			
		КонецЕсли;
	КонецЕсли;
	
	ТекстНадписи = Новый ФорматированнаяСтрока(МассивСтрок);
	Возврат ТекстНадписи;
	
КонецФункции

// Возвращает представление условий оплаты для документа "РеализацияТоваровУслуг",
// включающие в себя форму оплаты, этапы оплаты
//
// Параметры:
// 		СтруктураДокумента - Структура - Поля структуры описаны в функции "СтруктураПолученияНадписиЭтаповОплатыДляРеализациииТоваровУслуг"
//
// Возвращаемое значение:
// 		Строка - представление условий оплаты
//
Функция НадписьЭтапыОплатыДляРеализациииТоваровУслуг(СтруктураДокумента) Экспорт
	
	Параметры = СтруктураПолученияНадписиЭтаповОплатыДляРеализациииТоваровУслуг();
	ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(Параметры, СтруктураДокумента, Истина);
	
	Оформление = ПараметрыОФормленияНадписиЭтапыОплаты();
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ПредставлениеФормыОплаты(Параметры.ФормаОплаты));
	
	ПорядокРасчетовПоНакладным = (Параметры.ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоНакладным"));
	УчитыватьВариантОплаты     = Параметры.ИспользоватьСтатусыРеализацийТоваровУслуг 
		И (Не Параметры.РеализацияПоЗаказам Или ПорядокРасчетовПоНакладным)
		И Параметры.ХозяйственнаяОперация <> ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию");
		
	Если СтруктураДокумента.ГрафикИсполненияВДоговоре И Параметры.ПорядокРасчетов = ПредопределенноеЗначение("Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов") Тогда
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru='По графику договора';uk='За графіком договору'"));
		
	ИначеЕсли УчитыватьВариантОплаты И Параметры.СуммаВсего > 0 И Параметры.СуммаПредоплаты <> 0 Тогда
		
		ДоляПредоплаты = Параметры.СуммаПредоплаты *100 / Параметры.СуммаВсего;
		ЕстьКредит     = ЗначениеЗаполнено(Параметры.ДатаПлатежа) И ДоляПредоплаты < 100;
		
		МассивСтрок.Добавить(" ");
		СтрокаПредоплаты = Новый ФорматированнаяСтрока(
			Формат(Параметры.Дата, Оформление.ФорматДаты),
			,
			?(ЕстьКредит, Оформление.ЦветВыделение, Неопределено));
		МассивСтрок.Добавить(СтрокаПредоплаты);
		МассивСтрок.Добавить(" (" + Формат(ДоляПредоплаты, Оформление.ФорматДоли) + "%)");
		
		Если ЕстьКредит Тогда
			МассивСтрок.Добавить(", ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				Формат(Параметры.ДатаПлатежа, Оформление.ФорматДаты), , Оформление.ЦветВыделение));
			МассивСтрок.Добавить(" (" + Формат(100-ДоляПредоплаты, Оформление.ФорматДоли) + "%)");
		КонецЕсли;
		
	Иначе
		
		Если УчитыватьВариантОплаты И Параметры.СуммаПредоплаты > 0 Тогда
			ДатаПлатежа = Параметры.Дата;
		Иначе
			ДатаПлатежа = Параметры.ДатаПлатежа;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаПлатежа) Тогда
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Формат(ДатаПлатежа, Оформление.ФорматДаты) + " (100%)");
		Иначе
			МассивСтрок.Добавить(", ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru='не указана дата платежа';uk='не зазначена дата платежу'"), , Оформление.ЦветПредупреждение));
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстНадписи = Новый ФорматированнаяСтрока(МассивСтрок);
	Возврат ТекстНадписи;
	
КонецФункции

// Возвращает представление условий оплаты для соглашений,
// включающие в себя форму оплаты, этапы оплаты
//
// Параметры:
// 		Форма - УправляемаяФорма - форма из которой вызвана функция
//
// Возвращаемое значение:
// 		Строка - представление условий оплаты
//
Функция НадписьЭтапыОплатаДляСоглашений(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ФормаОплаты            = Объект.ФормаОплаты;
	ЭтапыГрафикаОплаты     = Объект.ЭтапыГрафикаОплаты;
	КоличествоЭтаповОплаты = ЭтапыГрафикаОплаты.Количество();
	
	Оформление = ПараметрыОФормленияНадписиЭтапыОплаты();
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ПредставлениеФормыОплатыДляСоглашений(ФормаОплаты));
	
	ТекстЭтаповОплаты = "";
	Если КоличествоЭтаповОплаты = 0 Тогда
		
		МассивСтрок.Добавить(", ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='этапы не указаны';uk='етапи не зазначені'"), , Оформление.ЦветПредупреждение));
		
	ИначеЕсли КоличествоЭтаповОплаты <= 2 Тогда
		
		МассивСтрок.Добавить(" ");
		Для Сч=1 По КоличествоЭтаповОплаты Цикл
			СтрокаОплаты = ЭтапыГрафикаОплаты[Сч-1];
			ТекстЭтаповОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 %2% %3 дн';uk='%1 %2% %3 дн'"),
				ПредставлениеВариантаОплаты(СтрокаОплаты.ВариантОплаты),
				СтрокаОплаты.ПроцентПлатежа, СтрокаОплаты.Сдвиг);
			МассивСтрок.Добавить(ТекстЭтаповОплаты);
			МассивСтрок.Добавить(", ");
		КонецЦикла;
		МассивСтрок.Удалить(МассивСтрок.Количество()-1);
		
	Иначе
		
		ТекстЭтапа = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
			КоличествоЭтаповОплаты,
			НСтр("ru='этапы';uk='етапи'"), НСтр("ru='этапа';uk='етапу'"), НСтр("ru='этапов';uk='етапів'"), НСтр("ru='м';uk='м'"));
			
		МассивСтрок.Добавить(" ");
		МассивСтрок.Добавить(НСтр("ru='в';uk='в'") +" " + Формат(КоличествоЭтаповОплаты, "ЧН=0") +" " + ТекстЭтапа);
		
	КонецЕсли;
	
	ТекстНадписи = Новый ФорматированнаяСтрока(МассивСтрок);
	Возврат ТекстНадписи;
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеИРаспределение

// Распределяет сумму по этапам оплаты
//
// Параметры:
// ЭтапыГрафика
// 		ЭтапыГрафикаОплаты -ТаблицаЗначений - таблица этапов оплаты, в которой необходимо распределить сумму
// 		СуммаКРаспределениюОплаты - Число - сумма платежей, которую необходимо распределить по этапам
// 		СуммаКРаспределениюЗалога - Число - сумма залога за тару, которую необходимо распределить по этапам
//
Процедура РаспределитьСуммуПоЭтапамГрафикаОплаты(ЭтапыГрафикаОплаты, Знач СуммаКРаспределениюОплаты, Знач СуммаКРаспределениюЗалога = 0) Экспорт
	
	РаспределеннаяСуммаОплаты = 0;
	РаспределеннаяСуммаЗалога = 0;
	ТекущийЭтап               = 0;
	ПроцентПлатежа            = 0;
	ПроцентЗалогаЗаТару       = 0;
	ОдинДень                  = 86400;
	ЕстьЛишниеЭтапы           = Ложь;
	КоличествоЭтапов          = ЭтапыГрафикаОплаты.Количество();
	 
	Для Каждого ЭтапГрафикаОплаты Из ЭтапыГрафикаОплаты Цикл
		
		ДанныеЭтапа = Новый Структура("ПроцентПлатежа, СуммаПлатежа, ПроцентЗалогаЗаТару, СуммаЗалогаЗаТару", 0, 0, 0, 0);
		ЗаполнитьЗначенияСвойств(ДанныеЭтапа, ЭтапГрафикаОплаты);
		
		ТекущийЭтап = ТекущийЭтап + 1;
		
		// Если сумма платежей по всем этапам менее ста процентов или 
		// проценты текущего этапа равны 0 -
		// добавим недостающие проценты
		
		ПроцентыТекущегоЭтапаНулевые = (ДанныеЭтапа.ПроцентПлатежа = 0 И ДанныеЭтапа.ПроцентЗалогаЗаТару = 0);
		
		Если (ТекущийЭтап = КоличествоЭтапов
			И ЭтапыГрафикаОплаты.Итог("ПроцентПлатежа") < 100)
			Или ПроцентыТекущегоЭтапаНулевые Тогда
			
			ДанныеЭтапа.ПроцентПлатежа = 100 - ПроцентПлатежа;
			
		КонецЕсли;
		Если (ТекущийЭтап = КоличествоЭтапов И ПроцентЗалогаЗаТару + ДанныеЭтапа.ПроцентЗалогаЗаТару < 100)
			Или ПроцентыТекущегоЭтапаНулевые Тогда
			
			ДанныеЭтапа.ПроцентЗалогаЗаТару = 100 - ПроцентЗалогаЗаТару;
			
		КонецЕсли;
		
		// Если к текущему этапу общий процент платежа более 100% - 
		// уменьшим процент текущего платежа и удалим "лишние" этапы
		
		ПроцентПлатежаСТекущимЭтапом = ПроцентПлатежа + ДанныеЭтапа.ПроцентПлатежа;
		ПроцентЗалогаЗаТаруСТекущимЭтапом = ПроцентЗалогаЗаТару + ДанныеЭтапа.ПроцентЗалогаЗаТару;
		
		Если ПроцентПлатежаСТекущимЭтапом > 100 Тогда
			ДанныеЭтапа.ПроцентПлатежа = 100 - ПроцентПлатежа;
		КонецЕсли;
		Если ПроцентЗалогаЗаТаруСТекущимЭтапом > 100 Тогда
			ДанныеЭтапа.ПроцентЗалогаЗаТару = 100 - ПроцентЗалогаЗаТару;
		КонецЕсли;
		
		СуммаПлатежаПоЭтапу       = Окр(СуммаКРаспределениюОплаты * ДанныеЭтапа.ПроцентПлатежа / 100, 2, РежимОкругления.Окр15как20);
		ДанныеЭтапа.СуммаПлатежа  = ?(ТекущийЭтап = КоличествоЭтапов, СуммаКРаспределениюОплаты - РаспределеннаяСуммаОплаты, СуммаПлатежаПоЭтапу);
		РаспределеннаяСуммаОплаты = РаспределеннаяСуммаОплаты + ДанныеЭтапа.СуммаПлатежа;
		ПроцентПлатежа            = ПроцентПлатежа + ДанныеЭтапа.ПроцентПлатежа;
		
		СуммаЗалогаПоЭтапу            = Окр(СуммаКРаспределениюЗалога * ДанныеЭтапа.ПроцентЗалогаЗаТару / 100, 2, РежимОкругления.Окр15как20);
		ДанныеЭтапа.СуммаЗалогаЗаТару = ?(ТекущийЭтап = КоличествоЭтапов, СуммаКРаспределениюЗалога - РаспределеннаяСуммаЗалога, СуммаЗалогаПоЭтапу);
		РаспределеннаяСуммаЗалога     = РаспределеннаяСуммаЗалога + ДанныеЭтапа.СуммаЗалогаЗаТару;
		ПроцентЗалогаЗаТару           = ПроцентЗалогаЗаТару + ДанныеЭтапа.ПроцентЗалогаЗаТару;
		
		// Если на текущем этапе превышен процент платежа и этап не последний - 
		// необходимо удалять лишние этапы
		
		Если ТекущийЭтап <> КоличествоЭтапов
			И ПроцентПлатежаСТекущимЭтапом >= 100
			И ПроцентЗалогаЗаТаруСТекущимЭтапом >= 100 Тогда
			ЕстьЛишниеЭтапы = Истина;
			Прервать;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтапГрафикаОплаты, ДанныеЭтапа);
		
	КонецЦикла;
	
	// Удалим лишние этапы графика оплаты
	Если ЕстьЛишниеЭтапы Тогда
		
		Для Счетчик = ТекущийЭтап По КоличествоЭтапов-1 Цикл
			ЭтапыГрафикаОплаты.Удалить(ТекущийЭтап);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет один этап оплаты по умолчанию
//
// Параметры:
//
// 		Объект - ДокументОбъект - Документ, для которого заполняются этапы графика оплаты
// 		ВариантОплаты - ПеречислениеСсылка.ВариантыОплатыКлиентом; ПеречислениеСсылка.ВариантыОплатыПоставщику - Вариант оплаты добавляемого этапа
// 		ЖелаемаяДата - Дата - Желаемая дата по документу
// 		СуммаОплатыПоДокументу - Число - сумма к оплате по документу
// 		СуммаЗалогаПоДокументу - Число - сумма залога по документу
//
Процедура ДобавитьЭтапОплатыПоУмолчанию(Объект, ВариантОплаты, Знач ЖелаемаяДата, Знач СуммаОплатыПоДокументу, Знач СуммаЗалогаПоДокументу = 0) Экспорт
	
	ЭтапыОплаты = Объект.ЭтапыГрафикаОплаты;
	
	Если ЭтапыОплаты.Количество() > 0 Тогда
		ЭтапыОплаты.Очистить();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЖелаемаяДата) Тогда
		ДатаПлатежа = ЖелаемаяДата;
	ИначеЕсли ЗначениеЗаполнено(Объект.Дата) Тогда
		ДатаПлатежа = Объект.Дата;
	Иначе
	#Если Клиент Тогда
		ДатаПлатежа = ОбщегоНазначенияКлиент.ДатаСеанса();
	#Иначе
		ДатаПлатежа = ТекущаяДатаСеанса();
	#КонецЕсли
	КонецЕсли;
	
	ДанныеЭтапа = Новый Структура;
	ДанныеЭтапа.Вставить("ДатаПлатежа",         ДатаПлатежа);
	ДанныеЭтапа.Вставить("ВариантОплаты",       ВариантОплаты);
	ДанныеЭтапа.Вставить("ПроцентПлатежа",      ?(СуммаОплатыПоДокументу = 0, 0, 100));
	ДанныеЭтапа.Вставить("СуммаПлатежа",        СуммаОплатыПоДокументу);
	ДанныеЭтапа.Вставить("ПроцентЗалогаЗаТару", ?(СуммаЗалогаПоДокументу = 0, 0, 100));
	ДанныеЭтапа.Вставить("СуммаЗалогаЗаТару",   СуммаЗалогаПоДокументу);
	
	НовыйЭтап = ЭтапыОплаты.Добавить();
	ЗаполнитьЗначенияСвойств(НовыйЭтап, ДанныеЭтапа);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структру для получение надписи этапов оплаты для документа "Реализация товаров и услуг".
//
// Возвращаемое значение:
// 		Структура
//
Функция СтруктураПолученияНадписиЭтаповОплатыДляРеализациииТоваровУслуг() Экспорт
	
	Возврат Новый Структура(
		"ФормаОплаты, ПорядокРасчетов, ХозяйственнаяОперация, Дата, ДатаПлатежа,
		|СуммаВсего, СуммаПредоплаты,
		|РеализацияПоЗаказам, ИспользоватьСтатусыРеализацийТоваровУслуг,",
		Неопределено, Неопределено, Неопределено, Неопределено, Неопределено,
		0, 0,
		Ложь, Ложь);
	
КонецФункции

// Возвращает информативное представление формы оплаты для документов
//
// Параметры:
// 		ФормаОплаты - ПеречислениеСсылка.ФормыОплаты - форма оплаты. для которой нужно получить представление
//
// Возвращаемое значение:
// 		Строка - представление формы оплаты
//
Функция ПредставлениеФормыОплаты(ФормаОплаты)
	
	Представление = "";
	
	Если Не ЗначениеЗаполнено(ФормаОплаты) Тогда
		Представление = НСтр("ru='К оплате';uk='До оплати'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Безналичная") Тогда
		Представление = НСтр("ru='К оплате безнал';uk='До оплати безгот'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличная") Тогда
		Представление = НСтр("ru='К оплате нал';uk='До оплати гот'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта") Тогда
		Представление = НСтр("ru='К оплате платежной картой';uk='До оплати платіжною картою'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Взаимозачет") Тогда
		Представление = НСтр("ru='Взаимозачет';uk='Взаємозалік'");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает информативное представление формы оплаты для соглашений
//
// Параметры:
// 		ФормаОплаты - ПеречислениеСсылка.ФормыОплаты - форма оплаты. для которой нужно получить представление
//
// Возвращаемое значение:
// 		Строка - представление формы оплаты
//
Функция ПредставлениеФормыОплатыДляСоглашений(ФормаОплаты)
	
	Представление = "";
	
	Если Не ЗначениеЗаполнено(ФормаОплаты) Тогда
		Представление = НСтр("ru='Оплата: Любая';uk='Оплата: Будь-яка'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта") Тогда
		Представление = НСтр("ru='Оплата платежной картой';uk='Оплата платіжною картою'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Взаимозачет") Тогда
		Представление = НСтр("ru='Взаимозачет';uk='Взаємозалік'");
	Иначе
		Представление = НСтр("ru='%ФормаОплаты% оплата';uk='%ФормаОплаты% оплата'");
		Представление = СтрЗаменить(Представление, "%ФормаОплаты%", ФормаОплаты);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает сокращенное представление формы оплаты
//
// Параметры:
// 		ВариантОплаты - ПеречислениеСсылка.ВариантыОплатыКлиентом
//                    - ПеречислениеСсылка.ВариантыОплатыПоставщику 
//                    - вариант оплаты. для которого нужно получить представление
//
// Возвращаемое значение:
// 		Строка - представление варианта оплаты
//
Функция ПредставлениеВариантаОплаты(ВариантОплаты)
	
	Представление = "";
	
	Если ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.ПредоплатаДоПоступления") Тогда
		Представление = НСтр("ru='Предоплата';uk='Передплата'");
	ИначеЕсли ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.КредитПослеПоступления") Тогда
		Представление = НСтр("ru='Кредит';uk='Кредит'");
	ИначеЕсли ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.АвансДоОбеспечения")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.АвансДоПодтверждения") Тогда
		Представление = НСтр("ru='Аванс';uk='Аванс'");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ПараметрыОФормленияНадписиЭтапыОплаты()
	
	СтруктураПараметров = Новый Структура(
		"ЦветПредупреждение, ЦветВыделение, ФорматДаты, ФорматДоли",
		WebЦвета.Кирпичный,
		Новый Цвет(22, 39, 121),
		"ДЛФ=D",
		"ЧЦ=3; ЧДЦ=; ЧН=0"
	);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти
