-- Определить, во сколько раз зарплата каждого сотрудника меньше максимальной зарплаты по компании.
select employees.employee_id,
       employees.first_name,
       employees.last_name,
       employees.salary,
       max(employees.salary) over () / employees.salary as ratio
from employees;

-- Определить, во сколько раз зарплата сотрудника отличается от средней зарплаты по департаменту.
select employees.employee_id,
       employees.first_name,
       employees.last_name,
       employees.department_id,
       employees.salary,
       employees.salary / avg(employees.salary) over (partition by department_id) as ratio
from employees;

-- Вывести список всех сотрудников. Для каждого сотрудника вывести среднюю зарплату по департаменту и среднюю зарплату по должности.
-- Определить, во сколько раз средняя зарплата по департаменту отличается от средней зарплаты по должности.
select employees.employee_id,
       employees.first_name,
       employees.last_name,
       employees.salary,
       employees.department_id,
       avg(employees.salary) over (partition by employees.department_id) as avg_department,
       employees.job_id,
       avg(employees.salary) over (partition by employees.job_id)        as avg_job,
       avg(employees.salary) over (partition by employees.department_id) /
       avg(employees.salary) over (partition by employees.job_id)        as ratio
from employees;

-- Вывести список сотрудников, получающих минимальную зарплату по департаменту.
-- Если в каком-либо департаменте несколько сотрудников получают минимальную зарплату, вывести того, чья фамилия идет раньше по алфавиту.
with employee_rank as (select employees.employee_id,
                              employees.first_name,
                              employees.last_name,
                              employees.salary,
                              employees.department_id,
                              rank()
                              over (partition by department_id order by (employees.salary, employees.last_name)) as rank
                       from employees)
-- select * from employee_rank
select employee_id,
       first_name,
       last_name,
       salary,
       department_id
from employee_rank
where rank = 1;

-- На основе таблицы employees создать таблицу scores c результатами соревнований со следующим маппингом:
-- employee_id -> man_id, department_id -> division, salary -> score.
-- Вывести список людей, занявших первые 3 места в каждом дивизионе (т.е. занявших три позиции с максимальным количеством очков).
create temp table if not exists temp_table as
    (select employees.employee_id as man_id, employees.department_id as division, employees.salary as score
     from employees);

with drank_table as (select temp_table.*,
                            dense_rank() over (partition by temp_table.division order by temp_table.score desc) as drank
                     from temp_table)
select *
from drank_table
where drank_table.drank <= 3;

-- [+1 балл] Отсортировать список сотрудников по фамилиям и разбить на 5 по возможности равных групп.
-- Для каждого сотрудника вывести разницу между его зарплатой и средней зарплатой по группе.
-- https://www.postgresql.org/docs/current/functions-window.html вот здесь нашел такую интересную функцию ntile
with sorted_employees as (select employees.employee_id,
                                 employees.first_name,
                                 employees.last_name,
                                 employees.salary,
                                 ntile(5) over (order by employees.last_name) as nt
                          from employees)
select sorted_employees.*,
--        count(1) over (partition by sorted_employees.nt)
       sorted_employees.salary - avg(sorted_employees.salary) over (partition by sorted_employees.nt) as ans
from sorted_employees;

-- [+1 балл] Для каждого сотрудника посчитать количество сотрудников, принятых на работу в период ± 1 год от даты его принятия на работу,
-- а также количество сотрудников, принятых позже данного сотрудника, но в этом же году. Если два сотрудника приняты в один день,
-- считать принятым позже сотрудника с большим employee_id.
select employees.employee_id,
       employees.first_name,
       employees.last_name,
       employees.hire_date,
       count(1) over (order by employees.hire_date range between '1 year' preceding and '1 year' following)                                                                                    as ans1,
       count(1)
       over (partition by date_part('year', employees.hire_date) order by employees.hire_date, employees.employee_id groups between current row and unbounded following exclude current row) as ans2
from employees;
