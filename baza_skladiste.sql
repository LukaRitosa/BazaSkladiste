DROP DATABASE IF EXISTS baza_skladiste;
CREATE DATABASE baza_skladiste;
USE baza_skladiste;

	CREATE TABLE kategorije (
    id_kategorija INTEGER PRIMARY KEY,
    naziv_kategorije VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL
);

CREATE TABLE dobavljaci (
    id_dobavljac INTEGER PRIMARY KEY,
    naziv_dobavljaca VARCHAR(30) NOT NULL,
    kontakt_osoba VARCHAR(50) NOT NULL,
    telefon CHAR(15) NOT NULL,
    email VARCHAR(30) NOT NULL,
    adresa VARCHAR(30) NOT NULL,
    CONSTRAINT telefon_ck_d CHECK(LENGTH(telefon)>=10 OR LENGTH(telefon)<=14),
    CONSTRAINT email_ck_d CHECK(email LIKE'%@%')
);

CREATE TABLE proizvodi (
    id_proizvod INTEGER PRIMARY KEY,
    naziv_proizvoda VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL,
    cijena DECIMAL(8, 2) NOT NULL,
    kolicina_na_skladistu INT NOT NULL,
    id_kategorija INT NOT NULL,
    id_dobavljac INT NOT NULL,
    CONSTRAINT proizvod_cijena_ck CHECK (cijena > -1),
	CONSTRAINT kolicina_na_skladistu_ck CHECK (kolicina_na_skladistu > -1),
    CONSTRAINT kategorija_id_fk_p FOREIGN KEY (id_kategorija) REFERENCES kategorije(id_kategorija),
    CONSTRAINT dobavljac_id_fk_p FOREIGN KEY (id_dobavljac) REFERENCES dobavljaci(id_dobavljac)
);

-- SANJA
CREATE TABLE skladista (
    id_skladiste INTEGER PRIMARY KEY,
    naziv_skladista VARCHAR(20) NOT NULL,
    lokacija VARCHAR(30) NOT NULL
);

CREATE TABLE zaposlenici(
    id_zaposlenik INTEGER PRIMARY KEY,
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    id_skladiste INTEGER NOT NULL,
    CONSTRAINT skladiste_id_fk_z FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste),
    CONSTRAINT provjera_znamenki_telefona CHECK(LENGTH(telefon)>=10 OR LENGTH(telefon)<=14),
    CONSTRAINT provjera_email CHECK(email LIKE'%@%')
);

CREATE TABLE narudzbe (
    id_narudzba INTEGER PRIMARY KEY,
    datum_narudzbe DATETIME NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
    CONSTRAINT zaposlenik_id_fk_n FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id_zaposlenik)
);


-- novo 

CREATE TABLE stavke_narudzbe (
    id_stavka INTEGER PRIMARY KEY,
    id_narudzba INTEGER,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    CONSTRAINT kolicina_sn_ck CHECK (kolicina > 0),
    CONSTRAINT narudzba_id_fk_sn FOREIGN KEY (id_narudzba) REFERENCES narudzbe(id_narudzba),
    CONSTRAINT proizvod_id_fk_sn FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

CREATE TABLE ulazi_proizvoda (
    id_ulaz INTEGER PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    datum_ulaza DATETIME NOT NULL,
    id_skladiste INTEGER NOT NULL,
    CONSTRAINT kolicina_up_ck CHECK (kolicina > 0),
    CONSTRAINT proizvod_id_fk_up FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod),
    CONSTRAINT skladiste_id_fk_up FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste)
);

CREATE TABLE izlazi_proizvoda (
    id_izlaz INTEGER PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    datum_izlaza DATETIME NOT NULL,
    id_skladiste INTEGER NOT NULL,
    CONSTRAINT kolicina_ip_ck CHECK (kolicina > 0),
	CONSTRAINT proizvod_id_fk_ip FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod),
    CONSTRAINT skladiste_id_fk_ip FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste)
);

-- TONI

CREATE TABLE kupci (
    id_kupac INTEGER PRIMARY KEY,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    CONSTRAINT k_telefon_ck CHECK(LENGTH(telefon) BETWEEN 10 AND 14),
    CONSTRAINT k_email_ck CHECK(email LIKE'%@%')
);


CREATE TABLE racuni (
    id_racun INTEGER PRIMARY KEY,
    datum_racuna DATETIME NOT NULL,
    id_kupac INTEGER NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
    CONSTRAINT kupac_id_fk_r FOREIGN KEY (id_kupac) REFERENCES kupci(id_kupac),
    CONSTRAINT zaposlenik_id_fk_r FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id_zaposlenik)
);

drop TABLE stavke_racuna;

CREATE TABLE stavke_racuna (
    id_stavka_racun INTEGER PRIMARY KEY,
    id_racun INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena DECIMAL(8,2) NOT NULL,
    CONSTRAINT sr_cijena_ck CHECK (cijena > -1),
	CONSTRAINT kolicina_sr_ck CHECK (kolicina > 0),
    CONSTRAINt racun_id_fk_sr FOREIGN KEY (id_racun) REFERENCES racuni(id_racun),
    CONSTRAINT proizvod_id_fk FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);


-- RAMIC

CREATE TABLE dobavljacke_narudzbe (
    id_dobavljacka_narudzba INTEGER PRIMARY KEY,
    id_dobavljac INTEGER NOT NULL,
    datum_narudzbe DATETIME NOT NULL,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljaci(id_dobavljac)
);

CREATE TABLE stavke_dobavljacke_narudzbe (
    id_stavka_dobavljaca INTEGER PRIMARY KEY,
    id_dobavljacka_narudzba INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INT NOT NULL,
    FOREIGN KEY (id_dobavljacka_narudzba) REFERENCES dobavljacke_narudzbe(id_dobavljacka_narudzba),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

CREATE TABLE placanja (
    id_placanje INTEGER PRIMARY KEY,
    id_dobavljacka_narudzba INTEGER NOT NULL,
    iznos DECIMAL(10, 2) NOT NULL,
    datum_placanja DATETIME NOT NULL,
    nacin_placanja VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_dobavljacka_narudzba) REFERENCES dobavljacke_narudzbe(id_dobavljacka_narudzba)
);

-- MARTINA

CREATE TABLE inventar (
    id_inventar INTEGER PRIMARY KEY,
    id_skladiste INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    trenutna_kolicina INTEGER NOT NULL,
   CONSTRAINT skladiste_id_fk_i FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste),
   CONSTRAINT proizvodi_id_fk_i FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

CREATE TABLE dostave (
    id_dostava INTEGER PRIMARY KEY,
    id_racun INTEGER NOT NULL,
    datum_dostave DATETIME NOT NULL,
    adresa_dostave VARCHAR(40) NOT NULL,
    status_dostave VARCHAR(20) NOT NULL,
    CONSTRAINT racun_id_fk_d FOREIGN KEY (id_racun) REFERENCES racuni(id_racun)
);

