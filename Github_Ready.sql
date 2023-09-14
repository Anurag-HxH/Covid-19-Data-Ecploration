/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Subqueries, Aggregate Functions, Creating Views, Converting Data Types

*/




--Select Data To Get Started



Select *
From PortfolioProject..CovidDeaths
Where continent is Not Null
Order by 3,4



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country



Select location, date, total_cases, total_deaths, population,
(Convert(float,total_deaths) / total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not Null 
and location like 'India%'
Order by 1,2





-- Total Cases vs Population
-- Shows what percentage of population infected with Covid


Select location, date, total_cases, population,
(total_cases / population) * 100 as PercentInfectionRate
From PortfolioProject..CovidDeaths
Where continent is Not Null 
--and location like '%India%' 
Order by 1,2




-- Looking at the countries with Highest Infection rate per Population

Select location, population, Max(total_cases) as HighestInfectionCount, 
(Max(total_cases)/Max(population))* 100 as PercentInfectionRate
From PortfolioProject..CovidDeaths
Where Continent is Not Null 
Group By location, population
Order by PercentInfectionRate Desc





-- Looking at the countries with Highest Deaths per Population


Select location, Max(cast(total_deaths as int)) TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is Not Null 
Group By location
Order by TotalDeathCount Desc




 
-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population



Select location, Max(cast(total_deaths as int)) TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is Null and location not in ('European Union','Low Income', 'High Income', 'Lower Middle Income','Upper middle income')
Group By location
Order by TotalDeathCount Desc






-- Global Numbers Date wise

Select date, SUM(new_cases) as TotalCases, Sum(new_deaths)as TotalDeaths, (Sum(new_deaths) / NULLIF(Sum(new_cases),0)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is not null
Group by date
Order by 1




--Global Numbers (overall)


Select SUM(new_cases) as TotalCases, Sum(new_deaths)as TotalDeaths, (Sum(new_deaths) / NULLIF(Sum(new_cases),0)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is not null
--Group by date
Order by 1,2 






--Overall Numbers (India)


Select location,  Sum(new_deaths) as TotalDeaths, Sum(new_cases) as TotalCases, 
(Sum(new_deaths) / NullIF(Sum(new_cases),0) * 100) as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%India%'
Group By location
--Order by 1,2




--Join tables

-- Population VS Vaccination

Select dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition By dea.location )
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is Not Null
--Group By dea.location, dea.population, dea.date, vac.new_vaccinations
Order by 1,3



Select dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) 
OVER (Partition By dea.location  ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is Not Null
Order by 1,3


--Using Subquery To Find Percent Population Vaccinated



Select *, (a.RollingPeopleVaccinated/a.population)* 100 as PercentVaccinated
From  (Select dea.location, dea.population, dea.date, vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations as bigint)) 
		OVER (Partition By dea.location  ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
		From PortfolioProject..CovidDeaths dea
		Join PortfolioProject..CovidVaccinations vac
			ON dea.location = vac.location
			and dea.date = vac.date
		Where dea.continent is Not Null
		) as a


 -- Using CTE to perform Calculation on Partition By in previous query




With PopvsVac as
(Select dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) 
OVER (Partition By dea.location  ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is Not Null
) 
Select *, (RollingPeopleVaccinated/population)* 100 as PercentVaccinated
From PopvsVac





-- Using Temp Tables to perform Calculation on Partition By in previous query



Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
location nvarchar(255),
population numeric,
date datetime,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) 
OVER (Partition By dea.location  ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is Not Null
--Order by 1,3

Select *, (RollingPeopleVaccinated/population)* 100 as PercentVaccinated
From #PercentPopulationVaccinated






-- Creating View to Store Data For Later Visualizations


CREATE VIEW DeathPercentage
as
Select SUM(new_cases) as TotalCases, Sum(new_deaths)as TotalDeaths, (Sum(new_deaths) / NULLIF(Sum(new_cases),0)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is not null






Create View TotalDeathCount As
Select location, Max(cast(total_deaths as int)) TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is Null and location not in ('European Union','Low Income', 'High Income', 'Lower Middle Income','Upper middle income')
Group By location









