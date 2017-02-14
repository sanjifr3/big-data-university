/*********** SQL Social-Network Query Exercises ************/

/* 1. Find the names of all students who are friends with someone named Gabriel. */

select h1.name
from friend, highschooler h1, highschooler h2
where h1.id = id1 and h2.id = id2 and h2.name="Gabriel";

/* 2. For every student who likes someone 2 or more grades younger than themselves, return that student's 
      name and grade, and the name and grade of the student they like. */

select h1.name,h1.grade,h2.name, h2.grade
from likes, highschooler h1, highschooler h2
where h1.id = id1 and h2.id = id2 and h1.grade - h2.grade >= 2;

/* 3. For every pair of students who both like each other, return the name and grade of both students. 
      Include each pair only once, with the two names in alphabetical order. */

select lh.name, lh.grade, rh.name, rh.grade
from highschooler lh, highschooler rh,
(select l1.id1 as leftid, l1.id2 as rightid, l2.id1, l2.id2
from likes l1, likes l2
where l1.id2 = l2.id1 and l1.id1 = l2.id2)
where (leftid = 1709 or leftid = 1501) and lh.id = leftid and rh.id = rightid;

select h1.name, h1.grade, h2.name, h2.grade
from likes l1, likes l2, highschooler h1, highschooler h2
where l1.id2 = l2.id1
and h1.id = l1.id1
and h2.id = l1.id2
and  l1.id1 = l2.id2
and l2.id1 < l1.id1


/* 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and 
      return their names and grades. Sort by grade, then by name within each grade. */

select name, grade
from highschooler
where id not in (select id1 from likes union select id2 from likes)
order by grade, name;

/* 5. For every situation where student A likes student B, but we have no information about whom B likes 
      (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes
where h1.id = id1 and h2.id = id2
	and id2 not in (select id1 from likes);

/* 6. Find names and grades of students who only have friends in the same grade. Return the result sorted 
      by grade, then by name within each grade. */

SELECT h1.name, h1.grade
FROM friend, highschooler h1,highschooler h2
WHERE h1.id = id1 and h2.id = id2
group by id1
having  sum(abs(h1.grade - h2.grade)) = 0
order by h1.grade, h1.name;

/* 7. For each student A who likes a student B where the two are not friends, find if they have a friend C 
      in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */

select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade  from friend f1, friend f2, highschooler h1, highschooler h2, highschooler h3,
(
	select likes.id1 as id_1, likes.id2 as id_2 from likes 
	where likes.id1 not in 
	(
		select likes.id1
		from likes, friend
		where likes.id1 = friend.id1 and likes.id2 = friend.id2
	)
)
where id_1 = f1.id1 and f1.id2 = f2.id1 and f2.id2 = id_2
	and h1.id = id_1 and h2.id = id_2 and h3.id = f1.id2;

/* 8. Find the difference between the number of students in the school and the number of different first 
      names. */
select count(*) - count(distinct name) from highschooler;

/* 9. Find the name and grade of all students who are liked by more than one other student. */
select name, grade
from likes, Highschooler
where id = id2
group by id2
having count(id1) > 1;

/*********** SQL Social-Network Query Exercises Extras ************/

/* 1. For every situation where student A likes student B, but student B likes a different student C, 
      return the names and grades of A, B, and C. */

select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes l1, likes l2
where h1.id = l1.id1 and h2.id = l1.id2 and h3.id = l2.id2 and l1.id2 = l2.id1
and h1.name <> h3.name;

/* 2. Find those students for whom all of their friends are in different grades from themselves. Return
      the students' names and grades. */

select name, grade from highschooler where
id not in
(
	select distinct h1.id
	from highschooler h1, highschooler h2, friend
	where h1.id = id1 and h2.id = id2
	and h1.grade = h2.grade
)

/* 3. What is the average number of friends per student? (Your result should be just one number.) */

select avg(num_friends) from 
(
	select count(*) as num_friends
	from friend
	group by id1
)

/* 4. Find the number of students who are either friends with Cassandra or are friends of friends of 
      Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */

select count(*)
from highschooler h1, highschooler h2, highschooler h3, friend f1, friend f2
where h1.id = f1.id1 and h2.id = f1.id2 and h3.id = f2.id2 and f1.id2 = f2.id1
and h1.name <> h3.name 
and h2.name <> h3.name 
and (h2.name = 'Cassandra' or h3.name = 'Cassandra')

/* 5. Find the name and grade of the student(s) with the greatest number of friends. */

select h1.name, h1.grade 
from highschooler h1, friend
where h1.id = friend.id1
group by id1
having count(*) =  
(
	select max(num_friends) from 
	(
		select count(*) as num_friends
		from friend
		group by id1
	)
)





