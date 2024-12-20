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

/*

SANJA

skladista (
    id_kladiste PRIMARY KEY,
    naziv_skladista,
    lokacija
);

zaposlenici (
    id_aposlenik PRIMARY KEY,
    ime,
    prezime,
    email,
    telefon,
    id_skladiste,
    FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste)
);

narudzbe (
    id_narudzba PRIMARY KEY,
    datum_narudzbe,
    id_zaposlenik,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id_zaposlenik)
);

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

MARTINA

inventar (
    id_inventar PRIMARY KEY,
    id_skladiste,
    id_proizvod,
    trenutna_kolicina,
    FOREIGN KEY (id_skladiste) REFERENCES skladista(id_skladiste),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);

dostave (
    id_dostava PRIMARY KEY,
    id_racun,
    datum_dostave,
    adresa_dostave,
    status_dostave,
    FOREIGN KEY (id_racun) REFERENCES racuni(id_racun)
);

povrati_proizvoda (
    id_povrat PRIMARY KEY,
    id_racun,
    id_proizvod,
    kolicina,
    datum_povrata,
    razlog_povrata,
    FOREIGN KEY (id_racun) REFERENCES racuni(id_racun),
    FOREIGN KEY (id_proizvod) REFERENCES proizvodi(id_proizvod)
);
*/