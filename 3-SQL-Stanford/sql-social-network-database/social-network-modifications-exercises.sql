/*********** SQL Social-Network Modification Exercises ************/


/* 1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete from highschooler
where id in ( 
select id from highschooler where grade = 12);

/* 2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuples. */
delete from likes where likes.id1 in 
 (
select likes.id1 from likes, friend where likes.id1 not in 
(
select l1.id1
from likes l1, likes l2
where l1.id2 = l2.id1 and l1.id1 = l2.id2
)
and likes.id1 = friend.id1 and friend.id2 = likes.id2);

/* 3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the 
      pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships 
      with oneself. (This one is a bit challenging; congratulations if you get it right.) */
insert into friend
select a.id1 as id_1,  b.id2 as id_2 from
( friend a join friend b on a.id2 = b.id1 )
where a.id1 <> b.id2 
group by a.id1, b.id2 
except
select * from friend;


