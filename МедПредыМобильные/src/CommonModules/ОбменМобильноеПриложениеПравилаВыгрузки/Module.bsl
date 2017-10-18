#Область СлужебныйПрограммныйИнтерфейс

// Получает объект XDTO из переданного объекта конфигурации.
//
Функция ПолучитьОбъектXDTO(Прокси, Данные) Экспорт
	
	ПередаваемыйОбъект = Неопределено;
	
	Попытка
		
		Если ТипЗнч(Данные) = Тип("СправочникОбъект.Контрагенты")
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.Контрагенты") Тогда
			ПередаваемыйОбъект = СериализацияКонтрагент(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.КонтактныеЛица")
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
			ПередаваемыйОбъект = СериализацияКонтактноеЛицо(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.СпециализацияВрача")
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.СпециализацияВрача") Тогда
			ПередаваемыйОбъект = СериализацияСпециализацияВрача(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Проекты") 
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.Проекты") Тогда
			ПередаваемыйОбъект = СериализацияПроект(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Товары") 
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.Товары") Тогда
			ПередаваемыйОбъект = СериализацияТовар(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.ВидыМероприятий") 
			ИЛИ ТипЗнч(Данные) = Тип("СправочникСсылка.ВидыМероприятий") Тогда
			ПередаваемыйОбъект = СериализацияВидМероприятия(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("ДокументОбъект.Визит") 
			ИЛИ ТипЗнч(Данные) = Тип("ДокументСсылка.Визит") Тогда
			ПередаваемыйОбъект = СериализацияВизит(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("ДокументОбъект.Мероприятие") 
			ИЛИ ТипЗнч(Данные) = Тип("ДокументСсылка.Мероприятие") Тогда
			ПередаваемыйОбъект = СериализацияМероприятие(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("ПеречислениеСсылка.ВидыВизитов")
			ИЛИ ТипЗнч(Данные) = Тип("ПеречислениеСсылка.СостоянияВизитов")
			ИЛИ ТипЗнч(Данные) = Тип("ПеречислениеСсылка.ВидыКонтрагентов") Тогда
			ПередаваемыйОбъект = СериализацияПеречисления(Прокси, Данные);
		ИначеЕсли ТипЗнч(Данные) = Тип("УдалениеОбъекта") Тогда
			ПередаваемыйОбъект = СериализацияУдалениеОбъекта(Прокси, Данные);
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции // ПолучитьОбъектXDTO()

#КонецОбласти

#Область Справочники

Функция СериализацияКонтрагент(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "Контрагенты");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	Если ЗначениеЗаполнено(Данные.Родитель) Тогда
		ПередаваемыйОбъект.Родитель = ПолучитьОбъектXDTO(Прокси, Данные.Родитель.ПолучитьОбъект());
	КонецЕсли;
	
	Если Данные.ЭтоГруппа Тогда
		ПередаваемыйОбъект.ЭтоГруппа = Истина;
		Возврат ПередаваемыйОбъект;
	Иначе
		ПередаваемыйОбъект.ЭтоГруппа = Ложь;
	КонецЕсли;
	ПередаваемыйОбъект.ВидКонтрагента = ПолучитьОбъектXDTO(Прокси, Данные.ВидКонтрагента);
	
	ПередаваемыйОбъект.Сеть = Данные.Сеть;
	
	ПередаваемыйОбъект.Адрес = Данные.Адрес;
	ПередаваемыйОбъект.Телефон = Данные.НомерТелефона;
	ПередаваемыйОбъект.АдресЭП = Данные.АдресЭП;
	ПередаваемыйОбъект.Комментарий = Данные.Комментарий;
	
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияКонтактноеЛицо(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "КонтактныеЛица");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	
	ПередаваемыйОбъект.СпециализацияВрача = ПолучитьОбъектXDTO(Прокси, Данные.СпециализацияВрача);
	
	ПередаваемыйОбъект.Владелец = ПолучитьОбъектXDTO(Прокси, Данные.Владелец);
	
	ПередаваемыйОбъект.Телефон = Данные.НомерТелефона;
	ПередаваемыйОбъект.АдресЭП = Данные.АдресЭП;
	ПередаваемыйОбъект.Комментарий = Данные.Комментарий;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияСпециализацияВрача(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "СпециализацияВрача");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияПроект(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "Проекты");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияТовар(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "Товары");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияВидМероприятия(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "ВидыМероприятий");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.Наименование = Данные.Наименование;
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	ПередаваемыйОбъект.Владелец = ПолучитьОбъектXDTO(Прокси, Данные.Владелец);
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

#КонецОбласти

#Область Документы

Функция СериализацияВизит(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "Визиты");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	ПередаваемыйОбъект.Проведен = Данные.Проведен;
	ПередаваемыйОбъект.Номер = Данные.Номер;
	ПередаваемыйОбъект.Дата = Данные.Дата;
	ПередаваемыйОбъект.Контрагент = ПолучитьОбъектXDTO(Прокси, Данные.Контрагент.ПолучитьОбъект());
	ПередаваемыйОбъект.КонтактноеЛицо = ПолучитьОбъектXDTO(Прокси, Данные.КонтактноеЛицо.ПолучитьОбъект());
	
	ДобавляемыеСтрокиТип = ПередаваемыйОбъект.Свойства().Получить("ЧекЛист").Тип;
	ДобавляемыеСтроки = Прокси.ФабрикаXDTO.Создать(ДобавляемыеСтрокиТип);
	
	Для каждого СтрокаТЧ Из Данные.ЧекЛист Цикл
		ДобавляемаяСтрокаТип = ДобавляемыеСтроки.Свойства().Получить("СтрокаЧекЛист").Тип;
		ДобавляемаяСтрока = Прокси.ФабрикаXDTO.Создать(ДобавляемаяСтрокаТип);
		ДобавляемаяСтрока.Пункт = СтрокаТЧ.Пункт;
		ДобавляемаяСтрока.ТипЗначения = СтрокаТЧ.ТипЗначения;
		Если ТипЗнч(СтрокаТЧ.Значение) = Тип("Число") Тогда
			ДобавляемаяСтрока.ЗначениеЧисло = СтрокаТЧ.Значение;
		ИначеЕсли ТипЗнч(СтрокаТЧ.Значение) = Тип("Строка") Тогда
			ДобавляемаяСтрока.ЗначениеСтрока = СтрокаТЧ.Значение;
		ИначеЕсли ТипЗнч(СтрокаТЧ.Значение) = Тип("Дата") Тогда
			ДобавляемаяСтрока.ЗначениеДата = СтрокаТЧ.Значение;
		ИначеЕсли ТипЗнч(СтрокаТЧ.Значение) = Тип("Булево") Тогда
			ДобавляемаяСтрока.ЗначениеБулево = СтрокаТЧ.Значение;
		КонецЕсли;
		ДобавляемыеСтроки.СтрокаЧекЛист.Добавить(ДобавляемаяСтрока);
	КонецЦикла;
	
	ПередаваемыйОбъект.ЧекЛист = ДобавляемыеСтроки;
	
	ДобавляемыеСтрокиТип = ПередаваемыйОбъект.Свойства().Получить("Препараты").Тип;
	ДобавляемыеСтроки = Прокси.ФабрикаXDTO.Создать(ДобавляемыеСтрокиТип);
	
	Для каждого СтрокаТЧ Из Данные.Препараты Цикл
		ДобавляемаяСтрокаТип = ДобавляемыеСтроки.Свойства().Получить("СтрокаПрепараты").Тип;
		ДобавляемаяСтрока = Прокси.ФабрикаXDTO.Создать(ДобавляемаяСтрокаТип);
		Если ЗначениеЗаполнено(СтрокаТЧ.Товар) Тогда
			ДобавляемаяСтрока.Товар = ПолучитьОбъектXDTO(Прокси, СтрокаТЧ.Товар.ПолучитьОбъект());
		Конецесли;
		ДобавляемаяСтрока.Матрица = СтрокаТЧ.Матрица;
		ДобавляемаяСтрока.Наличие = СтрокаТЧ.Наличие;
		ДобавляемаяСтрока.Заказ = СтрокаТЧ.Заказ;
		ДобавляемыеСтроки.СтрокаПрепараты.Добавить(ДобавляемаяСтрока);
	КонецЦикла;
	
	ПередаваемыйОбъект.Препараты = ДобавляемыеСтроки;
	
	ДобавляемыеСтрокиТип = ПередаваемыйОбъект.Свойства().Получить("Цены").Тип;
	ДобавляемыеСтроки = Прокси.ФабрикаXDTO.Создать(ДобавляемыеСтрокиТип);
	
	Для каждого СтрокаТЧ Из Данные.Цены Цикл
		ДобавляемаяСтрокаТип = ДобавляемыеСтроки.Свойства().Получить("СтрокаЦены").Тип;
		ДобавляемаяСтрока = Прокси.ФабрикаXDTO.Создать(ДобавляемаяСтрокаТип);
		Если ЗначениеЗаполнено(СтрокаТЧ.Товар) Тогда
			ДобавляемаяСтрока.Товар = ПолучитьОбъектXDTO(Прокси, СтрокаТЧ.Товар.ПолучитьОбъект());
		Конецесли;
		ДобавляемаяСтрока.Цена = СтрокаТЧ.Цена;
		ДобавляемыеСтроки.СтрокаЦены.Добавить(ДобавляемаяСтрока);
	КонецЦикла;
	
	ПередаваемыйОбъект.Цены = ДобавляемыеСтроки;
	
	ПередаваемыйОбъект.СостояниеВизита = ПолучитьОбъектXDTO(Прокси, Данные.СостояниеВизита);
	ПередаваемыйОбъект.ВидВизита = ПолучитьОбъектXDTO(Прокси, Данные.ВидВизита);
	ПередаваемыйОбъект.Проект = ПолучитьОбъектXDTO(Прокси, Данные.Проект);
	
	ПередаваемыйОбъект.Оценка		        = Данные.Оценка;

	ПередаваемыйОбъект.ГеоМеткаНачало		= ПолучитьКоординаты(Данные.ГеоМеткаНачало.Получить());
	ПередаваемыйОбъект.ДатаНачало			= Данные.ДатаНачало;
	ПередаваемыйОбъект.ГеоМеткаОкончание	= ПолучитьКоординаты(Данные.ГеоМеткаОкончание.Получить());
	ПередаваемыйОбъект.ДатаОкончание		= Данные.ДатаОкончание;
	ПередаваемыйОбъект.Комментарий			= Данные.Комментарий;
	Если ЗначениеЗаполнено(Данные.СлужебныйКомментарий) Тогда
		ПередаваемыйОбъект.СлужебныйКомментарий	= Данные.СлужебныйКомментарий;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.Картинка.Получить()) Тогда
		ПередаваемыйОбъект.Картинка = ПолучитьКартинку(Данные.Картинка);
	КонецЕсли;
		
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияМероприятие(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "Мероприятия");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	ПередаваемыйОбъект.ПометкаУдаления = Данные.ПометкаУдаления;
	ПередаваемыйОбъект.Проведен = Данные.Проведен;
	ПередаваемыйОбъект.Номер = Данные.Номер;
	ПередаваемыйОбъект.Дата = Данные.Дата;
	
	ПередаваемыйОбъект.Проект = ПолучитьОбъектXDTO(Прокси, Данные.Проект);
	ПередаваемыйОбъект.ВидМероприятия = ПолучитьОбъектXDTO(Прокси, Данные.ВидМероприятия);
	
	ПередаваемыйОбъект.Комментарий	= Данные.Комментарий;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция СериализацияПеречисления(Прокси, Данные)
	
	//теперь получаем как названо перечисление в конфигураторе
	ИмяПеречисления = Данные.Метаданные().Имя;
	
	//теперь получим индекс где хранится то что нам надо
	НужныйИндекс = Перечисления[ИмяПеречисления].Индекс(Данные);
	
	ПередаваемыйОбъект = Метаданные.Перечисления[ИмяПеречисления].ЗначенияПеречисления[НужныйИндекс].Имя;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

Функция СериализацияУдалениеОбъекта(Прокси, Данные)
	
	ПередаваемыйОбъект = ОбменМобильноеПриложениеВызовСервера.СоздатьОбъект(Прокси, "УдалениеОбъекта");
	ПередаваемыйОбъект.УникальныйИдентификатор = Строка(Данные.Ссылка.УникальныйИдентификатор());
	
	Если ТипЗнч(Данные.Ссылка) = Тип("СправочникСсылка.Контрагенты") Тогда
		ПередаваемыйОбъект.Тип = "Контрагенты";
	ИначеЕсли ТипЗнч(Данные.Ссылка) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ПередаваемыйОбъект.Тип = "КонтактныеЛица";
	ИначеЕсли ТипЗнч(Данные.Ссылка) = Тип("ДокументСсылка.Визит") Тогда
		ПередаваемыйОбъект.Тип = "Визит";
	ИначеЕсли ТипЗнч(Данные.Ссылка) = Тип("ДокументСсылка.Мероприятие") Тогда
		ПередаваемыйОбъект.Тип = "Мероприятие";
	КонецЕсли;
	
	Возврат ПередаваемыйОбъект;
	
КонецФункции

#КонецОбласти

// Получает картинку.
//
Функция ПолучитьКартинку(Картинка) Экспорт
	
	ДвоичныеДанныеФайла = Картинка.Получить();
	СериализиаторXDTO = Новый СериализаторXDTO(ФабрикаXDTO);
	
	Попытка
		КартинкаXDTO = СериализиаторXDTO.ЗаписатьXDTO(ДвоичныеДанныеФайла);
	Исключение
		КартинкаXDTO = Неопределено;
	КонецПопытки;
	
	Возврат КартинкаXDTO;
	
КонецФункции

// Получает координаты.
//
Функция ПолучитьКоординаты(Координаты)
	
	СериализиаторXDTO = Новый СериализаторXDTO(ФабрикаXDTO);
	
	Попытка
		КоординатыXDTO = СериализиаторXDTO.ЗаписатьXDTO(Координаты);
	Исключение
		КоординатыXDTO = Неопределено;
	КонецПопытки;
	
	Возврат КоординатыXDTO;
	
КонецФункции