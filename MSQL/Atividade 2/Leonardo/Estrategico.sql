-- Cursos com maior diversidade de disciplinas
SELECT 
    c.nome AS curso,
    COUNT(cd.idDisciplina) AS total_disciplinas
FROM Curso c
JOIN Curso_Disciplina cd ON c.idCurso = cd.idCurso
GROUP BY c.nome
HAVING COUNT(cd.idDisciplina) > (
    SELECT AVG(qtd) 
    FROM (
        SELECT COUNT(*) AS qtd 
        FROM Curso_Disciplina 
        GROUP BY idCurso
    ) AS sub
);

-- Campi com maior desempenho médio ponderado por número de alunos
SELECT 
    campus.nome AS campus,
    AVG(resultado.nota) AS media_desempenho,
    COUNT(resultado.idDiscente) AS total_resultados
FROM Resultado resultado
JOIN Discente discente ON resultado.idDiscente = discente.idDiscente
JOIN Curso curso ON discente.idCurso = curso.idCurso
JOIN Campus campus ON curso.idCampus = campus.idCampus
GROUP BY campus.nome
HAVING COUNT(resultado.idDiscente) > (
    SELECT AVG(qtd)
    FROM (
        SELECT COUNT(*) AS qtd 
        FROM Resultado 
        GROUP BY idAplicacao
    ) sub
);