# Data Exploration

## Table of Contents:

- [Project Overview](project-overview)
- [Data Sources](data-sources)
- [Tools](tools)
- [Key Areas of Exploration](key-areas-of-exploration)
- [Project Structure](project-structure)
- [Expected Outcome](expected-outcome)

### Project Overview:

This project focuses on exploring COVID-19 data to gain insights into the pandemic's impact across different regions. The key areas of analysis include the number of COVID-19 cases, deaths, and vaccinations. Additionally, the project investigates regional differences in infection rates, mortality, and vaccination coverage.

### Data Sources:

The data is sourced from the Our World in Data website, providing regularly updated, reliable global COVID-19 statistics, including cases, deaths, and vaccination rates for thorough regional analysis.

### Tools

- `Excel`: For managing, and analyzing the dataset.
- `SQL`: For quering, data cleaning, visualization and further analysis.
- `GitHub Page`': For hosting the project and making findings accessible online.

### Key Areas of Exploration:

#### COVID-19 Deaths:

- Examination of total COVID-19 deaths.
- Analysis of mortality rates in relation to infection rates.

```Sql
Total_Cases Vs Total_Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percent
from [Portfolio Project].dbo.CovidDeaths
where total_cases <> '0'  and total_deaths <> '0'
order by 1,2
```

```sql
Encounter By Location

select Continent, Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percent
from [Portfolio Project].dbo.CovidDeaths
where location like '%states%' and total_cases <> '0'  and total_deaths <> '0'
order by 1,2
```

#### COVID-19 Infected Cases:

- Analysis of the number of confirmed COVID-19 cases over time.
- Identification of trends in infection rates across different regions.

```sql
Highest Infected_Rate as per Population

select continent, Location, Population, max(total_cases) as HighestInfected_Count,
max((total_cases/population))*100 as HighestInfected_Percent
from [Portfolio Project].dbo.CovidDeaths
where  total_cases <> '0'  and total_deaths <> '0'
group by CONTINENT, location, population
order by HighestInfected_Percent desc
```

#### Overall Deaths:

- Comparison of overall deaths during the pandemic.
- Analysis of the contribution of COVID-19 to overall mortality.

```sql
Highest Death_Percentage as per Continent

select continent,  max(total_cases) as TotalCases_Count, max(total_deaths) as TotalDeaths_Count, 
cast(max((total_deaths/total_cases))*100 as int) as HighestDeath_Percent
from [Portfolio Project].dbo.CovidDeaths
where total_cases <> '0'  and total_deaths <> '0'
group by continent
order by HighestDeath_Percent desc
```

  #### COVID-19 Vaccinations:

  - Analysis of vaccination rates over time.
  - Exploration of the relationship between vaccination and infection/death rates.

```sql
Total_Population Vs Total_Vaccination
Using CTE

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
```

```sql
Total_Population Vs Total_Vaccination
Using Temp_Table

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
```

### Project Structure:

- `Data`: Raw datasets related to COVID-19 cases, deaths, and vaccinations.
- `Server`: SQL Server containing the code for data exploration and analysis.
- `docs`: Detailed reports and documentation of the project’s findings.

### Expected Outcome: 

The project aims to provide a comprehensive understanding of the COVID-19 pandemic's impact across different regions, identifying key factors infection rates, mortality, and vaccination effectiveness.
