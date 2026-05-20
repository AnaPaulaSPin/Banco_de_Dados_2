-- =====================================================
-- CONSULTA OPERACIONAL 1
-- Listar as medições de energia de uma unidade consumidora específica
-- =====================================================
SELECT 
    uc.nomeResponsavel,
    me.dataMedicao,
    me.energiaGeradaKwh,
    me.energiaConsumidaKwh,
    me.energiaExcedenteKwh,
    me.economiaEstimada,
    me.co2EvitarKg
FROM UnidadeConsumidora uc
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
WHERE uc.idUnidadeConsumidora = 1;


-- =====================================================
-- CONSULTA OPERACIONAL 2
-- Listar os painéis solares associados a uma unidade consumidora específica
-- =====================================================
SELECT 
    uc.nomeResponsavel,
    ps.modelo,
    ps.fabricante,
    ps.potenciaWatts,
    ps.eficiencia,
    ps.status
FROM UnidadeConsumidora uc
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN PainelSolar ps 
    ON sp.idSistemaPainel = ps.idSistemaPainel
WHERE uc.idUnidadeConsumidora = 1;


-- =====================================================
-- CONSULTA OPERACIONAL 3
-- Consultar contratos ativos de uma empresa instaladora
-- =====================================================
SELECT 
    ei.razaoSocial AS empresa,
    c.numero AS numeroContrato,
    c.dataInicio,
    c.dataFim,
    c.valor,
    c.status,
    uc.nomeResponsavel AS unidadeConsumidora,
    sp.idSistemaPainel,
    sp.capacidadeKwp
FROM EmpresaInstaladora ei
JOIN Contrato c
    ON ei.idEmpresa = c.idEmpresaInstaladora
JOIN UnidadeConsumidora uc
    ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
JOIN SistemaPainel sp
    ON c.idSistemaPainel = sp.idSistemaPainel
WHERE ei.idEmpresa = 1
AND c.status = 'ATIVO';


-- =====================================================
-- CONSULTA OPERACIONAL 4
-- Listar as unidades consumidoras cadastradas em um bairro específico
-- =====================================================
SELECT 
    uc.nomeResponsavel,
    uc.tipoUnidade,
    uc.telefone,
    uc.email,
    b.nome AS bairro,
    ci.nome AS cidade
FROM UnidadeConsumidora uc
JOIN Bairro b 
    ON uc.idBairro = b.idBairro
JOIN Cidade ci 
    ON b.idCidade = ci.idCidade
WHERE b.idBairro = 1;


-- =====================================================
-- CONSULTA OPERACIONAL 5
-- Listar os painéis solares em manutenção
-- =====================================================
SELECT 
    ps.idPainelSolar,
    ps.modelo,
    ps.fabricante,
    ps.potenciaWatts,
    ps.eficiencia,
    sp.idSistemaPainel
FROM PainelSolar ps
JOIN SistemaPainel sp 
    ON ps.idSistemaPainel = sp.idSistemaPainel
WHERE ps.status = 'MANUTENCAO';