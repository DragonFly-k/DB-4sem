/*drop view [�������������]
drop view [���������� ������]
drop view ���������
drop view ����������_���������
drop view ����������*/

--1--
create view [�������������]
as select TEACHER [���], 
TEACHER_NAME [��� �������������],
GENDER [���],
PULPIT [��� �������]
from TEACHER

select * from [�������������]

--2--
create view [���������� ������]
as select FACULTY.FACULTY_NAME [���������], 
count(PULPIT.FACULTY)	[���������� ������]
from FACULTY inner join PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 

select * from [���������� ������]

--3--
create view ��������� (���, ������������_���������)
as select	AUDITORIUM, AUDITORIUM_NAME
from AUDITORIUM
where AUDITORIUM_TYPE like '��%'

insert ��������� values('201', '200-3�')
select * from ���������
select * from AUDITORIUM
update ��������� set ������������_���������=0 where ���='236-1'
select * from ���������
update ��������� set ������������_���������='236-1' where ���='236-1'
delete from AUDITORIUM where AUDITORIUM='201'
select * from AUDITORIUM

--4--
create view [����������_���������]
as select AUDITORIUM [���],
AUDITORIUM_NAME	[������������_���������]
from AUDITORIUM
where AUDITORIUM_TYPE like '��%'
with check option

alter view [����������_���������]
as select AUDITORIUM [���],
AUDITORIUM_NAME	[������������_���������],
AUDITORIUM_TYPE [���]
from AUDITORIUM
where AUDITORIUM_TYPE like '��%'
with check option

insert ����������_��������� values('201','200-3�','��')
update ����������_��������� set ������������_���������=0 where ���='236-1'
select * from ����������_���������
update ����������_���������  set ������������_���������='236-1' where ���='236-1'
delete from AUDITORIUM where AUDITORIUM='201'
select * from ����������_���������

--5--
create view ����������
as select top 150 SUBJECT [���],
SUBJECT_NAME [������������],
PULPIT [��� �������]
from SUBJECT
order by ������������

select * from ����������

--6--
alter view [���������� ������] with schemabinding
as select FACULTY.FACULTY_NAME [���������], 
count(PULPIT.FACULTY)	[���������� ������]
from dbo.FACULTY inner join dbo.PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 

select * from [���������� ������]



