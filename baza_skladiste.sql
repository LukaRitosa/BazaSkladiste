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
    adresa VARCHAR(30) NOT NULL
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
/*
TONI

kupci (
    id_kupac PRIMARY KEY,
    ime,
    prezime,
    email,
    telefon,
    adresa
);

racuni (
    id_racun PRIMARY KEY,
    datum_racuna,
    id_kupac,
    id_zaposlenik,
    FOREIGN KEY (id_kupac) REFERENCES kupci(id_kupac),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id_zaposlenik)
);

stavke_racuna (
    id_stavka_racun PRIMARY KEY,
    id_racun,
    id_proizvod,
    kolicina,
    cijena,
    FOREIGN KEY (id_racun) REFERENCES racuni(id_zaposlenik),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);
*/

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
