///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// {http://www.1c.ru/1cFresh/Application/Permissions/Control/a.b.c.d}InfoBasePermissionsRequestProcessed
//
// Параметры:
//  ИдентификаторПакета - УникальныйИдентификатор - идентификатор запроса на использование внешних ресурсов.
//  РезультатОбработки - ПеречислениеСсылка.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса -
//                       результат обработки,
//  ИнформацияОбОшибке - ОбъектXDTO - {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription.
//
Процедура ОбработанЗапросНеразделенногоСеанса(Знач ИдентификаторПакета, Знач РезультатОбработки, Знач ИнформацияОбОшибке) Экспорт
	
	ОбработанЗапрос(ИдентификаторПакета, РезультатОбработки);
	
КонецПроцедуры

// {http://www.1c.ru/1cFresh/Application/Permissions/Control/a.b.c.d}ApplicationPermissionsRequestProcessed
//
// Параметры:
//  ИдентификаторПакета - УникальныйИдентификатор - идентификатор запроса на использование внешних ресурсов.
//  РезультатОбработки - ПеречислениеСсылка.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса -
//                       результат обработки,
//  ИнформацияОбОшибке - ОбъектXDTO - {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription.
//
Процедура ОбработанЗапросРазделенногоСеанса(Знач ИдентификаторПакета, Знач РезультатОбработки, Знач ИнформацияОбОшибке) Экспорт
	
	ОбработанЗапрос(ИдентификаторПакета, РезультатОбработки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработанЗапрос(Знач ИдентификаторПакета, Знач РезультатОбработки)
	
	НачатьТранзакцию();
	
	Попытка
		
		Менеджер = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.МенеджерПримененияПакета(ИдентификаторПакета);
		
		Если РезультатОбработки = Перечисления.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса.ЗапросОдобрен Тогда
			Менеджер.ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов();
		Иначе
			Менеджер.ОтменитьПримененияЗапросовНаИспользованиеВнешнихРесурсов();
		КонецЕсли;
		
		РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.УстановитьРезультатОбработкиПакета(РезультатОбработки);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

