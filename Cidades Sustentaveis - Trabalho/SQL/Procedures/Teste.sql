-- =====================================================
-- TESTE DAS PROCEDURES - SISTEMA ENERGIA SOLAR
-- =====================================================

USE SistemaEnergiaSolar;

-- =====================================================
-- TESTE: PROCEDURES SELECT SEM PARÂMETRO
-- =====================================================

CALL listar_cidades();
CALL listar_sistemas_paineis();
CALL listar_empresas_instaladoras();
CALL listar_contratos();


-- =====================================================
-- TESTE: PROCEDURES SELECT COM PARÂMETRO
-- =====================================================

-- Medições por sistema
CALL buscar_medicoes_por_sistema(1);

-- Contratos por empresa instaladora
CALL buscar_contratos_por_empresa(1);

-- Unidades por bairro
CALL buscar_unidades_por_bairro(1);

-- Painéis por sistema
CALL buscar_paineis_por_sistema(1);


-- =====================================================
-- TESTE: PROCEDURES INSERT
-- =====================================================

CALL inserir_cidade('Nazaré');

CALL inserir_empresa_instaladora(
    'Solar Bahia LTDA',
    '12345678000199',
    'contato@solarbahia.com',
    'Rua Central',
    '100'
);

CALL inserir_sistema_painel(
    10.5,
    NOW(),
    25,
    'ATIVO'
);

CALL inserir_unidade_consumidora(
    'Ana Paula',
    'RESIDENCIAL',
    'Rua das Flores',
    '15',
    '71999999999',
    'ana@email.com',
    CURDATE(),
    1
);


-- =====================================================
-- TESTE: PROCEDURES UPDATE
-- =====================================================

CALL atualizar_status_sistema(1, 'MANUTENCAO');

CALL atualizar_unidade_consumidora(
    1,
    '71988888888',
    'novoemail@email.com'
);

CALL atualizar_contrato(
    1,
    5000.00,
    'ATIVO'
);

CALL atualizar_ultimo_login(
    1,
    NOW()
);