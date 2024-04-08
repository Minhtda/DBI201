USE master
IF OBJECT_ID('SV_SE162088') IS NOT NULL 
DROP DATABASE TRANDAIANHMINH
CREATE DATABASE TRANDAIANHMINH
USE TRANDAIANHMINH

--1 Dung cau lenh create table tao 3 bang

IF OBJECT_ID('SV_SE162088') IS NOT NULL 
DROP TABLE SV_SE162088

IF OBJECT_ID('KQ_SE162088') IS NOT NULL 
DROP TABLE SV_SE162088

IF OBJECT_ID('MH_SE162088') IS NOT NULL 
DROP TABLE SV_SE162088

CREATE TABLE SV_SE162088(
MASV VARCHAR(8) PRIMARY KEY,
HOSV      VARCHAR(25)  NOT NULL,
TENSV     VARCHAR(20)  NOT NULL,
PHAI VARCHAR(3) NOT NULL,
NGAYSINH DATE NOT NULL,
NOISINH VARCHAR(30)
)
CREATE TABLE KQ_SE162088(
MASV VARCHAR(8),
MAMH      VARCHAR(8),
DIEM_Q    NUMERIC(3,1)  NOT NULL,
DIEM_L    NUMERIC(3,1)  NOT NULL,
DIEM_AS    NUMERIC(3,1)  NOT NULL,
)
CREATE TABLE MH_SE162088(
MAMH      VARCHAR(8)  PRIMARY KEY,
TENMH VARCHAR(30) NOT NULL,
SOTIET NUMERIC(2,0) NOT NULL
)

--2 Dung cay lenh alter table de cai dat lien ket 1-N

ALTER TABLE KQ_SE162088
ADD CONSTRAINT  AB001
    FOREIGN KEY (MASV)
	REFERENCES  SV_SE162088(MASV)

ALTER TABLE KQ_SE162088
ADD CONSTRAINT  BC001
    FOREIGN KEY (MAMH)
	REFERENCES  MH_SE162088(MAMH)

--3 Thuc hien cau lenh insert de nhap du lieu vao ba bang 

INSERT INTO SV_SE162088
VALUES ('SE162088','Tran Dai Anh','Minh','Nam','2002-12-12','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162205','Nguyen Anh','Duy','Nam','2002-12-12','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162406','Nguyen Ngoc','Khuong','Nu','2002-11-04','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162930','Hoang Tuan','Minh','Nam','2002-05-27','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162119','Le Quang','An','Nam','2002-08-17','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162492','Pham Ngoc','Han','Nu','2002-04-19','TP HCM')

INSERT INTO MH_SE162088
VALUES ('TRS601','Database Systems',30)
INSERT INTO MH_SE162088
VALUES ('IOT102','Internet of Things',15)
INSERT INTO MH_SE162088
VALUES ('MAS291','Probability & statistics',30)
INSERT INTO MH_SE162088
VALUES ('JPD113','Japanese 1',30)
INSERT INTO MH_SE162088
VALUES ('MAE101','Mathematics for Engineering',30)
INSERT INTO MH_SE162088
VALUES ('VOV123','Vovinam 2',30)

INSERT INTO KQ_SE162088
VALUES ('SE162088','TRS601',7.5,8,7)
INSERT INTO KQ_SE162088
VALUES ('SE162205','IOT102',10.0,10.0,10.0)
INSERT INTO KQ_SE162088
VALUES ('SE162406','MAS291',8.5,9.6,9.1)
INSERT INTO KQ_SE162088
VALUES ('SE162205','IOT102',6.7,7.5,8.3)
INSERT INTO KQ_SE162088
VALUES ('SE162119','JPD113',8.5,9.0,10.0)
INSERT INTO KQ_SE162088
VALUES ('SE162492','VOV123',10.0,10.0,10.0)

SELECT *
FROM SV_SE162088

SELECT *
FROM MH_SE162088

SELECT *
FROM KQ_SE162088