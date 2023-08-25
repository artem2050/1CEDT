///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Ожидать завершения выполнения процедуры в фоновом задании и открыть форму ожидания длительной операции.
// Применяется совместно с функцией ДлительныеОперации.ВыполнитьВФоне для повышения отзывчивости пользовательского 
// интерфейса, заменяя длительный серверный вызов на запуск фонового задания.
// 
// Параметры:
//  ДлительнаяОперация     - см. ДлительныеОперации.ВыполнитьВФоне
//  ОповещениеОЗавершении  - ОписаниеОповещения - оповещение, которое вызывается при завершении фонового задания. 
//                           Параметры процедуры-обработчика оповещения: 
//   * Результат - Структура
//               - Неопределено - структура со свойствами или Неопределено, если задание было отменено:
//     ** Статус           - Строка - "Выполнено", если задание было успешно выполнено;
//	                                  "Ошибка", если задание завершено с ошибкой.
//     ** АдресРезультата  - Строка - адрес временного хранилища, в которое будет
//	                                  помещен (или уже помещен) результат работы процедуры.
//     ** АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат, 
//	                                     содержит адрес дополнительного временного хранилища,
//	                                     в которое будет помещен (или уже помещен) результат работы процедуры.
//     ** КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
//     ** ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
//     ** Сообщения        - ФиксированныйМассив
//	                       - Неопределено - массив объектов СообщениеПользователю, 
//                                         сформированных в процедуре-обработчике длительной операции.
//   * ДополнительныеПараметры - Произвольный - произвольные данные, переданные в описании оповещения. 
//  ПараметрыОжидания      - см. ДлительныеОперацииКлиент.ПараметрыОжидания
//
Процедура ОжидатьЗавершение(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении = Неопределено, 
	Знач ПараметрыОжидания = Неопределено) Экспорт
	
	ПроверитьПараметрыОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
	Если ДлительнаяОперация.Статус <> "Выполняется" Тогда
		Если ОповещениеОЗавершении <> Неопределено Тогда
			Если ДлительнаяОперация.Статус <> "Отменено" Тогда
				Результат = Новый Структура;
				Результат.Вставить("Статус", ДлительнаяОперация.Статус);
				Если ДлительнаяОперация.Свойство("АдресРезультата") Тогда
					Результат.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
				КонецЕсли;
				Если ДлительнаяОперация.Свойство("АдресДополнительногоРезультата") Тогда
					Результат.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
				КонецЕсли;
				Результат.Вставить("КраткоеПредставлениеОшибки", ДлительнаяОперация.КраткоеПредставлениеОшибки);
				Результат.Вставить("ПодробноеПредставлениеОшибки", ДлительнаяОперация.ПодробноеПредставлениеОшибки);
				Результат.Вставить("Сообщения", ?(ПараметрыОжидания <> Неопределено И ПараметрыОжидания.ВыводитьСообщения, 
					ДлительнаяОперация.Сообщения, Неопределено));
			Иначе
				Результат = Неопределено;
			КонецЕсли;
			
			Если ДлительнаяОперация.Статус = "Выполнено" И ПараметрыОжидания <> Неопределено Тогда
				ПоказатьОповещение(ПараметрыОжидания.ОповещениеПользователя);
			КонецЕсли;
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыОжидания(Неопределено);
	Если ПараметрыОжидания <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыОжидания);
	КонецЕсли;
	Если ДлительнаяОперация.Свойство("АдресРезультата") Тогда
		ПараметрыФормы.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
	КонецЕсли;
	Если ДлительнаяОперация.Свойство("АдресДополнительногоРезультата") Тогда
		ПараметрыФормы.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
	КонецЕсли;
	ПараметрыФормы.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
	
	Если ПараметрыФормы.ВыводитьОкноОжидания Тогда
		ПараметрыФормы.Удалить("ФормаВладелец");
		
		ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", ПараметрыФормы, 
			?(ПараметрыОжидания <> Неопределено, ПараметрыОжидания.ФормаВладелец, Неопределено),
			,,,ОповещениеОЗавершении);
	Иначе
		ПараметрыФормы.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		ПараметрыФормы.Вставить("ТекущийИнтервал", ?(ПараметрыФормы.Интервал <> 0, ПараметрыФормы.Интервал, 1));
		ПараметрыФормы.Вставить("Контроль", ТекущаяДата() + ПараметрыФормы.ТекущийИнтервал); // дата сеанса не используется
		
		Операции = АктивныеДлительныеОперации();
		Операции.Список.Вставить(ПараметрыФормы.ИдентификаторЗадания, ПараметрыФормы);
		
		ПодключитьОбработчикОжидания("КонтрольДлительныхОпераций", ПараметрыФормы.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает пустую структуру для параметра ПараметрыОжидания процедуры ДлительныеОперацииКлиент.ОжидатьЗавершение.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения
//                - Неопределено - форма, из которой вызывается длительная операция.
//
// Возвращаемое значение:
//  Структура              - параметры выполнения задания: 
//   * ФормаВладелец          - ФормаКлиентскогоПриложения
//                            - Неопределено - форма, из которой вызывается длительная операция.
//   * ТекстСообщения         - Строка - текст сообщения, выводимый на форме ожидания.
//                                       Если не задан, то выводится "Пожалуйста, подождите...".
//   * ВыводитьОкноОжидания   - Булево - если Истина, то открыть окно ожидания с визуальной индикацией длительной операции. 
//                                       Если используется собственный механизм индикации, то следует указать Ложь.
//   * ВыводитьПрогрессВыполнения - Булево - выводить прогресс выполнения в процентах на форме ожидания.
//                                      Процедура-обработчик длительной операции может сообщить о ходе своего выполнения
//                                      с помощью вызова процедуры ДлительныеОперации.СообщитьПрогресс.
//   * ОповещениеОПрогрессеВыполнения - ОписаниеОповещения - оповещение, которое периодически вызывается при 
//                                      проверке готовности фонового задания. Параметры процедуры-обработчика оповещения:
//      # Прогресс - Структура, Неопределено - структура со свойствами или Неопределено, если задание было отменено. Свойства: 
//	     ## Статус               - Строка - "Выполняется", если задание еще не завершилось;
//                                           "Выполнено", если задание было успешно выполнено;
//	                                         "Ошибка", если задание завершено с ошибкой;
//                                           "Отменено", если задание отменено пользователем или администратором.
//	     ## ИдентификаторЗадания - УникальныйИдентификатор - идентификатор запущенного фонового задания.
//	     ## Прогресс             - Структура, Неопределено - результат функции ДлительныеОперации.ПрочитатьПрогресс, 
//                                                            если ВыводитьПрогрессВыполнения = Истина.
//	     ## Сообщения            - ФиксированныйМассив, Неопределено - если ВыводитьСообщения = Истина, массив объектов СообщениеПользователю, 
//                                  очередная порция сообщений, сформированных в процедуре-обработчике длительной операции.
//      # ДополнительныеПараметры - Произвольный - произвольные данные, переданные в описании оповещения. 
//
//   * ВыводитьСообщения      - Булево - выводить в оповещения о завершении и прогресс сообщения, 
//                                       сформированные в процедуре-обработчике длительной операции.
//   * Интервал               - Число  - интервал в секундах между проверками готовности длительной операции.
//                                       По умолчанию 0 - после каждой проверки интервал увеличивается с 1 до 15 секунд
//                                       с коэффициентом 1.4.
//   * ОповещениеПользователя - Структура:
//     ** Показать            - Булево - если Истина, то по завершении длительной операции вывести оповещение пользователя.
//     ** Текст               - Строка - текст оповещения пользователя.
//     ** НавигационнаяСсылка - Строка - навигационная ссылка оповещения пользователя.
//     ** Пояснение           - Строка - пояснение оповещения пользователя.
//   
//   * ПолучатьРезультат - Булево - служебный параметр. Не предназначен для использования.
//
Функция ПараметрыОжидания(ФормаВладелец) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ФормаВладелец", ФормаВладелец);
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("ВыводитьОкноОжидания", Истина);
	Результат.Вставить("ВыводитьПрогрессВыполнения", Ложь);
	Результат.Вставить("ОповещениеОПрогрессеВыполнения", Неопределено);
	Результат.Вставить("ВыводитьСообщения", Ложь);
	Результат.Вставить("Интервал", 0);
	Результат.Вставить("ПолучатьРезультат", Ложь);
	
	ОповещениеПользователя = Новый Структура;
	ОповещениеПользователя.Вставить("Показать", Ложь);
	ОповещениеПользователя.Вставить("Текст", Неопределено);
	ОповещениеПользователя.Вставить("НавигационнаяСсылка", Неопределено);
	ОповещениеПользователя.Вставить("Пояснение", Неопределено);
	Результат.Вставить("ОповещениеПользователя", ОповещениеПользователя);
	
	Возврат Результат;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Заполняет структуру параметров значениями по умолчанию.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется значениями по умолчанию. 
//
// 
Процедура ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	ПараметрыОбработчикаОжидания.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("МаксимальныйИнтервал", 15);
	ПараметрыОбработчикаОжидания.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("КоэффициентУвеличенияИнтервала", 1.4);
	
КонецПроцедуры

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Заполняет структуру параметров новыми расчетными значениями.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется расчетными значениями. 
//
// 
Процедура ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
		
КонецПроцедуры

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Открывает форму-индикатор длительной операции.
// 
// Параметры:
//  ВладелецФормы        - ФормаКлиентскогоПриложения - форма, из которой производится открытие. 
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания.
//
// Возвращаемое значение:
//  ФормаКлиентскогоПриложения     - ссылка на открытую форму.
// 
Функция ОткрытьФормуДлительнойОперации(Знач ВладелецФормы, Знач ИдентификаторЗадания) Экспорт
	
	Возврат ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация",
		Новый Структура("ИдентификаторЗадания", ИдентификаторЗадания), 
		ВладелецФормы);
	
