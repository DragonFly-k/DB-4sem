---10----
use Sya_MyBase_2

select ������.������������_������, ���������.����������, ���������.�����
from ������ inner join ���������
on ������.�������� = ���������.����������  
and ������.������������_������  LIKE '%��%'

select ������.������������_������, ���������.����������, ���������.�����
from ������, ���������
where ������.�������� = ���������.����������  
and ������.������������_������  LIKE '%��%'

select ������.������������_������, ���������.����������, ���������.�����, ������.����������_�����,
case 
when (������.����������_����� between 0 and 100) then '�����'
when (������.����������_����� between 101 and 399) then '�������'
when (������.����������_����� between 400 and 1000) then '�������'
end [�������������]
from ������ inner join ���������
on ������.�������� = ���������.���������� 
order by(case 
when (������.����������_����� between 0 and 100) then 3
when (������.����������_����� between 101 and 399) then 1
when (������.����������_����� between 400 and 1000) then 2
end ), ������.����������_�����

select  isnull (������.������������_������, '***' ), ������.��������
from ������ right outer join ������
on ������.������������_������=������.������������_������

select  isnull (������.������������_������, '***' ), ������.��������
from ������ left outer join ������
on ������.������������_������=������.������������_������

select  isnull (������.������������_������, '***' ), ������.��������
from ������ full outer join ������
on ������.������������_������=������.������������_������

select  isnull (������.������������_������, '***' ), ������.��������
from ������ cross join ������
where ������.������������_������=������.������������_������