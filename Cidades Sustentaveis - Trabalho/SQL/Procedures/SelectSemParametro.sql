-- =====================================================
-- PROCEDURES (SELECT SEM PARÂMETRO)
-- Mínimo de 4 stored procedures de consulta sem parâmetros
-- =====================================================

-- =====================================================
-- 1. LISTAR TODAS AS CIDADES
-- =====================================================

DELIMITER //

CREATE PROCEDURE listar_cidades()
BEGIN
    SELECT 
        idCidade,
        nome
    FROM Cidade;
END //

DELIMITER ;


-- =====================================================
-- 2. LISTAR TODOS OS SISTEMAS DE PAINÉIS
-- =====================================================

DELIMITER //

CREATE PROCEDURE listar_sistemas_paineis()
BEGIN
    SELECT 
        idSistemaPainel,
        capacidadeKwp,
        dataInstalacao,
        vidaUtilEstimada,
        status
    FROM SistemaPainel;
END //

DELIMITER ;


-- =====================================================
-- 3. LISTAR TODAS AS EMPRESAS INSTALADORAS
-- =====================================================

DELIMITER //

CREATE PROCEDURE listar_empresas_instaladoras()
BEGIN
    SELECT 
        idEmpresa,
        razaoSocial,
        cnpj,
        email,
        logradouro,
        numeroResidencia
    FROM EmpresaInstaladora;
END //

DELIMITER ;


-- =====================================================
-- 4. LISTAR TODOS OS CONTRATOS
-- =====================================================

DELIMITER //

CREATE PROCEDURE listar_contratos()
BEGIN
    SELECT 
        idContrato,
        numero,
        dataInicio,
        dataFim,
        valor,
        status,
        idUnidadeConsumidora,
        idSistemaPainel,
        idEmpresaInstaladora
    FROM Contrato;
END //

DELIMITER ;