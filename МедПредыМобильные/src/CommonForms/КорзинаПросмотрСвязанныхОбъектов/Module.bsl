
#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Функция ЭтоСправочник(Ссылка)
	
	Если Ссылка <> неопределено И
		Метаданные.Справочники.Содержит(Метаданные.НайтиПоТипу(ТипЗнч(Ссылка))) Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЭтоДокумент(Ссылка)
	
	Если Метаданные.Документы.Содержит(Метаданные.НайтиПоТипу(ТипЗнч(Ссылка))) Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеНомера(Знач НомерОбъекта)

	// Удаляем все символы, не являющиеся цифрами.
	СтрокаЦифровыхСимволов = "0123456789";
	Номер = "";
	Для Индекс = 1 По СтрДлина(НомерОбъекта) Цикл
		Символ = Сред(НомерОбъекта, Индекс, 1);
		Если Найти(СтрокаЦифровыхСимволов, Символ) > 0 Тогда
			Номер = Номер + Символ;
		КонецЕсли;
	КонецЦикла;
	
	// Удаляем незначащие нули.
	Пока Лев(Номер, 1)= "0" Цикл
		Номер = Сред(Номер, 2);
	КонецЦикла;
	
	Возврат Номер;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеОбъекта(Ссылка)
	
	ПредставлениеОбъекта = Новый Структура("Представление, Дополнение", "", "");
	
	Если ЭтоСправочник(Ссылка) Тогда 
		ПредставлениеОбъекта.Представление = Ссылка.Наименование;
		ПредставлениеОбъекта.Дополнение = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним;
	ИначеЕсли ЭтоДокумент(Ссылка) Тогда 
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.Визит") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = 
				Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним +
				НСтр("ru=' №';en=' No.'") + ПолучитьПредставлениеНомера(Ссылка.Номер) + 
				НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходДенег") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходТовара") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Поставщик;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходДенег") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходТовара") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПредставлениеОбъекта;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Объект") И Параметры.Свойство("СвязанныеОбъекты") Тогда 
		ЭтаФорма.Объект = Параметры.Объект;
		ПредставлениеОбъекта = ПолучитьПредставлениеОбъекта(Объект);
		ЭтаФорма.Представление = ПредставлениеОбъекта.Представление;
		ЭтаФорма.Дополнение = ПредставлениеОбъекта.Дополнение;
		ЭтаФорма.СвязанныеОбъекты.Загрузить(Параметры.СвязанныеОбъекты.Выгрузить());
	КонецЕсли;
	
	Для Каждого СвязанныйОбъект Из ЭтаФорма.СвязанныеОбъекты Цикл 
		ПредставлениеОбъекта = ПолучитьПредставлениеОбъекта(СвязанныйОбъект.Ссылка);
		СвязанныйОбъект.Представление = ПредставлениеОбъекта.Представление;
		СвязанныйОбъект.Дополнение = ПредставлениеОбъекта.Дополнение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПрепятствующиеУдалениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбранныйОбъект = Элемент.ТекущиеДанные.Ссылка;
	ОткрытьЗначение(ВыбранныйОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("КорзинаПросмотрСвязанныхОбъектовЗакрытие");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	ОткрытьЗначение(Объект);
	
КонецПроцедуры

#КонецОбласти