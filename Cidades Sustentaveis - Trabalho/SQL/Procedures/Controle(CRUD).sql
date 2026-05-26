-- =====================================================
-- PROCEDURES DE CONTROLE (CRUD)
-- =====================================================

-- INSERIR --
DELIMITER //
CREATE PROCEDURE inserir_usuario(
    IN p_nome VARCHAR(45),
    IN p_email VARCHAR(45),
    IN p_senha VARCHAR(45),
    IN p_perfil ENUM('ADMIN','GESTOR','OPERADOR')
)
BEGIN
    IF EXISTS (SELECT 1 FROM Usuario WHERE email = p_email) THEN
        SELECT 'email já existe' AS mensagem;
    ELSE
        INSERT INTO Usuario (nome, email, senha, ultimoLogin, perfilAcesso, status)
        VALUES (p_nome, p_email, p_senha, NOW(), p_perfil, 'ATIVO');
    END IF;
END //
DELIMITER ;

-- ALTERAR --
DELIMITER //

CREATE PROCEDURE alterar_status_usuario(
    IN p_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Usuario
    SET status =
        CASE
            WHEN p_status IN ('ATIVO','INATIVO','SUSPENSO') THEN p_status
            ELSE status
        END
    WHERE idUsuario = p_id;
END //

DELIMITER ;

-- EXCLUIR --

DELIMITER //

CREATE PROCEDURE excluir_usuario(IN p_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM Usuario WHERE idUsuario = p_id) THEN
        UPDATE Usuario
        SET status = 'INATIVO'
        WHERE idUsuario = p_id;
    ELSE
        SELECT 'Usuário não encontrado' AS mensagem;
    END IF;
END //

DELIMITER ;


-- CONSULTAR --
DELIMITER //

CREATE PROCEDURE consultar_usuario(IN p_id INT)
BEGIN
    SELECT 
        idUsuario,
        nome,
        email,
        perfilAcesso,
        CASE 
            WHEN status = 'ATIVO' THEN 'Usuário ativo'
            WHEN status = 'SUSPENSO' THEN 'Usuário suspenso'
            WHEN status = 'INATIVO' THEN 'Usuário inativo'
        END AS situacao
    FROM Usuario
    WHERE idUsuario = p_id;
END //

DELIMITER ;