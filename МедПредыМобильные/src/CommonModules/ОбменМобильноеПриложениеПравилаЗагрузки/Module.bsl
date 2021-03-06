#Область СлужебныйПрограммныйИнтерфейс

// Процедура загружает объекты в информационную базу.
//
Процедура ЗагрузитьОбъекты(УзелОбмена, Прокси, КоличествоЗаписанных, ПерезапуститьПриложение) Экспорт
	
	ДокументыДляОтложенногоПроведения = Новый Массив;
	ДокументыДляОтложеннойОбработки = Новый Массив;
	ОбъектXDTOОстатки = Неопределено;
	
	НачатьТранзакцию();
	
	ТипОбъектаXDTO = Прокси.ФабрикаXDTO.Тип("http://www.prof-it.ru/ma/MobileExchange", "Объекты");
	ЧтениеXML = Новый ЧтениеXML;
	
	ВыборкаСообщенийОбмена = РегистрыСведений.ОчередьСообщенийОбмена.Выбрать(, "НомерСообщения Возр");
		
	Пока ВыборкаСообщенийОбмена.Следующий() Цикл
		
		ЧтениеXML.УстановитьСтроку(ВыборкаСообщенийОбмена.СообщениеОбмена.Получить());
		ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
		ЧтениеСообщения.НачатьЧтение(ЧтениеXML);
		
		Объекты = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаXDTO);
		
		Если Объекты <> Неопределено Тогда
			Для каждого ОбъектXDTO Из Объекты.объекты Цикл
				НайтиСоздатьОбъектПоXDTO(ОбъектXDTO, УзелОбмена, КоличествоЗаписанных, ОбъектXDTOОстатки, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки, ПерезапуститьПриложение)
			КонецЦикла;
		КонецЕсли;
		
		ЧтениеСообщения.ЗакончитьЧтение();
		ЧтениеXML.Закрыть();
		
		ОбменМобильноеПриложениеВызовСервера.УдалитьСообщениеОбменаИзОчереди(ВыборкаСообщенийОбмена.НомерСообщения);
		
	КонецЦикла;
	
	ОбменМобильноеПриложениеВызовСервера.ВыполнитьОтложенноеПроведениеДокументов(УзелОбмена, ДокументыДляОтложенногоПроведения);
	ОбменМобильноеПриложениеВызовСервера.ВыполнитьОтложеннуюОбработкуДокументов(УзелОбмена, ДокументыДляОтложеннойОбработки);
		
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры // ЗагрузитьОбъекты()

#КонецОбласти

#Область СправочникиИДокументы

