
-- Préparation de la requête pour consulter les détails d'un événement par son ID
\prompt 'Entrez ID de événement: ' event_id
PREPARE event_details(INT) AS
SELECT 
    Titre, 
    URL, 
    Chapeau, 
    Description, 
    Date_de_debut, 
    Date_de_fin, 
    Type_de_prix, 
    Detail_du_prix, 
    Type_d_acces, 
    Date_de_mise_a_jour, 
    Programmes, 
    En_ligne_adress_url, 
    En_ligne_adress_text, 
    Audience, 
    Childrens, 
    Group_
FROM Evenements
WHERE ID = $1;

EXECUTE event_details(:event_id);

DEALLOCATE event_details;

-- Préparation de la requête pour consulter les détails d'une localisation par son nom
\prompt 'Entrez le nom de la localisation: ' location_name
PREPARE location_details(TEXT) AS
SELECT 
    Nom_du_lieu, 
    Adresse_du_lieu, 
    Code_postal, 
    Ville, 
    Latitude, 
    Longitude, 
    Acces_PMR, 
    Acces_mal_voyant, 
    Acces_mal_entendant 
FROM Localisations
WHERE Ville = $1;

EXECUTE location_details(:'location_name');

DEALLOCATE location_details;

-- Préparation de la requête pour consulter les détails de contact par son URL
\prompt 'Entrez URL de contact: ' contact_url
PREPARE contact_details(TEXT) AS
SELECT 
    Url_de_contact, 
    Telephone_de_contact, 
    Email_de_contact, 
    URL_Facebook_associee, 
    URL_Twitter_associee 
FROM Contacts
WHERE Url_de_contact = $1;

EXECUTE contact_details(:'contact_url');

DEALLOCATE contact_details;

-- Préparation de la requête pour consulter les détails de réservation par son URL
\prompt 'Entrez URL de réservation: ' reservation_url
PREPARE reservation_details(TEXT) AS
SELECT 
    URL_de_reservation, 
    URL_de_reservation_Texte 
FROM Reservations
WHERE URL_de_reservation = $1;

EXECUTE reservation_details(:'reservation_url');

DEALLOCATE reservation_details;

-- Préparation de la requête pour consulter les détails d'une image par son URL
\prompt 'Entrez URL de image: ' image_url
PREPARE image_details(TEXT) AS
SELECT 
    url_de_limage, 
    texte_alternatif_de_image, 
    credit_de_image 
FROM Image
WHERE url_de_limage = $1;

EXECUTE image_details(:'image_url');

DEALLOCATE image_details;

-- Préparation de la requête pour consulter les mots-clés par l'ID de l'événement
\prompt 'Entrez ID de événement: ' event_id
PREPARE keywords_by_event_id(INT) AS
SELECT 
    mot_cle 
FROM Mots_cle
WHERE ID_Evenement = $1;

EXECUTE keywords_by_event_id(:event_id);

DEALLOCATE keywords_by_event_id;

-- Préparation de la requête pour consulter les détails de transport par l'URL
\prompt 'Entrez URL de transport: ' transport_url
PREPARE transport_details(TEXT) AS
SELECT 
    Lien, 
    Metro, 
    Bus, 
    Velib 
FROM Transport
WHERE Lien = $1;

EXECUTE transport_details(:'transport_url');

DEALLOCATE transport_details;

-- Préparation de la requête pour consulter les détails d'une occurrence par son ID
\prompt 'Entrez ID de occurrence: ' occurrence_id
PREPARE occurrence_details(INT) AS
SELECT 
    Heure_debut, 
    Heure_fin 
FROM Occurrence
WHERE ID_occurrence = $1;

EXECUTE occurrence_details(:occurrence_id);

DEALLOCATE occurrence_details;