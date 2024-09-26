DROP TABLE IF EXISTS Occurrence;
DROP TABLE IF EXISTS Mots_cle;
DROP TABLE IF EXISTS Transport;
DROP TABLE IF EXISTS Image;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Contacts;
DROP TABLE IF EXISTS Localisations;
DROP TABLE IF EXISTS Evenements;

-- Suppression de la table temporaire Evenements_temp
DROP TABLE IF EXISTS temp_data;

CREATE TABLE Evenements (
    ID SERIAL PRIMARY KEY,
    Titre TEXT NOT NULL,
    URL TEXT NOT NULL UNIQUE,
    Chapeau TEXT,
    Description TEXT,
    Date_de_debut TIMESTAMP,
    Date_de_fin TIMESTAMP,
    Type_de_prix TEXT,
    Detail_du_prix TEXT,
    Type_d_acces TEXT,
    Date_de_mise_a_jour TIMESTAMP,
    Programmes TEXT,
    En_ligne_adress_url TEXT,
    En_ligne_adress_text TEXT,
    Audience TEXT,
    Childrens TEXT,
    Group_ TEXT
);


CREATE TABLE Localisations (
    Nom_du_lieu VARCHAR(255) PRIMARY KEY, 
    Adresse_du_lieu VARCHAR(255),
    Code_postal VARCHAR(255),
    Ville VARCHAR(100),
    Latitude FLOAT,
    Longitude FLOAT,
    Acces_PMR BOOLEAN DEFAULT FALSE,
    Acces_mal_voyant BOOLEAN DEFAULT FALSE,
    Acces_mal_entendant BOOLEAN DEFAULT FALSE,
    ID_Evenement INT,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID),
    CONSTRAINT nom_du_lieu_unique UNIQUE (Nom_du_lieu)  -- Ajout de contrainte d'unicité
);


CREATE TABLE Contacts (
    Url_de_contact TEXT PRIMARY KEY,
    Telephone_de_contact VARCHAR(20),
    Email_de_contact VARCHAR(255),
    URL_Facebook_associee TEXT,
    URL_Twitter_associee TEXT,
    ID_Evenement INT NOT NULL,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID)
);

CREATE TABLE Reservations (
    URL_de_reservation TEXT PRIMARY KEY,
    URL_de_reservation_Texte TEXT,
    ID_Evenement INT NOT NULL,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID)
);

CREATE TABLE Image (
    url_de_limage TEXT PRIMARY KEY,
    texte_alternatif_de_image TEXT,
    credit_de_image TEXT,
    ID_Evenement INT NOT NULL,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID)
);

CREATE TABLE Mots_cle (
    ID_mot_cle SERIAL PRIMARY KEY,
    mot_cle VARCHAR(255),
    ID_Evenement INT NOT NULL,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID)
);


CREATE TABLE Transport (
    Lien TEXT  PRIMARY KEY,
    Metro TEXT,
    Bus TEXT,
    Velib TEXT,
    ID_Evenement INT NOT NULL,
    Nom_du_lieu VARCHAR(255),
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID),
    FOREIGN KEY (Nom_du_lieu) REFERENCES Localisations(Nom_du_lieu)
);

CREATE TABLE Occurrence (
    ID_occurrence SERIAL PRIMARY KEY,
    Heure_debut TIME,
    Heure_fin TIME,
    ID_Evenement INT NOT NULL,
    FOREIGN KEY (ID_Evenement) REFERENCES Evenements(ID)
);

-- Création de la table temporaire avec toutes les colonnes
CREATE TEMP TABLE temp_data (
    ID INT,
    URL TEXT,
    Titre TEXT,
    Chapeau TEXT,
    Description TEXT,
    Date_de_debut TIMESTAMP, 
    Date_de_fin TIMESTAMP, 
    Occurrences TEXT,
    Description_de_la_date TEXT,
    url_de_limage TEXT,
    texte_alternatif_de_image TEXT,
    credit_de_image TEXT,
    Mots_cles TEXT,
    Nom_du_lieu TEXT,
    Adresse_du_lieu TEXT,
    Code_postal TEXT,
    Ville TEXT,
    Coordonnees_geographiques TEXT,
    Acces_PMR BOOLEAN,
    Acces_mal_voyant BOOLEAN,
    Acces_mal_entendant BOOLEAN,
    Transport TEXT,
    Url_de_contact TEXT,
    Telephone_de_contact TEXT,
    Email_de_contact TEXT,
    URL_Facebook_associee TEXT,
    URL_Twitter_associee TEXT,
    Type_de_prix TEXT,
    Detail_du_prix TEXT,
    Type_d_acces TEXT,
    URL_de_reservation TEXT,
    URL_de_reservation_Texte TEXT,
    Date_de_mise_a_jour TIMESTAMP,
    Image_de_couverture TEXT,
    Programmes TEXT,
    En_ligne_adress_url TEXT,
    En_ligne_adress_url_text TEXT,
    En_ligne_adress_text TEXT,
    title_event TEXT,
    Audience TEXT,
    Childrens TEXT,
    Group_ TEXT
);


