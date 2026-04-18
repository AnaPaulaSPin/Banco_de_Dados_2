use faculdade;
-- Professor quer ver as notas dos alunos de uma turma que ele leciona
SELECT 
  Usuario.nome AS nome_aluno,
  Resultado.nota,
  Turma.idTurma,
  Disciplina.nome AS disciplina
FROM Resultado
JOIN Discente ON Resultado.idDiscente = Discente.idDiscente
JOIN Usuario ON Discente.idUsuario = Usuario.idUsuario
JOIN Aplicacao ON Resultado.idAplicacao = Aplicacao.idAplicacao
JOIN Turma ON Aplicacao.idTurma = Turma.idTurma
JOIN Disciplina ON Turma.idDisciplina = Disciplina.idDisciplina
WHERE Turma.idDocente = 1;

-- O departamento quer analisar quais disciplinas cada professor está lecionando
SELECT 
  Usuario.nome AS nome_docente,
  Disciplina.nome AS disciplina,
  Curso.nome AS curso,
  Turma.semestre,
  Turma.ano
FROM Turma
JOIN Docente ON Turma.idDocente = Docente.idDocente
JOIN Usuario ON Docente.idUsuario = Usuario.idUsuario
JOIN Disciplina ON Turma.idDisciplina = Disciplina.idDisciplina
JOIN Curso ON Turma.idCurso = Curso.idCurso
ORDER BY Usuario.nome, Turma.ano, Turma.semestre;