﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбновлениеИнформационнойБазы

#Область ДокументыСОтражениемОднойДатой_ЗаполнитьДатуОтраженияВРеглУчете

Процедура ДокументыСОтражениемОднойДатой_ЗаполнитьДатуОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ТипыРегитраторовКОбработке = Новый Массив;
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтражениеЗарплатыВФинансовомУчете");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетПереработчика");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетКомитенту");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПриходныйКассовыйОрдер");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеНедостачТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВыпускПродукции");
	ТипыРегитраторовКОбработке.Добавить("Документ.РеализацияПодарочныхСертификатов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПодготовкаКПередачеНМА");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПереоценкаВалютныхСредств");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеТоваровУслуг");
	ТипыРегитраторовКОбработке.Добавить("Документ.РеализацияУслугПрочихАктивов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПрочееОприходованиеТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.РасчетСебестоимостиТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.МодернизацияОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациями");
	ТипыРегитраторовКОбработке.Добавить("Документ.ЗаписьКнигиПродаж");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВзаимозачетЗадолженности");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеДенежныхДокументов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетКомиссионераОСписании");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств");
	ТипыРегитраторовКОбработке.Добавить("Документ.АвансовыйОтчет");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетБанкаПоОперациямЭквайринга");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеБезналичныхДенежныхСредств");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПересортицаТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВводОстатковВнеоборотныхАктивов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВыбытиеДенежныхДокументов");
	ТипыРегитраторовКОбработке.Добавить("Документ.РаспределениеПроизводственныхЗатрат");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратСырьяОтПереработчика");
	ТипыРегитраторовКОбработке.Добавить("Документ.ИзменениеПараметровОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.РаспределениеПрочихЗатрат");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеНМА");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПередачаСырьяПереработчику");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВыкупВозвратнойТарыКлиентом");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОперацияПоПлатежнойКарте");
	ТипыРегитраторовКОбработке.Добавить("Документ.СборкаТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратТоваровОтКлиента");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеУслугПрочихАктивов");
	ТипыРегитраторовКОбработке.Добавить("Документ.АннулированиеПодарочныхСертификатов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетКомитентуОСписании");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратОСОтАрендатора");
	ТипыРегитраторовКОбработке.Добавить("Документ.КорректировкаПоступления");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПринятиеКУчетуНМА");
	ТипыРегитраторовКОбработке.Добавить("Документ.ТаможеннаяДекларацияИмпорт");
	ТипыРегитраторовКОбработке.Добавить("Документ.ДепонированиеЗарплаты");
	ТипыРегитраторовКОбработке.Добавить("Документ.АмортизацияНМА");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеЗадолженности");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВыбытиеАрендованныхОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВводОстатков");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетКомиссионера");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПеремещениеОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.НачисленияКредитовИДепозитов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОприходованиеИзлишковТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеАрендованныхОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПринятиеКУчетуОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВнутреннееПотреблениеТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.РегламентнаяОперация");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратПодарочныхСертификатов");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПеремещениеТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.АмортизацияОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеОтПереработчика");
	ТипыРегитраторовКОбработке.Добавить("Документ.ИнвентаризацияНаличныхДенежныхСредств");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПередачаОСАрендатору");
	ТипыРегитраторовКОбработке.Добавить("Документ.РасходныйКассовыйОрдер");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПорчаТоваров");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратТоваровПоставщику");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетОРозничныхПродажах");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПогашениеСтоимостиТМЦВЭксплуатации");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПеремещениеМатериаловВПроизводстве");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеПредметовЛизинга");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеУслугПоЛизингу");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПередачаМатериаловВПроизводство");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратМатериаловИзПроизводства");
	ТипыРегитраторовКОбработке.Добавить("Документ.КорректировкаРегистров");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПереоценкаОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПереоценкаНМА");
	ТипыРегитраторовКОбработке.Добавить("Документ.НачислениеДивидендов");
	ТипыРегитраторовКОбработке.Добавить("Документ.НачислениеОценочныхОбязательствПоОтпускам");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОперацияБух");
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВыкупВозвратнойТарыУПоставщика");
	//УКР
	ТипыРегитраторовКОбработке.Добавить("Документ.РемонтОС");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПеремещениеНМА");
