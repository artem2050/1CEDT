///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Размещение заголовка.
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
		ШиринаЗаголовка = 1.3 * СтрДлина(Заголовок);
		Если ШиринаЗаголовка > 40 И ШиринаЗаголовка < 80 Тогда
			Ширина = ШиринаЗаголовка;
		ИначеЕсли ШиринаЗаголовка >= 80 Тогда
			Ширина = 80;
		КонецЕсли;
	КонецЕсли;
	
	// Размещение текста.
	ТекстСообщения = Параметры.ТекстСообщения;
	
	МинимальнаяШиринаПоля = 50;
	ПримернаяВысотаПоля = ЧислоСтрок(Параметры.ТекстСообщения, МинимальнаяШиринаПоля);
	Элементы.МногострочныйТекстСообщения.Ширина = МинимальнаяШиринаПоля;
	Элементы.МногострочныйТекстСообщения.Высота = Мин(ПримернаяВысотаПоля, 10);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветДа(Команда)
	
	ЗакрытьФормуОтветПолучен(КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНет(Команда)
	
	ЗакрытьФормуОтветПолучен(КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ЗакрытьФормуОтветПолучен(Ответ)
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеЗадаватьЭтотВопрос", БольшеНеЗадаватьЭтотВопрос);
	РезультатВыбора.Вставить("Значение", Ответ);
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

// Определяет примерное число строк с учетом переносов.
&НаСервереБезКонтекста
Функция ЧислоСтрок(Текст, ОтсечкаПоШирине, ПриводитьКРазмерамЭлементовФормы = Истина)
	
	ЧислоСтрок = СтрЧислоСтрок(Текст);
	ЧислоПереносов = 0;
	Для НомерСтроки = 1 По ЧислоСтрок Цикл
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		ЧислоПереносов = ЧислоПереносов + Цел(СтрДлина(Строка)/ОтсечкаПоШирине);
	КонецЦикла;
	
	ПримерноеЧислоСтрок = ЧислоСтрок + ЧислоПереносов;
	
	Если ПриводитьКРазмерамЭлементовФормы Тогда
		Коэффициент = 2 / 3; // В такси в высоту 2 вмещается примерно 3 строки текста.
		ПримерноеЧислоСтрок = Цел((ПримерноеЧислоСтрок + 1) * Коэффициент);
	КонецЕсли;
	
	Если ПримерноеЧислоСтрок = 2 Тогда
		ПримерноеЧислоСтрок = 3;
	КонецЕсли;
	
	Возврат ПримерноеЧислоСтрок;
	
КонецФункции

#КонецОбласти
