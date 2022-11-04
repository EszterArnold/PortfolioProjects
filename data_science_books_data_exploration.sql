--Exploring data of price table

--What is the most expensive data science book available on Amazon?
SELECT title, author, price
FROM price
WHERE price!=0
ORDER BY price DESC
LIMIT 1;

--How many of the cheapest book could you buy from the price of the most expensive one?
SELECT ROUND(MAX(price)/MIN(price))
FROM price;

--How many different authors have books available?
--(If there is more than one author, then it treats them as a pair, not looking individually.)
SELECT COUNT(DISTINCT author)
FROM price;

--Who are the authors who have multiple books available, starting with the one that has the most?
--(If there is more than one author, then it treats them as a pair, not looking individually.)
SELECT author,COUNT(author) AS number_of_books
FROM price
WHERE author IS NOT NULL
GROUP BY author
ORDER BY number_of_books DESC;

--Looking for authors with the first name 'Eric' or similar.
SELECT DISTINCT author
FROM price
WHERE author ILIKE 'Eric%';

--Exploring data of physical_properties table

--If I wanted to read all of the books, how many pages would that mean?
SELECT SUM(pages)
FROM physical_properties;

--How many of the books could NOT fit into a standard backpack,
--with dimensions 8*3.75*10.25 inches, one by one?
SELECT COUNT(isbn_13)
FROM physical_properties
WHERE dimension_a_inch>8 OR
	dimension_b_inch>3.75 OR
	dimension_c_inch>10.25;

--Exploring the rating table

--It only makes sense to work with a subset of data, where the review columns are not empty. #temptables
CREATE TEMP TABLE temp_rating(
title VARCHAR(500) PRIMARY KEY,
author VARCHAR(200),
avg_reviews NUMERIC,
n_reviews INTEGER,
star5 NUMERIC,
star4 NUMERIC,
star3 NUMERIC,
star2 NUMERIC,
star1 NUMERIC
);

INSERT INTO temp_rating(
SELECT *
FROM rating
WHERE avg_reviews IS NOT NULL);

	
--What are the books with the maximum rating?
SELECT title, avg_reviews
FROM temp_rating
WHERE avg_reviews=5
ORDER BY title;

--Out of the books with a rating between 4 and 5 which ones have the most 1star reviews? 
SELECT title, star1
FROM temp_rating
WHERE avg_reviews BETWEEN 4 AND 5 
ORDER BY star1 DESC;

--Categorize the books; the 5star-rated ones should be labeled 'super', #case
--4-5 as 'good', 3-4 as 'OK' and 1-2 as 'bad'.
SELECT title,avg_reviews,
 CASE WHEN avg_reviews=5 THEN 'fantastic'
 	  WHEN avg_reviews<5 AND avg_reviews>=4 THEN 'good'
	  WHEN avg_reviews<4 AND avg_reviews>=3 THEN 'OK'
      WHEN avg_reviews<3 THEN 'bad'
 ELSE 'no reviews'
 END
FROM rating;

--List the ISBN numbers and the price of all the books that have at least a 200 reviews,
--starting with the best rating. #joins
SELECT p.isbn_13, p.price
FROM rating AS r
JOIN price AS p
	ON p.title=r.title
WHERE r.n_reviews>200
ORDER BY r.avg_reviews DESC;

--Which book offers the "cheapest pages"? #joins
SELECT title,p.isbn_13, p.price/pp.pages AS price_per_page
FROM price AS p
JOIN physical_properties AS pp
	ON p.isbn_13=pp.isbn_13
ORDER BY p.price/pp.pages
LIMIT 1;

--List the books with 5 star average rating, that are under 15USD and start with the longest?
SELECT r.title, r.avg_reviews, p.price, pp.pages
FROM rating AS r
JOIN price AS p
	ON r.title=p.title
JOIN physical_properties AS pp
	ON p.isbn_13=pp.isbn_13
WHERE r.avg_reviews=5 AND p.price<15
ORDER BY pp.pages DESC;

