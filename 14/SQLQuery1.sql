--1--
--����������� AFTER-������� � ������ TR_TEACHER_INS ��� ������� TEACHER, ����������� �� ������� INSERT.
--���������� ������ �������� ������ � ������� TR_AUDIT.
--� ������� �� ������-���� �������� �������� �������� ������. 
create table TR_AUDIT(
ID int identity(1,1), --�����
STMT varchar(20) --DML-��������
     check (STMT in('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300))
--drop table TR_AUDIT

create trigger TR_TEACHER_INS on TEACHER after INSERT  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print '�������';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER_INS', @in);	         
return; 
go

insert into  TEACHER values('����', '������', '�', '����');
select * from TR_AUDIT

--2--
--������� AFTER-������� � ������ TR_TEACHER_DEL ��� ������� TEACHER, ����������� 
--�� ������� DELETE. ������� TR_TEACHER_DEL ������ ���������� ����-�� ������ � ������� TR_AUDIT 
--��� ������ ��������� ������. � ������� �� ���������� �������� ������� TEACHER ��������� ����-��. 
create  trigger TR_TEACHER_DEL on TEACHER after DELETE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print '��������';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER_DEL', @in);	         
return;  
go 

delete TEACHER where TEACHER='����'
select * from TR_AUDIT

--3--
--������� AFTER-������� � ������ TR_TEACHER_UPD ��� ������� TEACHER, ����������� �� ������� UPDATE. 
--������� TR_TEACHER_UPD ������ ���������� ����-�� ������ � ������� TR_AUDIT ��� ������ ���������� ������. 
--� ������� �� ���������� �������� ���� �������� ���������� ������ �� � ����� ���������.
create trigger TR_TEACHER_UPD on TEACHER after UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print '����������';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;

set @a1 = (select TEACHER from deleted);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER_UPD', @in);       
return;  
go

insert into  TEACHER values('����', '������', '�', '����');
update TEACHER set TEACHER_NAME = 'Bdfymrj' where TEACHER = '����'
select * from TR_AUDIT
--select * from TEACHER where TEACHER = '����'

--4--
--������� AFTER-������� � ������ TR_TEACHER ��� ������� TEACHER, ���-�������� �� ������� 
--INSERT, DELETE, UPDATE. ������� TR_TEACHER ������ ��-�������� ������ ������ � ������� TR_AUDIT 
--��� ������ ���������� ������. � ���� ������-�� ���������� �������, ���������������� ������� � 
--��������� � ������� �� �����������-���� ������� ����������. ����������� ���-�����, ��������������� 
--����������������� ��������. 
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
if ((select count(*) from inserted)> 0 and  (select count(*) from deleted)=0)
begin
print '�������: INSERT';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER', @in);	
end;

else if ((select count(*) from inserted)= 0 and  (select count(*) from deleted)>0)	  	 
begin
print '�������: DELETE';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER', @in);
end;

else if ((select count(*) from inserted)>0 and  (select count(*) from deleted)>0)
begin
print '�������: UPDATE'; 
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;

set @a1 = (select TEACHER from deleted);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER', @in); 
end;
return;  

delete TEACHER where TEACHER='����'
insert into  TEACHER values('����', '������', '�', '����');
update TEACHER set GENDER = '�' where TEACHER='����'
select * from TR_AUDIT

--5--
--����������� ��������, ������� ������������� �� ������� ���� ������ X_UNIVER, ��� ������-��
-- ����������� ����������� ����������� �� ������������ AFTER-��������.
update TEACHER set GENDER = '�' where TEACHER='����'
select * from TR_AUDIT

--6--
--������� ��� ������� TEACHER ��� AFTER-�������� � �������: TR_TEACHER_ DEL1, TR_TEACHER_DEL2 � TR_TEACHER_ DEL3. 
--�������� ������ ����������� �� ����-��� DELETE � ����������� ��������������� ������ � ������� TR_AUDIT.
create trigger TR_TEACHER_DEL1 on TEACHER after delete
as print 'DELETE Trigger 1'
return;

create trigger TR_TEACHER_DEL2 on TEACHER after delete
as print 'DELETE Trigger 2'
return;  

create trigger TR_TEACHER_DEL3 on TEACHER after delete
as print 'DELETE Trigger 3'
return;  

select t.name, e.type_desc 
from sys.triggers t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE'

exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last',  @stmttype = 'DELETE'

insert into  TEACHER values('����', '������', '�', '����');
delete from TEACHER where TEACHER = '����'
select * from TR_AUDIT

--7--
--����������� ��������, ��������������� �� ������� ���� ������ X_UNIVER �����������: 
--AFTER-������� �������� ������ ����������, � ������ �������� ����������� ��������, ����-������������ �������.
create trigger PTran on PULPIT after INSERT, DELETE, UPDATE  
as declare @c int = (select count (*) from PULPIT); 	 
if (@c >26) 
begin
raiserror('����� ���������� ������ �� ����� ���� >26', 10, 1);
rollback; 
end; 
return;          

insert into PULPIT(PULPIT) values ('FDDD')
--delete from PULPIT where PULPIT='FDDD'

--8--
--��� ������� FACULTY ������� INSTEAD OF-�������, ����������� �������� ����� � �������. 
--����������� ��������, ������� ������������� �� ������� ���� ������ X_UNIVER, ��� �������� ����������� ����������� ���������, ���� ���� INSTEAD OF-�������.
--� ������� ��������� DROP ������� ��� DML-��������, ��������� � ���� ������������ ������.
create trigger F_INSTEAD_OF  on FACULTY instead of DELETE 
as raiserror('�������� ���������', 10, 1);
return;

delete FACULTY where FACULTY = '����'

drop trigger F_INSTEAD_OF
drop trigger PTran
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER_INS

--9--
--������� DDL-�������, ����������� �� ��� DDL-������� � �� UNIVER. ������� ���-��� ��������� ��������� ����� ������� � ���-���� ������������.
--���� ���������� ������� ������ ������������ ����������, ������� ��������: ��� �������, ��� � ��� �������, � ����� ������������� �����, 
--� ������ �������-��� ���������� ���������.����������� ��������, ��������������� ������ ��������. 
create trigger TR_TEACHER_DDL on database for DDL_DATABASE_LEVEL_EVENTS  
as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
print '��� �������: ' + cast(@EVENT_TYPE as varchar)
print '��� �������: ' + cast(@OBJ_NAME as varchar)
print '��� �������: ' + cast(@OBJ_TYPE as varchar)
raiserror('�������� � �������� TEACHER ���������.', 16, 1)
rollback  
end

alter table TEACHER drop column TEACHER_NAME	-- ���������� ���������