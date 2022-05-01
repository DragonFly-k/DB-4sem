--1--
DECLARE @c char ='C', @v varchar(4)='����', @d datetime, @t time,
		@i int, @s smallint, @ti tinyint, @n numeric(12,5)
SET @d=GETDATE()
SELECT @t='11:11:11.11'
SELECT @c c, @v v, @d d, @t t
SELECT @s=111, @ti=1, @n=111111.11111
print 's='+cast(@s as varchar(10))
print 'ti='+cast(@ti as varchar(10))
print 'n='+cast(@n as varchar(13))

--2-- ���.����������� ���������
-- ���� >200, ����� ���-�� +��.��. +���-�� ��� � �� ������ ������� +�� %
-- ���� <200, ����� ��������� �� ���.��.
DECLARE @v1 int, @v2 int, @v3 int, @v4 int 
SELECT @v1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
if @v1 > 200 
begin 
select	@v2 = (select COUNT(*) as [����������] from AUDITORIUM), 
		@v3 = (select AVG(AUDITORIUM_CAPACITY) as [�������] from AUDITORIUM) 
set	@v4 = (select COUNT(*) as [����������] from AUDITORIUM where AUDITORIUM_CAPACITY < @v3) 
select @v2 '���-�� ���.', @v3 '������� �����', @v4 '���-�� ���. ������ �������',	
       100*(cast(@v4 as float)/cast(@v2 as float)) '% ���. ������ �������'			
end 
else print '���.��'+cast(@v1 as varchar(10))

--3-- ����.���-���
select	@@ROWCOUNT '����� ������������ �����',
		@@VERSION '������ SQL Server',
		@@SPID '���������� ��������� ������������� ��������, ����������� �������� �������� �����������',
		@@ERROR '��� ��������� ������',
		@@SERVERNAME '��� �������',
		@@TRANCOUNT '���������� ������� ����������� ����������',
		@@FETCH_STATUS '�������� ���������� ���������� ����� ��������������� ������',
		@@NESTLEVEL '������� ����������� ������� ���������'

--4--
declare @tt int=3, @x float=4, @z float;
if (@tt>@x) set @z=power(SIN(@tt),2);
if (@tt<@x) set @z=4*(@tt+@x);
if (@tt=@x) set @z=1-exp(@x-2);
print 'z='+cast(@z as varchar(10));

--�������������� ������� ��� �������� � ����������� 
declare @fio varchar(100)=(select top 1 NAME from STUDENT)
select substring(@fio, 1, charindex(' ', @fio))
		+substring(@fio, charindex(' ', @fio)+1,1)+'.'
		+substring(@fio, charindex(' ', @fio, charindex(' ', @fio)+1)+1,1)+'.'

--����� ���������, � ������� ���� ���-����� � ��������� ������, � ����������� �� ��������
select NAME,BDAY, 2022-YEAR(BDAY) [�������]	
from STUDENT 
where MONTH(BDAY)=MONTH(getdate())+1

--����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����
declare @gr integer = 6, @wd date
set @wd = (select top(1) PROGRESS.PDATE from PROGRESS 
join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where STUDENT.IDGROUP = @gr and PROGRESS.SUBJECT = '����')
print @wd

--5--
declare @idgr integer = 4, @avg numeric(5,2)
declare @count integer = (select count(*) from STUDENT where IDGROUP = @idgr)
if (@count > 5)
begin
set @avg = (select avg (cast (PROGRESS.NOTE as real))
from STUDENT join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT)
print '������� ���� � ������: '+cast(@avg as varchar)
end
else print '���-�� ��������� � ������: '+cast(@count as varchar)

--6.
select student.NAME [���], student.IDGROUP [������],
case when progress.NOTE between 0 and 3 then '�����'
when progress.NOTE between 4 and 6 then '������'
when progress.NOTE between 7 and 8 then '������'
else '�������'
end ������, COUNT(*)[����������]
from student, PROGRESS where student.IDGROUP=4
group by student.NAME, student.IDGROUP,
case when progress.NOTE between 0 and 3 then '�����'
when progress.NOTE between 4 and 6 then '������'
when progress.NOTE between 7 and 8 then '������'
else '�������'
end

--7-- ����. ����. ����. 3�10, ������ � �����, WHILE
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

--8. ���. ��������� RETURN
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
print ERROR_NUMBER()	--��� ��������� ������
print ERROR_MESSAGE()	--��������� �� ������
print ERROR_LINE()		--��� ��������� ������
print ERROR_PROCEDURE()	--��� ��������� ��� NULL
print ERROR_SEVERITY()	--������� ����������� ������
print ERROR_STATE()		--����� ������
end CATCH