Функция НайтиСоздатьОбъектПоXDTO(ОбъектXDTO, УзелОбмена, КоличествоЗаписанных, ОбъектXDTOОстатки = Неопределено, ДокументыДляОтложенногоПроведения = Неопределено, ДокументыДляОтложеннойОбработки = Неопределено, ПерезапуститьПриложение = Ложь)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	СсылкаНаОбъект = Неопределено;
	
	Если ОбъектXDTO.Тип().Имя = "Настройки" Тогда
		СсылкаНаОбъект = НайтиСоздатьНастройки(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "Контрагенты" Тогда
		СсылкаНаОбъект = НайтиСоздатьКонтрагенты(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "КонтактныеЛица" Тогда
		СсылкаНаОбъект = НайтиСоздатьКонтактныеЛица(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "Товары" Тогда
		СсылкаНаОбъект = НайтиСоздатьТовары(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "СпециализацияВрача" Тогда
		СсылкаНаОбъект = НайтиСоздатьСпециализацияВрача(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "Проекты" Тогда
		СсылкаНаОбъект = НайтиСоздатьПроекты(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "ВидыМероприятий" Тогда
		СсылкаНаОбъект = НайтиСоздатьВидыМероприятий(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "Визиты" Тогда
		СсылкаНаОбъект = НайтиСоздатьВизит(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "Мероприятия" Тогда
		СсылкаНаОбъект = НайтиСоздатьМероприятие(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки);
	ИначеЕсли ОбъектXDTO.Тип().Имя = "УдалениеОбъекта" Тогда
		ПометитьОбъектНаУдаление(УзелОбмена, ОбъектXDTO);
	КонецЕсли;
	
	Возврат СсылкаНаОбъект;
	
КонецФункции

#КонецОбласти

#Область Справочники

Функция НайтиСоздатьНастройки(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Профиль = НайтиПрофиль(ОбъектXDTO.Профиль);
	ТекущийПрофиль = Константы.ПрофильМобильногоПриложения.Получить();
	Если ТекущийПрофиль <> Профиль Тогда
		Константы.ПрофильМобильногоПриложения.Установить(Профиль);
	КонецЕсли;
	
	ТекущийПользователь = Константы.ТекущийПользователь.Получить();
	Если ОбъектXDTO.Свойства().Получить("ТекущийПользователь") <> Неопределено
		И ТекущийПользователь <> ОбъектXDTO.ТекущийПользователь Тогда
		Константы.ТекущийПользователь.Установить(ОбъектXDTO.ТекущийПользователь);
	КонецЕсли;
	
	Возврат Профиль;
	
КонецФункции // НайтиСоздатьКонтрагенты()

Функция НайтиСоздатьКонтрагенты(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("Контрагенты", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Родитель, ОбъектXDTO.Родитель, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	Если НЕ Объект.ЭтоГруппа Тогда
		
		ВидКонтрагента = НайтиВидыКонтрагентов(ОбъектXDTO.ВидКонтрагента);
		Если Объект.ВидКонтрагента <> ВидКонтрагента Тогда
			Объект.ВидКонтрагента = ВидКонтрагента;
			НужноЗаписыватьОбъект = Истина;
		КонецЕсли;
	
		ЗаполнитьРеквизитОбъекта(Объект.НомерТелефона, ОбъектXDTO.Телефон, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
		ЗаполнитьРеквизитОбъекта(Объект.АдресЭП, ОбъектXDTO.АдресЭП, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
		ЗаполнитьРеквизитОбъекта(Объект.Адрес, ОбъектXDTO.Адрес, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
		ЗаполнитьРеквизитОбъекта(Объект.Комментарий, ОбъектXDTO.Комментарий, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
		ЗаполнитьРеквизитОбъекта(Объект.Сеть, ОбъектXDTO.Сеть, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	КонецЕсли;
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
		
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСоздатьКонтрагенты()

Функция НайтиСоздатьКонтактныеЛица(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.КонтактныеЛица.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("КонтактныеЛица", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Владелец, ОбъектXDTO.Владелец, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.СпециализацияВрача, ОбъектXDTO.СпециализацияВрача, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.НомерТелефона, ОбъектXDTO.Телефон, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.АдресЭП, ОбъектXDTO.АдресЭП, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Комментарий, ОбъектXDTO.Комментарий, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
					
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСоздатьКонтрагенты()

Функция НайтиСоздатьТовары(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("Товары", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Родитель, ОбъектXDTO.Родитель, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	Если НЕ Объект.ЭтоГруппа Тогда
		ЗаполнитьРеквизитОбъекта(Объект.Артикул, ОбъектXDTO.Артикул, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
		ЗаполнитьРеквизитОбъекта(Объект.Штрихкод, ОбъектXDTO.Штрихкод, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	КонецЕсли;
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиТовары()

Функция НайтиСоздатьПроекты(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.Проекты.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("Проекты", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.ЛПУ, ОбъектXDTO.ЛПУ, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Аптеки, ОбъектXDTO.Аптеки, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Цикличность, ОбъектXDTO.Цикличность, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	
	Если Объект.ЧекЛист.Количество() > 0 Тогда
		Объект.ЧекЛист.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.ЧекЛист <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.ЧекЛист.СтрокаЧекЛист Цикл
			НоваяСтрока = Объект.ЧекЛист.Добавить();
			НоваяСтрока.Пункт = ТекСтрока.Пункт;			
			НоваяСтрока.ТипЗначения = ТекСтрока.ТипЗначения;
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.Препараты.Количество() > 0 Тогда
		Объект.Препараты.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.Препараты <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.Препараты.СтрокаПрепараты Цикл
			НоваяСтрока = Объект.Препараты.Добавить();
			НоваяСтрока.Товар = НайтиСоздатьТовары(УзелОбмена, ТекСтрока.Товар, КоличествоЗаписанных);			
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.Конкуренты.Количество() > 0 Тогда
		Объект.Конкуренты.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.Конкуренты <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.Конкуренты.СтрокаКонкуренты Цикл
			НоваяСтрока = Объект.Конкуренты.Добавить();
			НоваяСтрока.Товар = НайтиСоздатьТовары(УзелОбмена, ТекСтрока.Товар, КоличествоЗаписанных);			
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиПроекты()

Функция НайтиСоздатьСпециализацияВрача(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.СпециализацияВрача.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("СпециализацияВрача", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Родитель, ОбъектXDTO.Родитель, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСпециализацияВрача()

Функция НайтиСоздатьВидыМероприятий(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Справочники.СпециализацияВрача.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьСправочник("ВидыМероприятий", ОбъектXDTO, НужноЗаписыватьОбъект);
	
	ЗаполнитьРеквизитОбъекта(Объект.Наименование, ОбъектXDTO.Наименование, НужноЗаписыватьОбъект, Ложь, УзелОбмена, КоличествоЗаписанных);
	ЗаполнитьРеквизитОбъекта(Объект.Владелец, ОбъектXDTO.Владелец, НужноЗаписыватьОбъект, Истина, УзелОбмена, КоличествоЗаписанных);
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьСправочник(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСпециализацияВрача()

#КонецОбласти

#Область Документы

Функция НайтиСоздатьВизит(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Документы.Визит.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьДокумент("Визит", ОбъектXDTO, НужноЗаписыватьОбъект);

	Если Объект.Дата <> ОбъектXDTO.Дата Тогда
		Объект.Дата = ОбъектXDTO.Дата;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Операция = НайтиПрофиль(ОбъектXDTO.Операция);
	Если Объект.Операция <> Операция Тогда
		Объект.Операция = Операция;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
		
	Ответственный = ОбъектXDTO.Ответственный;
	Если Объект.Ответственный <> Ответственный Тогда
		Объект.Ответственный = Ответственный;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
		
	Проект = НайтиСоздатьПроекты(УзелОбмена, ОбъектXDTO.Проект, КоличествоЗаписанных);
	Если Объект.Проект <> Проект Тогда
		Объект.Проект = Проект;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;	
	
	Контрагент = НайтиСоздатьКонтрагенты(УзелОбмена, ОбъектXDTO.Контрагент, КоличествоЗаписанных);
	Если Объект.Контрагент <> Контрагент Тогда
		Объект.Контрагент = Контрагент;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	КонтактноеЛицо = НайтиСоздатьКонтактныеЛица(УзелОбмена, ОбъектXDTO.КонтактноеЛицо, КоличествоЗаписанных);
	Если Объект.КонтактноеЛицо <> КонтактноеЛицо Тогда
		Объект.КонтактноеЛицо = КонтактноеЛицо;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	СостояниеВизита = НайтиСостоянияВизитов(ОбъектXDTO.СостояниеВизита);
	Если Объект.СостояниеВизита <> СостояниеВизита Тогда
		Объект.СостояниеВизита = СостояниеВизита;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	ВидВизита = НайтиВидыВизитов(ОбъектXDTO.ВидВизита);
	Если Объект.ВидВизита <> ВидВизита Тогда
		Объект.ВидВизита = ВидВизита;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если Объект.ГеоМеткаНачало <> ОбъектXDTO.ГеоМеткаНачало Тогда
		Объект.ГеоМеткаНачало = ОбъектXDTO.ГеоМеткаНачало;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	Если Объект.ДатаНачало <> ОбъектXDTO.ДатаНачало Тогда
		Объект.ДатаНачало = ОбъектXDTO.ДатаНачало;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	Если Объект.ГеоМеткаОкончание <> ОбъектXDTO.ГеоМеткаОкончание Тогда
		Объект.ГеоМеткаОкончание = ОбъектXDTO.ГеоМеткаОкончание;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	Если Объект.ДатаОкончание <> ОбъектXDTO.ДатаОкончание Тогда
		Объект.ДатаОкончание = ОбъектXDTO.ДатаОкончание;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
			
	Если Объект.Оценка <> ОбъектXDTO.Оценка Тогда
		Объект.Оценка = ОбъектXDTO.Оценка;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если Объект.ЧекЛист.Количество() > 0 Тогда
		Объект.ЧекЛист.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.ЧекЛист <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.ЧекЛист.СтрокаЧекЛист Цикл
			НоваяСтрока = Объект.ЧекЛист.Добавить();
			НоваяСтрока.Пункт = ТекСтрока.Пункт;			
			НоваяСтрока.ТипЗначения = ТекСтрока.ТипЗначения;
			Если НоваяСтрока.ТипЗначения = "Число" Тогда
				НоваяСтрока.Значение = ТекСтрока.ЗначениеЧисло;
			ИначеЕсли НоваяСтрока.ТипЗначения = "Строка" Тогда
				НоваяСтрока.Значение = ТекСтрока.ЗначениеСтрока;
			ИначеЕсли НоваяСтрока.ТипЗначения = "Дата" Тогда
				НоваяСтрока.Значение = ТекСтрока.ЗначениеДата;
			ИначеЕсли НоваяСтрока.ТипЗначения = "Булево" Тогда
				НоваяСтрока.Значение = ТекСтрока.ЗначениеБулево;
			КонецЕсли;
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.Препараты.Количество() > 0 Тогда
		Объект.Препараты.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.Препараты <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.Препараты.СтрокаПрепараты Цикл
			НоваяСтрока = Объект.Препараты.Добавить();
			НоваяСтрока.Товар = НайтиСоздатьТовары(УзелОбмена, ТекСтрока.Товар, КоличествоЗаписанных);			
			НоваяСтрока.Матрица = ТекСтрока.Матрица;
			НоваяСтрока.Наличие = ТекСтрока.Наличие;
			НоваяСтрока.Заказ = ТекСтрока.Заказ;
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.Цены.Количество() > 0 Тогда
		Объект.Цены.Очистить();
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.Цены <> Неопределено Тогда
		Для каждого ТекСтрока Из ОбъектXDTO.Цены.СтрокаЦены Цикл
			НоваяСтрока = Объект.Цены.Добавить();
			НоваяСтрока.Товар = НайтиСоздатьТовары(УзелОбмена, ТекСтрока.Товар, КоличествоЗаписанных);			
			НоваяСтрока.Цена = ТекСтрока.Цена;
			НужноЗаписыватьОбъект = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если ОбъектXDTO.Свойства().Получить("Комментарий") <> Неопределено
		И Объект.Комментарий <> ОбъектXDTO.Комментарий Тогда
		Объект.Комментарий = ОбъектXDTO.Комментарий;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	Если ОбъектXDTO.Свойства().Получить("Картинка") <> Неопределено
		И Объект.Картинка.Получить() <> ОбъектXDTO.Картинка Тогда
			Объект.Картинка = Новый ХранилищеЗначения(ОбъектXDTO.Картинка);
			НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьДокумент(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения);
	
	ОбменМобильноеПриложениеВызовСервера.ДобавитьУникальныйДокументВМассив(Объект.Ссылка, ДокументыДляОтложеннойОбработки);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСоздатьЗаказПокупателя()

Функция НайтиСоздатьМероприятие(УзелОбмена, ОбъектXDTO, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Документы.Мероприятие.ПустаяСсылка();
	КонецЕсли;
	
	НужноЗаписыватьОбъект = Ложь;
	
	Объект = ОбменМобильноеПриложениеВызовСервера.СоздатьДокумент("Мероприятие", ОбъектXDTO, НужноЗаписыватьОбъект);

	Если Объект.Дата <> ОбъектXDTO.Дата Тогда
		Объект.Дата = ОбъектXDTO.Дата;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
		
	Ответственный = ОбъектXDTO.Ответственный;
	Если Объект.Ответственный <> Ответственный Тогда
		Объект.Ответственный = Ответственный;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
		
	ВидМероприятия = НайтиСоздатьВидыМероприятий(УзелОбмена, ОбъектXDTO.ВидМероприятия, КоличествоЗаписанных);
	Если Объект.ВидМероприятия <> ВидМероприятия Тогда
		Объект.ВидМероприятия = ВидМероприятия;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;	
		
	Проект = НайтиСоздатьПроекты(УзелОбмена, ОбъектXDTO.Проект, КоличествоЗаписанных);
	Если Объект.Проект <> Проект Тогда
		Объект.Проект = Проект;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;	

	Если ОбъектXDTO.Свойства().Получить("Комментарий") <> Неопределено
		И Объект.Комментарий <> ОбъектXDTO.Комментарий Тогда
		Объект.Комментарий = ОбъектXDTO.Комментарий;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
	ОбменМобильноеПриложениеВызовСервера.ЗаписатьДокумент(УзелОбмена, Объект, ОбъектXDTO, НужноЗаписыватьОбъект, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения);
	
	ОбменМобильноеПриложениеВызовСервера.ДобавитьУникальныйДокументВМассив(Объект.Ссылка, ДокументыДляОтложеннойОбработки);
	
	Возврат Объект.Ссылка;
	
КонецФункции // НайтиСоздатьЗаказПокупателя()

#КонецОбласти

#Область РегистрыСведений

#КонецОбласти

#Область Перечисления

Функция НайтиСостоянияВизитов(ОбъектXDTO)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Перечисления.СостоянияВизитов.ПустаяСсылка();
	КонецЕсли;
	
	Объект = Перечисления.СостоянияВизитов[ОбъектXDTO];
	
	Возврат Объект;
	
КонецФункции // НайтиСостоянияЗаказовПокупателей()

Функция НайтиВидыВизитов(ОбъектXDTO)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Перечисления.ВидыВизитов.ПустаяСсылка();
	КонецЕсли;
	
	Объект = Перечисления.ВидыВизитов[ОбъектXDTO];
	
	Возврат Объект;
	
КонецФункции // НайтиСостоянияЗаказовПокупателей()

Функция НайтиВидыКонтрагентов(ОбъектXDTO)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Перечисления.ВидыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Объект = Перечисления.ВидыКонтрагентов[ОбъектXDTO];
	
	Возврат Объект;
		
КонецФункции // НайтиСостоянияЗаказовПокупателей()

Функция НайтиПрофиль(ОбъектXDTO)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Перечисления.ПрофилиМобильногоПриложения.ПустаяСсылка();
	КонецЕсли;
	
	Объект = Перечисления.ПрофилиМобильногоПриложения[ОбъектXDTO];
	
	Возврат Объект;
		
КонецФункции // НайтиСостоянияЗаказовПокупателей()

#КонецОбласти

#Область Перечисления

Процедура ЗаполнитьРеквизитОбъекта(РеквизитОбъекта, РеквизитXDTO, НужноЗаписыватьОбъект, НужноСоздаватьОбъект = Ложь, УзелОбмена = Неопределено, КоличествоЗаписанных = Неопределено, ДокументыДляОтложенногоПроведения = Неопределено, ДокументыДляОтложеннойОбработки = Неопределено)
	
	Если НужноСоздаватьОбъект Тогда
		ОбъектРеквизитXDTO = НайтиСоздатьОбъектПоXDTO(РеквизитXDTO, УзелОбмена, КоличествоЗаписанных, ДокументыДляОтложенногоПроведения, ДокументыДляОтложеннойОбработки);
		Если РеквизитОбъекта <> ОбъектРеквизитXDTO Тогда
			РеквизитОбъекта = ОбъектРеквизитXDTO;
			НужноЗаписыватьОбъект = Истина;
		КонецЕсли;
	ИначеЕсли РеквизитОбъекта <> РеквизитXDTO Тогда
		РеквизитОбъекта = РеквизитXDTO;
		НужноЗаписыватьОбъект = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ПометитьОбъектНаУдаление(УзелОбмена, ОбъектXDTO)
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Идентификатор = Новый УникальныйИдентификатор(ОбъектXDTO.УникальныйИдентификатор);
	
	Если ОбъектXDTO.Тип = "Контрагенты" Тогда
		Ссылка = Справочники.Контрагенты.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "КонтактныеЛица" Тогда
		Ссылка = Справочники.КонтактныеЛица.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "СпециализацияВрача" Тогда
		Ссылка = Справочники.СпециализацияВрача.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "Товары" Тогда
		Ссылка = Справочники.Товары.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "ВидыМероприятий" Тогда
		Ссылка = Справочники.ВидыМероприятий.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "Проекты" Тогда
		Ссылка = Справочники.Проекты.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "Визит" Тогда
		Ссылка = Документы.Визит.ПолучитьСсылку(Идентификатор);
	ИначеЕсли ОбъектXDTO.Тип = "Мероприятие" Тогда
		Ссылка = Документы.Мероприятие.ПолучитьСсылку(Идентификатор);
	КонецЕсли;
	
	Попытка
		Объект = Ссылка.ПолучитьОбъект();
		Объект.УстановитьПометкуУдаления(Истина);
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, Объект);
	Исключение
	КонецПопытки;
	
КонецФункции // ПометитьОбъектНаУдаление()

