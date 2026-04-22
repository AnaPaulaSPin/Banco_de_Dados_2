-- Ver disciplinas que ainda NÃO possuem avaliação cadastrada
SELECT 
    nome AS disciplina
FROM Disciplina
WHERE idDisciplina NOT IN (
    SELECT idDisciplina FROM Avaliacao
);

-- Ver quais avaliações foram aplicadas em uma turma com quantidade de participantes
SELECT 
    turma.idTurma,
    disciplina.nome AS disciplina,
    avaliacao.titulo,
    aplicacao.data_aplicacao,
    COUNT(resultado.idDiscente) AS total_participantes
FROM Aplicacao aplicacao
JOIN Turma turma ON aplicacao.idTurma = turma.idTurma
JOIN Avaliacao avaliacao ON aplicacao.idAvaliacao = avaliacao.idAvaliacao
JOIN Disciplina disciplina ON avaliacao.idDisciplina = disciplina.idDisciplina
LEFT JOIN Resultado resultado ON resultado.idAplicacao = aplicacao.idAplicacao
GROUP BY turma.idTurma, avaliacao.titulo, aplicacao.data_aplicacao;