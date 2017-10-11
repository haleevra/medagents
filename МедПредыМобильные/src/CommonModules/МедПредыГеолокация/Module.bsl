#Если МобильноеПриложениеКлиент Тогда
&НаКлиенте
Функция ПолучитьКоординаты() Экспорт
	Провайдер = СредстваГеопозиционирования.ПолучитьСамогоТочногоПровайдера();
	ИмяПровайдера = Провайдер.Имя;
	// Если местоположение на данном устройстве ни разу не выполнялось
	// или выполнено более часа назад – обновить местоположение и
	// получить определенные координаты
	Координаты = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ИмяПровайдера);
	Если НЕ ЗначениеЗаполнено(Координаты) Тогда
		Провайдер = СредстваГеопозиционирования.ПолучитьСамогоТочногоПровайдера();
		ИмяПровайдера = Провайдер.Имя;
		Координаты = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ИмяПровайдера);
	КонецЕсли;
	
	Возврат Координаты;
КонецФункции
#КонецЕсли	