CREATE TABLE povrati_proizvoda (
    id_povrat INTEGER PRIMARY KEY,
    id_racun INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    datum_povrata DATETIME NOT NULL,
    razlog_povrata TEXT NOT NULL,
    CONSTRAINT racun_id_fk_pp FOREIGN KEY (id_racun) REFERENCES racuni(id_racun),
    CONSTRAINT proizvodi_id_fk_pp FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

INSERT INTO kategorije (id_kategorija, naziv_kategorije, opis) VALUES
(41, 'Pića', 'Bezalkoholna i alkoholna pića'),
(42, 'Hrana', 'Osnovni prehrambeni proizvodi'),
(43, 'Higijena', 'Proizvodi za ličnu higijenu'),
(44, 'Tehnika', 'Elektronski uređaji i dodaci'),
(45, 'Igračke', 'Razne igračke za decu'),
(46, 'Odjeća', 'Odjevni predmeti'),
(47, 'Obuća', 'Razne vrste obuće'),
(48, 'Namještaj', 'Nameštaj za kuću i kancelariju'),
(49, 'Kućne potrepštine', 'Proizvodi za svakodnevnu upotrebu'),
(50, 'Alati', 'Razni alati i oprema'),
(51, 'Knjige', 'Razne knjige i časopisi'),
(52, 'Sportska oprema', 'Oprema za sport i rekreaciju'),
(53, 'Zdravlje', 'Dodaci ishrani i medicinski proizvodi'),
(54, 'Kancelarijski materijal', 'Pribor za kancelarije i škole'),
(55, 'Kućanski aparati', 'Mali i veliki kućanski aparati'),
(56, 'Auto oprema', 'Dodatna oprema za vozila'),
(57, 'Vrtni alati', 'Oprema za održavanje vrta'),
(58, 'Dekoracije', 'Ukrasni predmeti za dom'),
(59, 'Računala', 'Komponente i uređaji za računare'),
(60, 'Ostalo', 'Razne kategorije koje ne spadaju u ostale');

INSERT INTO dobavljaci (id_dobavljac, naziv_dobavljaca, kontakt_osoba, telefon, email, adresa) VALUES
(80, 'Dobavljač 1', 'Ivan Horvat', '+385912345678', 'ivan.horvat@dobavljaci.com', 'Ulica 1, Zagreb'),
(81, 'Dobavljač 2', 'Ana Marić', '+385923456789', 'ana.maric@dobavljaci.com', 'Ulica 2, Split'),
(82, 'Dobavljač 3', 'Marko Perić', '+385934567890', 'marko.peric@dobavljaci.com', 'Ulica 3, Rijeka'),
(83, 'Dobavljač 4', 'Petra Novak', '+385945678901', 'petra.novak@dobavljaci.com', 'Ulica 4, Osijek'),
(84, 'Dobavljač 5', 'Lucija Šimić', '+385956789012', 'lucija.simic@dobavljaci.com', 'Ulica 5, Varaždin'),
(85, 'Dobavljač 6', 'Davor Lukić', '+385967890123', 'davor.lukic@dobavljaci.com', 'Ulica 6, Zadar'),
(86, 'Dobavljač 7', 'Mia Kovač', '+385978901234', 'mia.kovac@dobavljaci.com', 'Ulica 7, Pula'),
(87, 'Dobavljač 8', 'Josip Jurić', '+385989012345', 'josip.juric@dobavljaci.com', 'Ulica 8, Dubrovnik'),
(88, 'Dobavljač 9', 'Marija Vuk', '+385990123456', 'marija.vuk@dobavljaci.com', 'Ulica 9, Šibenik'),
(89, 'Dobavljač 10', 'Hrvoje Blažić', '+385991234567', 'hrvoje.blazic@dobavljaci.com', 'Ulica 10, Vinkovci'),
(90, 'Dobavljač 11', 'Sandra Ilić', '+385992345678', 'sandra.ilic@dobavljaci.com', 'Ulica 11, Slavonski Brod'),
(91, 'Dobavljač 12', 'Filip Radić', '+385993456789', 'filip.radic@dobavljaci.com', 'Ulica 12, Bjelovar'),
(92, 'Dobavljač 13', 'Tomislav Božić', '+385994567890', 'tomislav.bozic@dobavljaci.com', 'Ulica 13, Karlovac'),
(93, 'Dobavljač 14', 'Vanja Petrović', '+385995678901', 'vanja.petrovic@dobavljaci.com', 'Ulica 14, Čakovec'),
(94, 'Dobavljač 15', 'Nina Grgić', '+385996789012', 'nina.grgic@dobavljaci.com', 'Ulica 15, Sisak'),
(95, 'Dobavljač 16', 'Dario Babić', '+385997890123', 'dario.babic@dobavljaci.com', 'Ulica 16, Virovitica'),
(96, 'Dobavljač 17', 'Laura Đurić', '+385998901234', 'laura.djuric@dobavljaci.com', 'Ulica 17, Požega'),
(97, 'Dobavljač 18', 'Karlo Pavlić', '+385999012345', 'karlo.pavlic@dobavljaci.com', 'Ulica 18, Krapina'),
(98, 'Dobavljač 19', 'Tanja Matijaš', '+385991112345', 'tanja.matijas@dobavljaci.com', 'Ulica 19, Gospić');

INSERT INTO proizvodi (id_proizvod, naziv_proizvoda, opis, cijena, kolicina_na_skladistu, id_kategorija, id_dobavljac) VALUES
(1, 'Coca-Cola', 'Gazirano piće 0.5L', 1.50, 100, 41, 80),
(2, 'Voda Jana', 'Prirodna mineralna voda 1.5L', 0.80, 200, 41, 80),
(3, 'Pivo Heineken', 'Limenka 0.33L', 1.20, 150, 41, 80),
(4, 'Čokolada Milka', 'Mlečna čokolada 100g', 2.00, 300, 42, 81),
(5, 'Kruh Bijeli', 'Sveže pečen beli hleb 500g', 1.00, 50, 42, 81),
(6, 'Toalet papir', 'Pakovanje od 10 rolni', 3.50, 400, 43, 82),
(7, 'Pasta za zube Colgate', 'Osvežavajuća pasta za zube 75ml', 2.20, 250, 43, 82),
(8, 'Laptop Lenovo', 'Laptop 15.6" sa Intel procesorom', 500.00, 20, 44, 83),
(9, 'USB kabl', 'USB-C kabl dužine 1m', 5.00, 150, 44, 83),
(10, 'Lopta za fudbal', 'Oficijalna lopta za fudbal', 25.00, 80, 52, 84),
(11, 'Igračka robot', 'Interaktivni robot na baterije', 15.00, 90, 45, 85),
(12, 'Majica', 'Pamučna majica XL', 10.00, 120, 46, 86),
(13, 'Tenisice Nike', 'Sportske tenisice broj 42', 75.00, 60, 47, 87),
(14, 'Stolica za kancelariju', 'Ergonomska stolica sa naslonima', 100.00, 15, 48, 88),
(15, 'Tava za kuhanje', 'Neprianjajuća tava prečnika 24cm', 20.00, 110, 49, 89),
(16, 'Čekić', 'Metalni čekić sa drvenom drškom', 8.00, 130, 50, 90),
(17, 'Roman', 'Popularni roman u mekom povezu', 12.00, 70, 51, 91),
(18, 'Protein Whey', 'Pakovanje od 1kg čokolade', 40.00, 40, 53, 92),
(19, 'Printer Canon', 'Višenamenski inkjet printer', 120.00, 10, 54, 93),
(20, 'Mikrovalna pećnica', 'Mikrovalna sa gril funkcijom', 150.00, 5, 55, 94),
(21, 'Auto sjedište', 'Auto sedište za decu', 200.00, 8, 56, 95),
(22, 'Trimer za travu', 'Električni trimer za travu', 50.00, 20, 57, 96),
(23, 'Ukrasna vaza', 'Keramička vaza sa šarom', 30.00, 25, 58, 97),
(24, 'Monitor Samsung', '24" Full HD monitor', 180.00, 12, 59, 98),
(25, 'Krema za ruke', 'Hidratantna krema za ruke 50ml', 5.00, 180, 43, 82),
(26, 'Klupa za vrt', 'Drvena klupa sa metalnim ramom', 80.00, 25, 57, 96),
(27, 'Stol za trpezariju', 'Drveni stol za šest osoba', 200.00, 7, 48, 88),
(28, 'Ruksak za školu', 'Prostrani ruksak sa pregradama', 30.00, 100, 54, 93),
(29, 'Pametni sat', 'Pametni sat sa brojačem koraka', 100.00, 50, 44, 83),
(30, 'Četka za kosu', 'Antistatička četka za kosu', 8.00, 140, 43, 82);


-- SANJA podaci za unos
INSERT INTO skladista VALUES 
(123, 'Centralno', 'Zagreb'),
(124, 'Primorsko', 'Rijeka'),
(125, 'Sjeverno', 'Varaždin'),
(126, 'Južno', 'Zagreb'),
(127, 'Luka', 'Pula'),
(128, 'Marica', 'Varaždin'),
(129, 'Monte', 'Pula'),
(130, 'Karlovačko', 'Karlovac'),
(131, 'Mrežnica', 'Karlovac'),
(132, 'Parenzo', 'Poreč'); 

INSERT INTO zaposlenici VALUES 
(161, 'Sara', 'Sarić', 's.saric@gmail.com', '09934451009', 123), 
(162, 'Ivan', 'Ivić', 'ivan.ivic@gmail.com', '0911234567', 130), 
(163, 'Ana', 'Anić', 'ana.anic@gmail.com', '0959876543', 125),
(164, 'Marko', 'Marić', 'm.maric@gmail.com', '0914349899', 132), 
(165, 'Mario', 'Stojković', 'mstojkovic@gmail.com', '0911234567', 125), 
(166, 'Petar', 'Perić', 'p.peric44@gmail.com', '0950706556', 125),
(167, 'Ana', 'Poslović', 'ana0poslovic@gmail.com', '0939893200', 123), 
(168, 'Ivan', 'Stojković', 'ivan65stojkovic@gmail.com', '0973632332', 126), 
(169, 'Dalibor', 'Ivić', 'd.ivic44@gmail.com', '0918669500', 127),
(170, 'Sara', 'Sarić', 's.saric@gmail.com', '09934451009', 127), 
(171, 'Ivan', 'Ivić', 'ivan.ivic@gmail.com', '0911234567', 124), 
(172, 'Marko', 'Ognjac', 'm96ognjac@gmail.com', '0924146996', 131),
(173, 'Sara', 'Prijedovac', 'sara_p@gmail.com', '0945758877', 127); 

INSERT INTO narudzbe VALUES 
(205,  STR_TO_DATE('09.01.2025.', '%d.%m.%Y.'), 166),
(206, STR_TO_DATE('05.01.2025.', '%d.%m.%Y.'), 161),
(207, STR_TO_DATE('21.12.2024.', '%d.%m.%Y.'), 165),
(208,  STR_TO_DATE('09.01.2025.', '%d.%m.%Y.'), 165),
(209, STR_TO_DATE('05.01.2025.', '%d.%m.%Y.'), 166),
(210, STR_TO_DATE('09.12.2024.', '%d.%m.%Y.'), 163),
(211, STR_TO_DATE('17.12.2024.', '%d.%m.%Y.'), 164); 

    
INSERT INTO stavke_narudzbe (id_stavka, id_narudzba, id_proizvod, kolicina) VALUES
(241, 205, 7, 3),
(242, 206, 15, 2),
(243, 207, 23, 5),
(244, 208, 5, 1),
(245, 209, 19, 4),
(246, 210, 30, 6),
(247, 211, 2, 3),
(248, 205, 14, 2),
(249, 206, 9, 4),
(250, 207, 21, 3),
(251, 208, 12, 1),
(252, 209, 8, 2),
(253, 210, 27, 5),
(254, 211, 3, 1),
(255, 205, 16, 3),
(256, 206, 10, 2),
(257, 207, 18, 6),
(258, 208, 4, 3),
(259, 209, 22, 1),
(260, 210, 13, 2),
(261, 211, 11, 4),
(262, 205, 20, 5),
(263, 206, 6, 3),
(264, 207, 28, 2),
(265, 208, 1, 1),
(266, 209, 17, 4),
(267, 210, 24, 3),
(268, 211, 25, 6),
(269, 205, 29, 2),
(270, 206, 26, 1);



INSERT INTO ulazi_proizvoda (id_ulaz, id_proizvod, kolicina, datum_ulaza, id_skladiste) VALUES
(281, 5, 20, '2025-01-01 10:00:00', 123),
(282, 12, 15, '2025-01-02 11:30:00', 124),
(283, 7, 30, '2025-01-03 09:45:00', 125),
(284, 18, 40, '2025-01-04 08:20:00', 126),
(285, 21, 25, '2025-01-05 14:10:00', 127),
(286, 9, 50, '2025-01-06 12:00:00', 128),
(287, 3, 35, '2025-01-07 13:15:00', 129),
(288, 15, 10, '2025-01-08 07:50:00', 130),
(289, 26, 45, '2025-01-09 16:30:00', 131),
(290, 8, 60, '2025-01-10 10:05:00', 132),
(291, 5, 20, '2025-01-11 11:20:00', 123),
(292, 12, 25, '2025-01-12 08:55:00', 124),
(293, 7, 15, '2025-01-13 09:40:00', 125),
(294, 18, 50, '2025-01-14 12:30:00', 126),
(295, 21, 35, '2025-01-15 13:45:00', 127),
(296, 9, 10, '2025-01-16 07:15:00', 128),
(297, 3, 40, '2025-01-17 10:00:00', 129),
(298, 15, 30, '2025-01-18 11:25:00', 130),
(299, 26, 20, '2025-01-19 14:40:00', 131),
(300, 8, 25, '2025-01-20 09:10:00', 132),
(301, 10, 45, '2025-01-21 10:50:00', 123),
(302, 20, 50, '2025-01-22 12:15:00', 124),
(303, 4, 30, '2025-01-23 13:35:00', 125),
(304, 25, 40, '2025-01-24 08:30:00', 126),
(305, 17, 15, '2025-01-25 09:55:00', 127),
(306, 14, 60, '2025-01-26 10:40:00', 128),
(307, 19, 20, '2025-01-27 12:50:00', 129),
(308, 28, 35, '2025-01-28 11:00:00', 130),
(309, 22, 25, '2025-01-29 14:20:00', 131),
(310, 6, 45, '2025-01-30 09:30:00', 132);


INSERT INTO izlazi_proizvoda (id_izlaz, id_proizvod, kolicina, datum_izlaza, id_skladiste) VALUES
(321, 2, 15, '2025-02-01 10:00:00', 123),
(322, 8, 10, '2025-02-02 11:30:00', 124),
(323, 14, 25, '2025-02-03 09:45:00', 125),
(324, 19, 20, '2025-02-04 08:20:00', 126),
(325, 22, 30, '2025-02-05 14:10:00', 127),
(326, 5, 12, '2025-02-06 12:00:00', 128),
(327, 9, 18, '2025-02-07 13:15:00', 129),
(328, 3, 20, '2025-02-08 07:50:00', 130),
(329, 21, 10, '2025-02-09 16:30:00', 131),
(330, 15, 25, '2025-02-10 10:05:00', 132),
(331, 7, 15, '2025-02-11 11:20:00', 123),
(332, 12, 8, '2025-02-12 08:55:00', 124),
(333, 6, 30, '2025-02-13 09:40:00', 125),
(334, 10, 12, '2025-02-14 12:30:00', 126),
(335, 25, 20, '2025-02-15 13:45:00', 127),
(336, 4, 16, '2025-02-16 07:15:00', 128),
(337, 30, 18, '2025-02-17 10:00:00', 129),
(338, 28, 22, '2025-02-18 11:25:00', 130),
(339, 18, 15, '2025-02-19 14:40:00', 131),
(340, 26, 10, '2025-02-20 09:10:00', 132),
(341, 16, 5, '2025-02-21 10:50:00', 123),
(342, 11, 14, '2025-02-22 12:15:00', 124),
(343, 23, 20, '2025-02-23 13:35:00', 125),
(344, 1, 18, '2025-02-24 08:30:00', 126),
(345, 20, 22, '2025-02-25 09:55:00', 127),
(346, 17, 12, '2025-02-26 10:40:00', 128),
(347, 13, 16, '2025-02-27 12:50:00', 129),
(348, 27, 9, '2025-02-28 11:00:00', 130),
(349, 24, 18, '2025-03-01 14:20:00', 131),
(350, 29, 20, '2025-03-02 09:30:00', 132);



INSERT INTO dobavljacke_narudzbe (id_dobavljacka_narudzba, id_dobavljac, datum_narudzbe) VALUES
(481, 81, '2024-01-01 10:00:00'),
(482, 82, '2024-01-02 11:00:00'),
(483, 83, '2024-01-03 12:00:00'),
(484, 81, '2024-01-04 13:00:00'),
(485, 82, '2024-01-05 14:00:00'),
(486, 83, '2024-01-06 15:00:00'),
(487, 81, '2024-01-07 16:00:00'),
(488, 82, '2024-01-08 17:00:00'),
(489, 83, '2024-01-09 18:00:00'),
(490, 81, '2024-01-10 19:00:00'),
(491, 82, '2024-01-11 10:00:00'),
(492, 83, '2024-01-12 11:00:00'),
(493, 81, '2024-01-13 12:00:00'),
(494, 82, '2024-01-14 13:00:00'),
(495, 83, '2024-01-15 14:00:00'),
(496, 81, '2024-01-16 15:00:00'),
(497, 82, '2024-01-17 16:00:00'),
(498, 83, '2024-01-18 17:00:00'),
(499, 81, '2024-01-19 18:00:00'),
(500, 82, '2024-01-20 19:00:00'),
(501, 83, '2024-01-21 10:00:00'),
(502, 81, '2024-01-22 11:00:00'),
(503, 86, '2024-01-23 12:00:00'),
(504, 83, '2024-01-24 13:00:00'),
(505, 81, '2024-01-25 14:00:00'),
(506, 82, '2024-01-26 15:00:00'),
(507, 85, '2024-01-27 16:00:00'),
(508, 81, '2024-01-28 17:00:00'),
(509, 89, '2024-01-29 18:00:00'),
(510, 88, '2024-01-30 19:00:00');

INSERT INTO stavke_dobavljacke_narudzbe (id_stavka_dobavljaca, id_dobavljacka_narudzba, id_proizvod, kolicina) VALUES
(521, 481, 1, 10),
(522, 482, 2, 20),
(523, 483, 3, 30),
(524, 484, 4, 40),
(525,485, 5, 50),
(526, 486, 6, 60),
(527, 487, 7, 70),
(528, 488, 8, 80),
(529, 489, 9, 90),
(530, 490, 10, 100),
(531, 491, 11, 110),
(532, 492, 12, 120),
(533, 493, 13, 130),
(534, 494, 14, 140),
(535, 495, 15, 150),
(536, 496, 16, 160),
(537, 497, 17, 170),
(538, 498, 18, 180),
(539, 499, 19, 190),
(540, 500, 20, 200),
(541, 501, 21, 210),
(542, 502, 22, 220),
(543, 503, 23, 230),
(544, 504, 24, 240),
(545, 505, 25, 250),
(546, 506, 26, 260),
(547, 507, 27, 270),
(548, 508, 28, 280),
(549, 509, 29, 290),
(550, 510, 30, 300);

INSERT INTO placanja (id_placanje, id_dobavljacka_narudzba, iznos, datum_placanja, nacin_placanja) VALUES
(561, 481, 10.00, '2024-02-01 14:00:00', 'Kartica'),
(562, 482, 20.00, '2024-02-02 14:30:00', 'Gotovina'),
(563, 483, 30.00, '2024-02-03 15:00:00', 'Online'),
(564, 484, 40.00, '2024-02-04 15:30:00', 'Kartica'),
(565, 485, 50.00, '2024-02-05 16:00:00', 'Gotovina'),
(566, 486, 60.00, '2024-02-06 16:30:00', 'Online'),
(567, 487, 70.00, '2024-02-07 17:00:00', 'Kartica'),
(568, 488, 80.00, '2024-02-08 17:30:00', 'Gotovina'),
(569, 489, 90.00, '2024-02-09 18:00:00', 'Online'),
(570, 490, 100.00, '2024-02-10 18:30:00', 'Kartica'),
(571, 491, 110.00, '2024-02-11 19:00:00', 'Gotovina'),
(572, 492, 120.00, '2024-02-12 19:30:00', 'Online'),
(573, 493, 130.00, '2024-02-13 20:00:00', 'Kartica'),
(574, 494, 140.00, '2024-02-14 20:30:00', 'Gotovina'),
(575, 495, 150.00, '2024-02-15 21:00:00', 'Online'),
(576, 496, 160.00, '2024-02-16 21:30:00', 'Kartica'),
(577, 497, 170.00, '2024-02-17 22:00:00', 'Gotovina'),
(578, 498, 180.00, '2024-02-18 22:30:00', 'Online'),
(579, 499, 190.00, '2024-02-19 23:00:00', 'Kartica'),
(580, 500, 200.00, '2024-02-20 23:30:00', 'Gotovina'),
(581, 501, 210.00, '2024-02-21 10:00:00', 'Online'),
(582, 502, 220.00, '2024-02-22 10:30:00', 'Kartica'),
(583, 503, 230.00, '2024-02-23 11:00:00', 'Gotovina'),
(584, 504, 240.00, '2024-02-24 11:30:00', 'Online'),
(585, 505, 250.00, '2024-02-25 12:00:00', 'Kartica'),
(586, 506, 260.00, '2024-02-26 12:30:00', 'Gotovina'),
(587, 507, 270.00, '2024-02-27 13:00:00', 'Online'),
(588, 508, 280.00, '2024-02-28 13:30:00', 'Kartica'),
(589, 509, 290.00, '2024-03-01 14:00:00', 'Gotovina'),
(590, 510, 300.00, '2024-03-02 14:30:00', 'Online');


INSERT INTO kupci (id_kupac, ime, prezime, email, telefon, adresa) VALUES
(361, 'Ivan', 'Horvat', 'ivan.horvat1@example.com', '0912345678', 'Zagrebačka 1, Zagreb'),
(362, 'Ana', 'Kovač', 'ana.kovac2@example.com', '0912345679', 'Split 5, Split'),
(363, 'Marko', 'Ivić', 'marko.ivic3@example.com', '0912345680', 'Dubrovnička 8, Dubrovnik'),
(364, 'Lucija', 'Babić', 'lucija.babic4@example.com', '0912345681', 'Osječka 3, Osijek'),
(365, 'Petar', 'Jurić', 'petar.juric5@example.com', '0912345682', 'Zadarska 4, Zadar'),
(366, 'Maja', 'Savić', 'maja.savic6@example.com', '0912345683', 'Trogirska 2, Trogir'),
(367, 'Josip', 'Matić', 'josip.matic7@example.com', '0912345684', 'Vukovarska 7, Vukovar'),
(368, 'Klara', 'Novak', 'klara.novak8@example.com', '0912345685', 'Slavonska 6, Slavonski Brod'),
(369, 'Luka', 'Perković', 'luka.perkovic9@example.com', '0912345686', 'Karlovačka 10, Karlovac'),
(370, 'Sara', 'Grgić', 'sara.grgic10@example.com', '0912345687', 'Dubrovnička 12, Dubrovnik'),
(371, 'Tomislav', 'Radić', 'tomislav.radic11@example.com', '0912345688', 'Riječna 11, Rijeka'),
(372, 'Eva', 'Pavić', 'eva.pavic12@example.com', '0912345689', 'Primorska 15, Pula'),
(373, 'Nikola', 'Kolar', 'nikola.kolar13@example.com', '0912345690', 'Sisačka 16, Sisak'),
(374, 'Lana', 'Vuković', 'lana.vukovic14@example.com', '0912345691', 'Bjelovarska 17, Bjelovar'),
(375, 'Ivana', 'Zorić', 'ivana.zoric15@example.com', '0912345692', 'Varaždinska 18, Varaždin'),
(376, 'Fran', 'Šimunović', 'fran.simunovic16@example.com', '0912345693', 'Zagrebačka 19, Zagreb'),
(377, 'Andrea', 'Knežević', 'andrea.knezevic17@example.com', '0912345694', 'Osječka 20, Osijek'),
(378, 'David', 'Tomić', 'david.tomic18@example.com', '0912345695', 'Šibenik 21, Šibenik'),
(379, 'Ivana', 'Soldo', 'ivana.soldo19@example.com', '0912345696', 'Rijeka 22, Rijeka'),
(380, 'Gabrijela', 'Lukić', 'gabrijela.lukic20@example.com', '0912345697', 'Split 23, Split'),
(381, 'Dino', 'Pavić', 'dino.pavic21@example.com', '0912345698', 'Trogir 24, Trogir'),
(382, 'Maja', 'Hrvatska', 'maja.hrvat21@example.com', '0912345699', 'Zadar 25, Zadar'),
(383, 'Ivica', 'Barišić', 'ivica.barisic22@example.com', '0912345700', 'Pula 26, Pula'),
(384, 'Monika', 'Gajić', 'monika.gajic23@example.com', '0912345701', 'Riječna 27, Rijeka'),
(385, 'Marko', 'Vranjić', 'marko.vranjic24@example.com', '0912345702', 'Slavonska 28, Slavonski Brod'),
(386, 'Tea', 'Marin', 'tea.marin25@example.com', '0912345703', 'Zagreb 29, Zagreb'),
(387, 'Nikola', 'Lukić', 'nikola.lukic26@example.com', '0912345704', 'Osijek 30, Osijek'),
(388, 'Katarina', 'Čović', 'katarina.covic27@example.com', '0912345705', 'Trogir 31, Trogir'),
(389, 'Petra', 'Vlahović', 'petra.vlahovic28@example.com', '0912345706', 'Karlovac 32, Karlovac'),
(390, 'Marija', 'Gavran', 'marija.gavran29@example.com', '0912345707', 'Split 33, Split');



INSERT INTO racuni (id_racun, datum_racuna, id_kupac, id_zaposlenik) VALUES
(401, '2024-06-02 09:15:20', 367, 163),
(402, '2024-03-19 11:35:30', 365, 161),
(403, '2024-07-25 16:47:50', 364, 163),
(404, '2024-01-30 12:59:00', 368, 162),
(405, '2024-02-10 13:25:00', 369, 161),
(406, '2024-08-15 17:14:40', 371, 163),
(407, '2024-04-10 08:22:15', 372, 162),
(408, '2024-03-29 15:39:00', 373, 161),
(409, '2024-11-01 09:10:30', 374, 163),
(410, '2024-05-05 10:05:10', 375, 162),
(411, '2024-06-13 18:55:45', 376, 161),
(412, '2024-10-20 11:21:35', 377, 163),
(413, '2024-07-03 14:04:30', 378, 161),
(414, '2024-09-11 12:15:10', 379, 163),
(415, '2024-03-02 16:30:00', 380, 162),
(416, '2024-06-17 08:50:20', 381, 161),
(417, '2024-05-27 13:23:40', 382, 163),
(418, '2024-01-11 09:50:50', 383, 162),
(419, '2024-02-21 15:11:25', 384, 163),
(420, '2024-08-29 10:42:30', 385, 161),
(421, '2024-04-18 14:00:00', 386, 162),
(422, '2024-03-25 09:30:10', 387, 161),
(423, '2024-10-09 16:22:50', 388, 163),
(424, '2024-07-05 12:34:45', 389, 161),
(425, '2024-11-17 08:58:10', 390, 162),
(426, '2024-05-09 10:25:30', 368, 163),
(427, '2024-09-14 15:14:00', 369, 162),
(428, '2024-06-30 12:00:00', 371, 161),
(429, '2024-02-18 10:20:45', 373, 163),
(430, '2024-04-06 14:40:00', 374, 162);


INSERT INTO stavke_racuna (id_stavka_racun, id_racun, id_proizvod, kolicina, cijena) VALUES
(441, 401, 12, 3, 120.50),
(442, 401, 5, 2, 40.75),
(443, 401, 3, 1, 65.20),
(444, 402, 10, 1, 22.99),
(445, 402, 14, 2, 34.50),
(446, 403, 18, 1, 80.99),
(447, 404, 8, 5, 99.00),
(448, 405, 21, 3, 62.80),
(449, 406, 9, 4, 55.60),
(450, 407, 6, 3, 58.90),
(451, 408, 4, 2, 130.45),
(452, 409, 22, 3, 88.30),
(453, 409, 27, 4, 120.00),
(454, 410, 20, 1, 45.75),
(455, 410, 15, 2, 33.40),
(456, 411, 1, 5, 22.60),
(457, 411, 25, 2, 70.99),
(458, 412, 24, 4, 49.95),
(459, 413, 16, 3, 12.80),
(460, 413, 30, 2, 55.50),
(461, 414, 28, 1, 200.00),
(462, 415, 29, 2, 99.50),
(463, 416, 5, 3, 60.10),
(464, 416, 7, 2, 84.99),
(465, 417, 8, 1, 75.60),
(466, 418, 22, 2, 90.00),
(467, 418, 9, 3, 39.40),
(468, 419, 6, 1, 58.00),
(469, 420, 3, 2, 100.00),
(470, 421, 18, 1, 55.75),
(471, 422, 17, 4, 110.00),
(472, 423, 2, 1, 45.50),
(473, 423, 14, 3, 80.00),
(474, 424, 23, 1, 37.40),
(475, 425, 19, 2, 65.20),
(476, 426, 12, 1, 50.50),
(477, 427, 7, 2, 48.00),
(478, 428, 5, 3, 56.40),
(479, 429, 10, 1, 77.00),
(480, 430, 13, 4, 120.00);


INSERT INTO inventar(id_inventar, id_skladiste, id_proizvod, trenutna_kolicina) VALUES
(601, 123, 1, 100),
(602, 128, 5, 50),
(603, 124, 20, 55),
(604, 124, 10, 80),
(605, 132, 30, 140),
(606, 127, 3, 150),
(607, 128, 2, 200),
(608, 126, 12, 120),
(609, 125, 8, 20),
(610, 130, 15, 110),
(611, 130, 22, 20),
(612, 129, 29, 50),
(613, 123, 7, 250),
(614, 124, 6, 400),
(615, 125, 13, 60),
(616, 127, 11, 90),
(617, 126, 26, 25),
(687, 130, 27, 7),
(619, 128, 4, 300),
(620, 129, 15, 110),
(621, 129, 24, 12),
(622, 131, 23, 25),
(623, 132, 17, 70),
(624, 125, 18, 40),
(625, 123, 12, 120),
(626, 123, 21, 8),
(627, 126, 22, 20),
(628, 123, 25, 180),
(629, 130, 9, 150),
(630, 130, 28, 100),
(631, 129, 2, 200);

INSERT INTO dostave(id_dostava, id_racun, datum_dostave, adresa_dostave, status_dostave) VALUES
(640, 401, '2025-02-10', 'Vukovarska 7, Vukovar', 'Dostavljeno'),
(641, 402, '2025-02-11', 'Zadarska 4, Zadar', 'Dostavljeno'),
(642, 403, '2025-02-12', 'Osječka 3, Osijek', 'Dostavljeno'),
(643, 404, '2025-02-13', 'Slavonska 6, Slavonski Brod', 'Dostavljeno'),
(644, 405, '2025-02-14', 'Karlovačka 10, Karlovac', 'Dostavljeno'),
(645, 406, '2025-02-15', 'Riječna 11, Rijeka ', 'Dostavljeno'),
(646, 407, '2025-02-16', 'Primorska 15, Pula', 'Dostavljeno'),
(647, 408, '2025-02-17', 'Sisačka 16, Sisak', 'Dostavljeno'),
(648, 409, '2025-02-18', 'Bjelovarska 17, Bjelovar', 'Dostavljeno'),
(649, 410, '2025-02-19', 'Varaždinska 18, Varaždin', 'Dostavljeno'),
(650, 411, '2025-02-20', 'Zagrebačka 19, Zagreb', 'Dostavljeno'),
(651, 412, '2025-02-21', 'Osječka 20, Osijek', 'Isporučeno'),
(652, 413, '2025-02-22', 'Šibenik 21, Šibenik', 'Dostavljeno'),
(653, 414, '2025-02-23', 'Rijeka 22, Rijeka', 'Dostavljeno'),
(654, 415, '2025-02-23', 'Split 23, Split', 'Dostavljeno'),
(655, 416, '2025-02-24', 'Trogir 24, Trogir', 'Isporučeno'),
(656, 417, '2025-02-25', 'Zadar 25, Zadar', 'Isporučeno'),
(657, 418, '2025-02-26', 'Pula 26, Pula', 'Dostavljeno'),
(658, 419, '2024-02-27', 'Riječna 27, Rijeka', 'Isporučeno'),
(659, 420, '2025-02-28', 'Slavonska 28, Slavonski Brod', 'Isporučeno'),
(660, 421, '2025-03-01', 'Zagreb 29, Zagreb', 'Zaprimljeno'),
(661, 422, '2025-03-02', 'Osijek 30, Osijek', 'Isporučeno'),
(662, 423, '2025-03-03', 'Trogir 31, Trogir', 'Isporučeno'),
(663, 424, '2025-03-04', 'Karlovac 32, Karlovac', 'Zaprimljeno'),
(664, 425, '2025-03-05', 'Split 33, Split', 'Zaprimljeno'),
(665, 426, '2025-03-05', 'Slavonska 6, Slavonski Brod', 'Zaprimljeno'),
(666, 427, '2025-03-06', 'Karlovačka 10, Karlovac', 'Zaprimljeno'),
(667, 428, '2025-03-07', 'Riječna 11, Rijeka', 'Zaprimljeno'),
(668, 429, '2025-03-08', 'Sisačka 16, Sisak', 'Zaprimljeno'),
(669, 430, '2025-03-09', 'Bjelovarska 17, Bjelovar', 'Zaprimljeno');

INSERT INTO povrati_proizvoda(id_povrat, id_racun, id_proizvod, kolicina, datum_povrata, razlog_povrata) VALUES
(681, 401, 1, 4, '2025-02-11','Pogrešna kolićina'),
(682, 402, 2, 10, '2025-02-12', 'Pogrešna kolićina'),
(683, 403, 4, 2, '2025-02-13', 'Loša kvaliteta'),
(634, 404, 7, 1, '2025-02-14', 'Promijena mišljenja'),
(685, 405, 5, 2, '2025-02-15','Nije ispunio očekivanja'),
(686, 406, 10, 3,'2025-02-16' 'Nije ispunio očekivanjima'),
(687, 407, 6, 2, '2025-02-17','Promijena mišljenja'),
(688, 408, 8, 1, '2025-02-18','Problemi s isporukom'),
(689, 409, 9, 9, '2025-02-19','Proizvod je oštećen'),
(690, 410, 11, 5,'2025-02-21', 'Nije odgovarao opisu'),
(691, 411, 13, 1,'2025-02-22', 'Netočna veličina'),
(692, 412, 12, 12,'2025-02-23','Netočna veličina'),
(693, 413, 14, 20,'2025-02-24','Loša kvaliteta'),
(694, 414, 15, 14,'2025-02-25','Nije ispunio očekivanja'),
(695, 415, 16, 18,'2025-02-26', 'Promijena mišljenja'),
(696, 416, 19, 2,'2025-02-27','Nedostatak kompatibilnosti'),
(697, 417, 18, 8,'2025-02-28','Nije odgovarao opisu'),
(698, 418, 17, 15,'2025-03-01','Promijena mišljenja'),
(699, 419, 20, 1, '2025-03-02','Proizvod je neispravan'),
(700, 420, 22, 2, '2025-03-03', 'Loša kvaliteta'),
(701, 421, 23, 8, '2025-03-04', 'Nije ispunila očekivanja'),
(702, 422, 24, 3, '2025-03-05','Problemi s isporukom'),
(703, 423, 21, 2, '2025-03-06', 'Nije odgovarao opisu'),
(704, 424, 25, 30, '2025-03-07','Loša kvaliteta'),
(705, 425, 26, 3, '2025-03-08', 'Promijena mišljenja'),
(706, 426, 27, 1, '2025-03-09', 'Problemi s isporukom '),
(707, 427, 30, 2, '2025-03-10', 'Loša kvaliteta'),
(708, 428, 28, 5, '2025-03-10','Pogrešan model'),
(709, 429, 29, 2, '2025-03-11','Pogrešna boja'),
(710, 430, 3, 10, '2025-03-12','Poslana pogrešna kolićina');

-- |||||||||||||||BITNO||||||||||||||||
CREATE USER 'radnik'@'localhost' IDENTIFIED BY 'lozinka';
GRANT ALL PRIVILEGES ON baza_skladiste.* TO 'radnik'@'localhost';
-- |||||||||||||||BITNO||||||||||||||||


-- Luka

select naziv_dobavljaca, naziv_kategorije, count(*) broj_proizvoda
	from proizvodi
join kategorije 
	on kategorije.id_kategorija=proizvodi.id_kategorija
join dobavljaci 
	on dobavljaci.id_dobavljac=proizvodi.id_dobavljac
group by dobavljaci.naziv_dobavljaca, kategorije.id_kategorija
order by broj_proizvoda desc
limit 3;

select racuni.id_racun, sum(cijena*kolicina) ukupno
	from racuni 
join kupci k
	on k.id_kupac=racuni.id_kupac
join stavke_racuna sr
	on sr.id_racun=racuni.id_racun
join proizvodi p
	on p.id_proizvod=sr.id_proizvod
group by racuni.id_racun;

select k.naziv_kategorije , sum(kolicina) as ukupno_prodano
	from stavke_racuna sr
join proizvodi p
	on p.id_proizvod=sr.id_proizvod
join kategorije k  
	on  k.id_kategorija=p.id_kategorija
group by k.naziv_kategorije
order by ukupno_prodano desc
limit 5;



CREATE VIEW pregled_zaliha AS
SELECT s.naziv_skladista, p.naziv_proizvoda, i.trenutna_kolicina
	FROM inventar i
JOIN skladista s 
	ON i.id_skladiste = s.id_skladiste
JOIN proizvodi p 
	ON i.id_proizvod = p.id_proizvod;
 
 
DELIMITER // 
CREATE TRIGGER ai_ulazi_proizvoda
AFTER INSERT ON ulazi_proizvoda
FOR EACH ROW
BEGIN
    
    UPDATE proizvodi
		SET kolicina_na_skladistu = kolicina_na_skladistu + NEW.kolicina
    WHERE id_proizvod = NEW.id_proizvod;
    
    UPDATE inventar
    SET trenutna_kolicina = trenutna_kolicina + NEW.kolicina
    WHERE id_proizvod = NEW.id_proizvod AND id_skladiste = NEW.id_skladiste;
    
END//
DELIMITER ;

select @@autocommit;

SET AUTOCOMMIT= off;


DELIMITER // 
CREATE procedure novi_poizvod(
	IN p_id_proizvod INTEGER,
    IN p_naziv_proizvoda VARCHAR(30),
    IN p_opis TEXT,
    IN p_cijena DECIMAL(8, 2),
    IN p_kolicina_na_skladistu INT,
    IN p_id_kategorija INT,
    IN p_id_dobavljac INT
    )
BEGIN
	
    DECLARE EXIT HANDLER FOR 1062
		BEGIN
			ROLLBACK;
            SELECT CONCAT("Proizvod sa id-em ",p_id_proizvod," već postoji");
        END;
        
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
    INSERT INTO proizvodi (id_proizvod, naziv_proizvoda, opis, cijena, kolicina_na_skladistu, id_kategorija, id_dobavljac)
    VALUES(p_id_proizvod, p_naziv_proizvoda, p_opis, p_cijena, p_kolicina_na_skladistu, p_id_kategorija, p_id_dobavljac);
	COMMIT;
    
END//
DELIMITER ;

CALL novi_poizvod(31, 'Fen za kosu', 'Snažan fen za kosu', 12.00, 140, 43, 82);

select *
	from proizvodi;



DELIMITER //
CREATE PROCEDURE nazivi_kategorije(OUT p_nazivi_kategorije VARCHAR(4000))
BEGIN
	 
	 DECLARE kat VARCHAR(100) DEFAULT "";
	 DECLARE finished INTEGER DEFAULT 0;

	 DECLARE cur CURSOR FOR
		SELECT naziv_kategorije 
			FROM kategorije;

	 DECLARE CONTINUE HANDLER
	 FOR NOT FOUND SET finished = 1;

	 SET p_nazivi_kategorije = "";

	 OPEN CUR;

	 prolazi_kategorije: LOOP

	 FETCH cur INTO kat;

	 IF finished = 1 THEN
		LEAVE prolazi_kategorije;
	 END IF;
     
	 SET p_nazivi_kategorije = CONCAT(kat,";",p_nazivi_kategorije);

	 END LOOP prolazi_kategorije;

	 CLOSE cur;
	 SET p_nazivi_kategorije = CONCAT("GOTOVO",";",p_nazivi_kategorije);

END //
DELIMITER ;

CALL nazivi_kategorije(@kategorije);
SELECT @kategorije;

SELECT naziv_kategorije 
		FROM kategorije;
      
drop FUNCTION popust;      

DELIMITER //
CREATE FUNCTION popust(f_id_proizvod integer, f_postotak decimal(8,2)) RETURNS decimal(8,2)
DETERMINISTIC
BEGIN
	
    declare f_cijena decimal(8,2);
	declare spustena_cijena decimal(8,2);
    set f_postotak=f_postotak/100;
	set f_postotak=1-f_postotak;

    select cijena into f_cijena
		from proizvodi
	where id_proizvod=f_id_proizvod;
	
	set spustena_cijena=f_cijena*f_postotak;
    
	RETURN spustena_cijena;
END //
DELIMITER ;

select popust(1,25) from dual;
select *, popust(id_proizvod, 25)
	from proizvodi;
    


drop  FUNCTION koliko_ima_na_skladistu;    

DELIMITER //
CREATE FUNCTION koliko_ima_na_skladistu(f_id_skladiste integer, f_id_proizvod integer) RETURNS varchar(500)
DETERMINISTIC
BEGIN
	
    declare f_kolicina integer DEFAULT NULL;
	declare f_ime_skladista varchar(20) DEFAULT NULL;
	declare f_ime_proizvoda varchar(20) DEFAULT NULL;
    declare rez varchar(500) DEFAULT "";
    
    
    select trenutna_kolicina into f_kolicina
		from inventar
	where id_skladiste=f_id_skladiste and id_proizvod=f_id_proizvod;
    
    select naziv_proizvoda into f_ime_proizvoda
		from proizvodi
	where id_proizvod=f_id_proizvod;

	select naziv_skladista into f_ime_skladista
		from skladista
	where id_skladiste=f_id_skladiste;
    
	IF f_kolicina IS NULL OR f_ime_proizvoda IS NULL OR f_ime_skladista IS NULL THEN
        RETURN "Greška";
    END IF;
    
    set rez=concat("Na skladistu ", f_ime_skladista, " ima prozvoda ", f_ime_proizvoda," u kolicini od: ", f_kolicina);
    
	RETURN rez;
END //
DELIMITER ;

select koliko_ima_na_skladistu(123, 1) from dual;
select * 
	from inventar
where id_skladiste=123 ;

-- RAMIC:

-- UPITI:
-- 1.) Pronalazak svih dobavljačkih narudžbi s ukupnim iznosom većim od 100.00:
SELECT 
    dn.id_dobavljacka_narudzba AS IDNarudzbe,
    d.naziv_dobavljaca AS NazivDobavljaca,
    dn.datum_narudzbe AS DatumNarudzbe,
    p.iznos AS IznosPlacanja
