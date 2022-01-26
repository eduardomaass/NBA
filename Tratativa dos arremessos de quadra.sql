-- Criar a view shooting_percentages_2020 para consulta posterior
-- Mostra a porcentagem de arremessos convertidos de cada jogador por região da quadra

CREATE OR REPLACE VIEW shooting_percentages_2020 AS
WITH p AS(
	SELECT	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2020_2021
	GROUP BY
		player_id, player_name, team_id, team_name, shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS percentage
FROM
	p
ORDER BY
	team_id, player_id, shot_zone_basic;
	
	


-- Criar a view team_averages_2020 para consulta posterior
-- Mostra a porcentagem média de arremessos convertidos de cada time por região da quadra

CREATE OR REPLACE VIEW team_averages_2020 AS
WITH t AS(
	SELECT 
		team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM 
		nba_shots_2020_2021
	GROUP BY
		team_id, team_name, shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS team_average
FROM
	t
ORDER BY
	team_id, shot_zone_basic;
	
	
	

-- Criar a view league_averages_2020 para consulta posterior
-- Mostra a porcentagem média de arremessos convertidos por região da quadra

CREATE OR REPLACE VIEW league_averages_2020 AS
WITH l AS(
	SELECT 
		shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM 
		nba_shots_2020_2021
	GROUP BY
		shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS league_average
FROM
	l
ORDER BY
	shot_zone_basic;
	



-- Criar a view efficiency_2020 para consulta posterior
-- Cria os indicadores Efficient Field Goal Percentage(efg) e Points per Shot(pps)

CREATE OR REPLACE VIEW efficiency_2020 AS
WITH m AS(
	SELECT
		player_id, player_name, team_id, team_name,
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted,
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made, 
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' AND shot_made_flag = 1 THEN 3
			WHEN shot_zone_basic = 'Backcourt' AND shot_made_flag = 1 THEN 3
			WHEN shot_made_flag = 1 THEN 2
			ELSE 0
			END) AS total_points,
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' AND shot_made_flag = 1 THEN 3
			WHEN shot_zone_basic = 'Backcourt' AND shot_made_flag = 1 THEN 3
			ELSE 0
			END) AS total_3_points
	FROM
		nba_shots_2020_2021
	GROUP BY
		player_id, player_name, team_id, team_name
	ORDER BY
		player_id, player_name, team_id, team_name
)
SELECT
	player_id, player_name, team_id, team_name, 
	ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
	ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
FROM
	m
ORDER BY
	team_id, team_name, player_id, player_name;




-- Extrair as informações de efficiency_2020 

SELECT
	*
FROM
	efficiency_2020 
ORDER BY
	team_id, team_name, player_id, player_name;
