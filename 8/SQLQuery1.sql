--1--
DECLARE @c char ='C', @v varchar(4)='БГТУ', @d datetime, @t time,
		@i int, @s smallint, @ti tinyint, @n numeric(12,5)
SET @d=GETDATE()
SELECT @t='11:11:11.11'
SELECT @c c, @v v, @d d, @t t
SELECT @s=111, @ti=1, @n=111111.11111
print 's='+cast(@s as varchar(10))
print 'ti='+cast(@ti as varchar(10))
print 'n='+cast(@n as varchar(13))

--2-- общ.вместимость аудиторий
-- если >200, вывод кол-во +ср.вм. +кол-во ауд с вм меньше средней +их %
-- если <200, вывод сообщения об общ.вм.
DECLARE @v1 int, @v2 int, @v3 int, @v4 int 
SELECT @v1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
if @v1 > 200 
begin 
select	@v2 = (select COUNT(*) as [Количество] from AUDITORIUM), 
		@v3 = (select AVG(AUDITORIUM_CAPACITY) as [Средняя] from AUDITORIUM) 
set	@v4 = (select COUNT(*) as [Количество] from AUDITORIUM where AUDITORIUM_CAPACITY < @v3) 
select @v2 'Кол-во ауд.', @v3 'Средняя вмест', @v4 'Кол-во ауд. меньше средней',	
       100*(cast(@v4 as float)/cast(@v2 as float)) '% ауд. меньше средней'			
end 
else print 'общ.вм'+cast(@v1 as varchar(10))

--3-- глоб.пер-ные
select	@@ROWCOUNT 'число обработанных строк',
		@@VERSION 'версия SQL Server',
		@@SPID 'возвращает системный идентификатор процесса, назначенный сервером текущему подключению',
		@@ERROR 'код последней ошибки',
		@@SERVERNAME 'имя сервера',
		@@TRANCOUNT 'возвращает уровень вложенности транзакции',
		@@FETCH_STATUS 'проверка результата считывания строк результирующего набора',
		@@NESTLEVEL 'уровень вложенности текущей процедуры'

--4--
declare @tt int=3, @x float=4, @z float;
if (@tt>@x) set @z=power(SIN(@tt),2);
if (@tt<@x) set @z=4*(@tt+@x);
if (@tt=@x) set @z=1-exp(@x-2);
print 'z='+cast(@z as varchar(10));

--преобразование полного ФИО студента в сокращенное 
declare @fio varchar(100)=(select top 1 NAME from STUDENT)
select substring(@fio, 1, charindex(' ', @fio))
		+substring(@fio, charindex(' ', @fio)+1,1)+'.'
		+substring(@fio, charindex(' ', @fio, charindex(' ', @fio)+1)+1,1)+'.'

--поиск студентов, у которых день рож-дения в следующем месяце, и определение их возраста
select NAME,BDAY, 2022-YEAR(BDAY) [Возраст]	
from STUDENT 
where MONTH(BDAY)=MONTH(getdate())+1

--поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД
declare @gr integer = 6, @wd date
set @wd = (select top(1) PROGRESS.PDATE from PROGRESS 
join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where STUDENT.IDGROUP = @gr and PROGRESS.SUBJECT = 'СУБД')
print @wd

--5--
declare @idgr integer = 4, @avg numeric(5,2)
declare @count integer = (select count(*) from STUDENT where IDGROUP = @idgr)
if (@count > 5)
begin
set @avg = (select avg (cast (PROGRESS.NOTE as real))
from STUDENT join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT)
print 'Средний балл в группе: '+cast(@avg as varchar)
end
else print 'Кол-во студентов в группе: '+cast(@count as varchar)

--6.
select student.NAME [Имя], student.IDGROUP [Группа],
case when progress.NOTE between 0 and 3 then 'плохо'
when progress.NOTE between 4 and 6 then 'средне'
when progress.NOTE between 7 and 8 then 'хорошо'
else 'отлично'
end Оценка, COUNT(*)[Количество]
from student, PROGRESS where student.IDGROUP=4
group by student.NAME, student.IDGROUP,
case when progress.NOTE between 0 and 3 then 'плохо'
when progress.NOTE between 4 and 6 then 'средне'
when progress.NOTE between 7 and 8 then 'хорошо'
else 'отлично'
end

--7-- созд. врем. табл. 3х10, заполн и вывод, WHILE
CREATE table #PET(
age int,
name varchar(50),
relatives int)
declare @ii int=0;
while @ii<10
begin
insert #PET(age, name, relatives) 
values (floor(24*RAND()), replicate('fjs',2), floor(26*RAND()));
set @ii=@ii+1;
end
select * from #PET
--drop table #PET

--8. исп. оператора RETURN
declare @xx int = 1
while @xx < 10
begin
print @xx
set @xx=@xx+1
if (@xx > 5) return
end

--9--
begin TRY
update PROGRESS set NOTE='6' where NOTE='5'
end TRY
begin CATCH
print ERROR_NUMBER()	--код последней ошибки
print ERROR_MESSAGE()	--сообщение об ошибке
print ERROR_LINE()		--код последней ошибки
print ERROR_PROCEDURE()	--имя процедуры или NULL
print ERROR_SEVERITY()	--уровень серьезности ошибки
print ERROR_STATE()		--метка ошибки
end CATCH