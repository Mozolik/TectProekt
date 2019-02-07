﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.Премия - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.Премия - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеПоВсемУчетам = Ложь;
	МассивРегистров = Новый Массив;
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, ПроведениеПоВсемУчетам, МассивРегистров);
	
	Если Объект <> Неопределено И ВидыУчетов = Неопределено Тогда
		ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект);
	КонецЕсли;        
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	Если РеквизитыДляПроведения.ДокументРассчитан Тогда 
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
			ДатаОперации	= УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации);
			МесяцНачисления	= РеквизитыДляПроведения.ПериодРегистрации;
			
			// Начисления
			РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
				
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
			
			// Удержания
			РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
			ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
			
			// НДФЛ
			УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(
				РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, РеквизитыДляПроведения.ПланируемаяДатаВыплаты, ДанныеДляПроведения, Истина, РеквизитыДляПроведения.РассчитыватьУдержания Или УчетНДФЛРасширенный.ДоходыВУчетеНДФЛРегистрируютсяПоДатеВыплаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.ВидПремии)));
				
					
			// Учет начисленной зарплаты
			УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
				
			// - Регистрация начислений и удержаний.
			ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
						ДанныеДляПроведения.НачисленияПоСотрудникам,
						ДанныеДляПроведения.УдержанияПоСотрудникам,
						ДанныеДляПроведения.НДФЛПоСотрудникам,
						РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
				
			// Страховые взносы
			УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
			УчетСтраховыхВзносов.СформироватьИсчисленныеВзносыАвансом(Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.СтраховыеВзносы);
			
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
				Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
				Модуль.ЗарегистрироватьНачисленияДляРасчетаСохраняемогоДенежногоСодержания(Движения, Отказ, МесяцНачисления, ДанныеДляПроведения.НачисленияДляРегистрацииДенежногоСодержания);
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			
			// Учет среднего заработка
			УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
			
		КонецЕсли;

	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, ПроведениеПоВсемУчетам, МассивРегистров);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.Премия);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о поощрении сотрудников.
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная,ЧтениеНачисленнойЗарплатыРасширенная", , Ложь) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПоощрениеСотрудников";
		КомандаПечати.Представление = НСтр("ru='Приказ о поощрении сотрудников';uk='Наказ про заохочення співробітників'");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
	КонецЕсли; 
	
	// Приказ о поощрении сотрудника.
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная,ЧтениеНачисленнойЗарплатыРасширенная", , Ложь) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_Поощрение";
		КомандаПечати.СписокФорм = "ФормаДокумента";
		КомандаПечати.Обработчик = "Форма.ПечатьФормаПоощрение";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВсехПриказов", Истина);
		КомандаПечати.Представление = НСтр("ru='Приказы на каждого сотрудника в отдельности';uk='Накази на кожного співробітника окремо'");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	МассивСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Сотрудник", Истина);
	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивСотрудников, "ФизическоеЛицо");
	МассивФизическихЛиц = ОбщегоНазначения.ВыгрузитьКолонку(ФизическиеЛицаСотрудников, "Значение", Истина);
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = МассивФизическихЛиц;
	ДанныеДляПроверкиОграничений.Подразделение = Объект.Подразделение;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Объект.ВидПремии;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = Объект.СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 

	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(
			ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации", "Ссылка.ВидПремии");
			
		ДанныеДляПроведения.НачисленияПоСотрудникам.ЗаполнитьЗначения(РеквизитыДляПроведения.Ссылка, "ДокументОснование");
			
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления");
		
		РасчетЗарплаты.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплаты.ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
			НачисленияДляРегистрацииДенежногоСодержания = Модуль.СведенияОНачисленияхДляРегистрацииДенежногоСодержанияДокумента(РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ВидПремии");
			ДанныеДляПроведения.Вставить("НачисленияДляРегистрацииДенежногоСодержания", НачисленияДляРегистрацииДенежногоСодержания);
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаДействия = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.Начисление = "Ссылка.ВидПремии";
		ДополнительныеПараметры.Таблицы.Начисления.НачалоБазовогоПериода = "Ссылка.ДатаНачалаБазовогоПериода";
		ДополнительныеПараметры.Таблицы.Начисления.ОкончаниеБазовогоПериода = "Ссылка.ДатаОкончанияБазовогоПериода";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаНачала = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаОкончания = "Ссылка.ПериодРегистрации";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;

КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Премия.Ссылка,
	|	Премия.ДокументРассчитан,
	|	Премия.Организация,
	|	Премия.ПериодРегистрации,
	|	Премия.Дата,
	|	Премия.ПорядокВыплаты,
	|	Премия.ПланируемаяДатаВыплаты,
	|	Премия.РассчитыватьУдержания,
	|	Премия.ВидПремии
	|ИЗ
	|	Документ.Премия КАК Премия
	|ГДЕ
	|	Премия.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.Премия.РаспределениеПоТерриториямУсловиямТруда КАК ПремияРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, ДокументРассчитан, Организация, ПериодРегистрации, Дата, ПорядокВыплаты, ПланируемаяДатаВыплаты, 
		| РассчитыватьУдержания, РаспределениеПоТерриториямУсловиямТруда, ВидПремии");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#КонецЕсли