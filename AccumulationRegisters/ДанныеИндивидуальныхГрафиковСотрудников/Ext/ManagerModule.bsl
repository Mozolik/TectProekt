﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ОписаниеРегистра() Экспорт
	ОписаниеРегистра = УчетРабочегоВремени.ОписаниеРегистраДанныхУчетаВремени();
	
	ОписаниеРегистра.МетаданныеРегистра = Метаданные.РегистрыНакопления.ДанныеИндивидуальныхГрафиковСотрудников;
	ОписаниеРегистра.ИмяПоляСотрудник = "Сотрудник";
	ОписаниеРегистра.ИмяПоляПериод = "Период";
	ОписаниеРегистра.ИмяПоляПериодРегистрации = "ПериодРегистрации";
	ОписаниеРегистра.ИмяПоляВидДанных = Неопределено;
	ОписаниеРегистра.ВидДанных = Перечисления.ВидыДанныхУчетаВремениСотрудников.ДанныеИндивидуальныхГрафиков;
	
	Возврат ОписаниеРегистра;
КонецФункции

#КонецЕсли
