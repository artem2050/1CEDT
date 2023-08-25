///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПриПолученииПредставленияСертификата(Знач Сертификат, Знач ДобавкаВремени, Представление) Экспорт
	
	// Локализация
	ДатыСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДатыСертификата(Сертификат, ДобавкаВремени);
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, до %2'"),
		ПредставлениеСубъекта(Сертификат, Ложь), Формат(ДатыСертификата.ДатаОкончания, "ДФ=MM.yyyy"));
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриПолученииПредставленияСубъекта(Знач Сертификат, Представление) Экспорт
	
	// Локализация
	Представление = ПредставлениеСубъекта(Сертификат, Истина);
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриПолученииРасширенныхСвойствСубъектаСертификата(Знач Субъект, Свойства) Экспорт
	
	// Локализация
	Свойства = Новый Структура;
	Свойства.Вставить("ОГРН");
	Свойства.Вставить("ОГРНИП");
	Свойства.Вставить("СНИЛС");
	Свойства.Вставить("ИНН");
	Свойства.Вставить("Фамилия");
	Свойства.Вставить("Имя");
	Свойства.Вставить("Отчество");
	Свойства.Вставить("Должность");
	Свойства.Вставить("Организация");
	Свойства.Вставить("ОбщееИмя");
	Свойства.Вставить("ИННЮЛ");
	
	Если Субъект.Свойство("OGRN")Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Субъект.OGRN);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_1") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Субъект.OID1_2_643_100_1);
	КонецЕсли;
	
	Если Субъект.Свойство("OGRNIP") Тогда
		Свойства.ОГРНИП = ПодготовитьСтроку(Субъект.OGRNIP);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_5") Тогда
		Свойства.ОГРНИП = ПодготовитьСтроку(Субъект.OID1_2_643_100_5);
	КонецЕсли;
	
	Если Субъект.Свойство("SNILS") Тогда
		Свойства.СНИЛС = ПодготовитьСтроку(Субъект.SNILS);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_3") Тогда
		Свойства.СНИЛС = ПодготовитьСтроку(Субъект.OID1_2_643_100_3);
	КонецЕсли;
	
	ЗаполнитьИНН(Свойства, Субъект);
	
	Если Субъект.Свойство("CN") Тогда
		Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.CN);
	КонецЕсли;
	
	Если Субъект.Свойство("O") Тогда
		Свойства.Организация = ПодготовитьСтроку(Субъект.O);
	КонецЕсли;
	
	Если Субъект.Свойство("SN") Тогда // Наличие фамилии (обычно для должностного лица).
		
		// Извлечение ФИО из поля SN и GN.
		Свойства.Фамилия = ПодготовитьСтроку(Субъект.SN);
		
		Если Субъект.Свойство("GN") Тогда
			Отчество = ПодготовитьСтроку(Субъект.GN);
			Позиция = СтрНайти(Отчество, " ");
			Если Позиция = 0 Тогда
				Свойства.Имя = Отчество;
			Иначе
				Свойства.Имя = Лев(Отчество, Позиция - 1);
				Свойства.Отчество = ПодготовитьСтроку(Сред(Отчество, Позиция + 1));
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Свойства.ОГРНИП)    // Признак индивидуального предпринимателя.
	      Или Субъект.Свойство("T")                 // Признак должностного лица.
	      Или Субъект.Свойство("OID2_5_4_12")       // Признак должностного лица.
	      Или ЗначениеЗаполнено(Свойства.СНИЛС)     // Признак физического лица.
	      Или ЭтоИННФизЛица(Свойства.ИНН) И НЕ ЗначениеЗаполнено(Свойства.ИННЮЛ) Тогда // Признак физического лица.
		
		Если Свойства.ОбщееИмя <> Свойства.Организация
			   И Не (Субъект.Свойство("T")           И Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.T))
			   И Не (Субъект.Свойство("OID2_5_4_12") И Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.OID2_5_4_12)) Тогда
				
				// Извлечение ФИО из поля CN.
				Массив = СтрРазделить(Свойства.ОбщееИмя, " ", Ложь);
				
				Если Массив.Количество() < 4 Тогда
					Если Массив.Количество() > 0 Тогда
						Свойства.Фамилия = СокрЛП(Массив[0]);
					КонецЕсли;
					Если Массив.Количество() > 1 Тогда
						Свойства.Имя = СокрЛП(Массив[1]);
					КонецЕсли;
					Если Массив.Количество() > 2 Тогда
						Свойства.Отчество = СокрЛП(Массив[2]);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Свойства.Фамилия) Или ЗначениеЗаполнено(Свойства.Имя) Тогда
		Если Субъект.Свойство("T") Тогда
			Свойства.Должность = ПодготовитьСтроку(Субъект.T);
			
		ИначеЕсли Субъект.Свойство("OID2_5_4_12") Тогда
			Свойства.Должность = ПодготовитьСтроку(Субъект.OID2_5_4_12);
		КонецЕсли;
	КонецЕсли;
	
	// Конец Локализация
	
