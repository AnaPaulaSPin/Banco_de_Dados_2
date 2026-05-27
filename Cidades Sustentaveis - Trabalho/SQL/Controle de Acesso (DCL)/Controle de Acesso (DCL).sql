-- =====================================================
-- CONTROLE DE ACESSO (DCL)
-- =====================================================

-- 1. Criação do Usuário ADMINISTRADOR
CREATE USER 'admin_solar'@'localhost' IDENTIFIED BY 'AdminSolar@2026';
-- Permissão total no banco de dados
GRANT ALL PRIVILEGES ON SistemaEnergiaSolar.* TO 'admin_solar'@'localhost';

-- 2. Criação do Usuário GESTOR (Focado em Relatórios, Views e Funções)
CREATE USER 'gestor_solar'@'localhost' IDENTIFIED BY 'GestorSolar@2026';
-- Permissão de leitura em todas as tabelas e views
GRANT SELECT ON SistemaEnergiaSolar.* TO 'gestor_solar'@'localhost';
-- Permissão para executar procedures e funções
GRANT EXECUTE ON SistemaEnergiaSolar.* TO 'gestor_solar'@'localhost';

-- 3. Criação do Usuário OPERADOR (Aplicações operacionais e API de inserção)
CREATE USER 'operador_solar'@'localhost' IDENTIFIED BY 'OperadorSolar@2026';
-- Permissão de leitura no escopo geral
GRANT SELECT ON SistemaEnergiaSolar.* TO 'operador_solar'@'localhost';
-- Permissões de CRUD (sem DELETE, forçando exclusão lógica já mapeada nas procedures)
GRANT INSERT, UPDATE ON SistemaEnergiaSolar.MedicaoEnergia TO 'operador_solar'@'localhost';
GRANT INSERT, UPDATE ON SistemaEnergiaSolar.UnidadeConsumidora TO 'operador_solar'@'localhost';
GRANT INSERT, UPDATE ON SistemaEnergiaSolar.PainelSolar TO 'operador_solar'@'localhost';
GRANT INSERT, UPDATE ON SistemaEnergiaSolar.SistemaPainel TO 'operador_solar'@'localhost';
GRANT INSERT, UPDATE ON SistemaEnergiaSolar.Contrato TO 'operador_solar'@'localhost';

-- Aplica as definições de privilégios no servidor
FLUSH PRIVILEGES;