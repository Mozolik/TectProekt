﻿
#Область ПрограммныйИнтерфейс

// Заполняет массив структур, которые будут использованы для начального заполнения и
// восстановления начального заполнения профилей.
//
// Параметры:
// ОписанияПрофилей	- Массив
//
Процедура ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт
	
#Область Описание_профилей_Учет_производства
	ДобавитьПрофильЛокальногоДиспетчера(ОписанияПрофилей);
	ДобавитьПрофильТехнолог(ОписанияПрофилей);
	ДобавитьПрофильМенеджераПоПроизводствуНаСтороне(ОписанияПрофилей);
#КонецОбласти
	
#Область Описание_профилей_Регламентированный_учет
	ДобавитьПрофильБухгалтерВнеоборотныхАктивов(ОписанияПрофилей);
#КонецОбласти
	
#Область Описание_профилей_Бюджетирование
	ДобавитьПрофильАдминистраторБюджетирования(ОписанияПрофилей);
	ДобавитьПрофильУчастникБюджетногоПроцесса(ОписанияПрофилей);
#КонецОбласти
	
#Область Описание_профилей_Зарплата_и_кадры
	ДобавитьПрофилиЗарплатаИКадры(ОписанияПрофилей, ПараметрыОбновления);
#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Общие

// Служебная фунция. Сделана экспортной для удобства внедренцев.
//
Процедура ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля) Экспорт
	
	УправлениеДоступомУТ.ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеИнформационногоЦентра");
	
КонецПроцедуры

#КонецОбласти

#Область Учет_производства

