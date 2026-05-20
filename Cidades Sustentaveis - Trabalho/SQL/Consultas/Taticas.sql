-- =====================================================
-- CONSULTA TÁTICA 1
-- Média de energia gerada por sistema de painel
-- =====================================================
SELECT 
    sp.idSistemaPainel,
    sp.capacidadeKwp,
    sp.status,
    AVG(me.energiaGeradaKwh) AS mediaEnergiaGerada
FROM SistemaPainel sp
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY sp.idSistemaPainel, sp.capacidadeKwp, sp.status
ORDER BY mediaEnergiaGerada DESC;


-- =====================================================
-- CONSULTA TÁTICA 2
-- Sistemas com geração menor que o consumo
-- =====================================================
SELECT 
    sp.idSistemaPainel,
    uc.nomeResponsavel,
    me.dataMedicao,
    me.energiaGeradaKwh,
    me.energiaConsumidaKwh
FROM SistemaPainel sp
JOIN Contrato c 
    ON sp.idSistemaPainel = c.idSistemaPainel
JOIN UnidadeConsumidora uc 
    ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
WHERE me.energiaGeradaKwh < me.energiaConsumidaKwh
ORDER BY me.dataMedicao;


-- =====================================================
-- CONSULTA TÁTICA 3
-- Quantidade de unidades consumidoras por bairro
-- =====================================================
SELECT 
    b.nome AS bairro,
    ci.nome AS cidade,
    COUNT(uc.idUnidadeConsumidora) AS quantidadeUnidades
FROM Bairro b
JOIN Cidade ci 
    ON b.idCidade = ci.idCidade
LEFT JOIN UnidadeConsumidora uc 
    ON b.idBairro = uc.idBairro
GROUP BY b.idBairro, b.nome, ci.nome
ORDER BY quantidadeUnidades DESC;


-- =====================================================
-- CONSULTA TÁTICA 4
-- Empresas instaladoras com mais sistemas vinculados
-- =====================================================
SELECT 
    ei.razaoSocial AS empresa,
    COUNT(DISTINCT c.idSistemaPainel) AS quantidadeSistemas
FROM EmpresaInstaladora ei
JOIN Contrato c 
    ON ei.idEmpresa = c.idEmpresaInstaladora
GROUP BY ei.idEmpresa, ei.razaoSocial
ORDER BY quantidadeSistemas DESC;


-- =====================================================
-- CONSULTA TÁTICA 5
-- Economia média por tipo de unidade consumidora
-- =====================================================
SELECT 
    uc.tipoUnidade,
    AVG(me.economiaEstimada) AS economiaMedia
FROM UnidadeConsumidora uc
JOIN Contrato c 
    ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp 
    ON c.idSistemaPainel = sp.idSistemaPainel
JOIN MedicaoEnergia me 
    ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY uc.tipoUnidade
ORDER BY economiaMedia DESC;