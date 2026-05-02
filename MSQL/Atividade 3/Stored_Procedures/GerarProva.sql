DELIMITER $$

CREATE PROCEDURE cadastrar_prova_completa(
  IN p_idDisciplina INT UNSIGNED,
  IN p_titulo VARCHAR(50),
  IN p_tipo INT,
  IN p_dificuldade INT,
  IN p_qtdQuestoes INT
)
BEGIN
  DECLARE v_idAvaliacao INT UNSIGNED;

  INSERT INTO Avaliacao (idDisciplina, titulo, data_criacao, tipo, quantidade_questoes)
  VALUES (p_idDisciplina, p_titulo, NOW(), p_tipo, 0);

  SET v_idAvaliacao = LAST_INSERT_ID();

  INSERT INTO Avaliacao_Questao (idAvaliacao, idQuestao)
  SELECT v_idAvaliacao, q.idQuestao
  FROM Questao q
  WHERE q.idDisciplina = p_idDisciplina
    AND q.dificuldade = p_dificuldade
  ORDER BY RAND()
  LIMIT p_qtdQuestoes;
END $$

DELIMITER ;