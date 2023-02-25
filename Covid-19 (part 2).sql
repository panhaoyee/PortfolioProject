SELECT continent, location, date, population, new_vaccinations
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
order by 2,3

SELECT continent, location, date, population, new_vaccinations, SUM(CAST(new_vaccinations AS int)) OVER (Partition by location Order by date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
order by 2,3


With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(SELECT continent, location, date, population, new_vaccinations, SUM(CAST(new_vaccinations AS int)) OVER (Partition by location Order by date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select continent, location, date, population, new_vaccinations
, SUM(CONVERT(int,new_vaccinations)) OVER (Partition by Location Order by location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



Create View PercentPopulationVaccinated as
Select continent, location, date, population, new_vaccinations
, SUM(CONVERT(int,new_vaccinations)) OVER (Partition by Location Order by location, Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths
where continent is not null 