FROM dobavljacke_narudzbe dn
JOIN dobavljaci d ON dn.id_dobavljac = d.id_dobavljac
JOIN placanja p ON dn.id_dobavljacka_narudzba = p.id_dobavljacka_narudzba
WHERE p.iznos > 100.00;

-- 2.) Ukupna naručena količina za svaki proizvod u svim dobavljačkim narudžbama:
SELECT p.naziv_proizvoda AS NazivProizvoda, COUNT SUM(sdn.kolicina) AS UkupnaNarucenaKolicina
FROM stavke_dobavljacke_narudzbe sdn
JOIN proizvodi p ON sdn.id_proizvod = p.id_proizvod
GROUP BY p.naziv_proizvoda
ORDER BY UkupnaNarucenaKolicina DESC;

-- 3.) Prikaz svih dobavljačkih narudžbi koje su plaćene putem "kartica":
SELECT 
    dn.id_dobavljacka_narudzba AS IDNarudzbe,
    d.naziv_dobavljaca AS NazivDobavljaca,
    dn.datum_narudzbe AS DatumNarudzbe,
    p.iznos AS IznosPlacanja
FROM dobavljacke_narudzbe dn
JOIN dobavljaci d ON dn.id_dobavljac = d.id_dobavljac
JOIN placanja p ON dn.id_dobavljacka_narudzba = p.id_dobavljacka_narudzba
WHERE p.nacin_placanja = 'Kartica';

