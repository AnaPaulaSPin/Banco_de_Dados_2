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

-- -- O professor quer visualizar as questões que ele criou
SELECT 
  Usuario.nome AS nome_docente,
  Questao.idQuestao,
  Questao.enunciado,
  Questao.dificuldade,
  Disciplina.nome AS disciplina
FROM Questao
JOIN Contrato ON Questao.idContrato = Contrato.idContrato
JOIN Docente ON Contrato.idDocente = Docente.idDocente
JOIN Usuario ON Docente.idUsuario = Usuario.idUsuario
JOIN Disciplina ON Questao.idDisciplina = Disciplina.idDisciplina
WHERE Docente.idDocente = 1;