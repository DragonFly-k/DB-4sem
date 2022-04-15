use UNIVER 
---1----
/*������������ ������ ������������ ������, �� ����������, �� �������������, ���������� ��� ����������.*/
select PULPIT_NAME from FACULTY, PULPIT
where PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY IN (select PROFESSION.FACULTY from PROFESSION
where (PROFESSION_NAME like '%���������%'))

---2----
/* ���������� ����� ���� �����*/
select PULPIT_NAME from PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
and PULPIT.FACULTY IN ( select PROFESSION.FACULTY from PROFESSION
where (PROFESSION_NAME like '%���������%'))

---3----
/*��� ����������*/
select distinct PULPIT_NAME from PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
inner join PROFESSION  on FACULTY.FACULTY = PROFESSION.FACULTY
and (PROFESSION_NAME LIKE ('%���������%'))

---4----
/*������ ��������� ����� ������� ������������ ��� ������� ���� ��������� .������������� �������� �����������.*/
select AUDITORIUM_TYPE,AUDITORIUM_CAPACITY from AUDITORIUM A
where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM R 
where  R.AUDITORIUM_TYPE= A.AUDITORIUM_TYPE 
order by AUDITORIUM_CAPACITY desc)

---5----
/*���������� ��� ������*/
select distinct FACULTY_NAME from FACULTY, PULPIT
where not exists(select PULPIT.PULPIT from PULPIT
where FACULTY.FACULTY = PULPIT.FACULTY)

---6----
/*������� �������� ������ �� �����������, ������� ��������� ����: ����, �� � ����. */
select top(1)
(select avg(NOTE) from PROGRESS where SUBJECT= N'����')[����],
(select avg(NOTE) from PROGRESS where SUBJECT= N'����')[����],
(select avg(NOTE) from PROGRESS where SUBJECT= N'��')[��]
from PROGRESS

---7----
select SUBJECT, NOTE from PROGRESS
where NOTE >=all (
select NOTE from PROGRESS
where SUBJECT like '%�%')

---8----
select SUBJECT, NOTE from PROGRESS
where NOTE >any (
select NOTE from PROGRESS
where SUBJECT like '%�%')

---10----
/*���� �������� � ���� ����*/
select distinct  A.NAME, A.BDAY
from STUDENT A JOIN STUDENT D
ON A.BDAY=D.BDAY AND A.NAME!=D.NAME 
order by BDAY 