-- POGLED:
-- Prikaz dobavljačkih narudžbi s detaljima o stavkama i plaćanju:
CREATE VIEW pregled_narudzbi AS
SELECT 
    dn.id_dobavljacka_narudzba AS IDNarudzbe,
    d.naziv_dobavljaca AS Dobavljac,
    dn.datum_narudzbe AS DatumNarudzbe,
    p.iznos AS IznosPlacanja,
    sdn.id_proizvod AS IDProizvoda,
    sdn.kolicina AS Kolicina
FROM dobavljacke_narudzbe dn
JOIN dobavljaci d ON dn.id_dobavljac = d.id_dobavljac
JOIN placanja p ON dn.id_dobavljacka_narudzba = p.id_dobavljacka_narudzba
JOIN stavke_dobavljacke_narudzbe sdn ON dn.id_dobavljacka_narudzba = sdn.id_dobavljacka_narudzba;

-- FUNKCIJE:
-- 1.) Izračun ukupne količine proizvoda iz dobavljačkih narudžbi:
DELIMITER //
CREATE FUNCTION UkupnaKolicinaProizvoda(proizvodID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ukupnaKolicina INT;

    SELECT 
        SUM(kolicina)
    INTO 
        ukupnaKolicina
    FROM 
        stavke_dobavljacke_narudzbe
    WHERE 
        id_proizvod = proizvodID;

    RETURN IFNULL(ukupnaKolicina, 0);
END;
//
DELIMITER ;
SELECT * FROM proizvod;
SELECT UkupnaKolicinaProizvoda(1) FROM dual;

-- 2.) Izračun prosječnog iznosa plaćanja za dobavljačke narudžbe:
DELIMITER //
CREATE FUNCTION ProsjecniIznosPlacanja(dobavljacID INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE prosjecniIznos DECIMAL(10, 2);

    SELECT 
        AVG(p.iznos)
    INTO 
        prosjecniIznos
    FROM 
        placanja p
    JOIN 
        dobavljacke_narudzbe dn ON p.id_dobavljacka_narudzba = dn.id_dobavljacka_narudzba
    WHERE 
        dn.id_dobavljac = dobavljacID;

    RETURN IFNULL(prosjecniIznos, 0.00);
END;
//
DELIMITER ;
SELECT * FROM placanja;
SELECT ProsjecniIznosPlacanja(81) FROM dual;

-- PROCEDURE:
-- 1.) Dodavanje nove dobavljačke narudžbe:
DELIMITER //
CREATE PROCEDURE DodajDobavljackuNarudzbu(
    IN idDobavljac INT,
    IN datumNarudzbe DATETIME,
    IN stavke JSON
)
BEGIN
    DECLARE noviID INT;
    INSERT INTO dobavljacke_narudzbe (id_dobavljac, datum_narudzbe)
    VALUES (idDobavljac, datumNarudzbe);

    SET noviID = LAST_INSERT_ID();
