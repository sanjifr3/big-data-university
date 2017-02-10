/****SQL Movie-Rating Query Exercises *****/

/* 1. Find the titles of movies directed by Steven Spielberg */
select title 
from movie 
where director = 'Steven Spielberg';

/* 2. Find all years that have a movie that received a rating of 4 or 5, 
      and sort them in increasing order. */
select year 
from movie 
where mid in (select mid from rating where stars >= 4) 
order by year asc;

/* 3. Find the titles of all movies that have no ratings. */
select title
from Movie
where mID not in (select mid from rating);

/* 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers 
       who have ratings with a NULL value for the date. */
select name
from reviewer
where rid  in ( select rid from rating where ratingDate is null);

/* 5. Write a query to return the ratings data in a more readable format: reviewer name, movie 
      title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie 
      title, and lastly by number of stars. */
SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
FROM Reviewer
JOIN Rating
JOIN Movie
ON Reviewer.rID = Rating.rID AND  Rating.mID = Movie.mID
ORDER BY Reviewer.name, Movie.title, Rating.stars;

/* 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating 
      the second time, return the reviewer's name and the title of the movie. */
select name, title
from movie, rating A, reviewer, rating B
where movie.mid = A.mid and reviewer.rid = A.rid 
  and A.mid in ( select mid from Rating group by mid,rid having count(*) = 2 )
  and A.rid in ( select rid from Rating group by mid,rid having count(*) = 2 )
  and A.stars > B.stars
  and B.riD = A.rID
  and B.mid= A.mid
  and A.ratingDate > B.ratingDate;
 
/*  7. For each movie that has at least one rating, find the highest number of stars that movie 
       received. Return the movie title and number of stars. Sort by movie title. */ 
select title, max(stars)
from movie, rating
where movie.mid = rating.mid
group by title
order by title;

/* 8. For each movie, return the title and the 'rating spread', that is, the difference between 
      highest and lowest ratings given to that movie. Sort by rating spread from highest to 
      lowest, then by movie title. */
select title, max (mx-mn) from (
select title, min(stars) as mn, max(stars) as mx
from movie, rating
where movie.mid = rating.mid
group by title )
group by title
order by max(mx-mn) desc, title;

/* 9. Find the difference between the average rating of movies released before 1980 and the 
      average rating of movies released after 1980. (Make sure to calculate the average rating 
      for each movie, then the average of those averages for movies before 1980 and movies after. 
      Don't just calculate the overall average rating before and after 1980.) */
select avg(case when year < 1980 then movie_avg else null end) 
        - avg(case when year > 1980 then movie_avg else null end) 
            from (select title, year, avg(stars) as movie_avg
from movie, rating
where movie.mid = rating.mid
group by title
order by year, title);

/****SQL Movie-Rating Query Exercises Extras *****/

/* 1. Find the names of all reviewers who rated Gone with the Wind.  */
select distinct name
from movie,rating,reviewer
where movie.mid = rating.mid
and rating.rid = reviewer.rid
and movie.title = "Gone with the Wind";

/* 2. For any rating where the reviewer is the same as the director of the movie, return the 
      reviewer name, movie title, and number of stars. */
select name, title, max(stars)
from movie,rating,reviewer
where movie.mid = rating.mid
and director = name;

/* 3. Return all reviewer names and movie names together in a single list, alphabetized. 
      (Sorting by the first name of the reviewer and first word in the title is fine; no need for 
      special processing on last names or removing "The".)  */
select distinct title
from movie
union
select distinct name
from reviewer
order by title;

/* 4. Find the titles of all movies not reviewed by Chris Jackson. */
select title
from movie
where mid not in (
select mid
from rating, reviewer
where reviewer.rid = rating.rid
and name = "Chris Jackson");

/* 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return 
      the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and 
      include each pair only once. For each pair, return the names in the pair in alphabetical order. 
      */

/* WRONG ANSWER */

select re1.name, re2.name
from reviewer re1, reviewer re2, rating r1, rating r2
where re1.rid = r1.rid
and re2.rid = r2.rid
and r1.mid = r2.mid
and r1.rid < r2.rid
group by r1.mid, r1.rid
order by re1.name, re2.name;

/* 6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer 
      name, movie title, and number of stars. */

/* WRONG ANSWER */

select name,title,stars
from rating,movie,reviewer 
where rating.rid = reviewer.rid and movie.mid = rating.mid 
group by title
having min(stars) = (select min(stars) from rating)
order by title,name;

/* 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies 
      have the same average rating, list them in alphabetical order. */
select name,title,stars
from rating,movie,reviewer 
where rating.rid = reviewer.rid and movie.mid = rating.mid 
group by title
having min(stars) = (select min(stars) from rating)
order by title,name;

/* 8. Find the names of all reviewers who have contributed three or more ratings. (As an extra 
      challenge, try writing the query without HAVING or without COUNT.) */
select name,title,stars
from rating,movie,reviewer 
where rating.rid = reviewer.rid and movie.mid = rating.mid 
group by title
having min(stars) = (select min(stars) from rating)
order by title,name;

/* 9. Some directors directed more than one movie. For all such directors, return the titles of all 
      movies directed by them, along with the director name. Sort by director name, then movie title. 
      (As an extra challenge, try writing the query both with and without COUNT.) */
select title, director
from movie
where director in (
select director
from movie
group by director
having count(*) > 1)
order by director,title;

/* 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
       (Hint: This query is more difficult to write in SQLite than other systems; you might think of it 
       as finding the highest average rating and then choosing the movie(s) with that average rating.)*/
select title, avg(stars) from movie, rating
where movie.mid = rating.mid 
group by title
having avg(stars) = (
	select max(avg_stars) 
 	from ( select title, avg(stars) as avg_stars
			from movie, rating
			where movie.mid = rating.mid
			group by title
 		 )
		 );

/* 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
       (Hint: This query may be more difficult to write in SQLite than other systems; you might think of 
       it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
       */
select title, avg(stars) from movie, rating
where movie.mid = rating.mid 
group by title
having avg(stars) = (


select min(avg_stars) 
 from ( select title, avg(stars) as avg_stars
			from movie, rating
			where movie.mid = rating.mid
			group by title
 		 )
		 );


/* 12. For each director, return the director's name together with the title(s) of the movie(s) they 
       directed that received the highest rating among all of their movies, and the value of that rating. 
       Ignore movies whose director is NULL.*/
select director,title,max(stars) from movie, rating
where director is not null
and movie.mid = rating.mid
group by directo






