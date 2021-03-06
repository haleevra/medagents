#Область СлужебныйПрограммныйИнтерфейс

// Возвращает результат проверки завершения обмена.
//
функция РезультатПроверкиЗавершенияОбмена(УИДФоновогоЗаданияОбмена) Экспорт
	
	СтруктураВозврата = Новый Структура("ОбменЗавершен, ЕстьОшибки", Истина, Ложь);
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(УИДФоновогоЗаданияОбмена);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		
		СтруктураВозврата.ОбменЗавершен = Истина;
		
	Иначе
		
		Если Задание = Неопределено 
			ИЛИ Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно 
			ИЛИ Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			СтруктураВозврата.ЕстьОшибки = Истина;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			СтруктураВозврата.ОбменЗавершен = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции // РезультатПроверкиЗавершенияОбмена()

// Отправляет идетификатор подписчика на сервер в фоне.
//
Процедура ОтправитьИДПодписчикаНаСерверВФоне(ИДПодписчика) Экспорт
	
	Параметры = Новый Массив();
	Параметры.Добавить(ИДПодписчика);
	Параметры.Добавить(Истина);
	
	ФоновыеЗадания.Выполнить(
		"ОбменМобильноеПриложениеФоновыеЗадания.ОтправитьИДПодписчикаНаСервер",
		Параметры,
		Новый УникальныйИдентификатор,
		"ОтправкаИдентификатора"
	);
	
Конецпроцедуры // ОтправитьИДПодписчикаНаСерверВФоне()

// Отправляет идетификатор подписчика на сервер.
//
Процедура ОтправитьИДПодписчикаНаСервер(ИДПодписчикаУведомлений, ВыполнитьОбмен) Экспорт
	
	Результат = ОтправитьИДПодписчика(ИДПодписчикаУведомлений);
	Если НЕ Результат.Отказ Тогда
		ОбщегоНазначенияВызовСервера.УстановитьЗначениеКонстанты("ИДПодписчика", ИДПодписчикаУведомлений);
	КонецЕсли;
	
	Если ВыполнитьОбмен Тогда
		ОбменМобильноеПриложениеФоновыеЗадания.ВыполнениеОбмена();
	КонецЕсли;
	
КонецПроцедуры // ОтправитьИДПодписчикаНаСервер()

// Отправляет идентификатор подписчика.
//
Функция ОтправитьИДПодписчика(ИДПодписчика) Экспорт
	
	СтруктураОтвета = Новый Структура("Отказ, ИнформацияОбОшибке", Ложь, "");
	
	// 1. Подключаемся к базе
	ПараметрыОбмена = ОбменМобильноеПриложениеСервер.НачатьОбменДанными();
	
	Если НЕ ПараметрыОбмена.ОбменРазрешен Тогда
		СтруктураОтвета.Отказ = Истина;
		СтруктураОтвета.ИнформацияОбОшибке = ПараметрыОбмена.СообщениеОбОшибке;
		Возврат СтруктураОтвета;
	КонецЕсли;
	
	// 2. Отправляем новый идентификатор подписчика
	Попытка
		Если ИДПодписчика = Неопределено Тогда
			ИДПодписчикаXDTO = Неопределено;
		Иначе
			ИДПодписчикаXDTO = СериализаторXDTO.ЗаписатьXDTO(ИДПодписчика);
		КонецЕсли;
		СтруктураОтветаСервера = ПараметрыОбмена.Прокси.ЗарегистрироватьИДПодписчика(
		ИДПодписчикаXDTO,
		ПараметрыОбмена.КодМобильногоКомпьютера,
		ПараметрыОбмена.НаименованиеУстройства,
		Константы.Сценарий.Получить()
		);
		Если ЗначениеЗаполнено(СтруктураОтветаСервера) Тогда
			СтруктураОтвета.Отказ = Истина;
			СтруктураОтвета.ИнформацияОбОшибке = СтруктураОтветаСервера;
		КонецЕсли;
		
	Исключение
		СтруктураОтвета.Отказ = Истина;
		СтруктураОтвета.ИнформацияОбОшибке = ОписаниеОшибки();
		Возврат СтруктураОтвета;
	КонецПопытки;
	
	Возврат СтруктураОтвета;
	
КонецФункции

