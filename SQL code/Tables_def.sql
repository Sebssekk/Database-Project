# Tables_def. sql
# Contains the DDL part, with the definitions of all the tables with associated constraints

CREATE DATABASE PROGETTO_Fringuelli_Secchiaroli;
USE PROGETTO_Fringuelli_Secchiaroli;

CREATE TABLE Impianto (
	Stato VARCHAR(8) NOT NULL DEFAULT 'a_norma',
	CHECK (Stato='a_norma' OR Stato='no_norma'),
	Categoria VARCHAR(4) NOT NULL REFERENCES Normativa(Titolo) ON UPDATE CASCADE ON DELETE NO ACTION,
	Valore NUMERIC(6),
	DataInst DATE NOT NULL,
	DataRichiesta DATE NOT NULL,
	Cliente VARCHAR(20) NOT NULL REFERENCES Cliente(CF_Piva) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (Cliente,DataInst)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Normativa (
	DataIntro DATE NOT NULL,
	Titolo VARCHAR(4) NOT NULL PRIMARY KEY,
	CHECK (Titolo IN ('Aut','Antf','Vid'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Cliente (
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20),
	CF_Piva VARCHAR(20) PRIMARY KEY,
	Via CHAR(30) NOT NULL,
	N_Civico NUMERIC(3) NOT NULL,
	Citta VARCHAR(20) NOT NULL,
	CAP NUMERIC(5) NOT NULL,
	Mail VARCHAR(50),
	FAX NUMERIC(20)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Telefono (
	Numero NUMERIC(10) PRIMARY KEY,
	Cliente VARCHAR(20) NOT NULL REFERENCES Cliente(CF_Piva) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Ente_Pubblico (
	Cliente VARCHAR(20) PRIMARY KEY REFERENCES Cliente(CF_Piva) ON UPDATE CASCADE ON DELETE CASCADE,
	Metratura NUMERIC(6) NOT NULL,
	CHECK (MetrEnte > 0),
	TipoEnte VARCHAR(50)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Industria (
	Cliente VARCHAR(20) PRIMARY KEY REFERENCES Cliente(CF_Piva) ON UPDATE CASCADE ON DELETE CASCADE,
	Metratura NUMERIC(6) NOT NULL,
	CHECK (MetrInd > 0),
	TipoInd VARCHAR(50)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Contratto_Assistenza (
	Annuale NUMERIC(6) NOT NULL,
	CHECK (AnnualeAssistenza > 0),
	Scadenza DATE NOT NULL,
	Tipologia_Ass VARCHAR(50),
	TotOre_Ass NUMERIC(5) NOT NULL,
	CHECK (TotOre_Ass > 0),
	Cliente VARCHAR(20) NOT NULL,
	DataInst DATE NOT NULL,
	FOREIGN KEY (Cliente,DataInst) REFERENCES Impianto(Cliente,DataInst) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(Cliente,DataInst)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Es_Lavoro (
	DataEs DATE NOT NULL,
	LuogoEs VARCHAR(50) NOT NULL,
	CostoSic NUMERIC(5),
	CHECK (CostoSic >= 0),
	CostoMan NUMERIC(5),
	CHECK (CostoMan >= 0),
	Tipo_lavoro CHAR(3) NOT NULL,
	CHECK(Tipo_lavoro IN ('Ins','Man')),
	Descrizione VARCHAR(50) NOT NULL,
	Cliente VARCHAR(20) NOT NULL,
	DataInst DATE NOT NULL,
	FOREIGN KEY (Cliente,DataInst) REFERENCES Impianto(Cliente,DataInst) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(DataEs,LuogoEs)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Dipendente (
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	CF_Piva VARCHAR(20) PRIMARY KEY,
	Via VARCHAR(30) NOT NULL,
	N_Civico NUMERIC(3) NOT NULL,
	Citta VARCHAR(20) NOT NULL,
	CAP NUMERIC(5) NOT NULL,
	Mail VARCHAR(50),
	Telefono NUMERIC(10) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Effettuazione_Manodopoera (
	Num_ore NUMERIC(2) NOT NULL,
	DataEs DATE NOT NULL,
	LuogoEs VARCHAR(50) NOT NULL,
	Esecutore VARCHAR(20) NOT NULL REFERENCES Dipendente(CF_Piva) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY (DataEs,LuogoEs) REFERENCES Es_Lavoro(DataEs,LuogoEs) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (DataEs,LuogoEs,Esecutore)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Collaboratore (
	P_iva VARCHAR(20) PRIMARY KEY,
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	Professione VARCHAR(50) NOT NULL,
	TempoPer NUMERIC(4) NOT NULL,
	Retrib NUMERIC(6) NOT NULL,
	CHECK (Retrib > 0),
	Mail VARCHAR(30) NOT NULL,
	Telefono NUMERIC(10) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Effettuazione_Manodopoera_SP (
	Num_ore NUMERIC(2) NOT NULL,
	DataEs DATE NOT NULL,
	LuogoEs VARCHAR(50) NOT NULL,
	Esecutore VARCHAR(20) NOT NULL REFERENCES Collaboratore(P_iva) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY (DataEs,LuogoEs) REFERENCES Es_Lavoro(DataEs,LuogoEs) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (DataEs,LuogoEs,Esecutore)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Busta_Paga (
	Dipendente VARCHAR(20) NOT NULL REFERENCES Dipendente(CF_Piva) ON UPDATE CASCADE ON DELETE CASCADE,
	CorrAnnuale NUMERIC(5) NOT NULL,
	CHECK (CorrAnnuale > 0),
	Mensilita NUMERIC(4) NOT NULL,
	CHECK (Mensilita > 0),
	PRIMARY KEY (Dipendente,CorrAnnuale,Mensilita)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Componente (
	CodComp CHAR(10) PRIMARY KEY,
	CasaProd VARCHAR(30),
	PrezzoUn NUMERIC(4) NOT NULL,
	CHECK (PrezzoUn >= 0),
	Nome VARCHAR(30),
	Cliente VARCHAR(20) NOT NULL,
	DataInst DATE NOT NULL,
	FOREIGN KEY (Cliente,DataInst) REFERENCES Impianto(Cliente,DataInst) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Cablaggio_Antifurto (
	CodCabAF CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Sez NUMERIC(2) ,
	Cat CHAR(3) NOT NULL,
	CHECK (Cat='Int' OR Cat='Est')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Comb_Telefonico (
	CodCombin CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	VettoreTel CHAR(4) NOT NULL,
	CHECK (VettoreTel='UMTS' OR VettoreTel='PSTN'),
	Connessione CHAR(3) NOT NULL,
	CHECK (Connessione IN ('Pre','Ass'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Centrale (
	CodCentrale CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	N_Zone NUMERIC(3) NOT NULL,
	CHECK (N_Zone>=10 AND N_Zone<=420)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Rilevatore (
	CodRilevatore CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Tecnologia VARCHAR(20) NOT NULL,
	Portata VARCHAR(20) NOT NULL,
	CHECK (Tecnologia IN ('microwave','infra','radar','mista') AND Portata > 0)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Interfaccia (
	CodInterf CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Tecnologia VARCHAR(20) NOT NULL,
	CHECK (Tecnologia IN ('Touch','Tasti','Transp','Biomet'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Sirena (
	CodSirena CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Locazione CHAR(3) NOT NULL,
	CHECK(Locazione IN ('Int','Est')),
	Potenza NUMERIC(3) NOT NULL,
	CHECK(Potenza > 0 AND Potenza < 120)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Cablaggio_Automaz (
	CodCabAut CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Sez NUMERIC(2) ,
	Cat CHAR(3) NOT NULL,
	CHECK (Cat='Int' OR Cat='Est')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Fotocellula (
	CodFotocellula CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	PortataFot NUMERIC(2) NOT NULL,
	CHECK( PortataFot >= 10 AND PortataFot <=30),
	Connessione CHAR(5) NOT NULL,
	CHECK (Connessione IN ('Wired','Wless'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Costa_Antisk (
	CodCosta CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Altezza NUMERIC(3) NOT NULL,
	CHECK (Altezza > 0)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Motore (
	CodMotore CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	TipoMot CHAR(10) NOT NULL,
	CHECK (TipoMot IN('Canc_Ante','Canc_scorr','Porta','Barriera','Dissuasore'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Comando_Aut (
	CodComando CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Tipologia CHAR(10) NOT NULL,
	CHECK (Tipologia IN ('puls_int','radio','tastiera','puls_chiav'))
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Segnalatore (
	CodSegn CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Segnale CHAR(4) NOT NULL,
	CHECK (Segnale='Lamp' OR Segnale='Acus')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Telecamera (
	CodTelecamera CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Focale CHAR(3) NOT NULL,
	CHECK (Focale = 'Var' OR Focale= 'Fis'),
	Risoluz CHAR(5),
	Motore CHAR(1) NOT NULL,
	CHECK (Motore = 'M' OR Motore= '_')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE VideoReg (
	CodVideoreg CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	N_Canali NUMERIC(2) NOT NULL,
	CHECK (N_Canali>=4),
	ConnVR CHAR(5) NOT NULL,
	CHECK (ConnVR = 'Wired' OR ConnVR= 'Wless'),
	Tecnologia CHAR(1) NOT NULL,
	CHECK(Tecnologia='A' OR Tecnologia='D')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Memorizzazione (
	CodMem CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Archiviazione CHAR(2) NOT NULL,
	CHECK (Archiviazione='SD' OR Archiviazione='HD'),
	Dimensione NUMERIC(4) NOT NULL,
	CHECK (Dimensione>0)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Ponte_Radio (
	CodPonte CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	PortRadio NUMERIC(4) NOT NULL,
	CHECK (PortRadio>0)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Switch (
	CodSwitch CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	DimSwitch NUMERIC(4) NOT NULL,
	CHECK (DimSwitch>0)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Cablaggio_Videos (
	CodCabVS CHAR(10) PRIMARY KEY REFERENCES Componente(CodComp) ON UPDATE CASCADE ON DELETE CASCADE,
	Sez NUMERIC(2),
	Cat CHAR(3) NOT NULL,
	CHECK (Cat='Int' OR Cat='Est')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;
