-- Ver auditoria antes
SELECT * FROM Auditoria;

INSERT INTO Questao (enunciado, dificuldade, idDisciplina, idContrato)
VALUES ('Questão teste de auditoria', 2, 1, 1);

SELECT * FROM Auditoria;

UPDATE Questao
SET enunciado = 'Questão teste atualizada'
WHERE enunciado = 'Questão teste de auditoria';

SELECT * FROM Auditoria;

DELETE FROM Questao
WHERE enunciado = 'Questão teste atualizada';

SELECT * FROM Auditoria;

INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo)
VALUES (1, 'Avaliação teste auditoria', NOW(), 1);

SELECT * FROM Auditoria;

UPDATE Avaliacao
SET titulo = 'Avaliação teste atualizada'
WHERE titulo = 'Avaliação teste auditoria';

SELECT * FROM Auditoria;

DELETE FROM Avaliacao
WHERE titulo = 'Avaliação teste atualizada';

SELECT * FROM Auditoria;