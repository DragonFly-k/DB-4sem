--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID=object_id(N'DBO.L')) 
drop table L;           

declare @c int, @flag char = 'c'; -- если с->r, таблица не сохр
SET IMPLICIT_TRANSACTIONS ON -- вкл режим неявной транзакции
create table L(K int);                   
insert L values (1),(2),(3),(4),(5),(6);
set @c = (select count(*) from L);
print 'количество строк в таблице L: ' + cast(@c as varchar(2));
if @flag = 'c' commit  -- фиксация 
else rollback;     -- откат                           
SET IMPLICIT_TRANSACTIONS OFF -- действует режим автофиксации

if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.L')) 
print 'таблица L есть';  
else print 'таблицы L нет'

--2-- СВОЙСТВО АТОМАРНОСТИ ЯВНОЙ ТРАНЗАКЦИИ
begin try        
begin tran                 -- начало  явной транзакции
insert FACULTY values ('ДФ', 'Другой факультет');
insert FACULTY values ('ПиМ', 'Факультет print-технологий');
--insert FACULTY values ('ИТ','Самый лучший');
update FACULTY set FACULTY_NAME='The Best' where FACULTY='ИТ'
commit tran;               -- фиксация транзакции
end try
begin catch
print 'ошибка: '+ case 
when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 
then 'дублирование '	--позиция 1-го вхождения
else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
end;
if @@trancount > 0 rollback tran; -- ур.вложенности тр.>0,  транз не завершена 	  
end catch;

select * from FACULTY; 

update FACULTY set FACULTY_NAME='Факультет информационных технологий' where FACULTY='ИТ'
DELETE FACULTY WHERE FACULTY = 'ДФ';
DELETE FACULTY WHERE FACULTY = 'ПиМ';

--3-- ОПЕРАТОР SAVE TRAN
-- если транзакция сост из неск независ блоков операторов T-SQL, то исп.
-- SAVE TRANSACTION, формир контр.точку транзакции
declare @point varchar(3)
begin try
begin tran
delete from AUDITORIUM where AUDITORIUM = '123-1'
set @point = 'p1'; save tran @point
insert into AUDITORIUM values('test1', 'ЛБ-К', 40, 'test1')
set @point = 'p2'; save tran @point
insert into AUDITORIUM values('test1', 'ЛК', 50, 'test2')
set @point = 'p3'; save tran @point
commit tran
end try
begin catch
print 'Ошибка! ' + error_message()
if @@TRANCOUNT > 0
begin
print 'Контрольная точка: ' + cast(@point as varchar)
rollback tran @point
commit tran
end
end catch

--4--
--READ UNCOMMITTED 
--операторы могут читать строки, измененные, но не выполненые др.транзакциями
--READ COMMITTED 
--операторы не могут читать данные, измененные, но не выполненные др.транзакциями
-- Это предотвращает грязные чтения.

------A------
--явную транзакцию с уровнем изолированности READ UNCOMMITED,
--кот. допуск неподтвержд, неповтор. и фантомное чтение
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY WHERE FACULTY = 'ИТ';
select @@SPID, 'update PULPIT' 'результат', *
from PULPIT WHERE FACULTY = 'ИТ';
commit;
-----B–-------
--явную транзакцию с уровнем изолированности READ COMMITED (по умолч) 
-----t2---------
begin transaction
select @@SPID
insert FACULTY values('ИТt','Информационных технологий');
update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'
-----t1----------
-----t2----------
ROLLBACK;

SELECT * FROM FACULTY;
SELECT * FROM PULPIT;

--5--
--Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 
SELECT * from PULPIT;
-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT where FACULTY = 'ИТ';
-----t1-------
-----t2-------
select 'update PULPIT' 'результат', count(*) --здесь результат 2, т.к. произошло изменение
from PULPIT where FACULTY = 'ИТ'; --работает неповторяющееся чтение
commit;
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';
commit;
------t2------

--6--
-- Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--------A---------
set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT FROM PULPIT WHERE FACULTY = 'ИЭФ';
--------t1---------
--------t2---------
select case
when PULPIT = 'ЭТиМ' then 'insert'  
else ' ' 
end,
PULPIT from PULPIT where FACULTY = 'ИЭФ'
commit
--- B ---	
begin transaction 	  
--------t1---------
insert PULPIT values ('ЭТ', 'что-то про экономику','ИЭФ');
commit
--------t2---------
--delete PULPIT where PULPIT='ЭТ' 

--7--Разработать два сценария A и B 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности SERIALIZABLE. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и не-повторяющегося чтения.
--------A---------
set transaction isolation level SERIALIZABLE 
begin transaction 
delete AUDITORIUM where AUDITORIUM = '123-4'
insert AUDITORIUM values ('123-4', 'ЛК-К', 10, 'Луч')
update AUDITORIUM set AUDITORIUM_NAME = 'Луч' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t1---------
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t2---------
commit 	
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM_NAME = 'Луч' 
insert AUDITORIUM values ('123-4', 'ЛК-К', 10, 'Луч')
update AUDITORIUM set AUDITORIUM_NAME = 'Луч' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------

select * from AUDITORIUM 
--8-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 
begin tran
insert AUDITORIUM_TYPE values ('ЛБ-М', 'какой то тип')
begin tran
update AUDITORIUM set AUDITORIUM_CAPACITY = '100' where AUDITORIUM_TYPE = 'ЛК-К'
commit
if @@TRANCOUNT > 0
rollback

select (select count(*) from AUDITORIUM where AUDITORIUM_TYPE = 'ЛБ-М') Аудитории,
(select count(*) from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛБ-М') Тип

select * from AUDITORIUM
select * from AUDITORIUM_TYPE
delete  AUDITORIUM_TYPE where  AUDITORIUM_TYPE = 'ЛБ-М'; 