
&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	
	ОбменМобильноеПриложениеФоновыеЗадания.ВыполнениеОбменаПриОбновленииСписка();
	Оповестить("ПрошелОбмен");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Константы.ПрофильМобильногоПриложения.Получить() = Перечисления.ПрофилиМобильногоПриложения.МедПредставитель Тогда
		Элементы.Ответственный.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры
