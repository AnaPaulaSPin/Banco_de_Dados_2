SELECT * FROM Avaliacao;

INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo, quantidade_questoes)
VALUES (1, 'Teste Quantidade', NOW(), 1, 0);

SET @idAvaliacaoTeste = LAST_INSERT_ID();

SELECT * FROM Avaliacao WHERE idAvaliacao = @idAvaliacaoTeste;

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questao teste qtd', 2, 1, 1);

SET @idQuestaoTeste = LAST_INSERT_ID();

INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao)
VALUES (@idAvaliacaoTeste, @idQuestaoTeste);


SELECT * FROM Avaliacao WHERE idAvaliacao = @idAvaliacaoTeste;

DELETE FROM Avaliacao_Questao
WHERE idAvaliacao = @idAvaliacaoTeste AND idQuestao = @idQuestaoTeste;

SELECT * FROM Avaliacao WHERE idAvaliacao = @idAvaliacaoTeste;

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questao teste qtd 2', 2, 1, 1);

SET @idQ2 = LAST_INSERT_ID();

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questao teste qtd 3', 2, 1, 1);

SET @idQ3 = LAST_INSERT_ID();

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questao teste qtd 4', 2, 1, 1);

SET @idQ4 = LAST_INSERT_ID();

INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao)
VALUES (@idAvaliacaoTeste, @idQ2);

INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao)
VALUES (@idAvaliacaoTeste, @idQ3);

INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao)
VALUES (@idAvaliacaoTeste, @idQ4);

SELECT * FROM Avaliacao WHERE idAvaliacao = @idAvaliacaoTeste;