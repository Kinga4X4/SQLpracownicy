CREATE DATABASE firma_budowlana CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci;
-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko).
use firma_budowlana;
CREATE table pracownik(
id INT auto_increment PRIMARY KEY,
imie VARCHAR(30),
nazwisko VARCHAR(30),
wypłata BIGINT,
data_urodzenia date,
stanowisko VARCHAR(30)
);
-- Wstawia do tabeli co najmniej 6 pracowników
SELECT * FROM pracownik;
Insert into pracownik(imie,nazwisko,wypłata,data_urodzenia,stanowisko) 
Values
('Olga','Olech',10000,'1986-04-29','sekretarka'),
('Michał','Brzdąc',6000,'1981-05-15','murarz/tynkarz'),
('Arnold','Naruś',5500,'1995-12-08','robotnik budowlany'),
('Olgierd','Wąs',6000,'1978-10-04','glazurnik'),
('Mariusz','Cilek',11000,'1979-11-18','cieśla'),
('Jakub','Warnowicz',7500,'1974-01-10','ślusarz');

-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT*From pracownik order by nazwisko;

-- Pobiera pracowników na wybranym stanowisku
SELECT * from pracownik Where stanowisko like 'cieśla';

-- Pobiera pracowników, którzy mają co najmniej 30 lat
Select * from pracownik where (year(curdate()) - year(data_urodzenia))>=30;

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE pracownik SET wypłata = 1.1*wypłata Where stanowisko = 'glazurnik';

-- Pobiera najmłodszego pracownika (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
select * from pracownik where data_urodzenia = (select max(data_urodzenia) from pracownik);

-- Usuwa tabelę pracownik
drop table pracownik;

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
('Iga','Olech',7,1),
('Lucjan','Brzdąc',8,3),
('Karol','Naruś',9,2),
('Igor','Wąs',10,5),
('Mateusz','Cilek',12,4),
('Olek', 'Pantofel',11,6);

-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT p1.imie, p1.nazwisko, a.ulica, a.numer, a.kod_pocztowy, a.miejscowosc, s.nazwa AS stanowisko FROM 
pracownik1 AS p1, adres AS a, stanowisko AS s where p1.stanowisko_id = s.id AND p1.adres_id = a.id;

-- !!!!!! poprawOblicza sumę wypłat dla wszystkich pracowników w firmie należy pobrać wypłaty wszystkich pracowników, a nie sumę wypłat na wszystkich stanowiskach. 
-- Co jak będziemy mieli przykładowo tylko 3 ślusarzy?
SELECT p1.imie, p1.nazwisko,s.wypłata FROM pracownik1 AS p1, stanowisko AS s where p1.stanowisko_id = s.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT p1.imie, p1.nazwisko, a.ulica, a.numer, a.kod_pocztowy, a.miejscowosc FROM pracownik1 AS p1, adres as a Where p1.adres_id=a.id AND kod_pocztowy = '76-200';
