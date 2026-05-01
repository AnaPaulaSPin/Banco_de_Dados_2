   DELIMITER $$
	  CREATE PROCEDURE gerar_prova(
		 IN p_idDisciplina INT,
		 IN p_dificuldade INT,
		 IN p_qtd INT)
	   BEGIN
	   SELECT 
			idQuestao,
			enunciado,
			dificuldade
			FROM Questao
            WHERE idDisciplina = p_idDisciplina
            AND dificuldade = p_dificuldade
           ORDER BY RAND()
          LIMIT p_qtd;
         END $$
       DELIMITER ;
