USE CannesFilmFestival

/*
-a table with a single-column primary key and no foreign keys;
-a table with a single-column primary key and at least one foreign key;
-a table with a multicolumn primary key;
*/
SELECT * 
FROM Director

SELECT *
FROM Category

SELECT *
FROM Movie

--Views
--View with SELECT on a table
GO
CREATE VIEW OldDirectors AS
SELECT *
FROM Director
WHERE Age BETWEEN 80 AND 90

SELECT * 
FROM OldDirectors

--View with SELECT on two tables
GO
CREATE VIEW MoviesAndCategories AS
SELECT Movie.CategoryId AS Id, Title, Category.CategoryName, Genre
FROM Movie INNER JOIN Category ON Movie.CategoryId = Category.CategoryId

SELECT * 
FROM MoviesAndCategories

--View with SELECT on two tables having a GROUP BY clause
GO
CREATE VIEW EditionsAndCategories AS
SELECT Edition.EditionYear
FROM Edition INNER JOIN Category ON Edition.EditionYear = Category.EditionYear
GROUP BY Edition.EditionYear
--Edition years that have categories

SELECT * 
FROM EditionsAndCategories

--Creating a procedure for adding into tables
GO
CREATE OR ALTER PROCEDURE InsertInTable
	@rowNumber int,
	@tableName varchar(50)
AS
BEGIN
	DECLARE @index int;
	SET @index = 1;
	WHILE @index <= @rowNumber
	BEGIN
		EXECUTE ('INSERT INTO ' + @tableName + ' DEFAULT VALUES')
		SET @index = @index + 1
	END
END