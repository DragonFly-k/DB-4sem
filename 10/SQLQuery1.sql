use UNIVER
--1--
--Cписок дисциплин (краткие назв.) на ИСиТ
--из таблицы SUBJECT в одну строку через запятую (RTRIM)
declare Subs cursor for select SUBJECT from SUBJECT where SUBJECT.PULPIT='ИСиТ'

declare @sub char(4), @str char(100)=' '
open Subs  
fetch Subs into @sub;    
print 'Дисциплины на кафедре ИСиТ:'   
while @@fetch_status = 0                                   
begin 
set @str = rtrim(@sub)+', '+@str -- удаляет все завершающие пробелы        
fetch  Subs into @sub
end  
print @str      
close  Subs
deallocate Subs

--2--
--Отличие глобального курсора от локального 
declare curL cursor local for select PROGRESS.IDSTUDENT, PROGRESS.NOTE from PROGRESS 

declare @st varchar(10), @note int
open curL
fetch curL into @st,@note
print '1. ' + @st + ': ' + cast(@note as varchar) 

go
declare @st varchar(10), @note int
open curL
fetch curL into @st,@note
print '2. ' + @st + ': ' + cast(@note as varchar) 

go
declare curG cursor global for select PROGRESS.IDSTUDENT, PROGRESS.NOTE from PROGRESS 

declare @st varchar(10), @note int
open curG
fetch curG into @st,@note
print '1. ' + @st + ': ' + cast(@note as varchar) 

go
declare @st varchar(10), @note int
fetch curG into @st,@note
print '2. ' + @st + ': ' + cast(@note as varchar) 

close curG
deallocate curG

--3--
--Отличие статических курсоров от динамических
declare cur cursor local static for select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM 

declare @name varchar(10), @type varchar(5), @cap int
open cur
print 'Кол-во строк: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛК-К' where AUDITORIUM = '1234567'		
fetch cur into @name, @type, @cap;
while @@FETCH_STATUS = 0
begin
print @name + ' ' + @type + ' ' + cast(@cap as char) 
fetch cur into @name, @type, @cap
end
close cur

declare cur1 cursor local dynamic for select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM 

declare @name1 varchar(10), @type1 varchar(5), @cap1 int
open cur1
print 'Кол-во строк: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛК-К' where AUDITORIUM = '200-а'
fetch cur1 into @name1, @type1, @cap1
while @@FETCH_STATUS = 0
begin
print @name1 + ' ' + @type1 + ' ' + cast(@cap1 as char) 
fetch cur1 into @name1, @type1, @cap1
end
close cur1  

--4--
--Демонстр свойства навигации в результиру-ющем наборе курсора с атрибутом SCROLL 
DECLARE  @t int, @rn char(50)
DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUP = 6 
OPEN ScrollCur
fetch FIRST from ScrollCur into  @t, @rn                
print 'первая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn)
fetch NEXT from ScrollCur into  @t, @rn              
print 'следующая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn)      
fetch LAST from  ScrollCur into @t, @rn       
print 'последняя строка: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn)   
fetch PRIOR from ScrollCur into  @t, @rn         --пред от текущей  
print 'предпоследняя строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn) 
fetch ABSOLUTE 2 from ScrollCur into  @t, @rn    -- от начала             
print 'вторая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn) 
fetch RELATIVE 1 from ScrollCur into  @t, @rn    -- от текущей          
print 'третья строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn)       
CLOSE ScrollCur

--5--
--Создать курсор, демонстрирующий применение конструкции CURRENT OF 
--в секции WHERE с исп UPDATE и DELETE.
declare cur cursor local dynamic for select IDSTUDENT, NOTE from PROGRESS FOR UPDATE

declare @id varchar(10), @nt int
open cur
fetch cur into @id, @nt
print @id + ' оценка ' + cast(@nt as varchar) + ' '
delete PROGRESS where CURRENT OF cur	
fetch cur into @id, @nt
update PROGRESS set NOTE = NOTE + 1 where CURRENT OF cur
print @id + ' оценка ' + cast(@nt as varchar) + ' '
close cur

--6--
--из PROGRESS удал строки о студентах с оц<4
DECLARE @name3 nvarchar(20), @n int
DECLARE Cur1 CURSOR LOCAL for SELECT NAME, NOTE from PROGRESS join STUDENT 
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and NOTE<5

OPEN Cur1
fetch  Cur1 into @name3, @n
while @@fetch_status = 0
begin 		
delete PROGRESS where CURRENT OF Cur1	
fetch  Cur1 into @name3, @n  
end
CLOSE Cur1

SELECT NAME, NOTE from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and NOTE<5
insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
values  ('ОАиП', 1005,  '01.10.2013',4),
        ('СУБД', 1017,  '01.12.2013',4),
		('КГ',   1018,  '06.5.2013',4),
        ('ОХ',   1065,  '01.1.2013',4),
        ('ОХ',   1069,  '01.1.2013',4),
        ('ЭТ',   1058,  '01.1.2013',4)

-- увелиичть оценку на единицу
DECLARE @name4 char(20), @n3 int
DECLARE Cur2 CURSOR LOCAL for SELECT NAME, NOTE from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and PROGRESS.IDSTUDENT=1005

OPEN Cur2
fetch  Cur2 into @name4, @n3
UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2
CLOSE Cur2

SELECT NAME, NOTE from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and PROGRESS.IDSTUDENT=1005