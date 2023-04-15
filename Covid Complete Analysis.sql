--- Selecting table
SELECT *
FROM covid.dbo.covid_deaths
WHERE continent IS NOT NULL 
ORDER BY location

--- Selecting data we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid. dbo.covid_deaths
ORDER BY 1,2

--- Total cases vs Total deaths in Puerto Rico
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location='Puerto Rico' AND continent IS NOT NULL
ORDER BY 1,2

--- Total cases vs Population in Puerto Rico
SELECT location, date, population, total_cases, (ROUND(total_cases/population,6)*100) AS percentage_population_infected
FROM covid. dbo.covid_deaths
--- WHERE location='Puerto Rico'
ORDER BY 1,2;

--- Looking at countries with highest infection rates compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((ROUND(total_cases/population,6)*100)) AS percentage_population_infected
FROM covid. dbo.covid_deaths
GROUP BY location, population
ORDER BY percentage_population_infected DESC;

--- Showing countries with the highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count 
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

--- Breaking things down by continents
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count 
FROM covid. dbo.covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;

--- Global numbers
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
--- WHERE location='Puerto Rico' AND continent IS NOT NULL
WHERE continent IS NOT NULL
---GROUP BY date
ORDER BY 1,2


---Joining tables
SELECT * 
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date

--- Total population vs vaccinations
SELECT dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--- (rolling_vaccinations/populations)*100
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


--- Use CTE
WITH pop_vs_vac(continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--- (rolling_vaccinations/populations)*100
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--- ORDER BY 2,3;
)
SELECT *, (rolling_vaccinations/population)*100
FROM pop_vs_vac 


--- Temp table
DROP TABLE IF EXISTS #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated
(
continent NVARCHAR(255), 
location NVARCHAR(255), 
date DATETIME, 
population NUMERIC, 
new_vaccinations NUMERIC,
rolling_vaccinations NUMERIC
)

INSERT INTO #percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--- (rolling_vaccinations/populations)*100
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
--- WHERE dea.continent IS NOT NULL
--- ORDER BY 2,3;

SELECT *, (rolling_vaccinations/population)*100
FROM #percent_population_vaccinated


--- Creating view to store data for later visualization
CREATE VIEW percent_population_vaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--- (rolling_vaccinations/populations)*100
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--- ORDER BY 2,3;