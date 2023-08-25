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

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Возвращаемое значение:
//   см. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииЗаблокированныхРеквизитов.ЗаблокированныеРеквизиты.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Тип;Тип");
	БлокируемыеРеквизиты.Добавить("Родитель");
	БлокируемыеРеквизиты.Добавить("ИдентификаторДляФормул");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.ПоискИУдалениеДублей

// Параметры: 
//   ПарыЗамен - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.ПарыЗамен
//   ПараметрыЗамены - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.ПараметрыЗамены
// 
// Возвращаемое значение:
//   см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.НедопустимыеЗамены
//
Функция ВозможностьЗаменыЭлементов(Знач ПарыЗамен, Знач ПараметрыЗамены = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	Для Каждого КлючЗначение Из ПарыЗамен Цикл
		ТекущаяСсылка = КлючЗначение.Ключ;
		ЦелеваяСсылка = КлючЗначение.Значение;
		
		Если ТекущаяСсылка = ЦелеваяСсылка Тогда
			Продолжить;
		КонецЕсли;
		
		// Разрешаем заменять вид контактной информации на другой, только если они относятся к одной группе.
		МожноЗаменять = ТекущаяСсылка.Родитель = ЦелеваяСсылка.Родитель;
		Если Не МожноЗаменять Тогда
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Элемент ""%1"" относится к ""%2"", а ""%3"" - к ""%4""'"),
				ТекущаяСсылка, ТекущаяСсылка.Родитель, ЦелеваяСсылка, ЦелеваяСсылка.Родитель);
			Результат.Вставить(ТекущаяСсылка, Ошибка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Параметры: 
//   ПараметрыПоиска - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей.ПараметрыПоиска
//   ДополнительныеПараметры - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей.ДополнительныеПараметры 
//
Процедура ПараметрыПоискаДублей(ПараметрыПоиска, ДополнительныеПараметры = Неопределено) Экспорт
	
	Ограничение = Новый Структура;
	Ограничение.Вставить("Представление",      НСтр("ru = 'Относятся к одной группе и одного типа (адрес, телефон и пр.).'"));
	Ограничение.Вставить("ДополнительныеПоля", "Родитель, Тип");
	ПараметрыПоиска.ОграниченияСравнения.Добавить(Ограничение);
	
	// Размер таблицы для передачи в обработчик.
	ПараметрыПоиска.КоличествоЭлементовДляСравнения = 100;
	
КонецПроцедуры

// Параметры:
//   ТаблицаКандидатов - см. ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей.ТаблицаКандидатов
//   ДополнительныеПараметры - см. ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей.ДополнительныеПараметры
//
Процедура ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры = Неопределено) Экспорт
	
	Для Каждого Вариант Из ТаблицаКандидатов Цикл
		Если Вариант.Поля1.Родитель = Вариант.Поля2.Родитель И Вариант.Поля1.Тип = Вариант.Поля2.Тип Тогда
			Вариант.ЭтоДубли = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

// АПК:362-выкл Проектное решение

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#КонецЕсли
КонецПроцедуры

// АПК:362-вкл

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

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
//   Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СправочникПользователи";
	Элемент.Наименование = НСтр("ru = 'Контактная информация справочника ""Пользователи""'");
	Элемент.ЭтоГруппа = Истина;
	Элемент.Используется = Истина;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "EmailПользователя";
	Элемент.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	Элемент.Наименование = НСтр("ru = 'Электронная почта'");
	Элемент.МожноИзменятьСпособРедактирования = Истина;
	Элемент.РазрешитьВводНесколькихЗначений   = Истина;
	Элемент.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПользователи;
	Элемент.ИдентификаторДляФормул = "ЭлектроннаяПочта";
	Элемент.ВидРедактирования = "ПолеВвода";
	Элемент.Используется = Истина;
	Элемент.РеквизитДопУпорядочивания = 2;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ТелефонПользователя";
	Элемент.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	Элемент.Наименование = НСтр("ru = 'Телефон'");
	Элемент.МожноИзменятьСпособРедактирования = Истина;
	Элемент.РазрешитьВводНесколькихЗначений   = Истина;
	Элемент.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПользователи;
	Элемент.ИдентификаторДляФормул = "Телефон";
	Элемент.Используется = Истина;
	Элемент.ВидРедактирования = "ПолеВводаИДиалог";
	Элемент.РеквизитДопУпорядочивания = 1;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

