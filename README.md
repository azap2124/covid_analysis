<p align = "center">
	<img src="https://user-images.githubusercontent.com/126125206/232331834-ad55c64c-a487-4939-8b45-33198c477b44.jpg" width="285" height="160"/>
	
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
First look at the data: 
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
SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location='Puerto Rico' AND continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases,4)*100 AS death_percentage
FROM covid. dbo.covid_deaths
WHERE location='United States' AND continent IS NOT NULL
ORDER BY 1,2
```
As of March 19th 2020, the death rate in Puerto Rico had reached 4% compared to total cases, indicating a significant and concerning impact of the pandemic on the island. The United States had a lot more deaths (149) but in comparison to total cases, this number was just over 1%. 

<img width="474" alt="initial deaths in pr " src="https://user-images.githubusercontent.com/126125206/232587639-95ffb3b3-4cc4-4562-9775-2a577869c4f8.png">
<img width="474" alt="initial deaths in us " src="https://user-images.githubusercontent.com/126125206/232593180-4e6730bd-9dfa-48db-9222-7abb90b943f5.png">

# Sharing My Results 
