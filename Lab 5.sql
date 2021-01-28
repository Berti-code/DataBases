/*
The 3 tables:
Director
Category
Movie
*/

SELECT * FROM Director
SELECT * FROM Category
SELECT * FROM Movie

/*
UPDATE Director
SET Age = 87
WHERE DirectorId = 1;

UPDATE Director
SET Genre = 'Male'
WHERE DirectorId = 1;
*/

--a.) Queries on Director
--Clustered Index Scan
SELECT DirectorId, Name
FROM Director

--Clustered Index Seek
SELECT DirectorId, Name
FROM Director
WHERE DirectorId BETWEEN 0 AND 3

--NonClustered Index Scan
--CREATE NONCLUSTERED INDEX index_Age ON Director(Age)
SELECT Age
FROM Director

--NonClustered Index Seek
SELECT Age
FROM Director
WHERE Age BETWEEN 70 AND 90

--Lookup
SELECT *
FROM Director
WHERE Age = 87

--b.) Queries on Category
--Create a nonclustered index that can speed up the query. Examine the execution plan again.
--Original
SELECT EditionYear
FROM Category
WHERE EditionYear = 2019

--Create a nonclustered index
GO
CREATE NONCLUSTERED INDEX EditionYear_Category_Index
	ON Category(EditionYear);
GO

--Run with nonclustered index
SELECT EditionYear
FROM Category
WHERE EditionYear = 2019

/*
--Delete Index
GO
DROP EditionYear_Category_Index ON Category
GO
*/

--c.) Create a view that joins at least 2 tables.
GO
CREATE OR ALTER VIEW MovieCategory AS
SELECT Category.CategoryId AS Id, CategoryName
FROM Category INNER JOIN Movie ON Category.CategoryId = Movie.CategoryId
GO

SELECT *
FROM MovieCategory