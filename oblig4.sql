--IN2090, oblig 4

--DEL 1

--OPPGAVE 1 - Oppvarming
SELECT p.firstname, p.lastname, fc.filmcharacter
FROM film AS f
    INNER JOIN filmparticipation AS fp USING (filmid)
    INNER JOIN person AS p USING (personid)
    INNER JOIN filmcharacter AS fc USING (partid)
WHERE f.title = 'Star Wars' AND fp.parttype = 'cast'
;
--Svar: 108 rows



--OPPGAVE 2 - Land
SELECT country, count(*)
FROM filmcountry
GROUP BY country
ORDER BY count(*) DESC
;
--svar: 190



--Oppgave 3 - Spilletider
SELECT country, avg(cast(time AS int))
FROM runningtime
WHERE time ~ '^\d+$' AND country != '' --Her funket det ikke aa skrive NULL. Oppgaven sier hvor country ikke er lik NULL
GROUP BY country HAVING count(time) >= 200
;
--svar: 44



--OPPGAVE 4 - Komplekse mennesker
SELECT title, count(*) AS genres
FROM film INNER JOIN filmgenre USING (filmid)
GROUP BY filmid, title
ORDER BY count(*) DESC, title
LIMIT 10
;
/*
svar:
               title               | genres
-----------------------------------+--------
 Matilda                           |      9
 Pokémon Heroes                    |      9
 Utopia's Redemption               |      9
 Chiquititas: Rincón de luz        |      8
 Conker's Bad Fur Day              |      8
 Dai-Rantô Smash Brothers Deluxe   |      8
 Elder Scrolls III: Morrowind, The |      8
 Escaflowne                        |      8
 Fainaru fantajî XII               |      8
 Gwoemul                           |      8
(10 rows)
*/



--OPPGAVE 5

--Table with country, genres and number og movies in each genre for each country.
WITH country_genre_count AS (
    SELECT country, genre, count(*)
    FROM filmcountry
        INNER JOIN filmgenre USING (filmid)
    GROUP BY country, genre
    ORDER BY country, count DESC
)

--Table with country and name of most popular genre.
, country_most_pop_genre AS (
SELECT c.country, genre AS most_popular_genre
FROM country_genre_count AS c
    INNER JOIN (

        --Table with country and the number of movies in most popular genre.
        SELECT country, max(count)
        FROM country_genre_count
        GROUP BY country

    ) as m ON c.country = m.country AND m.max = c.count
)

--Table with number of films, avrage filmrating and most popular genre for each country.
SELECT *
FROM (
    SELECT country, count(country) AS films, avg(rank) AS avg_rating
    FROM filmcountry
        LEFT OUTER JOIN filmrating USING (filmid) --Must LEFT JOIN to include films with no rating in film count.
    GROUP BY country
    ORDER BY films DESC
) AS films_and_avgRating
    INNER JOIN country_most_pop_genre USING (country)
;
--Svar: 199 rows??? Fasit paa discorse sier sier 172 eller 190 rader. Noen land har likt antall mest pop genre!

--Spør om: Noen land har flere most_pop_genre.



--OPPGAVE 6 - Vennskap
SELECT *

FROM (
    WITH p AS (
        SELECT concat(firstname, ' ', lastname) AS name, filmid
        FROM film
            INNER JOIN filmcountry USING (filmid)
            INNER JOIN filmparticipation AS fp USING (filmid)
            INNER JOIN person USING (personid)
        WHERE country = 'Norway' --AND fp.parttype = 'cast'
        ORDER BY name
    )

        SELECT p1.name, p2.name, count(*) AS films_together
        FROM p AS p1
            
            INNER JOIN p AS p2 
                ON p1.filmid = p2.filmid
                AND p1.name != p2.name
                AND p1.name < p2.name --This takes away duplicate pairs, because p is ordered by name alfabetically.
        GROUP BY p1.name, p2.name
) AS actors_in_same_films
WHERE films_together >= 40
ORDER BY films_together DESC
;
--Svar:
/*
      name       |      name      | films_together
-----------------+----------------+----------------
 Petter Vennerød | Svend Wam      |             47
 Knut Bohwim     | Per A. Anonsen |             42
(2 rows)
*/


--DEL 2

--OPPGAVE 7 - Mot
SELECT title, year
FROM film
    INNER JOIN filmdescription USING (filmid)
    LEFT JOIN filmgenre USING (filmid)
    LEFT JOIN filmcountry USING (filmid)
WHERE (title LIKE '%Dark%' OR title LIKE '%Night%')
    AND (genre = 'Horror' OR country = 'Romania')
;
--Svar: 498 rows??? fasit sier 457.


--OPPGAVE 8 - Lunsj
SELECT title, count
FROM film
    INNER JOIN (

        --filmid and number of participants
        SELECT filmid, count(*)
        FROM film
            INNER JOIN filmdescription USING (filmid)
            LEFT JOIN filmparticipation USING (filmid)
        WHERE year >= '2010'
        GROUP BY filmid, title
        ORDER BY count

    ) AS num USING (filmid)
WHERE count <= 2
;
--Svar: 7 rows??? Fasit sier 28.


--OPPGAVE 9 - Introspeksjon
SELECT count(*)
FROM filmgenre
WHERE genre != 'Sci-Fi' AND genre != 'Horror'
;
--Svar: 661869 filmer


--OPPGAVE 10 - Kompetanseheving 
