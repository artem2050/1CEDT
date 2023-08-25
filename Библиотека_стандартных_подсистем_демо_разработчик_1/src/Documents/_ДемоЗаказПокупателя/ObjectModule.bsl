///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:     Организация И Партнер.
	// Изменения:  Организация И Партнер.
	
	// Чтение, Изменение: набор №0.
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Партнер;
	
КонецПроцедуры 

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	Если СуммаДокумента = 0 Тогда
		
		Сообщение = Новый СообщениеПользователю();
    	Сообщение.Текст = НСтр("ru = 'Не указана сумма документа.'");
    	Сообщение.Поле = "СуммаДокумента";
    	Сообщение.УстановитьДанные(ЭтотОбъект);
        Сообщение.Сообщить();
		
		Отказ = Истина;
		НепроверяемыеРеквизиты.Добавить("СуммаДокумента");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Демонстрация программного интерфейса для обработки локальных объектов.
	ПередЗаписьюЛокальнойКонтактнойИнформации();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.УстановитьПризнакАктивен(Ссылка,НЕ УдалитьЗаказЗакрыт);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает вспомогательные реквизиты по данным контактной информации шапки объекта.
//
Процедура ПередЗаписьюЛокальнойКонтактнойИнформации()
	
	// 1. Адрес
	СтруктураСтраныДоставки = УправлениеКонтактнойИнформацией.СтранаАдресаКонтактнойИнформации(АдресДоставки);
	СтранаДоставки = СтруктураСтраныДоставки.Ссылка;
	// Локализация
	РегионДоставки = РаботаСАдресами.РегионАдресаКонтактнойИнформации(АдресДоставки);
	ГородДоставки  = РаботаСАдресами.ГородАдресаКонтактнойИнформации(АдресДоставки);
	// Конец Локализация
	
	// 2. Электронная почта
	ДоменноеИмяСервера = УправлениеКонтактнойИнформацией.ДоменАдресаКонтактнойИнформации(ЭлектроннаяПочта);
	
	АдресДоставкиСтрокой = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(АдресДоставки);
	ЭлектроннаяПочтаСтрокой = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(ЭлектроннаяПочта);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли