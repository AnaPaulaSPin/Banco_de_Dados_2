DELIMITER $$

CREATE TRIGGER trg_auditoria_insert_questao
AFTER INSERT ON Questao
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (tabela_afetada, idRegistro, acao, data_acao)
  VALUES ('Questao', NEW.idQuestao, 'INSERCAO', NOW());
END $$

CREATE TRIGGER trg_auditoria_update_questao
AFTER UPDATE ON Questao
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (tabela_afetada, idRegistro, acao, data_acao)
  VALUES ('Questao', NEW.idQuestao, 'ATUALIZACAO', NOW());
END $$

CREATE TRIGGER trg_auditoria_delete_questao
BEFORE DELETE ON Questao
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (tabela_afetada, idRegistro, acao, data_acao)
  VALUES ('Questao', OLD.idQuestao, 'EXCLUSAO', NOW());
END $$

DELIMITER ;
