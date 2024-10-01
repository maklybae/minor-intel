# ДЗ-3

- [ДЗ-3](#дз-3)
  - [Задание 1](#задание-1)
  - [Задание 2](#задание-2)
    - [ER Diagram Библиотека](#er-diagram-библиотека)
    - [Несколько маленьких диаграмму](#несколько-маленьких-диаграмму)
    - [ER Diagram "ER"](#er-diagram-er)
  - [Задание 3](#задание-3)
    - [Hospital](#hospital)
    - [Stations](#stations)
  - [Вывод](#вывод)


## Задание 1

*Почему у каждого отношения в реляционной БД должен быть хотя бы один ключ?*

Во-первых, заметим, что для у любого непустого отношения (непустое значит имеющее хоть один атрибут) есть ключ, так как по определению ключом является наименьший по вложению суперключ, а им может являться множество всех атрибутов отношения.

Назначение ключа – идентификация кортежа и его поиск. Также ключи помогают поддерживать целостность данных, они ограничивают создание элементов с одинаковыми (первичными) ключами, связывают отношения между собой (внешние).

##  Задание 2

### ER Diagram Библиотека

Reference:

![reference](task2/sub1/reference.png)

Relational Database:

![sub1](task2/sub1/sub1.png)

### Несколько маленьких диаграмму

Reference:

![reference](task2/sub2/reference1.png)

![reference](task2/sub2/reference2.png) 

![reference](task2/sub2/reference3.png)

Relational Database:

![sub2](task2/sub2/sub2.png)

### ER Diagram "ER"

Reference:

![reference](task2/sub3/reference.png)

Relational Database:

![sub3](task2/sub3/sub3.png)

## Задание 3

### Hospital

Reference:

![reference](task3/sub1/reference.png)

Relational Database:

![sub1](task3/sub1/sub1.png)

### Stations

Reference:

![reference](task3/sub2/reference.png)

Relational Database:

![sub3](task3/sub2/sub2.png)

## Вывод

Спасибо за внимание 👍