END;
//
DELIMITER;
-- 2.) Ažuriranje plaćanje za određenu dobavljačku narudžbu:
DELIMITER //
CREATE PROCEDURE AzurirajPlacanje(
    IN idNarudzba INT,
    IN noviIznos DECIMAL(10, 2),
    IN nacinPlacanja VARCHAR(30)
)
BEGIN
    UPDATE placanja
    SET iznos = noviIznos, nacin_placanja = nacinPlacanja, datum_placanja = NOW()
    WHERE id_dobavljacka_narudzba = idNarudzba;
END;
//
DELIMITER ;

-- OKIDAČ (TRIGGER):
-- sprječavanje umetanje stavke dobavljačke narudžbe s količinom manjom od 1 ili većom od 1000:
DELIMITER //
CREATE TRIGGER sprijeci_neispravnu_kolicinu
BEFORE INSERT ON stavke_dobavljacke_narudzbe
FOR EACH ROW
BEGIN
    IF NEW.kolicina < 1 OR NEW.kolicina > 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Količina mora biti između 1 i 1000.';
    END IF;
END;
//
DELIMITER ;

-- TRANSAKCIJA:
-- Dodavanje narudžbi s uplatama:
START TRANSACTION;

-- Provjera postoji li dobavljač
IF NOT EXISTS (SELECT 1 FROM dobavljaci WHERE id_dobavljac = 81) THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dobavljač s ID-om 81 ne postoji.';
END IF;

