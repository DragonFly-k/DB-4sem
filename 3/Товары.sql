
use Sya_MyBase_2
create table ������
(������������_������ nvarchar(20) primary key,
���� real,
���������� int,
�������� nvarchar(max),
�����_�������� nvarchar(10)
);
ALTER Table ������ ADD ����_����������� date; 
select * from ������
ALTER Table ������ ADD ��� nvarchar(20) default '�����'; 
ALTER Table ������ DROP Column ����_�����������;
ALTER Table ������ DROP DF__������__���__01142BA1;
ALTER Table ������ DROP Column ���;