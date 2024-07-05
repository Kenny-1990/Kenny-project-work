Select *
From CovidDeaths

Select *
From [KENNY PROJECT WORK]..CovidDeaths

Select *
From CovidDeaths
Order by 3,4

Select *
From CovidVaccinations

Select *
From CovidVaccinations
Order by 3,4

Select Location,Date,Total_cases,new_cases,total_deaths,population
From CovidDeaths

Select Location,Date,Total_cases,new_cases,total_deaths,population
From CovidDeaths
Order by 1,2


Select Location,Date,Total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
From CovidDeaths
Order by 1,2


Select Location,Date,Total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
From CovidDeaths
Where Location like '%states%'
Order by 1,2


Select Location,Date,Total_cases,population,(total_cases/population)*100 as Deathpercentage 
From CovidDeaths
Where Location like '%states%'
Order by 1,2


Select Location,population,MAX(total_cases) as HighestInfectioncount,
MAX(total_cases/population)*100 as percentagepopulationinfected
From CovidDeaths
Where Location like '%states%'
Group by location, population
Order by Percentagepopulationinfected


Select Location,MAX(Cast(total_deaths as int))  as Totaldeathcount
From CovidDeaths
--Where Location like '%states%' 
Where continent is not null
Group by location
Order by Totaldeathcount desc
 
 Select Continent,MAX(Cast(total_deaths as int))  as Totaldeathcount
From CovidDeaths
--Where Location like '%states%' 
Where continent is not null
Group by continent
Order by Totaldeathcount desc



Select date,SUM(new_cases),SUM(Cast(new_deaths as int))--, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From CovidDeaths
--Where Location like '%states%' 
Where continent is not null
Group by date
Order by 1,2


Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
Order  by 2,3


Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location)
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
Order  by 2,3



Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
Order  by 2,3


--Using CTE
With popvsvac (Continent,location,date,population,New_vaccination,rollingpeoplevaccinated)
as
(
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3
)

Select *, (Rollingpeoplevaccinated/population)*100
FROM popvsvac


--With Temp Table
Create Table #percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric 
)
Insert into #percentpopulationvaccinated
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3


Select *, (Rollingpeoplevaccinated/population)*100
From #percentpopulationvaccinated


--With TEMP TABLE
Drop Table if exists  #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric 
)
Insert into #percentpopulationvaccinated
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
--where dea.continent is not null 
--Order  by 2,3


Select *, (Rollingpeoplevaccinated/population)*100
From #percentpopulationvaccinated



--CREATING VIEW

Create view percentpopulationvaccinated as
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3


Create view Deathpercentage as
Select Location,Date,Total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
From CovidDeaths
--Order by 1,2

Create view Deathpercentage1 as
Select Location,Date,Total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
From CovidDeaths
Where Location like '%states%'
--Order by 1,2

Create view percentcontactedcovid as
Select Location,Date,Total_cases,population,(total_cases/population)*100 as Deathpercentage 
From CovidDeaths
Where Location like '%states%'
--Order by 1,2

Create view highestinfectedratecountry as
Select Location,population,MAX(total_cases) as HighestInfectioncount,
MAX(total_cases/population)*100 as percentagepopulationinfected
From CovidDeaths
Where Location like '%states%'
Group by location, population
--Order by Percentagepopulationinfected

Create view highestdeathcountrycount as
Select Location,MAX(Cast(total_deaths as int))  as Totaldeathcount
From CovidDeaths
--Where Location like '%states%' 
Where continent is not null
Group by location
--Order by Totaldeathcount desc

 Create view highestdeathcountrycount1 as
 Select Continent,MAX(Cast(total_deaths as int))  as Totaldeathcount
From CovidDeaths
--Where Location like '%states%' 
Where continent is not null
Group by continent
--Order by Totaldeathcount desc




create view jointdeathvaccinepopulation as 
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3






Create view countryvaccinecount as
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3





Create view percentpopulationvaccinated as
Select dea.continent,dea.Location,dea.date,dea.population,Vac.new_vaccinations,SUM(Cast(Vac.new_vaccinations as int))
OVER (Partition by dea.Location order by dea.Location,dea.Date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From CovidDeaths dea 
Join CovidVaccinations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null 
--Order  by 2,3




