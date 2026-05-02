-- =====================================================
-- 1. CRIAR DISCIPLINA DE CSS
-- =====================================================

INSERT INTO Disciplina (nome, carga_horaria)
VALUES ('CSS', 60);

SET @idDisciplinaCSS = LAST_INSERT_ID();


-- =====================================================
-- 2. CRIAR USUÁRIO, DOCENTE E CONTRATO
-- =====================================================

INSERT INTO Usuario (nome, email, senha, tipo)
VALUES ('Professor Teste CSS', 'prof.css@email.com', '123456', 1);

SET @idUsuarioDocente = LAST_INSERT_ID();

INSERT INTO Docente (titularidade, especialidades, idUsuario)
VALUES (1, 'Desenvolvimento Web', @idUsuarioDocente);

SET @idDocenteCSS = LAST_INSERT_ID();

INSERT INTO Contrato (idDocente, dataInicio, dataValidade, bolsa)
VALUES (@idDocenteCSS, '2026-01-01', '2026-12-31', 1500.00);

SET @idContratoCSS = LAST_INSERT_ID();


-- =====================================================
-- 3. CRIAR QUESTÕES DE CSS
-- =====================================================

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES 
('O que é CSS?', 1, @idDisciplinaCSS, @idContratoCSS),
('Qual propriedade altera a cor do texto?', 1, @idDisciplinaCSS, @idContratoCSS),
('Qual propriedade define o tamanho da fonte?', 1, @idDisciplinaCSS, @idContratoCSS),
('Explique a diferença entre margin e padding.', 2, @idDisciplinaCSS, @idContratoCSS),
('O que é box model no CSS?', 2, @idDisciplinaCSS, @idContratoCSS),
('Qual a diferença entre position relative e absolute?', 2, @idDisciplinaCSS, @idContratoCSS),
('Explique especificidade em CSS.', 3, @idDisciplinaCSS, @idContratoCSS),
('Como funciona o flexbox?', 3, @idDisciplinaCSS, @idContratoCSS);


-- =====================================================
-- 4. TESTE: CADASTRO COMPLETO DE PROVA DE CSS
-- =====================================================

CALL cadastrar_prova_completa(@idDisciplinaCSS, 'Prova de CSS', 1, 2, 3);

SET @idProvaCSS = LAST_INSERT_ID();


-- =====================================================
-- 5. VISUALIZAR PROVA CRIADA
-- =====================================================

SELECT *
FROM Avaliacao
WHERE idAvaliacao = @idProvaCSS;


-- =====================================================
-- 6. VISUALIZAR QUESTÕES ASSOCIADAS À PROVA
-- =====================================================

SELECT 
  av.titulo,
  q.idQuestao,
  q.enunciado,
  q.dificuldade
FROM Avaliacao_Questao aq
JOIN Avaliacao av ON aq.idAvaliacao = av.idAvaliacao
JOIN Questao q ON aq.idQuestao = q.idQuestao
WHERE aq.idAvaliacao = @idProvaCSS;

-- =====================================================
-- 7 CRIAR ALUNOS PARA REALIZAR A PROVA DE CSS
-- =====================================================

INSERT INTO Usuario (nome, email, senha, tipo)
VALUES 
('Aluno Ana Teste', 'ana.teste@email.com', '123456', 2),
('Aluno Bruno Teste', 'bruno.teste@email.com', '123456', 2),
('Aluno Carla Teste', 'carla.teste@email.com', '123456', 2);

SET @idUsuarioAluno1 = LAST_INSERT_ID() - 2;
SET @idUsuarioAluno2 = LAST_INSERT_ID() - 1;
SET @idUsuarioAluno3 = LAST_INSERT_ID();


-- =====================================================
-- 8 CRIAR DISCENTES
-- =====================================================

INSERT INTO Discente (matricula, ingresso, idCurso, idUsuario)
VALUES 
(2027001, 2026, 1, @idUsuarioAluno1),
(2027002, 2026, 1, @idUsuarioAluno2),
(2027003, 2026, 1, @idUsuarioAluno3);

