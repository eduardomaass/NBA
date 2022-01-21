-- Creating View to store data for later visualizations
-- Shows the shooting percentages for each player per season and shot zone

CREATE OR REPLACE VIEW shooting_percentages AS

WITH p AS(
	
	-- Data from the 2020-2021 season
	
	SELECT
		'2020-2021' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2020_2021
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2019-2020 season	
	
	SELECT
		'2019-2020' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2019_2020
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2018-2019 season	
	
	SELECT
		'2018-2019' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2018_2019
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2017-2018 season		
	
	SELECT
		'2017-2018' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2017_2018
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2016-2017 season		
	
	SELECT
		'2016-2017' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2016_2017
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2015-2016 season		
	
	SELECT
		'2015-2016' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2015_2016
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION

	-- Data from the 2014-2015 season	
	
	SELECT
		'2014-2015' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2014_2015
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2013-2014 season	
	
	SELECT
		'2013-2014' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2013_2014
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2012-2013 season	
	
	SELECT
		'2012-2013' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2012_2013
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2011-2012 season	
	
	SELECT
		'2011-2012' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2011_2012
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
	UNION
	
	-- Data from the 2010-2011 season	
	
	SELECT
		'2010-2011' AS season,	
		player_id, player_name, team_id, team_name, shot_zone_basic, 
		CAST(SUM(shot_attempted_flag) AS numeric) AS shots_attempted, 
		CAST(SUM(shot_made_flag) AS numeric) AS shots_made	
	FROM
		nba_shots_2010_2011
	GROUP BY
		season, player_id, player_name, team_id, team_name, shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS percentage
FROM
	p
ORDER BY
	season, team_id, player_id, shot_zone_basic;
	



-- Shows the data in the View shooting_percentages

SELECT * FROM shooting_percentages;




-- Creating View to store data for later visualizations
-- Shows the shooting percentages for each team per season and shot zone

CREATE OR REPLACE VIEW team_averages AS

WITH t AS(
	SELECT 
		season, team_id, team_name, shot_zone_basic, 
		SUM(shots_attempted) AS shots_attempted, SUM(shots_made) AS shots_made
	FROM 
		shooting_percentages
	GROUP BY
		season, team_id, team_name, shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS team_average
FROM
	t
ORDER BY
	season, team_id, shot_zone_basic;




-- Shows the data in the View league_averages

SELECT * FROM team_averages;




-- Creating View to store data for later visualizations
-- Shows the shooting percentages for each season per shot zone

CREATE OR REPLACE VIEW league_averages AS

WITH s AS(
	SELECT 
		season, shot_zone_basic, 
		SUM(shots_attempted) AS shots_attempted, SUM(shots_made) AS shots_made
	FROM 
		shooting_percentages
	GROUP BY
		season, shot_zone_basic
)
SELECT
	*, 
	ROUND(CAST((shots_made / shots_attempted) * 100 AS numeric), 2) AS league_average
FROM
	s
ORDER BY
	season, shot_zone_basic;




-- Shows the data in the View league_averages

SELECT * FROM league_averages;




-- Compare players shoting percentages with team and league averages

SELECT 
	A.season, A.player_id, A.player_name, A.team_id, A.team_name,
	A.shot_zone_basic,  A.shots_attempted, A.shots_made, A.percentage, 
	B.team_average, C.league_average
FROM 
	shooting_percentages A 
INNER JOIN
	team_averages B
ON 
	A.season = B.season
AND
	A.shot_zone_basic = B.shot_zone_basic
AND
	A.team_id = B.team_id
INNER JOIN
	league_averages C
ON 
	A.season = C.season
AND
	A.shot_zone_basic = C.shot_zone_basic
ORDER BY
	season, team_id, player_id, shot_zone_basic;
	



-- Create the effective field goal and points per shot measurements

WITH m AS(
	SELECT
		season, player_id, player_name, team_id, team_name,
		SUM(shots_made) AS shots_made,
		SUM(shots_attempted) AS shots_attempted, 
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 2 * shots_made
			END) AS total_points,
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 0 * shots_made
			END) AS total_3_points
	FROM
		shooting_percentages
	GROUP BY
		season, player_id, player_name, team_id, team_name
	ORDER BY
		season, player_id, player_name, team_id, team_name
)
SELECT
	season, player_id, player_name, team_id, team_name, 
	ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
	ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
