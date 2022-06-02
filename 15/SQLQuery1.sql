--1--
--созд.XML в режиме PATH из TEACHER для преподов ИСиТ
--каждый столбец конфигурируется независимо с пом имени псевдонима этого столбца
select PULPIT.FACULTY[факультет/@код], TEACHER.PULPIT[факультет/кафедра/@код], TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель/@код]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Список_преподавателей_кафедры_ИСиТ');

--2--
--Разработать сценарий создания XML-документа в режиме AUTO на основе SELECT-запроса 
--к таблицам AUDITORIUM и AUDI-TORIUM_TYPE, который содержит следую-щие столбцы:
--наименование аудитории, наиме-нование типа аудитории и вместимость. 
--Найти только лекционные аудитории
select AUDITORIUM.AUDITORIUM [Аудитория], AUDITORIUM.AUDITORIUM_TYPE [Наимменование_типа],AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость] 
from AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список_аудиторий'), elements;

--3--
--содержащий данные о трех новых учебных дисциплинах, которые следует добавить в таб-лицу SUBJECT. 
--Разработать сценарий, извлекающий данные о дисциплинах из XML-документа и добавля-ющий их в таблицу SUBJECT. 
--При этом применить системную функцию OPENXML и конструкцию INSERT… SELECT. 
--имена его атрибутов совпадают с именами столбцов результирующего набора
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="МПп" название="Математическое программирование п" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
with([код] char(10), [название] varchar(100), [кафедра] char(20));

--select * from SUBJECT
--delete from SUBJECT where SUBJECT.SUBJECT='КГиГ' or SUBJECT.SUBJECT='ОЗИ' or SUBJECT.SUBJECT='МПп'

--4--
--Используя таблицу STUDENT разработать XML-структуру, содержащую паспортные дан-ные студента
--Разработать сценарий, в который включен оператор INSERT, добавляющий строку с XML-столбцом.
--Включить в этот же сценарий оператор UP-DATE, изменяющий столбец INFO у одной строки таблицы STUDENT 
--и оператор SELECT, формирующий результирующий набор, аналогичный представленному на ри-сунке. 
--В SELECT-запросе использовать методы QUERY и VALUEXML-типа.
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
values(4, 'Сятковская Е.Д.', '2003-04-20',
	'<студент>
		<паспорт серия="МР" номер="4133033" дата="2018-03-12" />
		<телефон>+375297631738</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Минск</город>
			<улица>Прушинских</улица>
			<дом>4</дом>
			<квартира>34</квартира>
		</адрес>
	</студент>');
select * from STUDENT where NAME = 'Сятковская Е.Д.';
update STUDENT set INFO = '<студент>
		<паспорт серия="МР" номер="4133033" дата="2018-03-12" />
		<телефон>375297631738</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Минск</город>
			<улица>Прушинских</улица>
			<дом>4</дом>
			<квартира>34</квартира>
		</адрес>
	</студент>' where NAME='Сятковская Е.Д.'
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта], 
INFO.query('/студент/адрес')[Адрес]
from  STUDENT where NAME = 'Сятковская Е.Д.';   

--5. измен STUDENT: значения типизир.столбца INFO контрол XML SCHEMACOLLECTION
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

--alter table STUDENT alter column INFO xml(Student);
--drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='Сятковская Е.Д.'