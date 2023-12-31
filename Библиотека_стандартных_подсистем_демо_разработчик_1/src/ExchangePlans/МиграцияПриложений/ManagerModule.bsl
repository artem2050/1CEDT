///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьВспомогательныеДанные() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МиграцияПриложений.ОбластьДанныхОсновныеДанные КАК ОбластьДанныхОсновныеДанные
	|ИЗ
	|	ПланОбмена.МиграцияПриложений КАК МиграцияПриложений
	|ГДЕ
	|	НЕ МиграцияПриложений.ЭтотУзел";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗначения = Константы.ИспользуетсяМиграцияПриложений.СоздатьМенеджерЗначения();
		МенеджерЗначения.ОбластьДанныхВспомогательныеДанные = Выборка.ОбластьДанныхОсновныеДанные;
		МенеджерЗначения.Значение = Истина;
		МенеджерЗначения.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли