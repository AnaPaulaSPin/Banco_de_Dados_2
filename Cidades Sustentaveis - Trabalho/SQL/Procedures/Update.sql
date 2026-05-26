-- =====================================================
-- PROCEDURES DE ATUALIZAÇÃO (UPDATE)
-- =====================================================

-- =====================================================
-- Atualizar status do sistema de painéis
-- =====================================================

DELIMITER //

CREATE PROCEDURE atualizar_status_sistema(
    IN idSistema INT,
    IN novoStatus ENUM('ATIVO','INATIVO','MANUTENCAO')
)
BEGIN
    UPDATE SistemaPainel
    SET status = novoStatus
    WHERE idSistemaPainel = idSistema;
END //

DELIMITER ;


-- =====================================================
-- Atualizar dados da unidade consumidora
-- =====================================================

DELIMITER //

CREATE PROCEDURE atualizar_unidade_consumidora(
    IN idUnidade INT,
    IN novoTelefone VARCHAR(20),
    IN novoEmail VARCHAR(45)
)
BEGIN
    UPDATE UnidadeConsumidora
    SET telefone = novoTelefone,
        email = novoEmail
    WHERE idUnidadeConsumidora = idUnidade;
END //

DELIMITER ;


-- =====================================================
-- Atualizar contrato (valor e status)
-- =====================================================

DELIMITER //

CREATE PROCEDURE atualizar_contrato(
    IN idContratoParam INT,
    IN novoValor FLOAT,
    IN novoStatus ENUM('ATIVO','ENCERRADO','SUSPENSO')
)
BEGIN
    UPDATE Contrato
    SET valor = novoValor,
        status = novoStatus
    WHERE idContrato = idContratoParam;
END //

DELIMITER ;


-- =====================================================
-- Atualizar último login do usuário
-- =====================================================

DELIMITER //

CREATE PROCEDURE atualizar_ultimo_login(
    IN idUser INT,
    IN dataLogin DATETIME
)
BEGIN
    UPDATE Usuario
    SET ultimoLogin = dataLogin
    WHERE idUsuario = idUser;
END //

DELIMITER ;