SET @idDiscente1 = LAST_INSERT_ID() - 2;
SET @idDiscente2 = LAST_INSERT_ID() - 1;
SET @idDiscente3 = LAST_INSERT_ID();


-- =====================================================
-- 9 CRIAR TURMA DE CSS
-- =====================================================

INSERT INTO Turma (idCurso, idDisciplina, semestre, ano, idDocente)
VALUES (1, @idDisciplinaCSS, 1, 2026, @idDocenteCSS);

SET @idTurmaCSS = LAST_INSERT_ID();


-- =====================================================
-- 10 MATRICULAR ALUNOS NA TURMA
-- =====================================================

INSERT INTO Discente_Turma (idDiscente, idTurma)
VALUES
(@idDiscente1, @idTurmaCSS),
(@idDiscente2, @idTurmaCSS),
(@idDiscente3, @idTurmaCSS);


-- =====================================================
-- 11 CRIAR APLICAÇÃO DA PROVA
-- =====================================================

INSERT INTO Aplicacao (data_aplicacao, idTurma, idAvaliacao)
VALUES (NOW(), @idTurmaCSS, @idProvaCSS);

SET @idAplicacaoCSS = LAST_INSERT_ID();


-- =====================================================
-- 12 REGISTRAR RESULTADOS DOS ALUNOS
-- =====================================================

INSERT INTO Resultado (idAplicacao, idDiscente, nota)
VALUES
(@idAplicacaoCSS, @idDiscente1, 8.50),
(@idAplicacaoCSS, @idDiscente2, 6.00),
(@idAplicacaoCSS, @idDiscente3, 9.00);


-- =====================================================
-- 13 VISUALIZAR RESULTADOS DA PROVA
-- =====================================================

SELECT 
  u.nome AS aluno,
  av.titulo AS avaliacao,
  d.nome AS disciplina,
  r.nota
FROM Resultado r
JOIN Discente di ON r.idDiscente = di.idDiscente
JOIN Usuario u ON di.idUsuario = u.idUsuario
JOIN Aplicacao ap ON r.idAplicacao = ap.idAplicacao
JOIN Avaliacao av ON ap.idAvaliacao = av.idAvaliacao
JOIN Disciplina d ON av.idDisciplina = d.idDisciplina
WHERE ap.idAplicacao = @idAplicacaoCSS;

-- =====================================================
-- 14 Geração de Respostas dos Alunos em questões
-- =====================================================
INSERT INTO Resposta_Aluno (idDiscente, idAvaliacao, idQuestao, acertou)
SELECT @idDiscente1, @idProvaCSS, aq.idQuestao, TRUE
FROM Avaliacao_Questao aq
WHERE aq.idAvaliacao = @idProvaCSS;

INSERT INTO Resposta_Aluno (idDiscente, idAvaliacao, idQuestao, acertou)
SELECT @idDiscente2, @idProvaCSS, aq.idQuestao, FALSE
FROM Avaliacao_Questao aq
WHERE aq.idAvaliacao = @idProvaCSS;

INSERT INTO Resposta_Aluno (idDiscente, idAvaliacao, idQuestao, acertou)
SELECT @idDiscente3, @idProvaCSS, aq.idQuestao, TRUE
FROM Avaliacao_Questao aq
WHERE aq.idAvaliacao = @idProvaCSS;

-- =====================================================
-- 15 TESTE: GERAR SIMULADO PERSONALIZADO
-- =====================================================

CALL gerar_simulado_personalizado(@idDiscente2, 5);


-- =====================================================
-- 16. TESTE: RELATÓRIO DE DESEMPENHO
-- =====================================================

CALL relatorio_desempenho_aluno_turma_disciplina();


-- =====================================================
-- 17. TESTE: RELATÓRIO TAXA DE ACERTO
-- =====================================================

CALL relatorio_taxa_acerto_questao();