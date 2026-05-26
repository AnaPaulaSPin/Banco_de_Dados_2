-- =====================================================
-- PROCEDURES DE EXCLUSÃO lÓGICA
-- =====================================================


-- INATIVAR 1 SISTEMAPAINEL
DELIMITER //
CREATE PROCEDURE inativar_sistemaPainel(IN ex_id INT)
BEGIN
    UPDATE sistemaPainel
    SET status = 'INATIVO'
    WHERE idSistemaPainel = ex_id;
END //
DELIMITER ;

-- EXCLUIR 1 CONTRATO
DELIMITER //
CREATE PROCEDURE excluir_contrato(IN ex_id INT)
BEGIN
    UPDATE contrato
    SET status = 'ENCERRADO'
    WHERE idcontrato = ex_id;
END //
DELIMITER ;

-- EXCLUIR 1 PAINELSOLAR
DELIMITER //
CREATE PROCEDURE inativar_painel_solar(IN ex_id INT)
BEGIN
    UPDATE painelSolar
    SET status = 'INATIVO'
    WHERE idPainelSolar = ex_id;
END //
DELIMITER ;

-- EXCLUIR 1 USUARIO
DELIMITER //
CREATE PROCEDURE inativar_usuario(IN ex_id INT)
BEGIN
    UPDATE usuario
    SET status = 'INATIVO'
    WHERE idUsuario = ex_id;
END //
DELIMITER ;