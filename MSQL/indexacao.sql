-- Índices Estratégicos 
CREATE INDEX idx_nota
On Resultado(nota);

CREATE INDEX idx_curso_turma
On Turma(idcurso, idturma);


-- Consultas

Explain
Select * From resultado Where nota = 7;

SET profiling = 1;
Select * From resultado Where nota = 7;
SHOW PROFILES; 

Explain
SELECT av.titulo, t.idTurma, c.nome AS curso
FROM Aplicacao a
JOIN Turma t ON a.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Avaliacao av ON a.idAvaliacao = av.idAvaliacao
WHERE t.idCurso = 1 AND t.idTurma = 2;

SET profiling = 1;
SELECT av.titulo, t.idTurma, c.nome AS curso
FROM Aplicacao a
JOIN Turma t ON a.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Avaliacao av ON a.idAvaliacao = av.idAvaliacao
WHERE t.idCurso = 1 AND t.idTurma = 2;
SHOW PROFILES; 


