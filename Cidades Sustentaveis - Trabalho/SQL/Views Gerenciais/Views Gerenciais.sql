-- =====================================================
-- VIEWS GERENCIAIS
-- =====================================================

-- View 1: Resumo do impacto ambiental e econômico por Cidade e Bairro
CREATE OR REPLACE VIEW vw_impacto_ambiental_economico AS
SELECT 
    ci.nome AS cidade,
    b.nome AS bairro,
    COUNT(DISTINCT uc.idUnidadeConsumidora) AS total_unidades,
    SUM(me.energiaGeradaKwh) AS energia_total_gerada,
    SUM(me.economiaEstimada) AS economia_total_estimada,
    SUM(me.co2EvitarKg) AS co2_total_evitado
FROM Cidade ci
JOIN Bairro b ON ci.idCidade = b.idCidade
LEFT JOIN UnidadeConsumidora uc ON b.idBairro = uc.idBairro
LEFT JOIN Contrato c ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
LEFT JOIN SistemaPainel sp ON c.idSistemaPainel = sp.idSistemaPainel
LEFT JOIN MedicaoEnergia me ON sp.idSistemaPainel = me.idSistemaPainel
GROUP BY ci.idCidade, ci.nome, b.idBairro, b.nome;

-- View 2: Desempenho e volume de contratos das Empresas Instaladoras
CREATE OR REPLACE VIEW vw_status_contratos_empresas AS
SELECT 
    ei.razaoSocial AS empresa,
    ei.cnpj,
    COUNT(c.idContrato) AS total_contratos_ativos,
    SUM(c.valor) AS valor_total_contratado
FROM EmpresaInstaladora ei
JOIN Contrato c ON ei.idEmpresa = c.idEmpresaInstaladora
WHERE c.status = 'ATIVO'
GROUP BY ei.idEmpresa, ei.razaoSocial, ei.cnpj;

-- View 3: Monitoramento de ativos em manutenção
CREATE OR REPLACE VIEW vw_alerta_manutencao_sistemas AS
SELECT 
    uc.nomeResponsavel AS cliente,
    uc.telefone,
    ei.razaoSocial AS empresa_responsavel,
    sp.idSistemaPainel,
    ps.idPainelSolar,
    ps.modelo,
    ps.status AS status_painel,
    sp.status AS status_sistema
FROM UnidadeConsumidora uc
JOIN Contrato c ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
JOIN SistemaPainel sp ON c.idSistemaPainel = sp.idSistemaPainel
JOIN EmpresaInstaladora ei ON c.idEmpresaInstaladora = ei.idEmpresa
LEFT JOIN PainelSolar ps ON sp.idSistemaPainel = ps.idSistemaPainel
WHERE ps.status = 'MANUTENCAO' OR sp.status = 'MANUTENCAO';