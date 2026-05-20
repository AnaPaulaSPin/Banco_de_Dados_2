-- =====================================================
-- ÍNDICES EM BAIRRO
-- =====================================================
CREATE INDEX idx_bairro_cidade
ON Bairro(idCidade);

-- =====================================================
-- ÍNDICES EM PAINEL SOLAR
-- =====================================================
CREATE INDEX idx_painel_sistema
ON PainelSolar(idSistemaPainel);

CREATE INDEX idx_painel_status
ON PainelSolar(status);

-- =====================================================
-- ÍNDICES EM UNIDADE CONSUMIDORA
-- =====================================================
CREATE INDEX idx_unidade_bairro
ON UnidadeConsumidora(idBairro);

CREATE INDEX idx_unidade_tipo
ON UnidadeConsumidora(tipoUnidade);

-- =====================================================
-- ÍNDICES EM MEDIÇÃO DE ENERGIA
-- =====================================================
CREATE INDEX idx_medicao_sistema
ON MedicaoEnergia(idSistemaPainel);

CREATE INDEX idx_medicao_data
ON MedicaoEnergia(dataMedicao);

-- =====================================================
-- ÍNDICES EM SISTEMA DE PAINEL
-- =====================================================
CREATE INDEX idx_sistema_status
ON SistemaPainel(status);

-- =====================================================
-- ÍNDICES EM CONTRATO
-- =====================================================
CREATE INDEX idx_contrato_unidade
ON Contrato(idUnidadeConsumidora);

CREATE INDEX idx_contrato_sistema
ON Contrato(idSistemaPainel);

CREATE INDEX idx_contrato_empresa
ON Contrato(idEmpresaInstaladora);

CREATE INDEX idx_contrato_status
ON Contrato(status);