-- PS : Si le chemin vers le fichier ne marche pas, il faut mettre le chemin absolue vers le fichier
COPY temp_data FROM '/data/que-faire-a-paris-.csv' DELIMITER ';' CSV HEADER;


-------------------------------------------------------------------INSERTIONS------------------------------------------------------------------------------------

-- Insérer les données dans la table Evenements
INSERT INTO Evenements (ID, Titre, URL, Chapeau, Description, Date_de_debut, Date_de_fin, Type_de_prix, Detail_du_prix, Type_d_acces, Date_de_mise_a_jour, Programmes, En_ligne_adress_url, En_ligne_adress_text, Audience, Childrens, Group_)
SELECT ID, Titre, URL, Chapeau, Description, Date_de_debut, Date_de_fin, Type_de_prix, Detail_du_prix, Type_d_acces, Date_de_mise_a_jour, Programmes, En_ligne_adress_url, En_ligne_adress_text, Audience, Childrens, Group_
FROM temp_data
WHERE Nom_du_lieu IS NOT NULL OR Url_de_contact IS NOT NULL  OR URL_de_reservation IS NOT NULL OR url_de_limage IS NOT NULL; 

-- Insérer les données dans la table Localisations
INSERT INTO Localisations (Nom_du_lieu, Adresse_du_lieu, Code_postal, Ville, Latitude, Longitude, Acces_PMR, Acces_mal_voyant, Acces_mal_entendant, ID_Evenement)
SELECT DISTINCT ON (Nom_du_lieu)
    Nom_du_lieu, Adresse_du_lieu, Code_postal, Ville, 
    CAST(SPLIT_PART(Coordonnees_geographiques, ',', 1) AS FLOAT) AS Latitude, -- Extraction de Latitude
    CAST(SPLIT_PART(Coordonnees_geographiques, ',', 2) AS FLOAT) AS Longitude, -- Extraction de Longitude
    Acces_PMR, Acces_mal_voyant, Acces_mal_entendant, ID
FROM
    temp_data
WHERE Nom_du_lieu IS NOT NULL;

-- Insérer les données dans la table Contacts
INSERT INTO Contacts (Url_de_contact, Telephone_de_contact, Email_de_contact, URL_Facebook_associee, URL_Twitter_associee, ID_Evenement)
SELECT DISTINCT ON (Url_de_contact)
    Url_de_contact, Telephone_de_contact, Email_de_contact, URL_Facebook_associee, URL_Twitter_associee, ID
FROM 
    temp_data
WHERE Url_de_contact IS NOT NULL;

-- Insérer les données dans la table Reservations
INSERT INTO Reservations (URL_de_reservation, URL_de_reservation_Texte, ID_Evenement)
SELECT DISTINCT ON (URL_de_reservation)
    URL_de_reservation, URL_de_reservation_Texte, ID
FROM 
    temp_data
WHERE URL_de_reservation IS NOT NULL;

-- Insérer les données dans la table Image
INSERT INTO Image (url_de_limage, texte_alternatif_de_image, credit_de_image, ID_Evenement)
SELECT DISTINCT ON (url_de_limage)
    url_de_limage, texte_alternatif_de_image, credit_de_image, ID
FROM 
    temp_data
WHERE url_de_limage IS NOT NULL;

-- Insérer les données dans la table Mots_cle
INSERT INTO Mots_cle (mot_cle, ID_Evenement)
SELECT DISTINCT ON (Mots_cles)
    Mots_cles, ID
FROM 
    temp_data
WHERE  Mots_cles IS NOT NULL;


-- Insérer les données dans la table Transport
INSERT INTO Transport (Lien, Metro, Bus, Velib, ID_Evenement, Nom_du_lieu)
SELECT DISTINCT ON (Lien)
    TRIM(BOTH '"' FROM REGEXP_REPLACE(SPLIT_PART(SPLIT_PART(Transport, 'GéoVélo', 1), 'href="', 2), '">.*', '')) AS Lien,
    CASE WHEN POSITION('Métro' IN Transport) > 0 THEN TRIM(SPLIT_PART(SPLIT_PART(Transport, '->', 2), '<', 1)) ELSE NULL END AS Metro,
    CASE WHEN POSITION('Bus' IN Transport) > 0 THEN TRIM(SPLIT_PART(SPLIT_PART(Transport, '->', 3), '<', 1)) ELSE NULL END AS Bus,
    CASE WHEN POSITION('Vélib' IN Transport) > 0 THEN TRIM(SPLIT_PART(SPLIT_PART(Transport, '->', 4), '<', 1)) ELSE NULL END AS Velib,
    ID,
    Nom_du_lieu
FROM
    temp_data
WHERE Transport IS NOT NULL;

-- Insérer les données dans la table Occurrence
INSERT INTO Occurrence (Heure_debut, Heure_fin, ID_Evenement)
SELECT 
    split_part(split_part(occurrence_range, '_', 1), '+', 1)::TIMESTAMP,
    split_part(split_part(occurrence_range, '_', 2), '+', 1)::TIMESTAMP,
    ID
FROM
    temp_data,
    unnest(string_to_array(Occurrences, ';')) AS occurrence_range
WHERE
    Occurrences IS NOT NULL;
