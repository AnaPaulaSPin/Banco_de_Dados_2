DELIMITER $$ 
             CREATE TRIGGER trg_impede_delete
             BEFORE DELETE ON Disciplina
             FOR EACH ROW 
             BEGIN 
                      IF EXISTS(SELECT 1 FROM Curso_Disciplina WHERE idDisciplina = OLD.idDisciplina ) THEN
                      SIGNAL SQLSTATE '45000'
                      SET MESSAGE_TEXT = 'Não pode excluir, disciplina pertence a um curso';
                    END IF;
                    END $$ 
DELIMITER ;