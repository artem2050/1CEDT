///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обслуживание таблиц ВидыДоступа и ЗначенияДоступа в формах редактирования.

// Только для внутреннего использования.
//
// Возвращаемое значение:
//   см. Пользователи.СформироватьДанныеВыбораПользователя
//
Функция СформироватьДанныеВыбораПользователя(Знач Текст,
                                             Знач ВключаяГруппы = Истина,
                                             Знач ВключаяВнешнихПользователей = Неопределено,
                                             Знач БезПользователей = Ложь) Экспорт
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(
		Текст,
		ВключаяГруппы,
		ВключаяВнешнихПользователей,
		БезПользователей);
	
КонецФункции

Функция ПараметрыРасшифровкиОтчетаАнализПравДоступа(АдресДанныхРасшифровки, Расшифровка) Экспорт
	
	Возврат Отчеты["АнализПравДоступа"].ПараметрыРасшифровки(АдресДанныхРасшифровки, Расшифровка);
	
КонецФункции

#КонецОбласти
