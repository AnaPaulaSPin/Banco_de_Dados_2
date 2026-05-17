DELIMITER $$

CREATE PROCEDURE relatorio_desempenho_aluno_turma_disciplina()
BEGIN
  SELECT 
    u.nome AS aluno,
    t.idTurma,
    d.nome AS disciplina,
    r.nota
  FROM Resultado r
  JOIN Discente di ON r.idDiscente = di.idDiscente
  JOIN Usuario u ON di.idUsuario = u.idUsuario
  JOIN Aplicacao a ON r.idAplicacao = a.idAplicacao
  JOIN Turma t ON a.idTurma = t.idTurma
  JOIN Disciplina d ON t.idDisciplina = d.idDisciplina
  ORDER BY d.nome, t.idTurma, u.nome;
END $$

DELIMITER ;