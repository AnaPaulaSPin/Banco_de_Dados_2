-- NOVOS USUARIOS
INSERT INTO Usuario (nome, email, senha, tipo) VALUES
('Fernanda Rocha', 'fernanda@une.edu.br', '123456', 1),
('Ricardo Mendes', 'ricardo@une.edu.br', '123456', 1),
('Lucas Silva', 'lucas@aluno.edu.br', '123456', 2),
('Juliana Costa', 'juliana@aluno.edu.br', '123456', 2),
('Bruno Santos', 'bruno@aluno.edu.br', '123456', 2);

-- NOVOS DOCENTES
INSERT INTO Docente (titularidade, especialidades, idUsuario) VALUES
(1, 'Algoritmos, Lógica', 6),
(3, 'Gestão de Projetos', 7);

-- NOVOS DISCENTES
INSERT INTO Discente (matricula, ingresso, idCurso, idUsuario) VALUES
(2026004, 2026, 1, 8),
(2026005, 2026, 2, 9),
(2026006, 2026, 3, 10);

-- NOVAS TURMAS
INSERT INTO Turma (idCurso, idDisciplina, semestre, ano, idDocente) VALUES
(1, 3, 2, 2026, 3),
(2, 4, 2, 2026, 4),
(3, 2, 2, 2026, 2);

-- NOVO DISCENTE_TURMA
INSERT INTO Discente_Turma (idDiscente, idTurma) VALUES
(4, 4),
(5, 5),
(6, 6),
(4, 6);

-- NOVOS CONTRATOS
INSERT INTO Contrato (idDocente, dataInicio, dataValidade, bolsa) VALUES
(3, '2026-01-01', '2026-12-31', 4000.00),
(4, '2026-01-01', '2026-12-31', 5500.00);

--------------------------------------------------
-- NOVAS QUESTÕES
--------------------------------------------------
INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato) VALUES
('O que e um algoritmo?', 1, 3, 3),
('Explique o conceito de backlog.', 2, 4, 4),
('Qual a funcao do CSS?', 1, 2, 2);

-- OBJETIVAS
INSERT INTO QuestaoObjetiva (idQuestao, tipoObjetiva) VALUES
(4, 'MULTIPLA'),
(6, 'MULTIPLA');

-- DISCURSIVAS
INSERT INTO QuestaoDiscursiva (idQuestao, respostaEsperada) VALUES
(5, 'Lista de tarefas priorizadas em um projeto.');

-- ALTERNATIVAS
INSERT INTO Alternativa (idQuestao, descricao, correta) VALUES
(4, 'Sequencia de passos para resolver um problema.', TRUE),
(4, 'Um tipo de linguagem de programacao.', FALSE),
(6, 'Estilizar paginas web.', TRUE),
(6, 'Criar banco de dados.', FALSE);

--------------------------------------------------
-- NOVAS AVALIACOES
--------------------------------------------------
INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo) VALUES
(3, 'Prova 1 - Algoritmos', '2026-05-10 08:00:00', 1),
(4, 'Simulado - Gestão', '2026-05-12 09:00:00', 3);

-- AVALIACAO_QUESTAO
INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao) VALUES
(3, 4),
(3, 5),
(4, 6);

-- APLICACOES
INSERT INTO Aplicacao (data_aplicacao, idTurma, idAvaliacao) VALUES
('2026-05-20 19:00:00', 4, 3),
('2026-05-22 19:00:00', 5, 4);

-- RESULTADOS
INSERT INTO Resultado (idAplicacao, idDiscente, nota) VALUES
(3, 4, 6.50),
(3, 1, 7.80),
(4, 5, 8.20),
(4, 6, 5.90);