Процедура ДобавитьПрофильЛокальногоДиспетчера(ОписанияПрофилей)

	// Профиль "Локальный диспетчер производства".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "ЛокальныйДиспетчер";
	ОписаниеПрофиля.Идентификатор = "2c1871fb-5fef-408d-adf8-4edcb6ab6c5c";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Локальный диспетчер производства';uk='Локальний диспетчер виробництва'");
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	// Справочники, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПроизводстваВПанелиНавигацииНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеБригад");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРаспоряженийНаВыпускПродукции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхФизическихЛицЗарплатаКадры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТМЦВЭксплуатации");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПараметровПооперационногоПланирования");
	//-- НЕ УТКА
	
	// Регистры, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафикаПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыпускаПродукцииРегистр");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТрудозатратПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекРаспределенияЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоступностиВидовРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРемонтовРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроизводственныхЗатрат");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРемонтов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводствоСпецификации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводствоТрудозатраты");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаВнутреннееПотребление");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаПеремещение");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаСборку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКПоступлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровНаСкладах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковМатериаловИРаботВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПотреблениеМатериаловИУслугВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКОтгрузке");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПооперационногоРасписания");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоступностиРабочихЦентров");
	//-- НЕ УТКА
	
	// Документы, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПроизводствуНаСтороне");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПереработкеДавальческогоСырья");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафиковРаботыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаРемонт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыпускаПродукции");
	
	// Справочники, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПричинЗадержекВыполненияМаршрутныхЛистов");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПараметровПооперационногоПланирования");
	//-- НЕ УТКА
	
	// Документы, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеМаршрутныхЛистовПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПередачМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратовМатериаловИзПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхНакладных");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПеремещенияМатериаловВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеИзделияИЗатратыНЗП");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКорректировокЗаказаМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасходныхОрдеровНаТовары");
	
	// Регистры, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастроекПередачиМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасписанияРабочихЦентров");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПооперационногоРасписания");
	//-- НЕ УТКА
	
	// Обработки, отчеты.
	ОписаниеПрофиля.Роли.Добавить("ПравоНаВводГрафиковРаботыРЦДляФормированияРасписанияРаботыРЦ");
	ОписаниеПрофиля.Роли.Добавить("ОтчетыЛокальногоДиспетчера");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПолученияМатериаловПоЗаказамНаВнутреннееПотребление");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПараметрыОбеспеченияПотребностей");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовПоВыполнениюМаршрутныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетовОЗагрузкеРабочихЦентров");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеВыполненияОпераций");
	//-- НЕ УТКА
	
	// КИ
	ОписаниеПрофиля.Роли.Добавить("РазделПроизводство");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru='Зона ответственности - один или несколько этапов производства.
                                            |Под профилем выполняются задачи:
                                            |1. формирование маршрутных листов по графику производства;
                                            |2. управление незначительными отклонениями внутри этапа;
                                            |3. корректировка состава технологических операций внутри этапа;
                                            |4. корректировка используемых ресурсов внутри этапа;
                                            |5. оперативный анализ загрузки оборудования и наличия ресурсов при выполнении этапа;
                                            |6. анализ наличия ТМЦ на центральных складах и в цеховой кладовой;
                                            |7. формирование заявок на перемещение с центральных складов;
                                            |8. ввод данных инвентаризации НЗП;
                                            |9. уведомление Главного диспетчера о возникновении глобальных отклонений.'
                                            |;uk='Зона відповідальності - один або декілька етапів виробництва.
                                            |Під профілем виконуються задачі:
                                            |1. формування маршрутних листів за графіком виробництва;
                                            |2. управління незначними відхиленнями всередині етапу;
                                            |3. коригування складу технологічних операцій всередині етапу;
                                            |4. коригування ресурсів, які використовуються, всередині етапу;
                                            |5. оперативний аналіз завантаження устаткування і наявності ресурсів при виконанні етапу;
                                            |6. аналіз наявності ТМЦ на центральних складах і в цеховій коморі;
                                            |7. формування заявок на переміщення з центральних складів;
                                            |8. введення даних інвентаризації НЗВ;
                                            |9. повідомлення Головного диспетчера про виникнення глобальних відхилень.'");

	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильТехнолог(ОписанияПрофилей)
	
	// Профиль "Технолог".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "Технолог";
	ОписаниеПрофиля.Идентификатор = "fd7b587b-ad0a-486e-9512-ad99447c8b89";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Технолог';uk='Технолог'");
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	// Справочники, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеПроизводстваВПанелиНавигацииНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеБригад");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтатейКалькуляции");
	
	// Справочники, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКлассификаторовИНастроекНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	
	// Документы, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовКлиентовЗаявокНаВозвратТоваровОтКлиента");
	
	// Документы, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРазрешенийНаЗаменуМатериалов");
	
	// Регистры, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекПередачиМатериаловВПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАналоговВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства");
	
	// Регистры, добавление изменение.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОсновныхСпецификаций");
	
	// Обработки, отчеты.
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеДереваРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеРедактированиеСпецификацииСтрокиЗаказа");
	
	// КИ
	ОписаниеПрофиля.Роли.Добавить("РазделПроизводство");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru='Под профилем выполняются задачи:
    |1. анализ существующих, доработка и разработка новых технологических процессов;
    |2. расчет расходования сырья и материалов;
    |3. разработка технологической документации (технологических нормативов, инструкций, маршрутных карт и др.);
    |4. разработка технических заданий на проектирование и производство оборудования;
    |5. проведение экспериментальных работ по освоению новых технологических процессов;
    |6. выявление брака, нарушений при работе оборудования на технологических линиях (новых и существующих), анализ причин и их устранение;
    |7. контроль соблюдения технологии производственного процесса и эксплуатации оборудования.'
    |;uk='Під профілем виконуються задачі:
    |1. аналіз існуючих, доопрацювання та розробка нових технологічних процесів;
    |2. розрахунок витрачання сировини і матеріалів;
    |3. розробка технологічної документації (технологічних нормативів, інструкцій, маршрутних карт і ін);
    |4. розробка технічних завдань на проектування та виробництво устаткування;
    |5. проведення експериментальних робіт з освоєння нових технологічних процесів;
    |6. виявлення браку, порушень при роботі устаткування на технологічних лініях (нових та існуючих), аналіз причин та їх усунення;
    |7. контроль дотримання технології виробничого процесу та експлуатації устаткування.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьПрофильМенеджераПоПроизводствуНаСтороне(ОписанияПрофилей)
	
	// Профиль "Менеджер по производству на стороне".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "МенеджерПоПроизводствуНаСтороне";
	ОписаниеПрофиля.Идентификатор = "7387da7a-e932-11e2-a832-c86000df10d3";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Менеджер по производству на стороне';uk='Менеджер з виробництва на стороні'");
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	///////////////////////////////////////////////////////////////////////
	// Базовые права.
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваУТ");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСделок");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНазначений");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКалендарей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоПартнерам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСПоставщиками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПодключаемогоОборудованияOffline");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатурыПартнеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРесурсныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтатейКалькуляции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСтруктурыРабочихЦентров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхФизическихЛицЗарплатаКадры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКасс");
	
	///////////////////////////////////////////////////////////////////////
	// Справочники, добавление изменение.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТранспортныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ИзменениеСкладскойИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("РегистрацияШтрихкодовНоменклатуры");
	
	///////////////////////////////////////////////////////////////////////
	// Регистры, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРегистровПартий");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЭтаповПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРасчетовСПоставщиками");	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровНаСкладах");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПотреблениеМатериаловИУслугВПроизводстве");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовПоставщикам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКОтгрузке");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковТоваровКПоступлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДенежныхСредствКРасходу");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСебестоимостиТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТоваровОрганизацийКОформлению");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАссортимента");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыпускаПродукцииРегистр");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхСпецификаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОсновныхМаршрутныхКарт");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРаспоряженийНаВыпускПродукции");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеГрафикаПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводствоСпецификации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, чтение.
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаданийНаПеревозку");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаПроизводство");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВводаОстатков");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКассовыхОрдеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДенежныхДокументов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеАвансовыхОтчетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаявокНаРасходДС");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОтчетовКомиссионеров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВозвратовТоваровОтКлиентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовКорректировкиЗадолженности");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовСписанияПоступленияБезналичныхДС");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПередачиТоваровМеждуОрганизациями");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеВыданныхДоверенностей");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКорректировокОбособленногоУчетаЗапасов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПоступленийУслугПрочихАктивов"); 
	ОписаниеПрофиля.Роли.Добавить("ЧтениеРегламентныхОпераций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеТранспортныхНакладных");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУпаковочныхЛистов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДокументовПоПереработкеДавальческогоСырья");
	
	///////////////////////////////////////////////////////////////////////
	// Документы, добавление изменение.
	
	ОписаниеПрофиля.Роли.Добавить("ЗачетОплаты");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовПереработчикам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтчетовПереработчиков");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПередачСырьяПереработчикам");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПоступленийОтПереработчиков");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратовОтПереработчиков");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВыданныхДоверенностей");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРасходныхОрдеровНаТовары");
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ИспользованиеРабочегоМестаЗаказыПереработчикам");
	//-- НЕ УТКА

	///////////////////////////////////////////////////////////////////////
	// Обработки, отчеты.
	
	ОписаниеПрофиля.Роли.Добавить("ОтчетыПроизводстваНаСтороне");
	ОписаниеПрофиля.Роли.Добавить("ПросмотрОтчетаСостояниеВыполненияДокумента");
	
	///////////////////////////////////////////////////////////////////////
	// Видимые подсистемы КИ
	
	ОписаниеПрофиля.Роли.Добавить("РазделПроизводство");
	ОписаниеПрофиля.Роли.Добавить("РазделПроизводствоПроизводствоНаСтороне");
	ОписаниеПрофиля.Роли.Добавить("РазделНормативноСправочнаяИнформация");
	
	///////////////////////////////////////////////////////////////////////
	// Виды доступа
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",				"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыПартнеров",		"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыФизическихЛиц",	"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыНоменклатуры",	"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации",			"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Склады",				"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВидыЦен",				"ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения",		"ВначалеВсеРазрешены");
	
	///////////////////////////////////////////////////////////////////////
	// Дополнительные права.
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастройкиПечатиОбъектов");
	ОписаниеПрофиля.Роли.Добавить("СохранениеНастроекПечатиОбъектовПоУмолчанию");
	
	///////////////////////////////////////////////////////////////////////
	// Описание поставляемого профиля.
	
	ОписаниеПрофиля.Описание =
		НСтр("ru='Под профилем выполняются задачи:
                    |1. Оформление заказов переработчикам;
                    |2. Отражения поступлений от переработчиков и передач переработчикам;
                    |3. Оформление отчетов переработчиков о выполнении услуг по переработке.'
                    |;uk='Під профілем виконуються задачі:
                    |1. Оформлення замовлень переробникам;
                    |2. Відображення надходжень від переробників і передач переробникам;
                    |3. Оформлення звітів переробників про виконання послуг з переробки.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти

#Область Регламентированный_учет

Процедура ДобавитьПрофильБухгалтерВнеоборотныхАктивов(ОписанияПрофилей)
	
	// Профиль "Бухгалтер по внеоборотным активам".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "БухгалтерПоВнеоборотнымАктивам";
	ОписаниеПрофиля.Идентификатор = "ddb10492-ea5e-11e3-b754-c86000df10d3";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Бухгалтер по внеоборотным активам';uk='Бухгалтер по необоротних активах'");
	
	ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
	
	// Видимые подсистемы КИ
	ОписаниеПрофиля.Роли.Добавить("РазделРегламентированныйУчет");
	
	// Справочники, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНематериальныхАктивов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОбъектовЭксплуатации");
	// Справочники, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоПартнерам");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСКлиентами");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСоглашенийСПоставщиками");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДоговоровКонтрагентов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоНоменклатуре");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхФизическихЛицЗарплатаКадры");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПоказателейНаработки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКлассовОбъектовЭксплуатации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОбщейБухгалтерскойНСИ");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеУзловОбъектовЭксплуатации");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеКатегорийЭксплуатации");
	
	// Документы, добавление.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПрочихОприходованийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВнутреннихПотребленийТоваров");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПоступленийУслугПрочихАктивов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРеализацийУслугПрочихАктивов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДокументовОС");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДокументовНМА");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРегистрацийНаработок");
	
	// Документы, чтение.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЗаказовНаВнутреннееПотребление");
	
	// Добавление/изменение регистров
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРегистрацииЗемельныхУчастков");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеРегистрацииТранспортныхСредств");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПорядкаОтраженияДоходов");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПорядкаОтраженияПрочихОпераций");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПорядкаОтраженияРасходов");
	
	// Чтение регистров.
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхРегламентированногоУчета");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеСостоянийДоставки");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковДоступныхТоваров");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеОстатковЗаказовНаВнутреннееПотребление");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеЦенНоменклатуры");
	
	// Отчеты и обработки.
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастроекОтраженияДокументовВРеглУчете");
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации", "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = 
		НСтр("ru='Дополнительный профиль, назначаемый пользователям для выполнения задач учета внеоборотных активов:
        |1. Сопровождения нормативно-справочной информации
        |2. Ведения документов движений внеоборотных активов
        |3. Получение отчетов по данным бухгалтерского и налогового учета.'
        |;uk='Додатковий профіль, який призначається користувачам для виконання задач з обліку необоротних активів:
        |1. Супроводження нормативно-довідкової інформації
        |2. Ведення документів рухів необоротних активів
        |3. Отримання звітів за даними бухгалтерського і податкового обліку.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти

#Область Бюджетирование

Процедура ДобавитьПрофильАдминистраторБюджетирования(ОписанияПрофилей)
	
	// Профиль "Администратор бюджетирования (дополнительный)".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "АдминистраторБюджетирования";
	ОписаниеПрофиля.Идентификатор = "4c4594ee-e699-40b4-9517-cedb7bf432ba";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Администратор бюджетирования (дополнительный)';uk='Адміністратор бюджетування (додатковий)'");
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНастроекБюджетирования");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЭкземпляровБюджетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхБюджетирования");
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПланаПродаж");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановЗакупок");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПланаПродажПоКатегориям");
	
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("УправлениеБюджетнымПроцессом");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзмененениеВыполнениеБюджетныхЗадач");
	//-- НЕ УТКА
	
	// КИ.
	ОписаниеПрофиля.Роли.Добавить("РазделБюджетированиеИПланирование");
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации",   "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Пользователи",  "ВначалеВсеРазрешены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru='Под профилем выполняются задачи:
                        |1. Настройка нормативно-справочной информации бюджетирования.
                        |2. Настройка бюджетных моделей.'
                        |;uk='Під профілем виконуються задачі:
                        |1. Настройка нормативно-довідкової інформації бюджетування.
                        |2. Настройка бюджетних моделей.'");

	ОписанияПрофилей.Добавить(ОписаниеПрофиля);

КонецПроцедуры

Процедура ДобавитьПрофильУчастникБюджетногоПроцесса(ОписанияПрофилей)
	
	// Профиль "Участник бюджетного процесса (дополнительный)".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Имя           = "УчастникБюджетногоПроцесса";
	ОписаниеПрофиля.Идентификатор = "b4787381-b3a8-4846-9195-f0f29c2eef9d";
	ОписаниеПрофиля.Наименование  = НСтр("ru='Участник бюджетного процесса (дополнительный)';uk='Учасник бюджетного процесу (додатковий)'");
	
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекБюджетирования");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЭкземпляровБюджетов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхБюджетирования");
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПланаПродаж");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановЗакупок");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановПроизводства");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПланаПродажПоКатегориям");
	
	//++ НЕ УТКА
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзмененениеВыполнениеБюджетныхЗадач");
	//-- НЕ УТКА
	
	// КИ.
	ОписаниеПрофиля.Роли.Добавить("РазделБюджетированиеИПланирование");
	
	// Виды доступа.
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации",   "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Подразделения", "ВначалеВсеРазрешены");
	ОписаниеПрофиля.ВидыДоступа.Добавить("Пользователи",  "ВначалеВсеЗапрещены");
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание 
		= НСтр("ru='Дополнительный профиль, который назначется пользователям, выполняющим задачи ввода и анализа данных бюджетирования.';uk='Додатковий профіль, який назначется користувачам, що виконують задачі введення і аналізу даних бюджетування.'");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

#КонецОбласти

#Область Зарплата_и_кадры

Процедура ДобавитьПрофилиЗарплатаИКадры(ОписанияПрофилей, ПараметрыОбновления, ДополнятьОбязательнымиРолями = Истина)
	
	КоличествоПрофилейУТУП = ОписанияПрофилей.Количество();
	
	Для НомерПрофиля = 1 По ОписанияПрофилей.Количество() Цикл
		
		ОписаниеПрофиля = ОписанияПрофилей[НомерПрофиля - 1];
		
		Если ОписаниеПрофиля.Роли.Найти("ЧтениеДанныхФизическихЛицЗарплатаКадры") <> Неопределено Тогда
			ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхФизическихЛицЗарплатаКадрыРасширенная");
		КонецЕсли;
		
		Если ОписаниеПрофиля.Роли.Найти("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") <> Неопределено Тогда
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадрыРасширенная");
		КонецЕсли;
		
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления);
	
	Для НомерПрофиля = КоличествоПрофилейУТУП + 1 По ОписанияПрофилей.Количество() Цикл
		
		ОписаниеПрофиля = ОписанияПрофилей[НомерПрофиля - 1];
		
		// Добавим в профиль БЗКР обязательные права УТ/УП
		ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
		
		ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
		
		// Добавим в профиль БЗКР роли на просмотр интерфейсных подсистем
		Если ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровик()
		 ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийКадровик() Тогда
			ОписаниеПрофиля.Роли.Добавить("РазделКадры");
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляРасчетчик()
		 ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийРасчетчик()
		 ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляТабельщик() Тогда
			ОписаниеПрофиля.Роли.Добавить("РазделЗарплата");
		Иначе
			// Аудитор, КадровикРасчетчик, СтаршийКадровикРасчетчик
			ОписаниеПрофиля.Роли.Добавить("РазделКадры");
			ОписаниеПрофиля.Роли.Добавить("РазделЗарплата");
		КонецЕсли;
		
		// Исключим не используемые в УТ/УП роли
		ИндексРоли = ОписаниеПрофиля.Роли.Найти("ПросмотрОписанияИзмененийПрограммы");
		Если ИндексРоли <> Неопределено Тогда
			ОписаниеПрофиля.Роли.Удалить(ИндексРоли);
		КонецЕсли;
		
		Если ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляРасчетчик()
			ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийРасчетчик()
			ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровикРасчетчик()
			ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийКадровикРасчетчик() Тогда
			
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДепонированнойЗарплаты");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеДепонированнойЗарплаты");
			
			ОписаниеПрофиля.Роли.Добавить("ОтражениеЗарплатыВФинансовомУчете");
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеОтраженияЗарплатыВФинансовомУчете");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеОтраженияЗарплатыВФинансовомУчете");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеВыполненныхРаботСотрудников");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеИнформацииПоПартнерам");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеВидовРаботСотрудников");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеРасценокРаботСотрудников");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхРегламентированногоУчета");
			
		КонецЕсли;
		
		Если ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровик()
			ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийКадровик()
			ИЛИ ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровикБезДоступаКЗарплате() Тогда
			
			ОписаниеПрофиля.Роли.Добавить("ЧтениеНормативноСправочнойИнформации");
			ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхРегламентированногоУчета");
			
		КонецЕсли;
		
		// Привязка к предопределенным элементам.
		Если ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляАудитор() Тогда
			ОписаниеПрофиля.Имя = "Аудитор";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровик() Тогда
			ОписаниеПрофиля.Имя = "Кадровик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровикБезДоступаКЗарплате() Тогда
			ОписаниеПрофиля.Имя = "КадровикБезДоступаКЗарплате";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляКадровикРасчетчик() Тогда
			ОписаниеПрофиля.Имя = "КадровикРасчетчик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляРасчетчик() Тогда
			ОписаниеПрофиля.Имя = "Расчетчик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийКадровик() Тогда
			ОписаниеПрофиля.Имя = "СтаршийКадровик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийКадровикРасчетчик() Тогда
			ОписаниеПрофиля.Имя = "СтаршийКадровикРасчетчик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляСтаршийРасчетчик() Тогда
			ОписаниеПрофиля.Имя = "СтаршийРасчетчик";
		ИначеЕсли ОписаниеПрофиля.Идентификатор = ЗарплатаКадрыРасширенный.ИдентификаторПрофиляТабельщик() Тогда
			ОписаниеПрофиля.Имя = "Табельщик";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик первого запуска.
