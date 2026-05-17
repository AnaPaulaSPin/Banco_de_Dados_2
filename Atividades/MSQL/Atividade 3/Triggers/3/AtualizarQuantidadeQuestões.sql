ALTER TABLE Avaliacao
ADD quantidade_questoes INT DEFAULT 0;

DELIMITER $$

CREATE TRIGGER trg_add_questao_avaliacao
AFTER INSERT ON Avaliacao_Questao
FOR EACH ROW
BEGIN
  UPDATE Avaliacao
  SET quantidade_questoes = quantidade_questoes + 1
  WHERE idAvaliacao = NEW.idAvaliacao;
END $$

DELIMITER ;

