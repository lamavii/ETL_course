-- 1. Создайте таблицу movies с полями movies_type, director, year_of_issue, length_in_minutes, rate.
create table if not exists movies (id serial PRIMARY KEY, 
movies_name character varying not null, 
movies_type character varying not null, 
director character varying not null, 
year_of_issue int not null, 
length_in_minutes int not null, 
rate real not null);
								
-- 2. Сделайте таблицы для горизонтального партицирования по году выпуска (до 1990, 1990 -2000, 2000- 2010, 2010-2020, после 2020).								
create table if not exists year_before_1990 (check (year_of_issue < 1990)) INHERITS (movies);
create table if not exists year_1990_2000 (check (year_of_issue >= 1990 and year_of_issue < 2000)) INHERITS (movies);
create table if not exists year_2000_2010 (check (year_of_issue >= 2000 and year_of_issue < 2010)) INHERITS (movies);
create table if not exists year_2010_2020 (check (year_of_issue >= 2010 and year_of_issue < 2020)) INHERITS (movies);
create table if not exists year_after_2020 (check (year_of_issue >= 2020)) INHERITS (movies);

-- 3. Сделайте таблицы для горизонтального партицирования по длине фильма (до 40 минута, от 40 до 90 минут, от 90 до 130 минут, более 130 минут).
create table if not exists length_before_40 (check (length_in_minutes < 40)) INHERITS (movies);
create table if not exists length_40_90 (check (length_in_minutes >= 40 and length_in_minutes < 90)) INHERITS (movies);
create table if not exists length_90_130 (check (length_in_minutes >= 90 and length_in_minutes < 130)) INHERITS (movies);
create table if not exists length_after_130 (check (length_in_minutes >= 130)) INHERITS (movies);

-- 4. Сделайте таблицы для горизонтального партицирования по рейтингу фильма (ниже 5, от 5 до 8, от 8до 10).
create table if not exists rate_before_5 (check (rate < 5)) INHERITS (movies);
create table if not exists rate_5_8 (check (rate >= 5 and rate < 8)) INHERITS (movies);
create table if not exists rate_8_10 (check (rate >= 8 and rate <= 10)) INHERITS (movies);

-- 5. Создайте правила добавления данных для каждой таблицы.
create rule insert_year_before_1990 as on insert to movies
where (year_of_issue < 1990) do instead insert into year_before_1990 values (new.*);

create rule insert_year_1990_2000 as on insert to movies
where ((year_of_issue >= 1990) and (year_of_issue < 2000)) do instead insert into year_1990_2000 values (new.*);

create rule insert_year_2000_2010 as on insert to movies
where ((year_of_issue >= 2000) and (year_of_issue < 2010)) do instead insert into year_2000_2010 values (new.*);

create rule insert_year_2010_2020 as on insert to movies
where ((year_of_issue >= 2010) and (year_of_issue < 2020)) do instead insert into year_2010_2020 values (new.*);

create rule insert_year_after_2020 as on insert to movies
where (year_of_issue >= 2020) do instead insert into year_after_2020 values (new.*);
									

create rule insert_length_before_40 as on insert to movies
where (length_in_minutes < 40) do instead insert into length_before_40 values (new.*);

create rule insert_length_40_90 as on insert to movies
where ((length_in_minutes >= 40) and (length_in_minutes < 90)) do instead insert into length_40_90 values (new.*);

create rule insert_length_90_130 as on insert to movies
where ((length_in_minutes >= 90) and (length_in_minutes < 130)) do instead insert into length_90_130 values (new.*);

create rule insert_length_after_130 as on insert to movies
where (length_in_minutes >= 130) do instead insert into length_after_130 values (new.*);


create rule insert_rate_before_5 as on insert to movies
where (rate < 5) do instead insert into rate_before_5 values (new.*);

create rule insert_rate_5_8 as on insert to movies
where ((rate >= 5) and (rate < 8)) do instead insert into rate_5_8 values (new.*);

create rule insert_rate_8_10 as on insert to movies
where ((rate >= 8) and (rate <= 10)) do instead insert into rate_8_10 values (new.*);


-- 6. Добавьте фильмы так, чтобы в каждой таблице было не менее 3 фильмов.
INSERT INTO movies (movies_name, movies_type, director, year_of_issue, length_in_minutes, rate)
VALUES ('Interstellar', 'fantastic', 'Christopher Nolan', 2014, 169, 8.6),
('Back to the Future', 'fantastic', 'Robert Zemeckis', 1985, 116, 8.6),
('Unbreakable', 'fantastic', 'M. Night Shyamalan', 2000, 106, 7.1),
('Alive in Joburg', 'fantastic', 'Neill Blomkamp', 2005, 7, 7.0),
('Игрушка', 'drama', 'Дмитрий Иванов', 2021, 6, 3.6),
('Alice & Viril', 'drama', 'Steven Shainberg', 1993, 2, 4.8),
('38 попугаев', 'animation', 'Иван Уфимцев', 1976, 9, 7.8),
('раздник Нептуна', 'comedy', 'Юрий Мамин', 1986, 44, 7.7),
('The Lion King', 'animation', 'Roger Allers, Rob Minkoff', 1994, 88, 8.8),
('Evil Toons', 'animation', 'Fred Olen Ray', 1991, 89, 4.8),
('WALL·E', 'animation', 'Andrew Stanton', 2008, 98, 8.4),
('Klaus', 'animation', 'Alfonso G. Aguilar', 2019, 96, 8.7),
('Hotel Transylvania', 'animation', 'Генадий Тартаковский', 2012, 89, 7.7),
('Dune: Part Two', 'fantastic', 'Denis Villeneuve', 2024, 166, 8.3),
('Guardians of the Galaxy Vol. 3', 'fantastic', 'James Gunn', 2023, 169, 8.1);

-- 7. Добавьте пару фильмов с рейтингом выше 10.
INSERT INTO movies (movies_name, movies_type, director, year_of_issue, length_in_minutes, rate)
values ('Non-existent', 'fantastic', 'Mister X', 2024, 150, 10.3),
('Another one non-existent', 'fantastic', 'Miss X', 2024, 100, 11);


-- 8. Сделайте выбор из всех таблиц, в том числе из основной.
SELECT * FROM movies;
SELECT * FROM year_before_1990;
SELECT * FROM year_1990_2000;
SELECT * FROM year_2000_2010;
SELECT * FROM year_2010_2020;
SELECT * FROM year_after_2020;
SELECT * FROM length_before_40;
SELECT * FROM length_40_90;
SELECT * FROM length_90_130;
SELECT * FROM length_after_130;
SELECT * FROM rate_before_5;
SELECT * FROM rate_5_8;
SELECT * FROM rate_8_10;


-- 9. Сделайте выбор только из основной таблицы.
SELECT * FROM only movies;
