-- Tworzy tabelę stanowisko (nazwa, opis, wypłata)
use firma_budowlana;
create table stanowisko (
	id INT Primary Key auto_increment,
	nazwa Varchar(30),
	opis Varchar(60),
	wypłata BIGINT
);

Insert into stanowisko(nazwa, opis, wypłata) 
Values
('sekretarka', 'prace biurowe i organizacja dokumentów', 10000),
('murarz/tynkarz', 'praca na świeżym powietrzu, wymaga uprawnień', 6000),
('robotnik budowlany', 'nie wymaga uprawnień, pomoc przy budowie', 5500),
('glazurnik', 'wymagane uprawnienia', 6000),
('cieśla', 'istotne zdolnosci manualne', 11000),
('ślusarz', 'praca na wysokości', 7500);

-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowosc)
use firma_budowlana;
create table adres (
	id INT Primary Key auto_increment,
	ulica Varchar(30),
	numer Varchar(30),
	kod_pocztowy CHAR(10),
	miejscowosc Varchar(40)
);

Insert into adres(ulica, numer, kod_pocztowy, miejscowosc) 
Values
('Kasztanowa', '2/15', '57-100', 'Nowe Chrapowo'),
('Okulickiego', '8b/4', '34-532', 'Linie'),
('Jablonowa', '210', '74-562', 'Okolin'),
('Romera', '2c/10', '56-108', 'Biezdziadki'),
('Dominikanska', '2/15', '76-200', 'Słupsk'),
('Lokalna', '8', 77-216, 'Bielun');

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
use firma_budowlana;
create table pracownik1 (
	id INT PRIMARY KEY auto_increment ,
	imie VARCHAR(30),
	nazwisko VARCHAR(30),
    stanowisko_id INT UNIQUE NOT NULL, 
    adres_id INT UNIQUE NOT NULL,
    FOREIGN KEY (stanowisko_id) REFERENCES stanowisko(id),
    FOREIGN KEY (adres_id) REFERENCES adres(id)
    );

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
SELECT * FROM pracownik1;
Insert into pracownik1(imie,nazwisko,stanowisko_id,adres_id) 
Values
('Iga','Olech',1,1),
('Lucjan','Brzdąc',2,3),
('Karol','Naruś',3,2),
('Igor','Wąs',4,5),
('Mateusz','Cilek',6,4),
('Olek', 'Pantofel',5,6);

-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT p1.imie, p1.nazwisko, a.ulica, a.numer, a.kod_pocztowy, a.miejscowosc, s.nazwa AS stanowisko FROM 
pracownik1 AS p1, adres AS a, stanowisko AS s where p1.stanowisko_id = s.id AND p1.adres_id = a.id;

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie należy pobrać wypłaty wszystkich pracowników, 
-- a nie sumę wypłat na wszystkich stanowiskach. 
SELECT p1.imie, p1.nazwisko,s.wypłata FROM pracownik1 AS p1, stanowisko AS s where p1.stanowisko_id = s.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT p1.imie, p1.nazwisko, a.ulica, a.numer, a.kod_pocztowy, a.miejscowosc FROM pracownik1 AS p1, adres as a Where p1.adres_id=a.id AND kod_pocztowy = '76-200';

-- dodam coś na próbę czy uda się zapisac