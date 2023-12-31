///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Нужно из-за того что в веб-клиенте в неоткрытой форме не выполняется обработчик ожидания
Процедура ОбновитьСтатусПереходаВСервис() Экспорт
	
	Форма = МиграцияПриложенийКлиент.ФормаПереходВСервис();
	Если Форма = Неопределено Тогда
		ОтключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис");
	Иначе
		Форма.ОбновлениеСтатусаПерехода();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОбработчикОбновленияСтатусаПереходаВСервис() Экспорт
	
	ПодключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис", 5, Ложь);
	
КонецПроцедуры

Процедура ОтключитьОбработчикОбновленияСтатусаПереходаВСервис() Экспорт
	
	ОтключитьОбработчикОжидания("ОбновитьСтатусПереходаВСервис");
	
КонецПроцедуры

#КонецОбласти
