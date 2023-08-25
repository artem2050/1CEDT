///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обновляет данные регистра сведений КэшТестовыхПериодов.
//
// Параметры:
//  ДанныеСервисовСопровождения  - ТаблицаЗначений - содержит описатель набора записей регистра:
//   *ИдентификаторСервисаСопровождения  - СправочникСсылка.ИдентификаторыСервисовСопровождения - сервис,
//                                         сопровождения, к которому принадлежит тестовый период;
//   *ТестовыеПериоды - Массив - содержит описатели тестовых периодов:
//     **Идентификатор - Строка - уникальный идентификатор тестового периода;
//     **Наименование  - Строка - наименование тестового периода;
//     **Описание      - Строка - краткое описание тестового периода.
//
Процедура ОбновитьДанныеТестовыхПериодов(ДанныеСервисовСопровождения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаОбновления        = ТекущаяДатаСеанса();
	ИдентификаторСервисов = ДанныеСервисовСопровождения.ВыгрузитьКолонку("ИдентификаторСервисаСопровождения");
	ИдентификаторСервисов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИдентификаторСервисов);
	
	Для Каждого ИдентификаторСервиса Из ИдентификаторСервисов Цикл
		
		ПараметрыПоиска = Новый Структура("ИдентификаторСервисаСопровождения", ИдентификаторСервиса);
		НайденныеСтроки = ДанныеСервисовСопровождения.НайтиСтроки(ПараметрыПоиска);
		
		Набор = РегистрыСведений.КэшТестовыхПериодов.СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторСервисаСопровождения.Установить(ИдентификаторСервиса);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.ТестовыеПериоды.Количество() > 0 Тогда
				Для каждого ОписательТестовогоПериодов Из НайденнаяСтрока.ТестовыеПериоды Цикл
					Запись = Набор.Добавить();
					Запись.ИдентификаторСервисаСопровождения = ИдентификаторСервиса;
					Запись.Идентификатор                     = ОписательТестовогоПериодов.Идентификатор;
					Запись.Наименование                      = ОписательТестовогоПериодов.Наименование;
					Запись.Описание                          = ОписательТестовогоПериодов.Описание;
					Запись.ДатаОбновления                    = ДатаОбновления;
				КонецЦикла;
			Иначе
				Запись = Набор.Добавить();
				Запись.ИдентификаторСервисаСопровождения = ИдентификаторСервиса;
				Запись.ДатаОбновления               = ДатаОбновления;
			КонецЕсли;
		КонецЦикла;
		
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Очищает данные кэша для идентификатора сервиса сопровождения.
//
// Параметры:
//  ИдентификаторСервиса  - СправочникСсылка.ИдентификаторыСервисовСопровождения - сервис сопровождения.
//
Процедура ОчиститьКэшТестовыхПериодов(ИдентификаторСервиса) Экспорт
	
	Набор = РегистрыСведений.КэшТестовыхПериодов.СоздатьНаборЗаписей();
	Набор.Отбор.ИдентификаторСервисаСопровождения.Установить(ИдентификаторСервиса);
	Набор.Записать();
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ФормаСпискаПриСозданииНаСервере(Форма) Экспорт
	
	Форма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ФормаЗаписиПриСозданииНаСервере(Форма) Экспорт
	
	Форма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли