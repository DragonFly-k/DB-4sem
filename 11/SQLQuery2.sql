--4--
-----B�-------
--����� ���������� � ������� ��������������� READ COMMITED (�� �����) 
begin transaction
select @@SPID
insert FACULTY values('��t','�������������� ����������');
update PULPIT set FACULTY = '��' WHERE PULPIT = '����'
-----t1----------
-----t2----------
ROLLBACK;
dELETE FACULTY WHERE FACULTY = '��t';

--5--
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = '��' where PULPIT = '��';
------t2------
rollback

--6--
--- B ---	
begin transaction 	  
--------t1---------
insert PULPIT values ('��', '���-�� ��� ���������','���');
commit
--------t2---------
--delete PULPIT where PULPIT='��' 

--7--
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM = '123-4' 
insert AUDITORIUM values ('123-4', '��-�', 10, '���')
update AUDITORIUM set AUDITORIUM_NAME = '���' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------