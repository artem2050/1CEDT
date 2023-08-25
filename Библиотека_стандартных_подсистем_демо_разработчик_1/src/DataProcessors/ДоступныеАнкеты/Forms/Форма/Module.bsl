///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.РежимАнкетирования = Перечисления.РежимыАнкетирования.Анкета;
	Если Параметры.Свойство("РежимАнкетирования") Тогда
		Объект.РежимАнкетирования = Параметры.РежимАнкетирования;
		Объект.Респондент = Параметры.Респондент;
	Иначе
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		Если ТипЗнч(ТекущийПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда 
			Объект.Респондент = ТекущийПользователь;
		Иначе	
			Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя(ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаАнкетРеспондента();
	 
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Анкета" ИЛИ ИмяСобытия = "Проведение_Анкета" Тогда
		ТаблицаАнкетРеспондента();
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоАнкетПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаАнкет.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.АнкетаОпрос);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		СтруктураПараметров.Вставить("РежимАнкетирования", Объект.РежимАнкетирования);
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	ИначеЕсли ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		СтруктураПараметров = Новый Структура;
		ЗначенияЗаполнения 	= Новый Структура;
		ЗначенияЗаполнения.Вставить("Респондент",Объект.Респондент);
		ЗначенияЗаполнения.Вставить("Опрос",ТекущиеДанные.АнкетаОпрос);
		ЗначенияЗаполнения.Вставить("РежимАнкетирования", Объект.РежимАнкетирования);
		СтруктураПараметров.Вставить("ЗначенияЗаполнения",ЗначенияЗаполнения);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АрхивАнкет(Команда)
	
	ОткрытьФорму("Обработка.ДоступныеАнкеты.Форма.АрхивАнкет",Новый Структура("Респондент",Объект.Респондент),ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура Обновить(Команда)
	
	ТаблицаАнкетРеспондента();
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТаблицаАнкетРеспондента()
	
	ТаблицаАнкет.Очистить();
	
	ПолученнаяТаблицаАнкет = Анкетирование.ТаблицаДоступныхРеспондентуАнкет(Объект.Респондент);
	
	Если ПолученнаяТаблицаАнкет <> Неопределено Тогда
		
		Для каждого СтрокаТаблицы Из ПолученнаяТаблицаАнкет Цикл
			
			НоваяСтрока = ТаблицаАнкет.Добавить();
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.АнкетаОпрос) Тогда
				
				НоваяСтрока.Представление = СтрокаТаблицы.Статус;
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				
			Иначе
				
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				НоваяСтрока.АнкетаОпрос   = СтрокаТаблицы.АнкетаОпрос;
				НоваяСтрока.Представление = ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаТаблицы);
				
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.КодКартинки = ?(СтрокаТаблицы.Статус = "Опросы",0,1);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление строки для дерева анкет.
//
// Параметры:
//  СтрокаДерева  - СтрокаДереваЗначений - на основании ее формируется представление 
//                 анкет и опросов в дереве.
//
&НаСервере
Функция ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаДерева)
	
	Если ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		Если ЗначениеЗаполнено(СтрокаДерева.ДатаОкончания) Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Анкета ""%1"", к заполнению до %2'"),
				СтрокаДерева.Наименование, Формат(НачалоДня(КонецДня(СтрокаДерева.ДатаОкончания) + 1), "ДЛФ=D"));
		Иначе	
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Анкета ""%1""'"), СтрокаДерева.Наименование);
		КонецЕсли;
	ИначеЕсли ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		Если ЗначениеЗаполнено(СтрокаДерева.ДатаАнкеты) И ЗначениеЗаполнено(СтрокаДерева.ДатаОкончания) Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Анкета ""%1"", последний раз редактировавшаяся %2, к заполнению до %3'"), 
				СтрокаДерева.Наименование, Формат(СтрокаДерева.ДатаАнкеты, "ДЛФ=D"),
				Формат(НачалоДня(КонецДня(СтрокаДерева.ДатаОкончания) + 1), "ДЛФ=D"));
		ИначеЕсли ЗначениеЗаполнено(СтрокаДерева.ДатаАнкеты) Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Анкета ""%1"", последний раз редактировавшаяся %2'"), 
				СтрокаДерева.Наименование, Формат(СтрокаДерева.ДатаАнкеты, "ДЛФ=D"));
		Иначе
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Анкета ""%1""'"), СтрокаДерева.Наименование);
		КонецЕсли;
	КонецЕсли;
	Возврат "";
	
КонецФункции

#КонецОбласти