#Область ИдентификаторДляФормул

// Проверяет уникальность идентификатора в рамках объекта метаданных для которого предназначен вид контактной
// информации (родитель) а также соответствие идентификатора правилам написания.
// 
// Параметры:
//   ИдентификаторДляФормул - Строка - идентификатор для формул.
//   Ссылка - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на текущий объект.
//   Родитель - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на родитель текущего объекта.
//   Отказ - Булево - флаг отказа при наличии ошибки.
//
Процедура ПроверитьУникальностьИдентификатора(ИдентификаторДляФормул, Ссылка, Родитель, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(ИдентификаторДляФормул) Тогда
		
		ИдентификаторПоПравилам = Истина;
		ПроверочныйИдентификатор = ИдентификаторДляФормул(ИдентификаторДляФормул);
		Если НЕ ВРег(ПроверочныйИдентификатор) = ВРег(ИдентификаторДляФормул) Тогда
			ИдентификаторПоПравилам = Ложь;
			
			ТекстОшибки = НСтр("ru = 'Идентификатор ""%1"" не соответствует правилам именования переменных.
										|Идентификатор не должен содержать пробелов и специальных символов.'");
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ИдентификаторДляФормул),,
				"ИдентификаторДляФормул",, Отказ);
				
			КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)'", КодЯзыка);
			ТекстОшибки = НСтр("ru = 'Идентификатор ""%1"" не соответствует правилам именования переменных.
									|Идентификатор не должен содержать пробелов и специальных символов.'", КодЯзыка);
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
				ИдентификаторДляФормул);
			ЗаписьЖурналаРегистрации(ИмяСобытия,
					УровеньЖурналаРегистрации.Ошибка,
					Ссылка.Метаданные(),
					Ссылка,
					ТекстОшибки);
		КонецЕсли;
		
		Если ИдентификаторПоПравилам Тогда
			РодительВерхнегоУровня = Родитель;
			Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
				Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
				Если ЗначениеЗаполнено(Значение) Тогда
					РодительВерхнегоУровня = Значение;
				Иначе
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ИдентификаторДляФормулУникален(ИдентификаторДляФормул, Ссылка, РодительВерхнегоУровня) Тогда
				
				Отказ = Истина;
				
				ТекстОшибки = НСтр("ru = 'В базе данных уже содержится вид контактной информации с идентификатором ""%1"" внутри группы ""%2"". Идентификатор должен быть уникальным'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
					ИдентификаторДляФормул, РодительВерхнегоУровня);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "ИдентификаторДляФормул");
				
				КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
				ТекстОшибки = НСтр("ru = 'В базе данных уже содержится вид контактной информации с идентификатором ""%1"" внутри группы ""%2"". Идентификатор должен быть уникальным'", КодЯзыка);
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
					ИдентификаторДляФормул, РодительВерхнегоУровня);
				ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)'", КодЯзыка);
				ЗаписьЖурналаРегистрации(ИмяСобытия,
					УровеньЖурналаРегистрации.Ошибка,
					Ссылка.Метаданные(),
					Ссылка,
					ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки = НСтр("ru = 'Идентификатор для формул не заполнен'");
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ИдентификаторДляФормул),,
			"ИдентификаторДляФормул",, Отказ);
			
		КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)'", КодЯзыка);
		ТекстОшибки = НСтр("ru = 'Идентификатор для формул не заполнен'", КодЯзыка);
		ЗаписьЖурналаРегистрации(ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ТекстОшибки);
			
	КонецЕсли;
	
КонецПроцедуры

