///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не СтандартнаяОбработка Тогда
		// Обрабатывается в другом месте.
		Возврат;
		
	ИначеЕсли Не Параметры.Свойство("РазрешитьДанныеКлассификатора") Тогда
		// Поведение по умолчанию, подбор только справочника.
		Возврат;
		
	ИначеЕсли Истина <> Параметры.РазрешитьДанныеКлассификатора Тогда
		// Подбор классификатора отключен, поведение по умолчанию.
		Возврат;
	КонецЕсли;
	
	УправлениеКонтактнойИнформациейСлужебный.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет данные страны по справочнику стран или классификатору стран.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеСтраныМира.
//
// Параметры:
//    КодСтраны    - Строка
//                 - Число - код страны по классификатору. Если не указано, то поиск по коду не производится.
//    Наименование - Строка        - наименование страны. Если не указано, то поиск по наименованию не производится.
//
// Возвращаемое значение:
//    Структура:
//          * Код                - Строка
//          * Наименование       - Строка
//          * НаименованиеПолное - Строка
//          * КодАльфа2          - Строка
//          * КодАльфа3          - Строка
//          * Ссылка             - СправочникСсылка.СтраныМира
//    Неопределено - страна не существует.
//
Функция ДанныеСтраныМира(Знач КодСтраны = Неопределено, Знач Наименование = Неопределено) Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеСтраныМира(КодСтраны, Наименование);
КонецФункции

// Определяет данные страны по классификатору стран мира.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду.
//
// Параметры:
//    Код - Строка
//        - Число - код страны по классификатору.
//    ТипКода - Строка - Варианты: КодСтраны (по умолчанию), Альфа2, Альфа3.
//
// Возвращаемое значение:
//    Структура:
//          * Код                - Строка
//          * Наименование       - Строка
//          * НаименованиеПолное - Строка
//          * КодАльфа2          - Строка
//          * КодАльфа3          - Строка
//    Неопределено - страна не существует.
//
Функция ДанныеКлассификатораСтранМираПоКоду(Знач Код, ТипКода = "КодСтраны") Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду(Код, ТипКода);
КонецФункции

// Определяет данные страны по классификатору.
// Рекомендуется использовать УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоНаименованию.
//
// Параметры:
//    Наименование - Строка - наименование страны.
//
// Возвращаемое значение:
//    Структура:
//          * Код                - Строка
//          * Наименование       - Строка
//          * НаименованиеПолное - Строка
//          * КодАльфа2          - Строка
//          * КодАльфа3          - Строка
//    Неопределено - страна не существует.
//
Функция ДанныеКлассификатораСтранМираПоНаименованию(Знач Наименование) Экспорт
	Возврат УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоНаименованию(Наименование);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти("РаботаСАдресами") <> Неопределено Тогда
		МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
		МодульРаботаСАдресами.ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти);
	КонецЕсли;
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

// Регистрирует к обработке страны мира.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		// Обновление мультиязычных строк, если они были изменены.
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РежимОбновления", "МультиязычныеСтроки");
		
		ОбновлениеИнформационнойБазы.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры,
			Метаданные.Справочники.СтраныМира, ДополнительныеПараметры);
	
	КонецЕсли;
	
	СписокСтран = УправлениеКонтактнойИнформацией.ПользовательскиеСтраныЕАЭС();
	
	НоваяСтрока                    = СписокСтран.Добавить();
	НоваяСтрока.Код                = "203";
	НоваяСтрока.Наименование       = НСтр("ru = 'ЧЕШСКАЯ РЕСПУБЛИКА'");
	НоваяСтрока.КодАльфа2          = "CZ";
	НоваяСтрока.КодАльфа3          = "CZE";
	
	НоваяСтрока                    = СписокСтран.Добавить();
	НоваяСтрока.Код                = "270";
	НоваяСтрока.Наименование       = НСтр("ru = 'ГАМБИЯ'");
	НоваяСтрока.КодАльфа2          = "GM";
	НоваяСтрока.КодАльфа3          = "GMB";
	НоваяСтрока.НаименованиеПолное = НСтр("ru = 'Республика Гамбия'");
	
	НоваяСтрока                    = СписокСтран.Добавить();
	НоваяСтрока.Код                = "807";
	НоваяСтрока.Наименование       = НСтр("ru = 'РЕСПУБЛИКА МАКЕДОНИЯ'");
	НоваяСтрока.КодАльфа2          = "MK";
	НоваяСтрока.КодАльфа3          = "MKD";
	НоваяСтрока.НаименованиеПолное =  НСтр("ru = 'Республика Македония'");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	СписокСтран.Код КАК Код,
		|	СписокСтран.Наименование КАК Наименование,
		|	СписокСтран.КодАльфа2 КАК КодАльфа2,
		|	СписокСтран.КодАльфа3 КАК КодАльфа3,
		|	СписокСтран.НаименованиеПолное КАК НаименованиеПолное
		|ПОМЕСТИТЬ СписокСтран
		|ИЗ
		|	&СписокСтран КАК СписокСтран
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтраныМира.Ссылка КАК Ссылка
		|ИЗ
		|	СписокСтран КАК СписокСтран
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
		|		ПО (СтраныМира.Код = СписокСтран.Код)
		|			И (СтраныМира.Наименование = СписокСтран.Наименование)
		|			И (СтраныМира.КодАльфа2 = СписокСтран.КодАльфа2)
		|			И (СтраныМира.КодАльфа3 = СписокСтран.КодАльфа3)
		|			И (СтраныМира.НаименованиеПолное = СписокСтран.НаименованиеПолное)";
	
	Запрос.УстановитьПараметр("СписокСтран", СписокСтран);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	СтраныКОбработке = РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СтраныКОбработке);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	СтранаМираСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.СтраныМира");
	НастройкиОбновления = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		НастройкиОбновления = МодульМультиязычностьСервер.НастройкиОбновлениеПредопределенныхДанных(Метаданные.Справочники.СтраныМира);
	КонецЕсли;
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока СтранаМираСсылка.Следующий() Цикл
		Попытка
			
			ДанныеКлассификатора = УправлениеКонтактнойИнформацией.ДанныеКлассификатораСтранМираПоКоду(СтранаМираСсылка.Ссылка.Код);
			
			Если ДанныеКлассификатора <> Неопределено Тогда
				
				Блокировка = Новый БлокировкаДанных();
				ЭлементБлокировки = Блокировка.Добавить("Справочник.СтраныМира");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", СтранаМираСсылка.Ссылка);
				
				НачатьТранзакцию();
				Попытка
					
					Блокировка.Заблокировать();
					
					СтранаМира = СтранаМираСсылка.Ссылка.ПолучитьОбъект();
					ЗаполнитьЗначенияСвойств(СтранаМира, ДанныеКлассификатора);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтранаМира);
					
					ЗафиксироватьТранзакцию();
					
				Исключение
					ОтменитьТранзакцию();
					ВызватьИсключение;
				КонецПопытки;
				
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СтранаМираСсылка.Ссылка);
			КонецЕсли;
			
			// Обновление наименований
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
				Если НастройкиОбновления.ЛокализуемыеРеквизитыОбъекта.Количество() > 0 Тогда
					МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
					МодульМультиязычностьСервер.ОбновитьМультиязычныеСтрокиПредопределенногоЭлемента(СтранаМираСсылка, НастройкиОбновления);
				КонецЕсли;
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать страну мира, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать страну: %1 по причине: %2'"),
					СтранаМираСсылка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.СтраныМира, СтранаМираСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.СтраныМира");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые страны мира(пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.СтраныМира,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура обновления обработала очередную порцию стран мира: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