// - должен добавиться
//	ТипыРегитраторовКОбработке.Добавить("Документ.ПеремещениеВЭксплуатации");
	ТипыРегитраторовКОбработке.Добавить("Документ.СписаниеИзЭксплуатации");		
	ТипыРегитраторовКОбработке.Добавить("Документ.НалоговаяНакладная");
	ТипыРегитраторовКОбработке.Добавить("Документ.Приложение2КНалоговойНакладной");
	ТипыРегитраторовКОбработке.Добавить("Документ.РегистрацияВходящегоНалоговогоДокумента");
	ТипыРегитраторовКОбработке.Добавить("Документ.КорректировкаНалоговогоНазначенияЗапасов");
	//УКР	
	
	//++ НЕ УТКА
	ТипыРегитраторовКОбработке.Добавить("Документ.ОтчетДавальцу");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПередачаДавальцу");
	ТипыРегитраторовКОбработке.Добавить("Документ.ВозвратСырьяДавальцу");
	ТипыРегитраторовКОбработке.Добавить("Документ.ПоступлениеСырьяОтДавальца");
	//-- НЕ УТКА
	
	Для каждого Регистратор Из ТипыРегитраторовКОбработке Цикл
		
		ЗарегистрироватьКОбработкеПоИмениДокумента(Регистратор, Параметры);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДокументыСОтражениемОднойДатой_ЗаполнитьДатуОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					Неопределено,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ДатыОтраженияПереоценки
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|	
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|	
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваБезналичные КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВКассахККМ КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Регистр.Период, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	РегистрНакопления.РасчетыПоДоговорамКредитовИДепозитов КАК Регистр
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		Регистр.Регистратор = ВТДляОбработки.Регистратор
	|		И ВТДляОбработки.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств
	|;
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТДляОбработки.Регистратор КАК Регистратор,
	|	ОтражениеДокументовВРеглУчете.Период,
	|	ОтражениеДокументовВРеглУчете.Активность,
	|	ОтражениеДокументовВРеглУчете.Организация,
	|	ВЫБОР 
	|		КОГДА НЕ ДатыОтраженияПереоценки.ДатаОтражения ЕСТЬ NULL
	|			ТОГДА ДатыОтраженияПереоценки.ДатаОтражения
	|		КОГДА НЕ ОтражениеДокументовВРеглУчете.Период ЕСТЬ NULL
	|			ТОГДА НАЧАЛОПЕРИОДА(ОтражениеДокументовВРеглУчете.Период, ДЕНЬ)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДатаОтражения,
	|	ОтражениеДокументовВРеглУчете.Статус,
	|	ВЫРАЗИТЬ(ОтражениеДокументовВРеглУчете.Комментарий КАК СТРОКА(1000)) КАК Комментарий
	|ИЗ
	|	ВТДляОбработки КАК ВТДляОбработки
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|	ПО
	|		ОтражениеДокументовВРеглУчете.Регистратор = ВТДляОбработки.Регистратор
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДатыОтраженияПереоценки КАК ДатыОтраженияПереоценки
	|	ПО
	|		ОтражениеДокументовВРеглУчете.Регистратор = ДатыОтраженияПереоценки.Регистратор
	|
	|ИТОГИ ПО
	|	Регистратор";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументы.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаДокументы.Регистратор);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДокументы.Регистратор);
			
			Если ВыборкаДокументы.ДатаОтражения = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
				Продолжить;
			КонецЕсли;
			
			Выборка = ВыборкаДокументы.Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось обработать движения по документу %Ссылка% по причине: %Причина%';uk='Не вдалося обробити руху по документу %Ссылка% з причини: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ВыборкаДокументы.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.ОтражениеДокументовВРеглУчете, 
				ВыборкаДокументы.Регистратор, ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область РеализацияТоваровУслуг_ЗаполнитьДатыОтраженияВРеглУчете

