select * 
from project..covid_deaths
where continent is not null
order by 3,4

--select * 
--from project..covid_vaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from project..covid_deaths
order by 1,2

-- Changes the data type of columns total_deaths and total_cases to float
alter table covid_deaths
alter column total_deaths float;

alter table covid_deaths
alter column total_cases float;


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathPercentage
from project..covid_deaths 
Where location like '%indi%'
order by 1,2

-- Looking at the total Cases vs Population
-- Shows what percentage of Population gets covid

select location,date,total_cases,Population, (total_cases/Population)*100 as PercentPopulationInfected
from project..covid_deaths 
--Where location like '%indi%'
order by 1,2

-- Looking at countries with highest infection rate compared to population
select location,Max(total_cases) as HighInfectionCount,Population, Max((total_cases/Population))*100 as PercentPopulationInfected
from project..covid_deaths 
--Where location like '%indi%'
group by location,Population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select location,Max(total_deaths) as TotalDeathCount
from project..covid_deaths 
--Where location like '%indi%'
where continent is not null
group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DWON BY CONTINENT
-- Showing the continents with the highest death counts per population

select continent,Max(total_deaths) as TotalDeathCount
from project..covid_deaths 
--Where location like '%indi%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

select date,SUM(new_cases) as total_cases,SUM(new_deaths) as total_deaths,
CASE
        WHEN SUM(new_cases) = 0 THEN NULL
        ELSE (SUM(new_deaths) * 100.0) / NULLIF(SUM(new_cases), 0)
    END AS deathPercentage

from project..covid_deaths 
--Where location like '%indi%'
where continent is not null
Group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location)
From project..covid_deaths dea
Join project..covid_vaccinations vac
     On dea.location=vac.location
	 and dea.date=vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE
with PopvsVac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CASE WHEN vac.new_vaccinations IS NOT NULL THEN  CONVERT(BIGINT, vac.new_vaccinations) ELSE 0 END) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
		

FROM project..covid_deaths dea
JOIN project..covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3;
)
Select * ,(RollingPeopleVaccinated/population)*100
From PopvsVac


-- TEMP Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinaton numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CASE WHEN vac.new_vaccinations IS NOT NULL THEN  CONVERT(BIGINT, vac.new_vaccinations) ELSE 0 END) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
		

FROM project..covid_deaths dea
JOIN project..covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3;
Select * ,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated






