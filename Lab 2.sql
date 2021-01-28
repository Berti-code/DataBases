use CannesFilmFestival;

/*
insert into Edition(EditionYear, StartDate, EndDate)
values (2019, '14-05-2019', '25-05-2019')

insert into Edition(EditionYear, StartDate, EndDate)
values (2017, '08-05-2017', '19-05-2017')
*/
insert into Category(CategoryId, CategoryName, EditionYear)
values (9, 'Golden Palm', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (10, 'Grand Prize of the Festival', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (11, 'Jury Prize', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (12, 'Best Short Film', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (13, 'Best Actress', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (14, 'Best Actor', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (15, 'Best Director', 2017)

insert into Category(CategoryId, CategoryName, EditionYear)
values (16, 'Best Screenplay', 2017)
/*
insert into Director(DirectorId, Name)
values (1, 'Roman Polanski')

insert into ScreenWriter(ScreenWriterId, Name)
values (1, 'Wladyslaw Szpilman')

insert into Producer(ProducerId, Name)
values (1, 'Alain Sarde')

insert into Movie(MovieId, Title, Genre, CategoryId, DirectorId, ScreenWriterId, ProducerId)
values (1, 'The Pianist', 'War/Drama', 1, 1, 1, 1)

insert into Movie(MovieId, Title, Genre, CategoryId, DirectorId, ScreenWriterId, ProducerId)
values (2, '120 Beats Per Minute', 'Drama', 1, 1, 1, 1)

insert into Movie(MovieId, Title, Genre, CategoryId, DirectorId, ScreenWriterId, ProducerId)
values (3, 'Moonlight', 'Drama', 1, 1, 1, 1)

insert into Movie(MovieId, Title, Genre, CategoryId, DirectorId, ScreenWriterId, ProducerId)
values (4, 'The Grand Budapest Hotel', 'Drama-Comedy', 1, 1, 1, 1)

insert into Movie(MovieId, Title, Genre, CategoryId, DirectorId, ScreenWriterId, ProducerId)
values (1, '4 Months, 3 Weeks and 2 Days', 'Drama', 9, 9, 9, 9)
/*Fails to add the movie because of integrity  constraints*/
*/
--Updates required for filling in the Length fields of the movies
UPDATE Movie
SET Lenght = 110
WHERE MovieId = 1

UPDATE Movie
SET Lenght = 130
WHERE MovieId = 2

UPDATE Movie
SET Lenght = 120
WHERE MovieId = 3

UPDATE Movie
SET Lenght = 90
WHERE MovieId = 4

--Updates
update Movie
set Title = 'A serious man'
where MovieId = 4 AND NOT(DirectorId = 5 OR DirectorId = 6)

update Producer
set Name = 'Robert Benmussa'
where (ProducerId IN (1,2,3)) OR (ProducerId is not null and ProducerId = 1)

update Category
set CategoryName = 'Prix Un Certain Regard'
where (CategoryId IS NOT NULL AND CategoryId = 4) AND (CategoryName NOT IN ('Best Screenplay','Jury Prize'))
/*
--Deletes
delete from Category
where CategoryName IN ('Prix Un Certain Regard','Palm Dog','Queer Palm','Cannes Soundtrack Award')

delete from Movie
where MovieId BETWEEN 4 and 6
*/
--Union
SELECT * from Movie
WHERE MovieId BETWEEN 4 AND 5
UNION ALL
SELECT * FROM Movie
WHERE Title not in ('A serious man')
--The movies with id's between 4 and 5 and those that are not in the set

SELECT * FROM Category
WHERE CategoryId >= 3
UNION
SELECT * FROM Category
WHERE CategoryName in ('Golden Palm','Best Actor','Queer Palm','Cannes Soundtrack Award')
--The categories with id's bigger than 3 and those that are in the set

--Intersect
SELECT * FROM Category
WHERE CategoryId >= 3
INTERSECT
SELECT * FROM Category
WHERE CategoryId in (2,3,4,5)
--The categories with both id's bigger than 3 and that are in the set

SELECT * FROM Movie
WHERE MovieId > 1
INTERSECT
SELECT * FROM Movie
WHERE Genre LIKE 'Drama'
--The movies with both id's bigger than 1 and that are dramas

--Except
SELECT * FROM Movie
WHERE MovieId < 4
EXCEPT
SELECT * FROM Movie
WHERE Genre LIKE 'War%'
--The movies with id's smaller than 4 that are not about war

SELECT * FROM Category
WHERE CategoryId not in (6)
EXCEPT
SELECT * FROM Category
WHERE CategoryName not like 'Best%'
--The categories who's id is not in the set {6}, excluding those that don't start with 'Best'


--JOIN
SELECT MovieId, Title, Movie.DirectorId, Movie.ScreenWriterId, Movie.ProducerId
FROM Movie INNER JOIN Director ON Director.DirectorId = Movie.DirectorId INNER JOIN ScreenWriter ON ScreenWriter.ScreenWriterId=Movie.ScreenWriterId INNER JOIN Producer ON Producer.ProducerId = Movie.ProducerId
--The movies having the same director, screen writer and producer

SELECT *
FROM Edition LEFT JOIN Category ON Edition.EditionYear = Category.EditionYear
--All the editions, returns NULL for editions without categories

SELECT *
FROM Director RIGHT JOIN Movie ON Director.DirectorId = Movie.DirectorId
--The directors togheter with the coresponding movies, NULL for directors without movies

SELECT *
FROM Movie FULL JOIN Contract ON Contract.MovieId = Movie.MovieId FULL JOIN Actor ON Actor.ActorId = Contract.ActorId
--All the movies together with their contracts and actors, NULL for missing contracts and actors

--IN
SELECT MovieId, Title
FROM Movie
WHERE MovieId IN
	(SELECT MovieId
	FROM Movie
	WHERE MovieId < 4
	);
--The movies that have the id's in the table with id smaller than 4

SELECT MovieId, Title, Genre, CategoryId
FROM Movie
WHERE MovieId IN
	(SELECT MovieId
	FROM Movie
	WHERE CategoryId IN
		(
		SELECT CategoryId
		FROM Movie
		WHERE Genre IN ('Drama', 'Drama-Comedy')
		)
	);
--The movies with movieIds in the list of movies with categoryIds in the list of movies that are either Drama or Drama-Comedy

--EXISTS
SELECT MovieId, Title, Genre
FROM Movie
WHERE EXISTS
	(SELECT MovieId
	FROM Movie
	WHERE CategoryId=1
	);
--Show the movies with categoryId equal to 1, if they exist

SELECT EditionYear, StartDate, EndDate
FROM Edition
WHERE EXISTS
	(SELECT EditionYear
	FROM Edition
	WHERE EditionYear BETWEEN 2017 AND 2020
	);

--FROM
SELECT CategoryName
FROM 
	(SELECT CategoryId, CategoryName, EditionYear
	FROM Category
	WHERE EditionYear=2019) AS categories
GROUP BY CategoryName
--The categories from the edition year 2019

SELECT Title
FROM 
	(SELECT MovieId, Title, Genre
	FROM Movie
	WHERE MovieId in (2,3)) as Titles
-- The titles of the movies having Ids in (2,3)

--GROUP BY
SELECT COUNT(Genre) as Movies, Genre
FROM Movie
GROUP BY Genre
--See how many movies there are from each Genre

SELECT Title, Lenght
FROM Movie
GROUP BY Lenght, Title
HAVING Lenght >
	(SELECT Min(Lenght)
	FROM Movie)
ORDER BY Lenght DESC;
--See all the movies with len bigger than the minimum ordered in decreasing order of length

SELECT Lenght, Title
FROM Movie
GROUP BY Title, Lenght
HAVING Lenght>
	(SELECT AVG(Lenght)
	FROM Movie);
--The movies that are longer than average

SELECT Lenght, Title
FROM Movie
GROUP BY Title, Lenght, CategoryId
HAVING Lenght<(SELECT SUM(Lenght) FROM Movie)
	AND (CategoryId=1);
--Movies with a lenght smaller than the sum of all legths and categoryId = 1

--ANY and ALL
SELECT * 
FROM Movie
WHERE MovieId = ANY
	(SELECT MovieId
	FROM Movie
	WHERE Lenght > 100)
--lists the movies if it finds ANY movies in the table that have length > 100

SELECT * 
FROM Movie
WHERE MovieId IN
	(SELECT MovieId
	FROM Movie
	WHERE Lenght > 100)
--rewritten using IN

SELECT * 
FROM Movie
WHERE MovieId = ANY
	(SELECT MovieId
	FROM Movie
	WHERE Lenght < 130)
--lists the movies if it finds ANY movies in the table that have length < 130

SELECT *
FROM Movie
WHERE MovieId NOT IN
	(SELECT MovieId
	FROM Movie
	WHERE Lenght >= 130)
--rewritten using NOT IN


SELECT * 
FROM Category
WHERE CategoryId = ALL
	(SELECT CategoryId
	FROM Movie
	WHERE Genre LIKE '%Drama%')
--ALL categories with Drama movies

SELECT *
FROM Movie
WHERE Lenght > ALL
	(SELECT Lenght
	FROM Movie
	WHERE Lenght <=
		(SELECT AVG(Lenght)
		FROM Movie)
	)
--ALL movies with length bigger than average

SELECT *
FROM Movie
WHERE Lenght >
	(SELECT AVG(Lenght)
	FROM Movie)
--rewritten with the operator AVG
