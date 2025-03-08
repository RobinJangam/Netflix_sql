-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(show_id VARCHAR(6),
type VARCHAR (10),
title VARCHAR (150),
director VARCHAR (210),
casts VARCHAR(1000),
country VARCHAR (150),
date_added VARCHAR (50),
release_year INT,
rating VARCHAR (10),
duration VARCHAR (15),
listed_in VARCHAR (100),
description VARCHAR (250));


SELECT * FROM netflix;


SELECT COUNT (*) as total_content
FROM netflix;

-- 15 Business Problems

-- Q.1 Count the Number of Movies vs TV Shows

SELECT type,
count(*) as total_content
FROM netflix
GROUP BY type

-- Q.2 Find the Most Common Rating for Movies and TV Shows

SELECT 
type,
rating
FROM
(SELECT 
type,
rating,
COUNT (*),
RANK () OVER(PARTITION BY type ORDER BY COUNT (*) DESC) as ranking
FROM netflix
GROUP BY 1, 2) as T1
WHERE ranking = 1

-- Q.3 List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM netflix
WHERE 
type = 'movie'
AND
release_year = 

--Q.4 Find the Top 5 Countries with the Most Content on Netflix

SELECT UNNEST (STRING_TO_ARRAY(COUNTRY,',')) as new_country,
COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.5 Identify the Longest Movie

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

-- Q.6 Find Content Added in the Last 5 Years

SELECT * 
FROM netflix
WHERE
TO_DATE(date_added,'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years'

-- Q.7 Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- Q.8 List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE 
type = 'TV Show'
AND
SPLIT_PART(duration, ' ', 1):: numeric > 5


-- Q.9 Count the Number of Content Items in Each Genre

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1


-- Q.10 Find each year and the average numbers of content release in India on netflix.


SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
COUNT(*),
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix
WHERE country = 'India')::numeric *100,2) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--Q.11 List All Movies that are Documentaries

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'


-- Q.12 Find All Content Without a Director

SELECT * FROM netflix
WHERE director IS NULL


-- Q.13 Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- Q.14 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- Q.15 Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

WITH new_table as 
(SELECT *, 
CASE 
WHEN description ILIKE '%kill%' OR description ILIKE '%violence%'
THEN 'Bad_Content'
ELSE 'Good Content'
END category 
FROM netflix)

SELECT category,
COUNT(*) as total_content
FROM new_table
GROUP BY 1













