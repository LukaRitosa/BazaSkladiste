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
    CONSTRAINT kategorija_id_fk FOREIGN KEY (id_kategorija) REFERENCES kategorije(id_kategorija),
    CONSTRAINT dobavljac_id_fk FOREIGN KEY (id_dobavljac) REFERENCES dobavljaci(id_dobavljac)
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
    CONSTRAINT skladiste_id_fk FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste),
    CONSTRAINT provjera_znamenki_telefona CHECK(LENGTH(telefon)>=10 OR LENGTH(telefon)<=14),
    CONSTRAINT provjera_email CHECK(email LIKE'%@%')
);

CREATE TABLE narudzbe (
    id_narudzba INTEGER PRIMARY KEY,
    datum_narudzbe DATETIME NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
    CONSTRAINT zaposlenik_id_fk FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id_zaposlenik)
);

/*
EUGEN

stavke_narudzbe (
    id_stavka PRIMARY KEY,
    id_narudzba,
    id_proizvod,
    kolicina,
    FOREIGN KEY (id_narudzba) REFERENCES narudzbe(id_narudzba),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

ulazi_proizvoda (
    id_ulaz PRIMARY KEY,
    id_proizvod,
    kolicina,
    datum_ulaza,
    id_skladiste,
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod),
    FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste)
);

izlazi_proizvoda (
    id_izlaz PRIMARY KEY,
    id_proizvod,
    kolicina,
    datum_izlaza,
    id_skladiste,
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod),
    FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste)
);

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

RAMIC

dobavljacke_narudzbe (
    id_dobavljacka_narudzba PRIMARY KEY,
    id_dobavljac,
    datum_narudzbe,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljaci(id_dobavljac)
);

stavke_dobavljacke_narudzbe (
    id_stavka_dobavljaca PRIMARY KEY,
    id_dobavljacka_narudzba,
    id_proizvod,
    kolicina,
    FOREIGN KEY (id_dobavljacka_narudzba) REFERENCES dobavljacke_narudzbe(id_dobavljacka_narudzba),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

placanja (
    id_placanje PRIMARY KEY,
    id_racun,
    iznos,
    datum_placanja,
    nacin_placanja,
    FOREIGN KEY (id_racun) REFERENCES racuni(id_racun)
);
*/
MARTINA

CREATE TABLE inventar (
    id_inventar INTEGER PRIMARY KEY,
    id_skladiste INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    trenutna_kolicina INTEGER NOT NULL,
   CONSTRAINT skladiste_id_fk FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste),
   CONSTRAINT proizvodi_id_fk FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

CREATE TABLE dostave (
    id_dostava INTEGER PRIMARY KEY,
    id_racun INTEGER NOT NULL,
    datum_dostave DATETIME NOT NULL,
    adresa_dostave VARCHAR(40) NOT NULL,
    status_dostave VARCHAR(20) NOT NULL,
    CONSTRAINT racun_id_fk FOREIGN KEY (id_racun) REFERENCES racuni(id_racun)
);

CREATE TABLE povrati_proizvoda (
    id_povrat INTEGER PRIMARY KEY,
    id_racun INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    datum_povrata DATETIME NOT NULL,
    razlog_povrata TEXT NOT NULL,
    CONSTRAINT racun_id_fk FOREIGN KEY (id_racun) REFERENCES racuni(id_racun),
    CONSTRAINT proizvod_id_fk FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

