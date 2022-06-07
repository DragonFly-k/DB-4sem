--1
-- Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество студентов на факультете:
create function COUNT_STUDENTS (@faculty nvarchar(20)) returns int 
as begin
declare @count int=0;
set @count=(select count(STUDENT.IDSTUDENT) from FACULTY
inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
where FACULTY.FACULTY = @faculty)
return @count;
end;
--drop function COUNT_STUDENTS;

declare @temp_1 int = dbo.COUNT_STUDENTS('ТОВ');
print 'Количество студентов на факультете ' +cast(@temp_1 as nvarchar(20))+ ' человек.';

select FACULTY 'Факультет', dbo.COUNT_STUDENTS(FACULTY) 'Кол-во студентов' from FACULTY

-- чтобы функция принимала второй параметр @prof:
alter function COUNT_STUDENTS (@faculty nvarchar(20), @prof nvarchar(20)) returns int 
as begin
declare @count int=0;
set @count=(select count(STUDENT.IDSTUDENT) from FACULTY
inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof)
return @count;
end;

declare @temp_1 int = dbo.COUNT_STUDENTS('ТОВ', '1-48 01 02');
print 'Количество студентов: ' + convert(varchar, @temp_1);

select FACULTY.FACULTY 'Факультет',	GROUPS.PROFESSION 'Специальность',
dbo.COUNT_STUDENTS(FACULTY.FACULTY, GROUPS.PROFESSION) 'Кол-во студентов'
from FACULTY inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
group by FACULTY.FACULTY, GROUPS.PROFESSION

--2
-- Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа VARCHAR(20),
-- значение которого задает код кафедры (столбец SUBJECT.PULPIT).
-- Функция должна возвращать строку типа VARCHAR(300) с перечнем дисциплин в отчете:
create function FSUBJECTS (@p nvarchar(20)) returns nvarchar(300) 
as begin
declare @list varchar(300) = 'Дисциплины: ', @sub varchar(20);
declare SUBJECT_CURSOR cursor local for select SUBJECT.SUBJECT 'Дисциплина' from SUBJECT where SUBJECT.PULPIT = @p
open SUBJECT_CURSOR
fetch next from SUBJECT_CURSOR into @sub
while @@FETCH_STATUS = 0
begin
set @list=@list+rtrim(@sub)+', ';
fetch SUBJECT_CURSOR into @sub
end;
return @list;
end;
-- drop function FSUBJECTS;

print dbo.FSUBJECTS('ИСиТ');
select PULPIT 'Кафедра', dbo.FSUBJECTS(PULPIT) 'Дисциплины' from PULPIT;

--3
-- Функция принимает два параметра, задающих код факультета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT).
--Использует SELECT-запрос c левым внешним соединением между таблицами FACULTY и PULPIT:
create function FFACPUL(@fac varchar(10), @pul varchar(10)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT 
from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY 
where FACULTY.FACULTY=isnull(@fac, FACULTY.FACULTY)
and PULPIT.PULPIT=isnull(@pul, PULPIT.PULPIT);
--drop function dbo.FFACPUL;

select * from dbo.FFACPUL(null,null);
select * from dbo.FFACPUL('ИДиП',null);
select * from dbo.FFACPUL(null,'ИСиТ');
select * from dbo.FFACPUL('ТТЛП','ЛМиЛЗ');

--4
-- Функция принимает один параметр, задающий код кафедры. Функция возвращает количество 
--преподавателей на заданной параметром кафедре. Если параметр равен NULL, то возвращается общее количество преподавателей.
create function FCTEACHER(@pul nvarchar(10)) returns int 
as begin
declare @count int=(select count(*) from TEACHER where PULPIT=isnull(@pul, PULPIT));
return @count;
end;
-- drop function FCTEACHER;

select PULPIT, dbo.FCTEACHER(PULPIT) [Количество преподавателей] from PULPIT;
select dbo.FCTEACHER(null) [Всего преподавателей];

--6
-- количество кафедр, количество групп, количество студентов и количество специальностей вычислялось отдельными скалярными функциями:
--drop function dbo.FACULTY_REPORT;
--drop function dbo.COUNT_PULPIT;
--drop function dbo.COUNT_GROUPS;
--drop function dbo.COUNT_PROFESSIONS;
create function COUNT_PULPIT(@faculty nvarchar(10)) returns int
as begin
declare @rc int=0;
set @rc=(select count(*) from PULPIT where PULPIT.FACULTY=@faculty)
return @rc;
end;

create function COUNT_GROUPS(@faculty nvarchar(10)) returns int
as begin
declare @rc int=0;
set @rc=(select count(*) from GROUPS where GROUPS.FACULTY=@faculty)
return @rc;
end;

create function COUNT_PROFESSION(@faculty varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(*) from PROFESSION where PROFESSION.FACULTY = @faculty)
return @rc;
end;

create function FACULTY_REPORT(@c int) returns @fr table
([Факультет] varchar(50), [Количество кафедр] int, [Количество групп] int,
[Количество студентов] int, [Количество специальностей] int)
as begin
declare cc cursor local static for select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY) > @c;
declare @f varchar(30);
open cc;
fetch cc into @f;
while @@fetch_status = 0
begin
insert @fr values(@f,dbo.COUNT_PULPIT(@f), dbo.COUNT_GROUPS(@f),dbo.COUNT_STUDENTS(@f), dbo.COUNT_PROFESSION(@f));
fetch cc into @f;
end;
close cc;
deallocate cc;
return;
end;

select * from dbo.FACULTY_REPORT(0);