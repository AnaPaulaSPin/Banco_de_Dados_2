-- ESTADO
INSERT INTO Estado (uf, nome) VALUES
('BA', 'Bahia'),
('SP', 'São Paulo');

-- CIDADE
INSERT INTO Cidade (nome, idEstado) VALUES
('Salvador', 1),
('Feira de Santana', 1),
('São Paulo', 2);

-- BAIRRO
INSERT INTO Bairro (nome, idCidade) VALUES
('Ondina', 1),
('Brotas', 1),
('Centro', 2),
('Butantã', 3);

-- INSTITUICAO
INSERT INTO Instituicao (nome, cnpj, email) VALUES
('Universidade Nova Era', '12.345.678/0001-90', 'contato@une.edu.br'),
('Faculdade Horizonte', '98.765.432/0001-10', 'secretaria@fh.edu.br');

-- CAMPUS
INSERT INTO Campus (nome, idBairro, idInstituicao) VALUES
('Campus Salvador', 1, 1),
('Campus Feira', 3, 1),
('Campus SP', 4, 2);

-- TELEFONE
INSERT INTO Telefone (numero, idInstituicao) VALUES
('(71) 3333-1111', 1),
('(75) 3222-2222', 1),
('(11) 4000-3000', 2);

-- CURSO
-- turno: 1=Matutino, 2=Vespertino, 3=Noturno
INSERT INTO Curso (nome, turno, idCampus, matriz_curricular, projeto_pedagogico) VALUES
('Sistemas de Informação', 3, 1, 'matriz_si_2026.pdf', 'ppc_si_2026.pdf'),
('Administração', 1, 2, 'matriz_adm_2026.pdf', 'ppc_adm_2026.pdf'),
('Engenharia de Software', 3, 3, 'matriz_es_2026.pdf', 'ppc_es_2026.pdf');

-- DISCIPLINA
INSERT INTO Disciplina (nome, carga_horaria) VALUES
('Banco de Dados', 60),
('Programação Web', 60),
('Algoritmos', 80),
('Gestão de Projetos', 40);

-- CURSO_DISCIPLINA
INSERT INTO Curso_Disciplina (idCurso, idDisciplina) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(3, 4);

-- USUARIO
-- tipo: 1=Docente, 2=Discente, 3=Administrador
INSERT INTO Usuario (nome, email, senha, tipo) VALUES
('Marina Souza', 'marina@une.edu.br', '123456', 1),
('Carlos Lima', 'carlos@une.edu.br', '123456', 1),
('Ana Beatriz', 'ana@aluno.edu.br', '123456', 2),
('João Pedro', 'joao@aluno.edu.br', '123456', 2),
('Luciana Alves', 'luciana@aluno.edu.br', '123456', 2);

-- DOCENTE
-- titularidade: 1=Especialista, 2=Mestre, 3=Doutor
INSERT INTO Docente (titularidade, especialidades, idUsuario) VALUES
(3, 'Banco de Dados, Modelagem', 1),
(2, 'Programação Web, Engenharia de Software', 2);

-- DISCENTE
INSERT INTO Discente (matricula, ingresso, idCurso, idUsuario) VALUES
(2026001, 2026, 1, 3),
(2026002, 2026, 1, 4),
(2026003, 2026, 3, 5);

-- TURMA
-- semestre: 1 ou 2
INSERT INTO Turma (idCurso, idDisciplina, semestre, ano, idDocente) VALUES
(1, 1, 1, 2026, 1),
(1, 2, 1, 2026, 2),
(3, 1, 1, 2026, 1);

-- DISCENTE_TURMA
INSERT INTO Discente_Turma (idDiscente, idTurma) VALUES
(1, 1),
(2, 1),
(1, 2),
(3, 3);

-- CONTRATO
INSERT INTO Contrato (idDocente, dataInicio, dataValidade, bolsa) VALUES
(1, '2026-01-01', '2026-12-31', 5000.00),
(2, '2026-01-01', '2026-12-31', 4500.00);

--------------------------------------------------
-- QUESTÕES (BASE)
-- dificuldade: 1=Facil, 2=Media, 3=Dificil
--------------------------------------------------
INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato) VALUES
('O que e uma chave primaria em banco de dados?', 1, 1, 1),
('Explique o conceito de normalizacao.', 2, 1, 1),
('Qual tag HTML e usada para formularios?', 1, 2, 2);

--------------------------------------------------
-- QUESTÕES OBJETIVAS
--------------------------------------------------

-- MULTIPLA ESCOLHA
INSERT INTO QuestaoObjetiva (idQuestao, tipoObjetiva) VALUES
(1, 'MULTIPLA'),
(3, 'MULTIPLA');

--------------------------------------------------
-- QUESTÕES DISCURSIVAS
--------------------------------------------------
INSERT INTO QuestaoDiscursiva (idQuestao, respostaEsperada) VALUES
(2, 'Processo de organizacao dos dados para evitar redundancia e inconsistencias.');

--------------------------------------------------
-- ALTERNATIVAS (SÓ PARA OBJETIVAS)
--------------------------------------------------
INSERT INTO Alternativa (idQuestao, descricao, correta) VALUES
(1, 'Um campo que identifica unicamente cada registro.', TRUE),
(1, 'Um campo usado apenas para ordenacao.', FALSE),
(1, 'Um campo opcional em toda tabela.', FALSE),
(3, '<form>', TRUE),
(3, '<table>', FALSE),
(3, '<input>', FALSE);

-- AVALIACAO
-- tipo: 1=Prova, 2=Lista, 3=Simulado
INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo) VALUES
(1, 'Prova 1 - Banco de Dados', '2026-04-10 08:00:00', 1),
(2, 'Lista 1 - Programacao Web', '2026-04-10 10:00:00', 2);

-- AVALIACAO_QUESTAO
INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao) VALUES
(1, 1),
(1, 2),
(2, 3);

-- APLICACAO
INSERT INTO Aplicacao (data_aplicacao, idTurma, idAvaliacao) VALUES
('2026-04-15 19:00:00', 1, 1),
('2026-04-16 19:00:00', 2, 2);

-- RESULTADO
INSERT INTO Resultado (idAplicacao, idDiscente, nota) VALUES
(1, 1, 8.50),
(1, 2, 7.00),
(2, 1, 9.00);