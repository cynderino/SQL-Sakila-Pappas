USE sakila;

-- 1a.  Display the first and last names of all actors from the table `actor`.

SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT 
    CONCAT(first_name, last_name) AS ' Actor Name'
FROM
    actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 

SELECT 
    first_name, last_name, actor_id
FROM
    actor
WHERE
    first_name = 'JOE';

-- 2b Find all actors whose last name contain the letters `GEN`

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c Find all actors whose last names contain the letters `LI`

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`

SELECT 
    *
FROM
    actor;
ALTER TABLE actor
ADD COLUMN  middle_name VARCHAR(50) AFTER first_name;

-- 3b You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB;

-- 3c Now delete the `middle_name` column

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a List the last names of actors, as well as how many actors have that last name

SELECT 
    last_name, COUNT(*) AS `Count`
FROM
    actor
GROUP BY last_name;

-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT 
    last_name, COUNT(*) AS `Count`
FROM
    actor
GROUP BY last_name
HAVING Count > 2;

-- 4c The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS'. Write a query to fix the record.

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- 4d the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`

UPDATE actor 
SET 
    first_name = 'MUCHO GROUCHO'
WHERE
    first_name = 'HARPO';

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';

-- 5a You cannot locate the schema of the `address` table. Which query would you use to re-create it?

DESCRIBE sakila.address

-- 6a Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`

SELECT 
    s.first_name, s.last_name, a.address_id
FROM
    staff s
        INNER JOIN
    address a ON s.address_id=a.address_id;


-- 6b Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`
SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    p.amount,
    p.payment_date
FROM
    staff s
        INNER JOIN
    payment p ON s.staff_id = p.staff_id
        AND payment_date LIKE '2005-08%';

-- 6c List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join
SELECT 
    f.title, COUNT(a.actor_id) AS 'TOTAL'
FROM
    film f
        LEFT JOIN
    film_actor a ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 
    COUNT(inventory_id) AS 'Total Movie Count'
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');

-- 6e Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
SELECT 
    c.first_name, c.last_name, SUM(p.amount) AS 'TOTAL'
FROM
    customer c
        LEFT JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name , c.last_name
ORDER BY c.last_name

-- 7a Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English

SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id = (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')

-- 7b Use subqueries to display all actors who appear in the film `Alone Trip'

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'ALONE TRIP'));

-- 7c  Use joins to retrieve this information.
      
SELECT 
    first_name, last_name, email
FROM
    customer cu
        JOIN
    address a ON (cu.address_id = a.address_id)
        JOIN
    city cit ON (a.city_id = cit.city_id)
        JOIN
    country cntry ON (cit.country_id = cntry.country_id);

-- 7d Identify all movies categorized as famiLy films
SELECT 
    Title
FROM
    film f
        JOIN
    film_category fcat ON (f.film_id = fcat.film_id)
        JOIN
    category c ON (fcat.category_id = c.category_id);

-- 7e Display the most frequently rented movies in descending order

SELECT 
    Title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM
    film f
        JOIN
    inventory i ON (f.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
GROUP BY title
ORDER BY Count_of_Rented_Movies DESC;

-- 7f Write a query to display how much business, in dollars, each store brought in
SELECT 
    s.store_id, SUM(p.amount)
FROM
    payment p
        JOIN
    staff s ON (p.staff_id = s.staff_id)
GROUP BY store_id;

-- 7g Write a query to display for each store its store ID, city, and country
SELECT 
    store_id, city, country
FROM
    store s
        JOIN
    address a ON (s.address_id = a.address_id)
        JOIN
    city c ON (a.city_id = c.city_id)
        JOIN
    country cntry ON (c.country_id = cntry.country_id);

-- 7h List the top five genres in gross revenue in descending order
SELECT 
    c.name AS 'Top Five', SUM(p.amount) AS 'Gross'
FROM
    category c
        JOIN
    film_category fc ON (c.category_id = fc.category_id)
        JOIN
    inventory i ON (fc.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
        JOIN
    payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- 8a the Top five genres by gross revenue

SELECT 
    c.name AS 'TopFive', SUM(p.amount) AS 'Gross'
FROM
    category c
        JOIN
    film_category fc ON (c.category_id = fc.category_id)
        JOIN
    inventory i ON (fc.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
        JOIN
    payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- 8b How would you display the view that you created in 8a?
SELECT * FROM (TopFive)

-- 8c You find that you no longer need the view `top_five_genres`. Write a query to delete it
DROP VIEW TopFive