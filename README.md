<p align = "center">
	<img src="https://user-images.githubusercontent.com/126125206/232331834-ad55c64c-a487-4939-8b45-33198c477b44.jpg" width="285" height="170"/>
	
<h1 align="center"> COVID-19 Analysis </h1>

### Contents: 
* [Introduction](https://github.com/azap2124/covid_analysis/edit/main/README.md#introduction)
* [Preparing the Data](https://github.com/azap2124/covid_analysis/edit/main/README.md#preparing-the-data)
* [Processing the Data](https://github.com/azap2124/covid_analysis/edit/main/README.md#processing-the-data)
* [Analyzing Insights](https://github.com/azap2124/covid_analysis/edit/main/README.md#analysing-insights)
* [Sharing My Results](https://github.com/azap2124/covid_analysis/edit/main/README.md#sharing-my-results)
* [Conclusion](https://github.com/azap2124/covid_analysis/edit/main/README.md#conclusion)
  
 # Introduction 
 The ongoing COVID-19 pandemic has significantly affected our daily lives. This data analysis aims to provide an exploratory examination of infection rates, deaths, and vaccination rates.  
 
 Additionally, special attention will be given to the impacts of COVID-19 on the island of Puerto Rico, as it holds personal significance as my birthplace. By 2020, the island was starting to recover from two category 5 hurricanes and a 6.4 earthquake right in the beginning of 2020.   
 
 Tools used: 
 * Microsoft Excel
 * SQL Server Management Studio
 * [Tableau Dashboard](https://public.tableau.com/views/CovidProject_16820174746020/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)
 
 ### The Data
I utilized a dataset from Our World in Data, a non-profit scientific online publication website that addresses critical global issues, including poverty, disease, hunger, climate change, war, existential risks, and inequality. You can access the dataset through this link: https://ourworldindata.org/covid-deaths  
	
The dataset I used is extensive and has been consistently updated on a daily basis since the start of the COVID-19 pandemic. For my analysis, I specifically focused on key aspects of the dataset, including population, dates, locations, cases, deaths, and vaccinations.  

# Preparing the Data
### Data Source
From the dataset downloaded (owid-covid-data), I created the following files to further investigate: 
* covid_deaths: emphasizes population, new cases, and death rates for each country. 
* covid_vaccinations: emphasizes vaccination rates for each country.

# Processing the Data
### Cleaning the Data
As part of my data cleaning process, I utilized SQL Server's Design tool to update data types to INT/FLOAT. This was necessary to perform calculations without encountering error messages. Additionally, I had to replace certain zeros in the columns with NULL values using the following code:
```
--- Changing zeros to NULLs in order to perform calculations 
UPDATE covid_deaths
SET continent = NULL
WHERE continent = 0;

UPDATE covid_deaths
SET total_cases = NULL
WHERE total_cases = 0;

UPDATE covid_deaths
SET total_deaths = NULL
WHERE total_deaths = 0;

--- Setting blank spaces to NULLs in the continent column 
UPDATE covid_deaths
SET continent = NULL
WHERE continent='';
```

# Analysing Insights
### First look at the data: 
```
--- Selecting data we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;
```
I was interested in analyzing the situation in Puerto Rico during the pandemic. Unfortunately, the initial findings were concerning, as the island had already recorded its first death out of the 24 reported cases within the first three months of 2020. 
```
--- Total cases vs Total deaths in Puerto Rico
SELECT location, date, total_cases, total_deaths, 
	ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location = 'Puerto Rico' AND continent IS NOT NULL
ORDER BY location, date;

SELECT location, date, total_cases, total_deaths, 
	ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location = 'United States' AND continent IS NOT NULL
ORDER BY location, date;
```
As of March 19th 2020, the death rate in Puerto Rico had reached 4% compared to total cases, indicating a significant and concerning impact of the pandemic on the island. 

<img width="474" alt="initial deaths in pr " src="https://user-images.githubusercontent.com/126125206/232587639-95ffb3b3-4cc4-4562-9775-2a577869c4f8.png">
<img width="474" alt="initial deaths in us " src="https://user-images.githubusercontent.com/126125206/232593180-4e6730bd-9dfa-48db-9222-7abb90b943f5.png">

### Looking at total cases vs population 
As of the day I downloaded the dataset, which was April 12th, 2023, Puerto Rico had a total of 1,110,017 COVID-19 cases, accounting for 34.12% of its population. In comparison, the United States had 102,873,924 cases, representing 30.41% of its population. 

<img width="474" alt="total cases in us" src="https://user-images.githubusercontent.com/126125206/232635496-ce560c45-5fe5-4863-be22-85d10b8cb38e.png">  
<img width="460" alt="total cases in pr" src="https://user-images.githubusercontent.com/126125206/232635497-bc61a91f-631c-4980-802a-9d48e3137555.png">

```
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
```

### Countries with the **highest infection** rates 
Top 5 countries with highest infection rates: 
1. Cyprus - 655,664 - 73.2% of total population
2. San Marino - 23,873 - 70.8% of total population  
3. Autria - 6,046,956 - 67.6% of total population
4. Faeroe Islands - 34,658 - 65.2% of total population
5. Brunei - 284,632 - 63.4% of total population

Puerto Rico ranked #58 with 1,110,017 total cases or 34.1% of the population. The United States ranked #68 with 102,873,924 total cases or 30.4% of the population. Here's my code: 
```
--- Looking at countries with highest infection rates compared to population
SELECT location, population, 
	MAX(total_cases) AS highest_infection_count, 
	ROUND((MAX(total_cases)/MAX(population)*100),6) AS percentage_population_infected
FROM covid. dbo.covid_deaths
GROUP BY location, population
ORDER BY percentage_population_infected DESC;
```

### Countries with highest death rates
The top 5 countries with the highest death counts were: 
1. United States - 1,118,800
2. Brazil - 700,556
3. India - 531,000
4. Russia - 397,642
5. Mexico - 333,596  

(#84 Puerto Rico - 5,867) 

Nonetheless, these countries have vast amounts of populations due to their size. I decided to look for the top five countries with the highest death rates: 
1. Yemen - 18.07% with 2,159 deaths 
2. Sudan - 7.86% with 5,034 deaths 
3. Syria - 5.5% with 3,163 deaths 
4. Somalia - 4.98% with 1,361 deaths 
5. Peru - 4.89% with 219,866  

(#97 United States - 1.09%) 
(#157 Puerto Rico - 0.53%)  
 
Code: 
```
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
```
### Breaking things down by social class
I was interested in analyzing how each social class was affected during the pandemic. The dataset provided us with three categories: High income, Upper middle income, Lower middle income, and Low income.  
```
--- Breaking things down by social class

SELECT location,
	MAX(CAST(total_deaths AS INT)) AS total_death_count 
FROM covid. dbo.covid_deaths
WHERE continent IS NULL AND location IN ('Low income', 'High income','Upper middle income', 'Lower middle income','Low income')
GROUP BY location
ORDER BY total_death_count DESC;
```
Results: 
High income: 2,850,794
Upper middle income: 2,654,361
Lower middle income: 1,340,036
Low income: 47,888

It can be observed that households categorized as upper and lower middle income, as well as low income, experienced the highest number of total deaths at 4,042,285. This could be attributed to factors such as access to quality healthcare facilities. Notably, low income households had a comparatively lower count of 47,888 deaths, which may seem disproportionately low compared to the other groups. However, it's important to consider that limited access to healthcare services for low income households could potentially lead to underreporting of COVID-19 cases and deaths.

### Global numbers
As of April 12,2023, the total number of confirmed COVID-19 cases is **763,128,258**, with **6,899,687** reported deaths, accounting for approximately **0.904%** of the total cases. I got these numbers from the following code: 
```
--- Global numbers
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths, 
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL;
```

### Vaccinations 
#### Percentage of people vaccinated
I used a CTE to perform calculations. 
```
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
WHERE location = 'United States')
ORDER BY location, date;
``` 
As of April 12, 2023 the total number of people vaccinated in the United States is **338,289,856** or **79.828%** of the total population. 

Initially, I observed that there was no data available for the "new_vaccinations" column for Puerto Rico. In order to investigate this further, I revisited the Excel spreadsheet to analyze the original data. It turns out that Puerto Rico was indeed missing this data. After further investigation in their website, I was not able to find a reason as to why this is. However, [this article](https://www.aha.org/news/blog/2022-07-22-digging-reasons-puerto-ricos-successful-covid-19-response) from the American Hospital Association, estimates that 95% of the population has received at least one dose of the vaccine. As this data is critical for the next part of the project, I decided to exclude Puerto Rico from the analysis.

I created a temp table to summarize all this data by country. 
```
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
``` 

# Sharing My Results 
Here's the link to my [Tableau Dashboard](https://public.tableau.com/views/CovidProject_16820174746020/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link) for this project.  

#### Visualizing total death counts by continent:
*As you can see, Europe had the most death counts with over 2 million deaths. Asia was close second with 1.6 million deaths.
    <br/><br/>
<img width="305" alt="column chart" src="https://user-images.githubusercontent.com/126125206/233473836-ba28a0d2-55f7-4583-ba7c-0c9cc78dbd4b.png">    
    <br/><br/>
  
#### Average of the population infected over three years for Puerto Rico, United States, China, India and Mexico: 
<img width="605" alt="line graph" src="https://user-images.githubusercontent.com/126125206/233473837-2ce9145e-887a-4ebe-9785-68b52e22bc49.png">   
  <br/><br/>
  
#### How each social class was affected by the pandemic (death counts): 
<img width="545" alt="pie chart" src="https://user-images.githubusercontent.com/126125206/233473834-6519ba16-1036-4b2c-afb1-19ee6109567f.png">  
    <br/><br/>
  
#### A map depicting the nations that have the most concentrated COVID-19 cases:
*The darker shaded the country, the highest infection rates.  
<img width="518" alt="map" src="https://user-images.githubusercontent.com/126125206/233473831-87afba1a-56a9-486d-98de-372651ec6a85.png">  
<br></br>

I created the following views for visualization purposes: 
```
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
```
# Conclusion
It's no doubt that COVID-19 has had a huge impacts in our lives. The virus has affected people from all walks of lives. This project demonstrates the significant impact of the pandemic on global healthcare systems, with widespread infections resulting in high death rates and a large number of fatalities. There has been 763,128,258 cases of COVID-19 as of April 12,2023 with over 6,899,687 deaths worldwide. These figures are staggering. Nonetheless, vaccinations have been promising about reducing th number of infections and deaths.

There are significant differences in vaccination rates per country as shown by the data, with some countries having a high percentage of their populations vaccinated and others lagging behind. These differences are likely due to a variety of factors, including vaccine availability and distribution systems.  

Overall, the COVID-19 pandemic has been a global health crisis that has touched the lives of millions of people around the world. While vaccinations offer hope for reducing the number of infections and deaths, it's important to continue to follow public health guidelines and work together to control the spreading of the virus.
