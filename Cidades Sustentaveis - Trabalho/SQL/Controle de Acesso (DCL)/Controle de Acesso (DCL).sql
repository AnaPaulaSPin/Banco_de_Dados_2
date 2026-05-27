-- =====================================================
-- CONTROLE DE ACESSO (DCL)
-- =====================================================

-- ---------------------------------------------------
-- Usuário 1: admin_solar
-- Perfil ADMIN — controle total do banco.
-- ---------------------------------------------------
CREATE USER 'admin_solar'@'localhost'
    IDENTIFIED BY 'Admin@Solar2026';
 
GRANT ALL PRIVILEGES
    ON SistemaEnergiaSolar.*
    TO 'admin_solar'@'localhost'
    WITH GRANT OPTION;
 
 
-- ---------------------------------------------------
-- Usuário 2: gestor_solar
-- Perfil GESTOR — leitura completa + execução.
-- Sem acesso à tabela de auditoria.
-- ---------------------------------------------------
CREATE USER 'gestor_solar'@'localhost'
    IDENTIFIED BY 'Gestor@Solar2026';
 
GRANT SELECT  ON SistemaEnergiaSolar.*  TO 'gestor_solar'@'localhost';
GRANT EXECUTE ON SistemaEnergiaSolar.*  TO 'gestor_solar'@'localhost';
 
REVOKE SELECT
    ON SistemaEnergiaSolar.auditoria_sistema
    FROM 'gestor_solar'@'localhost';
 
 
-- ---------------------------------------------------
-- Usuário 3: operador_solar
-- Perfil OPERADOR — usado pela API PyMySQL.
-- Leitura dos dados técnicos + inserção de medições
-- + execução de procedures e functions.
-- Sem acesso a contratos, usuários ou auditoria.
-- ---------------------------------------------------
CREATE USER 'operador_solar'@'localhost'
    IDENTIFIED BY 'Operador@Solar2026';
 
GRANT SELECT ON SistemaEnergiaSolar.Cidade              TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.Bairro              TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.SistemaPainel       TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.PainelSolar         TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.MedicaoEnergia      TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.UnidadeConsumidora  TO 'operador_solar'@'localhost';
 
GRANT INSERT ON SistemaEnergiaSolar.MedicaoEnergia      TO 'operador_solar'@'localhost';
 
GRANT SELECT ON SistemaEnergiaSolar.vw_desempenho_sistemas  TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.vw_alertas_manutencao   TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.vw_impacto_por_cidade   TO 'operador_solar'@'localhost';
GRANT SELECT ON SistemaEnergiaSolar.vw_contratos_ativos     TO 'operador_solar'@'localhost';
 
GRANT EXECUTE ON SistemaEnergiaSolar.* TO 'operador_solar'@'localhost';
 
 
FLUSH PRIVILEGES;