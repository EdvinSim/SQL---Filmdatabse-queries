--IN2090, oblig 4

--Oppgave 1 - Oppvarming
SELECT p.firstname, p.lastname, fc.filmcharacter
FROM film AS f
    INNER JOIN filmparticipation AS fp USING (filmid)
    INNER JOIN person AS p USING (personid)
    INNER JOIN filmcharacter AS fc USING (partid)
WHERE f.title = 'Star Wars' AND fp.parttype = 'cast'
;
--Svar: 108 rows


--Oppgave 2 - Land
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


--Oppgave 4 - Komplekse mennesker
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

--Oppgave 5
--Her er det lavere antall filmer i hvert land enn i oppgave 2. Fordi noen filmer ikke har noen rating?
--TODO vise genre ogsaa!!
SELECT country, count(country) AS films, avg(rank) AS avg_rating
FROM filmcountry
    INNER JOIN filmrating USING (filmid)
GROUP BY country
ORDER BY country
;
--svar: 173 rows??? Fasit paa discorse sier sier 172 rader.

--Table with country, genres and number og movies in each genre for each country.
WITH country_genre_count AS (
    SELECT country, genre, count(*)
    FROM filmcountry
        INNER JOIN filmgenre USING (filmid)
    GROUP BY country, genre
    ORDER BY country, count DESC
)

SELECT country, max(count)
FROM country_genre_count
GROUP BY country
;


--Oppgave 6 - Vennskap
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
--Her faar jeg kun opp 2 svar, slik fasit sier, hvis vi tar vekk fp.parttype cast?
--Dvs. at de som har jobbet i mer enn 40 filmer sammen ikke er skuepsillere?