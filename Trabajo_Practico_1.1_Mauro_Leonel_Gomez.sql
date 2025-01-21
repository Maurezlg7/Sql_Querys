-- NOMBRE/S: MAURO LEONEL
-- APELLIDO/S: GOMEZ

/*
Ejercicio 1
Usando la base de datos Sakila, obtener una lista de las películas que tienen como
idioma "Italian".
*/

USE sakila;
SELECT f.title FROM film AS f WHERE language_id = ANY (
	SELECT l.language_id FROM language as l WHERE l.name = "Italian"
);

/*
Ejercicio 2
Usando la base de datos Sakila, obtener una lista de los títulos de las películas cuya
categoría sea "Documentary".
*/

USE sakila;
SELECT f.title FROM film as f WHERE f.film_id IN (
	SELECT fc.film_id
    FROM film_category as fc
    WHERE fc.category_id IN (
		SELECT c.category_id
        FROM category as c WHERE c.name = "Documentary"
    )
);

/*
Ejercicio 3
Usando la base de datos World, se solicita obtener una lista con los nombres de los
países en los que se hable el idioma "Spanish" en más de un 50%.
*/

USE world;
SELECT c.Name FROM country as c WHERE c.Code IN (
	SELECT cl.CountryCode 
    FROM countrylanguage as cl 
    WHERE cl.language = "Spanish" AND cl.Percentage > 50
) ORDER BY c.Name ASC;

/*
Ejercicio 4
Usando la base de datos Sakila, obtener una lista de los nombres y apellidos de los
actores y la cantidad de películas en las que trabajaron.
Usar al menos una subconsulta correlacionada.
*/

USE sakila;
SELECT a.first_name, a.last_name, 
    (
		SELECT COUNT(*)
        FROM film_actor AS fa
        WHERE fa.actor_id = a.actor_id
	) AS cant_peliculas
FROM actor AS a
WHERE a.actor_id IN (
	SELECT actor_id FROM film_actor
) ORDER BY a.first_name, a.last_name ASC;

/*
Ejercicio 5
Usando la base de datos Sakila, obtener una lista de los nombres de todas las
películas y la cantidad de actores que trabajaron en ellas.
Usar al menos una subconsulta correlacionada.
*/

USE sakila;
SELECT f.title, (
	SELECT COUNT(fa.actor_id)
    FROM film_actor AS fa
    WHERE f.film_id = fa.film_id
)  AS cant_peliculas 
FROM film AS f
WHERE f.film_id IN (
	SELECT film_id FROM film_actor
)ORDER BY f.title ASC;

/*
Ejercicio 6
Usando la base de datos Sakila, obtener una lista de los nombres y apellidos de los
clientes (customer) que gastaron (payment) al menos $150 en alquileres.
Usar al menos una subconsulta correlacionada.
*/

USE sakila;
SELECT c.first_name, c.last_name 
FROM customer AS c
WHERE customer_id IN (
	SELECT p.customer_id
    FROM payment AS p
    GROUP BY p.customer_id
    HAVING SUM(p.amount) >= 150
) ORDER BY c.first_name, c.last_name ASC;

/*
Ejercicio 7
Usando la base de datos Sakila, obtener una lista de los nombres y apellidos de los
clientes (customer) que alquilaron (rental) al menos 35 películas.
Usar al menos una subconsulta correlacionada.
*/

USE sakila;
SELECT c.first_name, c.last_name 
FROM customer AS c
WHERE 35 <= ANY (
	SELECT COUNT(customer_id)
    FROM rental AS r
    WHERE r.customer_id = c.customer_id
) ORDER BY c.first_name, c.last_name ASC;

/*
Ejercicio 8
Usando la base de datos Sakila, obtener una lista de los nombres de las ciudades y
cuántos clientes viven en cada una.
Usar al menos una subconsulta correlacionada.
*/

USE sakila;
SELECT c.city, (
	SELECT COUNT(address_id)
    FROM customer AS cust
    WHERE cust.address_id IN (
		SELECT a.address_id FROM address AS a
        WHERE a.city_id = c.city_id
    )
) AS total FROM city AS c;