// Синхронизирует данные.
//
Процедура СинхронизироватьДанные() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ЗапуститьОбменПовторно.Установить(Ложь);
	Константы.ОбменВыполняется.Установить(Истина);
	
	ПараметрыОбмена = ОбменМобильноеПриложениеСервер.НачатьОбменДанными();
	
	Если ПараметрыОбмена.ОбменРазрешен Тогда
		ПродолжатьОбмен = Истина;
		Пока ПродолжатьОбмен Цикл
			ВыполнитьШагОбменаДанными(ПараметрыОбмена);
			Если ПараметрыОбмена.ОбменЗавершен
				ИЛИ ПараметрыОбмена.ЕстьОшибки Тогда
				ПродолжатьОбмен = Ложь;
			КонецЕсли;
		КонецЦикла;
	Конецесли;
	
	Константы.ОбменВыполняется.Установить(Ложь);
	Константы.ОповеститьОВыполненииОбмена.Установить(Истина);
	
	Если Константы.ЗапуститьОбменПовторно.Получить() Тогда
		ВыполнениеОбмена();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // СинхронизироватьДанные()

// Установка констант по умолчанию при старте.
//
Процедура УстановитьКонстантыПриСтарте() Экспорт
	
	Константы.ОбменВыполняется.Установить(Ложь);
	Константы.ЗапуститьОбменПовторно.Установить(Ложь);
	Константы.ОповеститьОВыполненииОбмена.Установить(Ложь);
	Константы.ПерезапуститьПриложение.Установить(Ложь);
	
КонецПроцедуры // УстановитьКонстантыПриСтарте()

// Выполняет очередной шаг обмена данными.
//
Процедура ВыполнитьШагОбменаДанными(ПараметрыОбмена)
	
	СообщениеОбОшибке = "";
	
	Если НЕ ПараметрыОбмена.ОбменЗавершенОтправкаДанных Тогда
		
		ОбменМобильноеПриложениеСервер.ОтправитьДанные(ПараметрыОбмена);
		
		Если ПараметрыОбмена.ЕстьОшибки Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыОбмена.ОжиданиеСообщенияОбмена = Ложь;
		
	ИначеЕсли НЕ ПараметрыОбмена.ОбменЗавершенЗагрузкаДанных Тогда
		
		ОбменМобильноеПриложениеСервер.ПолучитьДанные(ПараметрыОбмена);
		Если ПараметрыОбмена.ЕстьОшибки
			ИЛИ ПараметрыОбмена.ОжиданиеСообщенияОбмена Тогда
			Возврат;
		КонецЕсли;
		
		ОбменМобильноеПриложениеСервер.ЗагрузитьДанные(ПараметрыОбмена);
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьШагОбменаДанными()

// Подписка на событие при записи документов.
//
Процедура ВыполнениеОбменаПриЗаписиПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ЗапретитьПовторныйЗапускОбмена")
		И Источник.ДополнительныеСвойства.ЗапретитьПовторныйЗапускОбмена Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнениеОбмена();
	
КонецПроцедуры // ВыполнениеОбменаПриЗаписиПриЗаписи()

// Выполняет обмен.
//
Функция ВыполнениеОбмена() Экспорт
	
	Если НЕ Константы.СоединениеСЦБУстановлено.Получить() Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Истина);
	Если Константы.ОбменВыполняется.Получить() Тогда
		Константы.ЗапуститьОбменПовторно.Установить(Истина);
	Иначе
		Константы.ОбменВыполняется.Установить(Истина);
		Задание = ФоновыеЗадания.Выполнить(
		"ОбменМобильноеПриложениеФоновыеЗадания.СинхронизироватьДанные",
		,
		Новый УникальныйИдентификатор,
		"Обмен"
		);
		Возврат Задание.УникальныйИдентификатор;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Неопределено;
	
КонецФункции // ВыполнениеОбмена()

// Выполнение обмена при обновлении списка.
//
Процедура ВыполнениеОбменаПриОбновленииСписка() Экспорт
	
	Если НЕ Константы.СоединениеСЦБУстановлено.Получить() Тогда
		Возврат;
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Константы.ОбменВыполняется.Получить() Тогда
		ОбменМобильноеПриложениеФоновыеЗадания.СинхронизироватьДанные();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // ВыполнениеОбменаПриОбновленииСписка()

#КонецОбласти




