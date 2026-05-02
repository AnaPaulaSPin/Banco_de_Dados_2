DELIMITER $$

CREATE PROCEDURE relatorio_taxa_acerto_questao()
BEGIN
  SELECT 
    q.idQuestao,
    q.enunciado,
    q.dificuldade,
    COUNT(ra.idResposta) AS total_respostas,
    SUM(CASE WHEN ra.acertou = TRUE THEN 1 ELSE 0 END) AS total_acertos,
    ROUND(
      (SUM(CASE WHEN ra.acertou = TRUE THEN 1 ELSE 0 END) / COUNT(ra.idResposta)) * 100,
      2
    ) AS taxa_acerto_percentual
  FROM Resposta_Aluno ra
  JOIN Questao q ON ra.idQuestao = q.idQuestao
  GROUP BY q.idQuestao, q.enunciado, q.dificuldade
  ORDER BY taxa_acerto_percentual ASC;
END $$

DELIMITER ;