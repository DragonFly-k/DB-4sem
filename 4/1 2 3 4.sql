---1----
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

---2----
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE and
AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%êîìïüþòåð%'

---3----
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,AUDITORIUM.AUDITORIUM 
from AUDITORIUM ,AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

select a2.AUDITORIUM_TYPENAME ,a1.AUDITORIUM 
from AUDITORIUM as a1, AUDITORIUM_TYPE as a2
where a1.AUDITORIUM_TYPE=a2.AUDITORIUM_TYPE and
a2.AUDITORIUM_TYPENAME LIKE '%êîìïüþòåð%'

---4----
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then 'øåñòü'
when (PROGRESS.NOTE =7) then 'ñåìü'
when (PROGRESS.NOTE =8) then 'âîñåìü'
end [Îöåíêà]
from PROGRESS inner join STUDENT 
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
inner join GROUPS on STUDENT.IDGROUP =GROUPS.IDGROUP 
inner join SUBJECT on PROGRESS.SUBJECT=SUBJECT.SUBJECT
inner join FACULTY on GROUPS.FACULTY= FACULTY.FACULTY
inner join PULPIT on SUBJECT.PULPIT= PULPIT.PULPIT
order by PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT. NAME

---5----
select PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
case 
when (PROGRESS.NOTE =6) then 'øåñòü'
when (PROGRESS.NOTE =7) then 'ñåìü'
when (PROGRESS.NOTE =8) then 'âîñåìü'
end [Îöåíêà]
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
select isnull (TEACHER.TEACHER_NAME, '***' ) , PULPIT.PULPIT_NAME
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

---7----
select isnull (TEACHER.TEACHER_NAME, '***' ) , PULPIT.PULPIT_NAME
from TEACHER left outer join PULPIT 
on PULPIT.PULPIT = TEACHER.PULPIT

select isnull (TEACHER.TEACHER_NAME, '***' ) , PULPIT.PULPIT_NAME
from TEACHER right outer join PULPIT 
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER_NAME is not null 

---8----
create table reader
(ID int primary key, 
NAME   nvarchar(20))
insert into reader 
values (1, 'kgfakgjfk'),
(2, 'asgxgy'),
(3, 'vrshd'),
(4, 'ahthgfaw'),
(5, 'pokjhf')

create table books
(idbook int primary key,
reader_id int  foreign key  references reader(id), 
titel nvarchar(20),
author nvarchar(20))
insert into books 
values (17657, 1,'tsydjk','frasth'),
(98565, 2,'fdfgkf','wdsghfg'),
(88595, 5,'pohnm','fhdala')

--drop table books
--drop table reader

select * from reader full outer join books
on reader.ID=books.reader_id

select * from books full outer join reader
on reader.ID=books.reader_id

select isnull( PULPIT.PULPIT_NAME ,'***'), isnull( TEACHER.TEACHER_NAME, '***')
from PULPIT full outer join TEACHER 
on PULPIT.PULPIT =TEACHER.PULPIT
where PULPIT.PULPIT_NAME is not null and TEACHER.TEACHER_NAME is not null

select isnull( PULPIT.PULPIT_NAME ,'***'), isnull( TEACHER.TEACHER_NAME, '***')
from PULPIT full outer join TEACHER 
on PULPIT.PULPIT =TEACHER.PULPIT
where PULPIT.PULPIT_NAME is not null and TEACHER.TEACHER_NAME is null

select isnull( PULPIT.PULPIT_NAME ,'***'), isnull( TEACHER.TEACHER_NAME, '***')
from PULPIT full outer join TEACHER 
on PULPIT.PULPIT =TEACHER.PULPIT

---9----
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE =AUDITORIUM_TYPE.AUDITORIUM_TYPE 

---11----
create table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('ïí', 'âò', 'ñð', '÷ò', 'ïò', 'ñá')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)
insert into TIMETABLE values 
('ïí', 1, 'ÑÌËÂ', '313-1', 'ÑÓÁÄ', 15),
('ïí', 2, 'ÑÌËÂ', '313-1', 'ÎÀèÏ', 4),
('ïí', 3, 'ÑÌËÂ', '313-1', 'ÎÀèÏ', 11),
('ñð', 1, 'ÌÐÇ', '324-1', 'ÑÓÁÄ', 6),
('ñá', 3, 'ÓÐÁ', '324-1', 'ÏÈÑ', 4),
('÷ò', 1, 'ÓÐÁ', '206-1', 'ÏÈÑ', 10),
('ïí', 4, 'ÑÌËÂ', '206-1', 'ÎÀèÏ', 3),
('ïò', 1, 'ÁÐÊÂ×', '301-1', 'ÑÓÁÄ', 7),
('ïò', 4, 'ÁÐÊÂ×', '301-1', 'ÎÀèÏ', 7),
('ïí', 2, 'ÁÐÊÂ×', '413-1', 'ÑÓÁÄ', 8),
('ïí', 2, 'ÄÒÊ', '423-1', 'ÑÓÁÄ', 7),
('ïí', 4, 'ÄÒÊ', '423-1', 'ÎÀèÏ', 15),
('âò', 1, 'ÑÌËÂ', '313-1', 'ÑÓÁÄ', 15),
('âò', 2, 'ÑÌËÂ', '313-1', 'ÎÀèÏ', 4),
('âò', 3, 'ÓÐÁ', '324-1', 'ÏÈÑ', 4),
('âò', 4, 'ÑÌËÂ', '206-1', 'ÎÀèÏ', 3)

select AUDITORIUM.AUDITORIUM, isnull(TIMETABLE.AUDITORIUM,'***'),TIMETABLE.DAY_NAME ,TIMETABLE.LESSON,GROUPS.IDGROUP, TEACHER.TEACHER_NAME
from AUDITORIUM full outer join TIMETABLE full outer join TEACHER full outer join GROUPS
where TIMETABLE.AUDITORIUM = AUDITORIUM.AUDITORIUM and TIMETABLE.TEACHER =TEACHER.TEACHER and TIMETABLE.IDGROUP =GROUPS.IDGROUP
and TIMETABLE.DAY_NAME like 'ïí' and TIMETABLE.LESSON =2