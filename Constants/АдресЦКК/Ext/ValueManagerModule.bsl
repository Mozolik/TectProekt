﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриЗаписи(Отказ)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.МониторингЦКК, 
		НЕ ПустаяСтрока(ЭтотОбъект.Значение) И НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая()
	);
	
КонецПроцедуры

#КонецЕсли