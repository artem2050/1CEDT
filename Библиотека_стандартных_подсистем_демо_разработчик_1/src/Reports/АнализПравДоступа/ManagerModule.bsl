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

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты["АнализПравДоступа"]) Тогда
		Возврат;
	КонецЕсли;
	
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление = НСтр("ru = 'Права пользователей'");
	Команда.МножественныйВыбор = Истина;
	Команда.Менеджер= "Отчет.АнализПравДоступа";

	Если Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаСписка" Тогда
		Команда.Представление = НСтр("ru = 'Права пользователя'");
		Команда.КлючВарианта = "ПраваПользователейНаТаблицы";
	ИначеЕсли Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаЭлемента" Тогда
		Команда.Представление = НСтр("ru = 'Права пользователя'");
		Команда.КлючВарианта = "ПраваПользователяНаТаблицы";
	Иначе
		Команда.КлючВарианта = "ПраваПользователейНаТаблицу";
		Команда.ТолькоВоВсехДействиях = Истина;
		Команда.Важность = "СмТакже";
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	Иначе
		Возврат;
	КонецЕсли;
	
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализПравДоступа");
	НастройкиВарианта.Описание = НСтр("ru = 'Показывает текущие настройки прав доступа пользователей к таблицам информационной базы.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицы");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицы");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицу");
	НастройкиВарианта.Включен = Ложь;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицу");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицыОтчета");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователейНаТаблицыОтчета");
	НастройкиВарианта.Включен = Ложь;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПраваПользователяНаТаблицыОтчетов");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  АдресДанныхРасшифровки - Строка - адрес временного хранилища данных расшифровки отчета.
//  Расшифровка - ИдентификаторРасшифровкиКомпоновкиДанных - элемент расшифровки.
//
// Возвращаемое значение:
//  Структура:
//   * ИмяПоляРасшифровки - Строка
//   * СписокПолей - Соответствие из КлючИЗначение:
//    ** Ключ - Строка
//    ** Значение - Произвольный
//
Функция ПараметрыРасшифровки(АдресДанныхРасшифровки, Расшифровка) Экспорт
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки); // ДанныеРасшифровкиКомпоновкиДанных
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];

	СписокПолей = Новый Соответствие;
	ЗаполнитьСписокПолей(СписокПолей, ЭлементРасшифровки);
	
	ИмяПоляРасшифровки = "";
	Для Каждого ЗначениеПоля Из ЭлементРасшифровки.ПолучитьПоля() Цикл
		ИмяПоляРасшифровки = ЗначениеПоля.Поле;
		Прервать;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяПоляРасшифровки", ИмяПоляРасшифровки);
	Результат.Вставить("СписокПолей", СписокПолей);
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//   СписокПолей - Соответствие
//   ЭлементРасшифровки - ЭлементРасшифровкиКомпоновкиДанныхПоля
//                      - ЭлементРасшифровкиКомпоновкиДанныхГруппировка
//
Процедура ЗаполнитьСписокПолей(СписокПолей, ЭлементРасшифровки)
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ЗначениеПоля Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Если СписокПолей[ЗначениеПоля.Поле] = Неопределено Тогда
				СписокПолей.Вставить(ЗначениеПоля.Поле, ЗначениеПоля.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Для Каждого Родитель Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
		ЗаполнитьСписокПолей(СписокПолей, Родитель);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


