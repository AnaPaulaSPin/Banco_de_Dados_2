use faculdade;

-- O departamento quer analisar a média dos alunos por disciplina, turma e período
SELECT 
  Disciplina.nome AS disciplina,
  Turma.idTurma,
  Turma.semestre,
  Turma.ano,
  AVG(Resultado.nota) AS media_notas
FROM Resultado
JOIN Aplicacao ON Resultado.idAplicacao = Aplicacao.idAplicacao
JOIN Turma ON Aplicacao.idTurma = Turma.idTurma
JOIN Disciplina ON Turma.idDisciplina = Disciplina.idDisciplina
GROUP BY 
  Disciplina.nome,
  Turma.idTurma,
  Turma.semestre,
  Turma.ano
ORDER BY 
  Turma.ano,
  Turma.semestre,
  Disciplina.nome;
  
-- O departamento quer analisar quantas questões existem por curso
SELECT 
  Curso.nome AS curso,
  COUNT(Questao.idQuestao) AS quantidade_questoes
FROM Questao
JOIN Disciplina ON Questao.idDisciplina = Disciplina.idDisciplina
JOIN Curso_Disciplina ON Disciplina.idDisciplina = Curso_Disciplina.idDisciplina
JOIN Curso ON Curso_Disciplina.idCurso = Curso.idCurso
GROUP BY Curso.nome
ORDER BY quantidade_questoes DESC;