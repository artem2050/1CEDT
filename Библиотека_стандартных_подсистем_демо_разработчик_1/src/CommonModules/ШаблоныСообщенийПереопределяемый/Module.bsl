///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет состав назначений и общие реквизиты в шаблонах сообщений 
//
// Параметры:
//  Настройки - Структура:
//    * ПредметыШаблонов - ТаблицаЗначений - содержит варианты предметов для шаблонов. Колонки:
//         ** Имя           - Строка - уникальное имя назначения.
//         ** Представление - Строка - представление варианта.
//         ** Макет         - Строка - имя макета СКД, если состав реквизитов определяется посредством СКД.
//         ** ЗначенияПараметровСКД - Структура - значения параметров СКД для текущего предмета шаблона сообщения.
//    * ОбщиеРеквизиты - ДеревоЗначений - содержит описание общих реквизитов доступных во всех шаблонах. Колонки:
//         ** Имя            - Строка - уникальное имя общего реквизита.
//         ** Представление  - Строка - представление общего реквизита.
//         ** Тип            - Тип    - тип общего реквизита. По умолчанию строка.
//    * ИспользоватьПроизвольныеПараметры  - Булево - указывает, можно ли использовать произвольные пользовательские
//                                                    параметры в шаблонах сообщений.
//    * ЗначенияПараметровСКД - Структура - общие значения параметров СКД, для всех макетов, где состав реквизитов
//                                          определяется средствами СКД.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	// _Демо начало примера
	Настройки.ИспользоватьПроизвольныеПараметры = Истина;
	Настройки.ЗначенияПараметровСКД.Вставить("ОбращениеМужскойРод", НСтр("ru = 'Уважаемый'"));
	Настройки.ЗначенияПараметровСКД.Вставить("ОбращениеЖенскийРод", НСтр("ru = 'Уважаемая'"));
	
	// Определение шаблонов
	Предмет = Настройки.ПредметыШаблонов.Добавить();
	Предмет.Имя = "ОповещениеКлиентаИзменениеЗаказа";
	Предмет.Представление = НСтр("ru = 'Оповещение клиента ""Изменение заказа""'");
	Предмет.Макет = "ДанныеШаблонаСообщений";
	Предмет = Настройки.ПредметыШаблонов.Найти("ОповещениеКлиентаИзменениеЗаказа", "Имя");
	Предмет.ЗначенияПараметровСКД.Вставить("ОбращениеПолНеопределен", НСтр("ru = 'Уважаемый(ая)'"));
	
	Предмет = Настройки.ПредметыШаблонов.Найти(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя(), "Имя");
	Предмет.ЗначенияПараметровСКД.Вставить("ОбращениеПолНеопределен", НСтр("ru = 'Уважаемый(ая)'"));
	
	// Определение общих реквизитов для всех шаблонов
	НовыйРеквизит = Настройки.ОбщиеРеквизиты.Строки.Добавить();
	НовыйРеквизит.Имя = "ОбратныйАдрес";
	НовыйРеквизит.Представление = НСтр("ru = 'Обратный адрес'");
	НовыйРеквизит.Тип = Тип("Строка");
	
	НовыйРеквизит = Настройки.ОбщиеРеквизиты.Строки.Добавить();
	НовыйРеквизит.Имя = "ОсновнаяОрганизация";
	НовыйРеквизит.Представление = НСтр("ru = 'Основная организация'");
	НовыйРеквизит.Тип = Тип("СправочникСсылка._ДемоОрганизации");
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты - ДеревоЗначений - список реквизитов шаблона:
//    * Имя            - Строка - уникальное имя реквизита.
//    * Представление  - Строка - представление реквизита.
//    * Тип            - Тип    - тип реквизита.
//    * Подсказка      - Строка - расширенная информация о реквизите.
//    * Формат         - Строка - формат вывода значения для чисел, дат, строк и булевых значений. 
//                                Например, "ДЛФ=D" для даты.
//  Вложения - ТаблицаЗначений - печатные формы и вложения, где:
//    * Имя           - Строка - уникальное имя вложения.
//    * Идентификатор - Строка - идентификатор вложения.
//    * Представление - Строка - представление варианта.
//    * Подсказка     - Строка - расширенная информация о вложении.
//    * ТипФайла      - Строка - тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  НазначениеШаблона       - Строка  - назначение шаблона сообщения, например, "ОповещениеКлиентаИзменениеЗаказа".
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщения.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	
	// _Демо начало примера
	Если НазначениеШаблона = "Документ._ДемоСчетНаОплатуПокупателю" Тогда
		ДополнительныеПараметры.РазворачиватьСсылочныеРеквизиты = Ложь;
	КонецЕсли;
	
	Если НазначениеШаблона = "Документ._ДемоСчетНаОплатуПокупателю"
		ИЛИ НазначениеШаблона = "Документ._ДемоЗаказПокупателя" Тогда
		Если ДополнительныеПараметры.ТипШаблона = "Письмо" Тогда
			НовыйРеквизит = Реквизиты.Добавить();
			НовыйРеквизит.Имя = "КнопкаДляОплатыЯндексКасса";
			НовыйРеквизит.Представление = НСтр("ru = 'Кнопка для оплаты Яндекс.Касса'");
			Если ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
				КартинкаКнопки = Вложения.Добавить();
				КартинкаКнопки.Идентификатор = "КартинкаКнопкиДляОплатыЯндексКасса";
				КартинкаКнопки.Имя = "КартинкаКнопкиДляОплатыЯндексКасса";
				КартинкаКнопки.Представление = НСтр("ru = 'Кнопка для оплаты Яндекс.Касса'");
				КартинкаКнопки.ТипФайла = "jpg";
				КартинкаКнопки.Реквизит = "КнопкаДляОплатыЯндексКасса";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НазначениеШаблона = "ОповещениеКлиентаИзменениеЗаказа" Тогда
		ШаблоныСообщений.СформироватьСписокРеквизитовПоСКД(Реквизиты, Документы._ДемоЗаказПокупателя.ПолучитьМакет("ДанныеШаблонаСообщений"));
		
		Реквизит = Реквизиты.Найти("ОповещениеКлиентаИзменениеЗаказа.Дата");
		Реквизит.Формат = "ДЛФ=D";
	КонецЕсли;
	
	// _Демо конец примера

КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура:
//    * ЗначенияРеквизитов - Соответствие из КлючИЗначение - список используемых в шаблоне реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие из КлючИЗначение - список используемых в шаблоне общих реквизитов:
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие из КлючИЗначение:
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные
//                  - Строка - двоичные данные или адрес во временном хранилище вложения.
//    * ДополнительныеПараметры - Структура - дополнительные параметры сообщения. 
//  НазначениеШаблона - Строка -  полное имя назначения шаблон сообщения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ПараметрыШаблона - Структура -  дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
	// _Демо начало примера
	Если Сообщение.ЗначенияОбщихРеквизитов["ОбратныйАдрес"] <> Неопределено Тогда
		Сообщение.ЗначенияОбщихРеквизитов["ОбратныйАдрес"] = "admin@admin.ru";
	КонецЕсли;
	
	Если Сообщение.ЗначенияОбщихРеквизитов["ОсновнаяОрганизация"] <> Неопределено Тогда
		ОсновнаяОрганизация = Константы._ДемоОсновнаяОрганизация.Получить();
		Сообщение.ЗначенияОбщихРеквизитов["ОсновнаяОрганизация"] = ОсновнаяОрганизация.Наименование;
	КонецЕсли;
	
	Если ПараметрыШаблона.ТипШаблона = "Письмо"
		И (НазначениеШаблона = "Документ._ДемоСчетНаОплатуПокупателю"
		ИЛИ НазначениеШаблона = "Документ._ДемоЗаказПокупателя") Тогда
			Ссылка = "www.oplata.1c?order=" + XMLСтрока(ПредметСообщения.Номер);
			Если ПараметрыШаблона.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
				Если Сообщение.ЗначенияРеквизитов["КнопкаДляОплатыЯндексКасса"] <> Неопределено Тогда 
					Если Сообщение.Вложения["КнопкаДляОплатыЯндексКасса"] = Неопределено Тогда
						HTMLТекстКнопки = "<a href='" + Ссылка + "'><img src=""cid:КнопкаДляОплатыЯндексКасса""> Оплатить онлайн</a>";
						АдресКартинки = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.Информация32.ПолучитьДвоичныеДанные());
						Сообщение.Вложения["КнопкаДляОплатыЯндексКасса"] = АдресКартинки;
					Иначе
						HTMLТекстКнопки = "<a href='" + Ссылка + "'><img src=""cid:КнопкаДляОплатыЯндексКасса""></a>";
					КонецЕсли;
					Сообщение.ЗначенияРеквизитов["КнопкаДляОплатыЯндексКасса"] = HTMLТекстКнопки;
				КонецЕсли;
			Иначе
				Сообщение.ЗначенияРеквизитов["КнопкаДляОплатыЯндексКасса"] = НСтр("ru = 'Оплатить счет:'") + Символы.ПС + Ссылка;
			КонецЕсли;
		КонецЕсли;
	
	Если НазначениеШаблона = "ОповещениеКлиентаИзменениеЗаказа" Тогда
		ШаблоныСообщений.ЗаполнитьРеквизитыПоСКД(Сообщение.ЗначенияРеквизитов, ПредметСообщения, ПараметрыШаблона);
		Если ТипЗнч(Сообщение.ЗначенияРеквизитов[НазначениеШаблона]) = Тип("Соответствие") Тогда
			Сообщение.ЗначенияРеквизитов[НазначениеШаблона]["СуммаДокумента"] = ПредметСообщения.СуммаДокумента;
		КонецЕсли;
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений:
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS;
//     * Представление - Строка - представление получателя сообщения SMS;
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, НазначениеШаблона, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей почты при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма:
//     * Адрес           - Строка - адрес электронной почты получателя;
//     * Представление   - Строка - представление получателя письма;
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект, являющийся источником данных.
//                   - Структура  - структура описывающая параметры шаблона:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ВидСообщения - Строка - вид формируемого сообщения: "ЭлектроннаяПочта" или "СообщениеSMS";
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров;
//    * ОтправитьСразу - Булево - признак мгновенной отправки письма;
//    * ПараметрыСообщения - Структура - дополнительные параметры сообщения;
//    * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - признак преобразование HTML текста
//             сообщения содержащего картинки в тексте письма из-за особенностей вывода изображений
//             в форматированном документе;
//    * УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись для отправки письма.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт
	
	// _Демо начало примера
	Если НазначениеШаблона = "ОповещениеКлиентаИзменениеЗаказа" Тогда
		Предмет = ?(ТипЗнч(ПредметСообщения) = Тип("Структура"), ПредметСообщения.Предмет, ПредметСообщения);
		СписокПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Предмет.ЭлектроннаяПочтаСтрокой);
		Для каждого Получатель Из СписокПолучателей Цикл
			Если ПустаяСтрока(Получатель.ОписаниеОшибки) Тогда
				НовыйПолучатель               = ПолучателиПисьма.Добавить();
				НовыйПолучатель.Адрес         = Получатель.Адрес;
				НовыйПолучатель.Представление = Получатель.Псевдоним;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти

