create table reader
(
    id         serial primary key,
    last_name  varchar(100) not null,
    first_name varchar(100) not null,
    address    varchar(255),
    birth_date date
);

create table publisher
(
    pub_name varchar(100) primary key,
    pub_kind varchar(50) not null
);

create table book
(
    isbn      char(13) primary key,
    title     varchar(255) not null,
    author    varchar(100),
    pages_num int,
    pub_year  int,
    pub_name  varchar(100) references publisher (pub_name)
);

create table category
(
    category_name varchar(100) primary key,
    parent_cat    varchar(100) references category (category_name)
);

create table copy
(
    isbn        char(13) references book (isbn),
    copy_number int,
    shelf       varchar(50),
    position    varchar(50),
    primary key (isbn, copy_number)
);

create table borrowing
(
    reader_nr   int references reader (id),
    isbn        char(13),
    copy_number int,
    return_date date,
    primary key (reader_nr, isbn, copy_number),
    foreign key (isbn, copy_number) references copy (isbn, copy_number)
);

create table book_cat
(
    isbn          char(13) references book (isbn),
    category_name varchar(100) references category (category_name),
    primary key (isbn, category_name)
);



-- Далее идут запросы вставки, они пока не оптимизированы конкретно под ваше ДЗ,
-- но подойдут чтобы просто попробовать потыкаться и позапускать запросы, хорошие запросы вставки скину вечером


insert into reader (last_name, first_name, address, birth_date)
values ('Smith', 'John', '123 Main St', '1985-06-15'),
       ('Doe', 'Jane', '456 Elm St', '1990-11-22'),
       ('Brown', 'Charlie', '789 Maple Ave', '1978-02-14'),
       ('Johnson', 'Emily', '321 Oak St', '1992-03-05'),
       ('Davis', 'Michael', '654 Pine St', '1983-08-19'),
       ('Wilson', 'Emma', '987 Cedar Way', '1975-12-23');

insert into publisher (pub_name, pub_kind)
values ('Penguin Random House', 'Trade'),
       ('HarperCollins', 'Commercial'),
       ('Macmillan', 'Academic'),
       ('Simon & Schuster', 'Commercial'),
       ('Hachette Livre', 'Trade'),
       ('Scholastic', 'Educational');

insert into book (isbn, title, author, pages_num, pub_year, pub_name)
values ('9780316769488', 'The Catcher in the Rye', 'J.D. Salinger', 234, 1951, 'Penguin Random House'),
       ('9780007448036', 'To Kill a Mockingbird', 'Harper Lee', 281, 1960, 'HarperCollins'),
       ('9780140283334', '1984', 'George Orwell', 328, 1949, 'Penguin Random House'),
       ('9780231135604', 'Brave New World', 'Aldous Huxley', 259, 1932, 'Macmillan'),
       ('9781473664724', 'The Great Gatsby', 'F. Scott Fitzgerald', 180, 1925, 'Simon & Schuster'),
       ('9780316015844', 'Twilight', 'Stephenie Meyer', 498, 2005, 'Hachette Livre');

insert into category (category_name, parent_cat)
values ('Fiction', null),
       ('Classic', 'Fiction'),
       ('Science Fiction', 'Fiction'),
       ('Dystopian', 'Science Fiction'),
       ('Fantasy', 'Fiction'),
       ('Adventure', 'Fiction');

insert into copy (isbn, copy_number, shelf, position)
values ('9780316769488', 1, 'A1', '1'),
       ('9780007448036', 1, 'A1', '2'),
       ('9780140283334', 1, 'A1', '3'),
       ('9780231135604', 1, 'A2', '1'),
       ('9781473664724', 1, 'A2', '2'),
       ('9780316015844', 1, 'A2', '3'),
       ('9780316769488', 2, 'B1', '1'),
       ('9780007448036', 2, 'B1', '2'),
       ('9780140283334', 2, 'B1', '3'),
       ('9780231135604', 2, 'B2', '1');

insert into borrowing (reader_nr, isbn, copy_number, return_date)
values (1, '9780316769488', 1, '2023-11-01'),
       (2, '9780007448036', 1, '2023-11-15'),
       (3, '9780231135604', 1, null),
       (4, '9781473664724', 1, '2023-12-01'),
       (5, '9780316015844', 1, null),
       (6, '9780140283334', 2, '2023-10-20');

insert into book_cat (isbn, category_name)
values ('9780316769488', 'Classic'),
       ('9780007448036', 'Classic'),
       ('9780140283334', 'Dystopian'),
       ('9780231135604', 'Science Fiction'),
       ('9781473664724', 'Classic'),
       ('9780316015844', 'Fantasy');