-- =====================================================
-- TESTES DE TRIGGER: AUDITORIA
-- =====================================================

SELECT * FROM Auditoria;


-- =====================================================
-- TESTE COM TABELA: QUESTAO
-- =====================================================

-- INSERT
INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questão teste de auditoria', 2, 1, 1);

SET @idQuestaoTeste = LAST_INSERT_ID();

SELECT * FROM Auditoria;

-- UPDATE usando chave primária
UPDATE Questao
SET enunciado = 'Questão teste atualizada'
WHERE idQuestao = @idQuestaoTeste;

SELECT * FROM Auditoria;

-- DELETE usando chave primária
DELETE FROM Questao
WHERE idQuestao = @idQuestaoTeste;

SELECT * FROM Auditoria;


-- =====================================================
-- TESTE COM TABELA: AVALIACAO
-- =====================================================

-- INSERT
INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo)
VALUES (1, 'Avaliação teste auditoria', NOW(), 1);

SET @idAvaliacaoTeste = LAST_INSERT_ID();

SELECT * FROM Auditoria;

-- UPDATE usando chave primária
UPDATE Avaliacao
SET titulo = 'Avaliação teste atualizada'
WHERE idAvaliacao = @idAvaliacaoTeste;

SELECT * FROM Auditoria;

-- DELETE usando chave primária
DELETE FROM Avaliacao
WHERE idAvaliacao = @idAvaliacaoTeste;

SELECT * FROM Auditoria;