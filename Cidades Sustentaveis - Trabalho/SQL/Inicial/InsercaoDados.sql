-- =====================================================
-- INSERÇÃO DE DADOS PARA TESTES
-- Banco: Gerenciamento de Energia Solar Urbana
-- =====================================================

-- =====================================================
-- CIDADE
-- =====================================================

INSERT INTO Cidade (nome) VALUES
('Salvador'),
('Lauro de Freitas'),
('Camaçari');

-- =====================================================
-- BAIRRO
-- =====================================================

INSERT INTO Bairro (nome, regiao, idCidade) VALUES
('Brotas', 'Centro', 1),
('Pituba', 'Orla', 1),
('Cajazeiras', 'Subúrbio', 1),
('Itapuã', 'Orla', 1),
('Centro', 'Centro', 2),
('Vilas do Atlântico', 'Orla', 2),
('Abrantes', 'Norte', 3),
('Centro', 'Centro', 3);

-- =====================================================
-- SISTEMA DE PAINÉIS
-- =====================================================

INSERT INTO SistemaPainel 
(capacidadeKwp, dataInstalacao, vidaUtilEstimada, status) VALUES
(5.50, '2023-02-10 09:00:00', 25, 'ATIVO'),
(8.20, '2022-08-15 10:30:00', 25, 'ATIVO'),
(12.00, '2024-01-20 14:00:00', 25, 'ATIVO'),
(4.80, '2021-05-05 08:45:00', 20, 'MANUTENCAO'),
(15.50, '2023-11-12 11:20:00', 25, 'ATIVO'),
(7.30, '2022-03-18 15:10:00', 25, 'INATIVO'),
(10.00, '2024-04-01 13:00:00', 25, 'ATIVO'),
(6.60, '2023-07-22 09:40:00', 25, 'ATIVO');

-- =====================================================
-- PAINEL SOLAR
-- =====================================================

INSERT INTO PainelSolar
(modelo, fabricante, potenciaWatts, eficiencia, dataFabricacao, status, idSistemaPainel) VALUES
('CS6W-550', 'Canadian Solar', 550, '21%', '2022-12-01', 'ATIVO', 1),
('CS6W-550', 'Canadian Solar', 550, '21%', '2022-12-01', 'ATIVO', 1),
('JAM72S30', 'JA Solar', 545, '20.8%', '2022-06-15', 'ATIVO', 2),
('JAM72S30', 'JA Solar', 545, '20.8%', '2022-06-15', 'ATIVO', 2),
('Hi-MO 5', 'LONGi', 540, '21.1%', '2023-09-10', 'ATIVO', 3),
('Hi-MO 5', 'LONGi', 540, '21.1%', '2023-09-10', 'ATIVO', 3),
('Tiger Pro', 'Jinko Solar', 535, '20.7%', '2021-03-05', 'MANUTENCAO', 4),
('Tiger Pro', 'Jinko Solar', 535, '20.7%', '2021-03-05', 'ATIVO', 4),
('Vertex S', 'Trina Solar', 500, '20.5%', '2023-08-22', 'ATIVO', 5),
('Vertex S', 'Trina Solar', 500, '20.5%', '2023-08-22', 'ATIVO', 5),
('SunPower Maxeon', 'SunPower', 430, '22%', '2022-01-12', 'INATIVO', 6),
('SunPower Maxeon', 'SunPower', 430, '22%', '2022-01-12', 'INATIVO', 6),
('AstroEnergy', 'Astronergy', 450, '20%', '2024-02-01', 'ATIVO', 7),
('AstroEnergy', 'Astronergy', 450, '20%', '2024-02-01', 'ATIVO', 7),
('Risen Titan', 'Risen Energy', 550, '21%', '2023-04-18', 'ATIVO', 8),
('Risen Titan', 'Risen Energy', 550, '21%', '2023-04-18', 'ATIVO', 8);

-- =====================================================
-- UNIDADE CONSUMIDORA
-- =====================================================

