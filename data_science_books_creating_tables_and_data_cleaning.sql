--creating 'price' table
CREATE TABLE price(
title VARCHAR(500),
author VARCHAR (100),
price NUMERIC,
ISBN_13 VARCHAR(100) PRIMARY KEY)

--importing data
COPY price FROM '/private/tmp/price.csv' DELIMITER ',' CSV HEADER;

--cleaning data
--checking duplicates
SELECT * 
FROM price AS p
WHERE (SELECT COUNT(*) FROM price AS r
WHERE p.isbn_13 = r.isbn_13) > 1;

--fixing 'author' column
UPDATE price
SET author= INITCAP(SUBSTRING(author,2,LENGTH(author)-2));

SELECT *
FROM price;

--creating 'rating' table
CREATE TABLE rating(
title VARCHAR(500) PRIMARY KEY,
author VARCHAR(200),
avg_reviews NUMERIC,
n_reviews INTEGER,
star5 NUMERIC,
star4 NUMERIC,
star3 NUMERIC,
star2 NUMERIC,
star1 NUMERIC
)

--importing data
copy rating FROM '/private/tmp/rating.csv' DELIMITER ',' CSV HEADER;

--cleaning data
--fixing 'author' column
UPDATE rating
SET author= INITCAP(SUBSTRING(author,2,LENGTH(author)-2));

SELECT *
FROM rating;

--creating 'physical properties' table
CREATE TABLE physical_properties(
ISBN_13 VARCHAR(100) PRIMARY KEY,
pages INTEGER,
dimensions VARCHAR(50),
weight VARCHAR
)

--importing data
COPY physical_properties FROM '/private/tmp/physical_properties.csv' DELIMITER ',' CSV HEADER;


--cleaning data
--separating the 'dimensions' into 3 different columns
--(empty and NULL cells should show '0', cut off inches from 2nd and 3rd column,
--convert datatype to numeric)
ALTER TABLE physical_properties
ADD COLUMN dimension_a_inch VARCHAR(50),
ADD COLUMN dimension_b_inch VARCHAR(50),
ADD COLUMN dimension_c_inch VARCHAR(50);

SELECT isbn_13, dimensions
FROM physical_properties
WHERE dimensions IS NULL;

UPDATE physical_properties
SET dimensions=0 
WHERE dimensions IS NULL;

UPDATE physical_properties
SET dimension_a_inch=SPLIT_PART(dimensions, ' x ', 1),
	dimension_b_inch=SPLIT_PART(dimensions, ' x ', 2),
	dimension_c_inch=SPLIT_PART(dimensions, ' x ', 3);

UPDATE physical_properties
SET dimension_b_inch= SPLIT_PART(dimension_b_inch,' ',1),
	dimension_c_inch= SPLIT_PART(dimension_c_inch,' ',1);

SELECT dimension_b_inch, dimension_c_inch
FROM physical_properties
WHERE dimension_b_inch='' OR dimension_c_inch='';

UPDATE physical_properties
SET dimension_b_inch=0 
WHERE dimension_b_inch='';

UPDATE physical_properties
SET dimension_c_inch=0 
WHERE dimension_c_inch='';

ALTER TABLE physical_properties
ALTER COLUMN dimension_a_inch TYPE NUMERIC USING dimension_a_inch::NUMERIC,
ALTER COLUMN dimension_b_inch TYPE NUMERIC USING dimension_b_inch::NUMERIC,
ALTER COLUMN dimension_c_inch TYPE NUMERIC USING dimension_c_inch::NUMERIC;

--unifying 'weight' column to show everything in pounds without 'pounds' attached
--turning empty and null cells to '0's
--convert its datatype to numeric

UPDATE physical_properties
SET weight=0
WHERE weight IS NULL or weight='';

ALTER TABLE physical_properties
ADD COLUMN weight_pounds VARCHAR(50);

UPDATE physical_properties
SET weight_pounds=SPLIT_PART(weight, ' ', 1);

ALTER TABLE physical_properties
ALTER COLUMN weight_pounds TYPE NUMERIC USING weight_pounds::NUMERIC;

UPDATE physical_properties
SET weight_pounds=CASE
	WHEN weight LIKE '%pounds' THEN weight_pounds
	WHEN weight LIKE '%ounces' THEN weight_pounds*0.0625
	END;
	
SELECT*
FROM physical_properties;







