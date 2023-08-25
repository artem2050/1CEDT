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
	
	Текст = Параметры.ТекстЗапроса;
	ТекстЗапроса.УстановитьТекст(СформироватьТекстЗапросаДляКонфигуратора(Текст));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьТекстЗапросаДляКонфигуратора(Текст)
	
	Результат = """";
	Текст = Параметры.ТекстЗапроса;
	ПереводСтроки = Символы.ВК+Символы.ПС;
	Для Счетчик = 1 По СтрЧислоСтрок(Текст) Цикл
		ТекСтрока = СтрПолучитьСтроку(Текст, Счетчик);
		Если Счетчик > 1 Тогда 
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			Результат = Результат + ПереводСтроки + "|"+ ТекСтрока;
		Иначе
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			Результат = Результат + ТекСтрока;
		КонецЕсли;
	КонецЦикла;
	Результат = Результат + """";
	Возврат Результат;
	
КонецФункции

#КонецОбласти