INSERT INTO UnidadeConsumidora
(nomeResponsavel, tipoUnidade, logradouro, numeroResidencia, telefone, email, dataCadastro, idBairro) VALUES
('Ana Maria Santos', 'RESIDENCIAL', 'Rua A', '120', '71999990001', 'ana@email.com', '2023-01-10', 1),
('Mercado Sol Nascente', 'COMERCIAL', 'Av B', '45', '71999990002', 'mercado@email.com', '2023-03-05', 2),
('Escola Municipal Verde', 'PUBLICA', 'Rua C', '300', '71999990003', 'escola@email.com', '2023-06-12', 3),
('Fábrica Bahia Energia', 'INDUSTRIAL', 'Av D', '800', '71999990004', 'fabrica@email.com', '2022-09-20', 4),
('Condomínio Solar Azul', 'RESIDENCIAL', 'Rua E', '22', '71999990005', 'condominio@email.com', '2024-01-15', 5),
('Hospital Vida Urbana', 'PUBLICA', 'Av F', '100', '71999990006', 'hospital@email.com', '2024-02-18', 6),
('Padaria Luz do Dia', 'COMERCIAL', 'Rua G', '77', '71999990007', 'padaria@email.com', '2023-11-30', 7),
('Centro Administrativo', 'PUBLICA', 'Av H', '500', '71999990008', 'admin@email.com', '2022-04-25', 8);

-- =====================================================
-- EMPRESA INSTALADORA
-- =====================================================

INSERT INTO EmpresaInstaladora
(razaoSocial, cnpj, email, logradouro, numeroResidencia) VALUES
('SolTech Energia LTDA', '12345678000190', 'contato@soltech.com', 'Rua Solar', '10'),
('Bahia Solar Instalações', '22345678000191', 'contato@bahiasolar.com', 'Av Luz', '200'),
('EcoVolt Engenharia', '32345678000192', 'contato@ecovolt.com', 'Rua Verde', '35'),
('Energia Limpa Brasil', '42345678000193', 'contato@energialimpa.com', 'Av Sol', '410');

-- =====================================================
-- MEDIÇÃO DE ENERGIA
-- =====================================================

INSERT INTO MedicaoEnergia
(dataMedicao, energiaGeradaKwh, energiaConsumidaKwh, energiaExcedenteKwh, economiaEstimada, co2EvitarKg, idSistemaPainel) VALUES
('2024-04-01', 120.5, 100.0, 20.5, 95.00, 55.2, 1),
('2024-04-02', 118.0, 110.0, 8.0, 88.00, 50.0, 1),
('2024-04-03', 130.2, 105.0, 25.2, 102.50, 60.1, 1),

('2024-04-01', 180.0, 150.0, 30.0, 140.00, 80.5, 2),
('2024-04-02', 175.5, 160.0, 15.5, 132.00, 76.0, 2),
('2024-04-03', 190.0, 155.0, 35.0, 150.00, 85.3, 2),

('2024-04-01', 260.0, 220.0, 40.0, 210.00, 120.0, 3),
('2024-04-02', 255.0, 230.0, 25.0, 198.00, 115.7, 3),
('2024-04-03', 270.0, 225.0, 45.0, 220.00, 125.4, 3),

('2024-04-01', 90.0, 95.0, 0.0, 60.00, 38.0, 4),
('2024-04-02', 85.0, 100.0, 0.0, 55.00, 35.5, 4),

('2024-04-01', 310.0, 260.0, 50.0, 250.00, 145.0, 5),
('2024-04-02', 320.0, 270.0, 50.0, 260.00, 150.0, 5),

('2024-04-01', 70.0, 90.0, 0.0, 45.00, 30.0, 6),

('2024-04-01', 210.0, 180.0, 30.0, 170.00, 98.0, 7),
('2024-04-02', 215.0, 185.0, 30.0, 175.00, 100.2, 7),

