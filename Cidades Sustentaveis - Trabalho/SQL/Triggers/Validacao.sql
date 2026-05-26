-- =====================================================
-- TRIGGERS DE VALIDAÇÃO
-- =====================================================

-- VALIDAR SENHA (MINIMO 8) --
DELIMITER //
CREATE TRIGGER trg_usuario_senha_min
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.senha) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha deve ter no mínimo 8 caracteres';
    END IF;
END //
DELIMITER ;

-- VALIDAR EMAIL (incluir @gmail) --
DELIMITER //
CREATE TRIGGER trg_usuario_email
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email inválido: deve conter @gmail.com';
    END IF;
END //
DELIMITER ;

-- VALIDAR EMAIL DUPLICADO
DELIMITER //
CREATE TRIGGER trg_usuario_email_duplicado
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF exists(Select 1 from usuario where email = NEW.email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email já existe';
    END IF;
END //
DELIMITER ;


-- VALIDAR TELEFONE
DELIMITER //
CREATE TRIGGER trg_unidade_consumidora_telefone
BEFORE INSERT ON unidadeconsumidora
FOR EACH ROW
BEGIN
    IF NEW.telefone IS NULL OR CHAR_LENGTH(NEW.telefone) < 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Telefone incompleto (mínimo 11 dígitos)';
    END IF;
END //
DELIMITER ;

