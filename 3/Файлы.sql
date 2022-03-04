use master  
create database Sya on primary --первичная файловая группа
( name = N'Sya_mdf', filename = N'D:\универ\бд\лабы\3\Sya_mdf.mdf', size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'Sya_ndf', filename = N'D:\универ\бд\лабы\3\Sya_ndf.ndf', size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1 --вторичная файловая группа
( name = N'Sya_fg1_1', filename = N'D:\универ\бд\лабы\3\Sya_fgq-1.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Sya_fg1_2', filename = N'D:\универ\бд\лабы\3\Sya_fgq-2.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'Sya_log', filename=N'D:\универ\бд\лабы\3\Sya_log.ldf', size=10240Kb,  maxsize=2048Gb, filegrowth=10%)
go
USE Sya;
create table Товары
(Наименование_товара nvarchar(20) primary key,
Цена real,
Количество int,
Описание nvarchar(max),
Место_хранения nvarchar(10)
) ON FG1;
insert into Товары (Наименование_товара, Цена, Количество,Описание, Место_хранения)
values ('Стол', 78,  109856, 'крепкий', 6859),
('Стул офисный', 12,  10,'мягкий', 5425),
('Диван', 400,  3, 'удобный', 38787),
('Шкаф', 450,  10, 'купе', 46778),
('Скрепки', 5,  50, 'цветные', 1245),
('Бумага', 10,  30, 'белая', 657),
('Степлер', 4,  20, 'крепкий', 6456);
select * from Товары
