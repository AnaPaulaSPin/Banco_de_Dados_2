-- =====================================================
-- PROCEDURES (SELECT COM PARÂMETRO)
-- =====================================================

-- =====================================================
-- PROCEDURE 1
-- Buscar medições por sistema de painel
-- =====================================================

DELIMITER //

CREATE PROCEDURE buscar_medicoes_por_sistema(IN idSistema INT)
BEGIN
    SELECT 
        idMedicaoEnergia,
        dataMedicao,
        energiaGeradaKwh,
        energiaConsumidaKwh,
        energiaExcedenteKwh,
        economiaEstimada,
        co2EvitarKg
    FROM MedicaoEnergia
    WHERE idSistemaPainel = idSistema;
END //

DELIMITER ;

-- =====================================================
-- PROCEDURE 2
-- Buscar contratos por empresa instaladora
-- =====================================================

DELIMITER //

CREATE PROCEDURE buscar_contratos_por_empresa(IN idEmp INT)
BEGIN
    SELECT 
        idContrato,
        numero,
        dataInicio,
        dataFim,
        valor,
        status,
        idUnidadeConsumidora,
        idSistemaPainel
    FROM Contrato
    WHERE idEmpresaInstaladora = idEmp;
END //

DELIMITER ;

-- =====================================================
-- PROCEDURE 3
-- Buscar unidades consumidoras por bairro
-- =====================================================

DELIMITER //

CREATE PROCEDURE buscar_unidades_por_bairro(IN idBairroParam INT)
BEGIN
    SELECT 
        idUnidadeConsumidora,
        nomeResponsavel,
        tipoUnidade,
        logradouro,
        numeroResidencia,
        telefone,
        email,
        dataCadastro
    FROM UnidadeConsumidora
    WHERE idBairro = idBairroParam;
END //

DELIMITER ;

-- =====================================================
-- PROCEDURE 4
-- Buscar painéis solares por sistema
-- =====================================================

DELIMITER //

CREATE PROCEDURE buscar_paineis_por_sistema(IN idSistema INT)
BEGIN
    SELECT 
        idPainelSolar,
        modelo,
        fabricante,
        potenciaWatts,
        eficiencia,
        dataFabricacao,
        status
    FROM PainelSolar
    WHERE idSistemaPainel = idSistema;
END //

DELIMITER ;