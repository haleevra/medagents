Функция ЕстьЭлементыПоОтбору(ОтборПоГруппе = Неопределено, ОтборПоНаименованию = "", ОтбиратьГруппы = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(ОтборПоГруппе) Тогда
		ВыборкаСправочника = Справочники.Товары.Выбрать(ОтборПоГруппе);
	Иначе
		ВыборкаСправочника = Справочники.Товары.Выбрать();
	КонецЕсли;
	
	Пока ВыборкаСправочника.Следующий() Цикл
		Если НЕ ВыборкаСправочника.ПометкаУдаления
			И ВыборкаСправочника.ЭтоГруппа = ОтбиратьГруппы
			И (ПустаяСтрока(ОтборПоНаименованию) ИЛИ Найти(НРег(ВыборкаСправочника.Наименование), НРег(ОтборПоНаименованию)) > 0) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьФотоССервера(Товар, СообщениеОбОшибке = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоединениеСЦБУстановлено = ОбщегоНазначенияВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановлено");
	Если НЕ СоединениеСЦБУстановлено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Прокси = ОбменМобильноеПриложениеПовторноеИспользование.ПолучитьПрокси();
	Если Прокси = Неопределено Тогда
		СообщениеОбОшибке = НСтр("ru='Что-то пошло не так. Проверьте настройки подключения к интернету и попробуйте позже.'");
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ДанныеОтвета = Прокси.ПолучитьФотоТовара(Строка(Товар.Ссылка.УникальныйИдентификатор()));
	Исключение
		Инфо = ИнформацияОбОшибке();
		СообщениеОбОшибке = НСтр("ru='Для загрузки необходимо обновить серверную информационную базу. Минимально необходимая версия - 1.6.9.26.';en='You need to update the back-end database. The minimum required version is 1.6.9.26.'");
		Возврат Неопределено;
	КонецПопытки;
	
	//АдресФотоВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(ДанныеОтвета));
	АдресФотоВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеОтвета);
	
	Возврат АдресФотоВоВременномХранилище;
	
КонецФункции