-- Média de dificuldade das questões por disciplina
SELECT 
    disciplina.nome AS disciplina,
    AVG(questao.dificuldade) AS media_dificuldade
FROM Questao questao
JOIN Disciplina disciplina ON questao.idDisciplina = disciplina.idDisciplina
GROUP BY disciplina.nome;
  
-- Docentes com quantidade de contratos acima da média
SELECT 
    usuario.nome,
    COUNT(contrato.idContrato) AS total_contratos
FROM Contrato contrato
JOIN Docente docente ON contrato.idDocente = docente.idDocente
JOIN Usuario usuario ON docente.idUsuario = usuario.idUsuario
GROUP BY usuario.nome
HAVING COUNT(contrato.idContrato) > (
    SELECT AVG(qtd) 
    FROM (
        SELECT COUNT(*) AS qtd 
        FROM Contrato 
        GROUP BY idDocente
    ) AS sub
);