CREATE TABLE geography(
	country_name VARCHAR(50),
	name VARCHAR(200),
	latitude NUMERIC,
	longitude NUMERIC
);

COPY geography FROM '/private/tmp/geography.csv' DELIMITER ',' CSV HEADER;

SELECT *
FROM geography;

ALTER TABLE geography
ADD COLUMN id SERIAL PRIMARY KEY;

CREATE TABLE fuel(
	name VARCHAR(200),
	latitude NUMERIC,
	longitude NUMERIC,
	primary_fuel VARCHAR(50),
	secondary_fuel VARCHAR(50),
	other_fuel2 VARCHAR(50),
	other_fuel3 VARCHAR(50)
);

COPY fuel FROM '/private/tmp/fuel.csv' DELIMITER ',' CSV HEADER;

SELECT *
FROM fuel;

ALTER TABLE fuel
ADD COLUMN id SERIAL PRIMARY KEY;

CREATE TABLE owner(
	country_code VARCHAR(10),
	name VARCHAR(200),
	owner VARCHAR(200),
	start_year INTEGER
);

COPY owner FROM '/private/tmp/owner.csv' DELIMITER ',' CSV HEADER;

SELECT *
FROM owner;

ALTER TABLE owner
ADD COLUMN id SERIAL PRIMARY KEY;

CREATE TABLE power_generation(
	name VARCHAR(200),
	capacity_MW NUMERIC,
	generation_gwh_2021 NUMERIC,
	estimated_generation_gwh_2021 NUMERIC
);

COPY power_generation FROM '/private/tmp/power_generation.csv' DELIMITER ',' CSV HEADER;

SELECT *
FROM power_generation;

ALTER TABLE power_generation
ADD COLUMN id SERIAL PRIMARY KEY;

CREATE TABLE population(
	country_name VARCHAR(200),
	country_code VARCHAR(5) PRIMARY KEY,
	population_2021 NUMERIC
);

COPY population FROM '/private/tmp/world_bank_population.csv' DELIMITER ',' CSV HEADER;

SELECT *
FROM population;



