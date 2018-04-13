-- 1a. a list of all the actors who have Display the first and last names of all actors from the table actor.
Select first_Name, Last_name
From actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select upper(concat(first_name," ",last_name))
AS `Actor Name`
from actor;

-- 2a.  to find the ID number, first name, and last name of an actor, only know the first name JOE
Select actor_id, first_name, last_name
from actor
where first_name="JOE";

-- 2b. Find all actors whose last name contain the letters GEN:
Select actor_id, first_name, last_name
from actor
-- use wildcard
where last_name LIKE "%GEN%";

-- 2c.Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
Select actor_id, first_name, last_name
From actor
-- use wild card
where last_name LIKE "%LI%"
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
Select country_id country
from country
where country in ('Afghanistan', 'Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
ALTER TABLE actor add column middle_name varchar (30);

-- 3b. . Change the data type of the middle_name column to blobs
Alter table actor change column middle_name TYPE blob;

-- 3c. Now delete the middle_name column.
Alter table actor drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name
Select last_name, 
count(last_name)
from actor
group by last_name;

-- 4b . List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 1;

-- 4c. change Harpo williams's name to Groucho Williams
update actor
set first_name= 'Harpo', last_name='Williams'
where first_name= 'Groucho' and last_name='Williams';

-- 4d. if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error.

update actor
set first_name=(
case
when first_name like 'Harpo' and last_name ='Williams'
then 'Groucho'
when first_name like 'Groucho' and last_name = 'Williams'
then 'Mucho Groucho'
else frist_name
end );


-- 5a You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select s.first_name, s.last_name, a.address
from staff s
join address a 
on s.address_id=a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.first_name, s.last_name, SUM(p.amount) as 'staff payment amount'
from staff s
join payment p 
on s.staff_id= p.staff_id
group by s.first_name, s.last_name, p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(fa.actor_id) as number_of_actors
from film f
inner join film_actor fa
on f.film_id=fa.film_id
group by f.title, fa.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.film_id) as Copies_of_Hunchback_Impossible
from film f
right join inventory i 
on f.film_id= i.film_id
where f.title like 'Hunchback Impossible'
group by f.title, i.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select cus.first_name, cus.last_name,SUM(p.amount)
from customer cus
right join payment p 
on cus.customer_id=p.customer_id
group by cus.first_name, cus.last_name, p.customer_id
-- order by ascending last name (alphabetically)
order by cus.last_name asc; 

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title
from film f
join language l
on f.language_id=l.language_id
where f.title like"K%" and l.language_id=1
or f.title like "Q%" and l.language_id=1;

-- 7b.  Use subqueries to display all actors who appear in the film Alone Trip.
select Alonetrip.first_name, Alonetrip.last_name
from 
(select f.title, a.first_name, a.last_name
from film f
right join film_actor fa
on f.film_id=fa.film_id
join actor a
on fa.actor_id=a.actor_id) Alonetrip
where Alonetrip.title like'Alone Trip';

-- 7c. the names and email addresses of all Canadian customers.
select cus.first_name, cus.last_name, cus.email
from customer cus
join address a
on cus.address_id=a.address_id
join city 
on a.city_id=city.city_id
join country co
on co.country_id=city.country_id
where co.country like'Canada'; 

-- 7d.  Identify all movies categorized as famiy films.
select f.title
from film f
join film_category fc
on f.film_id=fc.film_id
join category c
on fc.category_id=c.category_id
where c.name like "Family";

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(r.rental_id)
from film f
join inventory i
on f.film_id= i.film_id
join rental r
on i.inventory_id=r.inventory_id
group by f.title
order by count(r.rental_id)desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, SUM(p.amount) as $_Store_Brought
from payment p
join staff 
on p.staff_id = staff.staff_id
join store s
on s.store_id=staff.store_id
group by s.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, country.country
from staff s
join address a 
on s.address_id= a.address_id
join city c
on a.city_id= c.city_id
join country
on country.country_id=c.country_id;

-- 7h.List the top five genres in gross revenue in descending order. 
select c.name, sum(p.amount) as Top_five_genres
from payment p
join rental r
on p.rental_id=r.rental_id
join inventory i
on r.inventory_id=i.inventory_id
join film_category film
on film.film_id=i.film_id
join category c
on film.category_id=c.category_id
group by c.name, c.category_id
order by Sum(p.amount)DESC
limit 5;

-- 8a. top five genres by gross revenue. 
Create or replace view top_5_gross_genres as 
select c.name,sum(p.amount) as top_5_gross_genre
from payment p
join rental r
on p.rental_id=r.rental_id
join inventory i
on r.inventory_id=i.inventory_id
join film_category film
on film.film_id=i.film_id
join category c
on film.category_id=c.category_id
group by c.name, c.category_id
order by Sum(p.amount)DESC
limit 5;

-- 8b. display 8a
select * 
from top_5_gross_genres;

-- 8c. delete top_five_genres
drop view top_5_gross_genres;