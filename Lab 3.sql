USE CannesFilmFestival

SELECT * FROM Movie

--Add table
GO
CREATE PROCEDURE CreateTable
AS
	GO
	CREATE TABLE ActorCopy(
	ActorId int not null,
	Name varchar(50),
	Age int,
	Genre varchar(50),
	Awards varchar(50),
	AgentId int not null
	)

	UPDATE CurrentVersion
	SET CUrrentVersion = 2
	WHERE CurrentVersion = 1

EXEC CreateTable

GO
CREATE PROCEDURE DeleteTable
AS
	GO
	DROP TABLE ActorCopy

	UPDATE CurrentVersion
	SET CurrentVersion = 1
	WHERE CurrentVersion = 2


EXEC DeleteTable

--Modify column type
GO
CREATE PROCEDURE UpdateColumn
AS
	GO
	ALTER TABLE Actor
	ALTER COLUMN ActorId varchar(5)

	UPDATE CurrentVersion
	SET CurrentVersion = 3
	WHERE CurrentVersion = 2

EXEC UpdateColumn

GO
CREATE PROCEDURE RestoreColumn
AS
	GO
	ALTER TABLE Actor
	ALTER COLUMN ActorId int

	UPDATE CurrentVersion
	SET CurrentVersion = 2
	WHERE CurrentVersion = 3

EXEC RestoreColumn

--Add a column
GO
CREATE PROCEDURE AddColumn
AS
	GO
	ALTER TABLE ActorCopy
	ADD newColumn int

	UPDATE CurrentVersion
	SET CurrentVersion = 4
	WHERE CurrentVersion = 3

EXEC AddColumn

GO
CREATE PROCEDURE DeleteColumn
AS
	GO
	ALTER TABLE ActorCopy
	DROP COLUMN newColumn
	
	UPDATE CurrentVersion
	SET CurrentVErsion = 3
	WHERE CurrentVersion = 4

EXEC DeleteColumn

--Add primary key
GO
CREATE PROCEDURE AddPrimaryKey
AS
	GO
	ALTER TABLE ActorCopy
	ADD CONSTRAINT pk_ActorId PRIMARY KEY (ActorId)

	UPDATE CurrentVersion
	SET CurrentVErsion = 5
	WHERE CurrentVersion = 4

EXEC AddPrimaryKey

GO
CREATE PROCEDURE DeletePrimaryKey
AS
	GO
	ALTER TABLE ActorCopy
	DROP CONSTRAINT pk_ActorId

	UPDATE CurrentVersion
	SET CurrentVErsion = 4
	WHERE CurrentVersion = 5

EXEC DeletePrimaryKey

--Add foreign key
GO
CREATE PROCEDURE AddForeignKey
AS
	GO
	ALTER TABLE ActorCopy
	ADD CONSTRAINT fk_AgentId FOREIGN KEY (AgentId) References Agent(AgentId)

	UPDATE CurrentVersion
	SET CurrentVErsion = 6
	WHERE CurrentVersion = 5

EXEC AddForeignKey

GO
CREATE PROCEDURE DeleteForeignKey
AS
	GO
	ALTER TABLE ActorCopy
	DROP CONSTRAINT fk_AgentId

	UPDATE CurrentVersion
	SET CurrentVErsion = 5
	WHERE CurrentVersion = 6

EXEC DeleteForeignKey

--Add default constraint
GO
CREATE PROCEDURE AddDefaultValue
AS
	GO
	ALTER TABLE ActorCopy
	ADD CONSTRAINT df_newColumn
	DEFAULT 'default' FOR newColumn

EXEC AddDefaultValue

GO
CREATE OR ALTER PROCEDURE DeleteDefault
AS
	GO
	ALTER TABLE ActorCopy
	DROP df_newColumn


--Current version
CREATE TABLE CurrentVersion(
CurrentVersion int not null)

INSERT INTO CurrentVersion
VALUES(1)

SELECT * FROM CurrentVersion

--Add version

CREATE TABLE Versions(
OldVer int not null,
NewVer int not null,
Operation varchar(100),
NameOfProc varchar(100))

select * from Versions

insert into Versions
values(1,2,'Creates table','CreateTable')

insert into Versions
values(2,1,'Deletes Table','DeleteTable')

insert into Versions
values(2,3,'Updates column','UpdateColumn')

insert into Versions
values(3,2,'Restores column','RestoreColumn')

insert into Versions
values(3,4,'Adds column','AddColumn')

insert into Versions
values(4,3,'Deletes column','DeleteColumn')

insert into Versions
values(4,5,'Adds primary key','AddPrimaryKey')

insert into Versions
values(5,4,'Deletes primary key','DeletePrimaryKey')

insert into Versions
values(5,6,'Adds foreign key','AddForeignKey')

insert into Versions
values(6,5,'Deletes foreign key','DeleteForeignKey')

--Version control
GO
CREATE PROCEDURE VersionControl
@NewVer int
AS
BEGIN
	DECLARE @description varchar(100)
	DECLARE @procedure varchar(100)
	WHILE (SELECT * FROM CurrentVersion) <> @NewVer
		IF (@NewVer NOT IN (1,2,3,4,5,6))
		BEGIN
			RAISERROR('Incorrect version!',18,0)
			RETURN
		END

		ELSE IF (@NewVer > (SELECT * FROM CurrentVersion))
		BEGIN
			SELECT @description = Operation, @procedure = NameOfProc FROM Versions WHERE OldVer = (SELECT * FROM CurrentVersion) AND NewVer = OldVer + 1 
			EXEC @procedure
			PRINT @description
		END

		ELSE IF (@NewVer < (SELECT * FROM CurrentVersion))
		BEGIN
			SELECT @description = Operation, @procedure = NameOfProc FROM Versions WHERE OldVer = (SELECT * FROM CurrentVersion) AND NewVer = OldVer - 1 
			EXEC @procedure
			PRINT @description
		END
END

EXEC VersionControl @NewVer = 6

SELECT * FROM CurrentVersion

SELECT * FROM ActorCopy