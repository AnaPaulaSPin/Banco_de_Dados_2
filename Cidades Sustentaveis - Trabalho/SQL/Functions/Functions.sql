-- =====================================================
-- FUNCTIONS
-- =====================================================
 
DELIMITER //
 
-- ---------------------------------------------------
-- Função 1
-- Retorna a economia financeira total acumulada (R$)
-- de uma unidade consumidora com base em todas as
-- medições do sistema vinculado ao seu contrato.
-- ---------------------------------------------------
CREATE FUNCTION fn_economia_unidade(p_idUnidade INT)
RETURNS FLOAT
READS SQL DATA
COMMENT 'Economia financeira total acumulada de uma unidade consumidora (R$)'
BEGIN
    DECLARE v_resultado FLOAT DEFAULT 0;
 
    SELECT IFNULL(SUM(me.economiaEstimada), 0)
    INTO   v_resultado
    FROM   Contrato c
    JOIN   SistemaPainel  sp ON c.idSistemaPainel  = sp.idSistemaPainel
    JOIN   MedicaoEnergia me ON sp.idSistemaPainel = me.idSistemaPainel
    WHERE  c.idUnidadeConsumidora = p_idUnidade;
 
    RETURN v_resultado;
END //
 
 
-- ---------------------------------------------------
-- Função 2
-- Retorna o total de CO₂ evitado (kg) por uma cidade
-- inteira, somando todas as medições de todos os
-- sistemas instalados nos bairros da cidade.
-- ---------------------------------------------------
CREATE FUNCTION fn_co2_evitado_cidade(p_idCidade INT)
RETURNS FLOAT
READS SQL DATA
COMMENT 'Total de CO2 evitado (kg) por uma cidade inteira'
BEGIN
    DECLARE v_resultado FLOAT DEFAULT 0;
 
    SELECT IFNULL(SUM(me.co2EvitarKg), 0)
    INTO   v_resultado
    FROM   Cidade            ci
    JOIN   Bairro             b  ON ci.idCidade             = b.idCidade
    JOIN   UnidadeConsumidora uc ON b.idBairro               = uc.idBairro
    JOIN   Contrato           c  ON uc.idUnidadeConsumidora  = c.idUnidadeConsumidora
    JOIN   SistemaPainel      sp ON c.idSistemaPainel        = sp.idSistemaPainel
    JOIN   MedicaoEnergia     me ON sp.idSistemaPainel       = me.idSistemaPainel
    WHERE  ci.idCidade = p_idCidade;
 
    RETURN v_resultado;
END //
 
 
-- ---------------------------------------------------
-- Função 3
-- Retorna o percentual de autossuficiência energética
-- de um sistema: (total gerado / total consumido) * 100.
-- Sistemas acima de 100% são excedentários.
-- Retorna NULL se não houver medições ou consumo = 0.
-- ---------------------------------------------------
CREATE FUNCTION fn_autossuficiencia_sistema(p_idSistema INT)
RETURNS FLOAT
READS SQL DATA
COMMENT 'Percentual de autossuficiencia energetica de um sistema (%)'
BEGIN
    DECLARE v_gerada    FLOAT DEFAULT 0;
    DECLARE v_consumida FLOAT DEFAULT 0;
 
    SELECT IFNULL(SUM(energiaGeradaKwh), 0),
           IFNULL(SUM(energiaConsumidaKwh), 0)
    INTO   v_gerada, v_consumida
    FROM   MedicaoEnergia
    WHERE  idSistemaPainel = p_idSistema;
 
    IF v_consumida = 0 THEN
        RETURN NULL;
    END IF;
 
    RETURN ROUND((v_gerada / v_consumida) * 100, 2);
END //
 
DELIMITER ;