INSERT INTO dobavljacke_narudzbe (id_dobavljacka_narudzba, id_dobavljac, datum_narudzbe)
VALUES (511, 81, NOW());

IF NOT EXISTS (SELECT 1 FROM proizvodi WHERE id_proizvod = 1) THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Proizvod s ID-om 1 ne postoji.';
END IF;

IF NOT EXISTS (SELECT 1 FROM proizvodi WHERE id_proizvod = 2) THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Proizvod s ID-om 2 ne postoji.';
END IF;

INSERT INTO stavke_dobavljacke_narudzbe (id_stavka_dobavljaca, id_dobavljacka_narudzba, id_proizvod, kolicina)
VALUES 
(601, 511, 1, 50),
(602, 511, 2, 100);

IF 150.00 <= 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Iznos plaćanja mora biti veći od 0.';
END IF;

INSERT INTO placanja (id_placanje, id_dobavljacka_narudzba, iznos, datum_placanja, nacin_placanja)
VALUES 
(591, 511, 150.00, NOW(), 'Kartica');

COMMIT;

-- SANJA:

-- Broj zaposlenika po skladištu(POGLED):
CREATE VIEW broj_zaposlenika_po_skladistu AS
SELECT s.naziv_skladista, COUNT(z.id_zaposlenik) AS broj_zaposlenika
FROM skladista s
LEFT JOIN zaposlenici z ON s.id_skladiste = z.id_skladiste
GROUP BY s.naziv_skladista;

