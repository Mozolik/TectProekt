﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	//Параметр доступный для редактирования пользователем
	ПараметрНалоговыйДокумент = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НалоговыйДокумент"));
	//Параметр, который определяется по параметру НалоговыйДокумент и устанавливается программно
	ПараметрНалоговаяНакладная = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НалоговаяНакладная"));
	
	Если ПараметрНалоговыйДокумент <> Неопределено Тогда
		
		НалоговыйДокумент = Неопределено;
		
		Если Не ЗначениеЗаполнено(ПараметрНалоговыйДокумент.Значение) Тогда
			//Проверим в пользовательских настройках
			ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрНалоговыйДокумент.ИдентификаторПользовательскойНастройки);
			
			Если ПараметрПользовательскойНастройки <> Неопределено И ЗначениеЗаполнено(ПараметрПользовательскойНастройки.Значение) Тогда
				НалоговыйДокумент = ПараметрПользовательскойНастройки.Значение;
			КонецЕсли;
			
		Иначе
			НалоговыйДокумент = ПараметрНалоговыйДокумент.Значение;	
		КонецЕсли;
			
		Если ЗначениеЗаполнено(НалоговыйДокумент) И ПараметрНалоговаяНакладная <> Неопределено Тогда
	
			НалоговаяНакладная = Неопределено;
			Если ТипЗнч(НалоговыйДокумент) = Тип("ДокументСсылка.Приложение2КНалоговойНакладной") Тогда
				НалоговаяНакладная = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НалоговыйДокумент, "НалоговаяНакладная");
				Если Не ЗначениеЗаполнено(НалоговаяНакладная) Тогда
					ТекстСообщения = НСтр("ru='В сохраненном документе ""%1"" не заполнен реквизит ""Налоговая накладная""';uk='У збереженому документі ""%1"" не заповнений реквізит ""Податкова накладна""'");
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НалоговыйДокумент);
				КонецЕсли;
		 	Иначе
				НалоговаяНакладная = НалоговыйДокумент;
			КонецЕсли;
			
			ПараметрНалоговаяНакладная.Значение = НалоговаяНакладная;
			ПараметрНалоговаяНакладная.Использование = Истина;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияОбщейФормыФормаОтчетаНДС

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	НалоговыйДокумент = Неопределено;
	Параметры.Свойство("НалоговыйДокумент", НалоговыйДокумент);
	
	Если Не ЗначениеЗаполнено(НалоговыйДокумент) Тогда
		Возврат;	
	КонецЕсли;
	
	ПараметрНалоговыйДокумент = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НалоговыйДокумент"));
	
	Если ПараметрНалоговыйДокумент <> Неопределено Тогда
		ПараметрНалоговыйДокумент.Значение 			= НалоговыйДокумент;
		ПараметрНалоговыйДокумент.Использование 	= Истина;
		ПараметрНалоговыйДокумент.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	КонецЕсли;
			
КонецПроцедуры

Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт

	ИскомыйПараметр = Новый ПараметрКомпоновкиДанных("НалоговыйДокумент");
	
	//При загрузке варианта на сервере могут затираться установленные параметры, так как с новым вариантом получаем и новые настройки компоновки
	ПараметрНалоговыйДокументИсточник = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ИскомыйПараметр);
	ПараметрНалоговыйДокументПриемник = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(ИскомыйПараметр);
	Если ПараметрНалоговыйДокументИсточник <> Неопределено И ЗначениеЗаполнено(ПараметрНалоговыйДокументИсточник.Значение)
		И ПараметрНалоговыйДокументПриемник <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрНалоговыйДокументПриемник, ПараметрНалоговыйДокументИсточник);
	КонецЕсли;		

КонецПроцедуры
 
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, ПользовательскиеНастройкиКД) Экспорт
 	
	ИскомыйПараметр = Новый ПараметрКомпоновкиДанных("НалоговыйДокумент");
	
	//При загрузке пользовательских настроек параметры в пользовательских настройках могут отличаться от установленного раннее
	ПараметрНалоговыйДокументИсточник = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ИскомыйПараметр);
	Если ПараметрНалоговыйДокументИсточник <> Неопределено И ЗначениеЗаполнено(ПараметрНалоговыйДокументИсточник.Значение) Тогда 
		
		Для каждого ЭлементПользовательскойНастройки Из ПользовательскиеНастройкиКД.Элементы Цикл
			Если ТипЗнч(ЭлементПользовательскойНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				Если ЭлементПользовательскойНастройки.Параметр = ИскомыйПараметр Тогда
					
					Если ПараметрНалоговыйДокументИсточник.Значение <> ЭлементПользовательскойНастройки.Значение Тогда
		
						ЗаполнитьЗначенияСвойств(ЭлементПользовательскойНастройки, ПараметрНалоговыйДокументИсточник);	
						КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройкиКД);
					
					КонецЕсли;
					
					Прервать;
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли