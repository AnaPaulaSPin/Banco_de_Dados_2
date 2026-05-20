-- =====================================================
-- CONSULTA ESTRATÉGICA 1
-- Identificar os bairros com maior geração total de energia solar
-- =====================================================

SELECT 
    b.nome AS bairro,
    ci.nome AS cidade,
    SUM(me.energiaGeradaKwh) AS totalEnergiaGerada
FROM Bairro b
JOIN Cidade ci 
    ON b.idCidade = ci.idCidade
JOIN UnidadeConsumidora uc 
    ON b.idBairro = uc.idBairro
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY b.idBairro, b.nome, ci.nome
ORDER BY totalEnergiaGerada DESC;


-- =====================================================
-- CONSULTA ESTRATÉGICA 2
-- Comparar a geração total de energia entre cidades cadastradas
-- =====================================================

SELECT 
    ci.nome AS cidade,
    SUM(me.energiaGeradaKwh) AS totalEnergiaGerada
FROM Cidade ci
JOIN Bairro b 
    ON ci.idCidade = b.idCidade
JOIN UnidadeConsumidora uc 
    ON b.idBairro = uc.idBairro
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY ci.idCidade, ci.nome
ORDER BY totalEnergiaGerada DESC;


-- =====================================================
-- CONSULTA ESTRATÉGICA 3
-- Calcular a economia financeira total gerada pelos sistemas solares
-- =====================================================

SELECT 
    SUM(me.economiaEstimada) AS economiaTotal
FROM MedicaoEnergia me;


-- =====================================================
-- CONSULTA ESTRATÉGICA 4
-- Estimar a redução total de emissão de CO2 proporcionada pelos sistemas
-- =====================================================

SELECT 
    SUM(me.co2EvitarKg) AS totalCo2EvitadoKg
FROM MedicaoEnergia me;


-- =====================================================
-- CONSULTA ESTRATÉGICA 5
-- Comparar os tipos de unidades consumidoras com maior adoção de energia solar
-- =====================================================

SELECT 
    uc.tipoUnidade,
    COUNT(DISTINCT uc.idUnidadeConsumidora) AS quantidadeUnidades,
    COUNT(DISTINCT sp.idSistemaPainel) AS quantidadeSistemas
FROM UnidadeConsumidora uc
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
GROUP BY uc.tipoUnidade
ORDER BY quantidadeSistemas DESC;