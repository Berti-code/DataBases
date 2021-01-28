/*create database CannesFilmFestival;*/

use CannesFilmFestival;

create table Edition(
EditionYear int not null PRIMARY KEY,
StartDate  varchar(50),
EndDate  varchar(50)
);

create table Category(
CategoryId int not null PRIMARY KEY,
CategoryName varchar(50),
EditionYear int FOREIGN KEY REFERENCES Edition(EditionYear)
);

create table Award(
AwardId int not null PRIMARY KEY,
Prize varchar(50),
Nominations int,
CategoryId int FOREIGN KEY REFERENCES Category(CategoryId)
);

create table Agent(
AgentId int not null PRIMARY KEY,
Name varchar(50),
Age int,
Gender varchar(50)
);

create table Actor(
ActorId int not null PRIMARY KEY,
Name varchar(50),
Age int,
Genre varchar(50),
Awards varchar(50),
AgentId int FOREIGN KEY REFERENCES Agent(AgentId)
);

create table Director(
DirectorId int not null PRIMARY KEY,
Name varchar(50),
Age int,
Genre varchar(50)
);

create table Producer(
ProducerId int not null PRIMARY KEY,
Name varchar(50),
Age int,
Genre varchar(50),
Awards varchar(50)
);

create table ScreenWriter(
ScreenWriterId int not null PRIMARY KEY,
Name varchar(50),
Age int,
Genre varchar(50),
Awards varchar(50)
);

create table Movie(
MovieId int not null PRIMARY KEY,
Title varchar(50),
Genre varchar(50),
Description varchar(50),
Lenght int,
CategoryId int FOREIGN KEY REFERENCES Category(CategoryId),
DirectorId int FOREIGN KEY REFERENCES Director(DirectorId),
ScreenWriterId int FOREIGN KEY REFERENCES ScreenWriter(ScreenWriterId),
ProducerId int FOREIGN KEY REFERENCES Producer(ProducerId)
);

create table Contract(
ContractId int not null PRIMARY KEY,
Age int,
Genre varchar(50),
Awards varchar(50),
MovieId int FOREIGN KEY REFERENCES Movie(MovieId),
ActorId int FOREIGN KEY REFERENCES Actor(ActorId)
);