////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ ОБЩИЕ МЕТОДЫ РАБОТЫ С БД
// - установка параметров сеанса
// - установка шрифтов и размеров элементов форм
// - обработка запуска приложения
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет необходимые действия перед запуском приложения.
//
Процедура ОбновитьПриложение() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ВерсияПриложенияДоОбновления = Константы.ТекущаяВерсияПриложения.Получить();
	НоваяВерсияПриложения = Метаданные.Версия;
	Если НЕ ЗначениеЗаполнено(ВерсияПриложенияДоОбновления) Тогда
		ПервыйЗапуск();
	КонецЕсли;
	Если ВерсияПриложенияДоОбновления <> НоваяВерсияПриложения Тогда
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("1.0.1.1", ВерсияПриложенияДоОбновления) > 0 Тогда
		КонецЕсли;
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("1.0.1.37", ВерсияПриложенияДоОбновления) > 0 Тогда
		КонецЕсли;
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("1.0.1.38", ВерсияПриложенияДоОбновления) > 0 Тогда
			// для оптимизации визуализации визитов введен новый реквизит, заполняем его
			Счетчик = 0;
			Визиты = Документы.Визит.Выбрать();
			Пока Визиты.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(Визиты.Операция) Тогда
					ОбъектВизита = Визиты.ПолучитьОбъект();
					ОбъектВизита.Операция = ?(ЗначениеЗаполнено(ОбъектВизита.Оценка),
												Перечисления.ПрофилиМобильногоПриложения.Супервайзер,
												Перечисления.ПрофилиМобильногоПриложения.Супервайзер);
					ОбъектВизита.Записать();
					Счетчик=Счетчик+1;
				КонецЕсли;
			КонецЦикла;
			Сообщить("Выполнено обновление на версию "+"1.0.1.38"+Символы.ПС+
					 "Обновлено "+Формат(Счетчик) + " визитов.");
		КонецЕсли;
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("1.0.1.38", ВерсияПриложенияДоОбновления) > 0 Тогда
			// установим период выгрузки месяц
			Константы.ПериодЗагрузки.Установить(Перечисления.ПериодыВыгрузкиВМобильноеПриложение.ЗаПоследнийМесяц);
			// для оптимизации быстродействия будут удалены данные визитов и мероприятий прошлого месяца
			Счетчик = 0;
			Визиты = Документы.Визит.Выбрать();
			Пока Визиты.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(Визиты.Операция) Тогда
					ОбъектВизита = Визиты.ПолучитьОбъект();
					ОбъектВизита.Операция = ?(ЗначениеЗаполнено(ОбъектВизита.Оценка),
												Перечисления.ПрофилиМобильногоПриложения.Супервайзер,
												Перечисления.ПрофилиМобильногоПриложения.Супервайзер);
					ОбъектВизита.Записать();
					Счетчик=Счетчик+1;
				КонецЕсли;
			КонецЦикла;
			Сообщить("Выполнено обновление на версию "+"1.0.1.38"+Символы.ПС+
					 "Обновлено "+Формат(Счетчик) + " визитов.");
		КонецЕсли;
		Константы.ТекущаяВерсияПриложения.Установить(НоваяВерсияПриложения);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // ОбновитьПриложение()

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ПервыйЗапуск()
		
КонецПроцедуры

//Процедура ЗаполнитьЗначенияКонстантРежимаРаботы()
//	
//	Попытка
//		
//		ЕстьДанныеВБазе = Ложь;
//		
//		ВыборкаПлановОбмена = ПланыОбмена.МобильноеПриложение.Выбрать();
//		ВыборкаПлановОбмена.Следующий();
//		Если ВыборкаПлановОбмена.Следующий() Тогда
//			Если ЗначениеЗаполнено(Константы.АдресЦентральнойБазы.Получить()) Тогда
//				Константы.СоединениеСЦБУстановлено.Установить(Истина);
//			КонецЕсли;
//			ЕстьДанныеВБазе = Истина;
//		КонецЕсли;
//		
//		Если Константы.ИспользоватьСинхронизациюДанных.Получить() Тогда
//			ЕстьДанныеВБазе = Истина;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Справочники.Контрагенты.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Справочники.Статьи.Выбрать();
//			ВыборкаОбъектов.Следующий();
//			ВыборкаОбъектов.Следующий();
//			ВыборкаОбъектов.Следующий();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Справочники.Товары.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.ВводОстатков.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.Визит.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.ПриходДенег.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.ПриходТовара.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.РасходДенег.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если НЕ ЕстьДанныеВБазе Тогда
//			ВыборкаОбъектов = Документы.РасходТовара.Выбрать();
//			Если ВыборкаОбъектов.Следующий() Тогда
//				ЕстьДанныеВБазе = Истина;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если ЕстьДанныеВБазе Тогда
//			Константы.РежимРаботыВыбран.Установить(Истина);
//		КонецЕсли;
//	
//	Исключение
//	КонецПопытки;
//	
//КонецПроцедуры

//Процедура УстановитьКонстантуРежимРаботыПриложения()
//	
//	Попытка
//		Если Константы.ИспользоватьСинхронизациюДанных.Получить() Тогда
//			Константы.РежимРаботыПриложения.Установить(Перечисления.РежимыРаботыПриложения.Многопользовательский);
//		Иначе
//			Константы.РежимРаботыПриложения.Установить(Перечисления.РежимыРаботыПриложения.Автономный);
//		КонецЕсли;
//	Исключение
//	КонецПопытки;
//	
//КонецПроцедуры

#КонецОбласти
