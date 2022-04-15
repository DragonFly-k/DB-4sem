use UNIVER
---1----
--сформировать перечень кодов аудиторий
--и соответствующих им наименований типов аудиторий 
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

---2----
--1+ комп
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%компьютер%'

---3----
-- 1 И 2 Неявно
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM ,AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

select a2.AUDITORIUM_TYPENAME ,a1.AUDITORIUM 
from AUDITORIUM a1, AUDITORIUM_TYPE a2
where a1.AUDITORIUM_TYPE=a2.AUDITORIUM_TYPE 
and a2.AUDITORIUM_TYPENAME LIKE '%компьютер%'

---4----
--сформировать перечень студентов, полу-чивших экзаменационные оценки от 6 до 8
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then 'шесть'
when (PROGRESS.NOTE =7) then 'семь'
when (PROGRESS.NOTE =8) then 'восемь'
end [Оценка]
from PROGRESS inner join STUDENT 
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
inner join GROUPS on STUDENT.IDGROUP =GROUPS.IDGROUP 
inner join SUBJECT on PROGRESS.SUBJECT=SUBJECT.SUBJECT
inner join FACULTY on GROUPS.FACULTY= FACULTY.FACULTY
inner join PULPIT on SUBJECT.PULPIT= PULPIT.PULPIT
order by PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT. NAME

---5----
-- 4 + сортировка по экзаменационным оценкам 
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then 'шесть'
when (PROGRESS.NOTE =7) then 'семь'
when (PROGRESS.NOTE =8) then 'восемь'
end [Оценка]
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
--Если на кафедре нет преподавателей, то в столбце Преподаватель должна быть выведена строка ***. 
select isnull (TEACHER.TEACHER_NAME, '***' ) [Преподаватель] , PULPIT.PULPIT_NAME
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---7----
-- поменять табл местами
select isnull (TEACHER.TEACHER_NAME, '***' )[Преподаватель] , PULPIT.PULPIT_NAME
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;
-- тоже самое через right
select isnull (TEACHER.TEACHER_NAME, '***' ) [Преподаватель] , PULPIT.PULPIT_NAME
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

--коммутативность опреации
select * from reader full outer join books
on reader.ID=books.reader_id

select * from books full outer join reader
on reader.ID=books.reader_id

--является объединением LEFT OUTER JOIN и RIGHT OUTER JOIN соединений этих таблиц
select * from reader left outer join books
on reader.ID=books.reader_id
union ALL
select * from reader right outer join books
on reader.ID=books.reader_id
except
(select * from reader full outer join books
on reader.ID=books.reader_id)

--включает соединение INNER JOIN этих таблиц
select * from reader inner join books
on reader.ID=books.reader_id
except
(select * from reader full outer join books
on reader.ID=books.reader_id)

--содержит данные левой таблицы и не содержит данные правой
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null

--содержит данные правой таблицы и не со-держащие данные левой
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null

--содержит данные правой таблицы и левой таблиц
select * from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---9----
-- как в 1
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE =AUDITORIUM_TYPE.AUDITORIUM_TYPE 

---11----
--drop table TIMETABLE 
create table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)
insert into TIMETABLE values 
('пн', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('пн', 3, 'СМЛВ', '313-1', 'ОАиП', 11),
('ср', 1, 'МРЗ', '324-1', 'СУБД', 6),
('сб', 3, 'УРБ', '324-1', 'ПИС', 4),
('чт', 1, 'УРБ', '206-1', 'ПИС', 10),
('пн', 4, 'СМЛВ', '206-1', 'ОАиП', 3),
('пт', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
('пт', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),
('пн', 2, 'БРКВЧ', '413-1', 'СУБД', 8),
('пн', 2, 'ДТК', '423-1', 'СУБД', 7),
('пн', 4, 'ДТК', '423-1', 'ОАиП', 15),
('вт', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('вт', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('вт', 3, 'УРБ', '324-1', 'ПИС', 4),
('вт', 4, 'СМЛВ', '206-1', 'ОАиП', 3)

select AUDITORIUM from AUDITORIUM
except( select AUDITORIUM.AUDITORIUM
from TIMETABLE inner join AUDITORIUM 
on AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM 
and TIMETABLE.LESSON = 2 )

select AUDITORIUM from AUDITORIUM
except( select AUDITORIUM.AUDITORIUM
from TIMETABLE  inner join AUDITORIUM 
on AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM
and TIMETABLE.DAY_NAME = 'ср');

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