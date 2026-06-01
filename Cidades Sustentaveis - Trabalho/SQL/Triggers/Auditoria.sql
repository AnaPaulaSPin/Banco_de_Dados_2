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
        INSERT INTO auditoriaSistema
        (tabela, campo, valorAntigo, valorNovo, usuario, ip, dataHora)
        VALUES
        ('Contrato', 'valor', OLD.valor, NEW.valor, USER(), '127.0.0.1', NOW());
    END IF;
    IF OLD.status <> NEW.status THEN
        INSERT INTO auditoriaSistema
        (tabela, campo, valorAntigo, valorNovo, usuario, ip, dataHora)
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
        INSERT INTO auditoriaSistema
        (tabela, campo, valoAntigo, valorNovo, usuario, ip, dataHora)
        VALUES
        ('Usuario', 'status', OLD.status, NEW.status, USER(), '127.0.0.1', NOW());
    END IF;
END //
DELIMITER ;


