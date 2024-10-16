-- Вывести все названия (Title) книг (Book) вместе с названиями (PubName) их издателей (Publisher)
select book.title, book.pub_name
from book;

-- Вывести ISBN книги/всех книг (Book) с максимальным количеством страниц (PagesNum)
select book.isbn
from book
where pages_num = (select max(bk.pages_num) from book bk);

-- Какие авторы (Author) написали больше пяти книг (Book)?
select book.author
from book
where author is not null
group by book.author
having count(1) > 5;

-- Вывести ISBN всех книг (Book), количество страниц (PagesNum) больше, чем в два раза больше среднего количества страниц во всех книгах
select bk.isbn
from book bk
where bk.pages_num > 2 * (select avg(bk2.pages_num) from book bk2);

-- Вывести категории, в которых есть подкатегории.
select distinct category.parent_cat
from category
where category.parent_cat is not null;

-- Вывести имена всех авторов (Author), написавших больше всех книг. Считать имена уникальными.
with author_count as (select book.author, count(book.isbn)
                      from book
                      group by author)
select author_count.author
from author_count
where author_count.count = (select max(ac.count) from author_count ac);

-- Вывести номера читателей (ReaderNr), которые брали (Borrwing) все книги (Book, не Copy) Марка Твена.
select r.id
from reader r
where not exists((select b1.isbn from book b1 where b1.author = 'Марк Твен')
                 except
                 (select br1.isbn from borrowing br1 where br1.reader_nr = r.id));

-- У каких (ISBN) книг (Book) больше, чем одна копия (Copy)?
select copy.isbn
from copy
group by copy.isbn
having count(copy.copy_number) > 1;

-- Вывести 10 самых старых (по PubYear) книг. Если в самом древнем году 10 книг или больше, вывести их все.
-- Если нет, вывести, сколько есть, и дальше выводить все книги из каждого предыдущего года, пока не наберется всего 10 или больше.
with count_table as (select book.*,
                            row_number() over (order by book.pub_year) as rn
                     from book)
select isbn, title, author, pages_num, pub_year, pub_name
from count_table
-- select * from count_table
where rn <= 10
   or pub_year = (select ct.pub_year from count_table ct limit 1);

-- Вывести все поддерево подкатегорий категории “Sports”.
with recursive subq as
                   (select *
                    from category
                    where category_name = 'Sports'

                    union all

                    select child.*
                    from subq s
                             join category child on child.parent_cat = s.category_name)
select *
from subq;
-- where subq.category_name != 'Sports';