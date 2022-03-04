use Sya_MyBase_2
SELECT * From Товары; 
SELECT Наименование_товара, Цена  From Товары;
SELECT count(*) From Товары;
SELECT Наименование_товара  From Товары where Цена > 100;
SELECT distinct top(4) Наименование_товара, Цена  From Товары order by Цена desc;
UPDATE ТОВАРЫ set Цена+=10 Where Наименование_товара = 'Стол';
SELECT Наименование_товара, Цена  From Товары Where Наименование_товара = 'Стол';
SELECT Наименование_товара, Цена  From Товары where Цена between 100 AND 420;
SELECT Наименование_товара From Товары Where Наименование_товара like 'С%';
SELECT Наименование_товара, Цена  From Товары where Цена in( 100 , 420);