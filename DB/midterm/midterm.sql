-- [4 балла]
-- Разрабатывается мессенджер, который позволяет пользователям обмениваться сообщениями и файлами.
-- Заказчик хочет, чтобы база данных содержала информацию о пользователях, каналах, сообщениях и файловых вложениях.
-- Должна быть возможность не только отправки сообщения выбранному пользователю, но и рассылки сообщений пользователям,
-- самостоятельно подписавшимся на канал. Пользователи должны иметь возможность пересылать полученные и отправленные сообщения.
-- Получатели сообщений должны иметь возможность реагировать на них с использованием эмодзи.
-- У каждого канала есть единственный администратор, который может в него отправлять сообщения.
--
-- Спроектируйте реляционную базу данных для такого приложения.
--
-- Обязательно: скрипт создания таблиц на SQL DDL (CREATE TABLE).
--
-- Не обязательно, на оценку не влияет: концептуальная модель в виде E/R или UML диаграммы.

create table if not exists messenger_user
(
    id           serial primary key,
    name         varchar(255) not null,
    surname      varchar(255) not null,
    mobile_phone varchar(20)  not null
);

-- чат и канал представлены одной сущностью, так как хочется иметь одинаковые id для них обоиох (это нам пригодится,
-- при связи сообщение-чат(канал), а далее и для реакций, файлов, который связаны с сообщением)
create table if not exists chat
(
    id         serial primary key,
    is_channel boolean not null, -- флаг ставится для чатов, являющимися каналами
    name       varchar(255)
);
-- также поддерживаются группы: то есть private messages могут быть с несколькими пользователями

create table if not exists chat_member
(
    chat_id  int     not null references chat (id) on delete cascade ,
    user_id  int     not null references messenger_user (id) on delete cascade,
    can_send boolean not null, -- флаг ставится для администраторов, в будущем можно поддерживать несколько администраторов каналов
    primary key (chat_id, user_id)
);

create table if not exists file
(
    id            serial primary key,
    name          varchar(255) not null,
    path_to_file  varchar(255) not null,
    download_time timestamp    not null default current_timestamp
);

create table if not exists message
(
    id                 serial primary key,
    chat_id            int       not null references chat (id) on delete cascade,
    sender_id          int       not null references messenger_user (id) on delete cascade,
    text               text      not null default '',
    forward_message_id int references message (id) on delete set null,
    file_id            int references file (id) on delete set null,
    send_time          timestamp not null default current_timestamp
);

-- считается, что можно оставлять несколько эмодзи на одно сообщение (тг премиум)
create table if not exists message_reaction
(
    message_id int         not null references message (id) on delete cascade,
    user_id    int         not null references messenger_user (id) on delete cascade,
    reaction   varchar(10) not null, -- emoji
    send_time  timestamp   not null default current_timestamp,
    primary key (message_id, user_id, reaction)
);

-- [2 балла] Напишите запрос на SQL к БД, спроектированной в задании 1, возвращающий количество личных сообщений с файлами,
-- отправленных, полученных и пересланных указанным пользователем за указанный период времени. Результат: три числа.
-- Для констант start_time = '2001-01-01', end_time = '2001-02-10', user_id = 2
select (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
        where ch.is_channel = FALSE
          and m.file_id is not null
          and '2001-01-01' <= m.send_time
          and m.send_time <= '2001-02-10'
          and m.sender_id = 2)     as sent_count,

       (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
                 join chat_member mem on ch.id = mem.chat_id
        where ch.is_channel = FALSE
          and m.file_id is not null
          and '2001-01-01' <= m.send_time
          and m.send_time <= '2001-02-10'
          and mem.user_id = 2
          and m.sender_id <> mem.user_id) as received_count,

       (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
                 join message f_m on m.forward_message_id = f_m.id
        where ch.is_channel = FALSE
          and f_m.file_id is not null
          and m.sender_id = 2
          and '2001-01-01' <= m.send_time
          and m.send_time <= '2001-02-10')   as forward_count;

-- Общий вариант
select (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
        where ch.is_channel = FALSE
          and m.file_id is not null
          and :start_date <= m.send_time
          and m.send_time <= :end_date
          and m.sender_id = :user_id)     as sent_count,

       (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
                 join chat_member mem on ch.id = mem.chat_id
        where ch.is_channel = FALSE
          and m.file_id is not null
          and :start_date <= m.send_time
          and m.send_time <= :end_date
          and mem.user_id = :user_id
          and m.sender_id <> mem.user_id) as received_count,

       (select count(*)
        from message m
                 join chat ch on m.chat_id = ch.id
                 join message f_m on m.forward_message_id = f_m.id
        where ch.is_channel = FALSE
          and f_m.file_id is not null
          and m.sender_id = :user_id
          and :start_date <= m.send_time
          and m.send_time <= :end_date)   as forward_count;


-- [2 балла] Напишите запрос на SQL к БД, спроектированной в задании 1,
-- возвращающий всех пользователей, у которых в сообщениях хотя бы одного канала, на который он подписан,
-- количество использований эмодзи превышает 5. Результат: список id пользователей.

-- в задании не сказано количество КАКИХ эмодзи превышает 5, поэтому будем считать, что количество ЛИЧНО оставленных эмодзи
select distinct u.id
from messenger_user u
         join chat_member cm on u.id = cm.user_id
         join chat c on cm.chat_id = c.id
         join message m on cm.chat_id = m.chat_id
         join message_reaction mr on u.id = mr.user_id and m.id = mr.message_id
where c.is_channel = TRUE
group by u.id, cm.chat_id
having count(mr.reaction) > 5;

-- [2 балла] Напишите запрос на SQL к БД, спроектированной в задании 1,
-- возвращающий  список из (не более, чем) 3 наиболее активных каналов по количеству отправленных в них сообщений
-- и для каждого такого канала - одно сообщение, у которого максимальное количество эмодзи.
-- Результат: список из строк (название канала, количество отправленных сообщений, id сообщения, самого популярного по количеству эмодзи ).
select c.name    as channel_name,
       count(*)  as count_messages,
       (select m2.id
        from message m2
                 join message_reaction mr2 on m2.id = mr2.message_id
        where m2.chat_id = c.id
        group by m2.id
        order by count(mr2.reaction) desc
        limit 1) as best_message_id -- подзапрос находит сообщение из канала с максимальным количеством реакций
from chat c
         join message m on c.id = m.chat_id
where c.is_channel = TRUE
group by c.id
order by count_messages desc
limit 3;
