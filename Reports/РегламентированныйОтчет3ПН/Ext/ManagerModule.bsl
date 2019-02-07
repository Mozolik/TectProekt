﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Министерства социальной политики Украины №316 от 31.05.2013 года.';uk= 'Затверджена наказом Міністерства соціальної політики України №316 від 31.05.2013 року.'"); 
	НоваяФорма.ДатаНачалоДействия = '20130712';
	НоваяФорма.ДатаКонецДействия  = '20170212';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Приказ Минсоцполитики Украины № 316 от 31.05.2013 г. (в редакции Приказа Минсоцполитики Украины от 05.12.2016 г. N 1476)';uk= 'Наказ Мінсоцполітики України №316 від 31.05.2013 р. (у редакції наказу Мінсоцполітики України від 05.12.2016 р. N 1476)'"); 
	НоваяФорма.ДатаНачалоДействия = '20170213';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");          
	                                                                       //дата приказа    //номер приказа     //имя формы
	Форма19990331 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '1999-03-31'		,"22-2"				,"ФормаОтчета2003Кв4");
	Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2006-12-11'		,"18-1"				,"ФормаОтчета2007Кв1");
	Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2008-03-05'		,"32-3"				,"ФормаОтчета2008Кв1");
	Форма20091001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2009-09-25'		,"24-1"				,"ФормаОтчета2009Кв4");
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-12-09'		,"12-1"				,"ФормаОтчета2012Кв1");
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-02-07'		,"454"				,"ФормаОтчета2013Кв1");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-06-27'		,"454"				,"ФормаОтчета2013Кв3");
	
	Возврат ФормыИФорматы;
	
КонецФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецЕсли