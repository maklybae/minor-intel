-- 1) Все фамилии (LastName) читателей (Reader) из Москвы
select reader.last_name
from reader
where address = 'Москва';

-- 2) Все названия (Title) и авторов (Author) книг (Books), опубликованных издателями
-- (Publisher) научной или справочной литературы (pubKind либо 'Science', либо 'Reference')
select book.title, book.author
from book
         join publisher p on p.pub_name = book.pub_name
where p.pub_kind in ('Science', 'Reference');

-- 3) Все названия (Title) и авторов (Author) книг (Books), которые брал Иван Иванов.
select distinct b.title, b.author
from borrowing
         join book b on borrowing.isbn = b.isbn
         join reader r on borrowing.reader_nr = r.id
where r.first_name = 'Иван'
  and r.last_name = 'Иванов';

-- 4) Все идентификаторы (ISBN) книг (Book), относящихся к категории "Mountains",
-- но не относящихся к категории "Travel". Подкатегории не учитывать.
select book.isbn
from book
where 'Mountains' in (select book_cat.category_name from book_cat where book_cat.isbn = book.isbn)
  and 'Travel' not in (select book_cat.category_name from book_cat where book_cat.isbn = book.isbn);

-- 5) Все фамилии и имена читателей, которые вернули хотя бы одну книгу
-- (Borrowing.ReturnDate is not null)
select distinct r.last_name, r.first_name
from borrowing
         join reader r on r.id = borrowing.reader_nr
where borrowing.return_date is not null;

-- 6) Все фамилии и имена читателей, которые брали (Borrowing) хотя бы одну книгу (Book),
-- которую брал Иван Иванов. Ответ не должен содержать самого Ивана Иванова.
select distinct reader.last_name, reader.first_name
from borrowing
         join reader on borrowing.reader_nr = reader.id
where borrowing.isbn in (select b.isbn
                         from borrowing b
                                  join reader r on r.id = b.reader_nr
                         where r.first_name = 'Иван'
                           and r.last_name = 'Иванов')
  and reader.first_name != 'Иван'
  and reader.last_name != 'Иванов';