КонецФункции

// Устарела. Следует использовать ОжидатьЗавершение с параметром ПараметрыОжидания.ВыводитьОкноОжидания = Истина.
// Закрывает форму-индикатор длительной операции.
// 
// Параметры:
//  ФормаДлительнойОперации - ФормаКлиентскогоПриложения - ссылка на форму-индикатор длительной операции. 
//
Процедура ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации) Экспорт
	
	Если ТипЗнч(ФормаДлительнойОперации) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если ФормаДлительнойОперации.Открыта() Тогда
			ФормаДлительнойОперации.Закрыть();
		КонецЕсли;
	КонецЕсли;
	ФормаДлительнойОперации = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Структура:
//   * Обработка - Булево
//   * Список - Соответствие
//
Функция АктивныеДлительныеОперации() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.АктивныеДлительныеОперации";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		Операции = Новый Структура("Обработка,Список", Ложь, Новый Соответствие);
		ПараметрыПриложения.Вставить(ИмяПараметра, Операции);
	КонецЕсли;
	Возврат ПараметрыПриложения[ИмяПараметра];

КонецФункции

Процедура ПроверитьПараметрыОжидатьЗавершение(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении, Знач ПараметрыОжидания)
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
		"ДлительнаяОперация", ДлительнаяОперация, Тип("Структура"));
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
			"ОповещениеОЗавершении", ОповещениеОЗавершении, Тип("ОписаниеОповещения"));
	КонецЕсли;
	
	Если ПараметрыОжидания <> Неопределено Тогда
		
		ТипыСвойств = Новый Структура;
		Если ПараметрыОжидания.ФормаВладелец <> Неопределено Тогда
			ТипыСвойств.Вставить("ФормаВладелец", Тип("ФормаКлиентскогоПриложения"));
		КонецЕсли;
		ТипыСвойств.Вставить("ТекстСообщения", Тип("Строка"));
		ТипыСвойств.Вставить("ВыводитьОкноОжидания", Тип("Булево"));
		ТипыСвойств.Вставить("ВыводитьПрогрессВыполнения", Тип("Булево"));
		ТипыСвойств.Вставить("ВыводитьСообщения", Тип("Булево"));
		ТипыСвойств.Вставить("Интервал", Тип("Число"));
		ТипыСвойств.Вставить("ОповещениеПользователя", Тип("Структура"));
		ТипыСвойств.Вставить("ПолучатьРезультат", Тип("Булево"));
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ДлительныеОперацииКлиент.ОжидатьЗавершение",
			"ПараметрыОжидания", ПараметрыОжидания, Тип("Структура"), ТипыСвойств);
		ОбщегоНазначенияКлиентСервер.Проверить(ПараметрыОжидания.Интервал = 0 Или ПараметрыОжидания.Интервал >= 1, 
			НСтр("ru = 'Параметр ПараметрыОжидания.Интервал должен быть больше или равен 1'"),
			"ДлительныеОперацииКлиент.ОжидатьЗавершение");
		ОбщегоНазначенияКлиентСервер.Проверить(Не (ПараметрыОжидания.ОповещениеОПрогрессеВыполнения <> Неопределено И ПараметрыОжидания.ВыводитьОкноОжидания), 
			НСтр("ru = 'Если параметр ПараметрыОжидания.ВыводитьОкноОжидания установлен в Истина, то параметр ПараметрыОжидания.ОповещениеОПрогрессеВыполнения не поддерживается'"),
			"ДлительныеОперацииКлиент.ОжидатьЗавершение");
	КонецЕсли;

КонецПроцедуры

Процедура ПоказатьОповещение(ОповещениеПользователя) Экспорт
	
	Оповещение = ОповещениеПользователя;
	Если Не Оповещение.Показать Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		Оповещение.НавигационнаяСсылка, Оповещение.Пояснение);

КонецПроцедуры

#КонецОбласти
