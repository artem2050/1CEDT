///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура-обработчик при нажатии на информационную ссылку.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - контекст управляемой формы.
//  Элемент - ГруппаФормы - группа формы.
//
Процедура НажатиеНаИнформационнуюСсылку(Форма, Элемент) Экспорт
	
	Гиперссылка = Форма.ИнформационныеСсылки.НайтиПоЗначению(Элемент.Имя);
	
	Если Гиперссылка <> Неопределено Тогда
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Гиперссылка.Представление);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик при нажатии на "Все" информационные ссылки.
//
// Параметры:
//  ПутьКФорме - Строка - полный путь к форме.
//
Процедура НажатиеНаСсылкуВсеИнформационныеСсылки(ПутьКФорме) Экспорт

	ПараметрыФормы = Новый Структура("ПутьКФорме", ПутьКФорме);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ИнформационныеСсылкиВКонтексте", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму со всеми обращениями в службу поддержки.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОткрытьОбращенияВСлужбуПоддержки() Экспорт 
КонецПроцедуры

// Открывает форму с обсуждениями на форуме.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОткрытьОбсужденияНаФоруме() Экспорт 
КонецПроцедуры

// Открывает форму с Центром идей.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОткрытьЦентрИдей() Экспорт 
КонецПроцедуры

// Открывает форму отображения всех новостей.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПоказатьВсеСообщения() Экспорт
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму отображения отдельной новости.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - идентификатор новости.
//
Процедура ПоказатьНовость(Идентификатор) Экспорт
КонецПроцедуры

// Открывает форму с содержанием идеи.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  ИдентификаторИдеи - Строка - уникальный идентификатор идеи.
//
Процедура ПоказатьИдею(Знач ИдентификаторИдеи) Экспорт
КонецПроцедуры

#КонецОбласти