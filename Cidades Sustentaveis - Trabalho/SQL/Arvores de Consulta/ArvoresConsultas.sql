use sistemaenergiasolar;
-- =====================================================
-- ÁRVORE DE CONSULTA 1
-- Consulta utilizando o índice idx_medicao_sistema
-- =====================================================

EXPLAIN
SELECT 
    uc.nomeResponsavel,
    me.dataMedicao,
    me.energiaGeradaKwh,
    me.energiaConsumidaKwh,
    me.energiaExcedenteKwh
FROM UnidadeConsumidora uc
JOIN Contrato c
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN MedicaoEnergia me
    ON sp.idSistemaPainel = me.idSistemaPainel
WHERE uc.idUnidadeConsumidora = 1;


-- =====================================================
-- ÁRVORE DE CONSULTA 2
-- Consulta utilizando o índice idx_contrato_empresa
-- =====================================================

EXPLAIN
SELECT 
    ei.razaoSocial,
    c.numero,
    c.dataInicio,
    c.dataFim,
    c.valor,
    c.status
FROM EmpresaInstaladora ei
JOIN Contrato c
    ON ei.idEmpresa = c.idEmpresaInstaladora
WHERE ei.idEmpresa = 1
AND c.status = 'ATIVO';