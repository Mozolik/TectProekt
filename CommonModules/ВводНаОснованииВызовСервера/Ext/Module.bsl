﻿
#Область СлужебныеПроцедурыИФункции

Функция СообщениеОПредназначенииКомандыСоздатьНаОсновании(ТипыОбъектовСоздатьНаОсновании) Экспорт
	ТекстСообщения = НСтр("ru='Выбранная команда создания на основании предназначена для объектов';uk='Обрана команда створення на підставі призначена для об''єктів'") 
		+ ?(ТипыОбъектовСоздатьНаОсновании.Количество() = 1, " ", ": " + Символы.ПС);
	Для Каждого Тип Из ТипыОбъектовСоздатьНаОсновании Цикл
		ТекстСообщения = ТекстСообщения + Метаданные.НайтиПоТипу(Тип).ПредставлениеСписка + Символы.ПС;
	КонецЦикла;
	Возврат СокрЛП(ТекстСообщения);
КонецФункции

Функция ДоступноПравоПроведения(СписокДокументов) Экспорт
	Возврат ВводНаОсновании.ДоступноПравоПроведения(СписокДокументов);
КонецФункции

#КонецОбласти
