
/*
IMDB Data Exploration 

Skills Used - Joins, Index, Temp Tables, Subqueries, Window Functions, Aggregate functions.

*/



-- Distinct genres and their count

SELECT Distinct(genre), Count(genre) 
FROM genres
Group By genre;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Min rating, Max rating and Avg ratings of all the content.

SELECT min(rating)as minScore, max(rating) as maxScore, avg(rating) as AvgRating 
FROM ratings;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Total votes casted On IMDB

SELECT sum(votes) as Totalvotes 
FROM ratings;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- All the shows Steve carell featured in

--Using Nested Queries

SELECT title from shows 
Where id in (Select show_id from stars Where person_id = (Select id from people Where name = 'Steve Carell'))
Order by title;

-- Using JOIN

SELECT title FROM people
JOIN stars ON  people.id = stars.person_id
JOIN shows ON stars.show_id = shows.id
Where name = 'Steve Carell'



-- All the Shows Bryan cranston featured in Using Nested Queries

Select title from shows 
Where id in (Select show_id from stars Where person_id = (Select id from people Where name = 'Bryan Cranston'))
ORDER By title; 


-----------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Joining Tables */




-- Highest rated Shows based on rating

SELECT  distinct(id), title, year, episodes, rating, votes
From shows Join genres
On shows.id = genres.show_id
Join ratings 
On shows.id = ratings.show_id
Where votes &gt;10000
Order By rating desc, votes desc


-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Highest rated Shows based on votes

SELECT  distinct(id), title, year, episodes, rating, votes
From shows Join genres
On shows.id = genres.show_id
Join ratings 
On shows.id = ratings.show_id
Order By votes desc


-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- All the Shows Bryan Cranston featured in with ratings

SELECT * FROM people
JOIN stars ON people.id = stars.person_id
JOIN shows ON stars.show_id = shows.id
JOIN ratings ON stars.show_id = ratings.show_id
JOIN genres ON stars.show_id = genres.show_id
WHERE name = 'Bryan Cranston'
GROUP By title, rating, year
ORDER By rating DESC


-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Temp Tables



CREATE TEMP TABLE Data

(

name TEXT,

title TEXT,

rating REAL,

year NUMERIC,

genre TEXT

);





INSERT INTO Data

SELECT name, title, rating, year , genre FROM people

JOIN stars ON people.id = stars.person_id

JOIN shows ON stars.show_id = shows.id

JOIN ratings ON stars.show_id = ratings.show_id

JOIN genres ON stars.show_id = genres.show_id

--WHERE name = 'Bryan Cranston'

GROUP By title, rating, year

--ORDER By rating DESC



Select title,  genre,

Avg(rating) OVER (Partition By genre) as AvgRating

From Data





Select *,

row_number() OVER (Partition By year Order by rating DESC) as rowNum

From Data


-----------------------------------------------------------------------------------------------------------------------------------------------------------------



-- To make the search faster

/*Create Index name on Table(column,....)*/


CREATE Index title_index on Shows(title);

select * from shows
where title = 'The Office'











</sql><current_tab id="0"/></tab_sql></sqlb_project>
