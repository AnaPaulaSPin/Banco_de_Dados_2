-- CREATE DATABASE SistemaEnergiaSolar;
use SistemaEnergiaSolar ;
-- =====================================================
-- CIDADE
-- =====================================================

CREATE TABLE Cidade (
  idCidade INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL
);

-- =====================================================
-- BAIRRO
-- =====================================================

CREATE TABLE Bairro (
  idBairro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  regiao VARCHAR(50) NOT NULL,
  idCidade INT UNSIGNED NOT NULL,
  FOREIGN KEY (idCidade) REFERENCES Cidade(idCidade)
);

-- =====================================================
-- SISTEMA DE PAINÉIS
-- =====================================================

CREATE TABLE SistemaPainel (
  idSistemaPainel INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  capacidadeKwp FLOAT NOT NULL,
  dataInstalacao DATETIME NOT NULL,
  vidaUtilEstimada INT NOT NULL,
  status ENUM('ATIVO', 'INATIVO', 'MANUTENCAO') NOT NULL
);

-- =====================================================
-- PAINEL SOLAR
-- =====================================================

CREATE TABLE PainelSolar (
  idPainelSolar INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  modelo VARCHAR(100) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  potenciaWatts FLOAT NOT NULL,
  eficiencia VARCHAR(25) NOT NULL,
  dataFabricacao DATE NOT NULL,
  status ENUM('ATIVO', 'INATIVO', 'MANUTENCAO') NOT NULL,
  idSistemaPainel INT UNSIGNED NOT NULL,
  FOREIGN KEY (idSistemaPainel)
    REFERENCES SistemaPainel(idSistemaPainel)
);

-- =====================================================
-- UNIDADE CONSUMIDORA
-- =====================================================

CREATE TABLE UnidadeConsumidora (
  idUnidadeConsumidora INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nomeResponsavel VARCHAR(100) NOT NULL,
  tipoUnidade ENUM(
    'RESIDENCIAL',
    'COMERCIAL',
    'PUBLICA',
    'INDUSTRIAL'
  ) NOT NULL,
  logradouro VARCHAR(45) NOT NULL,
  numeroResidencia VARCHAR(5) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  email VARCHAR(45),
  dataCadastro DATE NOT NULL,
  idBairro INT UNSIGNED NOT NULL,
  FOREIGN KEY (idBairro)
    REFERENCES Bairro(idBairro)
);

-- =====================================================
-- EMPRESA INSTALADORA
-- =====================================================

CREATE TABLE EmpresaInstaladora (
  idEmpresa INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  razaoSocial VARCHAR(250) NOT NULL UNIQUE,
  cnpj VARCHAR(14) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  logradouro VARCHAR(45) NOT NULL,
  numeroResidencia VARCHAR(5) NOT NULL
);

-- =====================================================
-- MEDIÇÃO DE ENERGIA
-- =====================================================

CREATE TABLE MedicaoEnergia (
  idMedicaoEnergia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dataMedicao DATE NOT NULL,
  energiaGeradaKwh FLOAT NOT NULL,
  energiaConsumidaKwh FLOAT NOT NULL,
  energiaExcedenteKwh FLOAT NOT NULL,
  economiaEstimada FLOAT NOT NULL,
  co2EvitarKg FLOAT NOT NULL,
  idSistemaPainel INT UNSIGNED NOT NULL,
  FOREIGN KEY (idSistemaPainel)
    REFERENCES SistemaPainel(idSistemaPainel)
);

-- =====================================================
-- USUÁRIO
-- =====================================================

CREATE TABLE Usuario (
  idUsuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  senha VARCHAR(45) NOT NULL,
  ultimoLogin DATETIME NOT NULL,
  perfilAcesso ENUM(
    'ADMIN',
    'GESTOR',
    'OPERADOR'
  ) NOT NULL
);

-- =====================================================
-- CONTRATO
-- =====================================================

CREATE TABLE Contrato (
  idContrato INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  numero INT NOT NULL UNIQUE,
  dataInicio DATE NOT NULL,
  dataFim DATE NOT NULL,
  valor FLOAT NOT NULL,
  observacao VARCHAR(45),
  status ENUM(
    'ATIVO',
    'ENCERRADO',
    'SUSPENSO'
  ) NOT NULL,

  idUnidadeConsumidora INT UNSIGNED NOT NULL,
  idSistemaPainel INT UNSIGNED NOT NULL,
  idEmpresaInstaladora INT UNSIGNED NOT NULL,

  FOREIGN KEY (idUnidadeConsumidora)
    REFERENCES UnidadeConsumidora(idUnidadeConsumidora),

  FOREIGN KEY (idSistemaPainel)
    REFERENCES SistemaPainel(idSistemaPainel),

  FOREIGN KEY (idEmpresaInstaladora)
    REFERENCES EmpresaInstaladora(idEmpresa)
);
