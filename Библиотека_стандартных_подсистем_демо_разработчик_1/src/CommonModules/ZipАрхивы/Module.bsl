///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция Создать(ИмяФайла) Экспорт
	
	Инфо = Новый Файл(ИмяФайла);
	Если Инфо.Существует() Тогда
		УдалитьФайлы(ИмяФайла);
	КонецЕсли;
	
	Архив = Новый Структура;
	Архив.Вставить("Поток", ФайловыеПотоки.ОткрытьДляЗаписи(ИмяФайла));
	Архив.Вставить("Файлы", Новый Массив);
	Архив.Вставить("РазмерКаталога", 0);
	
	Возврат Архив;
	
КонецФункции

Процедура ДобавитьФайл(Архив, ИмяФайла) Экспорт
	
	Инфо = Новый Файл(ИмяФайла);
	Если Инфо.ЭтоКаталог() Или Инфо.Размер() > 100 * 1024 * 1024 Тогда
		Поток = ФайловыеПотоки.Открыть(ПолучитьИмяВременногоФайла("zip"), РежимОткрытияФайла.ОткрытьИлиСоздать, ДоступКФайлу.ЧтениеИЗапись);
	Иначе
		Поток = Новый ПотокВПамяти();
	КонецЕсли;
	ЗаписьZIP = Новый ЗаписьZipФайла(Поток);
	Если Инфо.ЭтоКаталог() Тогда
		ЗаписьZIP.Добавить(ИмяФайла + ПолучитьРазделительПути() + "*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Иначе
		ЗаписьZIP.Добавить(ИмяФайла, РежимСохраненияПутейZIP.НеСохранятьПути);
	КонецЕсли;
	ЗаписьZIP.Записать();
	
	ДанныеАрхива = ПрочитатьАрхив(Поток);
	ВсеЗаписи = ВсеЗаписиКаталога(ДанныеАрхива);
	
	Для Каждого НайденнаяЗапись Из ВсеЗаписи Цикл
	
		ЗаголовокФайла = ПолучитьБайты(Поток, НайденнаяЗапись.СмещениеФайла, 30);
		Длина = 30 + ЗаголовокФайла.ПрочитатьЦелое16(26) + ЗаголовокФайла.ПрочитатьЦелое16(28) + НайденнаяЗапись.СжатыйРазмер; // 30 + file name length + extra field length
		
		Смещение = Архив.Поток.ТекущаяПозиция();
		Если Смещение >= 4294967295 Тогда
			
			ДлинаИмениФайла = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(28);
			ДлинаДопДанных = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(30);
			ДлинаКомментария = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(32);
			Если ДлинаКомментария <> 0 Тогда
				ВызватьИсключение "не реализовано";
			КонецЕсли;
			БуферДопДанные = НайденнаяЗапись.Буфер.Прочитать(46 + ДлинаИмениФайла, ДлинаДопДанных);
			ДопДанные = РаспарситьДопДанные(БуферДопДанные);
			
			// Т.к. файл в исходном архиве всегда 1, то смещение его 0 и соответственно в расширенной информации отсутствует
			НовыйБуфер = Новый БуферДвоичныхДанных(8);
			НовыйБуфер.ЗаписатьЦелое64(0, Смещение);
			Для Каждого Доп64 Из ДопДанные Цикл
				Если Доп64.Тип = ЧислоИзШестнадцатеричнойСтроки("0x0001") Тогда
					Доп64.Данные = Доп64.Данные.Соединить(НовыйБуфер);
					НовыйБуфер = Неопределено;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НовыйБуфер <> Неопределено Тогда
				ДопДанные.Добавить(Новый Структура("Тип, Данные", ЧислоИзШестнадцатеричнойСтроки("0x0001"), НовыйБуфер));
			КонецЕсли;
			БуферДопДанные = СобратьДопДанные(ДопДанные);
			НайденнаяЗапись.Буфер = НайденнаяЗапись.Буфер.Соединить(Новый БуферДвоичныхДанных(БуферДопДанные.Размер - ДлинаДопДанных));
			НайденнаяЗапись.Буфер.ЗаписатьЦелое16(30, БуферДопДанные.Размер);
			НайденнаяЗапись.Буфер.Записать(46 + ДлинаИмениФайла, БуферДопДанные);
			
			Смещение = 4294967295;
			
		КонецЕсли;
		НайденнаяЗапись.Буфер.ЗаписатьЦелое32(42, Смещение); // СмещениеФайла
		Архив.РазмерКаталога = Архив.РазмерКаталога + НайденнаяЗапись.ДлинаЗаписи;
		Архив.Файлы.Добавить(НайденнаяЗапись);
		
		// Сами данные
		Поток.Перейти(НайденнаяЗапись.СмещениеФайла, ПозицияВПотоке.Начало);
		Поток.КопироватьВ(Архив.Поток, Длина);		
		
	КонецЦикла;
	
	Поток.Закрыть();
	Если ТипЗнч(Поток) = Тип("ФайловыйПоток") Тогда
		УдалитьФайлы(Поток.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

Процедура Завершить(Архив) Экспорт
	
	ПотокЗаписи = Архив.Поток;
	ФайлыВАрхиве = Архив.Файлы;
	
	СмещениеКаталога = ПотокЗаписи.ТекущаяПозиция();
	
	// Запись центрального каталога
	Для Каждого НайденнаяЗапись Из ФайлыВАрхиве Цикл
		//ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(НайденнаяЗапись.Буфер);	
		ПотокЗаписи.Записать(НайденнаяЗапись.Буфер, 0, НайденнаяЗапись.Буфер.Размер);
	КонецЦикла;	
	
	Если СмещениеКаталога >= 4294967295 Или ФайлыВАрхиве.Количество() >= 65535 Тогда
		
		// КонецКаталога64
		Буфер = ПолучитьКонецКаталога64(ФайлыВАрхиве.Количество(), Архив.РазмерКаталога, СмещениеКаталога);
		СмещениеКонецКаталога64 = ПотокЗаписи.ТекущаяПозиция();
		ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
		
		// Локатор64
		Буфер = ПолучитьЛокатор64(СмещениеКонецКаталога64);
		ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
		
		СмещениеКаталога = 4294967295;
	КонецЕсли;
	
	// КонецКаталога
	Буфер = ПолучитьКонецКаталога(ФайлыВАрхиве.Количество(), Архив.РазмерКаталога, СмещениеКаталога);
	ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
	
	// Архив готов
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИЙункции

Функция ПрочитатьАрхив(Поток)
	
	ДанныеАрхива = Новый Структура;
	
	КонецКаталога = КонецКаталога(Поток);
	ДанныеАрхива.Вставить("КонецКаталога", КонецКаталога);
	
	Если КонецКаталога.СмещениеКаталога = ЧислоИзШестнадцатеричнойСтроки("0xFFFFFFFF") Тогда
		Локатор64 = Локатор64(Поток, Поток.Размер() - КонецКаталога.Буфер.Размер);
		КонецКаталога64 = КонецКаталога64(Поток, Локатор64.Смещение, Поток.Размер() - КонецКаталога.Буфер.Размер - Локатор64.Буфер.Размер);
		ЗаписиКаталога = ЗаписиКаталога(Поток, КонецКаталога64.СмещениеКаталога, КонецКаталога64.РазмерКаталога);
	Иначе
		ЗаписиКаталога = ЗаписиКаталога(Поток, КонецКаталога.СмещениеКаталога, КонецКаталога.РазмерКаталога);
	КонецЕсли;
	
	ДанныеАрхива.Вставить("ЗаписиКаталога", ЗаписиКаталога);
	
	Возврат ДанныеАрхива;
	
КонецФункции

Функция ВсеЗаписиКаталога(ДанныеАрхива)
	
	ЗаписиКаталога = Новый Массив;
	Смещение = 0;
	Буфер = ДанныеАрхива.ЗаписиКаталога;
	Размер = Буфер.Размер;
	
	Пока Смещение < Размер Цикл
		
		ЗаписьКаталога = ЗаписьКаталога(Буфер, Смещение);
		ЗаписиКаталога.Добавить(ЗаписьКаталога);
		
		Смещение = Смещение + ЗаписьКаталога.ДлинаЗаписи;
		
	КонецЦикла;
	
	Возврат ЗаписиКаталога;
	
КонецФункции

Функция КонецКаталога(Поток)
	
	КонецКаталога = ПолучитьБайты(Поток, Поток.Размер() - 22, 22);
	Если КонецКаталога.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x06054b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
		
	Данные.Вставить("НомерДиска", КонецКаталога.ПрочитатьЦелое16(4));
	Данные.Вставить("НачалоДиска", КонецКаталога.ПрочитатьЦелое16(6));
	Данные.Вставить("КоличествоЗаписейНаДиске", КонецКаталога.ПрочитатьЦелое16(8));
	Данные.Вставить("КоличествоЗаписейВсего", КонецКаталога.ПрочитатьЦелое16(10));
	Данные.Вставить("РазмерКаталога", КонецКаталога.ПрочитатьЦелое32(12));
	Данные.Вставить("СмещениеКаталога", КонецКаталога.ПрочитатьЦелое32(16));
	Данные.Вставить("ДлинаКомментария", КонецКаталога.ПрочитатьЦелое16(20));
	Данные.Вставить("Буфер", КонецКаталога);
	
	Возврат Данные;
	
КонецФункции

Функция ПолучитьКонецКаталога(КоличествоЗаписей, РазмерКаталога, СмещениеКаталога)
	
	Буфер = Новый БуферДвоичныхДанных(22);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x06054b50")); // end of central dir signature
	Буфер.ЗаписатьЦелое16(4, 0); // number of this disk
	Буфер.ЗаписатьЦелое16(6, 0); // number of the disk with the start of the central directory
	Буфер.ЗаписатьЦелое16(8, Мин(КоличествоЗаписей, 65535)); // total number of entries in the central directory on this disk
	Буфер.ЗаписатьЦелое16(10, Мин(КоличествоЗаписей, 65535)); // total number of entries in  the central directory
	Буфер.ЗаписатьЦелое32(12, РазмерКаталога); // size of the central directory
	Буфер.ЗаписатьЦелое32(16, СмещениеКаталога); // offset of start of central directory with respect to the starting disk number
	Буфер.ЗаписатьЦелое16(20, 0); // .ZIP file comment length
	
	Возврат Буфер;
	
КонецФункции

Функция КонецКаталога64(Поток, Начало, Конец)
	
	КонецКаталога = ПолучитьБайты(Поток, Начало, Конец - Начало);
	Если КонецКаталога.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x06064b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("РазмерКонецКаталога64", КонецКаталога.ПрочитатьЦелое64(4));
	Данные.Вставить("СделаноВерсией", КонецКаталога.ПрочитатьЦелое16(12));
	Данные.Вставить("ВерсияТребуется", КонецКаталога.ПрочитатьЦелое16(14));
	Данные.Вставить("НомерДиска", КонецКаталога.ПрочитатьЦелое32(16));
	Данные.Вставить("НомерДиска2", КонецКаталога.ПрочитатьЦелое32(20));
	Данные.Вставить("КоличествоЗаписейНаЭтомДиске", КонецКаталога.ПрочитатьЦелое64(24));
	Данные.Вставить("ВсегоЗаписей", КонецКаталога.ПрочитатьЦелое64(32));
	Данные.Вставить("РазмерКаталога", КонецКаталога.ПрочитатьЦелое64(40));
	Данные.Вставить("СмещениеКаталога", КонецКаталога.ПрочитатьЦелое64(48));
	Данные.Вставить("Буфер", КонецКаталога);
	
	Возврат Данные;
	
КонецФункции

Функция ПолучитьКонецКаталога64(ВсегоЗаписей, РазмерКаталога, СмещениеКаталога) 
	
	Буфер = Новый БуферДвоичныхДанных(56);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x06064b50")); // zip64 end of central dir signature  
	Буфер.ЗаписатьЦелое64(4, 56 - 12); // size of zip64 end of central directory record 
	Буфер.ЗаписатьЦелое16(12, 45); // version made by
	Буфер.ЗаписатьЦелое16(14, 45); // version needed to extract
	Буфер.ЗаписатьЦелое32(16, 0); // number of this disk
	Буфер.ЗаписатьЦелое32(20, 0); // number of the disk with the start of the central directory
	Буфер.ЗаписатьЦелое64(24, ВсегоЗаписей); //total number of entries in the central directory on this disk
	Буфер.ЗаписатьЦелое64(32, ВсегоЗаписей); // total number of entries in the central directory
	Буфер.ЗаписатьЦелое64(40, РазмерКаталога); // size of the central directory
	Буфер.ЗаписатьЦелое64(48, СмещениеКаталога); // offset of start of central directory with respect to the starting disk number
	Возврат Буфер;
	
КонецФункции

Функция ПолучитьБайты(Поток, Начало, Размер)
	
	Поток.Перейти(Начало, ПозицияВПотоке.Начало);
	Буфер = Новый БуферДвоичныхДанных(Размер);
	Если Поток.Прочитать(Буфер, 0, Размер) <> Размер Тогда
		ВызватьИсключение "Неправильные размеры";
	КонецЕсли;
	
	Возврат Буфер;
	
КонецФункции


Функция ЗаписиКаталога(Поток, Начало, Размер)
	
	Возврат ПолучитьБайты(Поток, Начало, Размер);
	
КонецФункции

Функция Локатор64(Поток, Конец)
	
	Локатор = ПолучитьБайты(Поток, Конец - 20, 20);
	Если Локатор.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x07064b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("НомерДиска", Локатор.ПрочитатьЦелое32(4));
	Данные.Вставить("Смещение", Локатор.ПрочитатьЦелое64(8));
	Данные.Вставить("ВсегоДисков", Локатор.ПрочитатьЦелое32(16));
	Данные.Вставить("Буфер", Локатор);
	
	Возврат Данные;
	
КонецФункции

Функция ПолучитьЛокатор64(СмещениеКонецКаталога64)
	
	Буфер = Новый БуферДвоичныхДанных(20);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x07064b50")); // zip64 end of central dir locator signature
	Буфер.ЗаписатьЦелое32(4, 0); // number of the disk with the start of the zip64 end of central directory
	Буфер.ЗаписатьЦелое64(8, СмещениеКонецКаталога64); // relative offset of the zip64 end of central directory record
	Буфер.ЗаписатьЦелое32(16, 1); // total number of disks
	
	Возврат Буфер;
	
КонецФункции

Функция ЗаписьКаталога(Буфер, Смещение)
	
	ЗаписьКаталога = Буфер;
	
	// ЧислоИзШестнадцатеричнойСтроки("0x02014b50") = 33639248
	Если ЗаписьКаталога.ПрочитатьЦелое32(Смещение) <> 33639248 Тогда
		ВызватьИсключение НСтр("ru = 'Неверный формат'");
	КонецЕсли;
	
	ДлинаИмениФайла = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 28);
	ДлинаДопДанных = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 30);
	ДлинаКомментария = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 32);
	ДлинаЗаписи = 46 + ДлинаИмениФайла + ДлинаДопДанных + ДлинаКомментария;
	
	Данные = Новый Структура;	
	Данные.Вставить("Буфер", ЗаписьКаталога.Прочитать(Смещение, ДлинаЗаписи));
	Данные.Вставить("СжатыйРазмер", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 20));
	Данные.Вставить("НесжатыйРазмер", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 24));	
	Данные.Вставить("СмещениеФайла", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 42));
	Данные.Вставить("ДлинаЗаписи", ДлинаЗаписи);
	
	Если Данные.НесжатыйРазмер = 4294967295 Или Данные.СмещениеФайла = 4294967295 Или Данные.СжатыйРазмер = 4294967295 Тогда
		
		Если ДлинаДопДанных = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Неверный формат'");
		КонецЕсли;
		
		Для Каждого ДопДанные Из РаспарситьДопДанные(ЗаписьКаталога.Прочитать(Смещение + 46 + ДлинаИмениФайла, ДлинаДопДанных)) Цикл 
			Если ДопДанные.Тип = ЧислоИзШестнадцатеричнойСтроки("0x0001") Тогда
				Буфер64 = ДопДанные.Данные;
				Индекс64 = 0;
				Если Данные.НесжатыйРазмер = 4294967295 Тогда
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Если Данные.СжатыйРазмер = 4294967295 Тогда
					Данные.СжатыйРазмер = Буфер64.ПрочитатьЦелое64(Индекс64);
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Если Данные.СмещениеФайла = 4294967295 Тогда
					Данные.СмещениеФайла = Буфер64.ПрочитатьЦелое64(Индекс64);
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Данные.Вставить("ИмяФайла", ПолучитьСтрокуИзБуфераДвоичныхДанных(ЗаписьКаталога.ПолучитьСрез(Смещение + 46, ДлинаИмениФайла))); // Мы используем только латиницу
	
	Возврат Данные;
	
