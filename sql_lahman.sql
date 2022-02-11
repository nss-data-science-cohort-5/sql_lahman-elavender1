--Find all players in the database who played at Vanderbilt University. 
--Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. 
--Sort this list in descending order by the total salary earned. 
--Which Vanderbilt player earned the most money in the majors?

SELECT playerid, salary
FROM salaries
WHERE playerid = 'barkele01'
LIMIT 10;

SELECT namefirst || ' ' || namelast AS player, SUM(salaries.salary) as total_salary
FROM people
INNER JOIN salaries 
USING (playerid)
INNER JOIN collegeplaying
USING (playerid)
INNER JOIN schools
USING (schoolid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY player 
ORDER BY total_salary DESC

--2)
--Using the fielding table, group players into three groups based on their position: label 
--players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
--and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT SUM(po),
	CASE WHEN pos = 'OF' then 'Outfield'
		WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR pos = '3B' then 'Infield'
		WHEN pos = 'P' OR pos = 'C'  then 'Battery'
		END AS positions
FROM fielding
WHERE yearid = 2016
GROUP BY positions

--3)Find the average number of strikeouts per game by decade since 1920.
--Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends? 
--(Hint: For this question, you might find it helpful to look at the generate_series function
WITH decades AS 
(SELECT 
	generate_series(1920, 2016, 10) AS start_decade,
	generate_series(1929, 2019, 10) AS end_decade)
SELECT 
	d.start_decade,
	SUM(so) AS total_strikeouts, 
	SUM(soa) AS total_, 
	SUM(g) / 2 AS total_games, 
	sum(so) / (sum(g) / 2.0) AS avg_strikeouts_per_game,
	round(1.00 * sum(hr) / (sum(g) / 2),2) as homeruns_avg
FROM teams as t
JOIN decades as d
on t.yearid >= d.start_decade and t.yearid <= d.end_decade
GROUP BY d.start_decade
ORDER BY d.start_decade

WITH 
SELECT 
	generate_series(1920, 2016, 10) AS start_decade,
	generate_series(1929, 2019, 10) AS end_decade

--4)
--Find the player who had the most success stealing bases in 2016, 
--where success is measured as the percentage of stolen base attempts which are successful.
--(A stolen base attempt results either in a stolen base or being caught stealing.) 
--Consider only players who attempted at least 20 stolen bases. Report the players' 
--names, number of stolen bases, number of attempts, and stolen base percentage.

SELECT 
	namefirst || ' ' || namelast AS player_name,
	sb,
	sb + cs AS attempts,
	round(100.00 * sb / (sb + cs),2)  AS steal_ratio 
FROM batting
LEFT JOIN people
USING (playerid)
WHERE yearid = 2016
AND sb + cs >= 20
ORDER BY steal_ratio DESC 

--5) From 1970 to 2016, what is the largest number of wins for a team that did not win the world series?
--What is the smallest number of wins for a team that did win the world series?
--Doing this will probably result in an unusually small number of wins for a world series champion;
--determine why this is the case. Then redo your query, excluding the problem year.
--How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?
SELECT 
	teamid,
	SUM(w) AS total_wins
FROM teams
WHERE wswin != 'Y'
	AND yearid >= 1970 
	AND yearid <= 2016
GROUP BY teamid
ORDER BY total_wins DESC
--WHERE 
--WHERE wswin = ''

SELECT *
FROM teams
LIMIT 10





