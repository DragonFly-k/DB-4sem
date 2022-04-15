use UNIVER
---1----
--������������ �������� ����� ���������
--� ��������������� �� ������������ ����� ��������� 
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

---2----
--1+ ����
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%���������%'

---3----
-- 1 � 2 ������
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM ,AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

select a2.AUDITORIUM_TYPENAME ,a1.AUDITORIUM 
from AUDITORIUM a1, AUDITORIUM_TYPE a2
where a1.AUDITORIUM_TYPE=a2.AUDITORIUM_TYPE 
and a2.AUDITORIUM_TYPENAME LIKE '%���������%'

---4----
--������������ �������� ���������, ����-������ ��������������� ������ �� 6 �� 8
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then '�����'
when (PROGRESS.NOTE =7) then '����'
when (PROGRESS.NOTE =8) then '������'
end [������]
from PROGRESS inner join STUDENT 
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
inner join GROUPS on STUDENT.IDGROUP =GROUPS.IDGROUP 
inner join SUBJECT on PROGRESS.SUBJECT=SUBJECT.SUBJECT
inner join FACULTY on GROUPS.FACULTY= FACULTY.FACULTY
inner join PULPIT on SUBJECT.PULPIT= PULPIT.PULPIT
order by PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT. NAME

---5----
-- 4 + ���������� �� ��������������� ������� 
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then '�����'
when (PROGRESS.NOTE =7) then '����'
when (PROGRESS.NOTE =8) then '������'
end [������]
from PROGRESS inner join STUDENT 
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
inner join GROUPS on STUDENT.IDGROUP =GROUPS.IDGROUP 
inner join SUBJECT on PROGRESS.SUBJECT=SUBJECT.SUBJECT
inner join FACULTY on GROUPS.FACULTY= FACULTY.FACULTY
inner join PULPIT on SUBJECT.PULPIT= PULPIT.PULPIT
order by(case 
when (PROGRESS.NOTE =6) then 3
when (PROGRESS.NOTE =7) then 1
when (PROGRESS.NOTE =8) then 2
end )

---6----
--���� �� ������� ��� ��������������, �� � ������� ������������� ������ ���� �������� ������ ***. 
select isnull (TEACHER.TEACHER_NAME, '***' ) [�������������] , PULPIT.PULPIT_NAME
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---7----
-- �������� ���� �������
select isnull (TEACHER.TEACHER_NAME, '***' )[�������������] , PULPIT.PULPIT_NAME
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;
-- ���� ����� ����� right
select isnull (TEACHER.TEACHER_NAME, '***' ) [�������������] , PULPIT.PULPIT_NAME
from PULPIT right outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---8----
create table reader
(ID int primary key, NAME   nvarchar(20))
insert into reader 
values (1, 'kgfakgjfk'),
(2, 'asgxgy'),
(3, 'vrshd'),
(4, 'ahthgfaw'),
(5, 'pokjhf')

create table books
(idbook int primary key, reader_id int  foreign key  references reader(id), 
titel nvarchar(20),
author nvarchar(20))
insert into books 
values (17657, 1,'tsydjk','frasth'),
(98565, 2,'fdfgkf','wdsghfg'),
(88595, 5,'pohnm','fhdala')

--drop table books
--drop table reader

--��������������� ��������
select * from reader full outer join books
on reader.ID=books.reader_id

select * from books full outer join reader
on reader.ID=books.reader_id

--�������� ������������ LEFT OUTER JOIN � RIGHT OUTER JOIN ���������� ���� ������
select * from reader left outer join books
on reader.ID=books.reader_id
union ALL
select * from reader right outer join books
on reader.ID=books.reader_id
except
(select * from reader full outer join books
on reader.ID=books.reader_id)

--�������� ���������� INNER JOIN ���� ������
select * from reader inner join books
on reader.ID=books.reader_id
except
(select * from reader full outer join books
on reader.ID=books.reader_id)

--�������� ������ ����� ������� � �� �������� ������ ������
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null

--�������� ������ ������ ������� � �� ��-�������� ������ �����
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null

--�������� ������ ������ ������� � ����� ������
select * from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---9----
-- ��� � 1
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE =AUDITORIUM_TYPE.AUDITORIUM_TYPE 

---11----
--drop table TIMETABLE 
create table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('��', '��', '��', '��', '��', '��')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)
insert into TIMETABLE values 
('��', 1, '����', '313-1', '����', 15),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '����', '313-1', '����', 11),
('��', 1, '���', '324-1', '����', 6),
('��', 3, '���', '324-1', '���', 4),
('��', 1, '���', '206-1', '���', 10),
('��', 4, '����', '206-1', '����', 3),
('��', 1, '�����', '301-1', '����', 7),
('��', 4, '�����', '301-1', '����', 7),
('��', 2, '�����', '413-1', '����', 8),
('��', 2, '���', '423-1', '����', 7),
('��', 4, '���', '423-1', '����', 15),
('��', 1, '����', '313-1', '����', 15),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '���', '324-1', '���', 4),
('��', 4, '����', '206-1', '����', 3)

select AUDITORIUM from AUDITORIUM
except( select AUDITORIUM.AUDITORIUM
from TIMETABLE inner join AUDITORIUM 
on AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM 
and TIMETABLE.LESSON = 2 )

select AUDITORIUM from AUDITORIUM
except( select AUDITORIUM.AUDITORIUM
from TIMETABLE  inner join AUDITORIUM 
on AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM
and TIMETABLE.DAY_NAME = '��');

select distinct TEACHER .TEACHER_NAME, TIMETABLE.DAY_NAME, TIMETABLE.LESSON
from TEACHER, TIMETABLE 
except( select distinct TEACHER .TEACHER_NAME, t.DAY_NAME, t.LESSON
from TEACHER 
inner join TIMETABLE t on TEACHER .TEACHER = t.TEACHER 
inner join TIMETABLE TT on t.DAY_NAME = TT.DAY_NAME 
and t.LESSON != TT.LESSON);

select distinct GROUPS.IDGROUP, t.DAY_NAME, TT.LESSON
from GROUPS, TIMETABLE t, TIMETABLE TT
except( select distinct GROUPS.IDGROUP, t.DAY_NAME, t.LESSON
from GROUPS 
inner join TIMETABLE t on GROUPS.IDGROUP = t.IDGROUP 
inner join TIMETABLE TT on t.DAY_NAME = TT.DAY_NAME 
and t.LESSON != TT.LESSON)