#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Т-6а
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Т6а";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о предоставлении отпуска работникам (Т-6а)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т6а") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_Т6а",
			НСтр("ru = 'Приказ о предоставлении отпуска работникам (Т-6а)'"),
			СформироватьПечатнуюФормуТ6а(МассивОбъектов, ОбъектыПечати),
			,
			"Документ._ДемоОтпускаСотрудников.ПФ_MXL_Т6а");
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуТ6а(МассивОбъектов, ОбъектыПечати)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	_ДемоОтпускаСотрудников.Ссылка КАК Ссылка,
	|	_ДемоОтпускаСотрудников.Номер КАК Номер,
	|	_ДемоОтпускаСотрудников.Дата КАК Дата,
	|	_ДемоОтпускаСотрудников.Организация КАК Организация,
	|	_ДемоОтпускаСотрудников.Руководитель КАК Руководитель,
	|	_ДемоОтпускаСотрудников.Сотрудники.(
	|		Сотрудник КАК Сотрудник,
	|		ДатаНачала КАК ДатаНачала,
	|		ДатаОкончания КАК ДатаОкончания,
	|		КоличествоДней КАК КоличествоДней
	|	) КАК Сотрудники
	|ИЗ
	|	Документ._ДемоОтпускаСотрудников КАК _ДемоОтпускаСотрудников
	|ГДЕ
	|	_ДемоОтпускаСотрудников.Ссылка В(&СписокДокументов)";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);

	Шапка = Запрос.Выполнить().Выбрать();

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПФ_MXL_Т6а";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ДемоОтпускаСотрудников.ПФ_MXL_Т6а");

	МассивОбластейМакета = Новый Массив;
	МассивОбластейМакета.Добавить("Шапка");
	МассивОбластейМакета.Добавить("ШапкаТаблицы");
	МассивОбластейМакета.Добавить("Строка");
	МассивОбластейМакета.Добавить("Подвал");

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ДанныеПечати = Новый Структура;
			
		ДанныеПечати.Вставить("Номер", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина));
		ДанныеПечати.Вставить("Дата", Формат(Шапка.Дата, НСтр("ru='ДФ=dd.MM.yyyy'")));
		ДанныеПечати.Вставить("Организация", Шапка.Организация);
		ДанныеПечати.Вставить("РуководительФИО", Шапка.Руководитель);
	
		ТаблицаСотрудники = Шапка.Сотрудники.Выгрузить();

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если СтрСравнить(ИмяОбласти,"Строка") <> 0 Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				Счет = 1;
				Для Каждого СтрокаТаблицы Из ТаблицаСотрудники Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ОбластьМакета.Параметры.ТабНомер = Формат(Счет,"ЧЦ=4; ЧВН=; ЧГ=");
					ТабличныйДокумент.Вывести(ОбластьМакета);
					Счет = Счет+1;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#КонецЕсли
