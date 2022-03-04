
use Sya_MyBase_2
create table Товары
(Наименование_товара nvarchar(20) primary key,
Цена real,
Количество int,
Описание nvarchar(max),
Место_хранения nvarchar(10)
);
ALTER Table Товары ADD Дата_поступления date; 
select * from Товары
ALTER Table Товары ADD Тип nvarchar(20) default 'кухня'; 
ALTER Table Товары DROP Column Дата_поступления;
ALTER Table Товары DROP DF__Товары__Тип__01142BA1;
ALTER Table Товары DROP Column Тип;