FROM
	m
ORDER BY
	season, team_id, team_name, player_id, player_name;
	



-- Create the team effective field goal and points per shot measurements

WITH mt AS(
	SELECT
		season, team_id, team_name,
		SUM(shots_made) AS shots_made,
		SUM(shots_attempted) AS shots_attempted, 
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 2 * shots_made
			END) AS total_points,
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 0 * shots_made
			END) AS total_3_points
	FROM
		shooting_percentages
	GROUP BY
		season, team_id, team_name
	ORDER BY
		season, team_id, team_name
)
SELECT
	season, team_id, team_name, 
	ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
	ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
FROM
	mt
ORDER BY
	season, team_id, team_name;
	



-- Create the season effective field goal and points per shot measurements

WITH ms AS(
	SELECT
		season,
		SUM(shots_made) AS shots_made,
		SUM(shots_attempted) AS shots_attempted, 
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 2 * shots_made
			END) AS total_points,
		SUM(CASE
			WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
			ELSE 0 * shots_made
			END) AS total_3_points
	FROM
		shooting_percentages
	GROUP BY
		season
	ORDER BY
		season
)
SELECT
	season, 
	ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
	ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
FROM
	ms
ORDER BY
	season;
	



-- Create efficiency view

CREATE OR REPLACE VIEW efficiency AS

WITH player AS(
	WITH m AS(
		SELECT
			season, player_id, player_name, team_id, team_name,
			SUM(shots_made) AS shots_made,
			SUM(shots_attempted) AS shots_attempted, 
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 2 * shots_made
				END) AS total_points,
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 0 * shots_made
				END) AS total_3_points
		FROM
			shooting_percentages
		GROUP BY
			season, player_id, player_name, team_id, team_name
		ORDER BY
			season, player_id, player_name, team_id, team_name
	)
	SELECT
		season, player_id, player_name, team_id, team_name, 
		ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
		ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
	FROM
		m
	ORDER BY
		season, team_id, team_name, player_id, player_name
),
team AS(
	WITH mt AS(
		SELECT
			season, team_id, team_name,
			SUM(shots_made) AS shots_made,
			SUM(shots_attempted) AS shots_attempted, 
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 2 * shots_made
				END) AS total_points,
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 0 * shots_made
				END) AS total_3_points
		FROM
			shooting_percentages
		GROUP BY
			season, team_id, team_name
		ORDER BY
			season, team_id, team_name
	)
	SELECT
		season, team_id, team_name, 
		ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
		ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
	FROM
		mt
	ORDER BY
		season, team_id, team_name
),
view_season AS(
	WITH ms AS(
		SELECT
			season,
			SUM(shots_made) AS shots_made,
			SUM(shots_attempted) AS shots_attempted, 
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 2 * shots_made
				END) AS total_points,
			SUM(CASE
				WHEN shot_zone_basic LIKE '%3' THEN 3 * shots_made
				ELSE 0 * shots_made
				END) AS total_3_points
		FROM
			shooting_percentages
		GROUP BY
			season
		ORDER BY
			season
	)
	SELECT
		season, 
		ROUND(CAST(((shots_made + 0.5 * (total_3_points/3))/shots_attempted) AS numeric), 3) AS efg,
		ROUND(CAST((total_points / shots_attempted) AS numeric), 2) AS pps
	FROM
		ms
	ORDER BY
		season
)
SELECT
	player.season, player.team_id, player.team_name, player.player_id, player.player_name,
	player.efg AS player_efg, player.pps AS player_pps, 
	team.efg AS team_efg, team.pps AS team_pps,
	view_season.efg AS season_efg, view_season.pps AS season_pps
FROM 
	player 
INNER JOIN
	team
ON 
	player.season = team.season
AND
	player.team_id = team.team_id
INNER JOIN
	view_season
ON 
	player.season = view_season.season
ORDER BY
	player.season, player.team_id, player.player_id;
	



-- Shows the data in the View efficiency

SELECT * FROM efficiency;