('2024-04-01', 150.0, 130.0, 20.0, 120.00, 70.0, 8),
('2024-04-02', 155.0, 140.0, 15.0, 125.00, 72.4, 8);

-- =====================================================
-- USUÁRIO
-- =====================================================

INSERT INTO Usuario
(nome, email, senha, ultimoLogin, perfilAcesso) VALUES
('Administrador Geral', 'admin@email.com', '123456', '2024-04-10 08:00:00', 'ADMIN'),
('Gestor Municipal', 'gestor@email.com', '123456', '2024-04-10 09:30:00', 'GESTOR'),
('Operador Sistema', 'operador@email.com', '123456', '2024-04-10 10:15:00', 'OPERADOR'),
('Analista Energia', 'analista@email.com', '123456', '2024-04-09 15:00:00', 'GESTOR');

-- =====================================================
-- CONTRATO
-- =====================================================

INSERT INTO Contrato
(numero, dataInicio, dataFim, valor, observacao, status,
 idUnidadeConsumidora, idSistemaPainel, idEmpresaInstaladora) VALUES
(1001, '2023-01-15', '2028-01-15', 25000.00, 'Instalação residencial', 'ATIVO', 1, 1, 1),
(1002, '2023-03-10', '2028-03-10', 38000.00, 'Instalação comercial', 'ATIVO', 2, 2, 2),
(1003, '2023-06-20', '2028-06-20', 60000.00, 'Projeto escola pública', 'ATIVO', 3, 3, 3),
(1004, '2022-09-25', '2027-09-25', 85000.00, 'Sistema industrial', 'SUSPENSO', 4, 4, 4),
(1005, '2024-01-20', '2029-01-20', 72000.00, 'Condomínio residencial', 'ATIVO', 5, 5, 1),
(1006, '2024-02-25', '2029-02-25', 90000.00, 'Hospital público', 'ATIVO', 6, 6, 2),
(1007, '2023-12-05', '2028-12-05', 32000.00, 'Comércio local', 'ATIVO', 7, 7, 3),
(1008, '2022-05-01', '2027-05-01', 55000.00, 'Prédio administrativo', 'ENCERRADO', 8, 8, 4);

-- =====================================================
-- UNIDADES CONSUMIDORAS ADICIONAIS
-- Mesmos bairros já cadastrados, para testar consultas por bairro
-- =====================================================
INSERT INTO UnidadeConsumidora
(nomeResponsavel, tipoUnidade, logradouro, numeroResidencia, telefone, email, dataCadastro, idBairro) VALUES
('João Silva', 'RESIDENCIAL', 'Rua A', '130', '71999990009', 'joao@email.com', '2024-03-01', 1),
('Maria Oliveira', 'RESIDENCIAL', 'Rua A', '145', '71999990010', 'maria@email.com', '2024-03-02', 1),
('Farmácia Popular Sol', 'COMERCIAL', 'Av B', '60', '71999990011', 'farmacia@email.com', '2024-03-05', 2),
('Creche Municipal Luz', 'PUBLICA', 'Rua C', '310', '71999990012', 'creche@email.com', '2024-03-08', 3);

-- =====================================================
-- PAINÉIS SOLARES ADICIONAIS EM MANUTENÇÃO
-- Para testar a consulta de painéis em manutenção
-- =====================================================
INSERT INTO PainelSolar
(modelo, fabricante, potenciaWatts, eficiencia, dataFabricacao, status, idSistemaPainel) VALUES
('Tiger Pro', 'Jinko Solar', 535, '20.7%', '2021-03-05', 'MANUTENCAO', 4),
('Vertex S', 'Trina Solar', 500, '20.5%', '2023-08-22', 'MANUTENCAO', 5),
('AstroEnergy', 'Astronergy', 450, '20%', '2024-02-01', 'MANUTENCAO', 7),
('Risen Titan', 'Risen Energy', 550, '21%', '2023-04-18', 'MANUTENCAO', 8);