drop database if exists students_group;
create database students_group;
use students_group;

drop table if exists students_info;
create table students_info(
	student_id tinyint unsigned primary key auto_increment,
	student_name varchar(15),
    student_subgroup set('a', 'b'),
    grade_point_average float(4, 2) unsigned,
    monthly_scholarship decimal(6, 2),
    tution_fee decimal(7, 2) default 0,
    student_sex enum('male', 'female'),
    participation set('Student Council', 'Student Council of Quality of Education', 'Council of Elders', 'BRYU', 'Council of Dormitries') default '',
    student_birth_date date,
    student_surname varchar(15),
    has_student_debths bool,
    student_home_city varchar(15)
);

insert into students_info
(student_name, student_surname, student_subgroup, grade_point_average, monthly_scholarship, tution_fee, student_sex, participation, student_birth_date, has_student_debths, student_home_city)
values
('Михаил', 'Смирнов', 'a', 8.6, 220, default, 'male', default, '2004-06-11', false, 'Minsk'),
('Адам', 'Федоров', 'a', 5.2, 0, 1600, 'male', default, '2003-09-05', true, 'Borysov'),
('Ирина', 'Иванова', 'b', 6.4, 160, default, 'female', 'Student Council,BRYU', '2005-12-17', false, 'Minsk'),
('Роман', 'Черный', 'b', 10, 240, default, 'male', default, '2004-01-26', false, 'Mogilev'),
('Арина', 'Волкова', 'a', 9.3, 0, 1400, 'female', 'Council of Elders', '2005-05-21', false, 'Lida'),
('Артур', 'Кожевников', 'b', 7.7, 180, default, 'male', 'Student Council of Quality of Education,Council of Dormitries,BRYU', '2004-07-31', false, 'Slonim'),
('Игорь', 'Морохов', 'a', 8.4, 220, default, 'male', default, '2004-10-16', false, 'Dzerzinsk');
-- select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.1. Измените тип, название, порядок следования 3–ёх произвольных столбцов. Обратите внимание на приведение типов в MySQL.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Сначала меняю тип у двух одинаковых столбцов student_name и student_surname, меняю у обоих, так как держать в таблице две колонки с разными типами char и varchar
-- не рекомендуется.

alter table students_info
modify student_name char(20),
modify student_surname char(20);

-- Теперь меняю тип обратно на varchar и изменяю имена у столбцов. 

alter table students_info
change student_name student_first_name varchar(15),
change student_surname student_last_name varchar(15);

-- Чтобы поставить столбец student_second_name после столбца student_first_name, мне нужно создать новый столбец, скопировать в него данные и удалить старый.  

alter table students_info
add column temp_column varchar(15) after student_first_name;

-- You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.

set sql_safe_updates = 0;

update students_info
set temp_column = student_last_name;

alter table students_info
drop column student_last_name,
rename column temp_column to student_last_name;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Теперь попробую поменять тип у столбца student_subgroup с set на enum.
-- Если в определении enum будет отсутствовать хотя бы одна из строк-значений, заданных в записях, то будет ошибка.

alter table students_info
modify student_subgroup enum('a', 'b', 'c');

-- Перемещу столбец student_sex после столбца student_subgroup.
-- Можно тоже создать новый столбец с лишним текстовым значением, но если убрать уже использующееся в записях, то будет ошибка.

alter table students_info
add column temp_column enum('male', 'female', 'nonbinary') after student_subgroup;

update students_info
set temp_column = student_sex;

alter table students_info
drop column student_sex,
rename column temp_column to student_sex;

-- Хочу переместить столбец has_students_debths после столбца grade_point_average.

alter table students_info
add column temp_column bool after grade_point_average;

update students_info
set temp_column = has_student_debths;

-- Булевский тип интересно приведется к enum: все значения true примут значения первой указанной в типе enum(str1, str2, ...) строки.

alter table students_info
drop column has_student_debths,
change temp_column has_student_debths enum('no', 'yes');

-- А текстовые значения преобразуются обратно в true.
-- Причем нельзя обратиться к переименованному столбцу в рамках одного alter table, так как пока инструкция не выполнена, столбец не считается переименовынным.

alter table students_info
modify has_student_debths bool;

select * from students_info;











