/*drop view [�������������]
drop view [���������� ������]
drop view ���������
drop view ����������_���������
drop view ����������*/

--1--
--�������������
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

alter view ��������� (���, ������������_���������, ���)
as select AUDITORIUM,
AUDITORIUM_NAME,
AUDITORIUM_TYPE 
from AUDITORIUM
where AUDITORIUM_TYPE like '��%'

select * from ���������

--4--
--��, �� � ������������
create view [����������_���������]
as select AUDITORIUM [���],
AUDITORIUM_NAME	[������������_���������]
from AUDITORIUM
where AUDITORIUM_TYPE like '��%'
with check option

update ����������_��������� set ������������_���������=0 where ���='236-1'
update ����������_��������� set ������������_���������=0 where ���='301-1'
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