SELECT * FROM broj_zaposlenika_po_skladistu;

-- UPITI
-- 1.) Koliko je puta neki zaposlenik izvršio narudžbi:
SELECT z.id_zaposlenik, z.ime, z.prezime, COUNT(n.id_zaposlenik) AS broj_narudzbi 
FROM zaposlenici z 
JOIN narudzbe n ON z.id_zaposlenik = n.id_zaposlenik
GROUP BY n.id_zaposlenik
ORDER BY broj_narudzbi DESC;

-- 2.) Popis zaposlenika koji imaju narudžbe u zadnjih 30 dana
SELECT z.ime, z.prezime, z.email, n.datum_narudzbe
FROM zaposlenici z
JOIN narudzbe n ON z.id_zaposlenik = n.id_zaposlenik
WHERE n.datum_narudzbe >= NOW() - INTERVAL 30 DAY
ORDER BY n.datum_narudzbe DESC;

-- 3.) koliko je narudžbi obradilo svako skladište, s nazivima skladišta i brojem narudžbi
SELECT s.naziv_skladista, COUNT(n.id_narudzba) AS broj_narudzbi
FROM skladista s
LEFT JOIN zaposlenici z ON s.id_skladiste = z.id_skladiste
LEFT JOIN narudzbe n ON z.id_zaposlenik = n.id_zaposlenik
GROUP BY s.naziv_skladista
ORDER BY broj_narudzbi DESC;

-- FUNKCIJE: 
-- 1.) Dohvaćanje ukupnog broja narudžbi zaposlenika po ID-u

DELIMITER //
CREATE FUNCTION broj_narudzbi_zaposlenika(zaposlenik_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE broj_narudzbi INTEGER;
    SELECT COUNT(*) INTO broj_narudzbi
    FROM narudzbe
    WHERE id_zaposlenik = zaposlenik_id;
    RETURN broj_narudzbi;
END //

DELIMITER ;

SELECT * FROM narudzbe;

SELECT  broj_narudzbi_zaposlenika(165) FROM DUAL;

-- 2.) Dohvaćanje ukupnog broja zaposlenika u određenom skladištu

DELIMITER //
CREATE FUNCTION broj_zaposlenika_skladiste(skladiste_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE broj INTEGER;
    SELECT COUNT(*) INTO broj
    FROM zaposlenici
    WHERE id_skladiste = skladiste_id;
    RETURN broj;
END //

DELIMITER ;

SELECT * FROM zaposlenici;
SELECT  broj_narudzbi_zaposlenika(165) FROM DUAL;

-- PROCEDURA + TRANSAKCIJA:
-- 1.) Dodavanje radnika na skladište: 
SELECT @@autocommit;
SET AUTOCOMMIT = OFF;

