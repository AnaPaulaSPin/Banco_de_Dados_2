DELIMITER $$

CREATE PROCEDURE gerar_simulado_personalizado(
  IN p_idDiscente INT,
  IN p_qtdQuestoes INT
)
BEGIN
  SELECT 
    q.idQuestao,
    q.enunciado,
    q.dificuldade,
    d.nome AS disciplina
  FROM Resultado r
  JOIN Aplicacao a ON r.idAplicacao = a.idAplicacao
  JOIN Avaliacao av ON a.idAvaliacao = av.idAvaliacao
  JOIN Disciplina d ON av.idDisciplina = d.idDisciplina
  JOIN Questao q ON q.idDisciplina = d.idDisciplina
  WHERE r.idDiscente = p_idDiscente
    AND r.nota < 7
  ORDER BY RAND()
  LIMIT p_qtdQuestoes;
END $$

DELIMITER ;