-- =====================================================
-- TRIGGERS DE AUDITORIA
-- =====================================================

-- SALVAR STATUS E VALOR DO CONTRATO --
DELIMITER //
CREATE TRIGGER trg_aud_contrato_status_valor
AFTER UPDATE ON Contrato
FOR EACH ROW
BEGIN
    IF OLD.valor <> NEW.valor THEN
        INSERT INTO auditoria_sistema
        (tabela, campo, valor_antigo, valor_novo, usuario, ip, data_hora)
        VALUES
        ('Contrato', 'valor', OLD.status, NEW.status, USER(), '127.0.0.1', NOW());
    END IF;
    IF OLD.status <> NEW.status THEN
        INSERT INTO auditoria_sistema
        (tabela, campo, valor_antigo, valor_novo, usuario, ip, data_hora)
        VALUES
        ('Contrato', 'status', OLD.status, NEW.status, USER(), '127.0.0.1', NOW());
    END IF;
END //
DELIMITER ;


-- SALVAR STATUS --
DELIMITER //
CREATE TRIGGER trg_aud_usuario_status
AFTER UPDATE ON Usuario
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO auditoria_sistema
        (tabela, campo, valor_antigo, valor_novo, usuario, ip, data_hora)
        VALUES
        ('Usuario', 'status', OLD.status, NEW.status, USER(), '127.0.0.1', NOW());
    END IF;
END //
DELIMITER ;


