DELIMITER $$

CREATE TRIGGER trg_remove_questao_avaliacao
AFTER DELETE ON Avaliacao_Questao
FOR EACH ROW
BEGIN
  UPDATE Avaliacao
  SET quantidade_questoes = quantidade_questoes - 1
  WHERE idAvaliacao = OLD.idAvaliacao;
END $$

DELIMITER ;