// Возвращает уникальный идентификатора для формул (после проверки на уникальность)
// 
// Параметры:
//   ПредставлениеОбъекта - Строка - представление, из которого будет сформирован идентификатор для формул.
//   СсылкаНаТекущийОбъект - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на текущий элемент.
//   Родитель - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на родитель текущего объекта.
// Возвращаемое значение:
//   Строка - уникальное значение идентификатора для формул.
//
Функция УникальныйИдентификаторДляФормул(ПредставлениеОбъекта, СсылкаНаТекущийОбъект, Родитель) Экспорт

	Идентификатор = ИдентификаторДляФормул(ПредставлениеОбъекта);
	Если ПустаяСтрока(Идентификатор) Тогда
		// Представление состоит и спецсимволов или цифр.
		Префикс = НСтр("ru = 'Идентификатор'");
		Идентификатор = ИдентификаторДляФормул(Префикс + ПредставлениеОбъекта);
	КонецЕсли;
	
	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул = &ИдентификаторДляФормул
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул ПОДОБНО &ИдентификаторДляФормулПодобие
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)";
	Запрос.УстановитьПараметр("СсылкаНаТекущийОбъект", СсылкаНаТекущийОбъект);
	Запрос.УстановитьПараметр("РодительВерхнегоУровня", РодительВерхнегоУровня);
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", Идентификатор);
	Запрос.УстановитьПараметр("ИдентификаторДляФормулПодобие", Идентификатор + "%");
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	УникальностьПоТочномуСоответствию = РезультатыЗапроса[0];
	Если НЕ УникальностьПоТочномуСоответствию.Пустой() Тогда
		// Есть элементы с данным идентификатором.
		ИспользованныеИдентификаторы = Новый Соответствие;
		ВыборкаПодобных = РезультатыЗапроса[1].Выбрать();
		Пока ВыборкаПодобных.Следующий() Цикл
			ИспользованныеИдентификаторы.Вставить(ВРЕГ(ВыборкаПодобных.ИдентификаторДляФормул), Истина);
		КонецЦикла;
		
		ДобавляемыйНомер = 1;
		ИдентификаторБезНомера = Идентификатор;
		Пока НЕ ИспользованныеИдентификаторы.Получить(ВРЕГ(Идентификатор)) = Неопределено Цикл
			ДобавляемыйНомер = ДобавляемыйНомер + 1;
			Идентификатор = ИдентификаторБезНомера + ДобавляемыйНомер;
		КонецЦикла;
	КонецЕсли;
	ИспользованныеИдентификаторы = Новый Соответствие;
	
	Возврат Идентификатор;
КонецФункции

Функция ИдентификаторДляФормулУникален(ПроверяемыйИдентификатор, СсылкаНаТекущийОбъект, Родитель)
	
	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &СсылкаНаТекущийОбъект
	|	И Таблица.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)
	|	И Таблица.ИдентификаторДляФормул = &ИдентификаторДляФормул";
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", ПроверяемыйИдентификатор);
	Запрос.УстановитьПараметр("СсылкаНаТекущийОбъект", СсылкаНаТекущийОбъект);
	Запрос.УстановитьПараметр("РодительВерхнегоУровня", РодительВерхнегоУровня);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
КонецФункции

// Вычисляет значение идентификатора из строки соответствии с правилами именования переменных.
// 
// Параметры:
//  СтрокаПредставления - Строка - наименование, строка из которой необходимо получить идентификатор. 
//
// Возвращаемое значение:
//  Строка - идентификатор, соответствующий правилам именования идентификаторов.
//
Функция ИдентификаторДляФормул(СтрокаПредставления) Экспорт
	
	СпецСимволы = СпецСимволы();
	
	Идентификатор = "";
	БылСпецСимвол = Ложь;
	
	Для НомСимвола = 1 По СтрДлина(СтрокаПредставления) Цикл
		
		Символ = Сред(СтрокаПредставления, НомСимвола, 1);
		
		Если СтрНайти(СпецСимволы, Символ) <> 0 Тогда
			БылСпецСимвол = Истина;
			Если Символ = "_" Тогда
				Идентификатор = Идентификатор + Символ;
			КонецЕсли;
		ИначеЕсли БылСпецСимвол
			ИЛИ НомСимвола = 1 Тогда
			БылСпецСимвол = Ложь;
			Идентификатор = Идентификатор + ВРег(Символ);
		Иначе
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

Функция СпецСимволы()
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 0, 32));
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 127, 191));
	
	СпецСимволы = " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
	Для Каждого Диапазон Из Диапазоны Цикл
		Для КодСимвола = Диапазон.Мин По Диапазон.Макс Цикл
			СпецСимволы = СпецСимволы + Символ(КодСимвола);
		КонецЦикла;
	КонецЦикла;
	Возврат СпецСимволы;
КонецФункции