КонецФункции

Функция РаспарситьДопДанные(БуферДвоичныхДанных)
	
	ДопДанные = Новый Массив;
	
	Индекс = 0;
	Пока Индекс < БуферДвоичныхДанных.Размер Цикл
		
		Тип = БуферДвоичныхДанных.ПрочитатьЦелое16(Индекс);
		Размер = БуферДвоичныхДанных.ПрочитатьЦелое16(Индекс + 2);
		Если Размер > 0 Тогда
			Данные = БуферДвоичныхДанных.Прочитать(Индекс + 4, Размер);
		Иначе
			Данные = Неопределено;
		КонецЕсли;
		
		ДопДанные.Добавить(Новый Структура("Тип, Данные", Тип, Данные));
		Индекс = Индекс + 4 + Размер;
		
	КонецЦикла;
	
	Возврат ДопДанные;
	
КонецФункции

Функция СобратьДопДанные(ДопДанные)
	
	Размер = 0;
	Для Каждого Данные Из ДопДанные Цикл
		Размер = Размер + 4 + Данные.Данные.Размер;
	КонецЦикла;
	
	Буфер = Новый БуферДвоичныхДанных(Размер);
	Смещение = 0;
	Для Каждого Данные Из ДопДанные Цикл
		Буфер.ЗаписатьЦелое16(Смещение, Данные.Тип);
		Буфер.ЗаписатьЦелое16(Смещение + 2, Данные.Данные.Размер);
		Буфер.Записать(Смещение + 4, Данные.Данные);
		Смещение = Смещение + 4 + Данные.Данные.Размер;		
	КонецЦикла;
	
	Возврат Буфер;
	
КонецФункции

#КонецОбласти
