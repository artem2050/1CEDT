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

	УстановитьУсловноеОформление();
	
	АдресДляЗагрузки = "http://cbrates.rbc.ru/tsv/cb/840.tsv";
	КудаСохранять = 0;
	
	ЗначениеЗаголовкаIfModifiedSince = ТекущаяДатаСеанса() - 24 * 60 * 60;
	Таймаут = 7;
	
	ВидимостьДоступность(ЭтотОбъект);
	
	Элементы.ПутьНаКлиенте.КнопкаВыбора = Не ОбщегоНазначения.ЭтоВебКлиент();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресДляЗагрузкиПриИзменении(Элемент)
	
	АдресДляЗагрузки = СокрЛП(АдресДляЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура КудаСохранятьПриИзменении(Элемент)
	
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьНаКлиентеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьКаталог(Новый ОписаниеОповещения("ПутьНаКлиентеНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьНаКлиентеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФайла = Результат;
	
	Если ИмяФайла <> Неопределено Тогда
		ПутьНаКлиенте = ИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресВоВременномХранилищеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ПустаяСтрока(АдресВоВременномХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресВоВременномХранилище, "demo.txt");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПроксиДоступСКлиента(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПроксиДоступССервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Ложь));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Заголовки = Новый Соответствие;
	
	Если ОтправлятьЗаголовокIfModifiedSince Тогда 
		Заголовки.Вставить("If-Modified-Since", ДатаHTTP(ЗначениеЗаголовкаIfModifiedSince));
	КонецЕсли;
	
	ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
	ПараметрыПолучения.Заголовки = Заголовки;
	ПараметрыПолучения.Таймаут = Таймаут;
	
	Если КудаСохранять = 0 Тогда
		
		Если Не ПустаяСтрока(ПутьНаКлиенте) Тогда 
			ПараметрыПолучения.ПутьДляСохранения = ПутьНаКлиенте;
		КонецЕсли;
		
		Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(АдресДляЗагрузки, ПараметрыПолучения);
		
		Если Результат.Статус Тогда
			ПутьНаКлиенте = Результат.Путь;
			ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На клиенте сохранен файл ""%1""'"), 
				Результат.Путь ));
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
		КонецЕсли;
	ИначеЕсли КудаСохранять = 1 Тогда
		
		Если Не ПустаяСтрока(ПутьНаСервере) Тогда 
			ПараметрыПолучения.ПутьДляСохранения = ПутьНаСервере;
		КонецЕсли;
		
		Результат = СкачатьФайлНаСервере(АдресДляЗагрузки, ПараметрыПолучения);
		
		Если Результат.Статус Тогда
			ПутьНаСервере = Результат.Путь;
			ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На сервере сохранен файл ""%1""'"), 
				Результат.Путь));
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
		КонецЕсли;
	ИначеЕсли КудаСохранять = 2 Тогда
		Результат = СкачатьФайлВоВременноеХранилище(АдресДляЗагрузки);
		
		Если Результат.Статус Тогда
			АдресВоВременномХранилище = Результат.Путь;
			ПоказатьПредупреждение(,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл сохранен во временное хранилище ""%1""'"), 
					АдресВоВременномХранилище));
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Куда сохранять"" не заполнено'"), , "КудаСохранять");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразует универсальную дату в дату формата rfc1123-date.
// См. https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html, п. 3.3.1.
//
&НаКлиентеНаСервереБезКонтекста
Функция ДатаHTTP(Знач Дата)
	
	ДниНедели = СтрРазделить("Mon,Tue,Wed,Thu,Fri,Sat,Sun", ",");
	Месяцы = СтрРазделить("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", ",");
	
	ШаблонДаты = "[ДеньНедели], [День] [Месяц] [Год] [Час]:[Минута]:[Секунда] GMT"; // АПК:1297 не локализуется
	
	ПараметрыДаты = Новый Структура;
	ПараметрыДаты.Вставить("ДеньНедели", ДниНедели[ДеньНедели(Дата)-1]);
	ПараметрыДаты.Вставить("День", Формат(День(Дата), "ЧЦ=2; ЧВН="));
	ПараметрыДаты.Вставить("Месяц", Месяцы[Месяц(Дата)-1]);
	ПараметрыДаты.Вставить("Год", Формат(Год(Дата), "ЧЦ=4; ЧВН=; ЧГ=0"));
	ПараметрыДаты.Вставить("Час", Формат(Час(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	ПараметрыДаты.Вставить("Минута", Формат(Минута(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	ПараметрыДаты.Вставить("Секунда", Формат(Секунда(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	
	ДатаHTTP = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонДаты, ПараметрыДаты);
	
	Возврат ДатаHTTP;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КудаСохранять.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтаИБФайловая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ПутьНаКлиенте.Доступность = (Форма.КудаСохранять = 0);
	Элементы.ПутьНаСервере.Доступность = (Форма.КудаСохранять = 1);
	Элементы.АдресВоВременномХранилище.Доступность    = (Форма.КудаСохранять = 2);
	Элементы.АдресВоВременномХранилище.ТолькоПросмотр = (Форма.КудаСохранять = 2);
	Элементы.ЗначениеЗаголовкаIfModifiedSince.ТолькоПросмотр = Не Форма.ОтправлятьЗаголовокIfModifiedSince;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталог(Знач Оповещение)
	
#Если ВебКлиент Тогда
	ВыполнитьОбработкуОповещения(Оповещение, Неопределено);
	Возврат;
#Иначе
	
	Если НЕ ЗначениеЗаполнено(АдресДляЗагрузки) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Что загружать"" не заполнено.'"),, "АдресДляЗагрузки");
		ВыполнитьОбработкуОповещения(Оповещение, Неопределено);
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения'");
	Диалог.ПолноеИмяФайла = ?(ЗначениеЗаполнено(ПутьНаКлиенте), ПутьНаКлиенте, ВыделитьИмяФайла());
	
	Контекст = Новый Структура("Диалог, Оповещение", Диалог, Оповещение);
	
	ОповещениеДиалогаВыбора = Новый ОписаниеОповещения("ВыбратьКаталогЗавершение", ЭтотОбъект, Контекст);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОповещениеДиалогаВыбора, Диалог);
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталогЗавершение(ВыбранныеФайлы, Контекст) Экспорт
	
	Диалог     = Контекст.Диалог;
	Оповещение = Контекст.Оповещение;
	
	Если НЕ (ВыбранныеФайлы <> Неопределено) Тогда
		ВыполнитьОбработкуОповещения(Оповещение, Неопределено);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Диалог.ВыбранныеФайлы[0]);
	
КонецПроцедуры

&НаКлиенте
Функция ВыделитьИмяФайла()
	
	Результат = "";
	
	ДлинаАдреса = СтрДлина(АдресДляЗагрузки);
	Для Номер = 1 По ДлинаАдреса Цикл
		НомерСимвола = ДлинаАдреса - Номер + 1;
		Символ = Сред(АдресДляЗагрузки, НомерСимвола, 1);
		Если Символ = "\" ИЛИ Символ = "/" Тогда
			Прервать;
		КонецЕсли;
		Результат = Символ + Результат;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СкачатьФайлНаСервере(АдресДляЗагрузки, ПараметрыПолучения)
	
	Возврат ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(АдресДляЗагрузки, ПараметрыПолучения);
	
КонецФункции

&НаСервереБезКонтекста
Функция СкачатьФайлВоВременноеХранилище(АдресДляЗагрузки)
	
	Возврат ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(АдресДляЗагрузки);
	
КонецФункции

&НаКлиенте
Процедура ОтправлятьЗаголовокIfModifiedSinceПриИзменении(Элемент)
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти