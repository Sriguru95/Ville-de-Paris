-- Requête 1 : Identifier les événements avec des titres manquants
\Prompt Requête pour détecter les événements avec des titres manquants
SELECT *
FROM Evenements
WHERE Titre IS NULL;

-- Requête 2 : Trouver les localisations en double
\Prompt Requête pour trouver les localisations en double
SELECT Nom_du_lieu, COUNT(*)
FROM Localisations
GROUP BY Nom_du_lieu
HAVING COUNT(*) > 1;

-- Requête 3 : Vérifier les coordonnées géographiques manquantes
\Prompt Requête pour vérifier les coordonnées géographiques manquantes
SELECT *
FROM Localisations
WHERE Latitude IS NULL OR Longitude IS NULL;

-- Requête 4 : Trouver les doublons dans les contacts
\Prompt Requête pour trouver les doublons dans les contacts
SELECT Url_de_contact, COUNT(*)
FROM Contacts
GROUP BY Url_de_contact
HAVING COUNT(*) > 1;

-- Requête 5 : Vérifier les URL de réservation manquantes
\Prompt Requête pour vérifier les URL de réservation manquantes
SELECT *
FROM Reservations
WHERE URL_de_reservation IS NULL;

-- Requête 6 : Détecter les images manquantes
\Prompt Requête pour détecter les images manquantes
SELECT *
FROM Image
WHERE url_de_limage IS NULL;
