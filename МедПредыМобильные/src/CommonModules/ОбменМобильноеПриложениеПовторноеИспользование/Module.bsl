#Область СлужебныйПрограммныйИнтерфейс

// Возвращает прокси сервиса обмена данными.
//
// Возвращаемое значение:
// WSПрокси
//
Функция ПолучитьПрокси(СообщениеОбОшибке = "", Адрес = "") Экспорт
	
	Пользователь = СокрЛП(Константы.ПользовательЦентральнойБазы.Получить());
	Пароль = Константы.Пароль.Получить();

	Если Адрес = "" Тогда
		Адрес = Константы.АдресЦентральнойБазы.Получить();
	Иначе
		Пользователь = "";
		Пароль = "";
	КонецЕсли;
	Если ПустаяСтрока(Адрес) Тогда
		Возврат Неопределено;
	Конецесли;
	
	Адрес = СокрЛП(Адрес) + "/ws/MobileService?wsdl";
	
	Попытка
		Определения = Новый WSОпределения(Адрес, Пользователь, Пароль);
		Прокси = Новый WSПрокси(Определения, "http://www.prof-it.ru/ma/MobileExchange", "MobileService", "MobileServiceSoap");
		Прокси.Пользователь = Пользователь;
		Прокси.Пароль = Пароль;
		Возврат Прокси;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Описание = Инфо.Причина.Описание;
		Если Найти(Описание, "При создании описания сервиса произошла ошибка")
			ИЛИ Найти(Описание, "Ошибка HTTP") Тогда
			СообщениеОбОшибке = НСтр("ru='По указанному адресу сервис недоступен.';en='The service is not available.'");
		Иначе
			СообщениеОбОшибке = Инфо.Причина.Описание;
		КонецЕсли;
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции // ПолучитьПрокси()

#КонецОбласти