// Помещает профили подсистемы "Зарплата и кадры" в предопределенную группу.
//
Процедура УстановитьРодителяПрофилейДоступаЗарплатаИКадры() Экспорт
	
	// Подготовим вспомогательные данные
	ГруппаПрофилей      = Справочники.ПрофилиГруппДоступа.ЗарплатаИКадры;
	ОписанияПрофилей    = Новый Массив;
	ПараметрыОбновления = Новый Структура(
		"ОбновлятьИзмененныеПрофили, ЗапретитьИзменениеПрофилей,
		|ОбновлятьГруппыДоступа, ОбновлятьГруппыДоступаСУстаревшимиНастройками");
		
	// Получим описания профилей "Зарплата и кадры"
	ДобавитьПрофилиЗарплатаИКадры(ОписанияПрофилей, ПараметрыОбновления, Ложь);
	
	// Получим массив их идентификаторов
	МассивИдентификаторов = Новый Массив;
	Для Каждого ОписаниеПрофиля Из ОписанияПрофилей Цикл
		МассивИдентификаторов.Добавить(Новый УникальныйИдентификатор(ОписаниеПрофиля.Идентификатор));
	КонецЦикла;
	
	// Выберем профили "Зарплата и кадры" с неверно заполненным родителем
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.Ссылка,
	|   ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	НЕ ПрофилиГруппДоступа.ЭтоГруппа
	|	И НЕ ПрофилиГруппДоступа.Предопределенный
	|	И ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных В(&МассивИдентификаторов)
	|	И ПрофилиГруппДоступа.Родитель <> &ГруппаПрофилей";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	Запрос.УстановитьПараметр("ГруппаПрофилей",        ГруппаПрофилей);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Установим в качестве родителя группу "Зарплата и кадры"
	Пока Выборка.Следующий() Цикл
		ОбъектПрофиль = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектПрофиль.Родитель = ГруппаПрофилей;
		ОбъектПрофиль.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
