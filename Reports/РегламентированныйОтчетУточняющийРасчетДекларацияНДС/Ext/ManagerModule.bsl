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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21';uk= 'Затверджено Наказом Міністерства фінінсів від 28.01.2016 № 21'");
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-07-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Мес8УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21 (с изменениями внесенными Приказом Минфина от 25.05.2016 № 503)';uk= 'Затверджено Наказом Міністерства фінінсів від 28.01.2016 № 21 (зі змінами,  що внесені Наказом Мінфіна від 25.05.2016 № 503)'");
	НоваяФорма.ДатаНачалоДействия = '2016-08-01';
	НоваяФорма.ДатаКонецДействия  = '2017-02-28';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21 (в редакции Приказа Минфина от 23.02.2017 № 276)';uk= 'Затверджено Наказом Міністерства фінінсів від 28.01.2016 № 21 (в редакції Наказу Мінфіна від 23.02.2017 № 276)'");
	НоваяФорма.ДатаНачалоДействия = '2017-03-01';
	НоваяФорма.ДатаКонецДействия  = '2018-05-31';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21 (в редакции Приказа Миинфина от 23.02.2017 № 276, с изменениями от 23.03.2018 согласно Приказа Минфина № 381)';uk= 'Затверджено Наказом Міністерства фінінсів від 28.01.2016 № 21 (в редакції Наказу Мінфіна від 23.02.2017 № 276, зі змінами від 23.03.2018 згідно Наказу Мінфіна № 381)'");
	НоваяФорма.ДатаНачалоДействия = '2018-06-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
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