<p align = "center">
	<img src="https://user-images.githubusercontent.com/126125206/232331834-ad55c64c-a487-4939-8b45-33198c477b44.jpg" width="285" height="170"/>
	
<h1 align="center"> COVID-19 Analysis </h1>

### Contents: 
* [Introduction](https://github.com/azap2124/covid_analysis/edit/main/README.md#introduction)
* [Preparing the Data](https://github.com/azap2124/covid_analysis/edit/main/README.md#preparing-the-data)
* [Processing the Data](https://github.com/azap2124/covid_analysis/edit/main/README.md#processing-the-data)
* [Analyzing Insights](https://github.com/azap2124/covid_analysis/edit/main/README.md#analysing-insights)
* [Sharing My Results](https://github.com/azap2124/covid_analysis/edit/main/README.md#sharing-my-results)
  
 # Introduction 
 The ongoing COVID-19 pandemic has significantly affected our daily lives. This data analysis aims to provide an exploratory examination of infection rates, deaths, and vaccination rates.  
 
 Additionally, special attention will be given to the impacts of COVID-19 on the island of Puerto Rico, as it holds personal significance as my birthplace. By 2020, the island was starting to recover from two category 5 hurricanes and a 6.4 earthquake right in the beginning of 2020.   
 
 Tools used: 
 * Microsoft Excel
 * SQL Server Management Studio
 * [Tableau Dashboard](https://public.tableau.com/views/CovidProject_16816646606030/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)
 
 ### The Data
I utilized a dataset from Our World in Data, a non-profit scientific online publication website that addresses critical global issues, including poverty, disease, hunger, climate change, war, existential risks, and inequality. You can access the dataset through this link: https://ourworldindata.org/covid-deaths.  
	
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
SET total_cases = CASE 
                    WHEN total_cases = 0 THEN NULL
                    ELSE total_cases
				 END
UPDATE covid_deaths
SET new_cases = CASE 
                    WHEN new_cases = 0 THEN NULL
                    ELSE new_cases
				 END
UPDATE covid_deaths
SET total_deaths = CASE 
                    WHEN total_deaths = 0 THEN NULL
                    ELSE total_deaths
				 END;

--- Setting blank spaces to NULLs in the continent column 
UPDATE covid_deaths
SET continent = NULL
WHERE continent=''
```

# Analysing Insights
### First look at the data: 
```
--- Selecting data we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid. dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2
```
I was interested in analyzing the situation in Puerto Rico during the pandemic. Unfortunately, the initial findings were concerning, as the island had already recorded its first death out of the 24 reported cases within the first three months of 2020. 
```
--- Total cases vs Total deaths in Puerto Rico
SELECT location, date, total_cases, total_deaths, 
	ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location='Puerto Rico' AND continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, 
	ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location='United States' AND continent IS NOT NULL
ORDER BY 1,2
```
As of March 19th 2020, the death rate in Puerto Rico had reached 4% compared to total cases, indicating a significant and concerning impact of the pandemic on the island. The United States had a lot more deaths (149) but in comparison to total cases, this number was just over 1%. 

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
ORDER BY percentage_population_infected DESC

SELECT location, date, population, total_cases, 
	ROUND(total_cases/population,6)*100 AS percentage_population_infected
FROM covid. dbo.covid_deaths
WHERE location = 'United States'
ORDER BY percentage_population_infected DESC
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

Nonetheless, these countries have vast amounts of populations due to their size. I decided to look for the top five countries with the highest death rates: 
1. Yemen - 18.07% with 2,159 deaths 
2. Sudan - 7.86% with 5,034 deaths 
3. Syria - 5.5% with 3,163 deaths 
4. Somalia - 4.98% with 1,361 deaths 
5. Peru - 4.89% with 219,866
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

# Sharing My Results 
