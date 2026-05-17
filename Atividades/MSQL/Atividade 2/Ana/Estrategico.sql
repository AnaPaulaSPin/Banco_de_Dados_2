-- O departamento quer identificar quais disciplinas possuem menor desempenho médio dos alunos
SELECT 
  Disciplina.nome AS disciplina,
  AVG(Resultado.nota) AS media_notas
FROM Resultado
JOIN Aplicacao ON Resultado.idAplicacao = Aplicacao.idAplicacao
JOIN Turma ON Aplicacao.idTurma = Turma.idTurma
JOIN Disciplina ON Turma.idDisciplina = Disciplina.idDisciplina
GROUP BY Disciplina.nome
ORDER BY media_notas ASC;

-- O departamento quer analisar a quantidade de questões produzidas por contrato e docente
SELECT 
  Usuario.nome AS nome_docente,
  Contrato.idContrato,
  COUNT(Questao.idQuestao) AS quantidade_questoes
FROM Contrato
JOIN Docente ON Contrato.idDocente = Docente.idDocente
JOIN Usuario ON Docente.idUsuario = Usuario.idUsuario
LEFT JOIN Questao ON Contrato.idContrato = Questao.idContrato
GROUP BY Usuario.nome, Contrato.idContrato
ORDER BY quantidade_questoes DESC;