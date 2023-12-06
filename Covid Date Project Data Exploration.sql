Select * From CovidDeathss1
Order by 3,4


Select * From CovidVaccinations1
Order by 3,4

--Selecting data to be used 

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeathss1
Order by 1,2
 
--Total Cases VS. Total Deaths
-- Chances of dying if ever you get covid on your country
Select location, date, total_cases, total_deaths, (Convert(float, total_deaths) / NULLIF (Convert(float,total_cases),0)) * 100 as DeathPercentage
From CovidDeathss1
Where location = 'Albania'
Order By 1,2

--Checking the total cases vs. population
--Show the percentage of the population that got affected by the Covid
Select location, population, MAX(Convert(bigint,total_cases)) AS HighestInfectionCount, MAX((total_cases / Convert(float, population))) * 100 AS PercentPopulationInfected
From CovidDeathss1
Group by location, population
Order by PercentPopulationInfected DESC

Select location, Max(population) AS MaximumPopulation
From CovidDeathss1
Group by location
Order by MaximumPopulation Desc

Select location, Max(total_cases) AS TotalCasesOnTheCountry
From CovidDeathss1
Group by location
Order by TotalCasesOnTheCountry


 


Select continent, MAX(Convert(bigint, total_deaths)) AS TotalDeathCount
From CovidDeathss1
Where continent is not null
Group by Continent
Order by TotalDeathCount desc


--Showing continent with highest death count per population 
Select continent, MAX(convert(bigint,total_deaths )) AS TotalDeathCount
From CovidDeathss1
Where continent is not null
Group by Continent
Order by TotalDeathCount desc


--Global Numbers
Select date, SUM(Convert(int,new_cases)) AS TotalCases, SUM(Convert(int, new_deaths)) AS SumOfTotalDeaths,
SUM(Convert(float, new_deaths)) / NULLIF (SUM(Convert(float,new_cases)),0) * 100 AS DeathPercentageOfNewCases
From CovidDeathss1
Where continent is not null
Group by date
Order by DeathPercentageOfNewCases 

Select SUM(Convert(int,new_cases)) AS TotalCases, SUM(Convert(int, new_deaths)) AS SumOfTotalDeaths,
SUM(Convert(float, new_deaths)) / NULLIF (SUM(Convert(float,new_cases)),0) * 100 AS DeathPercentageOfNewCases
From CovidDeathss1
Where continent is not null
Order by DeathPercentageOfNewCases 


Select *
From CovidVaccinations1


Select * 
From CovidDeathss1


-- Looking at Total Population and Vaccination

Select CDeaths.continent, CDeaths.location, CDeaths.date, CDeaths.population, Cvaccine.new_vaccinations,
SUM(Convert(bigint,Cvaccine.new_vaccinations)) OVER (Partition by CDeaths.location Order by CDeaths.location, Cdeaths.date) AS TotalVaccination
From CovidDeathss1 as CDeaths
Join CovidVaccinations1 as CVaccine
on Cdeaths.location = Cvaccine.location
AND Cdeaths.date = Cvaccine.date
Where CDeaths.continent is not null
Order by 2,3

--Use CTE
With PopulationVsVaccination(Continent, Location, Date, Population, new_vaccinations, TotalVaccination)
as
(
Select CDeaths.continent, CDeaths.location, CDeaths.date, CDeaths.population, Cvaccine.new_vaccinations,
SUM(Convert(bigint,Cvaccine.new_vaccinations)) OVER (Partition by CDeaths.location Order by CDeaths.location, Cdeaths.date) AS TotalVaccination
From CovidDeathss1 as CDeaths
Join CovidVaccinations1 as CVaccine
on Cdeaths.location = Cvaccine.location
AND Cdeaths.date = Cvaccine.date
Where CDeaths.continent is not null
)
Select *,(Convert(float,TotalVaccination)/ Convert(float,Population))*100 as VaccinatedPopulation
From PopulationVsVaccination 

--Temporary Table

Create table #PercentageOfVaccinated(
Continent nvarchar(255), Location nvarchar(255), Date varchar(255), Population varchar(255), new_vaccinations varchar(255), TotalVaccination numeric
)

Insert INTO #PercentageOfVaccinated
Select CDeaths.continent, CDeaths.location, CDeaths.date, CDeaths.population, Cvaccine.new_vaccinations,
SUM(Convert(bigint,Cvaccine.new_vaccinations)) OVER (Partition by CDeaths.location Order by CDeaths.location, Cdeaths.date) AS TotalVaccination
From CovidDeathss1 as CDeaths
Join CovidVaccinations1 as CVaccine
on Cdeaths.location = Cvaccine.location
AND Cdeaths.date = Cvaccine.date
Where CDeaths.continent is not null


Select *,(Convert(float,TotalVaccination)/ Convert(float,Population))*100 as VaccinatedPopulation
From  #PercentageOfVaccinated

DROP TABLE IF EXISTS #PERCENTAGEOFVACCINATED


--Creating VIEW
CREATE VIEW PopulationVaccined as
Select CDeaths.continent, CDeaths.location, CDeaths.date, CDeaths.population, Cvaccine.new_vaccinations,
SUM(Convert(bigint,Cvaccine.new_vaccinations)) OVER (Partition by CDeaths.location Order by CDeaths.location, Cdeaths.date) AS TotalVaccination
From CovidDeathss1 as CDeaths
Join CovidVaccinations1 as CVaccine
on Cdeaths.location = Cvaccine.location
AND Cdeaths.date = Cvaccine.date
Where CDeaths.continent is not null

Select * From  PopulationVaccined

