
with cte as (SELECT 
  artists.artist_name,
  DENSE_RANK() OVER (
    ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
FROM artists
INNER JOIN songs
  ON artists.artist_id = songs.artist_id
INNER JOIN global_song_rank AS ranking
  ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY artists.artist_name
)

select artist_name, artist_rank
FROM cte
where artist_rank<=5

--OR--
with cte as (
SELECT artist_name,count(1) as appearences
FROM global_song_rank gsk 
JOIN songs ON songs.song_id=gsk.song_id
JOIN artists ON songs.artist_id=artists.artist_id
WHERE rank<=10
group by artist_name
order by appearences DESC
)

select artist_name, artist_rank
FROM (select artist_name, 
DENSE_RANK() over (order by appearences DESC) as artist_rank
from cte) A
where artist_rank<=5
