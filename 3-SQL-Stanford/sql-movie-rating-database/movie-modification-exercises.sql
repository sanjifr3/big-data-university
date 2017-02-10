/****SQL Movie-Rating Modification Exercises *****/

/* 1. Add the reviewer Roger Ebert to your database, with an rID of 209.  */
insert into reviewer values (209,"Roger Ebert");

/* 2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into Rating
select (select rid from reviewer where name="James Cameron") as rID, mID, 5 as stars, null as ratingDate
from movie;

/* 3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update 
      the existing tuples; don't insert new tuples.) */

/* INCORRECT ANSWER */

update movie
set year = year + 25
where mid in (
select movie.mid
from movie, rating
where movie.mid = rating.mid
group by movie.mid
having avg(stars) >= 4.0
order by movie.mid, stars
)

/* 4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 
      4 stars. */
delete from rating
where mid in (
select movie.mid from rating, movie
where movie.mid = rating.mid and (year < 1970 or year > 2000) and stars < 4
) 
and rid in ( select rid from rating, movie
where movie.mid = rating.mid and (year < 1970 or year > 2000) and stars < 4)
and stars < 4;