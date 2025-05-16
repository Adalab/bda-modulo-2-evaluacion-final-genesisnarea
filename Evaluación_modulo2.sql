USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezacan duplicados

SELECT * FROM film;

SELECT DISTINCT title AS Movies
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan clasificacíon de "PG-13"

SELECT title Movie, rating
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción

SELECT title Movie, description
FROM film 
WHERE description LIKE '%amazin%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120min

SELECT title Movie, length
FROM film
WHERE length > 120
ORDER BY length ASC;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame "nombre_actor" y contenga nombre y apellido

SELECT * FROM actor;

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20

SELECT actor_id, first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuenta el título de las películas en la tabla film que no tengan clasificación "R" ni "PG-13"

SELECT * FROM film;

SELECT title movie, rating
FROM film
WHERE rating NOT IN ('R','PG-13'); 

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento

SELECT COUNT(*) movies, rating
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido juntos con la cantidad de peliculas alquiladas

SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;


SELECT CONCAT(c.first_name, ' ', c.last_name) nombre_cliente, c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY customer_id, nombre_cliente
ORDER BY customer_id ASC;

-- 11. Encuentra la cantidad total de películas alquiladas por categoria y muestra el nombre de la categoria junto con el recuento de alquileres

SELECT * FROM film;
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT COUNT(*) rental_movie, c.name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración

SELECT * FROM film;

SELECT rating, AVG(length) promedio
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"

SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;

SELECT CONCAT(a.first_name, ' ', a.last_name) actor, f.title movie
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción

SELECT * FROM film;

SELECT title movie, description
FROM film
WHERE description LIKE '%dog%' or description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor

SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) actor
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT * FROM film;

SELECT title movie, release_year 
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoria "family"

SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

SELECT f.title movie, c.name category
FROM film f
JOIN film_category fa ON f.film_id = fa.film_id
JOIN category c ON c.category_id = fa.category_id
WHERE name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas

SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT CONCAT(a.first_name, ' ', a.last_name) actor, COUNT(fa.film_id) total_movies
FROM actor a 
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor
HAVING COUNT(fa.film_id) > 10
ORDER BY total_movies DESC;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film

SELECT * FROM film;

SELECT title movie, rating, length
FROM film
WHERE rating = 'R' AND length > 120
ORDER BY length ASC;

-- 20. Encuentra las categoría de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoria junto con el promedio de duración

SELECT * FROM film;
SELECT * FROM category;
SELECT * FROM film_category;

SELECT c.name category, ROUND(AVG(f.length)) duration
FROM category c
JOIN film_category fa ON c.category_id = fa.category_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado

SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;

SELECT a.first_name actor, COUNT(fa.film_id) total_movies
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor
HAVING COUNT(fa.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra. EJ: DATEDIFF(fecha_inicial, fecha_final)

SELECT * FROM film; 
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT f.title movie 
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN
	(SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5)
    GROUP BY movie;
    
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "horror".
-- utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoria "horror" y luego excluyelos de la lista

SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM category;
SELECT * FROM film_category;

SELECT CONCAT(a.first_name, ' ', a.last_name) actor
FROM actor a 
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror');

-- BONUS --

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subcosultas

SELECT * FROM film;
SELECT * FROM category;
SELECT * FROM film_category;

SELECT f.title movie
FROM film f 
WHERE f.length > 180 AND f.film_id IN (
	SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy');
    
-- 25. Encuentra todos los actores que han actuado juntos en al menos una película
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
-- Pista: podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente

SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT 
    CONCAT(a1.first_name, ' ',a1.last_name) AS actor1_name, CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name,
    COUNT(*) AS films
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id -- evita pares repetidos
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY actor1_name, actor2_name
HAVING COUNT(*) >= 1 -- trabajaron juntos al menos una vez
ORDER BY films DESC;






