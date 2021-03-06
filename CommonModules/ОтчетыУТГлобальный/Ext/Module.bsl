﻿
#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьФоновыеЗадания() Экспорт
	ПараметрыПроверкиФоновыхЗаданий = ОтчетыУТКлиентПереопределяемый.ПараметрыПроверкиФоновыхЗаданий();
	Если ПараметрыПроверкиФоновыхЗаданий.Интервал < 15 Тогда
		ПараметрыПроверкиФоновыхЗаданий.Интервал = ПараметрыПроверкиФоновыхЗаданий.Интервал + 2;
	КонецЕсли;
	
	КлючиКУдалению = Новый Массив;
	ОтключитьОбработчикОжидания("ПроверитьФоновыеЗадания");
	
	Для Каждого Задание Из ПараметрыПроверкиФоновыхЗаданий.Задания Цикл 
		Результат = ОтчетыУТВызовСервераПереопределяемый.ПроверитьФоновоеЗадание(Задание.Ключ);
		Если Результат.УспешноВыполнено Тогда
			Если Задание.Ключ = "ПартионныйУчет" Тогда
				СписокФорм = Задание.Значение;
				ФормыКОповещению = ФормыКОповещению(Задание.Ключ, СписокФорм, ПараметрыПроверкиФоновыхЗаданий.Интервал);
				ПараметрыОбработчика = Новый Структура;
				ПараметрыОбработчика.Вставить("Формы", ФормыКОповещению);
				ФормыКОбработке = ФормыКОбработке(ФормыКОповещению, СписокФорм);
				Если ФормыКОбработке.Количество() > 0 Тогда
					ПараметрыОбработчика.Вставить("НеобработанныеФормы", ФормыКОбработке);
				КонецЕсли;
				ТекстВопроса = НСтр("ru='Выполнено распределение партий. Переформировать отчет?';uk='Виконаний розподіл партій. Переформувати звіт?'");
				ПоказатьВопросПользователю(ТекстВопроса, ПараметрыОбработчика);
			ИначеЕсли Задание.Ключ = "ВзаиморасчетыСКлиентами" ИЛИ Задание.Ключ = "ВзаиморасчетыСПоставщиками" 
			 ИЛИ Задание.Ключ = "Взаиморасчеты" Тогда
				ФормыКОповещению = ФормыКОповещению(Задание.Ключ, Задание.Значение, ПараметрыПроверкиФоновыхЗаданий.Интервал);
				ПараметрыОбработчика = Новый Структура;
				ПараметрыОбработчика.Вставить("Формы", ФормыКОповещению);
				ФормыКОбработке = ФормыКОбработке(ФормыКОповещению, СписокФорм);
				Если ФормыКОбработке.Количество() > 0 Тогда
					ПараметрыОбработчика.Вставить("НеобработанныеФормы", ФормыКОбработке);
				КонецЕсли;
				ТекстВопроса = НСтр("ru='Выполнено распределение расчетов. Переформировать отчет?';uk='Виконаний розподіл розрахунків. Переформувати звіт?'");
				ПоказатьВопросПользователю(ТекстВопроса, ПараметрыОбработчика);
			//++ НЕ УТ
			ИначеЕсли Задание.Ключ = "ОтражениеДокументовВБюджетировании" Тогда
				ФормыКОповещению = ФормыКОповещению(Задание.Ключ, Задание.Значение, ПараметрыПроверкиФоновыхЗаданий.Интервал);
				ПараметрыОбработчика = Новый Структура;
				ПараметрыОбработчика.Вставить("Формы", ФормыКОповещению);
				Если ФормыКОповещению.Количество() <> Задание.Значение.Формы.Количество() Тогда
					НеобработанныеФормы = Новый Соответствие;
					Для Каждого КлючИзначение из Задание.Значение.Формы Цикл
						Если Не КлючИзначение.Ключ.Открыта() Тогда
							Продолжить;
						КонецЕсли;
						Если ФормыКОповещению.Найти(КлючИзначение.Ключ) = Неопределено Тогда
							НеобработанныеФормы.Вставить(КлючИзначение.Ключ, КлючИзначение.Значение);
						КонецЕсли;
					КонецЦикла;
					Если НеобработанныеФормы.Количество() Тогда
						ПараметрыОбработчика.Вставить("НеобработанныеФормы", НеобработанныеФормы);
					КонецЕсли;
				КонецЕсли;
				Если ФормыКОповещению.Количество() Тогда
					ТекстВопроса = НСтр("ru='Выполнено отражение документов в бюджетировании. Переформировать отчет?';uk='Виконано відображення документів в бюджетуванні. Переформувати звіт?'");
					Обработчик = Новый ОписаниеОповещения("ФормаОтчетаПослеПодтвержденияПереформирования", ОтчетыУПКлиентПереопределяемый, ПараметрыОбработчика);
					СписокОтветов = Новый СписокЗначений;
					СписокОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Переформировать';uk='Переформувати'"));
					СписокОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Оставить как есть';uk='Залишити як є'"));
					ПоказатьВопрос(Обработчик, ТекстВопроса, СписокОтветов);
				КонецЕсли;
			//-- НЕ УТ
			КонецЕсли;
			КлючиКУдалению.Добавить(Задание.Ключ);
		ИначеЕсли Результат.ЕщеВыполняется Тогда
			ПодключитьОбработчикОжидания("ПроверитьФоновыеЗадания", ПараметрыПроверкиФоновыхЗаданий.Интервал, Истина);
			ЕстьВыполняющиесяЗадания = Истина;
		ИначеЕсли Результат.ВыполненоСОшибками Тогда
			ТекстСобытия = НСтр(Задание.Ключ, ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ТекстСобытия, "Ошибка", Результат.ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Ключ Из КлючиКУдалению Цикл
		ПараметрыПроверкиФоновыхЗаданий.Задания.Удалить(Ключ);
	КонецЦикла;
КонецПроцедуры

Процедура ПоказатьВопросПользователю(ТекстВопроса, ПараметрыОбработчика)
	Обработчик = Новый ОписаниеОповещения("ФормаОтчетаПослеПодтвержденияПереформирования", ОтчетыУТКлиентПереопределяемый, ПараметрыОбработчика);
	СписокОтветов = Новый СписокЗначений;
	СписокОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Переформировать';uk='Переформувати'"));
	СписокОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Оставить как есть';uk='Залишити як є'"));
	ПоказатьВопрос(Обработчик, ТекстВопроса, СписокОтветов);
КонецПроцедуры

Функция ФормыКОбработке(ФормыКОповещению, СписокФорм)
	КОбработке = Новый Соответствие;
	Если ФормыКОповещению.Количество() <> СписокФорм.Количество() Тогда
		Для Каждого ДанныеФормы Из СписокФорм Цикл
			Если Не ДанныеФормы.Ключ.Открыта() Тогда
				Продолжить;
			КонецЕсли;
			Если ФормыКОповещению.Найти(ДанныеФормы.Ключ) = Неопределено Тогда
				КОбработке.Вставить(ДанныеФормы.Ключ, ДанныеФормы.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат КОбработке;
КонецФункции

Функция ФормыКОповещению(ИмяЗадания, СписокФорм, Интервал)
	ФормыКОповещению = Новый Массив();
	Если ИмяЗадания = "ПартионныйУчет" Тогда
		ФормыКОповещению = ФормыПартийКОповещению(СписокФорм);
	ИначеЕсли ИмяЗадания = "Взаиморасчеты" ИЛИ ИмяЗадания = "ВзаиморасчетыСКлиентами" ИЛИ ИмяЗадания = "ВзаиморасчетыСПоставщиками" Тогда
		ФормыКОповещению = ФормыВзаиморасчетовКОповещению(СписокФорм);
	ИначеЕсли ИмяЗадания = "ОтражениеДокументовВБюджетировании" Тогда
		ФормыКОповещению = ФормыБюджетированияКОповещению(СписокФорм);
	КонецЕсли;
	
	Возврат ФормыКОповещению;
КонецФункции

Функция ФормыПартийКОповещению(СписокФорм)
	ФормыКОповещению = Новый Массив();
	Для Каждого Форма Из СписокФорм Цикл
		Если Не Форма.Ключ.Открыта() Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыФормы = Форма.Значение;
		МесяцВРасчете = ОтчетыУТВызовСервераПереопределяемый.ГраницаРасчетаПартий(ПараметрыФормы.ГраницаРасчета, ПараметрыФормы.НомерЗадания);
		Если НЕ ЗначениеЗаполнено(МесяцВРасчете) Тогда
			ФормыКОповещению.Добавить(Форма.Ключ);
		КонецЕсли;
	КонецЦикла;
	Возврат ФормыКОповещению;
КонецФункции

Функция ФормыВзаиморасчетовКОповещению(СписокФорм)
	ФормыКОповещению = Новый Массив();
	Для Каждого Форма Из СписокФорм Цикл
		ПараметрыФормы = Форма.Значение;
		НачалоРасчета = ОтчетыУТВызовСервераПереопределяемый.НачалоРаспределенияВзаиморасчетов(ПараметрыФормы.ГраницаВзаиморасчетов, 
			ПараметрыФормы.АналитикиКРасчету,
			ПараметрыФормы.ИмяРасчета,
			ПараметрыФормы.НомерЗадания);
		Если НЕ ЗначениеЗаполнено(НачалоРасчета) Тогда
			ФормыКОповещению.Добавить(Форма.Ключ);
		КонецЕсли;
	КонецЦикла;
	Возврат ФормыКОповещению;
КонецФункции

Функция ФормыБюджетированияКОповещению(ПараметрыЗадания)
	
	СписокФорм = ПараметрыЗадания.Формы;
	ФормыКОповещению = Новый Массив();
	
	Для Каждого Форма Из СписокФорм Цикл
		Если Не Форма.Ключ.Открыта() Тогда
			Продолжить;
		КонецЕсли;
		ФормаВходитВИнтервал = Ложь;
		Если ПараметрыЗадания.Параметры.НачалоПериода >= Форма.Значение.НачалоПериода
			И ПараметрыЗадания.Параметры.НачалоПериода <= Форма.Значение.КонецПериода Тогда
			ФормаВходитВИнтервал = Истина;
		КонецЕсли;
		Если ПараметрыЗадания.Параметры.КонецПериода >= Форма.Значение.НачалоПериода
			И ПараметрыЗадания.Параметры.КонецПериода <= Форма.Значение.КонецПериода Тогда
			ФормаВходитВИнтервал = Истина;
		КонецЕсли;
		Если ПараметрыЗадания.Параметры.НачалоПериода <= Форма.Значение.НачалоПериода
			И ПараметрыЗадания.Параметры.КонецПериода >= Форма.Значение.КонецПериода Тогда
			ФормаВходитВИнтервал = Истина;
		КонецЕсли;
		Если ФормаВходитВИнтервал Тогда
			ФормыКОповещению.Добавить(Форма.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ФормыКОповещению;
	
КонецФункции

#КонецОбласти
