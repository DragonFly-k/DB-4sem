use UNIVER 
---1----
/*сформировать список наименований кафедр, на факультете, по специальности, технология или технологии.*/
select PULPIT_NAME from FACULTY, PULPIT
where PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY IN (select PROFESSION.FACULTY from PROFESSION
where (PROFESSION_NAME like '%технологи%'))

---2----
/* переписать через инер джоин*/
select PULPIT_NAME from PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
and PULPIT.FACULTY IN ( select PROFESSION.FACULTY from PROFESSION
where (PROFESSION_NAME like '%технологи%'))

---3----
/*без подзапроса*/
select distinct PULPIT_NAME from PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
inner join PROFESSION  on FACULTY.FACULTY = PROFESSION.FACULTY
and (PROFESSION_NAME LIKE ('%технологи%'))

---4----
/*список аудиторий самых больших вместимостей для каждого типа аудитории .отсортировать убывания вместимости.*/
select AUDITORIUM_TYPE,AUDITORIUM_CAPACITY from AUDITORIUM A
where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM R 
where  R.AUDITORIUM_TYPE= A.AUDITORIUM_TYPE 
order by AUDITORIUM_CAPACITY desc)

---5----
/*факультеты без кафедр*/
select distinct FACULTY_NAME from FACULTY, PULPIT
where not exists(select PULPIT.PULPIT from PULPIT
where FACULTY.FACULTY = PULPIT.FACULTY)

---6----
/*средние значения оценок по дисциплинам, имеющим следующие коды: ОАиП, БД и СУБД. */
select top(1)
(select avg(NOTE) from PROGRESS where SUBJECT= N'ОАиП')[ОАиП],
(select avg(NOTE) from PROGRESS where SUBJECT= N'СУБД')[СУБД],
(select avg(NOTE) from PROGRESS where SUBJECT= N'КГ')[КГ]
from PROGRESS

---7----
select SUBJECT, NOTE from PROGRESS
where NOTE >=all (
select NOTE from PROGRESS
where SUBJECT like '%П%')

---8----
select SUBJECT, NOTE from PROGRESS
where NOTE >any (
select NOTE from PROGRESS
where SUBJECT like '%П%')

---10----
/*день рождения в один день*/
select distinct  A.NAME, A.BDAY
from STUDENT A JOIN STUDENT D
ON A.BDAY=D.BDAY AND A.NAME!=D.NAME 
order by BDAY 

