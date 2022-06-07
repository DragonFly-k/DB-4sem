--1-- ����� ������� ����������
-- ���������� ����������, ���� ����������� ���� �� ��������� ����������: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- ������� ���������� ������������ �� ��� ���, ���� �� ����� �������� COMMIT ��� ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID=object_id(N'DBO.L')) 
drop table L;           

declare @c int, @flag char = 'c'; -- ���� �->r, ������� �� ����
SET IMPLICIT_TRANSACTIONS ON -- ��� ����� ������� ����������
create table L(K int);                   
insert L values (1),(2),(3),(4),(5),(6);
set @c = (select count(*) from L);
print '���������� ����� � ������� L: ' + cast(@c as varchar(2));
if @flag = 'c' commit  -- �������� 
else rollback;     -- �����                           
SET IMPLICIT_TRANSACTIONS OFF -- ��������� ����� ������������

if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.L')) 
print '������� L ����';  
else print '������� L ���'

--2-- �������� ����������� ����� ����������
begin try        
begin tran                 -- ������  ����� ����������
insert FACULTY values ('��', '������ ���������');
insert FACULTY values ('���', '��������� print-����������');
--insert FACULTY values ('��','����� ������');
update FACULTY set FACULTY_NAME='The Best' where FACULTY='��'
commit tran;               -- �������� ����������
end try
begin catch
print '������: '+ case 
when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 
then '������������ '	--������� 1-�� ���������
else '����������� ������: '+ cast(error_number() as  varchar(5))+ error_message()  
end;
if @@trancount > 0 rollback tran; -- ��.����������� ��.>0,  ����� �� ��������� 	  
end catch;

select * from FACULTY; 

update FACULTY set FACULTY_NAME='��������� �������������� ����������' where FACULTY='��'
DELETE FACULTY WHERE FACULTY = '��';
DELETE FACULTY WHERE FACULTY = '���';

--3-- �������� SAVE TRAN
-- ���� ���������� ���� �� ���� ������� ������ ���������� T-SQL, �� ���.
-- SAVE TRANSACTION, ������ �����.����� ����������
declare @point varchar(3)
begin try
begin tran
delete from AUDITORIUM where AUDITORIUM = '123-1'
set @point = 'p1'; save tran @point
insert into AUDITORIUM values('test1', '��-�', 40, 'test1')
set @point = 'p2'; save tran @point
insert into AUDITORIUM values('test1', '��', 50, 'test2')
set @point = 'p3'; save tran @point
commit tran
end try
begin catch
print '������! ' + error_message()
if @@TRANCOUNT > 0
begin
print '����������� �����: ' + cast(@point as varchar)
rollback tran @point
commit tran
end
end catch

--4--
--READ UNCOMMITTED 
--��������� ����� ������ ������, ����������, �� �� ���������� ��.������������
--READ COMMITTED 
--��������� �� ����� ������ ������, ����������, �� �� ����������� ��.������������
-- ��� ������������� ������� ������.

------A------
--����� ���������� � ������� ��������������� READ UNCOMMITED,
--���. ������ �����������, ��������. � ��������� ������
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' '���������', *
from FACULTY WHERE FACULTY = '��';
select @@SPID, 'update PULPIT' '���������', *
from PULPIT WHERE FACULTY = '��';
commit;
-----B�-------
--����� ���������� � ������� ��������������� READ COMMITED (�� �����) 
-----t2---------
begin transaction
select @@SPID
insert FACULTY values('��t','�������������� ����������');
update PULPIT set FACULTY = '��' WHERE PULPIT = '����'
-----t1----------
-----t2----------
ROLLBACK;

SELECT * FROM FACULTY;
SELECT * FROM PULPIT;

--5--
--����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ����������������� ������, 
--�� ��� ���� ��������  ��������������� � ��������� ������. 
SELECT * from PULPIT;
-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT where FACULTY = '��';
-----t1-------
-----t2-------
select 'update PULPIT' '���������', count(*) --����� ��������� 2, �.�. ��������� ���������
from PULPIT where FACULTY = '��'; --�������� ��������������� ������
commit;
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = '��' where PULPIT = '����';
commit;
------t2------

--6--
-- ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� REPEATABLE READ. 
--���-����� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--------A---------
set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT FROM PULPIT WHERE FACULTY = '���';
--------t1---------
--------t2---------
select case
when PULPIT = '����' then 'insert'  
else ' ' 
end,
PULPIT from PULPIT where FACULTY = '���'
commit
--- B ---	
begin transaction 	  
--------t1---------
insert PULPIT values ('��', '���-�� ��� ���������','���');
commit
--------t2---------
--delete PULPIT where PULPIT='��' 

--7--����������� ��� �������� A � B 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� SERIALIZABLE. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED.
--�������� A ������ ��������������� ���������� ����������, ����������������� � ��-�������������� ������.
--------A---------
set transaction isolation level SERIALIZABLE 
begin transaction 
delete AUDITORIUM where AUDITORIUM = '123-4'
insert AUDITORIUM values ('123-4', '��-�', 10, '���')
update AUDITORIUM set AUDITORIUM_NAME = '���' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t1---------
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t2---------
commit 	
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM_NAME = '���' 
insert AUDITORIUM values ('123-4', '��-�', 10, '���')
update AUDITORIUM set AUDITORIUM_NAME = '���' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------

select * from AUDITORIUM 
--8-- ��������� ����������
-- ����������, ������������� � ������ ������ ����������, ���������� ���������. 
-- �������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������; 
-- �������� ROLLBACK ��������� ���������� ��������� �� ���-����� ������� � ���������� ����������, 
-- � ����� ��������� ��� ����������; 
-- ������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT. 
begin tran
insert AUDITORIUM_TYPE values ('��-�', '����� �� ���')
begin tran
update AUDITORIUM set AUDITORIUM_CAPACITY = '100' where AUDITORIUM_TYPE = '��-�'
commit
if @@TRANCOUNT > 0
rollback

select (select count(*) from AUDITORIUM where AUDITORIUM_TYPE = '��-�') ���������,
(select count(*) from AUDITORIUM_TYPE where AUDITORIUM_TYPE = '��-�') ���

select * from AUDITORIUM
select * from AUDITORIUM_TYPE
delete  AUDITORIUM_TYPE where  AUDITORIUM_TYPE = '��-�'; 