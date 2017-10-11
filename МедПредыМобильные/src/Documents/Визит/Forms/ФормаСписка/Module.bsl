&НаСервере
Процедура УстановитьФильтр(ВидОтбораДляУстановки)
	
	ВидОтбора = ВидОтбораДляУстановки;
	
	Список.Отбор.Элементы[ИндексОтбораВРаботе].Использование = Ложь;
	Список.Отбор.Элементы[ИндексОтбораВыполненные].Использование = Ложь;
	Список.Отбор.Элементы[ИндексОтбораОткрытые].Использование = Ложь;
	Список.Отбор.Элементы[ИндексОтбораПометкаУдаления].Использование = Ложь;
	
	Если ВидОтбора = Перечисления.ФильтрыПоВизиту.ВРаботе Тогда
		Список.Отбор.Элементы[ИндексОтбораВРаботе].Использование = Истина;
		Список.Отбор.Элементы[ИндексОтбораВРаботе].ПравоеЗначение = Перечисления.СостоянияВизитов.ВРаботе;
		Список.Отбор.Элементы[ИндексОтбораПометкаУдаления].Использование = Истина;
	ИначеЕсли ВидОтбора = Перечисления.ФильтрыПоВизиту.Открытые Тогда
		Список.Отбор.Элементы[ИндексОтбораОткрытые].Использование = Истина;
		Список.Отбор.Элементы[ИндексОтбораОткрытые].ПравоеЗначение = Ложь;
		Список.Отбор.Элементы[ИндексОтбораПометкаУдаления].Использование = Истина;
	ИначеЕсли ВидОтбора = Перечисления.ФильтрыПоВизиту.Выполненные Тогда
		Список.Отбор.Элементы[ИндексОтбораВыполненные].Использование = Истина;
		Список.Отбор.Элементы[ИндексОтбораВыполненные].ПравоеЗначение = Перечисления.СостоянияВизитов.Выполнен;
		Список.Отбор.Элементы[ИндексОтбораПометкаУдаления].Использование = Истина;
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
	Элементы.ФормаОтменитьФильтр.Доступность = ЗначениеЗаполнено(ВидОтбора);
	СохранитьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	Константы.ФильтрПоВизиту.Установить(ВидОтбора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если ЗначениеЗаполнено(ВидОтбора) Тогда
		Заголовок = НСтр("ru='Визиты (';en='Visits ('") + ВидОтбора + ")";
	Иначе
		Заголовок = НСтр("ru='Визиты';en='Visits'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Незавершенные(Команда)
	
	УстановитьФильтр(ПредопределенноеЗначение("Перечисление.ФильтрыПоВизиту.ВРаботе"));
	
КонецПроцедуры

&НаКлиенте
Процедура Открытые(Команда)
	
	УстановитьФильтр(ПредопределенноеЗначение("Перечисление.ФильтрыПоВизиту.Открытые"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФильтр(Команда)
	
	УстановитьФильтр("");
	
КонецПроцедуры

&НаКлиенте
Процедура Выполненные(Команда)
	
	УстановитьФильтр(ПредопределенноеЗначение("Перечисление.ФильтрыПоВизиту.Выполненные"));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидОтбора = Константы.ФильтрПоВизиту.Получить();
	
	// Предустановка отборов на список.
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("СостояниеВизита");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ИндексОтбораВРаботе = Список.Отбор.Элементы.Индекс(ЭлементОтбора);
		
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение   = Ложь;
	ИндексОтбораПометкаУдаления = Список.Отбор.Элементы.Индекс(ЭлементОтбора);
	
	Список.Параметры.УстановитьЗначениеПараметра("СимволНомера", НСтр("ru='№ ';en='# '"));
	УстановитьФильтр(ВидОтбора);
	
	Если Константы.ПрофильМобильногоПриложения.Получить() = Перечисления.ПрофилиМобильногоПриложения.МедПредставитель Тогда
		Элементы.Ответственный.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	
	ОбменМобильноеПриложениеФоновыеЗадания.ВыполнениеОбменаПриОбновленииСписка();
	Оповестить("ПрошелОбмен");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПрошелОбмен" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	ПерейтиПоНавигационнойСсылке("http://server.prof-it.ru/redmine/projects/dfgwiki/wiki/Wiki");
	
КонецПроцедуры

