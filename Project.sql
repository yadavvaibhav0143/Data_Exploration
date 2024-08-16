

--DBO.CovidDeaths Data

Select *
from [Portfolio Project].dbo.CovidDeaths
where continent is not null


--Total_Cases Vs Total_Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percent
from [Portfolio Project].dbo.CovidDeaths
where total_cases <> '0'  and total_deaths <> '0'
order by 1,2

--Encounter By Location

select Continent, Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percent
from [Portfolio Project].dbo.CovidDeaths
where location like '%states%' and total_cases <> '0'  and total_deaths <> '0'
order by 1,2

--Highest Infected_Rate as per Population

select continent, Location, Population, max(total_cases) as HighestInfected_Count, max((total_cases/population))*100 as HighestInfected_Percent
from [Portfolio Project].dbo.CovidDeaths
where  total_cases <> '0'  and total_deaths <> '0'
group by CONTINENT, location, population
order by HighestInfected_Percent desc

--Highest Death_Percentage as per Continent

select continent,  max(total_cases) as TotalCases_Count, max(total_deaths) as TotalDeaths_Count, 
cast(max((total_deaths/total_cases))*100 as int) as HighestDeath_Percent
from [Portfolio Project].dbo.CovidDeaths
where total_cases <> '0'  and total_deaths <> '0'
group by continent
order by HighestDeath_Percent desc


--Total_Population Vs Total_Vaccination

--Using CTE

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, VaccinationByLocation)
as
(
Select Dea.continent, Dea.location, dea.date, Dea.population, vac.new_vaccinations,
sum(cast(Vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) as VaccinationByLocation
from [Portfolio Project].dbo.CovidDeaths as Dea
join [Portfolio Project].dbo.CovidVaccination AS Vac
on Dea.LOCATION = Vac.location 	and
Dea.date = Vac.date
where Dea.continent is not null
)
select *
from PopvsVac

--Using Temp_Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
VaccinationByLocation numeric
)
insert into #PercentPopulationVaccinated	
Select Dea.continent, dea.location, dea.date, Dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition  by  dea.date, dea.location) as VaccinationByLocation
from [Portfolio Project].dbo.CovidDeaths as Dea	
join [Portfolio Project].dbo.CovidVaccination AS Vac
on Dea.LOCATION = Vac.location 	and
dea.date = vac.date
order by 2

select *, (VaccinationByLocation/population)*100 as Vaccination_Percent
from #PercentPopulationVaccinated


--Creating View to Store Data for Later

select *
from #PercentPopulationVaccinated	
