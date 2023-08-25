///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Управляет видимостью команды вызова онлайн поддержки на форме
//
// Параметры:
//  ИмяСобытия - Строка - идентификатор сообщения;
//  Элемент - КнопкаФормы - команда вызова онлайн поддержки на форме.
//
Процедура ОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	Если ИмяСобытия = "СохранениеНастроекВызовОнлайнПоддержки" Тогда
		НастройкиПользователя = ВызовОнлайнПоддержкиВызовСервера.НастройкиУчетнойЗаписиПользователя();
		Элемент.Видимость = НастройкиПользователя.ВидимостьКнопкиВызовОнлайнПоддержки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФормуНастройкаОнлайнПоддержки() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОнлайнПоддержки");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает уникальный идентификатор клиента 1С (приложение).
Функция ИдентификаторКлиента() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ИдентификаторКлиента;
	
КонецФункции

// Возвращает путь файла приложения в реестре Windows.
// 
Функция ПутьКИсполняемомуФайлуИзРеестраWindows() Экспорт
	
#Если ВебКлиент Тогда
	Возврат "";
#Иначе
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		Возврат "";
	КонецЕсли;
	
	Значение = "";
	
	Объект = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
	Объект.GetStringValue("2147483649","Software\Buhphone","ProgramPath", Значение);
	
	Если Значение = "" Или  Значение = NULL Тогда
		ЗначениеИзРеестра = "";
	Иначе
		ЗначениеИзРеестра = Значение;
	КонецЕсли;
	
	Возврат ЗначениеИзРеестра;
	
#КонецЕсли
	
КонецФункции

// Диалоговое окно для выбора файла.
//
Процедура ВыбратьФайлВызовОнлайнПоддержки(ОповещениеОЗакрытии, ПутьКФайлу = "") Экспорт
	
	Каталог = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru = 'Выберите исполняемый файл приложения'");
	Диалог.ПолноеИмяФайла = ПутьКФайлу;
	Диалог.Каталог = Каталог.Путь;
	Фильтр = НСтр("ru = 'Файл приложения (*.exe)|*.exe'");
	Диалог.Фильтр = Фильтр;
	Диалог.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлВызовОнлайнПоддержкиЗавершение", ЭтотОбъект, ОповещениеОЗакрытии);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Оповещение, Диалог);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВыбратьФайлВызовОнлайнПоддержкиЗавершение(ВыбранныеФайлы, ОповещениеОЗакрытии) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, ВыбранныеФайлы[0]);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, "");
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие исполняемого файла по указанному пути.
//
Процедура НаличиеФайлаВызовОнлайнПоддержки(ОповещениеОЗакрытии, Путь)
	ПроверяемыйФайл = Новый Файл(Путь);
	Оповещение = Новый ОписаниеОповещения("НаличиеФайлаВызовОнлайнПоддержкиПослеПроверкиСуществования", ЭтотОбъект, ОповещениеОЗакрытии);
	Если НРег(ПроверяемыйФайл.Расширение) <> ".exe" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Ложь);
	Иначе
		ПроверяемыйФайл.НачатьПроверкуСуществования(Оповещение);
	КонецЕсли;
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура НаличиеФайлаВызовОнлайнПоддержкиПослеПроверкиСуществования(Существует, ОповещениеОЗакрытии) Экспорт
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Существует);
КонецПроцедуры

// Процедура запускает исполняемый файл приложения.
// При отсутствии файла приложения - открывает форму поиска пути к исполняемому файлу.
//
Процедура ВызватьОнлайнПоддержку() Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для работы с приложением необходима операционная система Microsoft Windows.'"));
		Возврат
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеУстановкиРасширения", ЭтотОбъект);
	ТекстСообщения = НСтр("ru = 'Для запуска приложения установите расширение для работы с 1С:Предприятием.'");
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения, Ложь);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеУстановкиРасширения(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ РасширениеПодключено Тогда
		Возврат;
	КонецЕсли;
	
	// Определение параметров запуска.
	ИдентификаторКлиента = ИдентификаторКлиента();
	ПутьИзРеестра = ПутьКИсполняемомуФайлуИзРеестраWindows();
	ПутьИзХранилища = ВызовОнлайнПоддержкиВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПутьИзРеестра", ПутьИзРеестра);
	ДополнительныеПараметры.Вставить("ПутьИзХранилища", ПутьИзХранилища);
	
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеПроверкиПутиИзРеестра", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайлаВызовОнлайнПоддержки(Оповещение, ПутьИзРеестра);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеПроверкиПутиИзРеестра(ПутьИзРеестраВерен, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("ПутьИзРеестраВерен", ПутьИзРеестраВерен);
	Оповещение = Новый ОписаниеОповещения("ВызватьОнлайнПоддержкуПослеПроверкиПутиИзХранилища", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайлаВызовОнлайнПоддержки(Оповещение, ДополнительныеПараметры.ПутьИзХранилища);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВызватьОнлайнПоддержкуПослеПроверкиПутиИзХранилища(ПутьИзХранилищаВерен, Контекст) Экспорт
	
	УчетнаяЗапись = ВызовОнлайнПоддержкиВызовСервера.НастройкиУчетнойЗаписиПользователя();
	ПараметрыЗапускаВызовОнлайнПоддержки = Новый Массив;
	ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/StartedFrom1CConf");
	
	Если УчетнаяЗапись.ИспользоватьЛП Тогда
		
		Если Не ПустаяСтрока(УчетнаяЗапись.Логин) И Не ПустаяСтрока(УчетнаяЗапись.Пароль) Тогда
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/login:");
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить(УчетнаяЗапись.Логин);
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить("/password:");
			ПараметрыЗапускаВызовОнлайнПоддержки.Добавить(УчетнаяЗапись.Пароль);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПутьИзХранилищаВерен Тогда
		КомандаЗапуска = Новый Массив;
		КомандаЗапуска.Добавить(Контекст.ПутьИзХранилища);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КомандаЗапуска, ПараметрыЗапускаВызовОнлайнПоддержки);
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(КомандаЗапуска);
		Возврат;
	КонецЕсли;
	
	Если Контекст.ПутьИзРеестраВерен Тогда
		КомандаЗапуска = Новый Массив;
		КомандаЗапуска.Добавить(Контекст.ПутьИзРеестра);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КомандаЗапуска, ПараметрыЗапускаВызовОнлайнПоддержки);
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(КомандаЗапуска);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПоискИсполняемогоФайлаОнлайнПоддержки");
	
КонецПроцедуры

#КонецОбласти





 