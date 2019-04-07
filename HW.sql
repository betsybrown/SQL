-- 1a. Display the first and last names of all actors from the table actor.
use sakila;
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
alter table actor
ADD COLUMN Actor_Name varchar(60);
SELECT CONCAT(first_name, " ", last_name, " ") AS Actor_Name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name='Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select*from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
ADD COLUMN description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name having count(*) >1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select first_name, last_name, actor_id from actor where first_name='GROUCHO';
UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172;
-- confirming
select first_name, last_name, actor_id from actor where first_name='GROUCHO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172;
-- confirming
select first_name, last_name, actor_id from actor where first_name='GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE actor;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
use sakila;
select staff.first_name, staff.last_name, address.address, address.address2, address.district, address.postal_code
from address
inner join staff on
staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member ipayment_daten August of 2005. Use tables staff and payment.
use sakila;
select staff.first_name, staff.last_name, staff.staff_id, sum(payment.amount), payment.payment_date
from payment
inner join staff on
staff.staff_id=payment.staff_id
where payment.payment_date between '2005-08-01' AND '2005-08-31'
group by staff.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
use sakila;
select film.title, count(film_actor.actor_id)
from film_actor
inner join film on
film.film_id=film_actor.actor_id
group by film.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title, count(inventory.film_id)
from inventory 
inner join film on
inventory.film_id=film.film_id
where film.title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.last_name, customer.first_name, sum(payment.amount)	
from payment
inner join customer on
payment.customer_id=customer.customer_id
group by customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
	select film.title, language_id
	from film
	where language_id in
	(
		select language_id
		from film
		where language_id ='1' 
	)
    and (
		film.title like 'k%' or film.title like 'q%'
    );


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select film_actor.actor_id, actor.first_name, actor.last_name 
	from film_actor
    join actor on film_actor.actor_id=actor.actor_id
    join film on film_actor.film_id=film.film_id
    where film_actor.film_id=
    (select film_id from film where title ='Alone Trip'
);



-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email from customer
join address on customer.address_id=address.address_id
join city on address.city_id=city.city_id
join country on city.country_id=country.country_id
where country.country='Canada';



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film
join film_category on
film.film_id=film_category.film_id
join category on film_category.category_id=category.category_id
where category.name='Family';


-- 7e. Display the most frequently rented movies in descending order.
select count(film.title) AS 'No of Times Rented', title as 'Film Name' from film
join inventory on inventory.film_id=film.film_id
join rental on rental.inventory_id=inventory.inventory_id
group by film.title desc
order by count(film.title);


-- 7f. Write a query to display how much business, in dollars, each store brought in.

select store, total_sales from sales_by_store;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country from store
join address on store.adddress_id=address.address_id
join city on address.city_id=city.city_id
join country on city.country_id=country.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

Select sum(payment.amount), category.name  from payment
join rental on rental.rental_id=payment.rental_id
join inventory on inventory.inventory_id=rental.inventory_id
join film_category on film_category.film_id=inventory.film_id
join category on category.category_id=film_category.category_id
group by category.name 
order by sum(payment.amount) desc
limit 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_genres as 
Select sum(payment.amount), category.name  from payment
join rental on rental.rental_id=payment.rental_id
join inventory on inventory.inventory_id=rental.inventory_id
join film_category on film_category.film_id=inventory.film_id
join category on category.category_id=film_category.category_id
group by category.name 
order by sum(payment.amount) desc
limit 5;

-- 8b. How would you display the view that you created in 8a?

select * from top_genres;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_genres;

