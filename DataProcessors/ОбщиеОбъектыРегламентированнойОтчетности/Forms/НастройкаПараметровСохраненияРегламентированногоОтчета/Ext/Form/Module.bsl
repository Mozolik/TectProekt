﻿
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПутьДляВыгрузки = Параметры.ПутьДляВыгрузки;
	
	Если СокрЛП(ПутьДляВыгрузки)="" Тогда
				
		ПутьДляВыгрузки = ХранилищеНастроекДанныхФорм.Загрузить("Обработка.ОбщиеОбъектыРегламентированнойОтчетности.Форма.НастройкаПараметровСохраненияРегламентированногоОтчета",
										                        "ПутьДляВыгрузкиРегламентированныхОтчетов");
				
	КонецЕсли;
		
КонецПроцедуры // ПриСозданииНаСервере()

// ПутьДляВыгрузкиНачалоВыбора()
//
&НаКлиенте
Процедура ПутьДляВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПутьДляВыгрузкиУстановитьРасширениеЗавершение", ЭтотОбъект);
		НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещения);
	Иначе
		ПутьДляВыгрузкиНачалоВыбораЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьДляВыгрузкиУстановитьРасширениеЗавершение(ДополнительныеПараметры) Экспорт
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не удалось подключить расширение работы с файлами!"
"Выбор каталога невозможен.';uk='Не вдалося підключити розширення роботи з файлами!"
"Вибір каталогу неможливий.'"));
	Иначе
		ПутьДляВыгрузкиНачалоВыбораЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьДляВыгрузкиНачалоВыбораЗавершение()
	
	Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Длг.Заголовок = НСтр("ru='Укажите каталог';uk='Вкажіть каталог'");
	Длг.Каталог   = ПутьДляВыгрузки;
	Если Длг.Выбрать() Тогда
		РазделительПутиОС = ПолучитьРазделительПути();
		ПутьДляВыгрузки = Длг.Каталог+?(Прав(Длг.Каталог, 1) <> РазделительПутиОС, РазделительПутиОС, "");
	КонецЕсли;
	
КонецПроцедуры // ПутьДляВыгрузкиНачалоВыбора()

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьУстановитьРасширениеЗавершение", ЭтотОбъект);
		НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещения);
	Иначе
		СохранитьЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьУстановитьРасширениеЗавершение(ДополнительныеПараметры) Экспорт
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Не удалось подключить расширение работы с файлами!"
"Сохранение файла выгрузки невозможно.';uk='Не вдалося підключити розширення роботи з файлами!"
"Збереження файлу вивантаження неможливе.'");
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстВопроса);
	Иначе
		СохранитьЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение()

	Если Лев(ПутьДляВыгрузки, 2) <> "\\" Тогда

		// Если при указании пути для выгрузки вручную не указан концевой слэш - добавляем его.
		РазделительПутиОС = ПолучитьРазделительПути();
		Если Прав(ПутьДляВыгрузки, 1) <> РазделительПутиОС Тогда
			ПутьДляВыгрузки = ПутьДляВыгрузки + РазделительПутиОС;
		КонецЕсли;

		Кат = Новый Файл(ПутьДляВыгрузки + "NUL");
		
		Если НЕ Кат.Существует() Тогда

			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Нет доступа к каталогу %1.';uk='Немає доступу до каталогу %1.'"), ПутьДляВыгрузки);

			Текст = Текст + Символы.ПС + НСтр("ru='Проверьте корректность имени каталога выгрузки!';uk='Перевірте коректність імені каталогу вивантаження!'");

			ПоказатьПредупреждение(,Текст);
			Возврат;
			
		КонецЕсли;
			
	КонецЕсли;

	Кат = Новый Файл(ПутьДляВыгрузки);
	Если Кат.Существует() и Кат.ЭтоКаталог() Тогда
		СохранитьЗначениеНаСервере();
		ЭтаФорма.Закрыть(Истина);
	Иначе
		ПоказатьПредупреждение(,НСтр("ru='Имя каталога задано неверно! Проверьте правильность указания имени каталога!';uk=""Ім'я каталогу задане невірно! Перевірте правильність вказаного ім'я каталогу!"""));
	КонецЕсли;
	
КонецПроцедуры // Сохранить()

&НаКлиенте
Процедура ЗакрытьФормуЗавершение(ДополнительныеПараметры) Экспорт
	
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры


// СохранитьЗначениеНаСервере()
//
&НаСервере
Процедура СохранитьЗначениеНаСервере()
	
	ХранилищеНастроекДанныхФорм.Сохранить("Обработка.ОбщиеОбъектыРегламентированнойОтчетности.Форма.НастройкаПараметровСохраненияРегламентированногоОтчета",
										  "ПутьДляВыгрузкиРегламентированныхОтчетов", 
										  ПутьДляВыгрузки);
	
КонецПроцедуры // СохранитьЗначениеНаСервере()

