&НаКлиенте
Перем КэшНайденныхКонтактов;

#Область ОбщегоНазначения

&НаКлиенте
Процедура ПозвонитьОтправитьСМС(Схема)
	
	Если ЗначениеЗаполнено(Объект.НомерТелефона) Тогда
		ЗапуститьПриложение(Схема + СокрЛП(Объект.НомерТелефона));
	Иначе
		Предупреждение(НСтр("ru='Вначале укажите телефон!';en='First, specify the telephone!'"));
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	ОбщегоНазначенияСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("en='Counterparty';ru='Контрагент'"));
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура Позвонить(Команда)
	
	ПозвонитьОтправитьСМС("tel:");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСМС(Команда)
	
	ПозвонитьОтправитьСМС("sms:");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЭлектронноеПисьмо(Команда)
	
	Если ЗначениеЗаполнено(Объект.АдресЭП) Тогда
		ЗапуститьПриложение("mailto:"+СокрЛП(Объект.АдресЭП));
	Иначе
		Предупреждение(НСтр("ru='Вначале укажите Email!';en='First, specify the Email!'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерКонтактовКлиент.ЗаполнитьСписокВыбораИзКонтактнойКниги(
		Текст,
		ДанныеВыбора,
		СтандартнаяОбработка,
		КэшНайденныхКонтактов,
		Ложь
	);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	#Если МобильноеПриложениеКлиент Тогда
		//ИспользоватьСинхронизациюСКонтактнойКнигой = ОбщегоНазначенияВызовСервера.ПолучитьЗначениеКонстанты("ИспользоватьСинхронизациюСКонтактнойКнигой");
		ИспользоватьСинхронизациюСКонтактнойКнигой = Истина;
		Если НЕ ИспользоватьСинхронизациюСКонтактнойКнигой Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
			СтандартнаяОбработка = Ложь;
			МенеджерКонтактовКлиент.ЗаполнитьРеквизитыКонтрагента(Объект, ВыбранноеЗначение);
		КонецЕсли;
		КэшНайденныхКонтактов = Неопределено;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНаКартеКоманда(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда
	Если ОбщегоНазначенияВызовСервера.ВерсияОС() = "iOS" Тогда
		ПерейтиПоНавигационнойСсылке("http://maps.apple.com/?q=" + ОбщегоНазначенияВызовСервера.Кодировать(Объект.Адрес));
	Иначе
		Запуск = Новый ЗапускПриложенияМобильногоУстройства();
		Запуск.Действие = "android.intent.action.VIEW";
		Запуск.Данные = "geo:0,0?q=" + Объект.Адрес;
		Запуск.Запустить(Ложь);
	КонецЕсли;
	#Иначе
	ПерейтиПоНавигационнойСсылке("https://maps.yandex.ru/?text=" + Объект.Адрес);
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("en='Counterparty';ru='Контрагент'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	//!
	ПерейтиПоНавигационнойСсылке("http://server.prof-it.ru/redmine/projects/dfgwiki/wiki/Wiki");
	
КонецПроцедуры

#КонецОбласти
