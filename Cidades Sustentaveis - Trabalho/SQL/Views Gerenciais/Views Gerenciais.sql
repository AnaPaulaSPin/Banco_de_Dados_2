-- =====================================================
-- VIEWS GERENCIAIS
-- =====================================================
 
-- ---------------------------------------------------
-- View 1
-- Desempenho consolidado de cada sistema de painéis:
-- totais de geração, consumo, economia, CO₂ e o
-- percentual de autossuficiência via function.
-- Destinada a dashboards e integrações externas.
-- ---------------------------------------------------
CREATE OR REPLACE VIEW vw_desempenho_sistemas AS
SELECT
    sp.idSistemaPainel,
    sp.capacidadeKwp,
    sp.status                                             AS status_sistema,
    sp.dataInstalacao,
    COUNT(me.idMedicaoEnergia)                            AS total_medicoes,
    ROUND(SUM(me.energiaGeradaKwh),    2)                 AS energia_gerada_kwh,
    ROUND(SUM(me.energiaConsumidaKwh), 2)                 AS energia_consumida_kwh,
    ROUND(SUM(me.energiaExcedenteKwh), 2)                 AS energia_excedente_kwh,
    ROUND(SUM(me.economiaEstimada),    2)                 AS economia_total_r$,
    ROUND(SUM(me.co2EvitarKg),         2)                 AS co2_evitado_kg,
    fn_autossuficiencia_sistema(sp.idSistemaPainel)       AS autossuficiencia_pct
FROM SistemaPainel sp
LEFT JOIN MedicaoEnergia me ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY
    sp.idSistemaPainel, sp.capacidadeKwp,
    sp.status, sp.dataInstalacao;
 
 
-- ---------------------------------------------------
-- View 2
-- Contratos ativos com dados completos: unidade
-- consumidora, localização, empresa e indicadores
-- financeiros calculados pela function.
-- Destinada a relatórios de gestão e APIs externas.
-- ---------------------------------------------------
CREATE OR REPLACE VIEW vw_contratos_ativos AS
SELECT
    c.idContrato,
    c.numero                                              AS numero_contrato,
    c.dataInicio,
    c.dataFim,
    c.valor                                               AS valor_contrato_r$,
    c.observacao,
    uc.nomeResponsavel,
    uc.tipoUnidade,
    uc.telefone,
    uc.email                                              AS email_unidade,
    b.nome                                                AS bairro,
    ci.nome                                               AS cidade,
    sp.idSistemaPainel,
    sp.capacidadeKwp,
    sp.status                                             AS status_sistema,
    ei.razaoSocial                                        AS empresa_instaladora,
    ei.email                                              AS email_empresa,
    fn_economia_unidade(uc.idUnidadeConsumidora)          AS economia_acumulada_r$
FROM Contrato c
JOIN UnidadeConsumidora uc ON c.idUnidadeConsumidora  = uc.idUnidadeConsumidora
JOIN Bairro              b  ON uc.idBairro             = b.idBairro
JOIN Cidade              ci ON b.idCidade              = ci.idCidade
JOIN SistemaPainel       sp ON c.idSistemaPainel       = sp.idSistemaPainel
JOIN EmpresaInstaladora  ei ON c.idEmpresaInstaladora  = ei.idEmpresa
WHERE c.status = 'ATIVO';
 
 
-- ---------------------------------------------------
-- View 3
-- Impacto ambiental e econômico agrupado por cidade:
-- quantidade de sistemas, geração total, economia
-- e CO₂ evitado (em kg e toneladas).
-- Destinada a relatórios de sustentabilidade (ODS).
-- ---------------------------------------------------
CREATE OR REPLACE VIEW vw_impacto_por_cidade AS
SELECT
    ci.idCidade,
    ci.nome                                               AS cidade,
    COUNT(DISTINCT uc.idUnidadeConsumidora)               AS total_unidades,
    COUNT(DISTINCT sp.idSistemaPainel)                    AS total_sistemas,
    ROUND(SUM(me.energiaGeradaKwh),    2)                 AS energia_gerada_kwh,
    ROUND(SUM(me.economiaEstimada),    2)                 AS economia_total_r$,
    ROUND(SUM(me.co2EvitarKg),         2)                 AS co2_evitado_kg,
    ROUND(SUM(me.co2EvitarKg) / 1000,  3)                 AS co2_evitado_ton,
    fn_co2_evitado_cidade(ci.idCidade)                    AS co2_via_function_kg
FROM Cidade ci
JOIN Bairro             b  ON ci.idCidade             = b.idCidade
JOIN UnidadeConsumidora uc ON b.idBairro              = uc.idBairro
JOIN Contrato           c  ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel      sp ON c.idSistemaPainel       = sp.idSistemaPainel
LEFT JOIN MedicaoEnergia me ON sp.idSistemaPainel     = me.idSistemaPainel
GROUP BY ci.idCidade, ci.nome
ORDER BY energia_gerada_kwh DESC;
 
 
-- ---------------------------------------------------
-- View 4
-- Painel de alertas: painéis e sistemas em manutenção
-- com localização completa e empresa responsável.
-- Destinada a equipes de campo e sistemas de O&M.
-- ---------------------------------------------------
CREATE OR REPLACE VIEW vw_alertas_manutencao AS
SELECT
    ps.idPainelSolar,
    ps.modelo,
    ps.fabricante,
    ps.potenciaWatts,
    ps.status                                             AS status_painel,
    sp.idSistemaPainel,
    sp.status                                             AS status_sistema,
    uc.nomeResponsavel,
    uc.telefone,
    b.nome                                                AS bairro,
    ci.nome                                               AS cidade,
    ei.razaoSocial                                        AS empresa_responsavel,
    ei.email                                              AS email_empresa
FROM PainelSolar         ps
JOIN SistemaPainel       sp ON ps.idSistemaPainel        = sp.idSistemaPainel
JOIN Contrato            c  ON sp.idSistemaPainel        = c.idSistemaPainel
JOIN UnidadeConsumidora  uc ON c.idUnidadeConsumidora    = uc.idUnidadeConsumidora
JOIN Bairro              b  ON uc.idBairro               = b.idBairro
JOIN Cidade              ci ON b.idCidade                = ci.idCidade
JOIN EmpresaInstaladora  ei ON c.idEmpresaInstaladora    = ei.idEmpresa
WHERE ps.status = 'MANUTENCAO'
   OR sp.status = 'MANUTENCAO';