DROP PROCEDURE IF EXISTS zaposljavanje;
DELIMITER //
CREATE PROCEDURE zaposljavanje(p_id INTEGER, p_ime VARCHAR(20), p_prezime VARCHAR(20), p_email VARCHAR(30), p_telefon VARCHAR(20),p_id_skladiste INTEGER)
BEGIN
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
		IF EXISTS (SELECT 1 FROM zaposlenici WHERE id_zaposlenik=p_id OR telefon=p_telefon OR email=p_email) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Ne možeš dodati zaposlenika koji ima isti ID/telefon/email postojećeg zaposlenika!';
		ROLLBACK;
		END IF;
			IF p_id<161 OR p_id>200 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Ne možeš dodati ID zaposlenika koji je izvan dozvoljenog raspona!';
			ROLLBACK;
			END IF;
				IF NOT EXISTS (SELECT 1 FROM skladista WHERE id_skladiste = p_id_skladiste) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Nepostojeće skladište!';
				ROLLBACK;
				END IF;
    INSERT INTO zaposlenici 
    VALUES (p_id, p_ime, p_prezime, p_email, p_telefon, p_id_skladiste);
    COMMIT;
END //
DELIMITER ;

SELECT * FROM zaposlenici;
CALL zaposljavanje(174, 'Franjo', 'Franjevački', 'franjo_franjo@gmail.com', '0956769009',125);
SELECT * FROM zaposlenici;
DELETE FROM zaposlenici WHERE id=174;

SET AUTOCOMMIT = ON;
-- PROCEDURA: 
-- 2.)Prikaz narudžbi zaposlenika po ID-u i filtriranje po datumu
DELIMITER //
CREATE PROCEDURE prikaz_narudzbi_zaposlenika(IN zaposlenik_id INTEGER, IN pocetni_datum DATE, IN zavrsni_datum DATE)
BEGIN
    SELECT n.id_narudzba, n.datum_narudzbe, z.ime, z.prezime
    FROM narudzbe n
    JOIN zaposlenici z ON n.id_zaposlenik = z.id_zaposlenik
    WHERE n.id_zaposlenik = zaposlenik_id
      AND n.datum_narudzbe BETWEEN pocetni_datum AND zavrsni_datum
    ORDER BY n.datum_narudzbe;
END //
DELIMITER ;

CALL prikaz_narudzbi_zaposlenika(166, '2025-01-01', '2025-01-10');

-- OKIDAČ:  
-- Sprječavanje dodavanja narudžbe za zaposlenika koji već ima narudžbu na isti datum
DELIMITER //
CREATE TRIGGER sprijeci_duple_narudzbe
BEFORE INSERT ON narudzbe
FOR EACH ROW
BEGIN
    DECLARE postoji INTEGER;
    SELECT COUNT(*) INTO postoji
    FROM narudzbe
    WHERE id_zaposlenik = NEW.id_zaposlenik
      AND DATE(datum_narudzbe) = DATE(NEW.datum_narudzbe);
    IF postoji>0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Zaposlenik već ima narudžbu na isti datum.';
    END IF;
END
// DELIMITER ;

INSERT INTO narudzbe (id_narudzba, datum_narudzbe, id_zaposlenik)
VALUES (301, STR_TO_DATE('09.01.2025.', '%d.%m.%Y.'), 165);

-- MARTINA

-- Stanje skaldišta(POGLED)
CREATE VIEW stanje_inventara AS
SELECT  p.id_proizvod, p.naziv_proizvoda, p.opis AS opis_proizvoda, p.cijena,i.trenutna_kolicina, k.naziv_kategorije, s.naziv_skladista, s.lokacija
FROM inventar i
JOIN proizvodi p ON i.id_proizvod = p.id_proizvod
JOIN kategorije k ON p.id_kategorija = k.id_kategorija
JOIN skladista s ON i.id_skladiste = s.id_skladiste;

SELECT * FROM stanje_inventara;

-- UPIT 
	-- 1.Ukupan broj povrata
    SELECT p.id_proizvod, p.naziv_proizvoda, SUM(i.kolicina) AS broj_povrata
    FROM povrati_proizvoda
    JOIN inventar i on p.id_proizvod = i.proizvod_id
    GROUP BY p.id_proizvod, p.naziv_proizvoda
    ORDER BY broj_povrata DESC;
    
    -- 2.Najprodavaniji proizvod
    SELECT  p.id_proizvod, i.naziv_proizvoda, SUM(n.kolicina) AS ukupno_prodano
		FROM stavke_racuna sr
	JOIN proizvodi p ON sr.id_proizvod = p.id_proizvod
	JOIN inventar i ON p.id_proizvod = i.id_proizvod
	GROUP BY p.id_proizvod, i.naziv_proizvoda
	ORDER BY ukupno_prodano DESC
		LIMIT 1;
        
	-- 3.Mala količina 
    SELECT i.id_proizvod, p.naziv_proizvoda, i.trenutna_kolicina
	FROM inventar i
		JOIN proizvodi p ON i.id_proizvod = p.id_proizvod
	WHERE i.trenutna_kolicina < 10
	ORDER BY i.trenutna_kolicina ASC;
    
    -- FUNKCIJE
    -- 1.Trenutna količina 
    DELIMITER //

	CREATE FUNCTION trenutna_kolicina_proizvoda(p_id_proizvod INTEGER)
	RETURNS INTEGER
	DETERMINISTIC
	BEGIN
		DECLARE kolicina INTEGER;
    
    SELECT trenutna_kolicina INTO kolicina
    FROM inventar
    WHERE id_proizvod = p_id_proizvod;
    
    RETURN kolicina;
	END //

	DELIMITER ;
    
    -- 2.Vraća status dostave prema ID-u
    DELIMITER //
	CREATE FUNCTION status_dostave_prema_id(p_id_dostava INTEGER)
	RETURNS VARCHAR(20)
	DETERMINISTIC
	BEGIN
		DECLARE status VARCHAR(20);
    
    SELECT status_dostave INTO status
    FROM dostave
    WHERE id_dostava = p_id_dostava;
    
   
    RETURN status;
	END //

	DELIMITER ;
    
    -- Procedura + tranakcija
    -- 1.Pračenje statusa dostave
    DELIMITER//

CREATE PROCEDURE azuriraj_status_dostave(
    IN p_id_dostava INT,
    IN p_novi_status VARCHAR(20)
)
BEGIN
    START TRANSACTION;

    UPDATE dostave
    SET status_dostave = p_novi_status
    WHERE id_dostava = p_id_dostava;

    IF ROW_COUNT() = 0 THEN
        SELECT 'Nema dostave s tim ID-om.' AS error_message;
        ROLLBACK;
    ELSE
        SELECT 'Status dostave je uspješno ažuriran!' AS success_message;
        COMMIT;
    END IF;
END $$

DELIMITER ;

    

-- 2. Povrat proizvoda
DELIMITER//

CREATE PROCEDURE PovratProizvoda(
    IN p_id_racun INT,                
    IN p_id_proizvod INT,              
    IN p_kolicina INT,                 
    IN p_razlog_povrata TEXT           
)
BEGIN
    DECLARE v_trenutna_kolicina INT;

    SELECT trenutna_kolicina
    INTO v_trenutna_kolicina
    FROM inventar
    WHERE id_proizvod = p_id_proizvod
    LIMIT 1;

    IF v_trenutna_kolicina >= p_kolicina THEN
	
        START TRANSACTION;

	
        UPDATE inventar
        SET trenutna_kolicina = trenutna_kolicina + p_kolicina
        WHERE id_proizvod = p_id_proizvod;

        INSERT INTO povrati_proizvoda (id_racun, id_proizvod, kolicina, datum_povrata, razlog_povrata)
        VALUES (p_id_racun, p_id_proizvod, p_kolicina, NOW(), p_razlog_povrata);

        COMMIT;

        SELECT 'Povrat proizvoda je uspješno obavljen.' AS success_message;
    ELSE
        -- Ako nema dovoljno proizvoda u inventaru
        SELECT 'Nemate dovoljno proizvoda u inventaru za povrat.' AS error_message;
    END IF;
END;

DELIMITER ;


    
    
    -- OKIDAČ
    -- Sprječava duplu dostavu
    DELIMITER//
	CREATE TRIGGER sprijeci_duple_dostave
	BEFORE INSERT ON dostave
	FOR EACH ROW
	BEGIN
    DECLARE dostava_postoji INT;

    SELECT COUNT(*) INTO dostava_postoji
    FROM stavke_racuna sr
    JOIN racuni r ON sr.id_racun = r.id_racun
    WHERE r.id_racun = NEW.id_racun AND sr.id_proizvod = NEW.id_proizvod;

    IF dostava_postoji > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Dostava za ovaj proizvod i račun već postoji!';
    END IF;
	END;

DELIMITER ;
