-- =====================================================
-- FUNCTIONS
-- =====================================================

DELIMITER //

-- Função 1: Calcula o total economizado por uma Unidade Consumidora
CREATE FUNCTION fn_total_economia_unidade(p_idUnidade INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE v_total_economia FLOAT;
    
    SELECT IFNULL(SUM(me.economiaEstimada), 0) INTO v_total_economia
    FROM Contrato c
    JOIN SistemaPainel sp ON c.idSistemaPainel = sp.idSistemaPainel
    JOIN MedicaoEnergia me ON sp.idSistemaPainel = me.idSistemaPainel
    WHERE c.idUnidadeConsumidora = p_idUnidade;
    
    RETURN v_total_economia;
END //

-- Função 2: Calcula o total de CO2 evitado por uma Cidade inteira
CREATE FUNCTION fn_total_co2_evitado_cidade(p_idCidade INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE v_total_co2 FLOAT;
    
    SELECT IFNULL(SUM(me.co2EvitarKg), 0) INTO v_total_co2
    FROM Cidade ci
    JOIN Bairro b ON ci.idCidade = b.idCidade
    JOIN UnidadeConsumidora uc ON b.idBairro = uc.idBairro
    JOIN Contrato c ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
    JOIN SistemaPainel sp ON c.idSistemaPainel = sp.idSistemaPainel
    JOIN MedicaoEnergia me ON sp.idSistemaPainel = me.idSistemaPainel
    WHERE ci.idCidade = p_idCidade;
    
    RETURN v_total_co2;
END //

-- Função 3: Autossuficiência Energética do Sistema
CREATE FUNCTION fn_autossuficiencia_sistema(p_idSistema INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE v_total_gerada FLOAT;
    DECLARE v_total_consumida FLOAT;
    DECLARE v_percentual FLOAT;
    
    -- Calcula o total gerado e consumido pelo sistema com base no histórico
    SELECT 
        SUM(energiaGeradaKwh), 
        SUM(energiaConsumidaKwh) 
    INTO 
        v_total_gerada, 
        v_total_consumida
    FROM MedicaoEnergia
    WHERE idSistemaPainel = p_idSistema;
    
    -- Retorna NULL se não houver medições ou se o consumo for 0 (evita erro de divisão por zero)
    IF v_total_consumida IS NULL OR v_total_consumida = 0 THEN
        RETURN NULL;
    ELSE
        -- Calcula o percentual: (Geração / Consumo) * 100
        SET v_percentual = (v_total_gerada / v_total_consumida) * 100;
        RETURN v_percentual;
    END IF;
END //

DELIMITER ;