Процедура РеализацияТоваровУслуг_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.РеализацияТоваровУслуг";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура РеализацияТоваровУслуг_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.РеализацияТоваровУслуг";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеализацияТоваровУслуг.Ссылка       КАК Регистратор,
	|	РеализацияТоваровУслуг.Дата         КАК Период,
	|	РеализацияТоваровУслуг.Организация  КАК Организация,
	|	НАЧАЛОПЕРИОДА(РеализацияТоваровУслуг.Дата, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		РеализацияТоваровУслуг.Ссылка = ВТДляОбработки.Регистратор
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеализацияТоваровУслуг.Ссылка       КАК Регистратор,
	|	РеализацияТоваровУслуг.Дата         КАК Период,
	|	РеализацияТоваровУслуг.Организация  КАК Организация,
	|	НАЧАЛОПЕРИОДА(РеализацияТоваровУслуг.ДатаПереходаПраваСобственности, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		РеализацияТоваровУслуг.Ссылка = ВТДляОбработки.Регистратор
	|ГДЕ
	|	РеализацияТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности)
	|	И РеализацияТоваровУслуг.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
	|
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область КорректировкаРеализации_ЗаполнитьДатыОтраженияВРеглУчете

Процедура КорректировкаРеализации_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.КорректировкаРеализации";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура КорректировкаРеализации_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.КорректировкаРеализации";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КорректировкаРеализации.Ссылка      КАК Регистратор,
	|	КорректировкаРеализации.Дата        КАК Период,
	|	КорректировкаРеализации.Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(КорректировкаРеализации.Дата, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		КорректировкаРеализации.Ссылка = ВТДляОбработки.Регистратор
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КорректировкаРеализации.Ссылка      КАК Регистратор,
	|	КорректировкаРеализации.Дата        КАК Период,
	|	КорректировкаРеализации.Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(
	|		КОНЕЦПЕРИОДА(КорректировкаРеализации.ДокументОснование.Дата, МЕСЯЦ), ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		КорректировкаРеализации.Ссылка = ВТДляОбработки.Регистратор
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(КорректировкаРеализации.Дата, ГОД) <> НАЧАЛОПЕРИОДА(КорректировкаРеализации.ДокументОснование.Дата, ГОД)
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);

КонецПроцедуры

#КонецОбласти

#Область АктВыполненныхРабот_ЗаполнитьДатыОтраженияВРеглУчете

Процедура АктВыполненныхРабот_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.АктВыполненныхРабот";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура АктВыполненныхРабот_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.АктВыполненныхРабот";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АктВыполненныхРабот.Ссылка       КАК Регистратор,
	|	АктВыполненныхРабот.Дата         КАК Период,
	|	АктВыполненныхРабот.Организация  КАК Организация,
	|	НАЧАЛОПЕРИОДА(АктВыполненныхРабот.Дата, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		АктВыполненныхРабот.Ссылка = ВТДляОбработки.Регистратор
	|
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область РаспределениеРасходовБудущихПериодов_ЗаполнитьДатыОтраженияВРеглУчете

Процедура РаспределениеРасходовБудущихПериодов_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.РаспределениеРасходовБудущихПериодов";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура РаспределениеРасходовБудущихПериодов_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.РаспределениеРасходовБудущихПериодов";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка           КАК Регистратор,
	|	ДанныеДокумента.Дата             КАК Период,
	|	ДанныеДокумента.Организация      КАК Организация,
	|	НАЧАЛОПЕРИОДА(Строки.Дата, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ДанныеДокумента.Ссылка = ВТДляОбработки.Регистратор
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ПО
	|		ДанныеДокумента.Ссылка = Строки.Ссылка
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);

КонецПроцедуры

#КонецОбласти


#Область ПрочиеДоходыРасходы_ЗаполнитьДатыОтраженияВРеглУчете

Процедура ПрочиеДоходыРасходы_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПрочиеДоходыРасходы";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура ПрочиеДоходыРасходы_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПрочиеДоходыРасходы";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрочиеДоходыРасходы.Ссылка      КАК Регистратор,
	|	ПрочиеДоходыРасходы.Дата        КАК Период,
	|	ПрочиеДоходыРасходы.Организация КАК Организация,
	|	ВЫБОР 
	|		КОГДА ТаблицаПрочиеРасходы.ДатаОтражения = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПрочиеДоходыРасходы.Дата, ДЕНЬ)
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(ТаблицаПрочиеРасходы.ДатаОтражения, ДЕНЬ)
	|	КОНЕЦ КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.ПрочиеДоходыРасходы КАК ПрочиеДоходыРасходы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ПрочиеДоходыРасходы.Ссылка = ВТДляОбработки.Регистратор
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ПрочиеДоходыРасходы.ПрочиеРасходы КАК ТаблицаПрочиеРасходы
	|	ПО
	|		ПрочиеДоходыРасходы.Ссылка = ТаблицаПрочиеРасходы.Ссылка
	|	
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрочиеДоходыРасходы.Ссылка      КАК Регистратор,
	|	ПрочиеДоходыРасходы.Дата        КАК Период,
	|	ПрочиеДоходыРасходы.Организация КАК Организация,
	|	ВЫБОР 
	|		КОГДА ТаблицаПрочиеДоходы.ДатаОтражения = ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПрочиеДоходыРасходы.Дата, ДЕНЬ)
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(ТаблицаПрочиеДоходы.ДатаОтражения, ДЕНЬ)
	|	КОНЕЦ КАК ДатаОтражения
	|ИЗ
	|	Документ.ПрочиеДоходыРасходы КАК ПрочиеДоходыРасходы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ПрочиеДоходыРасходы.Ссылка = ВТДляОбработки.Регистратор
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ПрочиеДоходыРасходы.ПрочиеДоходы КАК ТаблицаПрочиеДоходы
	|	ПО
	|		ПрочиеДоходыРасходы.Ссылка = ТаблицаПрочиеДоходы.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрочиеДоходыРасходы.Ссылка      КАК Регистратор,
	|	ПрочиеДоходыРасходы.Дата        КАК Период,
	|	ПрочиеДоходыРасходы.Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(ПрочиеДоходыРасходы.Дата, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	Документ.ПрочиеДоходыРасходы КАК ПрочиеДоходыРасходы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ПрочиеДоходыРасходы.Ссылка = ВТДляОбработки.Регистратор
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);

КонецПроцедуры

#КонецОбласти

#Область ПодготовкаКПередачеОС_ЗаполнитьДатыОтраженияВРеглУчете

Процедура ПодготовкаКПередачеОС_ЗаполнитьДатыОтраженияВРеглУчете_ОтметитьКОбработке(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПодготовкаКПередачеОС";
	ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры);
	
КонецПроцедуры

Процедура ПодготовкаКПередачеОС_ЗаполнитьДатыОтраженияВРеглУчете(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПодготовкаКПередачеОС";
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
					Параметры.Очередь, 
					ПолноеИмяДокумента,
					ПолноеИмяРегистра, 
					МенеджерВТ);
		
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодготовкаКПередачеОС.Ссылка                    КАК Регистратор,
	|	ПодготовкаКПередачеОС.Дата                      КАК Период,
	|	ПодготовкаКПередачеОС.Организация               КАК Организация,
	|	НАЧАЛОПЕРИОДА(ПодготовкаКПередачеОС.Дата, ДЕНЬ) КАК ДатаОтражения
	|ПОМЕСТИТЬ ИзмеренияКРегистрации
	|ИЗ
	|	Документ.ПодготовкаКПередачеОС КАК ПодготовкаКПередачеОС
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ПодготовкаКПередачеОС.Ссылка = ВТДляОбработки.Регистратор
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодготовкаКПередачеОС.Ссылка                            КАК Регистратор,
	|	ПодготовкаКПередачеОС.Дата                              КАК Период,
	|	ПодготовкаКПередачеОС.Организация                       КАК Организация,
	|	НАЧАЛОПЕРИОДА(ПодготовкаКПередачеОС.ДатаПередачи, ДЕНЬ) КАК ДатаОтражения
	|ИЗ
	|	Документ.ПодготовкаКПередачеОС КАК ПодготовкаКПередачеОС
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВТДляОбработки КАК ВТДляОбработки
	|	ПО
	|		ПодготовкаКПередачеОС.Ссылка = ВТДляОбработки.Регистратор
	|ГДЕ
	|	ПодготовкаКПередачеОС.ПередачаВыполнена
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.Выполнить();
	
	ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВТ, Параметры);

