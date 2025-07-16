-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT  max(duration_min) FROM spotify;

SELECT  min(duration_min) FROM spotify;

SELECT * FROM spotify 
WHERE duration_min=0;

DELETE FROM spotify 
WHERE duration_min=0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

/*
-------------------------------------------
Solving Business Problems
-------------------------------------------
 Easy Level
*/

-- Q1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify 
WHERE stream>1000000000 ;

--Q2.List all albums along with their respective artists.
SELECT 
DISTINCT album,artist 
FROM spotify
ORDER BY 1;

--Q3.Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

--Q4.Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE album_type = 'single';

--Q5.Count the total number of tracks by each artist.
SELECT artist, COUNT(*) as total_no_songs
FROM spotify
GROUP BY artist
ORDER BY 2 ;

/*
-------------------------------------------
Medium Level
-------------------------------------------
*/

--Q6.Calculate the average danceability of tracks in each album.
SELECT album,
AVG(danceability) as average
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Q7.Find the top 5 tracks with the highest energy values.
SELECT track, MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q8.List all tracks along with their views and likes where official_video = TRUE.
SELECT track,
SUM(views) as total_views,
SUM(likes) as total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC ;

--Q9.For each album, calculate the total views of all associated tracks.
SELECT album,track,
SUM(views) as total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC ;

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT track,
COALESCE(SUM(CASE WHEN most_played_on='youtube' THEN stream END ),0) as streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_played_on='spotify' THEN stream END ),0) as streamed_on_spotify
FROM spotify
GROUP BY 1) as t1
WHERE streamed_on_youtube< streamed_on_spotify
AND streamed_on_youtube <> 0;

/*
-------------------------------------------
Advanced Level
-------------------------------------------
*/

--Q11.Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist
AS
(SELECT 
artist,
track,
SUM(views) AS total_view,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM SPOTIFY
GROUP BY 1,2
ORDER BY 1,3 DESC)
SELECT * FROM ranking_artist
WHERE rank<=3;

--Q12.Write a query to find tracks where the liveness score is above the average.
SELECT track, artist,liveness FROM spotify
WHERE liveness> (SELECT AVG(liveness) FROM spotify);

--Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
album,
MAX(energy) as highest_energy,
MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1)
SELECT
album,
highest_energy - lowest_energy as energy_diff
FROM cte;


-- Query Optimization

EXPLAIN ANALYZE --et 7.97 ms pt 0.112ms

SELECT artist,track, views
FROM spotify
WHERE artist = 'Gorillaz'
      AND 
	  most_played_on= 'Youtube'
ORDER BY stream DESC LIMIT 25


CREATE INDEX artist_index ON spotify (artist);











 