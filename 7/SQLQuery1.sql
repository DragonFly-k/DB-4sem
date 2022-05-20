/*drop view [Преподаватель]
drop view [Количество кафедр]
drop view Аудитории
drop view Лекционные_аудитории
drop view Дисциплины*/

--1--
--Преподаватели
create view [Преподаватель]
as select TEACHER [код], 
TEACHER_NAME [имя преподавателя],
GENDER [пол],
PULPIT [код кафедры]
from TEACHER

select * from [Преподаватель]

--2--
create view [Количество кафедр]
as select FACULTY.FACULTY_NAME [факультет], 
count(PULPIT.FACULTY)	[количество кафедр]
from FACULTY inner join PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 

select * from [Количество кафедр]

--3--
create view Аудитории (код, наименование_аудитории)
as select	AUDITORIUM, AUDITORIUM_NAME
from AUDITORIUM
where AUDITORIUM_TYPE like 'ЛК%'

alter view Аудитории (код, наименование_аудитории, тип)
as select AUDITORIUM,
AUDITORIUM_NAME,
AUDITORIUM_TYPE 
from AUDITORIUM
where AUDITORIUM_TYPE like 'ЛК%'

select * from Аудитории

--4--
--лк, но с ограничением
create view [Лекционные_аудитории]
as select AUDITORIUM [код],
AUDITORIUM_NAME	[наименование_аудитории]
from AUDITORIUM
where AUDITORIUM_TYPE like 'ЛК%'
with check option

update Лекционные_аудитории set наименование_аудитории=0 where код='236-1'
update Лекционные_аудитории set наименование_аудитории=0 where код='301-1'
select * from Лекционные_аудитории

--5--
create view Дисциплины
as select top 150 SUBJECT [код],
SUBJECT_NAME [наименование],
PULPIT [код кафедры]
from SUBJECT
order by наименование

select * from Дисциплины

--6--
alter view [Количество кафедр] with schemabinding
as select FACULTY.FACULTY_NAME [факультет], 
count(PULPIT.FACULTY)	[количество кафедр]
from dbo.FACULTY inner join dbo.PULPIT
on PULPIT.FACULTY=FACULTY.FACULTY
group by FACULTY.FACULTY_NAME 

select * from [Количество кафедр]