Функция НаименованиеДляФормированияИдентификатора(Знач Наименование, Знач Представления)
	Если ТекущийЯзык().КодЯзыка <> ОбщегоНазначения.КодОсновногоЯзыка() Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("КодЯзыка", ОбщегоНазначения.КодОсновногоЯзыка());
		НайденныеСтроки = Представления.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Наименование = НайденныеСтроки[0].Наименование;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Наименование;
КонецФункции

#КонецОбласти

// Регистрирует к обработке виды контактной информации.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
		РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ВидКонтактнойИнформацииСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	ЯзыковБольшеОдного = Метаданные.Языки.Количество() > 1;
	Наименования = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.НаименованияВидовКонтактнойИнформации();
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока ВидКонтактнойИнформацииСсылка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВидыКонтактнойИнформации");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВидКонтактнойИнформацииСсылка.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка.Заблокировать();
			
			ВидКонтактнойИнформации = ВидКонтактнойИнформацииСсылка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ВидыКонтактнойИнформации
			
			// Исправление наименований на разных языках
			Если ЯзыковБольшеОдного Тогда
				ИмяВида = ?(ЗначениеЗаполнено(ВидКонтактнойИнформации.ИмяПредопределенногоВида),
					ВидКонтактнойИнформации.ИмяПредопределенногоВида, ВидКонтактнойИнформации.ИмяПредопределенныхДанных);
				
				Если ЗначениеЗаполнено(ИмяВида) Тогда
					УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования);
				КонецЕсли;
			КонецЕсли;
			
			Если Не ВидКонтактнойИнформации.ЭтоГруппа Тогда
				Если ВидКонтактнойИнформации.УдалитьРедактированиеТолькоВДиалоге Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "Диалог";
				ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты
						Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Skype
						Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Другое Тогда
						ВидКонтактнойИнформации.ВидРедактирования = "ПолеВвода";
				ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "Диалог";
				Иначе
					ВидКонтактнойИнформации.ВидРедактирования = "ПолеВводаИДиалог";
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ ВидКонтактнойИнформации.ЭтоГруппа
				И НЕ ЗначениеЗаполнено(ВидКонтактнойИнформации.ИдентификаторДляФормул) Тогда
				НаименованиеДляИдентификатора = НаименованиеДляФормированияИдентификатора(ВидКонтактнойИнформации.Наименование,
					ВидКонтактнойИнформации.Представления);
				ВидКонтактнойИнформации.ИдентификаторДляФормул = УникальныйИдентификаторДляФормул(НаименованиеДляИдентификатора,
					ВидКонтактнойИнформации.Ссылка, ВидКонтактнойИнформации.Родитель);
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидКонтактнойИнформации);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			// Если не удалось обработать какой-либо вид контактной информации, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать вид контактной информации: %1 по причине: %2'"),
					ВидКонтактнойИнформацииСсылка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ВидыКонтактнойИнформации, ВидКонтактнойИнформацииСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ЗаполнитьВидыКонтактнойИнформации не удалось обработать некоторые виды контактной информации (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВидыКонтактнойИнформации,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ЗаполнитьВидыКонтактнойИнформации обработала очередную порцию видов контактной информации: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования)
	
	Для Каждого Язык Из Метаданные.Языки Цикл
		
		Представление = Наименования[Язык.КодЯзыка][ИмяВида];
		Если ЗначениеЗаполнено(Представление) Тогда
			
			Если Язык = Метаданные.ОсновнойЯзык Тогда
				ВидКонтактнойИнформации.Наименование = Представление;
			Иначе
				
				Если Наименования[Язык.КодЯзыка][ИмяВида] <> Неопределено Тогда
					
					Отбор = Новый Структура;
					Отбор.Вставить("КодЯзыка",     Язык.КодЯзыка);
					Отбор.Вставить("Наименование", Представление);
					НайденныеСтроки = ВидКонтактнойИнформации.Представления.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() > 0 Тогда
						НоваяСтрока = НайденныеСтроки[0];
					Иначе
						НоваяСтрока = ВидКонтактнойИнформации.Представления.Добавить();
					КонецЕсли;
					НоваяСтрока.КодЯзыка     = Язык.КодЯзыка;
					НоваяСтрока.Наименование = Представление;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли