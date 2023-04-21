--- Selecting table
SELECT *
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL 
ORDER BY location;


--- Selecting data we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;


--- Total cases vs Total deaths in Puerto Rico and the US
SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location = 'Puerto Rico' AND continent IS NOT NULL
ORDER BY location, date;

SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location = 'United States' AND continent IS NOT NULL
ORDER BY location, date;


--- Total cases vs Population
SELECT location, date, population, total_cases, 
	ROUND(total_cases/population,6)*100 AS percentage_population_infected
FROM covid. dbo.covid_deaths
WHERE location = 'Puerto Rico'
ORDER BY percentage_population_infected DESC;

SELECT location, date, population, total_cases, 
	ROUND(total_cases/population,6)*100 AS percentage_population_infected
FROM covid. dbo.covid_deaths
WHERE location = 'United States'
ORDER BY percentage_population_infected DESC;


--- Looking at countries with highest infection rates compared to population
SELECT location, population, 
	MAX(total_cases) AS highest_infection_count, 
	ROUND((MAX(total_cases)/MAX(population)*100),6) AS percentage_population_infected
FROM covid. dbo.covid_deaths
GROUP BY location, population
ORDER BY percentage_population_infected DESC;


--- Looking at countries with highest infection rates compared to population with dates
SELECT location, population, date,  
		MAX(total_cases) AS highest_infection_count, 
		ROUND((MAX(total_cases)/MAX(population)*100),6) AS percentage_population_infected
FROM covid. dbo.covid_deaths
GROUP BY location, population, date
ORDER BY percentage_population_infected DESC;


--- Showing countries with the highest death rates compared to total cases
SELECT TOP 5 location,
       MAX(total_deaths) AS total_deaths
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC;

SELECT TOP 5 location,
	   MAX(total_cases) AS total_cases,
       MAX(total_deaths) AS total_deaths,
       ROUND(MAX(total_deaths)/MAX(total_cases)*100, 4) AS death_rate
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_rate DESC;

SELECT location,
       MAX(total_deaths) AS total_deaths
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC;

SELECT location,
	   MAX(total_cases) AS total_cases,
       MAX(total_deaths) AS total_deaths,
       ROUND(MAX(total_deaths)/MAX(total_cases)*100, 4) AS death_rate
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_rate DESC;


--- Breaking things down by social class
SELECT location,
	MAX(CAST(total_deaths AS INT)) AS total_death_count 
FROM covid. dbo.covid_deaths
WHERE continent IS NULL AND location IN ('Low income', 'High income','Upper middle income', 'Lower middle income','Low income')
GROUP BY location
ORDER BY total_death_count DESC;


--- Global numbers
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths, 
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL;


---Joining tables
SELECT * 
FROM covid..covid_deaths AS dea
JOIN covid..covid_vaccinations AS vac
	ON dea.location = vac.location AND dea.date = vac.date;


--- Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, 
	MAX(vac.people_vaccinated) OVER (PARTITION BY dea.location ORDER BY dea. location, dea.date) AS total_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;

SELECT dea.continent, dea.location, dea.date, dea.population,
	MAX(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date;


--- Use CTE
WITH pop_vs_vac(continent, location, date, population, people_vaccinated)
AS 
(
    SELECT dea.continent, dea.location, dea.date, dea.population, 
	MAX(vac.people_vaccinated) OVER (PARTITION BY dea.location ORDER BY dea. location, dea.date) AS total_people_vaccinated
    FROM covid..covid_deaths dea
    JOIN covid..covid_vaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
    ROUND((people_vaccinated/population)*100,5) AS percent_vaccinated
FROM pop_vs_vac
ORDER BY location, date


--- Temp table
DROP TABLE IF EXISTS percent_population_vaccinated_by_country
CREATE TABLE percent_population_vaccinated_by_country
(
continent NVARCHAR(255), 
location NVARCHAR(255), 
date DATETIME, 
population NUMERIC,
total_people_vaccinated NUMERIC
);

INSERT INTO percent_population_vaccinated_by_country
SELECT dea.continent, dea.location, dea.date, dea.population, 
MAX(vac.people_vaccinated) OVER (PARTITION BY dea.location ORDER BY dea. location, dea.date) AS total_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date;

SELECT location, 
       MAX(population) AS population, 
       MAX(total_people_vaccinated) AS total_people_vaccinated,
       (MAX(total_people_vaccinated) / MAX(population)) * 100 AS percent_vaccinated
FROM percent_population_vaccinated_by_country
GROUP BY location
ORDER BY percent_vaccinated DESC;


--- Creating views to store data for later visualization
GO

CREATE VIEW death_percentage_world AS 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL;

GO

CREATE VIEW highest_infection_rate AS
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((ROUND(total_cases/population,6)*100)) AS percentage_population_infected
FROM covid. dbo.covid_deaths
GROUP BY location, population;


GO

CREATE VIEW death_count_continent AS
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count 
FROM covid. dbo.covid_deaths
WHERE continent IS NULL
GROUP BY location;

GO 

CREATE VIEW global_numbers AS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL;