КонецПроцедуры

#КонецОбласти


#Область ВспомогательныеПроцедуры

Процедура ЗарегистрироватьКОбработкеПоИмениДокумента(ПолноеИмяДокумента, Параметры)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтражениеДокументовВРеглУчете.Регистратор
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|ГДЕ
	|	ОтражениеДокументовВРеглУчете.Регистратор ССЫЛКА %Документ%
	|	И ОтражениеДокументовВРеглУчете.ДатаОтражения = ДАТАВРЕМЯ(1,1,1)
	|";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%Документ%", ПолноеИмяДокумента);
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры, 
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор"), 
		ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбновитьДанныеРегистраПоДатамОтражения(МенеджерВременныхТаблиц, Параметры)
	
	ПолноеИмяРегистра = "РегистрСведений.ОтражениеДокументовВРеглУчете";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИзмеренияКРегистрации.Регистратор                     КАК Регистратор,
	|	ИзмеренияКРегистрации.Период                          КАК Период,
	|	ИзмеренияКРегистрации.Организация                     КАК Организация,
	|	ИзмеренияКРегистрации.ДатаОтражения                   КАК ДатаОтражения,
	|	ЕСТЬNULL(ДанныеРегистра.Статус, НЕОПРЕДЕЛЕНО)         КАК Статус,
	|	ВЫРАЗИТЬ(ДанныеРегистра.Комментарий КАК СТРОКА(1000)) КАК Комментарий 
	|ИЗ 
	|	ИзмеренияКРегистрации КАК ИзмеренияКРегистрации
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтражениеДокументовВРеглУчете КАК ДанныеРегистра
	|	ПО
	|		ДанныеРегистра.Регистратор = ИзмеренияКРегистрации.Регистратор
	|		И ДанныеРегистра.Организация = ИзмеренияКРегистрации.Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтражения
	|	
	|ИТОГИ ПО
	|	Регистратор";
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументы.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаДокументы.Регистратор);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДокументы.Регистратор);
			
			Если ВыборкаДокументы.Статус = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
				Продолжить;
			КонецЕсли;
			
			Выборка = ВыборкаДокументы.Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось обработать движения по документу %Ссылка% по причине: %Причина%';uk='Не вдалося обробити руху по документу %Ссылка% з причини: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ВыборкаДокументы.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.ОтражениеДокументовВРеглУчете, ВыборкаДокументы.Регистратор, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли