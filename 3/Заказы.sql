
use Sya_MyBase_2
create table ������
(�����_������ int primary key,
������������_������ nvarchar(20)  foreign key  references ������ (������������_������),
����������_����� int,
����_������ datetime,
�������� nvarchar(20) foreign key references ���������(����������)
); 