-- Day 8:  Game play analysis 1,2,3,a4

--q1: Write a SQL query that reports the first login date for each player

--q2: Write a SQL query that reports the device that is first logged in for each player

--q3: Write an SQL query that reports for each player and date, 
-- how many games played so far by the player. That is, total number of games
-- played by that player until the date.

--q4:Write an SQL query that reports the fraction of players that logged in again
-- on the day after the day they first logged in, rounded to 2 decimal places.

create table activity (

 player_id     int     ,
 device_id     int     ,
 event_date    date    ,
 games_played  int
 );

 insert into activity values (1,2,'2016-03-01',5 ),(1,2,'2016-03-02',6 ),(2,3,'2017-06-25',1 )
 ,(3,1,'2016-03-02',0 ),(3,4,'2018-07-03',5 );

 select * from activity;
