--1--
--Разработать AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT.
--записывать строки вводимых данных в таблицу TR_AUDIT.
--В столбец СС помеща-ются значения столбцов вводимой строки. 
create table TR_AUDIT(
ID int identity(1,1), --номер
STMT varchar(20) --DML-оператор
     check (STMT in('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300))
--drop table TR_AUDIT

create trigger TR_TEACHER_INS on TEACHER after INSERT  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'Вставка';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER_INS', @in);	         
return; 
go

insert into  TEACHER values('ИВНВ', 'Иванов', 'м', 'ИСиТ');
select * from TR_AUDIT

--2--
--Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEACHER, реагирующий 
--на событие DELETE. Триггер TR_TEACHER_DEL должен записывать стро-ку данных в таблицу TR_AUDIT 
--для каждой удаляемой строки. В столбец СС помещаются значения столбца TEACHER удаляемой стро-ки. 
create  trigger TR_TEACHER_DEL on TEACHER after DELETE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'Удаление';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER_DEL', @in);	         
return;  
go 

delete TEACHER where TEACHER='ИВНВ'
select * from TR_AUDIT

--3--
--Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEACHER, реагирующий на событие UPDATE. 
--Триггер TR_TEACHER_UPD должен записывать стро-ку данных в таблицу TR_AUDIT для каждой изменяемой строки. 
--В столбец СС помещаются значения всех столбцов изменяемой строки до и после изменения.
create trigger TR_TEACHER_UPD on TEACHER after UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'Обновление';
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

insert into  TEACHER values('ИВНВ', 'Иванов', 'м', 'ИСиТ');
update TEACHER set TEACHER_NAME = 'Bdfymrj' where TEACHER = 'ИВНВ'
select * from TR_AUDIT
--select * from TEACHER where TEACHER = 'ИВНВ'

--4--
--Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реа-гирующий на события 
--INSERT, DELETE, UPDATE. Триггер TR_TEACHER должен за-писывать строку данных в таблицу TR_AUDIT 
--для каждой изменяемой строки. В коде тригге-ра определить событие, активизировавшее триггер и 
--поместить в столбец СС соответству-ющую событию информацию. Разработать сце-нарий, демонстрирующий 
--работоспособность триггера. 
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
if ((select count(*) from inserted)> 0 and  (select count(*) from deleted)=0)
begin
print 'Событие: INSERT';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER', @in);	
end;

else if ((select count(*) from inserted)= 0 and  (select count(*) from deleted)>0)	  	 
begin
print 'Событие: DELETE';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER', @in);
end;

else if ((select count(*) from inserted)>0 and  (select count(*) from deleted)>0)
begin
print 'Событие: UPDATE'; 
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

delete TEACHER where TEACHER='ИВНВ'
insert into  TEACHER values('ИВНВ', 'Иванов', 'м', 'ИСиТ');
update TEACHER set GENDER = 'ж' where TEACHER='ИВНВ'
select * from TR_AUDIT

--5--
--Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, что провер-ка
-- ограничения целостности выполняется до срабатывания AFTER-триггера.
update TEACHER set GENDER = 'м' where TEACHER='ИВНВ'
select * from TR_AUDIT

--6--
--Создать для таблицы TEACHER три AFTER-триггера с именами: TR_TEACHER_ DEL1, TR_TEACHER_DEL2 и TR_TEACHER_ DEL3. 
--Триггеры должны реагировать на собы-тие DELETE и формировать соответствующие строки в таблицу TR_AUDIT.
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

insert into  TEACHER values('ИВНВ', 'Иванов', 'м', 'ИСиТ');
delete from TEACHER where TEACHER = 'ИВНВ'
select * from TR_AUDIT

--7--
--Разработать сценарий, демонстрирующий на примере базы данных X_UNIVER утверждение: 
--AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, акти-визировавший триггер.
create trigger PTran on PULPIT after INSERT, DELETE, UPDATE  
as declare @c int = (select count (*) from PULPIT); 	 
if (@c >26) 
begin
raiserror('Общая количество кафедр не может быть >26', 10, 1);
rollback; 
end; 
return;          

insert into PULPIT(PULPIT) values ('FDDD')
--delete from PULPIT where PULPIT='FDDD'

--8--
--Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
--Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, что проверка ограничения целостности выполнена, если есть INSTEAD OF-триггер.
--С помощью оператора DROP удалить все DML-триггеры, созданные в этой лабораторной работе.
create trigger F_INSTEAD_OF  on FACULTY instead of DELETE 
as raiserror('Удаление запрещено', 10, 1);
return;

delete FACULTY where FACULTY = 'ИДиП'

drop trigger F_INSTEAD_OF
drop trigger PTran
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER_INS

--9--
--Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. Триггер дол-жен запрещать создавать новые таблицы и уда-лять существующие.
--Свое выполнение триггер должен сопровождать сообщением, которое содержит: тип события, имя и тип объекта, а также пояснительный текст, 
--в случае запреще-ния выполнения оператора.Разработать сценарий, демонстрирующий работу триггера. 
create trigger TR_TEACHER_DDL on database for DDL_DATABASE_LEVEL_EVENTS  
as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
print 'Тип события: ' + cast(@EVENT_TYPE as varchar)
print 'Имя объекта: ' + cast(@OBJ_NAME as varchar)
print 'Тип объекта: ' + cast(@OBJ_TYPE as varchar)
raiserror('Операции с таблицей TEACHER запрещены.', 16, 1)
rollback  
end

alter table TEACHER drop column TEACHER_NAME	-- выполнение запрещено