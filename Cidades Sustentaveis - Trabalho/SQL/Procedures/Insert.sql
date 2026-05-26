-- =====================================================
-- PROCEDURES DE INSERT
-- =====================================================

-- -----------------------------------------------------
-- Inserir Cidade
-- -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE inserir_cidade(IN nomeCidade VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Cidade (nome)
    VALUES (nomeCidade);

    COMMIT;
END //

DELIMITER ;


-- -----------------------------------------------------
-- Inserir Empresa Instaladora
-- -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE inserir_empresa_instaladora(
    IN razao VARCHAR(250),
    IN cnpjEmpresa VARCHAR(14),
    IN emailEmpresa VARCHAR(100),
    IN logradouroEmpresa VARCHAR(45),
    IN numeroEmpresa VARCHAR(5)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO EmpresaInstaladora 
    (razaoSocial, cnpj, email, logradouro, numeroResidencia)
    VALUES 
    (razao, cnpjEmpresa, emailEmpresa, logradouroEmpresa, numeroEmpresa);

    COMMIT;
END //

DELIMITER ;


-- -----------------------------------------------------
-- Inserir Sistema de Painéis
-- -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE inserir_sistema_painel(
    IN capacidade FLOAT,
    IN dataInst DATETIME,
    IN vidaUtil INT,
    IN statusSistema VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO SistemaPainel 
    (capacidadeKwp, dataInstalacao, vidaUtilEstimada, status)
    VALUES 
    (capacidade, dataInst, vidaUtil, statusSistema);

    COMMIT;
END //

DELIMITER ;


-- -----------------------------------------------------
-- Inserir Unidade Consumidora
-- -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE inserir_unidade_consumidora(
    IN nomeResp VARCHAR(100),
    IN tipo VARCHAR(20),
    IN logradouro VARCHAR(45),
    IN numero VARCHAR(5),
    IN telefone VARCHAR(20),
    IN email VARCHAR(45),
    IN dataCad DATE,
    IN idBairro INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO UnidadeConsumidora
    (nomeResponsavel, tipoUnidade, logradouro, numeroResidencia, telefone, email, dataCadastro, idBairro)
    VALUES
    (nomeResp, tipo, logradouro, numero, telefone, email, dataCad, idBairro);

    COMMIT;
END //

DELIMITER ;