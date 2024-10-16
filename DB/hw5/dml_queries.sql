-- Добавить в таблицу Borrowing запись про то, что ‘John Johnson’ взял книгу c ISBN=123456 и CopyNumber=4.
-- Но такой книги, копии и читателя нет в исходных данных, эхххъ
insert into borrowing (reader_nr, isbn, copy_number, return_date)
values ((select id from reader where first_name = 'John' and last_name = 'Johnson'), '123456', 4, null);

-- Удалить все книги с годом публикации больше, чем 2000.
delete
from book
where pub_year > 2000
returning *;

-- Увеличить дату возврата на 30 дней (просто +30) для всех книг в категории "Databases",  у которых эта дата > '01.01.2022'.
update borrowing
set return_date = return_date + 30
where 'Databases' in (select category_name from book_cat where book_cat.isbn = borrowing.isbn)
  and return_date > '01.01.2022'
returning *;