КонецПроцедуры

Процедура ПриПолученииРасширенныхСвойствИздателяСертификата(Знач Издатель, Свойства) Экспорт
	
	// Локализация
	Свойства = Новый Структура;
	Свойства.Вставить("ОГРН");
	Свойства.Вставить("ИНН");
	Свойства.Вставить("ИННЮЛ");
	
	Если Издатель.Свойство("OGRN") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Издатель.OGRN);
		
	ИначеЕсли Издатель.Свойство("OID1_2_643_100_1") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Издатель.OID1_2_643_100_1);
	КонецЕсли;
	
	ЗаполнитьИНН(Свойства, Издатель);

	// Конец Локализация
	
КонецПроцедуры

// Локализация
Функция ПредставлениеСубъекта(Знач Сертификат, Знач Отчество) 
	
	Субъект = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	
	Если ЗначениеЗаполнено(Субъект.Фамилия)
	   И ЗначениеЗаполнено(Субъект.Имя) Тогда
		
		Представление = Субъект.Фамилия + " " + Субъект.Имя;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.Фамилия) Тогда
		Представление = Субъект.Фамилия;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.Имя) Тогда
		Представление = Субъект.Имя;
	КонецЕсли;
	
	Если Отчество И ЗначениеЗаполнено(Субъект.Отчество) Тогда
		Представление = Представление + " " + Субъект.Отчество;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представление) Тогда
		Если ЗначениеЗаполнено(Субъект.Организация) Тогда
			Представление = Представление + ", " + Субъект.Организация;
		КонецЕсли;
		Если ЗначениеЗаполнено(Субъект.Подразделение) Тогда
			Представление = Представление + ", " + Субъект.Подразделение;
		КонецЕсли;
		Если ЗначениеЗаполнено(Субъект.Должность) Тогда
			Представление = Представление + ", " + Субъект.Должность;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.ОбщееИмя) Тогда
		Представление = Субъект.ОбщееИмя;
	КонецЕсли;
	Возврат Представление;
	
КонецФункции

Функция ПодготовитьСтроку(СтрокаИзСертификата)
	Возврат СокрЛП(ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(СтрокаИзСертификата));
КонецФункции

Функция ЭтоИННФизЛица(ИНН)
	
	Если СтрДлина(ИНН) <> 12 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для НомерСимвола = 1 По 12 Цикл
		Если СтрНайти("0123456789", Сред(ИНН,НомерСимвола,1)) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрНачинаетсяС(ИНН, "00") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьИНН(Свойства, Данные)
	
	ИННЮЛ = Неопределено;
	ИНН = Неопределено;
	
	Если Данные.Свойство("INN") Тогда
		ИНН = Данные.INN;
	ИначеЕсли Данные.Свойство("OID1_2_643_3_131_1_1") Тогда
		ИНН = ПодготовитьСтроку(Данные.OID1_2_643_3_131_1_1);
	КонецЕсли;
	
	Если Данные.Свойство("INNLE") Тогда
		ИННЮЛ = Данные.INNLE;
	ИначеЕсли Данные.Свойство("OID1_2_643_100_4")
			И СтрДлина(Данные.OID1_2_643_100_4) = 10 Тогда
		ИННЮЛ = ПодготовитьСтроку(Данные.OID1_2_643_100_4);
	ИначеЕсли Данные.Свойство("_1_2_643_100_4") Тогда
		ИННЮЛ = ПодготовитьСтроку(Данные._1_2_643_100_4);
	КонецЕсли;
		
	Свойства.ИННЮЛ = ИННЮЛ;
	Свойства.ИНН = ИНН;
	
КонецПроцедуры

// Конец Локализация

#КонецОбласти
