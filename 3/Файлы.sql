use master  
create database Sya on primary --��������� �������� ������
( name = N'Sya_mdf', filename = N'D:\������\��\����\3\Sya_mdf.mdf', size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'Sya_ndf', filename = N'D:\������\��\����\3\Sya_ndf.ndf', size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1 --��������� �������� ������
( name = N'Sya_fg1_1', filename = N'D:\������\��\����\3\Sya_fgq-1.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Sya_fg1_2', filename = N'D:\������\��\����\3\Sya_fgq-2.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'Sya_log', filename=N'D:\������\��\����\3\Sya_log.ldf', size=10240Kb,  maxsize=2048Gb, filegrowth=10%)
go
USE Sya;
create table ������
(������������_������ nvarchar(20) primary key,
���� real,
���������� int,
�������� nvarchar(max),
�����_�������� nvarchar(10)
) ON FG1;
insert into ������ (������������_������, ����, ����������,��������, �����_��������)
values ('����', 78,  109856, '�������', 6859),
('���� �������', 12,  10,'������', 5425),
('�����', 400,  3, '�������', 38787),
('����', 450,  10, '����', 46778),
('�������', 5,  50, '�������', 1245),
('������', 10,  30, '�����', 657),
('�������', 4,  20, '�������', 6456);
select * from ������
