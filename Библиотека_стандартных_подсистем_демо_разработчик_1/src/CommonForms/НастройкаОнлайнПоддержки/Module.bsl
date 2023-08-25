///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
   	
	// Заполнение элементов формы согласно предыдущих настроек текущего пользователя.
	Результат = ВызовОнлайнПоддержкиВызовСервера.НастройкиУчетнойЗаписиПользователя();
	ВидимостьКнопки = Результат.ВидимостьКнопкиВызовОнлайнПоддержки;
	СохранитьЛогинПароль = Результат.ИспользоватьЛП;	
	Элементы.Логин.Доступность = Результат.ИспользоватьЛП;
	Элементы.Пароль.Доступность = Результат.ИспользоватьЛП;
	Логин = Результат.Логин;
	Пароль = Результат.Пароль;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	ПутьКФайлу = ВызовОнлайнПоддержкиВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
	
	ИнициализироватьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для работы с приложением необходима операционная система Microsoft Windows.'"));
		Отказ = Истина;
	КонецЕсли;
	Если ПутьКФайлу="" Тогда
		ПутьКФайлу = ВызовОнлайнПоддержкиКлиент.ПутьКИсполняемомуФайлуИзРеестраWindows();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СохранитьЛогинПарольПриИзменении(Элемент)
	 
	Доступ = СохранитьЛогинПароль;
	Элементы.Логин.Доступность = Доступ;
	Элементы.Пароль.Доступность = Доступ;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьКнопкиПриИзменении(Элемент)
	ИнициализироватьЭлементыФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораЗавершение", ЭтотОбъект);
	ВызовОнлайнПоддержкиКлиент.ВыбратьФайлВызовОнлайнПоддержки(Оповещение, ПутьКФайлу);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ИдентификаторКлиента = ВызовОнлайнПоддержкиКлиент.ИдентификаторКлиента();	
	СохранитьНастройкиПользователяВХранилище(Логин, Пароль, СохранитьЛогинПароль, ВидимостьКнопки);
	НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу);
	// Оповестим форму кнопки для управления видимостью кнопки.
	Оповестить("СохранениеНастроекВызовОнлайнПоддержки");
    ПриИзмененииНастроек();
	ОбновитьИнтерфейс();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАккаунтВызовОнлайнПоддержки(Команда)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://buhphone.com/clients/be-client/");
	
КонецПроцедуры

&НаКлиенте
Процедура ТехническиеТребования(Команда)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://buhphone.com/require/#anchor_1");
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьПриложение(Команда)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://distribs.buhphone.com/current");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу)
	ВызовОнлайнПоддержки.СохранитьРасположениеИсполняемогоФайлаВызовОнлайнПоддержки(ИдентификаторКлиента, ПутьКФайлу);
КонецПроцедуры 

&НаСервереБезКонтекста
Процедура СохранитьНастройкиПользователяВХранилище(Логин, 
										 Пароль, 
										 СохранитьЛогинПароль,
										 ВидимостьКнопки)
																
	ВызовОнлайнПоддержки.СохранитьНастройкиПользователяВХранилище(Логин, Пароль, СохранитьЛогинПароль, ВидимостьКнопки);

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ПриИзмененииНастроек()
	ВызовОнлайнПоддержкиПереопределяемый.ПриИзмененииНастроек();
КонецПроцедуры

// Выполняет инициализацию элементов формы в зависимости от
// настроек приложения.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ИнициализироватьЭлементыФормы(Форма)
	
	Форма.Элементы.ГруппаПараметрыЗапуска.Доступность = Форма.ВидимостьКнопки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораЗавершение(НовыйПутьКФайлу, ДополнительныеПараметры) Экспорт
	Если НовыйПутьКФайлу <> "" Тогда
		ПутьКФайлу = НовыйПутьКФайлу;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти




