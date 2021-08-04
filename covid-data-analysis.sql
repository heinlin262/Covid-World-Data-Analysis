--DROP TABLE covid_death;

/**CREATE TABLE covid_death (
	iso_code VARCHAR(50),
 	continent VARCHAR(50),
 	location VARCHAR(100),
  	date VARCHAR(50),
	population BIGINT,
	total_cases BIGINT,
	new_cases BIGINT,
	new_cases_smoothed DECIMAL,
	total_deaths BIGINT,
	new_deaths BIGINT,
	new_deaths_smoothed DECIMAL,
	total_cases_per_million DECIMAL,
	new_cases_per_million DECIMAL,
	new_cases_smoothed_per_million DECIMAL,
	total_deaths_per_million DECIMAL,
	new_deaths_per_million DECIMAL,
	new_deaths_smoothed_per_million DECIMAL,
	reproduction_rate DECIMAL,
	icu_patients BIGINT,
	icu_patients_per_million DECIMAL,
	hosp_patients BIGINT,
	hosp_patients_per_million DECIMAL,
	weekly_icu_admissions DECIMAL,
	weekly_icu_admissions_per_million DECIMAL,
	weekly_hosp_admissions DECIMAL,
	weekly_hosp_admissions_per_million DECIMAL	
);**/

SELECT * FROM covid_death;

--DROP TABLE covid_vaccination;

/**
CREATE TABLE covid_vaccination(
	iso_code VARCHAR(50),
 	continent VARCHAR(50),
 	location VARCHAR(100),
  	date VARCHAR(50),
	new_tests BIGINT,
	total_tests BIGINT,
	total_tests_per_thousand DECIMAL,
	new_tests_per_thousand DECIMAL,
	new_tests_smoothed BIGINT,
	new_tests_smoothed_per_thousand DECIMAL,
	positive_rate DECIMAL,
	tests_per_case DECIMAL,
	tests_units VARCHAR(100),
	total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated BIGINT,
	new_vaccinations BIGINT, 
	new_vaccinations_smoothed BIGINT,
	total_vaccinations_per_hundred DECIMAL,
	people_vaccinated_per_hundred DECIMAL,
	people_fully_vaccinated_per_hundred DECIMAL,
	new_vaccinations_smoothed_per_million DECIMAL,
	stringency_index DECIMAL,
	population_density DECIMAL,
	median_age DECIMAL,
	aged_65_older DECIMAL,
	aged_70_older DECIMAL,
	gdp_per_capita DECIMAL,
	extreme_poverty DECIMAL,
	cardiovasc_death_rate DECIMAL,
	diabetes_prevalence DECIMAL,
	female_smokers DECIMAL,
	male_smokers DECIMAL,
	handwashing_facilities DECIMAL,
	hospital_beds_per_thousand DECIMAL,
	life_expectancy DECIMAL,
	human_development_index DECIMAL,
	excess_mortality DECIMAL
);**/

SELECT * FROM covid_vaccination;

SELECT * FROM covid_death;

SELECT * FROM covid_vaccination;

-- select data that will be used

SELECT location, date, population, total_cases, new_cases, total_deaths
FROM covid_death;

-- total cases vs total deaths
-- likelihood of dying percentage in each countries

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_death
WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY DeathPercentage DESC;


--total cases vs population
-- likelihood of having infection percentage in each countries

SELECT location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage
FROM covid_death
WHERE total_cases IS NOT NULL AND population IS NOT NULL 
ORDER BY CasePercentage DESC;


--which country which has the infection rate

SELECT location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage
FROM covid_death
WHERE total_cases IS NOT NULL AND population IS NOT NULL 
ORDER BY CasePercentage DESC
LIMIT 1;

--which countries has the highest infection cases

SELECT location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage
FROM covid_death
WHERE total_cases IS NOT NULL AND population IS NOT NULL AND location != continent
ORDER BY total_cases DESC;

--which countries has the highest deaths

SELECT location, SUM(total_deaths) AS TotalDeathCounts
FROM covid_death
WHERE location != continent AND total_deaths IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCounts DESC;

--which continents has the highest deaths

SELECT continent, SUM(total_deaths) AS TotalDeathCounts
FROM covid_death
WHERE total_deaths IS NOT NULL and continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCounts DESC;

--which continents has the highest cases

SELECT continent, SUM(total_cases) AS TotalDeathCounts
FROM covid_death
WHERE total_cases IS NOT NULL AND continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCounts DESC;

--in which date most people die

SELECT date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_death
WHERE total_deaths IS NOT NULL and total_cases IS NOT NULL
ORDER BY total_deaths DESC;

--unfortunately, it was just the day before i wrote this code :(

--date and location where most people die

SELECT date, location, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_death
WHERE total_deaths IS NOT NULL and total_cases IS NOT NULL and location != continent
ORDER BY total_deaths DESC;

--total death percentage around the world

SELECT SUM(total_cases) AS all_cases, SUM(total_deaths) AS all_deaths, 
SUM(total_deaths)/SUM(total_cases) * 100 AS total_death_percentage
FROM covid_death;


--total populations vs vaccination

SELECT cd.continent, cd.location, cd.date, cd.population, cv.total_vaccinations
FROM covid_death AS cd, covid_vaccination AS cv
WHERE cd.date = cv.date AND cd.location = cv.location AND cv.total_vaccinations IS NOT NULL;

--which countries have the highest vaccination

SELECT cd.location, SUM(cv.total_vaccinations) AS TotalVaccination
FROM covid_death AS cd, covid_vaccination AS cv
WHERE cd.date = cv.date AND cd.location = cv.location AND cv.total_vaccinations IS NOT NULL
AND cd.location != cd.continent
GROUP BY cd.location
ORDER BY TotalVaccination DESC;

--which countries have the highest vaccination per population

SELECT cd.location, SUM(cv.total_vaccinations) AS TotalVaccination, 
SUM(cd.population) AS TotalPopulation, SUM(cv.total_vaccinations)/SUM(cd.population) * 100 AS VaccinationPerPopulation
FROM covid_death AS cd, covid_vaccination AS cv
WHERE cd.date = cv.date AND cd.location = cv.location AND cv.total_vaccinations IS NOT NULL
AND cd.location != cd.continent AND cv.total_vaccinations IS NOT NULL 
AND cd.population IS NOT NULL AND cd.population > cv.total_vaccinations
GROUP BY cd.location
ORDER BY VaccinationPerPopulation DESC;

--which countries have the highest vaccination per population

SELECT cd.location, SUM(cv.total_vaccinations) AS TotalVaccination, 
SUM(cd.population) AS TotalPopulation, SUM(cv.total_vaccinations)/SUM(cd.population) * 100 as VaccinationPerPopulation
FROM covid_death AS cd, covid_vaccination AS cv
WHERE cd.date = cv.date AND cd.location = cv.location AND cv.total_vaccinations IS NOT NULL
AND cd.location != cd.continent AND cv.total_vaccinations IS NOT NULL 
AND cd.population IS NOT NULL AND cd.population > cv.total_vaccinations
GROUP BY cd.location
ORDER BY VaccinationPerPopulation;















