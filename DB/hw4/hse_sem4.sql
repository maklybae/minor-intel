create table professors
(
    id       serial primary key,
    name     text not null,
    surname  text not null,
    age      int  not null,
    birthday date not null,
    position text not null,
    boss_id  int references professors (id)
);

create table study_groups
(
    id      serial primary key,
    name    text not null unique,
    program text not null,
    year    int  not null
);

create table professor_groups
(
    professor_id int  not null references professors (id),
    group_id     int  not null references study_groups (id),
    subject      text not null,

    primary key (professor_id, group_id, subject)
);

insert into study_groups (name, program, year)
values ('БПИ205', 'Программная инженерия', 2020),
       ('БПИ206', 'Программная инженерия', 2020),
       ('БПИ2411', 'Программная инженерия', 2024),
       ('БПМИ231', 'Прикладная матетематика и информатика', 2023);

insert into professors (name, surname, age, birthday, position, boss_id)
values ('Иван', 'Аржанцев', 40, '01-01-1984', 'Декан', null),
       ('Евгений', 'Соколов', 35, '01-01-1989', 'Руководитель департамента', 1),
       ('Всеволод', 'Чернышев', 35, '01-01-1989', 'Доцент', 2),
       ('Иван', 'Иванов', 30, '01-01-1994', 'Доцент', 2),
       ('Петр', 'Иванов', 20, '01-01-2004', 'Ассистент', 4);

insert into professor_groups (professor_id, group_id, subject)
values (1, 1, 'Криптография'),
       (1, 2, 'Криптография'),
       (2, 3, 'Машинное обучение'),
       (1, 3, 'Алгебра'),
       (3, 3, 'Алгебра'),
       (3, 2, 'Алгебра'),
       (3, 1, 'Алгебра'),
       (4, 4, 'Математический анализ'),
       (4, 2, 'Дискретная математика');

-- SELECT
-- базовый селект всего
select *
from study_groups;

-- селект конкретных полей
select id, name, program
from study_groups;

-- селект полей с названиями, селект измененных полей
select year as start_year, year + 4 as end_year
from study_groups;

-- селект полей и выржаений не зависящих от полей
select year as start_year, 5 as five_col
from study_groups;

-- разные функции (подробнее потом)
select lower(name)
from study_groups;

-- пустой селект
select
from study_groups;



-- DISTINCT
-- запрос с неуникальными результатами
select program
from study_groups;
-- берем уникальность по программе
select distinct program
from study_groups;
-- добавляем поле, но программы стали неуникальные
select distinct program, name
from study_groups;
-- делаем distinct on, для уникальности по конкретному полю
select distinct on (program) program, name
from study_groups;



-- WHERE
-- простейшие фильтры
select *
from study_groups
where id = 1;

-- стандартные логические операторы and, or, not
select *
from study_groups
where (id = 1 or name = 'БПИ206')
  and not year > 2021;

-- in выражения
select *
from study_groups
where id in (1, 3, 4);

-- not in выражения
select *
from study_groups
where id not in (1, 3, 4);

-- any выражения
select *
from study_groups
where id = any (array [1, 3, 4]);

-- all выражения
select *
from study_groups
where id != all (array [1, 3, 4]);


-- LIKE
-- по подстроке БПИ
select *
from study_groups
where name like '%БПИ%';
-- по суффиксу БПИ
select *
from study_groups
where name like '%БПИ';
-- по префиксу БПИ
select *
from study_groups
where name like 'БПИ%';



-- LIMIT OFFSET
-- запрос с большим количеством строк
select *
from study_groups a,
     study_groups b;
-- берем лимит
select *
from study_groups a,
     study_groups b
limit 5;
-- берем со сдвигом
select *
from study_groups a,
     study_groups b
offset 5;
-- совмещаем
select *
from study_groups a,
     study_groups b
limit 10 offset 5;



-- ORDER BY
-- обычный order by с ненужным asc
select *
from study_groups
order by year asc;
-- без asc
select *
from study_groups
order by year;
-- можно и по убыванию
select *
from study_groups
order by year desc;
-- а можно и совмещать, тогда сначала по первому, при равенстве первых по второму и тд
select *
from study_groups
order by program, year desc, id desc;



-- JOIN
-- cross join, декартово
select *
from study_groups,
     professor_groups;
-- можно с самим собой, но нужны alias'ы
select *
from study_groups a,
     study_groups b;
-- то же самое
select *
from study_groups a
         cross join study_groups b;
-- join, часто хорошо бы задавать alias'ы
select *
from study_groups sg
         join professor_groups pg on sg.id = pg.group_id;
-- inner - то же самое
select *
from study_groups sg
         inner join professor_groups pg on sg.id = pg.group_id;
-- cross join через обычный join
select *
from study_groups sg
         join professor_groups pg on true;
-- join через cross join
select *
from study_groups sg,
     professor_groups pg
where sg.id = pg.group_id;

-- join'ов может быть несколько, причем разных типов
select *
from study_groups sg
         join professor_groups pg on sg.id = pg.group_id
         join professors p on pg.professor_id = p.id;



-- OUTER JOINS
-- без указания outer'ности мы не можем получить профессора без начальника
select *
from professors p
         join professors boss_p on p.boss_id = boss_p.id;
-- делаем left join, и получаем декана с null boss'ом
select *
from professors p
         left join professors boss_p on p.boss_id = boss_p.id;
-- outer - то же самое
select *
from professors p
         left outer join professors boss_p on p.boss_id = boss_p.id;

-- right join делает наоборот, например для запроса о подчиненных получаем вот так
select *
from professors p
         right join professors boss_p on boss_p.id = p.boss_id;
-- outer - то же самое
select *
from professors p
         right outer join professors boss_p on boss_p.id = p.boss_id;

-- full (outer) join - берет и left и right части
select *
from professors p
         full join professors boss_p on boss_p.id = p.boss_id;



-- NATURAL JOIN
-- делаем любой (inner/left/right/full) join с указанием using
select *
from study_groups sg
         join study_groups pg using (program);
-- natural - сам выбирает колонки которые не надо дублировать по совпадению
select *
from study_groups sg
         natural join study_groups pg;


-- NESTED SELECT
-- Select professors where age > avg age. Uncorelated nested select
select *
from professors p
where age > (select avg(age)
      from professors p);

-- Subordinates of second level. Corelated nested query
select *
from professors p
where exists (select *
        from professors p2
        where p.boss_id = p2.id and p2.boss_id is null);

-- Does not have groups. Not in
select *
from professors p
where id not in  (select professor_id
from professor_groups pg);

-- Any
select *
from professors p
where id = any(select professor_id
from professor_groups pg);