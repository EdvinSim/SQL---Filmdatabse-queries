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
FROM film INNER JOIN filmcountry USING (filmid)
GROUP BY country
ORDER BY count(*) DESC
;
--svar: 189 rows??? Fasiten er 190. Der country er NULL mangler?


--Oppgave 3 - Spilletider
--TODO oppgaven sier hvor country ikke er lik NULL
SELECT country, avg(cast(time AS int))
FROM runningtime
WHERE time ~ '^\d+$'
GROUP BY country HAVING count(time) >= 200
;
--svar: 45?? Fasit er 44.


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