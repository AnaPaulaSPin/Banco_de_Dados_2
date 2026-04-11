-- LOCALIZAÇÃO
CREATE TABLE Estado (
  idEstado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uf CHAR(2) NOT NULL,
  nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Cidade (
  idCidade INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  idEstado INT UNSIGNED NOT NULL,
  FOREIGN KEY (idEstado) REFERENCES Estado(idEstado),
  UNIQUE (nome, idEstado)
);

CREATE TABLE Bairro (
  idBairro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  idCidade  INT UNSIGNED NOT NULL,
  FOREIGN KEY (idCidade) REFERENCES Cidade(idCidade)
);

-- INSTITUIÇÃO E CAMPUS
CREATE TABLE Instituicao (
  idInstituicao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  cnpj VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(50) NOT NULL
);

CREATE TABLE Campus (
  idCampus INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  idBairro INT UNSIGNED NOT NULL,
  idInstituicao INT UNSIGNED NOT NULL,
  FOREIGN KEY (idBairro) REFERENCES Bairro(idBairro),
  FOREIGN KEY (idInstituicao) REFERENCES Instituicao(idInstituicao)
);

CREATE TABLE Telefone (
  idTelefone INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) NOT NULL,
  idInstituicao INT UNSIGNED NOT NULL,
  FOREIGN KEY (idInstituicao) REFERENCES Instituicao(idInstituicao)
);

-- CURSO E DISCIPLINA
CREATE TABLE Curso (
  idCurso INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  turno INT NOT NULL,
  idCampus INT UNSIGNED NOT NULL,
  matriz_curricular VARCHAR(100),
  projeto_pedagogico VARCHAR(100),
  FOREIGN KEY (idCampus) REFERENCES Campus(idCampus)
);

CREATE TABLE Disciplina (
  idDisciplina INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  carga_horaria INT NOT NULL
);

CREATE TABLE Curso_Disciplina (
  idCurso INT UNSIGNED  NOT NULL,
  idDisciplina INT UNSIGNED  NOT NULL,
  PRIMARY KEY (idCurso, idDisciplina),
  FOREIGN KEY (idCurso) REFERENCES Curso(idCurso),
  FOREIGN KEY (idDisciplina) REFERENCES Disciplina(idDisciplina)
);

-- USUÁRIOS
CREATE TABLE Usuario (
  idUsuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  senha VARCHAR(30) NOT NULL,
  tipo INT NOT NULL
);

CREATE TABLE Docente (
  idDocente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  titularidade INT NOT NULL,
  especialidades VARCHAR(50),
  idUsuario INT UNSIGNED NOT NULL,
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Discente (
  idDiscente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  matricula INT NOT NULL UNIQUE,
  ingresso INT NOT NULL,
  idCurso INT UNSIGNED NOT NULL,
  idUsuario INT UNSIGNED NOT NULL,
  FOREIGN KEY (idCurso) REFERENCES Curso(idCurso),
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

-- TURMAS
CREATE TABLE Turma (
  idTurma INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  idCurso INT UNSIGNED NOT NULL,
  idDisciplina INT UNSIGNED NOT NULL,
  semestre INT NOT NULL,
  ano INT NOT NULL,
  idDocente INT UNSIGNED NOT NULL,
  FOREIGN KEY (idCurso) REFERENCES Curso(idCurso),
  FOREIGN KEY (idDisciplina) REFERENCES Disciplina(idDisciplina),
  FOREIGN KEY (idDocente) REFERENCES Docente(idDocente)
);

CREATE TABLE Discente_Turma (
  idDiscente INT UNSIGNED  NOT NULL,
  idTurma INT UNSIGNED  NOT NULL,
  PRIMARY KEY (idDiscente, idTurma),
  FOREIGN KEY (idDiscente) REFERENCES Discente(idDiscente),
  FOREIGN KEY (idTurma) REFERENCES Turma(idTurma)
);

-- QUESTÕES
CREATE TABLE Questao (
  idQuestao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  enunciado VARCHAR(100) NOT NULL,
  tipo INT NOT NULL,
  dificuldade INT NOT NULL,
  idDisciplina INT UNSIGNED NOT NULL,
  idDocente INT UNSIGNED NOT NULL,
  FOREIGN KEY (idDisciplina) REFERENCES Disciplina(idDisciplina),
  FOREIGN KEY (idDocente) REFERENCES Docente(idDocente)
);

CREATE TABLE Alternativa (
  idAlternativa INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  idQuestao INT UNSIGNED NOT NULL,
  descricao VARCHAR(100),
  correta BOOLEAN,
  FOREIGN KEY (idQuestao) REFERENCES Questao(idQuestao)
);

-- PROVA / AVALIAÇÃO
CREATE TABLE Avaliacao (
  idAvaliacao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  idDisciplina INT UNSIGNED NOT NULL,
  titulo VARCHAR(50),
  data_criacao DATETIME,
  tipo INT,
  FOREIGN KEY (idDisciplina) REFERENCES Disciplina(idDisciplina)
);

CREATE TABLE Avaliacao_Questao (
  idAvaliacao INT UNSIGNED  NOT NULL,
  idQuestao INT UNSIGNED NOT NULL,
  PRIMARY KEY (idAvaliacao, idQuestao),
  FOREIGN KEY (idAvaliacao) REFERENCES Avaliacao(idAvaliacao),
  FOREIGN KEY (idQuestao) REFERENCES Questao(idQuestao)
);

-- APLICAÇÃO E RESULTADO
CREATE TABLE Aplicacao (
  idAplicacao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  data_aplicacao DATETIME,
  idTurma INT UNSIGNED NOT NULL,
  idAvaliacao INT UNSIGNED NOT NULL,
  FOREIGN KEY (idTurma) REFERENCES Turma(idTurma),
  FOREIGN KEY (idAvaliacao) REFERENCES Avaliacao(idAvaliacao)
);

CREATE TABLE Resultado (
  idResultado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  idAplicacao INT UNSIGNED NOT NULL,
  idDiscente INT UNSIGNED NOT NULL,
  nota DECIMAL(4,2)  NOT NULL,
  FOREIGN KEY (idAplicacao) REFERENCES Aplicacao(idAplicacao),
  FOREIGN KEY (idDiscente) REFERENCES Discente(idDiscente)
);

