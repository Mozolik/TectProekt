﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокГражданПодлежащихПостановкеНаВоинскийУчет");
	НастройкиВарианта.Описание =
		НСтр("ru='Сведения о работниках, состоящих на воинском учете, а также о работниках, не состоящих, 
        |но обязанных состоять на воинском учете, для предоставления в военкомат'
        |;uk='Відомості про працівників, які перебувають на військовому обліку, а також про працівників, які не перебувають, 
        |але зобов''язаних перебувати на військовому обліку, для надання у військкомат'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокЮношей15_16Лет");
	НастройкиВарианта.Описание =
		НСтр("ru='Список работников мужского пола 15- и 16-летнего возраста на указанную дату 
        |для предоставления в военкомат'
        |;uk='Список працівників чоловічої статі 15 - і 16-річного віку на зазначену дату 
        |для надання в військкомат'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокПервоначальнойПостановкиНаВоинскийУчет");
	НастройкиВарианта.Описание =
		НСтр("ru='Список работников, подлежащих первоначальной постановке на воинский учет в указанном году, 
        |для предоставления в военкомат'
        |;uk='Список працівників, які підлягають первинній постановці на військовий облік у вказаному році, 
        |для надання в військкомат'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокДляСверкиСВоенкоматом");
	НастройкиВарианта.Описание =
		НСтр("ru='Сведения о воинском учете из личных карточек военнослужащих запаса 
        |для предоставления в военкомат'
        |;uk='Відомості про військовий облік з особистих карток військовослужбовців запасу 
        |для надання в військкомат'");
	
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ИзвещениеОПриемеУвольнении");
	НастройкиВарианта.Описание =
		НСтр("ru='Сообщения для военкоматов о приемах или увольнениях подлежащих 
        |воинскому учету работников за заданный период'
        |;uk='Повідомлення для військкоматів про прийомах або звільнення підлягають 
        |військовому обліку працівників за заданий період'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПринятыеУволенныеВоеннообязанные");
	НастройкиВарианта.Описание =
		НСтр("ru='Список принятых и уволенных военнослужащих запаса за заданный период';uk='Список прийнятих і звільнених військовослужбовців запасу за заданий період'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПринятыеУволенныеПризывники");
	НастройкиВарианта.Описание =
		НСтр("ru='Список принятых и уволенных призывников за заданный период';uk='Список прийнятих і звільнених призовників за заданий період'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализКарточекВоинскогоУчета");
	НастройкиВарианта.Описание =
		НСтр("ru='Данные воинского учета работников на заданную дату';uk='Дані військового обліку працівників на задану дату'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли