
use Sya_MyBase_2
create table Заказы
(Номер_заказа int primary key,
Наименование_товара nvarchar(20)  foreign key  references Товары (Наименование_товара),
Количество_ячеек int,
Дата_сделки datetime,
Заказчик nvarchar(20) foreign key references Заказчики(Покупатель)
); 