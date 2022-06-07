--4--
-----B–-------
--явную транзакцию с уровнем изолированности READ COMMITED (по умолч) 
begin transaction
select @@SPID
insert FACULTY values('ИТt','Информационных технологий');
update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'
-----t1----------
-----t2----------
ROLLBACK;
dELETE FACULTY WHERE FACULTY = 'ИТt';

--5--
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ЭТ';
------t2------
rollback

--6--
--- B ---	
begin transaction 	  
--------t1---------
insert PULPIT values ('ЭТ', 'что-то про экономику','ИЭФ');
commit
--------t2---------
--delete PULPIT where PULPIT='ЭТ' 

--7--
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM = '123-4' 
insert AUDITORIUM values ('123-4', 'ЛК-К', 10, 'Луч')
update AUDITORIUM set AUDITORIUM_NAME = 'Луч' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------